// ══════════════════════════════════════════════════════════════════════
// lib/services/copilot_controller.dart
//
// UPGRADE NOTES (this revision):
//   • Added ONE new public method — `recordCourseEvent` — that persists
//     a single course learning event (quiz answer / challenge answer /
//     project completion) via CopilotFirestoreService.recordCourseEvent,
//     then refreshes Copilot intelligence for that career so readiness,
//     next-best actions, and recommendations reflect the new evidence.
//   • In init(uid), when switching to a different user, the previous
//     _selectedCareerId is cleared before loading the new user's career
//     context. This prevents a stale career from leaking across users.
//     No Firestore history is deleted or modified by this.
//   • Everything else — public APIs, models, Firestore structure, the
//     offline/no-paid-API architecture, the career-aware skill and
//     roadmap tables, and all existing behaviour — is unchanged.
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
import 'reward_service.dart';        // for surprise rewards on goal completion
 

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

  // Existing RewardService — used only for surprise rewards after a
  // goal is completed. It persists its own XP; this controller never
  // adds surprise XP manually.
  final RewardService _rewardService = RewardService();

static bool get _hasApiKey => false; // Disable real API calls for now (set to true to enable with valid key)
  // ── Init (safe to call multiple times; re-inits if uid changes) ──────
  Future<void> init(String uid) async {
    // If same user already streaming, just ensure loading is off
    if (_currentUid == uid) {
      if (_state.isLoading) _set(_state.copyWith(isLoading: false));
      return;
    }

    // Switching to a different user — clear the previous user's career
    // scope so a stale career never leaks across users. This is an
    // in-memory reset only; no Firestore history is deleted or modified.
    if (_currentUid != null && _currentUid != uid) {
      _selectedCareerId = null;
      _copilotContext = null;
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

      // NEW: if this tap COMPLETED the goal (not un-completed it),
      // roll the existing surprise-reward chance via RewardService.
      // RewardService handles its own XP persistence, so we do NOT
      // touch totalXp here. Firestore's syncTodayProgress /
      // toggleGoalCompletion already handle normal goal XP, so this
      // path cannot double-award.
      final justCompleted = !goal.isCompleted; // previous state was incomplete
      if (justCompleted) {
        try {
          final surprise = await _rewardService.rollSurpriseReward(uid);
          if (surprise != null) {
            debugPrint(
              '🎁 Surprise reward: ${surprise.message} (+${surprise.xpAmount} XP)',
            );
          }
        } catch (e) {
          // Non-fatal — a surprise-reward failure must never break the
          // goal-completion flow.
          debugPrint('rollSurpriseReward error: $e');
        }
      }
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
  // Career-aware so it reflects what the user's selected career needs.
  // ══════════════════════════════════════════════════════════════════════

  /// Returns the required-skill spec for the user's selected career.
  ///
  /// Career resolution order (all offline, no AI):
  ///   1. CopilotContext.career.careerId (the actual selected career)
  ///   2. profile.targetRole (CareerGoal enum) — mapped to a career id
  ///   3. fallback to the AI Engineer spec so a brand-new user with an
  ///      unknown role still gets a meaningful, safe default.
  static List<_CareerSkill> _requiredSkillsFor(
    UserSkillProfile profile, {
    CopilotContext? context,
  }) {
    final careerId = context?.career?.careerId ?? '';

    // Try to match by career id first.
    final byId = _careerSkillSpecs[careerId];
    if (byId != null) return byId;

    // Then by the profile's target role.
    final byRole = _careerSkillSpecs[_careerIdForGoal(profile.targetRole)];
    if (byRole != null) return byRole;

    // Safe default — the user still gets career-relevant guidance.
    return _careerSkillSpecs['ai_engineer']!;
  }

  /// Maps a [CareerGoal] enum to the canonical career id used by the
  /// skill and roadmap spec tables.
  static String _careerIdForGoal(CareerGoal goal) {
    switch (goal) {
      case CareerGoal.aiEngineer:       return 'ai_engineer';
      case CareerGoal.mlEngineer:       return 'ml_engineer';
      case CareerGoal.dataScientist:    return 'data_scientist';
      case CareerGoal.nlpEngineer:      return 'llm_engineer';
      case CareerGoal.cvEngineer:       return 'cv_engineer';
      case CareerGoal.promptEngineer:   return 'prompt_engineer';
      case CareerGoal.aiResearcher:     return 'ai_researcher';
      case CareerGoal.aiProductManager: return 'ai_product_manager';
    }
  }

  /// Career-specific required-skill table.
  ///
  /// Each entry uses:
  ///   • name          — display name (also the matching key)
  ///   • required      — the target [SkillLevel] for that career
  ///   • priority      — 1=critical, 2=important, 3=nice-to-have
  ///   • reason        — why it matters for this specific career
  ///
  /// The table covers, at minimum: AI Engineer, ML Engineer,
  /// Data Scientist, LLM Engineer, Web Developer, Cyber Security,
  /// UI/UX Designer, plus additional nearby roles used elsewhere in the
  /// app.
  static final Map<String, List<_CareerSkill>> _careerSkillSpecs = {
    'ai_engineer': const [
      _CareerSkill('Python',            SkillLevel.advanced,     1, 'Core language for all AI/ML roles'),
      _CareerSkill('Machine Learning',  SkillLevel.advanced,     1, 'Foundation skill for AI Engineer'),
      _CareerSkill('Deep Learning',     SkillLevel.intermediate, 1, 'Essential for neural network applications'),
      _CareerSkill('PyTorch',           SkillLevel.intermediate, 2, 'Industry-standard deep learning framework'),
      _CareerSkill('LLMs',              SkillLevel.intermediate, 2, 'Large language models are key in 2025'),
      _CareerSkill('MLOps',             SkillLevel.beginner,     3, 'Deploying and monitoring ML models in production'),
    ],
    'ml_engineer': const [
      _CareerSkill('Python',            SkillLevel.advanced,     1, 'Core language for ML engineering'),
      _CareerSkill('Machine Learning',  SkillLevel.advanced,     1, 'Core skill for ML Engineer'),
      _CareerSkill('Deep Learning',     SkillLevel.advanced,     1, 'Neural networks are central to ML work'),
      _CareerSkill('PyTorch',           SkillLevel.advanced,     1, 'Primary framework for production models'),
      _CareerSkill('MLOps',             SkillLevel.intermediate, 2, 'Shipping and monitoring models in production'),
      _CareerSkill('System Design',     SkillLevel.intermediate, 3, 'Designing scalable training and serving pipelines'),
    ],
    'data_scientist': const [
      _CareerSkill('Python',            SkillLevel.advanced,     1, 'Primary language for data work'),
      _CareerSkill('SQL',               SkillLevel.advanced,     1, 'Querying data is a daily task'),
      _CareerSkill('Statistics',        SkillLevel.advanced,     1, 'Backbone of sound data analysis'),
      _CareerSkill('Machine Learning',  SkillLevel.intermediate, 2, 'Predictive modelling on real data'),
      _CareerSkill('Data Visualisation',SkillLevel.intermediate, 2, 'Communicating insights to stakeholders'),
      _CareerSkill('Feature Engineering',SkillLevel.intermediate,2, 'Turning raw data into useful signals'),
    ],
    'llm_engineer': const [
      _CareerSkill('Python',            SkillLevel.advanced,     1, 'Primary language for LLM pipelines'),
      _CareerSkill('LLMs',              SkillLevel.advanced,     1, 'Core subject of this career'),
      _CareerSkill('Prompt Engineering',SkillLevel.advanced,     1, 'Directly shapes model behaviour'),
      _CareerSkill('RAG',               SkillLevel.intermediate, 1, 'Retrieval-augmented generation is standard for production LLM apps'),
      _CareerSkill('Transformers',      SkillLevel.intermediate, 2, 'The architecture behind modern LLMs'),
      _CareerSkill('MLOps',             SkillLevel.beginner,     3, 'Serving and monitoring LLM services'),
    ],
    'web_developer': const [
      _CareerSkill('HTML',              SkillLevel.advanced,     1, 'Structure of every web page'),
      _CareerSkill('CSS',               SkillLevel.advanced,     1, 'Styling and layout are core to web work'),
      _CareerSkill('JavaScript',        SkillLevel.advanced,     1, 'Primary language of the web'),
      _CareerSkill('React',             SkillLevel.intermediate, 2, 'Most widely used UI framework'),
      _CareerSkill('Git',               SkillLevel.intermediate, 2, 'Version control on every project'),
      _CareerSkill('APIs',              SkillLevel.intermediate, 3, 'Connecting front-end to real data'),
    ],
    'frontend_dev': const [
      _CareerSkill('HTML',              SkillLevel.advanced,     1, 'Structure of every UI'),
      _CareerSkill('CSS',               SkillLevel.advanced,     1, 'Layout and styling mastery'),
      _CareerSkill('JavaScript',        SkillLevel.advanced,     1, 'Core language of the front-end'),
      _CareerSkill('React',             SkillLevel.advanced,     1, 'Most in-demand frontend framework'),
      _CareerSkill('APIs',              SkillLevel.intermediate, 2, 'Consuming backend services'),
      _CareerSkill('Git',               SkillLevel.intermediate, 3, 'Daily version-control workflow'),
    ],
    'cyber_security': const [
      _CareerSkill('Networking',        SkillLevel.advanced,     1, 'Every attack travels through a network'),
      _CareerSkill('Linux',             SkillLevel.advanced,     1, 'Primary OS for security work'),
      _CareerSkill('Security Fundamentals',SkillLevel.advanced, 1, 'Core concepts behind every defence'),
      _CareerSkill('Python',            SkillLevel.intermediate, 2, 'Automating security tasks and tooling'),
      _CareerSkill('Cryptography',      SkillLevel.intermediate, 2, 'Encryption, hashing and key management'),
      _CareerSkill('Penetration Testing',SkillLevel.beginner,    3, 'Ethical offensive security practice'),
    ],
    'ethical_hacker': const [
      _CareerSkill('Networking',        SkillLevel.advanced,     1, 'Traffic flows through networks you must understand'),
      _CareerSkill('Linux',             SkillLevel.advanced,     1, 'Most hacking tooling runs on Linux'),
      _CareerSkill('Security Fundamentals',SkillLevel.advanced, 1, 'Attack + defence fundamentals'),
      _CareerSkill('Penetration Testing',SkillLevel.intermediate,1, 'The core activity of the role'),
      _CareerSkill('Python',            SkillLevel.intermediate, 2, 'Scripting exploits and tools'),
      _CareerSkill('Cryptography',      SkillLevel.intermediate, 3, 'Understanding real-world crypto'),
    ],
    'ui_ux_designer': const [
      _CareerSkill('UX Fundamentals',   SkillLevel.advanced,     1, 'Foundation of every design decision'),
      _CareerSkill('UI Design',         SkillLevel.advanced,     1, 'Visual craft of the product'),
      _CareerSkill('Design Thinking',   SkillLevel.intermediate, 1, 'Human-centred problem solving'),
      _CareerSkill('Figma',             SkillLevel.intermediate, 2, 'Industry-standard design tool'),
      _CareerSkill('Prototyping',       SkillLevel.intermediate, 2, 'Testing ideas before building them'),
      _CareerSkill('Accessibility',     SkillLevel.beginner,     3, 'Designing for everyone, not just the median user'),
    ],
    'ux_designer': const [
      _CareerSkill('UX Fundamentals',   SkillLevel.advanced,     1, 'Foundation of every design decision'),
      _CareerSkill('UI Design',         SkillLevel.advanced,     1, 'Visual craft of the product'),
      _CareerSkill('Design Thinking',   SkillLevel.intermediate, 1, 'Human-centred problem solving'),
      _CareerSkill('Figma',             SkillLevel.intermediate, 2, 'Industry-standard design tool'),
      _CareerSkill('Prototyping',       SkillLevel.intermediate, 2, 'Testing ideas before building them'),
      _CareerSkill('Accessibility',     SkillLevel.beginner,     3, 'Designing for everyone'),
    ],
    'devops_engineer': const [
      _CareerSkill('Linux',             SkillLevel.advanced,     1, 'Foundation of every server'),
      _CareerSkill('Docker',            SkillLevel.advanced,     1, 'Packaging and shipping applications'),
      _CareerSkill('Kubernetes',        SkillLevel.intermediate, 1, 'Orchestrating containers in production'),
      _CareerSkill('Cloud Computing',   SkillLevel.intermediate, 2, 'Running workloads on real infrastructure'),
      _CareerSkill('CI/CD',             SkillLevel.intermediate, 2, 'Automating builds and deployments'),
      _CareerSkill('Networking',        SkillLevel.beginner,     3, 'Understanding how services talk to each other'),
    ],
    'qa_engineer': const [
      _CareerSkill('Software Testing Fundamentals', SkillLevel.advanced, 1, 'Core skill of the role'),
      _CareerSkill('Testing',           SkillLevel.advanced,     1, 'Writing and maintaining tests'),
      _CareerSkill('Python',            SkillLevel.intermediate, 2, 'Automation and scripting'),
      _CareerSkill('Git',               SkillLevel.intermediate, 2, 'Working with codebases and PRs'),
      _CareerSkill('APIs',              SkillLevel.intermediate, 3, 'Testing services end-to-end'),
      _CareerSkill('Debugging',         SkillLevel.beginner,     3, 'Root-causing failures quickly'),
    ],
    'blockchain_dev': const [
      _CareerSkill('Blockchain',        SkillLevel.advanced,     1, 'Core subject of the career'),
      _CareerSkill('Smart Contracts',   SkillLevel.intermediate, 1, 'The building blocks of dApps'),
      _CareerSkill('Solidity',          SkillLevel.intermediate, 2, 'Primary smart-contract language'),
      _CareerSkill('Cryptography',      SkillLevel.intermediate, 2, 'Underpins trust and immutability'),
      _CareerSkill('Security Fundamentals', SkillLevel.intermediate, 2, 'Smart-contract bugs are permanent'),
      _CareerSkill('JavaScript',        SkillLevel.beginner,     3, 'Front-end integration for dApps'),
    ],
    'solutions_architect': const [
      _CareerSkill('System Design',     SkillLevel.advanced,     1, 'The core skill of the role'),
      _CareerSkill('Architecture',      SkillLevel.advanced,     1, 'High-level component design'),
      _CareerSkill('Cloud Computing',   SkillLevel.intermediate, 2, 'Where most systems run today'),
      _CareerSkill('Databases',         SkillLevel.intermediate, 2, 'Choosing and designing storage'),
      _CareerSkill('Networking',        SkillLevel.intermediate, 3, 'How services communicate reliably'),
      _CareerSkill('Security Fundamentals', SkillLevel.beginner, 3, 'Designing systems that resist attack'),
    ],
  };

  /// Builds the missing-skill list for the user's selected career.
  ///
  /// Purely additive — if `context` is null (first run, older callers)
  /// this resolves the career purely from the profile's targetRole,
  /// which matches the old hard-coded default behaviour for AI Engineer
  /// while remaining correct for every other career the user might have
  /// picked.
  List<SkillGap> _mockGapsFor(UserSkillProfile profile, {CopilotContext? context}) {
    // NEW: use real lesson-completion progress when available to infer a
    // rough level for skills the user hasn't explicitly rated. Same
    // conservative mapping as before — never invents progress.
    SkillLevel? inferredFallback(String skillName) {
      final p = context?.learningProgress.progress ?? 0.0;
      if (p <= 0) return null;
      if (p >= 0.75) return SkillLevel.advanced;
      if (p >= 0.4) return SkillLevel.intermediate;
      return SkillLevel.beginner;
    }

    // Pick the required-skill spec for the user's actual career.
    final requiredSkills = _requiredSkillsFor(profile, context: context);

    // Only return the skills that are genuinely missing or below the
    // career-specific required level. Never fabricate a completed skill.
    final gaps = <SkillGap>[];
    for (final req in requiredSkills) {
      final current = _lvl(profile, req.name) ?? inferredFallback(req.name);
      final cur = current?.value ?? 0;
      if (cur < req.required.value) {
        gaps.add(SkillGap(
          skillName: req.name,
          requiredLevel: req.required,
          currentLevel: current,
          priority: req.priority,
          reason: req.reason,
        ));
      }
    }

    gaps.sort((a, b) => a.priority.compareTo(b.priority));
    return gaps;
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

  /// Career-aware roadmap builder.
  ///
  /// Uses the same career resolution order as [_requiredSkillsFor] so the
  /// roadmap always aligns with the career-specific skill table. The
  /// per-career phase specs are declared below in [_careerRoadmapSpecs].
  ///
  /// Progress-based unlock/completion logic is preserved exactly:
  ///   • progress 0.0 → phase 0 unlocked, nothing completed (old default)
  ///   • progress increases → phases unlock and complete proportionally
  /// Only the *content* of the roadmap now varies per career.
  PersonalizedRoadmap _mockRoadmapFor(UserSkillProfile profile, {CopilotContext? context}) {
    // Progress signal — unchanged from previous version.
    final progress = context?.learningProgress.progress ?? 0.0;

    // Resolve the career id the same way the skill-gap table does.
    final careerId = context?.career?.careerId ?? '';
    final spec = _careerRoadmapSpecs[careerId] ??
        _careerRoadmapSpecs[_careerIdForGoal(profile.targetRole)] ??
        _careerRoadmapSpecs['ai_engineer']!;

    // Unlock/completion math — identical to the previous version.
    final totalPhases = spec.phases.length;
    bool phaseCompleted(int phaseNumber) =>
        totalPhases == 0 ? false : progress >= (phaseNumber + 1) / totalPhases;
    bool phaseUnlocked(int phaseNumber) =>
        phaseNumber == 0 || (totalPhases > 0 && progress >= phaseNumber / totalPhases);
    final currentPhaseIndex =
        totalPhases == 0 ? 0 : min(totalPhases - 1, (progress * totalPhases).floor());

    // Build concrete RoadmapPhase objects from the career spec.
    final phases = <RoadmapPhase>[];
    for (var i = 0; i < spec.phases.length; i++) {
      final ps = spec.phases[i];
      phases.add(RoadmapPhase(
        phaseNumber: i,
        title: ps.title,
        description: ps.description,
        skills: ps.skills,
        resources: ps.resources
            .map((r) => LearningResource(
                  title: r.title,
                  platform: r.platform,
                  url: r.url,
                  isFree: r.isFree,
                  duration: r.duration,
                  icon: r.icon,
                ))
            .toList(),
        estimatedDuration: ps.estimatedDuration,
        isUnlocked: phaseUnlocked(i),
        isCompleted: phaseCompleted(i),
      ));
    }

    return PersonalizedRoadmap(
      uid: profile.uid,
      targetRole: profile.targetRole,
      currentPhaseIndex: currentPhaseIndex,
      generatedAt: DateTime.now(),
      phases: phases,
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

  /// Persists ONE course learning event (quiz answer / challenge answer /
  /// project completion) with idempotent XP award, then refreshes Copilot
  /// intelligence so Skill Gaps / Readiness / Next Best Actions reflect
  /// the new evidence.
  ///
  /// [eventId] must be stable and unique per event (e.g.
  /// `quiz:{courseId}:{index}`). Repeated calls with the same eventId are
  /// safe — the Firestore transaction awards XP at most once.
  ///
  /// The downstream evidence flow is:
  ///   Course event → copilot_learning_progress (append-only event id +
  ///   evidence trail + XP) → refreshIntelligence() → readiness recompute
  ///   → next-best-action regeneration → recommendation regeneration.
  ///
  /// Errors are logged and rethrown so the caller (the course screen) can
  /// present a retryable failure state instead of a false success.
  Future<void> recordCourseEvent(
    String uid, {
    required String careerId,
    required String eventId,
    required int xpReward,
  }) async {
    final effectiveCareerId =
        careerId.isNotEmpty ? careerId : (_selectedCareerId ?? '');
    if (effectiveCareerId.isEmpty || eventId.isEmpty) return;

    try {
      await CopilotFirestoreService.recordCourseEvent(
        uid,
        careerId: effectiveCareerId,
        eventId: eventId,
        xpReward: xpReward,
      );
      _selectedCareerId ??= effectiveCareerId;
      await refreshIntelligence(uid, careerId: effectiveCareerId);
    } catch (e) {
      debugPrint('recordCourseEvent error: $e');
      rethrow;
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

// ── Career-aware required-skill spec ───────────────────────────────────
//
// Tiny immutable value type used only inside CopilotController to
// describe one required skill for a career. Kept private to this file so
// it does not touch the public model layer.

class _CareerSkill {
  final String name;
  final SkillLevel required;
  final int priority; // 1 = critical, 2 = important, 3 = nice-to-have
  final String reason;

  const _CareerSkill(this.name, this.required, this.priority, this.reason);
}

// ── Career-aware roadmap spec ──────────────────────────────────────────
//
// Private, immutable content used only to build the mock roadmap. Each
// entry describes the ordered phases for one career. Skills in each
// phase align with the career-specific skill table above, so the roadmap
// and the gap analysis always tell the user the same story.

class _CareerRoadmapSpec {
  final List<_RoadmapPhaseSpec> phases;
  const _CareerRoadmapSpec(this.phases);
}

class _RoadmapPhaseSpec {
  final String title;
  final String description;
  final List<String> skills;
  final List<_RoadmapResourceSpec> resources;
  final String estimatedDuration;
  const _RoadmapPhaseSpec({
    required this.title,
    required this.description,
    required this.skills,
    required this.resources,
    required this.estimatedDuration,
  });
}

class _RoadmapResourceSpec {
  final String title;
  final String platform;
  final String url;
  final bool isFree;
  final String duration;
  final String icon;
  const _RoadmapResourceSpec({
    required this.title,
    required this.platform,
    required this.url,
    required this.isFree,
    required this.duration,
    required this.icon,
  });
}

/// Career-specific roadmap table. Keyed by the same canonical career ids
/// used by [_careerSkillSpecs]. Falls back to AI Engineer when the career
/// is unknown so a brand-new user still gets a meaningful roadmap.
final Map<String, _CareerRoadmapSpec> _careerRoadmapSpecs = {
  // ── AI Engineer ─────────────────────────────────────────────────────
  'ai_engineer': const _CareerRoadmapSpec([
    _RoadmapPhaseSpec(
      title: 'Python & Math Foundations',
      description:
          'Build a solid Python base and understand the maths behind ML algorithms.',
      skills: ['Python', 'NumPy', 'Pandas', 'Linear Algebra', 'Statistics'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Python for Everybody',
          platform: 'Coursera',
          url: 'https://coursera.org/specializations/python',
          isFree: true,
          duration: '4 weeks',
          icon: '🐍',
        ),
        _RoadmapResourceSpec(
          title: 'Mathematics for ML',
          platform: 'Coursera',
          url: 'https://coursera.org/specializations/mathematics-machine-learning',
          isFree: false,
          duration: '5 weeks',
          icon: '📐',
        ),
      ],
      estimatedDuration: '4 weeks',
    ),
    _RoadmapPhaseSpec(
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
        _RoadmapResourceSpec(
          title: 'ML Specialization',
          platform: 'Coursera (Andrew Ng)',
          url: 'https://coursera.org/specializations/machine-learning-introduction',
          isFree: false,
          duration: '3 months',
          icon: '🧠',
        ),
        _RoadmapResourceSpec(
          title: 'Kaggle ML Courses',
          platform: 'Kaggle',
          url: 'https://kaggle.com/learn',
          isFree: true,
          duration: '3 weeks',
          icon: '📊',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Deep Learning & Neural Networks',
      description:
          'Build and train neural networks using PyTorch for real-world tasks.',
      skills: ['Deep Learning', 'PyTorch', 'CNNs', 'RNNs', 'Transfer Learning'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Deep Learning Specialization',
          platform: 'DeepLearning.AI',
          url: 'https://coursera.org/specializations/deep-learning',
          isFree: false,
          duration: '4 months',
          icon: '⚡',
        ),
        _RoadmapResourceSpec(
          title: 'Fast.ai Practical DL',
          platform: 'Fast.ai',
          url: 'https://course.fast.ai',
          isFree: true,
          duration: '7 weeks',
          icon: '🚀',
        ),
      ],
      estimatedDuration: '8 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'LLMs, NLP & Specialisation',
      description:
          'Dive into large language models, fine-tuning, and your chosen AI specialisation.',
      skills: ['LLMs', 'HuggingFace', 'LangChain', 'RAG', 'Prompt Engineering'],
      resources: [
        _RoadmapResourceSpec(
          title: 'LLM Bootcamp',
          platform: 'Full Stack Deep Learning',
          url: 'https://fullstackdeeplearning.com/llm-bootcamp',
          isFree: true,
          duration: '4 weeks',
          icon: '🤖',
        ),
        _RoadmapResourceSpec(
          title: 'HuggingFace NLP Course',
          platform: 'HuggingFace',
          url: 'https://huggingface.co/learn/nlp-course',
          isFree: true,
          duration: '5 weeks',
          icon: '🤗',
        ),
      ],
      estimatedDuration: '8 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Portfolio, MLOps & Job Ready',
      description:
          'Build 3 portfolio projects, deploy models, and land your first AI Engineer role.',
      skills: ['MLOps', 'Docker', 'FastAPI', 'GitHub', 'System Design'],
      resources: [
        _RoadmapResourceSpec(
          title: 'MLOps Zoomcamp',
          platform: 'DataTalks.Club',
          url: 'https://github.com/DataTalksClub/mlops-zoomcamp',
          isFree: true,
          duration: '6 weeks',
          icon: '🏗️',
        ),
        _RoadmapResourceSpec(
          title: 'Build Your AI Portfolio',
          platform: 'YouTube',
          url: 'https://youtube.com/results?search_query=AI+ML+portfolio+projects',
          isFree: true,
          duration: '4 weeks',
          icon: '💼',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
  ]),

  // ── ML Engineer ─────────────────────────────────────────────────────
  'ml_engineer': const _CareerRoadmapSpec([
    _RoadmapPhaseSpec(
      title: 'Python & Engineering Foundations',
      description:
          'Sharpen Python, version control, and the engineering habits that ML work depends on.',
      skills: ['Python', 'Git', 'Testing', 'Linux Basics'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Python for Engineers',
          platform: 'Coursera',
          url: 'https://coursera.org/specializations/python',
          isFree: true,
          duration: '4 weeks',
          icon: '🐍',
        ),
        _RoadmapResourceSpec(
          title: 'Git & GitHub Crash Course',
          platform: 'YouTube',
          url: 'https://youtube.com/results?search_query=git+github+crash+course',
          isFree: true,
          duration: '1 week',
          icon: '📦',
        ),
      ],
      estimatedDuration: '4 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Machine Learning in Production',
      description:
          'Classic ML algorithms plus the model-evaluation and feature-engineering rigour production teams expect.',
      skills: ['Machine Learning', 'Model Evaluation', 'Feature Engineering', 'Scikit-learn'],
      resources: [
        _RoadmapResourceSpec(
          title: 'ML Specialization',
          platform: 'Coursera (Andrew Ng)',
          url: 'https://coursera.org/specializations/machine-learning-introduction',
          isFree: false,
          duration: '3 months',
          icon: '🧠',
        ),
        _RoadmapResourceSpec(
          title: 'Kaggle ML Courses',
          platform: 'Kaggle',
          url: 'https://kaggle.com/learn',
          isFree: true,
          duration: '3 weeks',
          icon: '📊',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Deep Learning Frameworks',
      description:
          'Master PyTorch and the neural-network architectures used across industry.',
      skills: ['Deep Learning', 'PyTorch', 'CNNs', 'RNNs', 'Transfer Learning'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Deep Learning Specialization',
          platform: 'DeepLearning.AI',
          url: 'https://coursera.org/specializations/deep-learning',
          isFree: false,
          duration: '4 months',
          icon: '⚡',
        ),
        _RoadmapResourceSpec(
          title: 'PyTorch Official Tutorials',
          platform: 'PyTorch',
          url: 'https://pytorch.org/tutorials/',
          isFree: true,
          duration: '4 weeks',
          icon: '🔥',
        ),
      ],
      estimatedDuration: '8 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'MLOps & Production Systems',
      description:
          'Ship models reliably — pipelines, monitoring, versioning, and scalable serving.',
      skills: ['MLOps', 'System Design', 'Docker', 'FastAPI', 'Monitoring'],
      resources: [
        _RoadmapResourceSpec(
          title: 'MLOps Zoomcamp',
          platform: 'DataTalks.Club',
          url: 'https://github.com/DataTalksClub/mlops-zoomcamp',
          isFree: true,
          duration: '6 weeks',
          icon: '🏗️',
        ),
        _RoadmapResourceSpec(
          title: 'Designing Machine Learning Systems',
          platform: 'O\'Reilly (Book)',
          url: 'https://www.oreilly.com/library/view/designing-machine-learning/9781098107956/',
          isFree: false,
          duration: '5 weeks',
          icon: '📘',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Portfolio & Job Ready',
      description:
          'Turn your ML skills into a portfolio of shipped, deployed projects recruiters can see.',
      skills: ['Portfolio', 'GitHub', 'Interview Prep'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Build an ML Portfolio',
          platform: 'YouTube',
          url: 'https://youtube.com/results?search_query=machine+learning+portfolio',
          isFree: true,
          duration: '3 weeks',
          icon: '💼',
        ),
      ],
      estimatedDuration: '3 weeks',
    ),
  ]),

  // ── Data Scientist ──────────────────────────────────────────────────
  'data_scientist': const _CareerRoadmapSpec([
    _RoadmapPhaseSpec(
      title: 'Python, SQL & Statistics',
      description:
          'The analytical toolkit every data scientist uses daily.',
      skills: ['Python', 'SQL', 'Statistics', 'Pandas', 'NumPy'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Python for Data Science',
          platform: 'Coursera',
          url: 'https://coursera.org/specializations/python',
          isFree: true,
          duration: '4 weeks',
          icon: '🐍',
        ),
        _RoadmapResourceSpec(
          title: 'SQL for Data Science',
          platform: 'Coursera',
          url: 'https://coursera.org/learn/sql-for-data-science',
          isFree: false,
          duration: '3 weeks',
          icon: '🗄️',
        ),
      ],
      estimatedDuration: '5 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Data Wrangling & Visualisation',
      description:
          'Clean real datasets and turn them into stories stakeholders understand.',
      skills: ['Data Cleaning', 'Feature Engineering', 'Data Visualisation', 'Matplotlib'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Data Analysis with Python',
          platform: 'freeCodeCamp',
          url: 'https://www.freecodecamp.org/learn/data-analysis-with-python/',
          isFree: true,
          duration: '4 weeks',
          icon: '📊',
        ),
      ],
      estimatedDuration: '4 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Machine Learning for Analysts',
      description:
          'Apply ML to real business problems and evaluate models honestly.',
      skills: ['Machine Learning', 'Model Evaluation', 'Scikit-learn', 'Kaggle'],
      resources: [
        _RoadmapResourceSpec(
          title: 'ML Specialization',
          platform: 'Coursera (Andrew Ng)',
          url: 'https://coursera.org/specializations/machine-learning-introduction',
          isFree: false,
          duration: '3 months',
          icon: '🧠',
        ),
        _RoadmapResourceSpec(
          title: 'Kaggle Competitions',
          platform: 'Kaggle',
          url: 'https://kaggle.com/competitions',
          isFree: true,
          duration: '4 weeks',
          icon: '🏆',
        ),
      ],
      estimatedDuration: '8 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Case Studies & Portfolio',
      description:
          'Package real analyses into portfolio-ready case studies that get interviews.',
      skills: ['Portfolio', 'Storytelling', 'Dashboards'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Data Science Portfolio Guide',
          platform: 'YouTube',
          url: 'https://youtube.com/results?search_query=data+science+portfolio',
          isFree: true,
          duration: '3 weeks',
          icon: '💼',
        ),
      ],
      estimatedDuration: '3 weeks',
    ),
  ]),

  // ── LLM Engineer ────────────────────────────────────────────────────
  'llm_engineer': const _CareerRoadmapSpec([
    _RoadmapPhaseSpec(
      title: 'Python & Transformer Foundations',
      description:
          'Everything needed to read and reason about modern language models.',
      skills: ['Python', 'Transformers', 'Tokenization', 'Attention'],
      resources: [
        _RoadmapResourceSpec(
          title: 'HuggingFace NLP Course',
          platform: 'HuggingFace',
          url: 'https://huggingface.co/learn/nlp-course',
          isFree: true,
          duration: '5 weeks',
          icon: '🤗',
        ),
      ],
      estimatedDuration: '4 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Prompt Engineering & Evaluation',
      description:
          'Design prompts that reliably produce the outputs you want, and measure them.',
      skills: ['Prompt Engineering', 'Evaluation', 'Few-shot Learning'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Prompt Engineering Guide',
          platform: 'Prompting Guide',
          url: 'https://www.promptingguide.ai',
          isFree: true,
          duration: '3 weeks',
          icon: '✍️',
        ),
      ],
      estimatedDuration: '3 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'RAG & LLM Applications',
      description:
          'Ground LLMs in real data using retrieval-augmented generation.',
      skills: ['RAG', 'Vector Databases', 'LangChain', 'LLMs'],
      resources: [
        _RoadmapResourceSpec(
          title: 'LLM Bootcamp',
          platform: 'Full Stack Deep Learning',
          url: 'https://fullstackdeeplearning.com/llm-bootcamp',
          isFree: true,
          duration: '4 weeks',
          icon: '🤖',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Serving, MLOps & Portfolio',
      description:
          'Ship production LLM services and turn them into portfolio proof.',
      skills: ['MLOps', 'Serving', 'Portfolio', 'System Design'],
      resources: [
        _RoadmapResourceSpec(
          title: 'MLOps Zoomcamp',
          platform: 'DataTalks.Club',
          url: 'https://github.com/DataTalksClub/mlops-zoomcamp',
          isFree: true,
          duration: '6 weeks',
          icon: '🏗️',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
  ]),

  // ── Web Developer / Frontend ───────────────────────────────────────
  'web_developer': const _CareerRoadmapSpec([
    _RoadmapPhaseSpec(
      title: 'Web Foundations',
      description:
          'The three pillars every web page is built on.',
      skills: ['HTML', 'CSS', 'JavaScript', 'Git'],
      resources: [
        _RoadmapResourceSpec(
          title: 'The Odin Project — Foundations',
          platform: 'The Odin Project',
          url: 'https://www.theodinproject.com/paths/foundations/courses/foundations',
          isFree: true,
          duration: '4 weeks',
          icon: '🌐',
        ),
        _RoadmapResourceSpec(
          title: 'freeCodeCamp Responsive Web Design',
          platform: 'freeCodeCamp',
          url: 'https://www.freecodecamp.org/learn/2022/responsive-web-design/',
          isFree: true,
          duration: '6 weeks',
          icon: '🎨',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Modern JavaScript & DOM',
      description:
          'Master ES6+, async patterns, and building interactive UIs.',
      skills: ['JavaScript', 'DOM', 'Fetch API', 'Async/Await'],
      resources: [
        _RoadmapResourceSpec(
          title: 'JavaScript.info',
          platform: 'JavaScript.info',
          url: 'https://javascript.info',
          isFree: true,
          duration: '5 weeks',
          icon: '📜',
        ),
      ],
      estimatedDuration: '5 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Frontend Frameworks',
      description:
          'Build real apps with React and understand component thinking.',
      skills: ['React', 'Components', 'State Management', 'React Router'],
      resources: [
        _RoadmapResourceSpec(
          title: 'React Official Tutorial',
          platform: 'React',
          url: 'https://react.dev/learn',
          isFree: true,
          duration: '4 weeks',
          icon: '⚛️',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'APIs, Deployment & Portfolio',
      description:
          'Connect to real backends, ship to the web, and build a portfolio.',
      skills: ['APIs', 'Deployment', 'GitHub Pages', 'Portfolio'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Full Stack Open — Part 0–3',
          platform: 'University of Helsinki',
          url: 'https://fullstackopen.com/en/',
          isFree: true,
          duration: '6 weeks',
          icon: '🚀',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
  ]),
  'frontend_dev': const _CareerRoadmapSpec([
    _RoadmapPhaseSpec(
      title: 'Web Foundations',
      description:
          'Structure, style and behaviour of every web page.',
      skills: ['HTML', 'CSS', 'JavaScript', 'Git'],
      resources: [
        _RoadmapResourceSpec(
          title: 'The Odin Project — Foundations',
          platform: 'The Odin Project',
          url: 'https://www.theodinproject.com/paths/foundations/courses/foundations',
          isFree: true,
          duration: '4 weeks',
          icon: '🌐',
        ),
      ],
      estimatedDuration: '5 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Modern JavaScript & DOM',
      description:
          'ES6+, DOM APIs, and the interactive patterns behind real UIs.',
      skills: ['JavaScript', 'DOM', 'Fetch API', 'Async/Await'],
      resources: [
        _RoadmapResourceSpec(
          title: 'JavaScript.info',
          platform: 'JavaScript.info',
          url: 'https://javascript.info',
          isFree: true,
          duration: '5 weeks',
          icon: '📜',
        ),
      ],
      estimatedDuration: '5 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'React & Frontend Frameworks',
      description:
          'Components, state and routing in production-grade frontends.',
      skills: ['React', 'Components', 'State Management'],
      resources: [
        _RoadmapResourceSpec(
          title: 'React Official Tutorial',
          platform: 'React',
          url: 'https://react.dev/learn',
          isFree: true,
          duration: '4 weeks',
          icon: '⚛️',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'APIs, Testing & Portfolio',
      description:
          'Wire up real backends, write tests, and publish a portfolio.',
      skills: ['APIs', 'Testing', 'Portfolio'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Full Stack Open — Part 0–3',
          platform: 'University of Helsinki',
          url: 'https://fullstackopen.com/en/',
          isFree: true,
          duration: '6 weeks',
          icon: '🚀',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
  ]),

  // ── Cyber Security / Ethical Hacker ────────────────────────────────
  'cyber_security': const _CareerRoadmapSpec([
    _RoadmapPhaseSpec(
      title: 'Networking & Linux Foundations',
      description:
          'The two things every security professional must know cold.',
      skills: ['Networking', 'Linux', 'TCP/IP', 'Command Line'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Networking Basics',
          platform: 'Cisco NetAcad',
          url: 'https://www.netacad.com/courses/networking',
          isFree: true,
          duration: '5 weeks',
          icon: '🌐',
        ),
        _RoadmapResourceSpec(
          title: 'Linux Journey',
          platform: 'Linux Journey',
          url: 'https://linuxjourney.com',
          isFree: true,
          duration: '3 weeks',
          icon: '🐧',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Security Fundamentals',
      description:
          'Core concepts: authentication, encryption, hashing, secure design.',
      skills: ['Security Fundamentals', 'Cryptography', 'Authentication', 'Authorization'],
      resources: [
        _RoadmapResourceSpec(
          title: 'TryHackMe — Pre-Security Path',
          platform: 'TryHackMe',
          url: 'https://tryhackme.com/path/outline/presecurity',
          isFree: true,
          duration: '4 weeks',
          icon: '🔒',
        ),
      ],
      estimatedDuration: '4 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Offensive Security',
      description:
          'Ethical hacking, reconnaissance, exploitation and reporting.',
      skills: ['Penetration Testing', 'Reconnaissance', 'Exploitation', 'Reporting'],
      resources: [
        _RoadmapResourceSpec(
          title: 'TryHackMe — Jr Penetration Tester',
          platform: 'TryHackMe',
          url: 'https://tryhackme.com/path/outline/jrpenetrationtester',
          isFree: false,
          duration: '8 weeks',
          icon: '🕵️',
        ),
      ],
      estimatedDuration: '8 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Defensive Security & Portfolio',
      description:
          'Blue-team skills, incident response, and a portfolio of write-ups.',
      skills: ['Blue Team', 'Incident Response', 'Portfolio'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Blue Team Labs Online',
          platform: 'Blue Team Labs',
          url: 'https://blueteamlabs.online',
          isFree: false,
          duration: '6 weeks',
          icon: '🛡️',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
  ]),
  'ethical_hacker': const _CareerRoadmapSpec([
    _RoadmapPhaseSpec(
      title: 'Networking & Linux Foundations',
      description:
          'Understand how data moves and how to operate on Linux hosts.',
      skills: ['Networking', 'Linux', 'Bash', 'TCP/IP'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Networking Basics',
          platform: 'Cisco NetAcad',
          url: 'https://www.netacad.com/courses/networking',
          isFree: true,
          duration: '5 weeks',
          icon: '🌐',
        ),
      ],
      estimatedDuration: '5 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Security Fundamentals',
      description:
          'Encryption, hashing, and the security mindset needed for offensive work.',
      skills: ['Security Fundamentals', 'Cryptography'],
      resources: [
        _RoadmapResourceSpec(
          title: 'TryHackMe — Pre-Security Path',
          platform: 'TryHackMe',
          url: 'https://tryhackme.com/path/outline/presecurity',
          isFree: true,
          duration: '4 weeks',
          icon: '🔒',
        ),
      ],
      estimatedDuration: '4 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Ethical Hacking Tooling',
      description:
          'Reconnaissance, scanning, exploitation and post-exploitation with real tools.',
      skills: ['Penetration Testing', 'Reconnaissance', 'Exploitation', 'Metasploit'],
      resources: [
        _RoadmapResourceSpec(
          title: 'TryHackMe — Jr Penetration Tester',
          platform: 'TryHackMe',
          url: 'https://tryhackme.com/path/outline/jrpenetrationtester',
          isFree: false,
          duration: '8 weeks',
          icon: '🕵️',
        ),
      ],
      estimatedDuration: '8 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Bug Bounties & Portfolio',
      description:
          'Practice on real targets legally and build a public track record.',
      skills: ['Bug Bounty', 'Reporting', 'Portfolio'],
      resources: [
        _RoadmapResourceSpec(
          title: 'HackerOne Resources',
          platform: 'HackerOne',
          url: 'https://www.hackerone.com/hackers',
          isFree: true,
          duration: 'Ongoing',
          icon: '🐞',
        ),
      ],
      estimatedDuration: 'Ongoing',
    ),
  ]),

  // ── UI / UX Designer ────────────────────────────────────────────────
  'ui_ux_designer': const _CareerRoadmapSpec([
    _RoadmapPhaseSpec(
      title: 'UX Foundations',
      description:
          'Human-centred thinking, usability, and how design decisions get made.',
      skills: ['UX Fundamentals', 'Design Thinking', 'User Research'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Google UX Design Certificate',
          platform: 'Coursera (Google)',
          url: 'https://coursera.org/professional-certificates/google-ux-design',
          isFree: false,
          duration: '3 months',
          icon: '🎨',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'UI & Visual Craft',
      description:
          'Typography, colour, layout, and the visual polish users notice.',
      skills: ['UI Design', 'Typography', 'Color Theory', 'Layout'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Refactoring UI',
          platform: 'Refactoring UI (Book)',
          url: 'https://www.refactoringui.com',
          isFree: false,
          duration: '3 weeks',
          icon: '🖌️',
        ),
      ],
      estimatedDuration: '4 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Figma & Prototyping',
      description:
          'Design end-to-end flows in Figma and test them with real users.',
      skills: ['Figma', 'Prototyping', 'Accessibility'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Figma Learn',
          platform: 'Figma',
          url: 'https://help.figma.com/hc/en-us/categories/360002051613',
          isFree: true,
          duration: '3 weeks',
          icon: '🧩',
        ),
      ],
      estimatedDuration: '4 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Portfolio & Job Ready',
      description:
          'Package 3 real case studies and prepare for design interviews.',
      skills: ['Portfolio', 'Case Studies', 'Interview Prep'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Design Portfolio Guide',
          platform: 'YouTube',
          url: 'https://youtube.com/results?search_query=ux+design+portfolio',
          isFree: true,
          duration: '3 weeks',
          icon: '💼',
        ),
      ],
      estimatedDuration: '3 weeks',
    ),
  ]),
  'ux_designer': const _CareerRoadmapSpec([
    _RoadmapPhaseSpec(
      title: 'UX Foundations',
      description:
          'Human-centred thinking and the principles behind great experiences.',
      skills: ['UX Fundamentals', 'Design Thinking', 'User Research'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Google UX Design Certificate',
          platform: 'Coursera (Google)',
          url: 'https://coursera.org/professional-certificates/google-ux-design',
          isFree: false,
          duration: '3 months',
          icon: '🎨',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'UI & Visual Craft',
      description:
          'Visual hierarchy, typography, and layout that communicates clearly.',
      skills: ['UI Design', 'Typography', 'Color Theory', 'Layout'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Refactoring UI',
          platform: 'Refactoring UI (Book)',
          url: 'https://www.refactoringui.com',
          isFree: false,
          duration: '3 weeks',
          icon: '🖌️',
        ),
      ],
      estimatedDuration: '4 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Figma & Prototyping',
      description:
          'Design real flows and test them with users before building.',
      skills: ['Figma', 'Prototyping', 'Accessibility'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Figma Learn',
          platform: 'Figma',
          url: 'https://help.figma.com/hc/en-us/categories/360002051613',
          isFree: true,
          duration: '3 weeks',
          icon: '🧩',
        ),
      ],
      estimatedDuration: '4 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Portfolio & Job Ready',
      description:
          'Turn your best work into case studies that get interviews.',
      skills: ['Portfolio', 'Case Studies', 'Interview Prep'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Design Portfolio Guide',
          platform: 'YouTube',
          url: 'https://youtube.com/results?search_query=ux+design+portfolio',
          isFree: true,
          duration: '3 weeks',
          icon: '💼',
        ),
      ],
      estimatedDuration: '3 weeks',
    ),
  ]),

  // ── DevOps Engineer ────────────────────────────────────────────────
  'devops_engineer': const _CareerRoadmapSpec([
    _RoadmapPhaseSpec(
      title: 'Linux & Networking Foundations',
      description:
          'The base OS and network skills every DevOps engineer relies on.',
      skills: ['Linux', 'Networking', 'Bash', 'System Administration'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Linux Journey',
          platform: 'Linux Journey',
          url: 'https://linuxjourney.com',
          isFree: true,
          duration: '3 weeks',
          icon: '🐧',
        ),
      ],
      estimatedDuration: '4 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Containers & Orchestration',
      description:
          'Package apps with Docker and run them reliably on Kubernetes.',
      skills: ['Docker', 'Kubernetes', 'Container Networking'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Docker & Kubernetes Guide',
          platform: 'YouTube (TechWorld with Nana)',
          url: 'https://youtube.com/results?search_query=techworld+with+nana+docker+kubernetes',
          isFree: true,
          duration: '5 weeks',
          icon: '🐳',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Cloud & Infrastructure as Code',
      description:
          'Run workloads on real cloud platforms and manage them declaratively.',
      skills: ['Cloud Computing', 'Terraform', 'IAM'],
      resources: [
        _RoadmapResourceSpec(
          title: 'AWS Cloud Practitioner Essentials',
          platform: 'AWS Skill Builder',
          url: 'https://explore.skillbuilder.aws/learn',
          isFree: true,
          duration: '4 weeks',
          icon: '☁️',
        ),
      ],
      estimatedDuration: '5 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'CI/CD, Observability & Portfolio',
      description:
          'Automate delivery, monitor production, and publish DevOps projects.',
      skills: ['CI/CD', 'GitHub Actions', 'Monitoring', 'Portfolio'],
      resources: [
        _RoadmapResourceSpec(
          title: 'GitHub Actions Docs',
          platform: 'GitHub',
          url: 'https://docs.github.com/en/actions',
          isFree: true,
          duration: '3 weeks',
          icon: '⚙️',
        ),
      ],
      estimatedDuration: '4 weeks',
    ),
  ]),

  // ── QA Engineer ────────────────────────────────────────────────────
  'qa_engineer': const _CareerRoadmapSpec([
    _RoadmapPhaseSpec(
      title: 'Testing Fundamentals',
      description:
          'The mindset and vocabulary of software quality.',
      skills: ['Software Testing Fundamentals', 'Testing', 'Test Design'],
      resources: [
        _RoadmapResourceSpec(
          title: 'ISTQB Foundation Overview',
          platform: 'ISTQB',
          url: 'https://www.istqb.org',
          isFree: true,
          duration: '3 weeks',
          icon: '🧪',
        ),
      ],
      estimatedDuration: '3 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Manual & Exploratory Testing',
      description:
          'Design and run tests that catch real bugs, not just the obvious ones.',
      skills: ['Manual Testing', 'Bug Reporting', 'Regression Testing'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Ministry of Testing',
          platform: 'Ministry of Testing',
          url: 'https://www.ministryoftesting.com',
          isFree: true,
          duration: '3 weeks',
          icon: '🔍',
        ),
      ],
      estimatedDuration: '4 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Automation & Tooling',
      description:
          'Automate the boring parts — API tests, UI tests, CI.',
      skills: ['Automation', 'Python', 'APIs', 'Git'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Automate the Boring Stuff with Python',
          platform: 'Automate the Boring Stuff',
          url: 'https://automatetheboringstuff.com',
          isFree: true,
          duration: '4 weeks',
          icon: '🐍',
        ),
      ],
      estimatedDuration: '5 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Test Strategy & Portfolio',
      description:
          'Design test plans for real products and document your work.',
      skills: ['Test Strategy', 'Debugging', 'Portfolio'],
      resources: [
        _RoadmapResourceSpec(
          title: 'QA Portfolio Guide',
          platform: 'YouTube',
          url: 'https://youtube.com/results?search_query=qa+tester+portfolio',
          isFree: true,
          duration: '3 weeks',
          icon: '💼',
        ),
      ],
      estimatedDuration: '3 weeks',
    ),
  ]),

  // ── Blockchain Developer ───────────────────────────────────────────
  'blockchain_dev': const _CareerRoadmapSpec([
    _RoadmapPhaseSpec(
      title: 'Blockchain Fundamentals',
      description:
          'How distributed ledgers work and why they are hard to tamper with.',
      skills: ['Blockchain', 'Cryptography', 'Hashing'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Blockchain Basics',
          platform: 'Coursera (Buffalo)',
          url: 'https://coursera.org/learn/blockchain-basics',
          isFree: false,
          duration: '4 weeks',
          icon: '⛓️',
        ),
      ],
      estimatedDuration: '4 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Smart Contracts & Solidity',
      description:
          'Write, test, and deploy contracts on Ethereum.',
      skills: ['Smart Contracts', 'Solidity', 'Testing'],
      resources: [
        _RoadmapResourceSpec(
          title: 'CryptoZombies',
          platform: 'CryptoZombies',
          url: 'https://cryptozombies.io',
          isFree: true,
          duration: '4 weeks',
          icon: '🧟',
        ),
      ],
      estimatedDuration: '5 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Security & Auditing',
      description:
          'Find and avoid the vulnerabilities that make smart contracts dangerous.',
      skills: ['Security Fundamentals', 'Auditing', 'Cryptography'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Ethernaut by OpenZeppelin',
          platform: 'OpenZeppelin',
          url: 'https://ethernaut.openzeppelin.com',
          isFree: true,
          duration: '4 weeks',
          icon: '🛡️',
        ),
      ],
      estimatedDuration: '4 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'dApps & Portfolio',
      description:
          'Build a full dApp, ship it, and showcase your contracts.',
      skills: ['JavaScript', 'Web3', 'Portfolio'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Full Stack Web3',
          platform: 'Alchemy University',
          url: 'https://university.alchemy.com',
          isFree: true,
          duration: '6 weeks',
          icon: '🚀',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
  ]),

  // ── Solutions Architect ────────────────────────────────────────────
  'solutions_architect': const _CareerRoadmapSpec([
    _RoadmapPhaseSpec(
      title: 'System Design Foundations',
      description:
          'How large systems are structured, scaled and reasoned about.',
      skills: ['System Design', 'Architecture', 'Scalability'],
      resources: [
        _RoadmapResourceSpec(
          title: 'System Design Primer',
          platform: 'GitHub',
          url: 'https://github.com/donnemartin/system-design-primer',
          isFree: true,
          duration: '4 weeks',
          icon: '🏗️',
        ),
      ],
      estimatedDuration: '4 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Cloud & Infrastructure',
      description:
          'Design systems on real cloud platforms with real trade-offs.',
      skills: ['Cloud Computing', 'Networking', 'Databases'],
      resources: [
        _RoadmapResourceSpec(
          title: 'AWS Solutions Architect Path',
          platform: 'AWS Skill Builder',
          url: 'https://explore.skillbuilder.aws/learn',
          isFree: true,
          duration: '6 weeks',
          icon: '☁️',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Security & Reliability',
      description:
          'Design systems that stay up and stay safe under real traffic.',
      skills: ['Security Fundamentals', 'Reliability', 'Observability'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Site Reliability Engineering (Book)',
          platform: 'Google SRE',
          url: 'https://sre.google/books/',
          isFree: true,
          duration: '5 weeks',
          icon: '🛡️',
        ),
      ],
      estimatedDuration: '5 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Portfolio & Job Ready',
      description:
          'Document real architecture decisions and prepare for senior interviews.',
      skills: ['Portfolio', 'Interview Prep', 'System Design'],
      resources: [
        _RoadmapResourceSpec(
          title: 'System Design Interview Guide',
          platform: 'YouTube',
          url: 'https://youtube.com/results?search_query=system+design+interview',
          isFree: true,
          duration: '3 weeks',
          icon: '💼',
        ),
      ],
      estimatedDuration: '3 weeks',
    ),
  ]),
};