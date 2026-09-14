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
//
// NEW (additive, offline, no paid API):
//  7. CopilotContext (Selected Career + Skills + Current + Historical
//     Progress) is loaded/maintained alongside the existing CopilotState.
//  8. A deterministic, rule-based Next-Best-Action / Recommendation /
//     Readiness engine runs entirely locally — no AI or network calls
//     beyond the same Firestore already in use.
//  9. Progress-recording hooks (lesson/project/job/interview) persist
//     permanent append-only history via CopilotFirestoreService and then
//     recompute readiness + actions + recommendations.
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

  // ── NEW: Copilot Context (Selected Career + Skills + Current +
  // Historical Progress). Purely additive — CopilotState above is
  // completely untouched and keeps working exactly as before for any
  // existing widget that only reads `state`. New/updated UI can read
  // `copilotContext` for the richer, evolving picture. ──────────────────
  CopilotContext? _copilotContext;
  CopilotContext? get copilotContext => _copilotContext;

  /// The career the Copilot's readiness/actions/recommendations are
  /// currently scoped to. Restored from Firestore on init(); updated by
  /// [selectCareer] or any of the `record*Completed` hooks below.
  String? _selectedCareerId;
  String? get selectedCareerId => _selectedCareerId;

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

    // NEW: restore a previously selected career (if any) so learning
    // progress and readiness stay tied to the right career across
    // sessions. Read-only — never resets or overwrites anything.
    try {
      final career = await CopilotFirestoreService.getCareerContext(uid);
      if (career != null) _selectedCareerId = career.careerId;
    } catch (_) {
      // Non-fatal: Copilot intelligence still works without a stored
      // career context; readiness/actions just won't be career-scoped yet.
    }

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

      // NEW: skill profile changed — recompute Copilot intelligence in
      // the background. refreshIntelligence() never throws, so this can
      // never turn into an unhandled stream error.
      unawaited(refreshIntelligence(uid));
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

    // NEW: one-shot initial intelligence refresh so readiness / next
    // actions / recommendations are available as soon as this screen
    // opens, even before any stream above has emitted yet.
    unawaited(refreshIntelligence(uid));

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

      // NEW: a completed goal changes daily progress — recompute
      // readiness/next-actions/recommendations in the background.
      unawaited(refreshIntelligence(uid));
    } catch (e) {
      debugPrint('toggleGoal error: $e');
    }
  }

  // ── Mark a roadmap phase complete ────────────────────────────────────
  Future<void> completePhase(String uid, int phaseIndex) async {
    try {
      await CopilotFirestoreService.completeRoadmapPhase(uid, phaseIndex);
      // Stream will auto-update roadmap UI

      // NEW: a completed roadmap phase changes readiness — recompute.
      unawaited(refreshIntelligence(uid));
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

        // NEW: fold in whatever Copilot context we already have (career +
        // real learning progress) so the mock gaps/roadmap are influenced
        // by the user's actual progress instead of being fully generic.
        // Falls back to the exact old generic behaviour when no context
        // has been loaded yet (context == null), so nothing regresses.
        gaps = _mockGapsFor(profile, context: _copilotContext);
        await CopilotFirestoreService.saveSkillGaps(profile.uid, gaps);
        _set(_state.copyWith(skillGaps: gaps));

        roadmap = _mockRoadmapFor(profile, context: _copilotContext);
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

  List<SkillGap> _mockGapsFor(UserSkillProfile profile, {CopilotContext? context}) {
    final userSkillNames =
        profile.skills.map((s) => s.name.toLowerCase()).toSet();

    // NEW: when the user hasn't explicitly logged a level for a skill,
    // infer a rough one from their real lesson-completion progress for
    // the selected career, so gaps shrink as they actually make progress
    // instead of staying static forever. Purely additive — if `context`
    // is null (e.g. first run, or callers that don't pass it) this
    // resolves to null for every skill, which is byte-for-byte the same
    // fallback behaviour as before this change.
    SkillLevel? inferredFallback(String skillName) {
      final p = context?.learningProgress.progress ?? 0.0;
      if (p <= 0) return null;
      if (p >= 0.75) return SkillLevel.advanced;
      if (p >= 0.4) return SkillLevel.intermediate;
      return SkillLevel.beginner;
    }

    final allGaps = <SkillGap>[
      SkillGap(
        skillName: 'Python',
        requiredLevel: SkillLevel.advanced,
        currentLevel: _lvl(profile, 'Python') ?? inferredFallback('Python'),
        priority: 1,
        reason: 'Core language for all AI/ML roles',
      ),
      SkillGap(
        skillName: 'Machine Learning',
        requiredLevel: SkillLevel.advanced,
        currentLevel: _lvl(profile, 'Machine Learning') ??
            inferredFallback('Machine Learning'),
        priority: 1,
        reason: 'Foundation skill for ${profile.targetRole.label}',
      ),
      SkillGap(
        skillName: 'Deep Learning',
        requiredLevel: SkillLevel.intermediate,
        currentLevel: _lvl(profile, 'Deep Learning') ??
            inferredFallback('Deep Learning'),
        priority: 1,
        reason: 'Essential for neural network applications',
      ),
      SkillGap(
        skillName: 'PyTorch',
        requiredLevel: SkillLevel.intermediate,
        currentLevel: _lvl(profile, 'PyTorch') ?? inferredFallback('PyTorch'),
        priority: 2,
        reason: 'Industry-standard deep learning framework',
      ),
      SkillGap(
        skillName: 'LLMs',
        requiredLevel: SkillLevel.intermediate,
        currentLevel: _lvl(profile, 'LLMs') ?? inferredFallback('LLMs'),
        priority: 2,
        reason: 'Large language models are key in 2025',
      ),
      SkillGap(
        skillName: 'MLOps',
        requiredLevel: SkillLevel.beginner,
        currentLevel: _lvl(profile, 'MLOps') ?? inferredFallback('MLOps'),
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

  PersonalizedRoadmap _mockRoadmapFor(UserSkillProfile profile, {CopilotContext? context}) {
    // NEW: derive completed/unlocked phase state from real learning
    // progress when available. `progress` defaults to 0.0 when `context`
    // is null (or has no learning progress yet), which reproduces the
    // exact original static values below (only phase 0 unlocked, nothing
    // completed) — so this is a strict superset of the old behaviour.
    final progress = context?.learningProgress.progress ?? 0.0;
    const totalPhases = 5;
    bool phaseCompleted(int phaseNumber) =>
        progress >= (phaseNumber + 1) / totalPhases;
    bool phaseUnlocked(int phaseNumber) =>
        phaseNumber == 0 || progress >= phaseNumber / totalPhases;
    final currentPhaseIndex =
        min(totalPhases - 1, (progress * totalPhases).floor());

    return PersonalizedRoadmap(
      uid: profile.uid,
      targetRole: profile.targetRole,
      currentPhaseIndex: currentPhaseIndex,
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
          isUnlocked: phaseUnlocked(0),
          isCompleted: phaseCompleted(0),
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
          isUnlocked: phaseUnlocked(1),
          isCompleted: phaseCompleted(1),
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
          isUnlocked: phaseUnlocked(2),
          isCompleted: phaseCompleted(2),
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
          isUnlocked: phaseUnlocked(3),
          isCompleted: phaseCompleted(3),
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
          isUnlocked: phaseUnlocked(4),
          isCompleted: phaseCompleted(4),
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

  // ══════════════════════════════════════════════════════════════════════
  // NEW: COPILOT INTELLIGENCE — deterministic, offline, rule-based.
  //
  // Uses ONLY data already aggregated by CopilotFirestoreService and the
  // existing local CopilotState — no AI/API calls, no new databases.
  // Every write below is append-only or a safe recompute of a derived
  // value (readiness); nothing here ever deletes or resets history.
  // ══════════════════════════════════════════════════════════════════════

  /// Loads the full [CopilotContext] (career + skills + current +
  /// historical progress), recomputes [CareerReadiness] deterministically,
  /// generates any genuinely-new [NextBestAction]s / [CopilotRecommendation]s
  /// (skipping ones that already exist so nothing is duplicated or reset),
  /// persists the new pieces, and updates local state.
  ///
  /// Safe to call as often as needed (init, after any progress change, or
  /// manually) — it never throws; failures are logged and result in the
  /// previous [copilotContext] being left untouched.
  Future<CopilotContext?> refreshIntelligence(String uid, {String? careerId}) async {
    try {
      final resolvedCareerId = careerId ?? _selectedCareerId;
      final context = await CopilotFirestoreService.getCopilotContext(
        uid,
        careerId: resolvedCareerId,
      );

      final readiness = _computeReadiness(context);

      final existingActionIds = context.nextActions.map((a) => a.id).toSet();
      final newActions = _generateNextActions(context, readiness)
          .where((a) => !existingActionIds.contains(a.id))
          .toList();

      final existingRecIds =
          context.recommendations.map((r) => r.id).toSet();
      final newRecs = _generateRecommendations(context, readiness)
          .where((r) => !existingRecIds.contains(r.id))
          .toList();

      // Persist: readiness is a derived snapshot (safe to overwrite on
      // every recompute). Actions/recommendations are only ever ADDED —
      // existing ones (including completed/dismissed ones) are left alone.
      await CopilotFirestoreService.saveCareerReadiness(uid, readiness);
      for (final action in newActions) {
        await CopilotFirestoreService.saveNextAction(uid, action);
      }
      for (final rec in newRecs) {
        await CopilotFirestoreService.saveRecommendation(uid, rec);
      }

      final updatedContext = context.copyWith(
        readiness: readiness,
        nextActions: [...context.nextActions, ...newActions],
        recommendations: [...context.recommendations, ...newRecs],
      );

      _copilotContext = updatedContext;
      notifyListeners();
      return updatedContext;
    } catch (e) {
      debugPrint('refreshIntelligence error: $e');
      return null;
    }
  }

  /// Records the user's selected career (persisted, never overwrites past
  /// career history since CareerContext itself is just "current
  /// selection" — per-career learning progress keeps its own permanent
  /// history in Firestore keyed by careerId regardless of which career is
  /// currently selected), then recomputes intelligence for it.
  Future<void> selectCareer(String uid, CareerContext career) async {
    try {
      await CopilotFirestoreService.saveCareerContext(uid, career);
      _selectedCareerId = career.careerId;
      await refreshIntelligence(uid, careerId: career.careerId);
    } catch (e) {
      debugPrint('selectCareer error: $e');
    }
  }

  /// Appends one completed lesson to permanent per-career history, then
  /// recomputes readiness/actions/recommendations.
  Future<void> recordLessonCompleted(
    String uid, {
    required String careerId,
    required String lessonId,
    int? totalLessons,
    String? currentLevelTitle,
  }) async {
    try {
      await CopilotFirestoreService.appendCompletedLesson(
        uid,
        careerId: careerId,
        lessonId: lessonId,
        totalLessons: totalLessons,
        currentLevelTitle: currentLevelTitle,
      );
      _selectedCareerId ??= careerId;
      await refreshIntelligence(uid, careerId: careerId);
    } catch (e) {
      debugPrint('recordLessonCompleted error: $e');
    }
  }

  /// Appends one completed project to permanent history, then recomputes.
  Future<void> recordProjectCompleted(
    String uid,
    String projectId, {
    int? totalProjects,
    String? currentProjectId,
  }) async {
    try {
      await CopilotFirestoreService.appendCompletedProject(
        uid,
        projectId,
        totalProjects: totalProjects,
        currentProjectId: currentProjectId,
      );
      await refreshIntelligence(uid);
    } catch (e) {
      debugPrint('recordProjectCompleted error: $e');
    }
  }

  /// Appends one applied job to permanent history, then recomputes.
  Future<void> recordJobApplied(String uid, String jobId) async {
    try {
      await CopilotFirestoreService.appendAppliedJob(uid, jobId);
      await refreshIntelligence(uid);
    } catch (e) {
      debugPrint('recordJobApplied error: $e');
    }
  }

  /// Appends one completed interview (with optional score) to permanent
  /// history, then recomputes.
  Future<void> recordInterviewCompleted(
    String uid,
    String interviewId, {
    double? score,
  }) async {
    try {
      await CopilotFirestoreService.appendCompletedInterview(
        uid,
        interviewId,
        score: score,
      );
      await refreshIntelligence(uid);
    } catch (e) {
      debugPrint('recordInterviewCompleted error: $e');
    }
  }

  /// Marks a Next Best Action as completed WITHOUT deleting it (it stays
  /// in the user's action history) and updates local state optimistically.
  Future<void> completeNextAction(String uid, String actionId) async {
    try {
      await CopilotFirestoreService.completeNextAction(uid, actionId);
      final ctx = _copilotContext;
      if (ctx != null) {
        final updatedActions = ctx.nextActions
            .map((a) => a.id == actionId ? a.copyWith(isCompleted: true) : a)
            .toList();
        _copilotContext = ctx.copyWith(nextActions: updatedActions);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('completeNextAction error: $e');
    }
  }

  /// Marks a recommendation as dismissed WITHOUT deleting it (it stays in
  /// the user's recommendation history) and updates local state
  /// optimistically.
  Future<void> dismissRecommendation(String uid, String recommendationId) async {
    try {
      await CopilotFirestoreService.dismissRecommendation(
          uid, recommendationId);
      final ctx = _copilotContext;
      if (ctx != null) {
        final updatedRecs = ctx.recommendations
            .map((r) =>
                r.id == recommendationId ? r.copyWith(isDismissed: true) : r)
            .toList();
        _copilotContext = ctx.copyWith(recommendations: updatedRecs);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('dismissRecommendation error: $e');
    }
  }

  // ── Rule engine (private, deterministic, no AI) ──────────────────────

  /// Deterministic readiness scoring from whatever progress data exists.
  /// Every dimension defaults to 0 when its underlying data is empty, so
  /// a brand-new user simply starts at 0 readiness rather than erroring.
  CareerReadiness _computeReadiness(CopilotContext context) {
    double skillReadiness;
    if (context.state.skillGaps.isEmpty) {
      skillReadiness = context.state.hasProfile ? 1.0 : 0.0;
    } else {
      final avgGap = context.state.skillGaps
              .map((g) => g.gapScore.clamp(0.0, 1.0))
              .fold<double>(0, (a, b) => a + b) /
          context.state.skillGaps.length;
      skillReadiness = (1 - avgGap).clamp(0.0, 1.0);
    }

    final learningReadiness = context.learningProgress.progress.clamp(0.0, 1.0);
    final projectReadiness = context.projectProgress.progress.clamp(0.0, 1.0);

    double interviewReadiness = 0.0;
    if (context.interviewProgress.mockInterviewsDone > 0) {
      interviewReadiness =
          (context.interviewProgress.averageScore / 100).clamp(0.0, 1.0);
    }

    final jobReadiness = ((skillReadiness * 0.3) +
            (learningReadiness * 0.3) +
            (projectReadiness * 0.2) +
            (interviewReadiness * 0.2))
        .clamp(0.0, 1.0);

    return CareerReadiness(
      skillReadiness: skillReadiness,
      learningReadiness: learningReadiness,
      projectReadiness: projectReadiness,
      interviewReadiness: interviewReadiness,
      jobReadiness: jobReadiness,
      computedAt: DateTime.now(),
    );
  }

  /// Deterministic Next-Best-Action rules. IDs are stable/semantic (e.g.
  /// `action_skill_python`) rather than random — this is the dedup
  /// mechanism: [refreshIntelligence] only persists actions whose id
  /// isn't already present in the user's action history, so calling this
  /// repeatedly never creates duplicate rows, and an action the user
  /// already completed under that id will not be silently resurrected
  /// with isCompleted reset to false.
  List<NextBestAction> _generateNextActions(
    CopilotContext context,
    CareerReadiness readiness,
  ) {
    final actions = <NextBestAction>[];
    final now = DateTime.now();
    final careerTitle = context.career?.careerTitle ??
        context.state.skillProfile?.targetRole.label ??
        'your career';

    // Rule 1: a critical (priority 1) skill gap → recommend skill practice.
    final criticalGaps =
        context.state.skillGaps.where((g) => g.priority == 1).toList();
    if (criticalGaps.isNotEmpty) {
      final gap = criticalGaps.first;
      final key = gap.skillName.toLowerCase().replaceAll(' ', '_');
      actions.add(NextBestAction(
        id: 'action_skill_$key',
        type: NextActionType.skillReview,
        title: 'Strengthen ${gap.skillName}',
        description: gap.reason,
        priority: 1,
        relatedSkill: gap.skillName,
        createdAt: now,
      ));
    }

    // Rule 2: learning not yet complete → recommend the next lesson.
    if (readiness.learningReadiness < 1.0) {
      final careerKey =
          context.learningProgress.careerId.isEmpty ? 'general' : context.learningProgress.careerId;
      actions.add(NextBestAction(
        id: 'action_continue_learning_$careerKey',
        type: NextActionType.lesson,
        title: context.learningProgress.completedCount == 0
            ? 'Start your $careerTitle path'
            : 'Continue your $careerTitle path',
        description: context.learningProgress.totalLessons > 0
            ? '${context.learningProgress.completedCount}/${context.learningProgress.totalLessons} lessons complete — keep going.'
            : 'Pick up where you left off in $careerTitle.',
        priority: 2,
        createdAt: now,
      ));
    }

    // Rule 3: decent learning progress but low project progress →
    // recommend building a project.
    if (readiness.learningReadiness >= 0.4 && readiness.projectReadiness < 0.6) {
      actions.add(NextBestAction(
        id: 'action_build_project',
        type: NextActionType.project,
        title: 'Build a portfolio project',
        description:
            "Apply what you've learned in $careerTitle to a real project.",
        priority: 2,
        createdAt: now,
      ));
    }

    // Rule 4: reasonably learned but interview-unready → recommend a
    // mock interview.
    if (readiness.learningReadiness >= 0.5 && readiness.interviewReadiness < 0.5) {
      actions.add(NextBestAction(
        id: 'action_mock_interview',
        type: NextActionType.interview,
        title: 'Practice a mock interview',
        description: 'Build interview confidence for $careerTitle roles.',
        priority: 2,
        createdAt: now,
      ));
    }

    // Rule 5: job-ready → recommend applying.
    if (readiness.jobReadiness >= 0.6) {
      actions.add(NextBestAction(
        id: 'action_apply_jobs',
        type: NextActionType.application,
        title: 'Apply to $careerTitle roles',
        description:
            "Your readiness score suggests you're ready to start applying.",
        priority: 1,
        createdAt: now,
      ));
    }

    // Rule 6: streak lost after prior activity → nudge to return.
    if (_state.currentStreak == 0 && context.state.progressHistory.isNotEmpty) {
      actions.add(NextBestAction(
        id: 'action_resume_streak',
        type: NextActionType.skillReview,
        title: 'Jump back in',
        description:
            "You've lost your streak — a few minutes today keeps you moving.",
        priority: 3,
        createdAt: now,
      ));
    }

    return actions;
  }

  /// Deterministic recommendation rules, mirroring the action rules above
  /// but framed as higher-level guidance. Same stable-id dedup strategy:
  /// [refreshIntelligence] never re-creates (and never un-dismisses) a
  /// recommendation whose id already exists in history.
  List<CopilotRecommendation> _generateRecommendations(
    CopilotContext context,
    CareerReadiness readiness,
  ) {
    final recs = <CopilotRecommendation>[];
    final now = DateTime.now();
    final careerTitle = context.career?.careerTitle ??
        context.state.skillProfile?.targetRole.label ??
        'your career';

    final criticalGaps =
        context.state.skillGaps.where((g) => g.priority == 1).toList();
    if (criticalGaps.isNotEmpty) {
      final first = criticalGaps.first;
      final names = criticalGaps.map((g) => g.skillName).join(', ');
      final key = first.skillName.toLowerCase().replaceAll(' ', '_');
      recs.add(CopilotRecommendation(
        id: 'rec_skill_gap_$key',
        category: RecommendationCategory.skillGap,
        title: 'Close your biggest skill gaps',
        description: 'Focus on $names — these matter most for $careerTitle.',
        priority: 1,
        createdAt: now,
      ));
    }

    if (readiness.learningReadiness < 0.5) {
      recs.add(CopilotRecommendation(
        id: 'rec_learning_path',
        category: RecommendationCategory.learningPath,
        title: 'Keep building your foundation',
        description:
            "You're ${(readiness.learningReadiness * 100).round()}% through the $careerTitle path.",
        priority: 2,
        createdAt: now,
      ));
    }

    if (readiness.learningReadiness >= 0.4 && readiness.projectReadiness < 0.5) {
      recs.add(CopilotRecommendation(
        id: 'rec_project',
        category: RecommendationCategory.project,
        title: 'Start a hands-on project',
        description: 'Projects turn lessons into proof for recruiters.',
        priority: 2,
        createdAt: now,
      ));
    }

    if (readiness.learningReadiness >= 0.5 && readiness.interviewReadiness < 0.5) {
      recs.add(CopilotRecommendation(
        id: 'rec_interview_prep',
        category: RecommendationCategory.interviewPrep,
        title: 'Prepare for interviews',
        description: 'Try a mock interview to see where you stand.',
        priority: 2,
        createdAt: now,
      ));
    }

    if (readiness.jobReadiness >= 0.6) {
      recs.add(CopilotRecommendation(
        id: 'rec_job_match',
        category: RecommendationCategory.jobMatch,
        title: "You're looking job-ready",
        description:
            'Consider applying to $careerTitle openings that match your skills.',
        priority: 1,
        createdAt: now,
      ));
    }

    if (_state.currentStreak == 0 && context.state.progressHistory.isNotEmpty) {
      recs.add(CopilotRecommendation(
        id: 'rec_streak_nudge',
        category: RecommendationCategory.streakNudge,
        title: "Don't lose momentum",
        description: 'A short session today restarts your streak.',
        priority: 3,
        createdAt: now,
      ));
    }

    return recs;
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