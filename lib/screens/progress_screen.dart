// ══════════════════════════════════════════════════════════════════════
// lib/screens/progress_screen.dart
//
// CAREER PROGRESS DASHBOARD
//
// UI ONLY.
// • Reads the current CopilotContext from CopilotController.
// • Uses ProgressTrackingService only for presentation snapshots.
// • Does not access Firestore/API/SharedPreferences.
// • Does not calculate readiness or progression rules itself.
// • Uses the canonical CareerStage from copilot_models.dart.
// • Falls back to a safe loading/insufficient-data state when the richer
//   CopilotContext is not available yet.
//
// CURRENT PIPELINE
// Exploration → Assessment → Learning → Practice → Projects →
// Portfolio → CV Ready → Interview Prep → Job Search → Job Ready → Growth
//
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/copilot_models.dart';
import '../services/copilot_provider.dart';
import '../services/progress_tracking_service.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  static const _bg = Color(0xFF0F0F1A);
  static const _surface = Color(0xFF1A1A2E);
  static const _border = Color(0xFF2A2A40);
  static const _primary = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted = Color(0xFF888899);
  static const _green = Color(0xFF4ADE80);

  @override
  Widget build(BuildContext context) {
    final ctrl = CopilotProvider.maybeOf(context);

    if (ctrl == null) {
      return const _LoadingScreen();
    }

    final state = ctrl.state;
    final copilotContext = ctrl.copilotContext;

    final history = [...state.progressHistory]
      ..sort((a, b) => a.date.compareTo(b.date));

    final chartData = history.length > 7
        ? history.sublist(history.length - 7)
        : history;

    final maxXp = chartData.fold<int>(
      0,
      (maxValue, entry) =>
          entry.xpEarned > maxValue ? entry.xpEarned : maxValue,
    );

    // The richer canonical read model is the preferred source.
    final snapshot = copilotContext == null
        ? _emptySnapshot()
        : ProgressTrackingService.getCopilotProgressSnapshot(copilotContext!);

    final hasCanonicalData = copilotContext != null;
    final currentStage = hasCanonicalData
        ? ProgressTrackingService.currentCanonicalStage(copilotContext!)
        : null;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text(
          'Progress',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!hasCanonicalData)
              const _ContextLoadingBanner()
            else ...[
              _CareerHeader(contextData: copilotContext!)
                  .animate()
                  .fadeIn(),

              const SizedBox(height: 16),

              _StatsStrip(state: state)
                  .animate()
                  .fadeIn(delay: 50.ms),

              const SizedBox(height: 20),

              _OverallProgressCard(
                snapshot: snapshot,
                currentStage: currentStage,
              ).animate().fadeIn(delay: 90.ms),

              const SizedBox(height: 16),

              _CareerJourneyCard(snapshot: snapshot)
                  .animate()
                  .fadeIn(delay: 130.ms),

              const SizedBox(height: 16),

              _ReadinessCard(
                snapshot: snapshot,
                available: true,
              ).animate().fadeIn(delay: 170.ms),
            ],

            const SizedBox(height: 24),

            const Text(
              '7-Day XP',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 12),

            _XpChart(
              chartData: chartData,
              maxXp: maxXp,
            ).animate().fadeIn(delay: 220.ms),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'History',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '${history.length} days',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12,
                  ),
                ),
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
                  child: Text(
                    'Complete a meaningful career action to start tracking.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _muted,
                      fontSize: 13,
                    ),
                  ),
                ),
              )
            else
              ...history.reversed.take(14).toList().asMap().entries.map(
                    (entry) => _HistoryRow(entry: entry.value)
                        .animate()
                        .fadeIn(
                          delay: Duration(
                            milliseconds: 280 + entry.key * 35,
                          ),
                        ),
                  ),
          ],
        ),
      ),
    );
  }

  static CareerProgressSnapshot _emptySnapshot() {
    return CareerProgressSnapshot(
      stageProgress: {
        for (final stage in ProgressTrackingService.canonicalStageOrder)
          stage: 0,
      },
      overallProgress: 0,
      jobReadinessScore: 0,
      interviewReadinessScore: 0,
      nextMilestone: null,
      motivationalMessage: 'Loading your career progress...',
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  static const _bg = Color(0xFF0F0F1A);
  static const _primary = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: _bg,
      body: Center(
        child: CircularProgressIndicator(color: _primary),
      ),
    );
  }
}

class _ContextLoadingBanner extends StatelessWidget {
  const _ContextLoadingBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFFA78BFA),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Syncing your career progress…',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// CAREER HEADER
// ══════════════════════════════════════════════════════════════════════

class _CareerHeader extends StatelessWidget {
  final CopilotContext contextData;

  const _CareerHeader({required this.contextData});

  @override
  Widget build(BuildContext context) {
    final career = contextData.career;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7C3AED).withOpacity(0.22),
            const Color(0xFFA78BFA).withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF7C3AED).withOpacity(0.30),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              career?.emoji.isNotEmpty == true ? career!.emoji : '🎯',
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Career',
                  style: TextStyle(
                    color: Color(0xFF888899),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  career?.careerTitle.isNotEmpty == true
                      ? career!.careerTitle
                      : 'Career not selected',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// STATS STRIP
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
        _tile('⚡', '${state.totalXp}', 'XP'),
        const SizedBox(width: 10),
        _tile('📅', '${state.progressHistory.length}', 'Active Days'),
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
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF888899),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// OVERALL PROGRESS
// ══════════════════════════════════════════════════════════════════════

class _OverallProgressCard extends StatelessWidget {
  final CareerProgressSnapshot snapshot;
  final CareerStage? currentStage;

  const _OverallProgressCard({
    required this.snapshot,
    required this.currentStage,
  });

  @override
  Widget build(BuildContext context) {
    final overall = snapshot.overallProgress.clamp(0.0, 100.0);
    final milestone = snapshot.nextMilestone ?? 'Keep moving forward.';
    final stageLabel =
        currentStage?.label ?? 'Career progress';

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
        border: Border.all(
          color: const Color(0xFF7C3AED).withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.insights,
                color: Color(0xFFA78BFA),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Overall Career Progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                '${overall.round()}%',
                style: const TextStyle(
                  color: Color(0xFFA78BFA),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
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
            label: 'Current stage',
            value: stageLabel,
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
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF888899),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// CAREER JOURNEY — CANONICAL 11 STAGES
// ══════════════════════════════════════════════════════════════════════

class _CareerJourneyCard extends StatelessWidget {
  final CareerProgressSnapshot snapshot;

  const _CareerJourneyCard({required this.snapshot});

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
          const Row(
            children: [
              Icon(
                Icons.route,
                color: Color(0xFFA78BFA),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Career Journey',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...ProgressTrackingService.canonicalStageOrder.map(
            (stage) {
              final value =
                  snapshot.progressFor(stage).clamp(0.0, 100.0);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _stageRow(stage, value),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _stageRow(CareerStage stage, double pct) {
    // Presentation only:
    // 100 = completed-looking, >0 = started, 0 = not evidenced.
    final Color color;
    if (pct >= 100) {
      color = const Color(0xFF4ADE80);
    } else if (pct > 0) {
      color = const Color(0xFF7C3AED);
    } else {
      color = const Color(0xFF444455);
    }

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 92,
          child: Text(
            stage.label,
            style: TextStyle(
              color:
                  pct > 0 ? Colors.white : const Color(0xFF888899),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 6),
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
              color: pct > 0
                  ? const Color(0xFFA78BFA)
                  : const Color(0xFF888899),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// READINESS
// ══════════════════════════════════════════════════════════════════════

class _ReadinessCard extends StatelessWidget {
  final CareerProgressSnapshot snapshot;
  final bool available;

  const _ReadinessCard({
    required this.snapshot,
    required this.available,
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
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _readinessTile(
            emoji: '🎤',
            label: 'Interview Readiness',
            score: snapshot.interviewReadinessScore,
          ),
        ),
      ],
    );
  }

  Widget _readinessTile({
    required String emoji,
    required String label,
    required int score,
  }) {
    final s = score.clamp(0, 100);

    final Color color;
    if (s >= 70) {
      color = const Color(0xFF4ADE80);
    } else if (s >= 40) {
      color = const Color(0xFFF59E0B);
    } else {
      color = const Color(0xFF888899);
    }

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
                    fontSize: 12,
                  ),
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
                fontSize: 24,
              ),
            )
          else
            const Text(
              'Insufficient data',
              style: TextStyle(
                color: Color(0xFF888899),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: available ? (s / 100).clamp(0.0, 1.0) : 0.0,
              minHeight: 5,
              backgroundColor: const Color(0xFF0F0F20),
              valueColor: AlwaysStoppedAnimation(
                available ? color : const Color(0xFF444455),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// XP CHART
// ══════════════════════════════════════════════════════════════════════

class _XpChart extends StatelessWidget {
  final List<ProgressEntry> chartData;
  final int maxXp;

  const _XpChart({
    required this.chartData,
    required this.maxXp,
  });

  @override
  Widget build(BuildContext context) {
    if (chartData.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A2A40)),
        ),
        child: const Center(
          child: Text(
            'No activity data yet',
            style: TextStyle(color: Color(0xFF888899)),
          ),
        ),
      );
    }

    const dayLabels = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

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

          final pct = maxXp <= 0
              ? 0.0
              : (item.xpEarned / maxXp).clamp(0.0, 1.0);

          final day = dayLabels[item.date.weekday - 1];

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${item.xpEarned}',
                    style: const TextStyle(
                      color: Color(0xFFA78BFA),
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 400 + i * 50),
                    curve: Curves.easeOut,
                    height: 80 * pct + 4,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7C3AED),
                          Color(0xFFA78BFA),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    day,
                    style: const TextStyle(
                      color: Color(0xFF888899),
                      fontSize: 10,
                    ),
                  ),
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
// HISTORY
// ══════════════════════════════════════════════════════════════════════

class _HistoryRow extends StatelessWidget {
  final ProgressEntry entry;

  const _HistoryRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final pct = entry.completionRate.clamp(0.0, 1.0);
    final d = entry.date;

    final label =
        '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF888899),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 6,
                backgroundColor: const Color(0xFF2A2A40),
                valueColor: const AlwaysStoppedAnimation(
                  Color(0xFF7C3AED),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${entry.goalsCompleted}/${entry.totalGoals}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+${entry.xpEarned}',
              style: const TextStyle(
                color: Color(0xFFA78BFA),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
