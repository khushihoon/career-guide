// ══════════════════════════════════════════════════════════════════════
// lib/services/copilot_controller.dart
//
// FIXES vs previous version:
//  1. Real CopilotAIService is called (not mock data)
//  2. Falls back to smart mock data only when API key is missing
//  3. init() guard fixed — won't block re-init after logout/login
//  4. rerunAnalysis() resets guard so re-analysis always works
//  5. Loading flag always cleared even on unexpected throws
//  6. Existing today goals are preserved (no re-generation if already exist)
// ══════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/copilot_models.dart';
import 'copilot_firestore_service.dart';
import 'copilot_ai_service.dart';
import 'achievement_service.dart';   // for awarding XP on goal completion
import '../models/achievement_models.dart'; // for awarding XP on goal completion
import '../models/quest_models.dart';       // for awarding XP on goal completion
import 'ai_memory_service.dart';     // for storing conversation history and context
import 'goal_content_database.dart';   // for fetching engaging goal descriptions and tips
import 'local_goal_generator_service.dart'; // for generating fallback goals without AI

class CopilotController extends ChangeNotifier {
  CopilotState _state = const CopilotState();
  CopilotState get state => _state;

  StreamSubscription<UserSkillProfile?>? _profileSub;
  StreamSubscription<PersonalizedRoadmap?>? _roadmapSub;
  StreamSubscription<List<DailyGoal>>? _goalsSub;
  StreamSubscription<List<ProgressEntry>>? _progressSub;

  String? _currentUid;

static bool get _hasApiKey => false; // Disable real API calls for now (set to true to enable with valid key)
  // ── Init (safe to call multiple times; re-inits if uid changes) ──────
  Future<void> init(String uid) async {
    // If same user already streaming, just ensure loading is off
    if (_currentUid == uid) {
      if (_state.isLoading) _set(_state.copyWith(isLoading: false));
      return;
    }

    _currentUid = uid;

    // Cancel any old streams
    await _cancelStreams();

    _set(_state.copyWith(isLoading: true, error: null));

    // Subscribe to real-time streams
    _profileSub = CopilotFirestoreService.skillProfileStream(uid).listen((p) async {
      _set(_state.copyWith(skillProfile: p));

      if (p !=null) {
        final existtingGoals =
            await CopilotFirestoreService.getTodayGoals(uid); 

        if (existtingGoals.isEmpty) {
         await _runAnalysis(p);
        }
      }
    });  

    _roadmapSub = CopilotFirestoreService.roadmapStream(uid).listen((r) {
      _set(_state.copyWith(roadmap: r));
    });

    _goalsSub = CopilotFirestoreService.todayGoalsStream(uid).listen((g) {
      _set(_state.copyWith(todayGoals: g));
    });

    _progressSub = CopilotFirestoreService.progressStream(uid).listen((h) {
      _set(_state.copyWith(progressHistory: h));
    });

    // One-shot: load skill gaps from Firestore
    try {
      final gaps = await CopilotFirestoreService.getSkillGaps(uid);
      _set(_state.copyWith(skillGaps: gaps, isLoading: false));
    } catch (e) {
      _set(_state.copyWith(isLoading: false, error: e.toString()));
    }

    // Safety: ensure loading clears after 800ms no matter what
    Future.delayed(const Duration(milliseconds: 800), () {
      if (_state.isLoading) _set(_state.copyWith(isLoading: false));
    });
  }

  // ── Save skill profile + trigger full AI analysis ────────────────────
  Future<void> saveSkillProfile(UserSkillProfile profile) async {
    _set(_state.copyWith(isLoading: true, error: null));
    try {
      await CopilotFirestoreService.saveSkillProfile(profile);
      _set(_state.copyWith(skillProfile: profile));
      await _runAnalysis(profile);
    } catch (e) {
      _set(_state.copyWith(isLoading: false, error: 'Save failed: $e'));
    }
  }

  // ── Re-run analysis on pull-to-refresh ───────────────────────────────
  Future<void> rerunAnalysis(String uid) async {
    final profile = _state.skillProfile;
    if (profile == null) return;
    _currentUid = uid; // allow re-analysis
    await _runAnalysis(profile);
  }

  // ── Toggle a daily goal completion ───────────────────────────────────
  Future<void> toggleGoal(String uid, DailyGoal goal) async {
    try {
      await CopilotFirestoreService.toggleGoalCompletion(uid, goal);
      // Sync progress entry with updated list (stream will also update UI)
      final updated = _state.todayGoals.map((g) {
        if (g.id == goal.id) {
          return DailyGoal(
            id: g.id,
            uid: g.uid,
            title: g.title,
            category: g.category,
            date: g.date,
            isCompleted: !g.isCompleted,
            xpReward: g.xpReward,
            linkedSkill: g.linkedSkill,
          );
        }
        return g;
      }).toList();
      await CopilotFirestoreService.syncTodayProgress(uid, updated);
    } catch (e) {
      debugPrint('toggleGoal error: $e');
    }
  }

  // ── Mark a roadmap phase complete ────────────────────────────────────
  Future<void> completePhase(String uid, int phaseIndex) async {
    try {
      await CopilotFirestoreService.completeRoadmapPhase(uid, phaseIndex);
      // Stream will auto-update roadmap UI
    } catch (e) {
      debugPrint('completePhase error: $e');
    }
  }

  // ══════════════════════════════════════════════════════════════════════
  // INTERNAL: Full AI analysis pipeline
  // ══════════════════════════════════════════════════════════════════════
  Future<void> _runAnalysis(UserSkillProfile profile) async {
    _set(_state.copyWith(isLoading: true, error: null));
    try {
      List<SkillGap> gaps;
      PersonalizedRoadmap roadmap;
      List<DailyGoal> goals;

      if (_hasApiKey) {
        // ── Real Claude AI path ──────────────────────────────────────
        debugPrint('🤖 CopilotController: Using real Claude API');

        gaps = await CopilotAIService.analyseSkillGaps(profile);
        await CopilotFirestoreService.saveSkillGaps(profile.uid, gaps);
        _set(_state.copyWith(skillGaps: gaps));

        roadmap = await CopilotAIService.generateRoadmap(profile, gaps);
        await CopilotFirestoreService.saveRoadmap(roadmap);
        _set(_state.copyWith(roadmap: roadmap));

        // Only generate goals if none exist for today
        final existingGoals =
            await CopilotFirestoreService.getTodayGoals(profile.uid);
        if (existingGoals.isEmpty) {
          goals = await CopilotAIService.generateDailyGoals(
              profile, roadmap, gaps);
          await CopilotFirestoreService.saveDailyGoals(profile.uid, goals);
          _set(_state.copyWith(todayGoals: goals));
        }
      } else {
        // ── Smart mock fallback (no API key) ─────────────────────────
        debugPrint(
            '⚠️  CopilotController: No API key — using mock data');

        gaps = _mockGapsFor(profile);
        await CopilotFirestoreService.saveSkillGaps(profile.uid, gaps);
        _set(_state.copyWith(skillGaps: gaps));

        roadmap = _mockRoadmapFor(profile);
        await CopilotFirestoreService.saveRoadmap(roadmap);
        _set(_state.copyWith(roadmap: roadmap));

        final existingGoals =
            await CopilotFirestoreService.getTodayGoals(profile.uid);
        if (existingGoals.isEmpty) {
          goals = await LocalGoalGeneratorService().generateAndSaveDailyGoals(
            uid: profile.uid,
            targetRole: profile.targetRole.label,
            currentSkills: profile.skills.map((s) => s.name).toList(),
            currentStreak: 0,
            currentLevel: 1,
            roadmapPhase:0, // could be dynamic based on progress
            existingGoals: existingGoals,
          );
          await CopilotFirestoreService.saveDailyGoals(profile.uid, goals);
          _set(_state.copyWith(todayGoals: goals));
        }
      }

      _set(_state.copyWith(isLoading: false));
    } catch (e) {
      debugPrint('❌ CopilotController _runAnalysis error: $e');
      _set(_state.copyWith(isLoading: false, error: 'Analysis failed: $e'));
    }
  }

  // ══════════════════════════════════════════════════════════════════════
  // MOCK DATA  (used when ANTHROPIC_API_KEY is not set)
  // Role-aware so it still feels relevant
  // ══════════════════════════════════════════════════════════════════════

  List<SkillGap> _mockGapsFor(UserSkillProfile profile) {
    final userSkillNames =
        profile.skills.map((s) => s.name.toLowerCase()).toSet();

    final allGaps = <SkillGap>[
      SkillGap(
        skillName: 'Python',
        requiredLevel: SkillLevel.advanced,
        currentLevel: _lvl(profile, 'Python'),
        priority: 1,
        reason: 'Core language for all AI/ML roles',
      ),
      SkillGap(
        skillName: 'Machine Learning',
        requiredLevel: SkillLevel.advanced,
        currentLevel: _lvl(profile, 'Machine Learning'),
        priority: 1,
        reason: 'Foundation skill for ${profile.targetRole.label}',
      ),
      SkillGap(
        skillName: 'Deep Learning',
        requiredLevel: SkillLevel.intermediate,
        currentLevel: _lvl(profile, 'Deep Learning'),
        priority: 1,
        reason: 'Essential for neural network applications',
      ),
      SkillGap(
        skillName: 'PyTorch',
        requiredLevel: SkillLevel.intermediate,
        currentLevel: _lvl(profile, 'PyTorch'),
        priority: 2,
        reason: 'Industry-standard deep learning framework',
      ),
      SkillGap(
        skillName: 'LLMs',
        requiredLevel: SkillLevel.intermediate,
        currentLevel: _lvl(profile, 'LLMs'),
        priority: 2,
        reason: 'Large language models are key in 2025',
      ),
      SkillGap(
        skillName: 'MLOps',
        requiredLevel: SkillLevel.beginner,
        currentLevel: _lvl(profile, 'MLOps'),
        priority: 3,
        reason: 'Deploying and monitoring ML models in production',
      ),
    ];

    // Only include gaps where skill is missing or below required level
    return allGaps.where((g) {
      final cur = g.currentLevel?.value ?? 0;
      return cur < g.requiredLevel.value;
    }).toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
  }

  SkillLevel? _lvl(UserSkillProfile profile, String skill) {
    try {
      return profile.skills
          .firstWhere((s) => s.name.toLowerCase() == skill.toLowerCase())
          .level;
    } catch (_) {
      return null;
    }
  }

  PersonalizedRoadmap _mockRoadmapFor(UserSkillProfile profile) {
    return PersonalizedRoadmap(
      uid: profile.uid,
      targetRole: profile.targetRole,
      currentPhaseIndex: 0,
      generatedAt: DateTime.now(),
      phases: [
        RoadmapPhase(
          phaseNumber: 0,
          title: 'Python & Math Foundations',
          description:
              'Build a solid Python base and understand the maths behind ML algorithms.',
          skills: ['Python', 'NumPy', 'Pandas', 'Linear Algebra', 'Statistics'],
          resources: [
            LearningResource(
              title: 'Python for Everybody',
              platform: 'Coursera',
              url: 'https://coursera.org/specializations/python',
              isFree: true,
              duration: '4 weeks',
              icon: '🐍',
            ),
            LearningResource(
              title: 'Mathematics for ML',
              platform: 'Coursera',
              url: 'https://coursera.org/specializations/mathematics-machine-learning',
              isFree: false,
              duration: '5 weeks',
              icon: '📐',
            ),
          ],
          estimatedDuration: '4 weeks',
          isUnlocked: true,
          isCompleted: false,
        ),
        RoadmapPhase(
          phaseNumber: 1,
          title: 'Machine Learning Core',
          description:
              'Master classic ML algorithms and learn to build, evaluate, and tune models.',
          skills: [
            'Machine Learning',
            'Scikit-learn',
            'Model Evaluation',
            'Feature Engineering'
          ],
          resources: [
            LearningResource(
              title: 'ML Specialization',
              platform: 'Coursera (Andrew Ng)',
              url: 'https://coursera.org/specializations/machine-learning-introduction',
              isFree: false,
              duration: '3 months',
              icon: '🧠',
            ),
            LearningResource(
              title: 'Kaggle ML Courses',
              platform: 'Kaggle',
              url: 'https://kaggle.com/learn',
              isFree: true,
              duration: '3 weeks',
              icon: '📊',
            ),
          ],
          estimatedDuration: '6 weeks',
          isUnlocked: false,
          isCompleted: false,
        ),
        RoadmapPhase(
          phaseNumber: 2,
          title: 'Deep Learning & Neural Networks',
          description:
              'Build and train neural networks using PyTorch for real-world tasks.',
          skills: ['Deep Learning', 'PyTorch', 'CNNs', 'RNNs', 'Transfer Learning'],
          resources: [
            LearningResource(
              title: 'Deep Learning Specialization',
              platform: 'DeepLearning.AI',
              url: 'https://coursera.org/specializations/deep-learning',
              isFree: false,
              duration: '4 months',
              icon: '⚡',
            ),
            LearningResource(
              title: 'Fast.ai Practical DL',
              platform: 'Fast.ai',
              url: 'https://course.fast.ai',
              isFree: true,
              duration: '7 weeks',
              icon: '🚀',
            ),
          ],
          estimatedDuration: '8 weeks',
          isUnlocked: false,
          isCompleted: false,
        ),
        RoadmapPhase(
          phaseNumber: 3,
          title: 'LLMs, NLP & Specialisation',
          description:
              'Dive into large language models, fine-tuning, and your chosen AI specialisation.',
          skills: ['LLMs', 'HuggingFace', 'LangChain', 'RAG', 'Prompt Engineering'],
          resources: [
            LearningResource(
              title: 'LLM Bootcamp',
              platform: 'Full Stack Deep Learning',
              url: 'https://fullstackdeeplearning.com/llm-bootcamp',
              isFree: true,
              duration: '4 weeks',
              icon: '🤖',
            ),
            LearningResource(
              title: 'HuggingFace NLP Course',
              platform: 'HuggingFace',
              url: 'https://huggingface.co/learn/nlp-course',
              isFree: true,
              duration: '5 weeks',
              icon: '🤗',
            ),
          ],
          estimatedDuration: '8 weeks',
          isUnlocked: false,
          isCompleted: false,
        ),
        RoadmapPhase(
          phaseNumber: 4,
          title: 'Portfolio, MLOps & Job Ready',
          description:
              'Build 3 portfolio projects, deploy models, and land your first ${profile.targetRole.label} role.',
          skills: ['MLOps', 'Docker', 'FastAPI', 'GitHub', 'System Design'],
          resources: [
            LearningResource(
              title: 'MLOps Zoomcamp',
              platform: 'DataTalks.Club',
              url: 'https://github.com/DataTalksClub/mlops-zoomcamp',
              isFree: true,
              duration: '6 weeks',
              icon: '🏗️',
            ),
            LearningResource(
              title: 'Build Your AI Portfolio',
              platform: 'YouTube',
              url: 'https://youtube.com/results?search_query=AI+ML+portfolio+projects',
              isFree: true,
              duration: '4 weeks',
              icon: '💼',
            ),
          ],
          estimatedDuration: '6 weeks',
          isUnlocked: false,
          isCompleted: false,
        ),
      ],
    );
  }

  List<DailyGoal> _mockGoalsFor(UserSkillProfile profile) {
    final today = DateTime.now();
    final dateKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final uid = profile.uid;

    return [
      DailyGoal(
        id: '${uid}_${dateKey}_0',
        uid: uid,
        title: 'Complete 1 Python exercise on HackerRank',
        category: GoalCategory.practice,
        date: dateKey,
        isCompleted: false,
        xpReward: 25,
        linkedSkill: 'Python',
      ),
      DailyGoal(
        id: '${uid}_${dateKey}_1',
        uid: uid,
        title: 'Watch Andrew Ng ML lecture (30 min)',
        category: GoalCategory.learning,
        date: dateKey,
        isCompleted: false,
        xpReward: 30,
        linkedSkill: 'Machine Learning',
      ),
      DailyGoal(
        id: '${uid}_${dateKey}_2',
        uid: uid,
        title: 'Read 1 AI paper abstract on Arxiv',
        category: GoalCategory.learning,
        date: dateKey,
        isCompleted: false,
        xpReward: 15,
        linkedSkill: 'LLMs',
      ),
      DailyGoal(
        id: '${uid}_${dateKey}_3',
        uid: uid,
        title: 'Update LinkedIn with latest skills',
        category: GoalCategory.networking,
        date: dateKey,
        isCompleted: false,
        xpReward: 20,
        linkedSkill: null,
      ),
    ];
  }

  // ── Helpers ─────────────────────────────────────────────────────────
  void _set(CopilotState s) {
    _state = s;
    notifyListeners();
  }

  Future<void> _cancelStreams() async {
    await _profileSub?.cancel();
    await _roadmapSub?.cancel();
    await _goalsSub?.cancel();
    await _progressSub?.cancel();
    _profileSub = null;
    _roadmapSub = null;
    _goalsSub = null;
    _progressSub = null;
  }

  @override
  void dispose() {
    _cancelStreams();
    super.dispose();
  }
}