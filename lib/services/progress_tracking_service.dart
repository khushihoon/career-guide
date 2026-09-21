// ══════════════════════════════════════════════════════════════════════
// lib/services/progress_tracking_service.dart
//
// Career Progress Tracking Engine — pure calculation, no persistence, no
// network, no decision-making. This service turns the user's real,
// already-tracked data (UserProfile) into accurate, null-safe progress
// percentages across the full professional pipeline:
//
//   Learning → Skills → Roadmap → DSA → Projects → Portfolio →
//   Interview → Job Ready
//
// ══════════════════════════════════════════════════════════════════════
// BACKWARD COMPATIBILITY
// ══════════════════════════════════════════════════════════════════════
// Every original public method keeps its exact signature and return
// type, so every existing call site keeps compiling and working:
//   • calculateRoadmapProgress(int currentStep, int totalSteps) → double
//   • calculateJobReadinessScore(UserProfile user)               → int
//   • calculateInterviewReadinessScore(UserProfile user)         → int
//   • getNextMilestone(UserProfile user)                         → String?
//   • getMotivationalMessage(UserProfile user)                   → String
//
// ══════════════════════════════════════════════════════════════════════
// DATA HONESTY
// ══════════════════════════════════════════════════════════════════════
// Every stage is computed from REAL UserProfile counts and targets:
// completedLessons/totalLessons, currentRoadmapStep/totalRoadmapSteps,
// skills/targetSkillCount, dsaProblemsCompleted/dsaProblemsTarget,
// projectsCompleted/projectsTarget, portfolioItemsCount/
// portfolioItemsTarget, interviewsPracticed/interviewsTarget, and
// jobApplications/applicationsTarget.
//
// This service NEVER infers completed DSA practice, projects, or
// portfolio items from badge names, skill names, keywords, or any other
// indirect signal. When a real count is unavailable for a stage, that
// stage's progress is 0 for this calculation — never a fabricated
// number. Only the Learning stage has a well-defined fallback (roadmap
// step), because the two signals track the same underlying progression
// and lesson-level data is optional on older profiles.
//
// This service does not duplicate CopilotController's intelligence or
// Next-Best-Action engine — it names the earliest incomplete stage in
// the pipeline, nothing more.
//
// ══════════════════════════════════════════════════════════════════════
// JOB-READY SEMANTICS
// ══════════════════════════════════════════════════════════════════════
// Job Applications are job-search ACTIVITY, not preparation, and are
// NEVER treated as proof of job readiness.
//
// [UserProfile] exposes no single genuine "job readiness" field, so the
// Job Ready stage is derived from the SAME real preparation signals the
// headline readiness composite uses: skills, learning, roadmap, DSA,
// projects, portfolio, and interview practice. This keeps the stage
// honest (no fabricated signal, no application-derived readiness) and
// internally consistent with [calculateJobReadinessScore].
//
//   • [CareerStage.jobReady] is the preparation-derived readiness score
//     (0-100) computed by the same weighted composite used by
//     [_jobReadinessFromStages]. It is NOT derived from application
//     counts and does NOT read [calculateApplicationActivity].
//   • [calculateJobReadinessScore] remains the public readiness entry
//     point and additionally applies the bounded application-activity
//     bonus, capped at [_maxApplicationBonus], preserving backward
//     compatibility without claiming applications equal readiness.
//   • [calculateApplicationActivity] is preserved unchanged so any
//     existing call site can still read job-search activity as its own
//     separate signal.
//
// No circular dependency exists: [_jobReadinessFromStages] reads only
// the seven preparation stage values and NEVER reads
// `stages[CareerStage.jobReady]`.
//
// This service never fabricates interview scores, job-readiness scores,
// or any other data not present on [UserProfile].
// ══════════════════════════════════════════════════════════════════════

import '../models/user_profile.dart';

/// One stage in the real career pipeline this service tracks.
enum CareerStage {
  learning,
  skills,
  roadmap,
  dsa,
  projects,
  portfolio,
  interview,
  jobReady,
}

extension CareerStageX on CareerStage {
  String get label {
    switch (this) {
      case CareerStage.learning:  return 'Learning';
      case CareerStage.skills:    return 'Skills';
      case CareerStage.roadmap:   return 'Roadmap';
      case CareerStage.dsa:       return 'DSA';
      case CareerStage.projects:  return 'Projects';
      case CareerStage.portfolio: return 'Portfolio';
      case CareerStage.interview: return 'Interview';
      case CareerStage.jobReady:  return 'Job Ready';
    }
  }
}

/// Immutable snapshot of a user's progress across every pipeline stage,
/// plus the two headline readiness scores. Pure calculation result —
/// carries no logic itself and is not persisted by this service.
class CareerProgressSnapshot {
  final Map<CareerStage, double> stageProgress; // each 0-100
  final double overallProgress;                 // 0-100, weighted
  final int jobReadinessScore;                  // 0-100
  final int interviewReadinessScore;            // 0-100
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

  /// Convenience accessor — returns 0 for a stage that's somehow missing
  /// from the map instead of throwing.
  double progressFor(CareerStage stage) => stageProgress[stage] ?? 0;
}

class ProgressTrackingService {
  // ════════════════════════════════════════════════════════════════════
  // SHARED CONFIGURATION
  // ════════════════════════════════════════════════════════════════════
  //
  // Every default target used anywhere in this file lives here exactly
  // once. Every calculator and every readiness composite reads from
  // these constants so they can never silently disagree about what a
  // completed target means.

  static const int _defaultTotalRoadmapSteps  = 10;
  static const int _defaultTargetSkills       = 15;
  static const int _defaultTargetDsaProblems  = 100;
  static const int _defaultTargetProjects     = 5;
  static const int _defaultTargetPortfolio    = 3;
  static const int _defaultTargetInterviews   = 10;
  static const int _defaultTargetApplications = 10;

  /// Stage below which the pipeline considers a stage "not yet done" for
  /// the purpose of naming the next milestone.
  static const double _milestoneThreshold = 70.0;

  // Weights used for the headline Job Readiness composite. These reflect
  // preparation, not job-search activity. Applications are handled
  // separately as a small bonus (see _jobReadinessFromStages).
  //
  // Sum of preparation weights = 1.00.
  static const double _wSkills      = 0.20;
  static const double _wLearning    = 0.10;
  static const double _wRoadmap     = 0.10;
  static const double _wDsa         = 0.15;
  static const double _wProjects    = 0.15;
  static const double _wPortfolio   = 0.10;
  static const double _wInterview   = 0.20;

  /// Maximum extra points the job-search activity signal can add on top
  /// of preparation — never a substitute for it.
  static const double _maxApplicationBonus = 10.0;

  /// Weights for the overall (multi-stage) career progress number. They
  /// sum to exactly 1.00 and lean slightly toward the later professional
  /// preparation stages so an early-stage-heavy user cannot appear
  /// strongly "overall complete" while later stages are missing.
  static const Map<CareerStage, double> _overallWeights = {
    CareerStage.learning:  0.12,
    CareerStage.skills:    0.13,
    CareerStage.roadmap:   0.10,
    CareerStage.dsa:       0.15,
    CareerStage.projects:  0.15,
    CareerStage.portfolio: 0.10,
    CareerStage.interview: 0.15,
    CareerStage.jobReady:  0.10,
  };

  // ════════════════════════════════════════════════════════════════════
  // PRESERVED PUBLIC API
  // ════════════════════════════════════════════════════════════════════

  /// Percentage (0-100) through a step-based sequence. Bounds-safe:
  /// non-positive [totalSteps] returns 0 (no div-by-zero / NaN), and the
  /// result is clamped to [0, 100] even if [currentStep] exceeds
  /// [totalSteps].
  static double calculateRoadmapProgress(int currentStep, int totalSteps) {
    if (totalSteps <= 0) return 0;
    return _clampPct((currentStep / totalSteps) * 100);
  }

  /// Overall job readiness, 0-100.
  ///
  /// Primarily preparation-driven: skills, learning, roadmap, DSA,
  /// projects, portfolio, and interview readiness. Job-search activity
  /// (applications submitted) contributes only as a small bonus capped
  /// at [_maxApplicationBonus] points — it can never make up for
  /// missing preparation and is never presented as readiness on its own.
  static int calculateJobReadinessScore(UserProfile user) {
    final skills    = calculateSkillProgress(user);
    final learning  = calculateLearningProgress(user);
    final roadmap   = calculateRoadmapProgressForUser(user);
    final dsa       = calculateDsaProgress(user);
    final projects  = calculateProjectProgress(user);
    final portfolio = calculatePortfolioProgress(user);
    final interview = calculateInterviewReadinessScore(user).toDouble();
    final apps      = calculateApplicationActivity(user);

    final preparation =
        (skills    * _wSkills)    +
        (learning  * _wLearning)  +
        (roadmap   * _wRoadmap)   +
        (dsa       * _wDsa)       +
        (projects  * _wProjects)  +
        (portfolio * _wPortfolio) +
        (interview * _wInterview);

    final bonus = (apps / 100.0) * _maxApplicationBonus;

    return _clampScore(preparation + bonus);
  }

  /// Interview readiness, 0-100.
  ///
  /// Weighted toward actual practice volume, with skill and roadmap
  /// progress as supporting factors — you can't be interview-ready on
  /// skills you haven't built yet. The only real interview signal this
  /// service has is [UserProfile.interviewsPracticed]; no interview
  /// scores or outcomes are fabricated or inferred.
  static int calculateInterviewReadinessScore(UserProfile user) {
    final practice = calculateInterviewPracticeProgress(user);
    final skills   = calculateSkillProgress(user);
    final roadmap  = calculateRoadmapProgressForUser(user);
    return _clampScore((practice * 0.50) + (skills * 0.30) + (roadmap * 0.20));
  }

  /// The single most useful next step, chosen by walking the real
  /// pipeline in order and returning the first stage that isn't
  /// meaningfully progressed yet. Returns "Apply for jobs" only when
  /// every preparation stage has crossed [_milestoneThreshold]; a user
  /// with high early-stage progress but missing later stages is never
  /// mislabelled as job ready.
  static String? getNextMilestone(UserProfile user) =>
      _nextMilestoneFromStages(_stageProgressMap(user));

  /// Short, streak-aware encouragement. Logic and thresholds unchanged
  /// from the original implementation.
  static String getMotivationalMessage(UserProfile user) {
    if (user.dailyStreak >= 30) {
      return 'Amazing consistency!';
    }
    if (user.dailyStreak >= 7) {
      return 'Great progress!';
    }
    return 'Keep learning every day.';
  }

  // ════════════════════════════════════════════════════════════════════
  // FULL-PIPELINE SNAPSHOT
  // ════════════════════════════════════════════════════════════════════

  /// Computes progress across every stage in one call. All override
  /// parameters are optional with sensible defaults, so this works out
  /// of the box from just a UserProfile.
  ///
  /// Snapshot consistency: stage progress, overall progress, and both
  /// readiness scores are all computed from the SAME effective targets
  /// resolved here (profile value first, then caller override, then
  /// shared default). No hidden defaults are used anywhere downstream.
  ///
  /// The [CareerStage.jobReady] stage value equals the preparation-based
  /// readiness score produced by [_jobReadinessFromStages], so the Job
  /// Ready stage in the map is internally consistent with the public
  /// readiness composite. It is NOT derived from application activity.
  static CareerProgressSnapshot getProgressSnapshot(
    UserProfile user, {
    int totalRoadmapSteps  = _defaultTotalRoadmapSteps,
    int targetSkillCount   = _defaultTargetSkills,
    int? dsaProblemsCompleted,
    int targetDsaProblems  = _defaultTargetDsaProblems,
    int? projectsCompleted,
    int targetProjects     = _defaultTargetProjects,
    int? portfolioItemsCount,
    int targetPortfolioItems = _defaultTargetPortfolio,
    int targetInterviews   = _defaultTargetInterviews,
    int targetApplications = _defaultTargetApplications,
  }) {
    // Resolve effective targets once, up front. Every number below
    // (stage map + readiness) is then derived from these same values.
    final effRoadmapSteps  = _resolveTarget(
        user.totalRoadmapSteps, totalRoadmapSteps, _defaultTotalRoadmapSteps);
    final effSkillsTarget  = _resolveTarget(
        user.targetSkillCount, targetSkillCount, _defaultTargetSkills);
    final effDsaTarget     = _resolveTarget(
        user.dsaProblemsTarget, targetDsaProblems, _defaultTargetDsaProblems);
    final effProjectTarget = _resolveTarget(
        user.projectsTarget, targetProjects, _defaultTargetProjects);
    final effPortfolioTarget = _resolveTarget(
        user.portfolioItemsTarget, targetPortfolioItems, _defaultTargetPortfolio);
    final effInterviewTarget = _resolveTarget(
        user.interviewsTarget, targetInterviews, _defaultTargetInterviews);
    final effApplicationTarget = _resolveTarget(
        user.applicationsTarget, targetApplications, _defaultTargetApplications);

    final effDsaCompleted = _resolveCount(
        user.dsaProblemsCompleted, dsaProblemsCompleted);
    final effProjectsCompleted = _resolveCount(
        user.projectsCompleted, projectsCompleted);
    final effPortfolioCount = _resolveCount(
        user.portfolioItemsCount, portfolioItemsCount);

    final stages = _stageProgressMap(
      user,
      effectiveRoadmapSteps:  effRoadmapSteps,
      effectiveSkillsTarget:  effSkillsTarget,
      effectiveDsaTarget:     effDsaTarget,
      effectiveProjectTarget: effProjectTarget,
      effectivePortfolioTarget: effPortfolioTarget,
      effectiveInterviewTarget: effInterviewTarget,
      effectiveApplicationTarget: effApplicationTarget,
      effectiveDsaCompleted:     effDsaCompleted,
      effectiveProjectsCompleted: effProjectsCompleted,
      effectivePortfolioCount:    effPortfolioCount,
    );

    final overall       = _weightedOverallFromStages(stages);
    // Job readiness is derived from preparation stages only and never
    // reads stages[CareerStage.jobReady], so there is no circularity.
    // The map's jobReady value is already equal to this same score, so
    // both stay consistent by construction.
    final jobReady      = _jobReadinessFromStages(stages);
    final interviewRdy  = _interviewReadinessFromStages(stages);

    return CareerProgressSnapshot(
      stageProgress: stages,
      overallProgress: overall,
      jobReadinessScore: jobReady,
      interviewReadinessScore: interviewRdy.round(),
      nextMilestone: _nextMilestoneFromStages(stages),
      motivationalMessage: getMotivationalMessage(user),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // INDIVIDUAL STAGE CALCULATORS (null-safe, 0-100 clamped)
  // ════════════════════════════════════════════════════════════════════

  /// Skills stage: how many skills logged vs. a realistic target for a
  /// job-ready profile. Prefers the user's real targetSkillCount when
  /// set; falls back to [targetSkillCount] otherwise.
  static double calculateSkillProgress(
    UserProfile user, {
    int targetSkillCount = _defaultTargetSkills,
  }) {
    final target = _resolveTarget(
        user.targetSkillCount, targetSkillCount, _defaultTargetSkills);
    return _pct(user.skills.length, target);
  }

  /// Roadmap stage, computed from currentRoadmapStep / totalRoadmapSteps.
  /// Prefers user.totalRoadmapSteps when set.
  static double calculateRoadmapProgressForUser(
    UserProfile user, {
    int totalRoadmapSteps = _defaultTotalRoadmapSteps,
  }) {
    final total = _resolveTarget(
        user.totalRoadmapSteps, totalRoadmapSteps, _defaultTotalRoadmapSteps);
    return calculateRoadmapProgress(user.currentRoadmapStep ?? 0, total);
  }

  /// Learning stage. Prefers real lesson-completion data
  /// (completedLessons / totalLessons) when the profile has it. When
  /// that data isn't available (older profiles), falls back to roadmap
  /// progress as the signal, since lesson completion and roadmap
  /// progress track the same underlying progression.
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

  /// DSA stage. Uses the user's real dsaProblemsCompleted /
  /// dsaProblemsTarget, or the caller override if the profile has none.
  /// If no real count exists anywhere, returns 0 — this service does not
  /// infer DSA practice from any other signal.
  static double calculateDsaProgress(
    UserProfile user, {
    int? dsaProblemsCompleted,
    int targetDsaProblems = _defaultTargetDsaProblems,
  }) {
    final solved = _resolveCount(
        user.dsaProblemsCompleted, dsaProblemsCompleted);
    if (solved == null) return 0;
    final target = _resolveTarget(
        user.dsaProblemsTarget, targetDsaProblems, _defaultTargetDsaProblems);
    return _pct(solved, target);
  }

  /// Projects stage. Uses the user's real projectsCompleted /
  /// projectsTarget, or the caller override. If no real count exists,
  /// returns 0 — badges or other indirect signals are never treated as
  /// completed projects.
  static double calculateProjectProgress(
    UserProfile user, {
    int? projectsCompleted,
    int targetProjects = _defaultTargetProjects,
  }) {
    final completed = _resolveCount(
        user.projectsCompleted, projectsCompleted);
    if (completed == null) return 0;
    final target = _resolveTarget(
        user.projectsTarget, targetProjects, _defaultTargetProjects);
    return _pct(completed, target);
  }

  /// Portfolio stage. Uses the user's real portfolioItemsCount /
  /// portfolioItemsTarget, or the caller override. If no real count
  /// exists, returns 0 — no indirect signal is treated as portfolio
  /// content.
  static double calculatePortfolioProgress(
    UserProfile user, {
    int? portfolioItemsCount,
    int targetPortfolioItems = _defaultTargetPortfolio,
  }) {
    final items = _resolveCount(
        user.portfolioItemsCount, portfolioItemsCount);
    if (items == null) return 0;
    final target = _resolveTarget(
        user.portfolioItemsTarget, targetPortfolioItems, _defaultTargetPortfolio);
    return _pct(items, target);
  }

  /// Raw interview PRACTICE volume (0-100), independent of the broader,
  /// composite [calculateInterviewReadinessScore]. This is the "have you
  /// actually done the interview-stage action" signal used in the
  /// stage-progress map. Prefers user.interviewsTarget when set.
  ///
  /// Practice volume is the only real interview signal on [UserProfile];
  /// no interview scores, outcomes, or inferred quality are used.
  static double calculateInterviewPracticeProgress(
    UserProfile user, {
    int targetInterviews = _defaultTargetInterviews,
  }) {
    final target = _resolveTarget(
        user.interviewsTarget, targetInterviews, _defaultTargetInterviews);
    return _pct(user.interviewsPracticed, target);
  }

  /// Job-search ACTIVITY (0-100) — how many applications submitted vs.
  /// a realistic target. This is job-search ACTIVITY, NOT readiness.
  /// It must never be presented as proof of job readiness; the headline
  /// readiness score treats it only as a bounded bonus on top of
  /// preparation. Prefers user.applicationsTarget when set.
  ///
  /// Preserved as a separate public signal for backward compatibility;
  /// it is NOT used as the [CareerStage.jobReady] stage percentage.
  static double calculateApplicationActivity(
    UserProfile user, {
    int targetApplications = _defaultTargetApplications,
  }) {
    final target = _resolveTarget(
        user.applicationsTarget, targetApplications, _defaultTargetApplications);
    return _pct(user.jobApplications, target);
  }

  // ════════════════════════════════════════════════════════════════════
  // PRIVATE: readiness composites derived from a stage map
  // ════════════════════════════════════════════════════════════════════

  /// Job readiness derived entirely from the stage map so it stays
  /// internally consistent with [getProgressSnapshot].
  ///
  /// This composite reads ONLY the seven preparation stages — skills,
  /// learning, roadmap, DSA, projects, portfolio, and interview. It
  /// NEVER reads `stages[CareerStage.jobReady]`, so there is no circular
  /// dependency, and it is safe to use as the value of that stage.
  ///
  /// Job Applications are NOT part of this composite — they are
  /// job-search ACTIVITY, not preparation. The public
  /// [calculateJobReadinessScore] applies the bounded application bonus
  /// on top of this preparation-derived score.
  static int _jobReadinessFromStages(Map<CareerStage, double> stages) {
    final skills    = stages[CareerStage.skills]    ?? 0;
    final learning  = stages[CareerStage.learning]  ?? 0;
    final roadmap   = stages[CareerStage.roadmap]   ?? 0;
    final dsa       = stages[CareerStage.dsa]       ?? 0;
    final projects  = stages[CareerStage.projects]  ?? 0;
    final portfolio = stages[CareerStage.portfolio] ?? 0;
    final interview = _interviewReadinessFromStages(stages);

    final preparation =
        (skills    * _wSkills)    +
        (learning  * _wLearning)  +
        (roadmap   * _wRoadmap)   +
        (dsa       * _wDsa)       +
        (projects  * _wProjects)  +
        (portfolio * _wPortfolio) +
        (interview * _wInterview);

    return _clampScore(preparation);
  }

  /// Interview readiness derived from the stage map (practice volume,
  /// skills, roadmap) so it matches the snapshot's effective targets.
  /// Uses only real [UserProfile] signals — practice volume is the
  /// [CareerStage.interview] stage value; no fabricated scores.
  static double _interviewReadinessFromStages(Map<CareerStage, double> stages) {
    final practice = stages[CareerStage.interview] ?? 0;
    final skills   = stages[CareerStage.skills]    ?? 0;
    final roadmap  = stages[CareerStage.roadmap]   ?? 0;
    return _clampPct((practice * 0.50) + (skills * 0.30) + (roadmap * 0.20));
  }

  // ════════════════════════════════════════════════════════════════════
  // PRIVATE: stage map + milestone resolution
  // ════════════════════════════════════════════════════════════════════

  /// Builds the stage map using caller-supplied effective targets/counts
  /// directly (no further resolution). Callers that want profile-then-
  /// override semantics should resolve once up front — see
  /// [getProgressSnapshot] — and pass the resolved values here.
  ///
  /// [CareerStage.jobReady] is the preparation-derived readiness score
  /// produced by [_jobReadinessFromStages]. Because that composite reads
  /// only the seven preparation stages — never `stages[jobReady]` — the
  /// assignment here is well-defined and non-circular. Application
  /// activity is NOT used as the Job Ready stage percentage.
  static Map<CareerStage, double> _stageProgressMap(
    UserProfile user, {
    int? effectiveRoadmapSteps,
    int? effectiveSkillsTarget,
    int? effectiveDsaTarget,
    int? effectiveProjectTarget,
    int? effectivePortfolioTarget,
    int? effectiveInterviewTarget,
    int? effectiveApplicationTarget,
    int? effectiveDsaCompleted,
    int? effectiveProjectsCompleted,
    int? effectivePortfolioCount,
  }) {
    final roadmapSteps  = effectiveRoadmapSteps  ?? _resolveTarget(
        user.totalRoadmapSteps, null, _defaultTotalRoadmapSteps);
    final skillsTarget  = effectiveSkillsTarget  ?? _resolveTarget(
        user.targetSkillCount, null, _defaultTargetSkills);
    final dsaTarget     = effectiveDsaTarget     ?? _resolveTarget(
        user.dsaProblemsTarget, null, _defaultTargetDsaProblems);
    final projectTarget = effectiveProjectTarget ?? _resolveTarget(
        user.projectsTarget, null, _defaultTargetProjects);
    final portfolioTarget = effectivePortfolioTarget ?? _resolveTarget(
        user.portfolioItemsTarget, null, _defaultTargetPortfolio);
    final interviewTarget = effectiveInterviewTarget ?? _resolveTarget(
        user.interviewsTarget, null, _defaultTargetInterviews);

    final dsaCompleted = effectiveDsaCompleted
        ?? _resolveCount(user.dsaProblemsCompleted, null);
    final projectsCompleted = effectiveProjectsCompleted
        ?? _resolveCount(user.projectsCompleted, null);
    final portfolioCount = effectivePortfolioCount
        ?? _resolveCount(user.portfolioItemsCount, null);

    final learning = calculateLearningProgress(
      user,
      totalRoadmapSteps: roadmapSteps,
    );
    final skills = _pct(user.skills.length, skillsTarget);
    final roadmap = calculateRoadmapProgressForUser(
      user,
      totalRoadmapSteps: roadmapSteps,
    );
    final dsa = dsaCompleted == null ? 0.0 : _pct(dsaCompleted, dsaTarget);
    final projects = projectsCompleted == null
        ? 0.0
        : _pct(projectsCompleted, projectTarget);
    final portfolio = portfolioCount == null
        ? 0.0
        : _pct(portfolioCount, portfolioTarget);
    final interview = _pct(user.interviewsPracticed, interviewTarget);

    // Job readiness is derived from the seven preparation stages above.
    // Build a preliminary map WITHOUT jobReady so the composite cannot
    // accidentally read it (no circularity), then assign its result as
    // the jobReady stage value.
    //
    // The [effectiveApplicationTarget] parameter is retained to keep
    // the private method signature stable; it does not affect this
    // stage — application activity is not readiness.
    // ignore: unused_local_variable
    final _ = effectiveApplicationTarget;

    final preparationStages = <CareerStage, double>{
      CareerStage.learning:  learning,
      CareerStage.skills:    skills,
      CareerStage.roadmap:   roadmap,
      CareerStage.dsa:       dsa,
      CareerStage.projects:  projects,
      CareerStage.portfolio: portfolio,
      CareerStage.interview: interview,
    };

    // Preparation-derived readiness — 0-100, same composite used by the
    // public readiness score (before the bounded application bonus).
    final jobReady = _jobReadinessFromStages(preparationStages).toDouble();

    return {
      ...preparationStages,
      CareerStage.jobReady: jobReady,
    };
  }

  /// Weighted overall progress across the sequential Career Journey.
  /// Weights live in [_overallWeights] and sum to 1.00, so the result is
  /// a bounded 0-100 weighted mean of the eight stage percentages.
  static double _weightedOverallFromStages(Map<CareerStage, double> stages) {
    double sum = 0;
    for (final entry in _overallWeights.entries) {
      sum += (stages[entry.key] ?? 0) * entry.value;
    }
    return _clampPct(sum);
  }

  /// Walks the pipeline in progression order and returns the first
  /// stage below [_milestoneThreshold]. "Apply for jobs" is returned only
  /// when every preparation stage has crossed the threshold — a user
  /// with strong early-stage progress but missing later stages is never
  /// mislabelled as job ready.
  ///
  /// Only the seven preparation stages are checked here. The Job Ready
  /// stage value is a derived readiness composite of the same seven
  /// stages, so checking the stage itself would be redundant. Once all
  /// preparation stages are complete, the next real action is to start
  /// applying — regardless of whether any applications have been
  /// submitted yet.
  static String? _nextMilestoneFromStages(Map<CareerStage, double> stages) {
    const order = [
      CareerStage.learning,
      CareerStage.skills,
      CareerStage.roadmap,
      CareerStage.dsa,
      CareerStage.projects,
      CareerStage.portfolio,
      CareerStage.interview,
    ];

    for (final stage in order) {
      if ((stages[stage] ?? 0) < _milestoneThreshold) {
        return _milestoneMessageFor(stage);
      }
    }
    return _milestoneMessageFor(CareerStage.jobReady);
  }

  static String _milestoneMessageFor(CareerStage stage) {
    switch (stage) {
      case CareerStage.learning:  return 'Continue your learning roadmap';
      case CareerStage.skills:    return 'Add more skills';
      case CareerStage.roadmap:   return 'Continue your learning roadmap';
      case CareerStage.dsa:       return 'Practice more DSA problems';
      case CareerStage.projects:  return 'Build more projects';
      case CareerStage.portfolio: return 'Strengthen your portfolio';
      case CareerStage.interview: return 'Practice interviews';
      case CareerStage.jobReady:  return 'Apply for jobs';
    }
  }

  // ════════════════════════════════════════════════════════════════════
  // PRIVATE: target/count resolution + numeric helpers
  // ════════════════════════════════════════════════════════════════════

  /// Resolves an effective target using: profile value (if > 0) →
  /// caller-provided value (if > 0) → shared default. Never returns a
  /// non-positive value.
  static int _resolveTarget(int? profileValue, int? callerValue, int fallback) {
    if (profileValue != null && profileValue > 0) return profileValue;
    if (callerValue != null && callerValue > 0) return callerValue;
    return fallback;
  }

  /// Resolves an effective count using: profile value (if >= 0) →
  /// caller-provided value (if >= 0) → null. Returning null means "no
  /// real count exists", which the caller treats as 0 progress for that
  /// stage rather than fabricating an estimate.
  static int? _resolveCount(int? profileValue, int? callerValue) {
    if (profileValue != null && profileValue >= 0) return profileValue;
    if (callerValue != null && callerValue >= 0) return callerValue;
    return null;
  }

  /// Safely divides [value] by [target] and returns a 0-100 percentage.
  /// Returns 0 for a non-positive target (avoids div-by-zero / NaN).
  /// Clamps to [0, 100] so a value larger than target can't exceed 100.
  static double _pct(num value, num target) {
    if (target <= 0) return 0;
    return _clampPct((value / target) * 100);
  }

  static double _clampPct(num v) {
    if (v.isNaN || v.isInfinite) return 0;
    return v.clamp(0, 100).toDouble();
  }

  static int _clampScore(num v) {
    if (v.isNaN || v.isInfinite) return 0;
    return v.round().clamp(0, 100).toInt();
  }
}