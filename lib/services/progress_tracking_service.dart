// ══════════════════════════════════════════════════════════════════════
// lib/services/progress_tracking_service.dart
//
// CAREER PROGRESSION ENGINE — COMPATIBILITY + CONTEXT ADAPTER
//
// This service is a PURE calculation/adapter layer.
// • No Firestore
// • No Firebase
// • No network
// • No AI/API
// • No persistence
//
// CURRENT ARCHITECTURE
// --------------------
// Canonical CareerStage and CopilotContext live in copilot_models.dart.
// CopilotController / Firestore / Readiness Engine own the authoritative
// data. This service only converts that real data into presentation-safe
// progress snapshots.
//
// BACKWARD COMPATIBILITY
// ----------------------
// The legacy UserProfile-based public methods remain available so existing
// callers continue to compile. They are now mapped onto the CANONICAL
// CareerStage enum instead of defining a second CareerStage.
//
// IMPORTANT
// ---------
// Do not use this service as a second readiness engine. When a
// CopilotContext is available, its CareerReadiness values are treated as the
// already-computed derived readiness snapshot. This service does not
// recalculate career-specific readiness from guesses.
//
// ══════════════════════════════════════════════════════════════════════

import '../models/copilot_models.dart';
import '../models/user_profile.dart';

/// Immutable presentation snapshot.
///
/// `stageProgress` uses the canonical [CareerStage] from
/// `copilot_models.dart`. It contains the 11-stage career pipeline:
///
/// Exploration → Assessment → Learning → Practice → Projects →
/// Portfolio → CV Ready → Interview Prep → Job Search → Job Ready → Growth
///
/// The snapshot is runtime-only. It is not persisted by this service.
class CareerProgressSnapshot {
  final Map<CareerStage, double> stageProgress; // each 0-100
  final double overallProgress; // 0-100
  final int jobReadinessScore; // 0-100 summary
  final int interviewReadinessScore; // 0-100 summary
  final String? nextMilestone;
  final String motivationalMessage;

  const CareerProgressSnapshot({
    required this.stageProgress,
    required this.overallProgress,
    required this.jobReadinessScore,
    required this.interviewReadinessScore,
    required this.nextMilestone,
    required this.motivationalMessage,
  });

  /// Returns 0 when a stage is not present.
  double progressFor(CareerStage stage) => stageProgress[stage] ?? 0;
}

class ProgressTrackingService {
  // ════════════════════════════════════════════════════════════════════
  // SHARED LEGACY DEFAULTS
  // ════════════════════════════════════════════════════════════════════

  static const int _defaultTotalRoadmapSteps = 10;
  static const int _defaultTargetSkills = 15;
  static const int _defaultTargetDsaProblems = 100;
  static const int _defaultTargetProjects = 5;
  static const int _defaultTargetPortfolio = 3;
  static const int _defaultTargetInterviews = 10;
  static const int _defaultTargetApplications = 10;

  static const double _milestoneThreshold = 70.0;

  // Legacy readiness weights. Preserved so the old UserProfile API keeps
  // the same mathematical behaviour.
  static const double _wSkills = 0.20;
  static const double _wLearning = 0.10;
  static const double _wRoadmap = 0.10;
  static const double _wDsa = 0.15;
  static const double _wProjects = 0.15;
  static const double _wPortfolio = 0.10;
  static const double _wInterview = 0.20;

  static const double _maxApplicationBonus = 10.0;

  // Canonical pipeline order. The enum itself is owned by copilot_models.dart.
  static const List<CareerStage> canonicalStageOrder = [
    CareerStage.exploration,
    CareerStage.assessment,
    CareerStage.learning,
    CareerStage.practice,
    CareerStage.projects,
    CareerStage.portfolio,
    CareerStage.cvReady,
    CareerStage.interviewPrep,
    CareerStage.jobSearch,
    CareerStage.jobReady,
    CareerStage.growth,
  ];

  // Overall display weights. Unknown stages remain zero rather than being
  // fabricated. The weights sum to 1.0.
  static const Map<CareerStage, double> _canonicalOverallWeights = {
    CareerStage.exploration: 0.05,
    CareerStage.assessment: 0.05,
    CareerStage.learning: 0.12,
    CareerStage.practice: 0.10,
    CareerStage.projects: 0.14,
    CareerStage.portfolio: 0.10,
    CareerStage.cvReady: 0.08,
    CareerStage.interviewPrep: 0.12,
    CareerStage.jobSearch: 0.07,
    CareerStage.jobReady: 0.12,
    CareerStage.growth: 0.05,
  };

  // ════════════════════════════════════════════════════════════════════
  // CURRENT ARCHITECTURE API — COPILOT CONTEXT
  // ════════════════════════════════════════════════════════════════════

  /// Builds a progress snapshot from the CURRENT canonical CopilotContext.
  ///
  /// Data ownership:
  /// • career                → Exploration
  /// • skill gaps            → Assessment evidence
  /// • learningProgress     → Learning
  /// • projectProgress       → Projects
  /// • portfolioReadiness    → Portfolio
  /// • cvReadiness           → CV Ready
  /// • interviewProgress     → Interview Prep
  /// • jobProgress           → Job Search
  /// • readiness.jobReadiness→ Job Ready
  ///
  /// Stages for which the current model exposes no direct aggregate
  /// (Practice and Growth) intentionally remain 0. No indirect signal is
  /// invented from XP, streaks, skill names, or recommendations.
  static CareerProgressSnapshot getCopilotProgressSnapshot(
    CopilotContext context, {
    int targetInterviews = _defaultTargetInterviews,
    int targetApplications = _defaultTargetApplications,
  }) {
    final stages = <CareerStage, double>{
      for (final stage in canonicalStageOrder) stage: 0.0,
    };
    final knownSignals = <CareerStage>{};

    // Exploration is a concrete selection event: an active CareerContext
    // means the user has selected a career.
    stages[CareerStage.exploration] = _hasActiveCareer(context) ? 100.0 : 0.0;
    knownSignals.add(CareerStage.exploration);

    // Assessment is considered evidenced only when the Copilot has actual
    // skill-gap output. An empty list is not interpreted as "assessment done".
    stages[CareerStage.assessment] =
        context.state.skillGaps.isNotEmpty ? 100.0 : 0.0;
    if (context.state.skillGaps.isNotEmpty) {
      knownSignals.add(CareerStage.assessment);
    }

    // Learning uses the canonical career-scoped lesson aggregate.
    if (context.learningProgress.totalLessons > 0) {
      stages[CareerStage.learning] = _ratioToPct(
        context.learningProgress.completedCount,
        context.learningProgress.totalLessons,
      );
      knownSignals.add(CareerStage.learning);
    }

    // Practice has no canonical count aggregate in MODEL CONTRACT v1.
    // Keep it at zero instead of treating skills/XP/lessons as practice.

    // Projects uses the canonical career-scoped project aggregate.
    if (context.projectProgress.totalProjects > 0) {
      stages[CareerStage.projects] = _ratioToPct(
        context.projectProgress.completedCount,
        context.projectProgress.totalProjects,
      );
      knownSignals.add(CareerStage.projects);
    }

    // Portfolio is derived from the readiness engine's portfolio summary.
    final portfolio = context.readiness.portfolioReadiness;
    if (portfolio != null && portfolio.targetCount > 0) {
      stages[CareerStage.portfolio] = _clampPct(portfolio.ratio * 100);
      knownSignals.add(CareerStage.portfolio);
    }

    // CV is derived from the readiness engine's explicit section flags.
    final cv = context.readiness.cvReadiness;
    if (cv != null) {
      stages[CareerStage.cvReady] = _clampPct(cv.ratio * 100);
      knownSignals.add(CareerStage.cvReady);
    }

    // Interview preparation is real attempt volume. A repeat attempt is
    // still meaningful practice, so attempts are counted. For legacy
    // aggregate-only documents, mockInterviewsDone is the available signal.
    final interviewCount = context.interviewProgress.attempts.isNotEmpty
        ? context.interviewProgress.attempts.length
        : context.interviewProgress.mockInterviewsDone;
    if (targetInterviews > 0) {
      stages[CareerStage.interviewPrep] = _ratioToPct(
        interviewCount,
        targetInterviews,
      );
      knownSignals.add(CareerStage.interviewPrep);
    }

    // Applications are job-search activity, not proof of job readiness.
    if (targetApplications > 0) {
      stages[CareerStage.jobSearch] = _ratioToPct(
        context.jobProgress.applicationsSent,
        targetApplications,
      );
      knownSignals.add(CareerStage.jobSearch);
    }

    // Job readiness belongs to the Readiness Engine. We display its current
    // derived value; we do not recompute a competing career-specific score.
    stages[CareerStage.jobReady] =
        _ratioToPctFromUnit(context.readiness.jobReadiness);
    knownSignals.add(CareerStage.jobReady);

    // Growth has no direct aggregate in MODEL CONTRACT v1. Do not infer it.

    final overall = _weightedOverall(
      stages,
      knownSignals: knownSignals,
    );

    final jobScore = _scoreFromUnit(context.readiness.jobReadiness);
    final interviewScore = _scoreFromUnit(context.readiness.interviewReadiness);

    final currentStage = context.currentStage;
    final nextMilestone = _nextCanonicalMilestone(
      stages,
      currentStage: currentStage,
      knownSignals: knownSignals,
    );

    return CareerProgressSnapshot(
      stageProgress: Map.unmodifiable(stages),
      overallProgress: overall,
      jobReadinessScore: jobScore,
      interviewReadinessScore: interviewScore,
      nextMilestone: nextMilestone,
      motivationalMessage: _motivationalMessageFromContext(context),
    );
  }

  /// Returns the current stage supplied by the progression/readiness layer.
  ///
  /// This is intentionally presentation-only. If no current-stage hint
  /// exists, it falls back to the first stage with incomplete progress.
  static CareerStage currentCanonicalStage(CopilotContext context) {
    final snapshot = getCopilotProgressSnapshot(context);
    if (context.currentStage != null) return context.currentStage!;

    for (final stage in canonicalStageOrder) {
      if (snapshot.progressFor(stage) < _milestoneThreshold) return stage;
    }
    return CareerStage.growth;
  }

  // ════════════════════════════════════════════════════════════════════
  // LEGACY UserProfile PUBLIC API — PRESERVED
  // ════════════════════════════════════════════════════════════════════

  static double calculateRoadmapProgress(int currentStep, int totalSteps) {
    if (totalSteps <= 0) return 0;
    return _clampPct((currentStep / totalSteps) * 100);
  }

  static int calculateJobReadinessScore(UserProfile user) {
    final skills = calculateSkillProgress(user);
    final learning = calculateLearningProgress(user);
    final roadmap = calculateRoadmapProgressForUser(user);
    final dsa = calculateDsaProgress(user);
    final projects = calculateProjectProgress(user);
    final portfolio = calculatePortfolioProgress(user);
    final interview = calculateInterviewReadinessScore(user).toDouble();
    final apps = calculateApplicationActivity(user);

    final preparation = (skills * _wSkills) +
        (learning * _wLearning) +
        (roadmap * _wRoadmap) +
        (dsa * _wDsa) +
        (projects * _wProjects) +
        (portfolio * _wPortfolio) +
        (interview * _wInterview);

    final bonus = (apps / 100.0) * _maxApplicationBonus;
    return _clampScore(preparation + bonus);
  }

  static int calculateInterviewReadinessScore(UserProfile user) {
    final practice = calculateInterviewPracticeProgress(user);
    final skills = calculateSkillProgress(user);
    final roadmap = calculateRoadmapProgressForUser(user);

    return _clampScore(
      (practice * 0.50) + (skills * 0.30) + (roadmap * 0.20),
    );
  }

  static String? getNextMilestone(UserProfile user) =>
      _nextLegacyMilestone(_legacyStageProgressMap(user));

  static String getMotivationalMessage(UserProfile user) {
    if (user.dailyStreak >= 30) return 'Amazing consistency!';
    if (user.dailyStreak >= 7) return 'Great progress!';
    return 'Keep learning every day.';
  }

  /// Legacy snapshot retained for old callers.
  ///
  /// Its keys are now the canonical 11-stage [CareerStage] values. Signals
  /// unavailable in UserProfile remain 0.
  static CareerProgressSnapshot getProgressSnapshot(
    UserProfile user, {
    int totalRoadmapSteps = _defaultTotalRoadmapSteps,
    int targetSkillCount = _defaultTargetSkills,
    int? dsaProblemsCompleted,
    int targetDsaProblems = _defaultTargetDsaProblems,
    int? projectsCompleted,
    int targetProjects = _defaultTargetProjects,
    int? portfolioItemsCount,
    int targetPortfolioItems = _defaultTargetPortfolio,
    int targetInterviews = _defaultTargetInterviews,
    int targetApplications = _defaultTargetApplications,
  }) {
    final effectiveRoadmapSteps = _resolveTarget(
      user.totalRoadmapSteps,
      totalRoadmapSteps,
      _defaultTotalRoadmapSteps,
    );
    final effectiveSkillsTarget = _resolveTarget(
      user.targetSkillCount,
      targetSkillCount,
      _defaultTargetSkills,
    );
    final effectiveDsaTarget = _resolveTarget(
      user.dsaProblemsTarget,
      targetDsaProblems,
      _defaultTargetDsaProblems,
    );
    final effectiveProjectTarget = _resolveTarget(
      user.projectsTarget,
      targetProjects,
      _defaultTargetProjects,
    );
    final effectivePortfolioTarget = _resolveTarget(
      user.portfolioItemsTarget,
      targetPortfolioItems,
      _defaultTargetPortfolio,
    );
    final effectiveInterviewTarget = _resolveTarget(
      user.interviewsTarget,
      targetInterviews,
      _defaultTargetInterviews,
    );
    final effectiveApplicationTarget = _resolveTarget(
      user.applicationsTarget,
      targetApplications,
      _defaultTargetApplications,
    );

    final dsaCompleted =
        _resolveCount(user.dsaProblemsCompleted, dsaProblemsCompleted);
    final projectsCompletedCount =
        _resolveCount(user.projectsCompleted, projectsCompleted);
    final portfolioCount =
        _resolveCount(user.portfolioItemsCount, portfolioItemsCount);

    final learning = calculateLearningProgress(
      user,
      totalRoadmapSteps: effectiveRoadmapSteps,
    );
    final skills = _pct(user.skills.length, effectiveSkillsTarget);
    final roadmap = calculateRoadmapProgressForUser(
      user,
      totalRoadmapSteps: effectiveRoadmapSteps,
    );
    final dsa =
        dsaCompleted == null ? 0.0 : _pct(dsaCompleted, effectiveDsaTarget);
    final projects = projectsCompletedCount == null
        ? 0.0
        : _pct(projectsCompletedCount, effectiveProjectTarget);
    final portfolio = portfolioCount == null
        ? 0.0
        : _pct(portfolioCount, effectivePortfolioTarget);
    final interview = _pct(
      user.interviewsPracticed,
      effectiveInterviewTarget,
    );
    final applications = _pct(
      user.jobApplications,
      effectiveApplicationTarget,
    );

    // Legacy 7-stage preparation readiness. Kept mathematically compatible.
    final preparationStages = <CareerStage, double>{
      CareerStage.learning: learning,
      CareerStage.assessment: 0.0,
      CareerStage.practice: dsa,
      CareerStage.projects: projects,
      CareerStage.portfolio: portfolio,
      CareerStage.cvReady: 0.0,
      CareerStage.interviewPrep: interview,
    };

    final legacyJobReady = _legacyPreparationReadiness(
      learning: learning,
      skills: skills,
      roadmap: roadmap,
      dsa: dsa,
      projects: projects,
      portfolio: portfolio,
      interview: interview,
    ).toDouble();

    final stages = <CareerStage, double>{
      for (final stage in canonicalStageOrder) stage: 0.0,
      CareerStage.exploration: 0.0,
      CareerStage.assessment: 0.0,
      CareerStage.learning: learning,
      CareerStage.practice: dsa,
      CareerStage.projects: projects,
      CareerStage.portfolio: portfolio,
      CareerStage.cvReady: 0.0,
      CareerStage.interviewPrep: interview,
      CareerStage.jobSearch: applications,
      CareerStage.jobReady: legacyJobReady,
      CareerStage.growth: 0.0,
    };

    // Keep this variable deliberately evaluated so target resolution remains
    // part of the snapshot path without introducing unused warnings.
    final _ = preparationStages;

    final interviewReadiness = _clampScore(
      (interview * 0.50) + (skills * 0.30) + (roadmap * 0.20),
    );

    return CareerProgressSnapshot(
      stageProgress: Map.unmodifiable(stages),
      overallProgress: _weightedOverall(
        stages,
        knownSignals: {
          CareerStage.learning,
          CareerStage.practice,
          CareerStage.projects,
          CareerStage.portfolio,
          CareerStage.interviewPrep,
          CareerStage.jobSearch,
          CareerStage.jobReady,
        },
      ),
      jobReadinessScore: _clampScore(legacyJobReady),
      interviewReadinessScore: interviewReadiness,
      nextMilestone: _nextLegacyMilestone(stages),
      motivationalMessage: getMotivationalMessage(user),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // LEGACY INDIVIDUAL CALCULATORS
  // ════════════════════════════════════════════════════════════════════

  static double calculateSkillProgress(
    UserProfile user, {
    int targetSkillCount = _defaultTargetSkills,
  }) {
    final target = _resolveTarget(
      user.targetSkillCount,
      targetSkillCount,
      _defaultTargetSkills,
    );
    return _pct(user.skills.length, target);
  }

  static double calculateRoadmapProgressForUser(
    UserProfile user, {
    int totalRoadmapSteps = _defaultTotalRoadmapSteps,
  }) {
    final total = _resolveTarget(
      user.totalRoadmapSteps,
      totalRoadmapSteps,
      _defaultTotalRoadmapSteps,
    );
    return calculateRoadmapProgress(user.currentRoadmapStep ?? 0, total);
  }

  static double calculateLearningProgress(
    UserProfile user, {
    int totalRoadmapSteps = _defaultTotalRoadmapSteps,
  }) {
    final completed = user.completedLessons;
    final total = user.totalLessons;

    if (completed != null && total != null && total > 0) {
      return _pct(completed, total);
    }

    return calculateRoadmapProgressForUser(
      user,
      totalRoadmapSteps: totalRoadmapSteps,
    );
  }

  static double calculateDsaProgress(
    UserProfile user, {
    int? dsaProblemsCompleted,
    int targetDsaProblems = _defaultTargetDsaProblems,
  }) {
    final solved =
        _resolveCount(user.dsaProblemsCompleted, dsaProblemsCompleted);
    if (solved == null) return 0;

    final target = _resolveTarget(
      user.dsaProblemsTarget,
      targetDsaProblems,
      _defaultTargetDsaProblems,
    );
    return _pct(solved, target);
  }

  static double calculateProjectProgress(
    UserProfile user, {
    int? projectsCompleted,
    int targetProjects = _defaultTargetProjects,
  }) {
    final completed = _resolveCount(user.projectsCompleted, projectsCompleted);
    if (completed == null) return 0;

    final target = _resolveTarget(
      user.projectsTarget,
      targetProjects,
      _defaultTargetProjects,
    );
    return _pct(completed, target);
  }

  static double calculatePortfolioProgress(
    UserProfile user, {
    int? portfolioItemsCount,
    int targetPortfolioItems = _defaultTargetPortfolio,
  }) {
    final items = _resolveCount(user.portfolioItemsCount, portfolioItemsCount);
    if (items == null) return 0;

    final target = _resolveTarget(
      user.portfolioItemsTarget,
      targetPortfolioItems,
      _defaultTargetPortfolio,
    );
    return _pct(items, target);
  }

  static double calculateInterviewPracticeProgress(
    UserProfile user, {
    int targetInterviews = _defaultTargetInterviews,
  }) {
    final target = _resolveTarget(
      user.interviewsTarget,
      targetInterviews,
      _defaultTargetInterviews,
    );
    return _pct(user.interviewsPracticed, target);
  }

  static double calculateApplicationActivity(
    UserProfile user, {
    int targetApplications = _defaultTargetApplications,
  }) {
    final target = _resolveTarget(
      user.applicationsTarget,
      targetApplications,
      _defaultTargetApplications,
    );
    return _pct(user.jobApplications, target);
  }

  // ════════════════════════════════════════════════════════════════════
  // LEGACY INTERNAL CALCULATIONS
  // ════════════════════════════════════════════════════════════════════

  static int _legacyPreparationReadiness({
    required double skills,
    required double learning,
    required double roadmap,
    required double dsa,
    required double projects,
    required double portfolio,
    required double interview,
  }) {
    final preparation = (skills * _wSkills) +
        (learning * _wLearning) +
        (roadmap * _wRoadmap) +
        (dsa * _wDsa) +
        (projects * _wProjects) +
        (portfolio * _wPortfolio) +
        (interview * _wInterview);

    return _clampScore(preparation);
  }

  static Map<CareerStage, double> _legacyStageProgressMap(
    UserProfile user,
  ) {
    final learning = calculateLearningProgress(user);
    final skills = calculateSkillProgress(user);
    final roadmap = calculateRoadmapProgressForUser(user);
    final dsa = calculateDsaProgress(user);
    final projects = calculateProjectProgress(user);
    final portfolio = calculatePortfolioProgress(user);
    final interview = calculateInterviewPracticeProgress(user);
    final applications = calculateApplicationActivity(user);

    return {
      CareerStage.exploration: 0,
      CareerStage.assessment: 0,
      CareerStage.learning: learning,
      CareerStage.practice: dsa,
      CareerStage.projects: projects,
      CareerStage.portfolio: portfolio,
      CareerStage.cvReady: 0,
      CareerStage.interviewPrep: interview,
      CareerStage.jobSearch: applications,
      CareerStage.jobReady: _legacyPreparationReadiness(
        skills: skills,
        learning: learning,
        roadmap: roadmap,
        dsa: dsa,
        projects: projects,
        portfolio: portfolio,
        interview: interview,
      ).toDouble(),
      CareerStage.growth: 0,
    };
  }

  static String? _nextLegacyMilestone(
    Map<CareerStage, double> stages,
  ) {
    const order = [
      CareerStage.learning,
      CareerStage.practice,
      CareerStage.projects,
      CareerStage.portfolio,
      CareerStage.interviewPrep,
      CareerStage.jobSearch,
    ];

    for (final stage in order) {
      if ((stages[stage] ?? 0) < _milestoneThreshold) {
        return _milestoneMessage(stage);
      }
    }

    return 'Apply for jobs';
  }

  // ════════════════════════════════════════════════════════════════════
  // CURRENT CONTEXT HELPERS
  // ════════════════════════════════════════════════════════════════════

  static bool _hasActiveCareer(CopilotContext context) {
    final id = context.career?.careerId.trim();
    return id != null && id.isNotEmpty;
  }

  static double _ratioToPct(int completed, int target) {
    if (target <= 0 || completed <= 0) return 0;
    return _clampPct((completed / target) * 100);
  }

  static double _ratioToPctFromUnit(double value) {
    if (value.isNaN || value.isInfinite) return 0;
    return _clampPct(value.clamp(0.0, 1.0) * 100);
  }

  static int _scoreFromUnit(double value) {
    if (value.isNaN || value.isInfinite) return 0;
    return _clampScore(value.clamp(0.0, 1.0) * 100);
  }

  static double _weightedOverall(
    Map<CareerStage, double> stages, {
    Set<CareerStage>? knownSignals,
  }) {
    double weightedSum = 0;
    double usedWeight = 0;

    for (final entry in _canonicalOverallWeights.entries) {
      final value = _clampPct(stages[entry.key] ?? 0);
      final weight = entry.value;

      // If a caller supplied an explicit known-signal set, only those stages
      // participate. This prevents unavailable aggregates from silently
      // depressing the user's overall progress.
      if (knownSignals != null && !knownSignals.contains(entry.key)) {
        continue;
      }

      weightedSum += value * weight;
      usedWeight += weight;
    }

    if (usedWeight <= 0) return 0;
    return _clampPct(weightedSum / usedWeight);
  }

  static String? _nextCanonicalMilestone(
    Map<CareerStage, double> stages, {
    CareerStage? currentStage,
    Set<CareerStage>? knownSignals,
  }) {
    // If the progression engine explicitly supplies a current stage, use it
    // as the presentation hint. The service still does not decide readiness.
    if (currentStage != null) {
      final currentValue = stages[currentStage] ?? 0;
      if (currentValue < _milestoneThreshold) {
        return _milestoneMessage(currentStage);
      }
    }

    for (final stage in canonicalStageOrder) {
      final value = stages[stage] ?? 0;
      if (knownSignals != null && !knownSignals.contains(stage)) continue;
      if (value < _milestoneThreshold) {
        return _milestoneMessage(stage);
      }
    }

    return _milestoneMessage(CareerStage.jobReady);
  }

  static String _milestoneMessage(CareerStage stage) {
    switch (stage) {
      case CareerStage.exploration:
        return 'Choose your target career';
      case CareerStage.assessment:
        return 'Complete your skill assessment';
      case CareerStage.learning:
        return 'Continue your learning roadmap';
      case CareerStage.practice:
        return 'Build deliberate practice evidence';
      case CareerStage.projects:
        return 'Build more projects';
      case CareerStage.portfolio:
        return 'Strengthen your portfolio';
      case CareerStage.cvReady:
        return 'Complete your CV';
      case CareerStage.interviewPrep:
        return 'Practice interviews';
      case CareerStage.jobSearch:
        return 'Start applying for jobs';
      case CareerStage.jobReady:
        return 'Reach your career readiness bar';
      case CareerStage.growth:
        return 'Continue professional growth';
    }
  }

  static String _motivationalMessageFromContext(CopilotContext context) {
    final history = context.state.progressHistory;
    if (history.isEmpty) return 'Start your next meaningful career action.';

    final activeGoals =
        history.fold<int>(0, (sum, e) => sum + e.goalsCompleted);

    if (activeGoals >= 30) return 'Amazing consistency!';
    if (activeGoals >= 7) return 'Great progress!';
    return 'Keep moving forward.';
  }

  // ════════════════════════════════════════════════════════════════════
  // NUMERIC HELPERS
  // ════════════════════════════════════════════════════════════════════

  static int _resolveTarget(
    int? profileValue,
    int? callerValue,
    int fallback,
  ) {
    if (profileValue != null && profileValue > 0) return profileValue;
    if (callerValue != null && callerValue > 0) return callerValue;
    return fallback;
  }

  static int? _resolveCount(int? profileValue, int? callerValue) {
    if (profileValue != null && profileValue >= 0) return profileValue;
    if (callerValue != null && callerValue >= 0) return callerValue;
    return null;
  }

  static double _pct(num value, num target) {
    if (target <= 0) return 0;
    return _clampPct((value / target) * 100);
  }

  static double _clampPct(num value) {
    if (value.isNaN || value.isInfinite) return 0;
    return value.clamp(0, 100).toDouble();
  }

  static int _clampScore(num value) {
    if (value.isNaN || value.isInfinite) return 0;
    return value.round().clamp(0, 100).toInt();
  }
}
