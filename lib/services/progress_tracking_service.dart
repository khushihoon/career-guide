import '../models/user_profile.dart';

class ProgressTrackingService {
  static double calculateRoadmapProgress(
    int currentStep,
    int totalSteps,
  ) {
    if (totalSteps == 0) return 0;
    return (currentStep / totalSteps) * 100;
  }

  static int calculateJobReadinessScore(UserProfile user) {
    int score = 0;

    score += user.skills.length * 5;
    score += user.interviewsPracticed * 3;
    score += user.jobApplications * 2;

    return score.clamp(0, 100);
  }

  static int calculateInterviewReadinessScore(UserProfile user) {
    int score = 20;

    score += user.interviewsPracticed * 5;
    score += user.skills.length * 2;

    return score.clamp(0, 100);
  }

  static String? getNextMilestone(UserProfile user) {
    if (user.skills.length < 5) {
      return 'Add more skills';
    }

    if (user.interviewsPracticed < 5) {
      return 'Practice interviews';
    }

    if (user.jobApplications < 10) {
      return 'Apply for jobs';
    }

    return 'You are job ready!';
  }

  static String getMotivationalMessage(UserProfile user) {
    if (user.dailyStreak >= 30) {
      return 'Amazing consistency!';
    }

    if (user.dailyStreak >= 7) {
      return 'Great progress!';
    }

    return 'Keep learning every day.';
  }
}