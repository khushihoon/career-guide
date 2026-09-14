import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/copilot_models.dart';
import '../services/copilot_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  static const _bg       = Color(0xFF0F0F1A);
  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: maybeOf use karo
    final ctrl = CopilotProvider.maybeOf(context);
    
    // ✅ Agar provider nahi mila to loading dikhao
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

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text('Progress',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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
            const SizedBox(height: 24),
            const Text('7-Day XP',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
            const SizedBox(height: 12),
            _XpChart(chartData: chartData, maxXp: maxXp)
                .animate()
                .fadeIn(delay: 100.ms),
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
                    style: const TextStyle(
                        color: Color(0xFF888899), fontSize: 12)),
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
                      style:
                          TextStyle(color: Color(0xFF888899), fontSize: 13)),
                ),
              )
            else
              ...history.reversed.take(14).toList().asMap().entries.map(
                    (entry) => _HistoryRow(entry: entry.value)
                        .animate()
                        .fadeIn(delay: Duration(milliseconds: entry.key * 50)),
                  ),
          ],
        ),
      ),
    );
  }
}

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
          final i    = entry.key;
          final item = entry.value;
          final pct  = maxXp == 0 ? 0.0 : item.xpEarned / maxXp;
          final day  = dayLabels[item.date.weekday - 1];

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

class _HistoryRow extends StatelessWidget {
  final ProgressEntry entry;
  const _HistoryRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final pct = entry.completionRate;
    final d   = entry.date;
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