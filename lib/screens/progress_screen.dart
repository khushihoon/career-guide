// ══════════════════════════════════════════════════════════════════════
// lib/screens/progress_screen.dart
//
// Career Progress Dashboard — UI layer only. Reads real data exposed by
// CopilotController (state, XP, streak, history, skill profile, roadmap)
// and delegates ALL progress math to ProgressTrackingService.
//
// ARCHITECTURE RULES OBSERVED HERE
//   • No Firestore / no API / no SharedPreferences access.
//   • No use of ctrl.copilotContext — the current CopilotController does
//     not expose it. Only ctrl.state and its fields are used.
//   • No progress formulas are re-implemented in this screen.
//   • No milestone-threshold decision logic is duplicated here; the
//     next-milestone string comes from ProgressTrackingService.
//   • No DSA / portfolio / interview / project / application progress is
//     invented. Fields without a real controller-side signal are left
//     null so ProgressTrackingService's own conservative default applies.
//   • Readiness scores are shown only when they can be computed from the
//     same real data used for the snapshot; otherwise the tile shows an
//     "Insufficient data" state instead of a fake number.
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/copilot_models.dart';
import '../models/user_profile.dart';
import '../services/copilot_provider.dart';
import '../services/progress_tracking_service.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  static const _bg        = Color(0xFF0F0F1A);
  static const _surface   = Color(0xFF1A1A2E);
  static const _border    = Color(0xFF2A2A40);
  static const _primary   = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted     = Color(0xFF888899);

  @override
  Widget build(BuildContext context) {
    final ctrl = CopilotProvider.maybeOf(context);

    if (ctrl == null) {
      return Scaffold(
        backgroundColor: _bg,
        body: const Center(
          child: CircularProgressIndicator(color: _primary),
        ),
      );
    }

    final state = ctrl.state;
    final history = state.progressHistory;

    final chartData = history.length > 7
        ? history.sublist(history.length - 7)
        : [...history];

    final maxXp = chartData.isEmpty
        ? 1
        : chartData.fold(0, (m, e) => e.xpEarned > m ? e.xpEarned : m);

    // Build a UserProfile from real controller data only.
    // ProgressTrackingService is the single source of truth for
    // calculations and for what counts as "next milestone".
    final userProfile = _buildProfileFromController(state);
    final snapshot = ProgressTrackingService.getProgressSnapshot(userProfile);

    // Readiness is only meaningful when the underlying stages were
    // computed from real data. Interview readiness needs real interview
    // practice; job readiness needs several preparation stages. Since
    // CopilotState exposes no dedicated interview-history or
    // interview-score signal, and no signal that specifically proves job
    // readiness, both tiles must fall back to "Insufficient data" rather
    // than inventing a number from unrelated signals.
    const hasRealInterviewData = false;
    const hasRealJobReadinessBasis = false;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text(
          'Progress',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatsStrip(state: state).animate().fadeIn(),

            const SizedBox(height: 20),
            _OverallProgressCard(snapshot: snapshot)
                .animate()
                .fadeIn(delay: 80.ms),

            const SizedBox(height: 16),
            _CareerJourneyCard(snapshot: snapshot)
                .animate()
                .fadeIn(delay: 140.ms),

            const SizedBox(height: 16),
            _ReadinessCard(
              snapshot: snapshot,
              showInterview: hasRealInterviewData,
              showJob: hasRealJobReadinessBasis,
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 24),
            const Text('7-Day XP',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
            const SizedBox(height: 12),
            _XpChart(chartData: chartData, maxXp: maxXp)
                .animate()
                .fadeIn(delay: 260.ms),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('History',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                Text('${history.length} days',
                    style: const TextStyle(color: _muted, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            if (history.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _border),
                ),
                child: const Center(
                  child: Text('Complete today\'s goals to start tracking',
                      style: TextStyle(color: _muted, fontSize: 13)),
                ),
              )
            else
              ...history.reversed.take(14).toList().asMap().entries.map(
                    (entry) => _HistoryRow(entry: entry.value)
                        .animate()
                        .fadeIn(
                            delay: Duration(milliseconds: 320 + entry.key * 40)),
                  ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // BEST-EFFORT PROFILE FROM CONTROLLER DATA
  // ══════════════════════════════════════════════════════════════════
  //
  // Only real signals currently exposed by CopilotState are used. Fields
  // the controller has no signal for are left null so
  // ProgressTrackingService uses its own conservative default (0 for
  // DSA, portfolio, etc.) — this screen never invents progress.
  static UserProfile _buildProfileFromController(CopilotState state) {
    // Real skills from the skill profile (empty when unavailable).
    final skills = state.skillProfile?.skillNames ?? const <String>[];

    // Real roadmap signal: completed phases / total phases.
    final roadmap = state.roadmap;
    final currentRoadmapStep = roadmap?.currentPhaseIndex;
    final totalRoadmapSteps = (roadmap?.phases.isNotEmpty ?? false)
        ? roadmap!.phases.length
        : null;

    // Learning signal: no dedicated lesson counter is exposed by the
    // current CopilotController, so leave it null and let
    // ProgressTrackingService fall back to roadmap progress (which is
    // its documented behaviour for profiles without lesson data).

    // DSA / Portfolio: no real signal exposed — leave null.
    // Projects / Interviews / Applications: no real signal exposed —
    // leave null.

    return UserProfile(
      skills: skills,
      currentRoadmapStep: currentRoadmapStep,
      totalRoadmapSteps: totalRoadmapSteps,
      // Everything else intentionally omitted so the service falls back
      // to its safe defaults rather than fabricated numbers.
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// STATS STRIP — streak / XP / active days (preserved from original)
// ══════════════════════════════════════════════════════════════════════

class _StatsStrip extends StatelessWidget {
  final CopilotState state;
  const _StatsStrip({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _tile('🔥', '${state.currentStreak}', 'Day Streak'),
        const SizedBox(width: 10),
        _tile('⚡', '${state.totalXp}', 'Total XP'),
        const SizedBox(width: 10),
        _tile('📅', '${state.progressHistory.length}', 'Days Active'),
      ],
    );
  }

  Widget _tile(String emoji, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A2A40)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label,
                style:
                    const TextStyle(color: Color(0xFF888899), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// OVERALL PROGRESS CARD — overall %, next milestone
// ══════════════════════════════════════════════════════════════════════
//
// "You are here" and "Next milestone" both come from the snapshot the
// service produced — no threshold or ordering logic is repeated here.

class _OverallProgressCard extends StatelessWidget {
  final CareerProgressSnapshot snapshot;
  const _OverallProgressCard({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final overall = snapshot.overallProgress.clamp(0.0, 100.0);
    final milestone = snapshot.nextMilestone ?? 'Keep going';
    final currentStageLabel = _stageLabelForOverall(snapshot, overall);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7C3AED).withOpacity(0.25),
            const Color(0xFFA78BFA).withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights, color: Color(0xFFA78BFA), size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Overall Career Progress',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              Text(
                '${overall.round()}%',
                style: const TextStyle(
                    color: Color(0xFFA78BFA),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (overall / 100).clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: const Color(0xFF0F0F20),
              valueColor:
                  const AlwaysStoppedAnimation(Color(0xFF7C3AED)),
            ),
          ),
          const SizedBox(height: 14),
          _infoRow(
            emoji: '📍',
            label: 'You are here',
            value: currentStageLabel,
            accent: const Color(0xFFA78BFA),
          ),
          const SizedBox(height: 8),
          _infoRow(
            emoji: '🎯',
            label: 'Next milestone',
            value: milestone,
            accent: const Color(0xFF6EE7B7),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required String emoji,
    required String label,
    required String value,
    required Color accent,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Color(0xFF888899),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4)),
              const SizedBox(height: 2),
              Text(value,
                  style: TextStyle(
                      color: accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  /// Renders "You are here" as a compact stage label derived from the
  /// snapshot the service already produced. This does NOT re-decide the
  /// next milestone or the pipeline order — it just picks a presentational
  /// label from the highest-numbered stage that has any real progress,
  /// defaulting to the pipeline's first stage.
  static String _stageLabelForOverall(
    CareerProgressSnapshot snapshot,
    double overall,
  ) {
    if (overall <= 0) return CareerStage.learning.label;

    // Walk the canonical pipeline order and remember the last stage with
    // any progress; that is a faithful "you are here" for the snapshot
    // the service produced, without re-implementing its milestone logic.
    const order = [
      CareerStage.learning,
      CareerStage.skills,
      CareerStage.roadmap,
      CareerStage.dsa,
      CareerStage.projects,
      CareerStage.portfolio,
      CareerStage.interview,
      CareerStage.jobReady,
    ];
    CareerStage last = CareerStage.learning;
    for (final stage in order) {
      if (snapshot.progressFor(stage) > 0) {
        last = stage;
      }
    }
    return last.label;
  }
}

// ══════════════════════════════════════════════════════════════════════
// CAREER JOURNEY CARD — all 8 stages with real progress
// ══════════════════════════════════════════════════════════════════════

class _CareerJourneyCard extends StatelessWidget {
  final CareerProgressSnapshot snapshot;
  const _CareerJourneyCard({required this.snapshot});

  static const _order = [
    CareerStage.learning,
    CareerStage.skills,
    CareerStage.roadmap,
    CareerStage.dsa,
    CareerStage.projects,
    CareerStage.portfolio,
    CareerStage.interview,
    CareerStage.jobReady,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.route, color: Color(0xFFA78BFA), size: 20),
              SizedBox(width: 8),
              Text(
                'Career Journey',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._order.map((stage) {
            final value = snapshot.progressFor(stage).clamp(0.0, 100.0);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _stageRow(stage, value),
            );
          }),
        ],
      ),
    );
  }

  Widget _stageRow(CareerStage stage, double pct) {
    final done = pct >= 70;
    final started = pct > 0;
    final color = done
        ? const Color(0xFF4ADE80)
        : started
            ? const Color(0xFF7C3AED)
            : const Color(0xFF444455);

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 74,
          child: Text(
            stage.label,
            style: TextStyle(
                color: started ? Colors.white : const Color(0xFF888899),
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (pct / 100).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: const Color(0xFF0F0F20),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 38,
          child: Text(
            '${pct.round()}%',
            textAlign: TextAlign.right,
            style: TextStyle(
                color: started
                    ? const Color(0xFFA78BFA)
                    : const Color(0xFF888899),
                fontSize: 11,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// READINESS CARD — job + interview readiness (only when data exists)
// ══════════════════════════════════════════════════════════════════════

class _ReadinessCard extends StatelessWidget {
  final CareerProgressSnapshot snapshot;
  final bool showJob;
  final bool showInterview;
  const _ReadinessCard({
    required this.snapshot,
    required this.showJob,
    required this.showInterview,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _readinessTile(
            emoji: '💼',
            label: 'Job Readiness',
            score: snapshot.jobReadinessScore,
            available: showJob,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _readinessTile(
            emoji: '🎤',
            label: 'Interview Readiness',
            score: snapshot.interviewReadinessScore,
            available: showInterview,
          ),
        ),
      ],
    );
  }

  Widget _readinessTile({
    required String emoji,
    required String label,
    required int score,
    required bool available,
  }) {
    final s = score.clamp(0, 100);
    final color = !available
        ? const Color(0xFF888899)
        : s >= 70
            ? const Color(0xFF4ADE80)
            : s >= 40
                ? const Color(0xFFF59E0B)
                : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (available)
            Text(
              '$s%',
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            )
          else
            const Text(
              'Insufficient data',
              style: TextStyle(
                  color: Color(0xFF888899),
                  fontWeight: FontWeight.w600,
                  fontSize: 13),
            ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: available ? (s / 100).clamp(0.0, 1.0) : 0.0,
              minHeight: 5,
              backgroundColor: const Color(0xFF0F0F20),
              valueColor: AlwaysStoppedAnimation(
                  available ? color : const Color(0xFF444455)),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// XP CHART — preserved from original
// ══════════════════════════════════════════════════════════════════════

class _XpChart extends StatelessWidget {
  final List<ProgressEntry> chartData;
  final int maxXp;
  const _XpChart({required this.chartData, required this.maxXp});

  @override
  Widget build(BuildContext context) {
    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    if (chartData.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A2A40)),
        ),
        child: const Center(
          child: Text('No data yet',
              style: TextStyle(color: Color(0xFF888899))),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: chartData.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final pct = maxXp == 0 ? 0.0 : item.xpEarned / maxXp;
          final day = dayLabels[item.date.weekday - 1];

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${item.xpEarned}',
                      style: const TextStyle(
                          color: Color(0xFFA78BFA), fontSize: 9)),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 400 + i * 50),
                    curve: Curves.easeOut,
                    height: 80 * pct + 4,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(day,
                      style: const TextStyle(
                          color: Color(0xFF888899), fontSize: 10)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// HISTORY ROW — preserved from original
// ══════════════════════════════════════════════════════════════════════

class _HistoryRow extends StatelessWidget {
  final ProgressEntry entry;
  const _HistoryRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final pct = entry.completionRate;
    final d = entry.date;
    final label =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(
                    color: Color(0xFF888899), fontSize: 12)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 6,
                backgroundColor: const Color(0xFF2A2A40),
                valueColor:
                    const AlwaysStoppedAnimation(Color(0xFF7C3AED)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text('${entry.goalsCompleted}/${entry.totalGoals}',
              style: const TextStyle(
                  color: Colors.white70, fontSize: 12)),
          const SizedBox(width: 10),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('+${entry.xpEarned}',
                style: const TextStyle(
                    color: Color(0xFFA78BFA), fontSize: 11)),
          ),
        ],
      ),
    );
  }
}