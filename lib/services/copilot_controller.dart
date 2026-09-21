// ══════════════════════════════════════════════════════════════════════
// lib/services/copilot_controller.dart
//
// FINAL integration pass — CopilotController as the intelligence /
// orchestration layer.
//
// Behaviour contract:
//   User action
//     → authoritative Firestore evidence/event (CopilotFirestoreService)
//     → XP/progress persistence
//     → CopilotContext refresh
//     → readiness recalculation
//     → skill gaps / roadmap / next action / today goals evolve
//     → UI receives the new state.
//
// AUTHORITATIVE STATE RECONCILIATION
// ──────────────────────────────────
// CopilotController.init(uid) intentionally returns early when the UID
// has not changed, so it cannot be used as a same-session refresh after
// an external XP/progress-changing operation (RewardService daily/surprise
// reward, QuestService, AchievementService, CopilotFirestoreService
// course events, etc.).
//
// This revision preserves the existing additive public method:
//
//     Future<void> refreshAuthoritativeState(String uid)
//
// which reads users/{uid}.totalXp directly from the authoritative
// Firestore document via CopilotFirestoreService.getUserTotalXp(uid).
//
// IMPORTANT — CopilotState.totalXp is DERIVED
// ────────────────────────────────────────────
// The current CopilotState model does NOT expose a writable `totalXp`
// field on its `copyWith`. `totalXp` is derived (e.g. from the local
// progress history). Because of that, `refreshAuthoritativeState(uid)`
// cannot push a fresh Firestore value into CopilotState via copyWith.
//
// Instead, this Controller keeps the authoritative Firestore XP in a
// dedicated in-memory field, `_authoritativeTotalXp`, which is populated
// only from CopilotFirestoreService.getUserTotalXp(uid). It never
// derives XP from progressHistory and never fabricates values. All
// Controller-side XP reads that must be authoritative go through
// `_resolveAuthoritativeTotalXp()`, which returns the cached
// authoritative value when present and falls back to `_state.totalXp`
// only when no authoritative value has ever been observed.
//
// rerunAnalysis(uid) is UID-safe: it does not mutate _currentUid. It
// runs only for the currently initialized user and safely no-ops
// otherwise.
//
// AUTHORITATIVE GOAL COMPLETION DETECTION
// ──────────────────────────────────────
// CopilotFirestoreService.toggleGoalCompletion() is the single source of
// truth for whether a goal completion actually happened AND for what the
// resulting Firestore state is. It returns a small result object that
// carries the authoritative resulting `isCompleted` state together with
// a `becameCompleted` flag that is true only for a genuine first-time
// false → true completion (used to trigger surprise rewards).
//
// The Controller uses that authoritative result to build local
// todayGoals and to feed syncTodayProgress(). The caller's UI
// `goal.isCompleted` snapshot is never consulted.
//
// AUTHORITATIVE COURSE-EVENT RESULT
// ─────────────────────────────────
// CopilotFirestoreService.recordCourseEvent() returns
// `Future<bool>`: true when THIS call newly recorded the event (and
// therefore awarded XP inside the Firestore transaction), false when
// the event already existed and the call was a no-op.
//
// The Controller forwards that result to the caller so a UI layer can
// distinguish a genuine first-time completion from an idempotent
// re-submission — WITHOUT adding any XP logic here. Firestore remains
// the sole authority for whether XP was awarded.
//
// FINAL PASS NOTES (preserved, unchanged):
//   • Software Engineer is a first-class Copilot career.
//   • State-versioned NextBestAction IDs for project / interview / apply.
//   • State-versioned Recommendation IDs.
//   • Career-aware skill gaps and roadmaps.
//   • Deterministic/offline fallback behaviour.
// ══════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/copilot_models.dart';
import '../models/quest_models.dart';
import 'copilot_firestore_service.dart';
import 'copilot_ai_service.dart';
import 'local_goal_generator_service.dart';
import 'reward_service.dart';

class CopilotController extends ChangeNotifier {
  CopilotState _state = const CopilotState();
  CopilotState get state => _state;

  StreamSubscription<UserSkillProfile?>? _profileSub;
  StreamSubscription<PersonalizedRoadmap?>? _roadmapSub;
  StreamSubscription<List<DailyGoal>>? _goalsSub;
  StreamSubscription<List<ProgressEntry>>? _progressSub;

  String? _currentUid;

  /// Monotonic token used to invalidate stale async refreshes. Each call
  /// to [refreshAuthoritativeState] captures the current value; on
  /// completion it only applies its result if the token still matches
  /// (i.e. no newer refresh or UID switch has occurred meanwhile).
  int _authoritativeRefreshToken = 0;

  /// Authoritative Firestore-backed total XP for the current user.
  ///
  /// Populated ONLY from
  /// `CopilotFirestoreService.getUserTotalXp(uid)` — never derived from
  /// `progressHistory` and never fabricated. It is intentionally NOT
  /// stored on `CopilotState`, because the model does not expose a
  /// writable `totalXp` field via `copyWith`. Consumers that need the
  /// authoritative value must use [_resolveAuthoritativeTotalXp].
  int? _authoritativeTotalXp;

  CopilotContext? _copilotContext;
  CopilotContext? get copilotContext => _copilotContext;

  String? _selectedCareerId;
  String? get selectedCareerId => _selectedCareerId;

  final RewardService _rewardService = RewardService();

  static bool get _hasApiKey => false;

  // ── Init ────────────────────────────────────────────────────────────
  Future<void> init(String uid) async {
    if (_currentUid == uid) {
      if (_state.isLoading) _set(_state.copyWith(isLoading: false));
      return;
    }

    if (_currentUid != null && _currentUid != uid) {
      _selectedCareerId = null;
      _copilotContext = null;
      _authoritativeTotalXp = null;
      _state = const CopilotState(isLoading: true);
      // Invalidate any in-flight authoritative refresh from the old UID.
      _authoritativeRefreshToken++;
    }

    _currentUid = uid;

    await _cancelStreams();
    _set(_state.copyWith(isLoading: true, error: null));

    try {
      final career = await CopilotFirestoreService.getCareerContext(uid);
      if (career != null) _selectedCareerId = career.careerId;
    } catch (_) {}

    _profileSub =
        CopilotFirestoreService.skillProfileStream(uid).listen((p) async {
      _set(_state.copyWith(skillProfile: p));

      if (p != null) {
        final existingGoals =
            await CopilotFirestoreService.getTodayGoals(uid);
        if (existingGoals.isEmpty) {
          await _runAnalysis(p);
        }
      }

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

    try {
      final gaps = await CopilotFirestoreService.getSkillGaps(uid);
      _set(_state.copyWith(skillGaps: gaps, isLoading: false));
    } catch (e) {
      _set(_state.copyWith(isLoading: false, error: e.toString()));
    }

    // Initial authoritative reconciliation — pulls the real users/{uid}
    // totalXp into the Controller's authoritative cache, then runs the
    // intelligence pipeline.
    await refreshAuthoritativeState(uid);
    unawaited(refreshIntelligence(uid));

    Future.delayed(const Duration(milliseconds: 800), () {
      if (_state.isLoading) _set(_state.copyWith(isLoading: false));
    });
  }

  // ── AUTHORITATIVE STATE RECONCILIATION ─────────────────────────────

  /// Reads users/{uid}.totalXp from the authoritative Firestore document
  /// via CopilotFirestoreService.getUserTotalXp(uid) and stores it in the
  /// Controller's authoritative XP cache.
  ///
  /// Guarantees:
  ///   • Only the Controller's authoritative XP cache is replaced.
  ///     Skill profile, roadmap, goals, skill gaps, progress history,
  ///     streak, career selection, readiness, next actions and
  ///     recommendations are all preserved.
  ///   • A missing document / missing field / malformed value never
  ///     zeroes out a previously valid value — the last known
  ///     authoritative value is retained and a debug line is logged.
  ///   • Safe to call repeatedly and concurrently: a monotonic token
  ///     discards results from older refreshes and from a previous UID.
  ///   • Notifies listeners only when the value actually changed.
  ///
  /// This method is the intended Hub-side refresh entry point after any
  /// RewardService / QuestService / AchievementService / course-event
  /// operation that may have changed XP on the user document.
  Future<void> refreshAuthoritativeState(String uid) async {
    if (uid.isEmpty) return;

    final token = ++_authoritativeRefreshToken;

    int? freshXp;
    try {
      freshXp = await CopilotFirestoreService.getUserTotalXp(uid);
    } catch (e) {
      debugPrint('refreshAuthoritativeState read failed: $e');
      return;
    }

    // Discard if a newer refresh (or a UID switch) has happened.
    if (token != _authoritativeRefreshToken) return;
    if (_currentUid != uid) return;
    if (freshXp == null) return;
    if (freshXp < 0) return;

    if (_authoritativeTotalXp == freshXp) return;

    _authoritativeTotalXp = freshXp;
    // CopilotState does not expose a writable totalXp field, so we notify
    // listeners directly. Consumers that read the authoritative value
    // must use `_resolveAuthoritativeTotalXp()`.
    notifyListeners();
  }

  // ── Save skill profile + analysis ───────────────────────────────────
  Future<void> saveSkillProfile(UserSkillProfile profile) async {
    _set(_state.copyWith(isLoading: true, error: null));
    try {
      await CopilotFirestoreService.saveSkillProfile(profile);
      _set(_state.copyWith(skillProfile: profile));
      await _runAnalysis(profile);
      await refreshAuthoritativeState(profile.uid);
    } catch (e) {
      _set(_state.copyWith(isLoading: false, error: 'Save failed: $e'));
    }
  }

  /// Reconciles authoritative state first, then re-runs intelligence
  /// analysis only when it is actually required.
  ///
  /// UID SAFETY:
  ///   • This method does NOT mutate _currentUid. Session/UID ownership
  ///     remains exclusively with init().
  ///   • If no session is initialized, or the caller's uid does not match
  ///     the currently initialized user, the method safely no-ops.
  ///
  /// "Required" analysis means: no skill profile yet, or no roadmap yet,
  /// or no today-goals yet. When profile, roadmap and goals already
  /// exist, the only thing that needs refreshing is the authoritative XP
  /// plus the intelligence pipeline (readiness / next actions /
  /// recommendations), which refreshIntelligence() already handles
  /// without regenerating goals.
  Future<void> rerunAnalysis(String uid) async {
    if (uid.isEmpty) return;

    // Session guard: only operate for the currently initialized user.
    final activeUid = _currentUid;
    if (activeUid == null || activeUid != uid) {
      debugPrint(
        'rerunAnalysis ignored: uid "$uid" does not match active session "$activeUid"',
      );
      return;
    }

    // 1. Authoritative reconciliation (XP, non-destructive).
    await refreshAuthoritativeState(uid);

    // 2. Decide whether full analysis is genuinely required.
    final profile = _state.skillProfile;
    final needsFullAnalysis = profile == null ||
        _state.roadmap == null ||
        _state.todayGoals.isEmpty;

    if (needsFullAnalysis && profile != null) {
      await _runAnalysis(profile);
    }

    // 3. Always refresh the intelligence pipeline (readiness / actions /
    //    recommendations). This uses the freshly reconciled state.
    await refreshIntelligence(uid);
  }

  // ── Toggle a daily goal completion ──────────────────────────────────
  //
  // Authoritative state and completion detection:
  //   • CopilotFirestoreService.toggleGoalCompletion() is the single
  //     source of truth. It returns a result object carrying the
  //     AUTHORITATIVE resulting `isCompleted` state and a
  //     `becameCompleted` flag that is true only for a genuine
  //     first-time false → true completion (i.e. the canonical
  //     completion record did not already exist).
  //   • The Controller builds the new local todayGoals using that
  //     authoritative resulting state — never from the caller's UI
  //     `goal.isCompleted` and never from `!g.isCompleted`.
  //   • syncTodayProgress() is fed the same authoritative todayGoals.
  //   • Surprise-reward logic runs only when `becameCompleted == true`.
  //   • Exactly-once XP/idempotency inside CopilotFirestoreService is
  //     preserved unchanged.
  Future<void> toggleGoal(String uid, DailyGoal goal) async {
    try {
      final result = await CopilotFirestoreService.toggleGoalCompletion(
        uid,
        goal,
        careerId: _resolveActiveCareerId(fallbackToProfile: false),
      );

      // Authoritative resulting state for THIS goal — never derived from
      // the caller's UI snapshot.
      final authoritativeIsCompleted = result.isCompleted;

      final updated = _state.todayGoals.map((g) {
        if (g.id == goal.id) {
          return DailyGoal(
            id: g.id,
            uid: g.uid,
            title: g.title,
            category: g.category,
            date: g.date,
            isCompleted: authoritativeIsCompleted,
            xpReward: g.xpReward,
            linkedSkill: g.linkedSkill,
          );
        }
        return g;
      }).toList();

      // Update local state first so the UI reflects the authoritative
      // result even if the subsequent Firestore sync fails.
      _set(_state.copyWith(todayGoals: updated));

      await CopilotFirestoreService.syncTodayProgress(uid, updated);

      // Reconcile authoritative XP before intelligence refresh so any
      // downstream listener sees the newly-awarded XP immediately.
      await refreshAuthoritativeState(uid);

      unawaited(refreshIntelligence(uid));

      // Surprise reward only on a genuine, first-time completion.
      if (result.becameCompleted) {
        try {
          final surprise = await _rewardService.rollSurpriseReward(uid);
          if (surprise != null) {
            debugPrint(
              '🎁 Surprise reward: ${surprise.message} (+${surprise.xpAmount} XP)',
            );
            // Surprise reward writes XP — reconcile again.
            await refreshAuthoritativeState(uid);
          }
        } catch (e) {
          debugPrint('rollSurpriseReward error: $e');
        }
      }
    } catch (e) {
      debugPrint('toggleGoal error: $e');
    }
  }

  // ── Mark a roadmap phase complete ───────────────────────────────────
  Future<void> completePhase(String uid, int phaseIndex) async {
    try {
      await CopilotFirestoreService.completeRoadmapPhase(uid, phaseIndex);
      unawaited(refreshIntelligence(uid));
    } catch (e) {
      debugPrint('completePhase error: $e');
    }
  }

  // ══════════════════════════════════════════════════════════════════════
  // INTERNAL: Full analysis pipeline
  // ══════════════════════════════════════════════════════════════════════
  Future<void> _runAnalysis(UserSkillProfile profile) async {
    _set(_state.copyWith(isLoading: true, error: null));
    try {
      List<SkillGap> gaps;
      PersonalizedRoadmap roadmap;
      List<DailyGoal> goals;

      if (_hasApiKey) {
        debugPrint('🤖 CopilotController: Using real Claude API');

        gaps = await CopilotAIService.analyseSkillGaps(profile);
        await CopilotFirestoreService.saveSkillGaps(profile.uid, gaps);
        _set(_state.copyWith(skillGaps: gaps));

        roadmap = await CopilotAIService.generateRoadmap(profile, gaps);
        await CopilotFirestoreService.saveRoadmap(roadmap);
        _set(_state.copyWith(roadmap: roadmap));

        final existingGoals =
            await CopilotFirestoreService.getTodayGoals(profile.uid);
        if (existingGoals.isEmpty) {
          goals = await CopilotAIService.generateDailyGoals(
              profile, roadmap, gaps);
          await CopilotFirestoreService.saveDailyGoals(profile.uid, goals);
          _set(_state.copyWith(todayGoals: goals));
        }
      } else {
        debugPrint('⚠️  CopilotController: No API key — using mock data');

        gaps = _mockGapsFor(profile, context: _copilotContext);
        await CopilotFirestoreService.saveSkillGaps(profile.uid, gaps);
        _set(_state.copyWith(skillGaps: gaps));

        roadmap = _mockRoadmapFor(profile, context: _copilotContext);
        await CopilotFirestoreService.saveRoadmap(roadmap);
        _set(_state.copyWith(roadmap: roadmap));

        final existingGoals =
            await CopilotFirestoreService.getTodayGoals(profile.uid);
        if (existingGoals.isEmpty) {
          final realStreak = _state.currentStreak;
          final realTotalXp = await _resolveAuthoritativeTotalXp();
          final realLevel = LevelSystem.levelFor(realTotalXp);
          final realPhase = _currentRoadmapPhaseIndex();

          goals = await LocalGoalGeneratorService().generateAndSaveDailyGoals(
            uid: profile.uid,
            targetRole: profile.targetRole.label,
            currentSkills: profile.skills.map((s) => s.name).toList(),
            currentStreak: realStreak,
            currentLevel: realLevel,
            roadmapPhase: realPhase,
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
  // AUTHORITATIVE XP
  // ══════════════════════════════════════════════════════════════════════

  /// Returns the best available total XP for the current user, in priority
  /// order:
  ///
  ///   1. The Controller's authoritative Firestore-backed cache, which is
  ///      populated ONLY by `CopilotFirestoreService.getUserTotalXp(uid)`.
  ///      A fresh read is attempted first so the returned value is always
  ///      current when Firestore is reachable.
  ///
  ///   2. Fall back to the last observed authoritative value when a fresh
  ///      read fails.
  ///
  ///   3. Fall back to the local `CopilotState.totalXp` ONLY when no
  ///      authoritative value has ever been observed (e.g. before init
  ///      completed).
  ///
  /// This method NEVER sums progressHistory.xpEarned. It NEVER fabricates
  /// or estimates XP. It NEVER zeroes a previously valid value on a
  /// transient failure.
  Future<int> _resolveAuthoritativeTotalXp() async {
    final uid = _currentUid;
    if (uid != null && uid.isNotEmpty) {
      try {
        final fresh = await CopilotFirestoreService.getUserTotalXp(uid);
        if (fresh >= 0) {
          _authoritativeTotalXp = fresh;
          return fresh;
        }
      } catch (_) {}
    }
    final cached = _authoritativeTotalXp;
    if (cached != null && cached >= 0) return cached;
    return _state.totalXp;
  }

  /// Real current roadmap phase index from the live roadmap; falls back to
  /// 0 only when there is genuinely no roadmap yet.
  int _currentRoadmapPhaseIndex() {
    final ctx = _copilotContext;
    if (ctx != null && ctx.state.roadmap != null) {
      return ctx.state.roadmap!.currentPhaseIndex;
    }
    final localRoadmap = _state.roadmap;
    if (localRoadmap != null) return localRoadmap.currentPhaseIndex;
    return 0;
  }

  /// Resolves the active career id in priority order:
  ///   1. explicit caller override,
  ///   2. _selectedCareerId,
  ///   3. mapped from the current skill profile's targetRole (optional).
  ///
  /// Returns null when no valid career id can be determined — callers MUST
  /// treat null as "no structured evidence" (never invent a bucket).
  String? _resolveActiveCareerId({bool fallbackToProfile = true}) {
    if (_selectedCareerId != null && _selectedCareerId!.isNotEmpty) {
      return _selectedCareerId;
    }
    if (fallbackToProfile) {
      final profile = _state.skillProfile;
      if (profile != null) {
        return _careerIdForGoal(profile.targetRole);
      }
    }
    return null;
  }

  // ── Career resolution ───────────────────────────────────────────────
  static List<_CareerSkill> _requiredSkillsFor(
    UserSkillProfile profile, {
    CopilotContext? context,
  }) {
    final careerId = context?.career?.careerId ?? '';

    final byId = _careerSkillSpecs[careerId];
    if (byId != null) return byId;

    final byRole = _careerSkillSpecs[_careerIdForGoal(profile.targetRole)];
    if (byRole != null) return byRole;

    return _careerSkillSpecs['ai_engineer']!;
  }

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
      case CareerGoal.softwareEngineer: return 'software_engineer';
    }
  }

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
    'software_engineer': const [
      _CareerSkill('Data Structures & Algorithms', SkillLevel.advanced, 1, 'Core skill for every software engineering interview'),
      _CareerSkill('System Design',     SkillLevel.intermediate, 1, 'Designing scalable, maintainable systems'),
      _CareerSkill('Git',               SkillLevel.advanced,     2, 'Version control on every project'),
      _CareerSkill('Testing',           SkillLevel.intermediate, 2, 'Writing reliable, maintainable code'),
      _CareerSkill('APIs',              SkillLevel.intermediate, 2, 'Building and consuming services'),
      _CareerSkill('Databases',         SkillLevel.intermediate, 3, 'Persisting and querying data'),
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
  /// Priority order for a skill's current level:
  ///   1. explicit UserSkillProfile level,
  ///   2. per-topic evidence from CopilotContext.learningProgress,
  ///   3. no evidence → null ("not demonstrated"), never invented.
  List<SkillGap> _mockGapsFor(UserSkillProfile profile,
      {CopilotContext? context}) {
    final requiredSkills = _requiredSkillsFor(profile, context: context);

    SkillLevel? evidenceFallback(String skillName) {
      final lp = context?.learningProgress;
      if (lp == null) return null;
      // The current LearningProgressContext model does not expose
      // per-skill strong / weak evidence counts, and no existing field
      // on it can be used to derive them without inventing data or
      // changing another file. To keep gap reporting honest, treat the
      // skill as "not demonstrated" and let the explicit
      // UserSkillProfile level be the only source of truth.
      return null;
    }

    final gaps = <SkillGap>[];
    for (final req in requiredSkills) {
      final explicit = _lvl(profile, req.name);
      final inferred = explicit ?? evidenceFallback(req.name);
      final cur = inferred?.value ?? 0;
      if (cur < req.required.value) {
        gaps.add(SkillGap(
          skillName: req.name,
          requiredLevel: req.required,
          currentLevel: inferred,
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

  /// Career-aware roadmap builder. Progress decision priority:
  ///   1. live roadmap evidence from CopilotContext,
  ///   2. local roadmap state,
  ///   3. conservative learning-progress fallback (older users).
  PersonalizedRoadmap _mockRoadmapFor(UserSkillProfile profile,
      {CopilotContext? context}) {
    final liveRoadmap = context?.state.roadmap;
    final localRoadmap = _state.roadmap;

    final double progress;
    final int currentPhaseIndexFromEvidence;
    if (liveRoadmap != null) {
      progress = liveRoadmap.overallProgress;
      currentPhaseIndexFromEvidence = liveRoadmap.currentPhaseIndex;
    } else if (localRoadmap != null) {
      progress = localRoadmap.overallProgress;
      currentPhaseIndexFromEvidence = localRoadmap.currentPhaseIndex;
    } else {
      progress = context?.learningProgress.progress ?? 0.0;
      currentPhaseIndexFromEvidence = 0;
    }

    final careerId = context?.career?.careerId ?? '';
    final spec = _careerRoadmapSpecs[careerId] ??
        _careerRoadmapSpecs[_careerIdForGoal(profile.targetRole)] ??
        _careerRoadmapSpecs['ai_engineer']!;

    final totalPhases = spec.phases.length;
    bool phaseCompleted(int phaseNumber) =>
        totalPhases == 0 ? false : progress >= (phaseNumber + 1) / totalPhases;
    bool phaseUnlocked(int phaseNumber) =>
        phaseNumber == 0 ||
        (totalPhases > 0 && progress >= phaseNumber / totalPhases);
    final computedIndex = totalPhases == 0
        ? 0
        : min(totalPhases - 1, (progress * totalPhases).floor());
    final currentPhaseIndex = liveRoadmap != null || localRoadmap != null
        ? currentPhaseIndexFromEvidence
        : computedIndex;

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

  // ══════════════════════════════════════════════════════════════════════
  // COPILOT INTELLIGENCE
  // ══════════════════════════════════════════════════════════════════════

  /// Loads the full [CopilotContext], recomputes readiness deterministically,
  /// generates genuinely-new actions/recommendations (state-versioned IDs),
  /// persists the new pieces, and updates local state.
  ///
  /// This method does NOT touch XP — it consumes whatever XP is already
  /// present on the caller's state. XP reconciliation is owned by
  /// [refreshAuthoritativeState] so there is exactly one XP source.
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

  Future<void> selectCareer(String uid, CareerContext career) async {
    try {
      await CopilotFirestoreService.saveCareerContext(uid, career);
      _selectedCareerId = career.careerId;
      await refreshIntelligence(uid, careerId: career.careerId);
    } catch (e) {
      debugPrint('selectCareer error: $e');
    }
  }

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
      await refreshAuthoritativeState(uid);
      await refreshIntelligence(uid, careerId: careerId);
    } catch (e) {
      debugPrint('recordLessonCompleted error: $e');
    }
  }

  /// Records a single course event and reports whether this call was the
  /// one that actually recorded it.
  ///
  /// Returns:
  ///   • `true`  — the event was newly recorded by this call
  ///                (CopilotFirestoreService awarded XP inside its own
  ///                transaction).
  ///   • `false` — the event already existed (idempotent no-op), or the
  ///                inputs were invalid (empty careerId / eventId), so
  ///                nothing was recorded and nothing should be awarded.
  ///
  /// XP authority is unchanged: Firestore remains the sole owner of the
  /// XP award. This method never adds XP logic of its own.
  ///
  /// Genuine Firestore errors are logged and rethrown so the caller can
  /// surface them; they never collapse into a silent `false`.
  Future<bool> recordCourseEvent(
    String uid, {
    required String careerId,
    required String eventId,
    required int xpReward,
    String? eventType,
    String? topic,
    bool? correct,
  }) async {
    final effectiveCareerId = careerId.isNotEmpty
        ? careerId
        : (_selectedCareerId ?? _resolveActiveCareerId() ?? '');
    if (effectiveCareerId.isEmpty || eventId.isEmpty) return false;

    try {
      final wasNewlyRecorded =
          await CopilotFirestoreService.recordCourseEvent(
        uid,
        careerId: effectiveCareerId,
        eventId: eventId,
        xpReward: xpReward,
        eventType: eventType,
        topic: topic,
        correct: correct,
      );
      _selectedCareerId ??= effectiveCareerId;
      await refreshAuthoritativeState(uid);
      await refreshIntelligence(uid, careerId: effectiveCareerId);
      return wasNewlyRecorded;
    } catch (e) {
      debugPrint('recordCourseEvent error: $e');
      rethrow;
    }
  }

  Future<void> recordProjectCompleted(
    String uid,
    String projectId, {
    int? totalProjects,
    String? currentProjectId,
  }) async {
    try {
      final resolvedCareerId = _resolveActiveCareerId();
      await CopilotFirestoreService.appendCompletedProject(
        uid,
        projectId,
        totalProjects: totalProjects,
        currentProjectId: currentProjectId,
        careerId: resolvedCareerId,
      );
      if (resolvedCareerId != null) _selectedCareerId ??= resolvedCareerId;
      await refreshAuthoritativeState(uid);
      await refreshIntelligence(
        uid,
        careerId: resolvedCareerId ?? _selectedCareerId,
      );
    } catch (e) {
      debugPrint('recordProjectCompleted error: $e');
    }
  }

  Future<void> recordJobApplied(String uid, String jobId) async {
    try {
      final resolvedCareerId = _resolveActiveCareerId();
      await CopilotFirestoreService.appendAppliedJob(
        uid,
        jobId,
        careerId: resolvedCareerId,
      );
      if (resolvedCareerId != null) _selectedCareerId ??= resolvedCareerId;
      await refreshIntelligence(
        uid,
        careerId: resolvedCareerId ?? _selectedCareerId,
      );
    } catch (e) {
      debugPrint('recordJobApplied error: $e');
    }
  }

  Future<void> recordInterviewCompleted(
    String uid,
    String interviewId, {
    double? score,
  }) async {
    try {
      final resolvedCareerId = _resolveActiveCareerId();
      await CopilotFirestoreService.appendCompletedInterview(
        uid,
        interviewId,
        score: score,
        careerId: resolvedCareerId,
      );
      if (resolvedCareerId != null) _selectedCareerId ??= resolvedCareerId;
      await refreshIntelligence(
        uid,
        careerId: resolvedCareerId ?? _selectedCareerId,
      );
    } catch (e) {
      debugPrint('recordInterviewCompleted error: $e');
    }
  }

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

  // ── Rule engine ─────────────────────────────────────────────────────

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

  /// Deterministic Next-Best-Action rules with state-versioned IDs.
  ///
  /// ID versions reflect real state, so a completed action under one state
  /// does not permanently block the same category at a later state.
  List<NextBestAction> _generateNextActions(
    CopilotContext context,
    CareerReadiness readiness,
  ) {
    final actions = <NextBestAction>[];
    final now = DateTime.now();
    final careerTitle = context.career?.careerTitle ??
        context.state.skillProfile?.targetRole.label ??
        'your career';

    // Rule 1: critical skill gap → skill review, versioned by the
    // current-to-required level delta.
    final criticalGaps =
        context.state.skillGaps.where((g) => g.priority == 1).toList();
    if (criticalGaps.isNotEmpty) {
      final gap = criticalGaps.first;
      final key = gap.skillName.toLowerCase().replaceAll(' ', '_');
      final levelKey =
          '${gap.currentLevel?.value ?? 0}_to_${gap.requiredLevel.value}';
      actions.add(NextBestAction(
        id: 'action_skill_${key}_$levelKey',
        type: NextActionType.skillReview,
        title: 'Strengthen ${gap.skillName}',
        description: gap.reason,
        priority: 1,
        relatedSkill: gap.skillName,
        createdAt: now,
      ));
    }

    // Rule 2: learning not yet complete → continue path, versioned by the
    // completed-count frontier.
    if (readiness.learningReadiness < 1.0) {
      final careerKey =
          context.learningProgress.careerId.isEmpty
              ? 'general'
              : context.learningProgress.careerId;
      final frontier = context.learningProgress.completedCount;
      actions.add(NextBestAction(
        id: 'action_continue_learning_${careerKey}_$frontier',
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

    // Rule 3: learning ≥ 0.4 and project < 0.6 → build project.
    // Version = projectsCompleted so the ID changes as the user ships
    // projects, releasing the action for the next project.
    if (readiness.learningReadiness >= 0.4 && readiness.projectReadiness < 0.6) {
      final projectsCompleted = context.projectProgress.completedCount;
      actions.add(NextBestAction(
        id: 'action_build_project_$projectsCompleted',
        type: NextActionType.project,
        title: 'Build a portfolio project',
        description:
            "Apply what you've learned in $careerTitle to a real project.",
        priority: 2,
        createdAt: now,
      ));
    }

    // Rule 4: learning ≥ 0.5 and interview < 0.5 → mock interview.
    // Version = interview readiness bucket (0–10). Changes as interview
    // evidence updates, releasing the action for the next attempt tier.
    if (readiness.learningReadiness >= 0.5 && readiness.interviewReadiness < 0.5) {
      final interviewBucket = (readiness.interviewReadiness * 10).floor();
      actions.add(NextBestAction(
        id: 'action_mock_interview_$interviewBucket',
        type: NextActionType.interview,
        title: 'Practice a mock interview',
        description: 'Build interview confidence for $careerTitle roles.',
        priority: 2,
        createdAt: now,
      ));
    }

    // Rule 5: jobReady ≥ 0.6 → apply.
    // Version = job readiness bucket (0–10). Changes as readiness evolves,
    // releasing the action for the next application tier.
    if (readiness.jobReadiness >= 0.6) {
      final jobBucket = (readiness.jobReadiness * 10).floor();
      actions.add(NextBestAction(
        id: 'action_apply_jobs_$jobBucket',
        type: NextActionType.application,
        title: 'Apply to $careerTitle roles',
        description:
            "Your readiness score suggests you're ready to start applying.",
        priority: 1,
        createdAt: now,
      ));
    }

    // Rule 6: streak lost → resume. Version = number of progress days so
    // it evolves with activity, without resurrecting a completed action.
    if (_state.currentStreak == 0 && context.state.progressHistory.isNotEmpty) {
      final historyDays = context.state.progressHistory.length;
      actions.add(NextBestAction(
        id: 'action_resume_streak_$historyDays',
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

  /// Deterministic recommendation rules with state-versioned IDs.
  List<CopilotRecommendation> _generateRecommendations(
    CopilotContext context,
    CareerReadiness readiness,
  ) {
    final recs = <CopilotRecommendation>[];
    final now = DateTime.now();
    final careerTitle = context.career?.careerTitle ??
        context.state.skillProfile?.targetRole.label ??
        'your career';

    // Skill gap → versioned by current-to-required level delta.
    final criticalGaps =
        context.state.skillGaps.where((g) => g.priority == 1).toList();
    if (criticalGaps.isNotEmpty) {
      final first = criticalGaps.first;
      final names = criticalGaps.map((g) => g.skillName).join(', ');
      final key = first.skillName.toLowerCase().replaceAll(' ', '_');
      final levelKey =
          '${first.currentLevel?.value ?? 0}_to_${first.requiredLevel.value}';
      recs.add(CopilotRecommendation(
        id: 'rec_skill_gap_${key}_$levelKey',
        category: RecommendationCategory.skillGap,
        title: 'Close your biggest skill gaps',
        description: 'Focus on $names — these matter most for $careerTitle.',
        priority: 1,
        createdAt: now,
      ));
    }

    // Learning path → versioned by learning-readiness bucket.
    if (readiness.learningReadiness < 0.5) {
      final learningBucket = (readiness.learningReadiness * 10).floor();
      recs.add(CopilotRecommendation(
        id: 'rec_learning_path_$learningBucket',
        category: RecommendationCategory.learningPath,
        title: 'Keep building your foundation',
        description:
            "You're ${(readiness.learningReadiness * 100).round()}% through the $careerTitle path.",
        priority: 2,
        createdAt: now,
      ));
    }

    // Project → versioned by projects completed.
    if (readiness.learningReadiness >= 0.4 && readiness.projectReadiness < 0.5) {
      final projectsCompleted = context.projectProgress.completedCount;
      recs.add(CopilotRecommendation(
        id: 'rec_project_$projectsCompleted',
        category: RecommendationCategory.project,
        title: 'Start a hands-on project',
        description: 'Projects turn lessons into proof for recruiters.',
        priority: 2,
        createdAt: now,
      ));
    }

    // Interview prep → versioned by interview-readiness bucket.
    if (readiness.learningReadiness >= 0.5 && readiness.interviewReadiness < 0.5) {
      final interviewBucket = (readiness.interviewReadiness * 10).floor();
      recs.add(CopilotRecommendation(
        id: 'rec_interview_prep_$interviewBucket',
        category: RecommendationCategory.interviewPrep,
        title: 'Prepare for interviews',
        description: 'Try a mock interview to see where you stand.',
        priority: 2,
        createdAt: now,
      ));
    }

    // Job match → versioned by job-readiness bucket.
    if (readiness.jobReadiness >= 0.6) {
      final jobBucket = (readiness.jobReadiness * 10).floor();
      recs.add(CopilotRecommendation(
        id: 'rec_job_match_$jobBucket',
        category: RecommendationCategory.jobMatch,
        title: "You're looking job-ready",
        description:
            'Consider applying to $careerTitle openings that match your skills.',
        priority: 1,
        createdAt: now,
      ));
    }

    // Streak nudge → versioned by progress-history length.
    if (_state.currentStreak == 0 && context.state.progressHistory.isNotEmpty) {
      final historyDays = context.state.progressHistory.length;
      recs.add(CopilotRecommendation(
        id: 'rec_streak_nudge_$historyDays',
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
class _CareerSkill {
  final String name;
  final SkillLevel required;
  final int priority;
  final String reason;

  const _CareerSkill(this.name, this.required, this.priority, this.reason);
}

// ── Career-aware roadmap spec ──────────────────────────────────────────
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

/// Career-specific roadmap table.
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

  // ── Software Engineer ──────────────────────────────────────────────
  'software_engineer': const _CareerRoadmapSpec([
    _RoadmapPhaseSpec(
      title: 'Programming Foundations',
      description:
          'One language deeply, clean code habits, and version control.',
      skills: ['Python', 'Git', 'Testing', 'Command Line'],
      resources: [
        _RoadmapResourceSpec(
          title: 'CS50: Introduction to Computer Science',
          platform: 'Harvard / edX',
          url: 'https://cs50.harvard.edu/x/',
          isFree: true,
          duration: '10 weeks',
          icon: '💻',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Data Structures & Algorithms',
      description:
          'The core toolkit for every technical interview.',
      skills: ['Data Structures & Algorithms', 'Big-O', 'Problem Solving'],
      resources: [
        _RoadmapResourceSpec(
          title: 'NeetCode 150',
          platform: 'NeetCode',
          url: 'https://neetcode.io/practice',
          isFree: true,
          duration: '8 weeks',
          icon: '🧠',
        ),
      ],
      estimatedDuration: '8 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'System Design & Databases',
      description:
          'Design and reason about real, scalable systems.',
      skills: ['System Design', 'Databases', 'APIs'],
      resources: [
        _RoadmapResourceSpec(
          title: 'System Design Primer',
          platform: 'GitHub',
          url: 'https://github.com/donnemartin/system-design-primer',
          isFree: true,
          duration: '5 weeks',
          icon: '🏗️',
        ),
      ],
      estimatedDuration: '6 weeks',
    ),
    _RoadmapPhaseSpec(
      title: 'Portfolio & Job Ready',
      description:
          'Ship real projects, prepare stories, and start applying.',
      skills: ['Portfolio', 'Interview Prep', 'System Design'],
      resources: [
        _RoadmapResourceSpec(
          title: 'Tech Interview Handbook',
          platform: 'GitHub',
          url: 'https://github.com/yangshun/tech-interview-handbook',
          isFree: true,
          duration: '4 weeks',
          icon: '💼',
        ),
      ],
      estimatedDuration: '4 weeks',
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