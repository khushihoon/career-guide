// ════════════════════════════════════════════════════════════════════
// CAREER DASHBOARD SCREEN - Overview and Progress
// Keep existing navigation structure
//
// ARCHITECTURE (compatibility pass)
// ──────────────────────────────────
// This is a legacy dashboard. It remains a UI / consumer layer ONLY.
// It never becomes an authority for XP, career selection,
// recommendations, or progress persistence. Specifically:
//
//   • XP
//       The dashboard does NOT trust `user.xpPoints` as the
//       authoritative Copilot XP value. It reads the authoritative
//       lifetime XP through CopilotController's existing public API
//       (`ctrl.state.totalXp`, which the current controller keeps in
//       sync with users/{uid}.totalXp via its own authoritative cache)
//       and falls back safely to 0 when that value is not yet
//       available. It never writes, mutates, or recomputes XP.
//
//   • Career
//       The dashboard does NOT trust `user.selectedCareerPath` as the
//       canonical career. When CopilotController is available, the
//       selected career is derived from its existing
//       `state.skillProfile?.targetRole` (the canonical CareerGoal
//       used across the Copilot architecture). The legacy field is
//       kept ONLY as a display fallback for out-of-Copilot contexts.
//
//   • Recommendations
//       The previous three static "recommendations" were not actually
//       personalized. This pass replaces them with either
//       (a) the user's real current NextBestAction from
//           CopilotController.copilotContext, when available, or
//       (b) a neutral fallback that does NOT pretend to be
//           personalized, based on existing dashboard metrics.
//       No second recommendation engine is implemented here.
//
//   • Choose Path
//       The button navigates to the EXISTING canonical career/skill
//       profile screen (SkillProfileScreen) via its existing route.
//       No new career-selection system is invented. If navigation
//       cannot be resolved, the button stays disabled rather than
//       fabricating a route.
//
//   • Legacy compatibility
//       UserProfile and ProgressTrackingService remain in use ONLY for
//       the metrics that genuinely belong to this legacy screen
//       (roadmap progress, job readiness, interview readiness,
//       milestone, motivation, and the skills/interviews/applications/
//       streak/badges stat cards). Neither is rewritten here.
//
// The dashboard remains a pure consumer of the current Copilot
// architecture through CopilotProvider.maybeOf(context), and every
// Copilot-derived value is read defensively so a missing controller or
// temporarily unavailable field never crashes the screen.
// ════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/models.dart';
import '../services/progress_tracking_service.dart';
import '../models/user_profile.dart';
import '../services/copilot_provider.dart';
import '../models/copilot_models.dart' as copilot;
import 'skill_profile_screen.dart';

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

  /// Guards one-shot invocation of the Copilot controller's init from
  /// this screen. We do not create a new controller or subscribe to
  /// anything here — init() is the existing public entry point, and it
  /// is safe to call repeatedly because the controller early-returns
  /// for the same UID.
  bool _copilotInitRequested = false;

  @override
  void initState() {
    super.initState();
    user = widget.userProfile;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Ask the existing CopilotController (via the existing provider) to
    // ensure its authoritative state is initialized for this session,
    // so XP / career / next-action reads below are backed by the
    // current architecture. We never create a second controller and
    // never subscribe to anything from this screen.
    if (!_copilotInitRequested) {
      _copilotInitRequested = true;
      final ctrl = CopilotProvider.maybeOf(context);
      final uid  = user.uid;
      if (ctrl != null && uid.isNotEmpty) {
        // Fire-and-forget; the controller notifies listeners when state
        // becomes available, and the build method reads state defensively.
        // ignore: discarded_futures
        ctrl.init(uid);
      }
    }
  }

  // ── Authoritative Copilot reads (defensive) ────────────────────────

  /// Returns the authoritative lifetime XP value exposed by the current
  /// Copilot architecture, or 0 when it is genuinely unavailable.
  ///
  /// This delegates exclusively to CopilotController.state.totalXp —
  /// the same authoritative value the current Copilot system already
  /// keeps in sync with users/{uid}.totalXp — and never uses the legacy
  /// UserProfile.xpPoints field, which is not an authoritative Copilot
  /// source.
  int _authoritativeXp() {
    try {
      final ctrl = CopilotProvider.maybeOf(context);
      final xp   = ctrl?.state.totalXp ?? 0;
      return xp < 0 ? 0 : xp;
    } catch (_) {
      return 0;
    }
  }

  /// Returns the canonical Copilot career label if a CopilotController
  /// session is available and has a skill profile with a target role.
  ///
  /// Falls back to the legacy `user.selectedCareerPath` ONLY as a
  /// display string when the Copilot context is not yet available — it
  /// is never treated as the canonical career source.
  String? _careerLabel() {
    try {
      final ctrl = CopilotProvider.maybeOf(context);
      final role = ctrl?.state.skillProfile?.targetRole;
      if (role != null) return role.label;
    } catch (_) {}
    final legacy = user.selectedCareerPath;
    if (legacy != null && legacy.trim().isNotEmpty) return legacy;
    return null;
  }

  /// Returns the current NextBestAction from the existing Copilot
  /// context, or null when the Copilot architecture has not produced
  /// one yet. This screen never computes a next action itself.
  copilot.NextBestAction? _currentNextBestAction() {
    try {
      final ctx = CopilotProvider.maybeOf(context)?.copilotContext;
      if (ctx == null || ctx.nextActions.isEmpty) return null;
      final incomplete = ctx.nextActions
          .where((a) => !a.isCompleted)
          .toList()
        ..sort((a, b) => a.priority.compareTo(b.priority));
      if (incomplete.isNotEmpty) return incomplete.first;
      final all = List<copilot.NextBestAction>.from(ctx.nextActions)
        ..sort((a, b) => a.priority.compareTo(b.priority));
      return all.isNotEmpty ? all.first : null;
    } catch (_) {
      return null;
    }
  }

  // ── Navigation ─────────────────────────────────────────────────────

  /// Opens the EXISTING canonical career/skill profile screen. This is
  /// the same screen the current Copilot hub uses to let the user pick
  /// or change their target career (CareerGoal). No new
  /// career-selection system is invented here.
  void _openExistingCareerProfile() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SkillProfileScreen()),
      );
    } catch (_) {
      // If navigation cannot be resolved for any reason, do nothing.
      // The button remains a safe no-op rather than fabricating a route.
    }
  }

  @override
  Widget build(BuildContext context) {
    final roadmapProgress = ProgressTrackingService.calculateRoadmapProgress(
      user.currentRoadmapStep ?? 0,
      10,
    );
    final jobReadiness = ProgressTrackingService.calculateJobReadinessScore(user);
    final interviewReadiness =
        ProgressTrackingService.calculateInterviewReadinessScore(user);
    final nextMilestone = ProgressTrackingService.getNextMilestone(user);
    final motivation = ProgressTrackingService.getMotivationalMessage(user);

    // Authoritative Copilot reads — defensive, never authoritative here.
    final xp           = _authoritativeXp();
    final careerLabel  = _careerLabel();
    final nextAction   = _currentNextBestAction();

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
                gradient: const LinearGradient(
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

            // Career Path — sourced from the existing Copilot career
            // architecture, not from a new source of truth.
            if (careerLabel == null)
              _buildCareerPathSelector()
            else
              _buildSelectedCareerPath(careerLabel),

            const SizedBox(height: 24),

            // Key Metrics
            const Text(
              'Your Progress',
              style: TextStyle(
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
              color: const Color(0xFF7C3AED),
            ),

            const SizedBox(height: 12),

            // Job Readiness
            _buildProgressCard(
              title: 'Job Readiness Score',
              progress: jobReadiness / 100,
              percentage: jobReadiness,
              icon: '💼',
              color: const Color(0xFF4ADE80),
            ),

            const SizedBox(height: 12),

            // Interview Readiness
            _buildProgressCard(
              title: 'Interview Readiness',
              progress: interviewReadiness / 100,
              percentage: interviewReadiness,
              icon: '🎤',
              color: const Color(0xFFA78BFA),
            ),

            const SizedBox(height: 24),

            // Quick Stats
            const Text(
              'Statistics',
              style: TextStyle(
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
                // XP is sourced from the authoritative Copilot value
                // (never from the legacy UserProfile.xpPoints field).
                _buildStatCard(
                  title: 'XP Points',
                  value: xp.toString(),
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

            // Recommendations — sourced from the current Copilot
            // next-action when available, otherwise a neutral fallback.
            _buildRecommendations(nextAction),

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
                  // Navigates to the EXISTING SkillProfileScreen, which
                  // is the canonical place to pick a CareerGoal in the
                  // current Copilot architecture. No new career-selection
                  // system is introduced here.
                  onPressed: _openExistingCareerProfile,
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

  Widget _buildSelectedCareerPath(String label) {
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
                label,
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

  /// Recommendations section.
  ///
  /// When the current Copilot architecture has produced a
  /// [copilot.NextBestAction], it is presented as the single current
  /// next step — sourced directly from
  /// `CopilotController.copilotContext`, not computed here.
  ///
  /// Otherwise the section shows a NEUTRAL fallback that is explicitly
  /// generic (not personalized). It never claims to be personalized,
  /// and it never duplicates CopilotController's intelligence.
  Widget _buildRecommendations(copilot.NextBestAction? nextAction) {
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
          if (nextAction != null)
            _buildRecommendationItem(
              icon: '🎯',
              title: nextAction.title,
              description: nextAction.description.trim().isEmpty
                  ? 'Your current recommended next step.'
                  : nextAction.description,
            )
          else ...[
            const Text(
              'Generic suggestions',
              style: TextStyle(
                color: Color(0xFF888899),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildRecommendationItem(
              icon: '📚',
              title: 'Continue Learning',
              description:
                  'Keep working through your roadmap — a general suggestion.',
            ),
            const SizedBox(height: 8),
            _buildRecommendationItem(
              icon: '🎤',
              title: 'Practice Interviews',
              description:
                  'Build interview confidence over time — a general suggestion.',
            ),
            const SizedBox(height: 8),
            _buildRecommendationItem(
              icon: '💼',
              title: 'Apply to Jobs',
              description:
                  'Start applying when you feel ready — a general suggestion.',
            ),
          ],
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