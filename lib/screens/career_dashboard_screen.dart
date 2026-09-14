// ════════════════════════════════════════════════════════════════════
// CAREER DASHBOARD SCREEN - Overview and Progress
// Keep existing navigation structure
// ════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/models.dart';
import '../services/progress_tracking_service.dart';
import '../models/user_profile.dart';

class CareerDashboardScreen extends StatefulWidget {
  final UserProfile userProfile;

  const CareerDashboardScreen({
    Key? key,
    required this.userProfile,
  }) : super(key: key);

  @override
  State<CareerDashboardScreen> createState() => _CareerDashboardScreenState();
}

class _CareerDashboardScreenState extends State<CareerDashboardScreen> {
  late UserProfile user;

  @override
  void initState() {
    super.initState();
    user = widget.userProfile;
  }

  @override
  Widget build(BuildContext context) {
    final roadmapProgress = ProgressTrackingService.calculateRoadmapProgress(
      user.currentRoadmapStep ?? 0,
      10,
    );
    final jobReadiness = ProgressTrackingService.calculateJobReadinessScore(user);
    final interviewReadiness = ProgressTrackingService.calculateInterviewReadinessScore(user);
    final nextMilestone = ProgressTrackingService.getNextMilestone(user);
    final motivation = ProgressTrackingService.getMotivationalMessage(user);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0F0F1A),
        title: const Text('Career Dashboard'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Motivational Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    motivation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nextMilestone ?? 'Keep going!',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms),

            const SizedBox(height: 24),

            // Career Path Selection
            if (user.selectedCareerPath == null)
              _buildCareerPathSelector()
            else
              _buildSelectedCareerPath(),

            const SizedBox(height: 24),

            // Key Metrics
            Text(
              'Your Progress',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Roadmap Progress
            _buildProgressCard(
              title: 'Learning Roadmap',
              progress: roadmapProgress / 100,
              percentage: roadmapProgress.toInt(),
              icon: '📚',
              color: Color(0xFF7C3AED),
            ),

            const SizedBox(height: 12),

            // Job Readiness
            _buildProgressCard(
              title: 'Job Readiness Score',
              progress: jobReadiness / 100,
              percentage: jobReadiness,
              icon: '💼',
              color: Color(0xFF4ADE80),
            ),

            const SizedBox(height: 12),

            // Interview Readiness
            _buildProgressCard(
              title: 'Interview Readiness',
              progress: interviewReadiness / 100,
              percentage: interviewReadiness,
              icon: '🎤',
              color: Color(0xFFA78BFA),
            ),

            const SizedBox(height: 24),

            // Quick Stats
            Text(
              'Statistics',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                _buildStatCard(
                  title: 'Skills',
                  value: user.skills.length.toString(),
                  icon: '⭐',
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  title: 'Interviews',
                  value: user.interviewsPracticed.toString(),
                  icon: '🎯',
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  title: 'Applications',
                  value: user.jobApplications.toString(),
                  icon: '📧',
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _buildStatCard(
                  title: 'Streak',
                  value: '${user.dailyStreak}d',
                  icon: '🔥',
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  title: 'XP Points',
                  value: user.xpPoints.toString(),
                  icon: '⚡',
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  title: 'Badges',
                  value: user.badges.length.toString(),
                  icon: '🏅',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recommendations
            _buildRecommendations(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCareerPathSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Your Career Path',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2A40)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose a specialization to get personalized recommendations',
                style: TextStyle(
                  color: Color(0xFF888899),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to career paths selection
                    // This would typically open a new screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Choose Path',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedCareerPath() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF7C3AED), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user.selectedCareerPath ?? 'Career Path',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.check_circle,
                color: Color(0xFF4ADE80),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'You\'re on the right track!',
            style: TextStyle(
              color: Color(0xFF888899),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required double progress,
    required int percentage,
    required String icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    icon,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFF2A2A40),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A40)),
        ),
        child: Column(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF888899),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💡 Recommendations',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildRecommendationItem(
            icon: '📚',
            title: 'Continue Learning',
            description: 'Complete your roadmap for better career prospects',
          ),
          const SizedBox(height: 8),
          _buildRecommendationItem(
            icon: '🎤',
            title: 'Practice Interviews',
            description: 'Improve your interview readiness score',
          ),
          const SizedBox(height: 8),
          _buildRecommendationItem(
            icon: '💼',
            title: 'Apply to Jobs',
            description: 'Start applying to relevant positions',
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem({
    required String icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF888899),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}