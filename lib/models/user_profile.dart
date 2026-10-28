// ══════════════════════════════════════════════════════════════════════
// lib/models/user_profile.dart
//
// Career progress profile. Pure data model — no Firestore, no API calls,
// no persistence logic of any kind lives here.
//
// ══════════════════════════════════════════════════════════════════════
// BACKWARD COMPATIBILITY
// ══════════════════════════════════════════════════════════════════════
// Every original field (currentRoadmapStep, selectedCareerPath, skills,
// interviewsPracticed, jobApplications, dailyStreak, xpPoints, badges)
// keeps its exact name, type, and default. The constructor is still a
// `const` constructor with the same named parameters behaving exactly as
// before — every existing `UserProfile(...)` call site compiles and
// behaves unchanged. Everything below is additive.
//
// ══════════════════════════════════════════════════════════════════════
// SCOPE
// ══════════════════════════════════════════════════════════════════════
// This model tracks COUNTS and TARGETS only (e.g. "3 of 5 projects
// completed"), consistent with ProgressTrackingService, which already
// expects exactly this shape (dsaProblemsCompleted, projectsCompleted,
// portfolioItemsCount, and their targets, as optional overrides it falls
// back to heuristics without). It does NOT store actual project files,
// screenshots, demos, certificates, or any uploaded work — that belongs
// to a dedicated Portfolio/Work system to be built later. The public-
// portfolio fields here (username, links, headline, bio) are just the
// lightweight identity/toggle a future public profile page would need;
// they carry no work content themselves.
// ══════════════════════════════════════════════════════════════════════

class UserProfile {
  // ── Original fields — unchanged ─────────────────────────────────────
  final int? currentRoadmapStep;
  final String? selectedCareerPath;
  final List<String> skills;
  final int interviewsPracticed;
  final int jobApplications;
  final int dailyStreak;
  final int xpPoints;
  final List<String> badges;

  // ── NEW: Learning progress ──────────────────────────────────────────
  // Distinct from currentRoadmapStep/totalRoadmapSteps below — this is
  // lesson-level completion. ProgressTrackingService currently derives
  // its "Learning" stage from the roadmap step as a proxy when this
  // isn't set; supplying real values here lets it use the real signal
  // instead, with zero changes needed on that service's side.
  final int? completedLessons;
  final int? totalLessons;

  // ── NEW: Roadmap sizing (pairs with currentRoadmapStep) ─────────────
  final int? totalRoadmapSteps;

  // ── NEW: Skills target ───────────────────────────────────────────────
  final int? targetSkillCount;

  // ── NEW: DSA progress/targets ────────────────────────────────────────
  final int? dsaProblemsCompleted;
  final int? dsaProblemsTarget;

  // ── NEW: Projects completed/targets ──────────────────────────────────
  final int? projectsCompleted;
  final int? projectsTarget;

  // ── NEW: Portfolio items/targets ─────────────────────────────────────
  // Counts and targets only — NOT the portfolio items themselves.
  final int? portfolioItemsCount;
  final int? portfolioItemsTarget;

  // ── NEW: Interview/application targets ───────────────────────────────
  final int? interviewsTarget;
  final int? applicationsTarget;

  // ── NEW: Public portfolio / profile identity ─────────────────────────
  // Lightweight identity + a visibility toggle for a future public
  // portfolio page. No work content lives here (see SCOPE above).
  final bool isPortfolioPublic;
  final String? username;
  final String? githubUrl;
  final String? linkedinUrl;
  final String? portfolioHeadline;
  final String? portfolioBio;

  const UserProfile({
    this.currentRoadmapStep,
    this.selectedCareerPath,
    this.skills = const [],
    this.interviewsPracticed = 0,
    this.jobApplications = 0,
    this.dailyStreak = 0,
    this.xpPoints = 0,
    this.badges = const [],
    this.completedLessons,
    this.totalLessons,
    this.totalRoadmapSteps,
    this.targetSkillCount,
    this.dsaProblemsCompleted,
    this.dsaProblemsTarget,
    this.projectsCompleted,
    this.projectsTarget,
    this.portfolioItemsCount,
    this.portfolioItemsTarget,
    this.interviewsTarget,
    this.applicationsTarget,
    this.isPortfolioPublic = false,
    this.username,
    this.githubUrl,
    this.linkedinUrl,
    this.portfolioHeadline,
    this.portfolioBio,
  })  : assert(
            interviewsPracticed >= 0, 'interviewsPracticed cannot be negative'),
        assert(jobApplications >= 0, 'jobApplications cannot be negative'),
        assert(dailyStreak >= 0, 'dailyStreak cannot be negative'),
        assert(xpPoints >= 0, 'xpPoints cannot be negative'),
        assert(currentRoadmapStep == null || currentRoadmapStep >= 0,
            'currentRoadmapStep cannot be negative'),
        assert(completedLessons == null || completedLessons >= 0,
            'completedLessons cannot be negative'),
        assert(totalLessons == null || totalLessons >= 0,
            'totalLessons cannot be negative'),
        assert(totalRoadmapSteps == null || totalRoadmapSteps >= 0,
            'totalRoadmapSteps cannot be negative'),
        assert(targetSkillCount == null || targetSkillCount >= 0,
            'targetSkillCount cannot be negative'),
        assert(dsaProblemsCompleted == null || dsaProblemsCompleted >= 0,
            'dsaProblemsCompleted cannot be negative'),
        assert(dsaProblemsTarget == null || dsaProblemsTarget >= 0,
            'dsaProblemsTarget cannot be negative'),
        assert(projectsCompleted == null || projectsCompleted >= 0,
            'projectsCompleted cannot be negative'),
        assert(projectsTarget == null || projectsTarget >= 0,
            'projectsTarget cannot be negative'),
        assert(portfolioItemsCount == null || portfolioItemsCount >= 0,
            'portfolioItemsCount cannot be negative'),
        assert(portfolioItemsTarget == null || portfolioItemsTarget >= 0,
            'portfolioItemsTarget cannot be negative'),
        assert(interviewsTarget == null || interviewsTarget >= 0,
            'interviewsTarget cannot be negative'),
        assert(applicationsTarget == null || applicationsTarget >= 0,
            'applicationsTarget cannot be negative');

  // ══════════════════════════════════════════════════════════════════
  // copyWith
  // ══════════════════════════════════════════════════════════════════
  // Standard "pass a new value to replace it, omit to keep the current
  // one" pattern. Note the usual Dart copyWith limitation: because `??`
  // is used to detect "not provided", there's no way to explicitly reset
  // an already-set nullable field (e.g. githubUrl) back to null through
  // copyWith alone — construct a new UserProfile directly for that rare
  // case. This keeps the common case (update a few fields, keep the
  // rest) simple and predictable, which covers the vast majority of
  // real usage.
  UserProfile copyWith({
    int? currentRoadmapStep,
    String? selectedCareerPath,
    List<String>? skills,
    int? interviewsPracticed,
    int? jobApplications,
    int? dailyStreak,
    int? xpPoints,
    List<String>? badges,
    int? completedLessons,
    int? totalLessons,
    int? totalRoadmapSteps,
    int? targetSkillCount,
    int? dsaProblemsCompleted,
    int? dsaProblemsTarget,
    int? projectsCompleted,
    int? projectsTarget,
    int? portfolioItemsCount,
    int? portfolioItemsTarget,
    int? interviewsTarget,
    int? applicationsTarget,
    bool? isPortfolioPublic,
    String? username,
    String? githubUrl,
    String? linkedinUrl,
    String? portfolioHeadline,
    String? portfolioBio,
  }) {
    return UserProfile(
      currentRoadmapStep: currentRoadmapStep ?? this.currentRoadmapStep,
      selectedCareerPath: selectedCareerPath ?? this.selectedCareerPath,
      skills: skills ?? this.skills,
      interviewsPracticed: interviewsPracticed ?? this.interviewsPracticed,
      jobApplications: jobApplications ?? this.jobApplications,
      dailyStreak: dailyStreak ?? this.dailyStreak,
      xpPoints: xpPoints ?? this.xpPoints,
      badges: badges ?? this.badges,
      completedLessons: completedLessons ?? this.completedLessons,
      totalLessons: totalLessons ?? this.totalLessons,
      totalRoadmapSteps: totalRoadmapSteps ?? this.totalRoadmapSteps,
      targetSkillCount: targetSkillCount ?? this.targetSkillCount,
      dsaProblemsCompleted: dsaProblemsCompleted ?? this.dsaProblemsCompleted,
      dsaProblemsTarget: dsaProblemsTarget ?? this.dsaProblemsTarget,
      projectsCompleted: projectsCompleted ?? this.projectsCompleted,
      projectsTarget: projectsTarget ?? this.projectsTarget,
      portfolioItemsCount: portfolioItemsCount ?? this.portfolioItemsCount,
      portfolioItemsTarget: portfolioItemsTarget ?? this.portfolioItemsTarget,
      interviewsTarget: interviewsTarget ?? this.interviewsTarget,
      applicationsTarget: applicationsTarget ?? this.applicationsTarget,
      isPortfolioPublic: isPortfolioPublic ?? this.isPortfolioPublic,
      username: username ?? this.username,
      githubUrl: githubUrl ?? this.githubUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      portfolioHeadline: portfolioHeadline ?? this.portfolioHeadline,
      portfolioBio: portfolioBio ?? this.portfolioBio,
    );
  }
}
