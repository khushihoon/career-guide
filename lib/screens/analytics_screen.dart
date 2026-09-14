// ══════════════════════════════════════════════════════════════════════
// lib/screens/analytics_screen.dart
// NEW — Learning analytics: velocity, skill mastery, career readiness
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quest_models.dart';
import '../models/copilot_models.dart';
import '../services/copilot_provider.dart';
import '../widgets/glassmorphism_card.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  static const _bg       = Color(0xFF0F0F1A);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);

  AnalyticsSnapshot? _snap;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('analytics')
          .doc(uid)
          .get();

      if (!doc.exists) {
        if (mounted) setState(() => _loading = false);
        return;
      }

      final d = doc.data()!;
      final weeklyRaw =
          List<Map<String, dynamic>>.from(d['weeklyXp'] as List? ?? []);
      final skillRaw =
          Map<String, dynamic>.from(d['skillMastery'] as Map? ?? {});

      final snap = AnalyticsSnapshot(
        weeklyXp: weeklyRaw
            .map((e) => WeeklyXp(
                  weekLabel: e['week'] as String,
                  xp: (e['xp'] as int?) ?? 0,
                ))
            .toList(),
        skillMastery: skillRaw
            .map((k, v) => MapEntry(k, (v as num).toDouble())),
        careerReadinessScore:
            (d['careerReadinessScore'] as int?) ?? 0,
        learningVelocity:
            (d['learningVelocity'] as num?)?.toDouble() ?? 0,
        totalGoalsCompleted:
            (d['totalGoalsCompleted'] as int?) ?? 0,
      );

      if (mounted) setState(() { _snap = snap; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl  = CopilotProvider.maybeOf(context);
    final state = ctrl?.state;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Analytics',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _primary))
          : ListView(
              padding: const EdgeInsets.all(18),
              children: [
                // Career readiness
                _CareerReadinessCard(
                  score: _snap?.careerReadinessScore ?? 0,
                  velocity: _snap?.learningVelocity ?? 0,
                ).animate().fadeIn(),

                const SizedBox(height: 16),

                // Weekly XP chart
                if (_snap != null && _snap!.weeklyXp.isNotEmpty) ...[
                  _WeeklyXpChart(weeks: _snap!.weeklyXp)
                      .animate()
                      .fadeIn(delay: 100.ms),
                  const SizedBox(height: 16),
                ],

                // Skill mastery
                if (_snap != null && _snap!.skillMastery.isNotEmpty) ...[
                  _SkillMasteryList(mastery: _snap!.skillMastery)
                      .animate()
                      .fadeIn(delay: 200.ms),
                  const SizedBox(height: 16),
                ],

                // Stats grid
                if (state != null) ...[
                  _StatsGrid(
                    state: state,
                    totalGoals: _snap?.totalGoalsCompleted ?? 0,
                  ).animate().fadeIn(delay: 300.ms),
                ],

                const SizedBox(height: 40),
              ],
            ),
    );
  }
}

class _CareerReadinessCard extends StatelessWidget {
  final int score;
  final double velocity;
  const _CareerReadinessCard(
      {required this.score, required this.velocity});

  @override
  Widget build(BuildContext context) {
    final pct = score / 100.0;
    final color = score >= 75
        ? const Color(0xFF6EE7B7)
        : score >= 50
            ? const Color(0xFFFBBF24)
            : const Color(0xFFF87171);

    return GlassCard(
      gradientColors: [
        const Color(0xFF7C3AED).withOpacity(0.18),
        const Color(0xFFA78BFA).withOpacity(0.06),
      ],
      borderColor: const Color(0xFF7C3AED).withOpacity(0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Career Readiness Score',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              // Circular indicator
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: pct,
                      strokeWidth: 7,
                      backgroundColor:
                          const Color(0xFF2A2A40),
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                    Text(
                      '$score',
                      style: TextStyle(
                          color: color,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      score >= 75
                          ? 'Job-Ready'
                          : score >= 50
                              ? 'Progressing Well'
                              : 'Keep Building',
                      style: TextStyle(
                          color: color,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Learning velocity: ${velocity.toStringAsFixed(1)} XP/day',
                      style: const TextStyle(
                          color: Color(0xFF888899), fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      score < 100
                          ? '${100 - score} points to perfect score'
                          : 'Perfect score! 🎉',
                      style: const TextStyle(
                          color: Color(0xFF888899), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklyXpChart extends StatelessWidget {
  final List<WeeklyXp> weeks;
  const _WeeklyXpChart({required this.weeks});

  @override
  Widget build(BuildContext context) {
    final maxXp = weeks.map((w) => w.xp).reduce((a, b) => a > b ? a : b);
    final show  = weeks.length > 8 ? weeks.sublist(weeks.length - 8) : weeks;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weekly XP',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: show.map((w) {
                final frac = maxXp == 0 ? 0.0 : w.xp / maxXp;
                return Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: (80 * frac).clamp(4.0, 80.0),
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
                          w.weekLabel.replaceAll('Jun ', ''),
                          style: const TextStyle(
                              color: Color(0xFF888899),
                              fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillMasteryList extends StatelessWidget {
  final Map<String, double> mastery;
  const _SkillMasteryList({required this.mastery});

  @override
  Widget build(BuildContext context) {
    final sorted = mastery.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Skill Mastery',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          ...sorted.take(6).map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(e.key,
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12)),
                        ),
                        Text(
                          '${(e.value * 100).toInt()}%',
                          style: const TextStyle(
                              color: Color(0xFFA78BFA),
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: e.value,
                        minHeight: 5,
                        backgroundColor: const Color(0xFF2A2A40),
                        valueColor:
                            AlwaysStoppedAnimation(
                          e.value >= 0.8
                              ? const Color(0xFF6EE7B7)
                              : e.value >= 0.5
                                  ? const Color(0xFF7C3AED)
                                  : const Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final CopilotState state;
  final int totalGoals;
  const _StatsGrid({required this.state, required this.totalGoals});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _StatCell('🔥', '${state.currentStreak}', 'Current Streak'),
        _StatCell('⚡', '${state.totalXp}', 'Total XP'),
        _StatCell('✅', '$totalGoals', 'Goals Completed'),
        _StatCell('🏆',
            '${LevelSystem.levelFor(state.totalXp)}',
            'Current Level'),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  const _StatCell(this.emoji, this.value, this.label);

  @override
  Widget build(BuildContext context) => GlassCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF888899), fontSize: 10)),
          ],
        ),
      );
}