class UserProfile {
  final int? currentRoadmapStep;
  final String? selectedCareerPath;
  final List<String> skills;
  final int interviewsPracticed;
  final int jobApplications;
  final int dailyStreak;
  final int xpPoints;
  final List<String> badges;

  const UserProfile({
    this.currentRoadmapStep,
    this.selectedCareerPath,
    this.skills = const [],
    this.interviewsPracticed = 0,
    this.jobApplications = 0,
    this.dailyStreak = 0,
    this.xpPoints = 0,
    this.badges = const [],
  });
}