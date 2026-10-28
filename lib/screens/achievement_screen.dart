// ══════════════════════════════════════════════════════════════════════
// lib/screens/achievement_screen.dart
//
// Achievement cabinet — read-only UI layer.
//
// Consumes AchievementService.fetchUserAchievements(uid) and renders the
// full achievement cabinet: a summary bar, an overall progress section,
// a rarity filter, and a responsive grid of achievement cards. Tapping a
// card opens a details sheet with the same real data the card shows.
//
// This screen NEVER:
//   • calls checkAndUnlock or writes achievement data
//   • duplicates achievement definitions
//   • invents progress, unlock dates, or career signals
//   • accesses Firestore directly
//   • mutates the fetched achievement list
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/achievement_models.dart';
import '../services/achievement_service.dart';
import '../widgets/glassmorphism_card.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  static const _bg = Color(0xFF0F0F1A);
  static const _surface = Color(0xFF1A1A2E);
  static const _border = Color(0xFF2A2A40);
  static const _primary = Color(0xFF7C3AED);
  static const _muted = Color(0xFF888899);

  final _service = AchievementService();

  List<Achievement> _achievements = const [];
  bool _loading = true;
  bool _errored = false;
  bool _noUser = false;
  AchievementRarity? _filter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (!mounted) return;
    setState(() {
      _loading = true;
      _errored = false;
      _noUser = uid == null;
    });

    if (uid == null) {
      if (!mounted) return;
      setState(() {
        _achievements = const [];
        _loading = false;
      });
      return;
    }

    try {
      final list = await _service.fetchUserAchievements(uid);
      if (!mounted) return;
      setState(() {
        _achievements = list;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errored = true;
        _loading = false;
      });
    }
  }

  /// Filtered view — returns a NEW list, never mutates [_achievements].
  List<Achievement> get _filtered => _filter == null
      ? _achievements
      : _achievements.where((a) => a.rarity == _filter).toList();

  int get _unlockedCount => _achievements.where((a) => a.isUnlocked).length;

  int get _totalCount => _achievements.length;

  double get _overallProgress =>
      _totalCount == 0 ? 0.0 : _unlockedCount / _totalCount;

  /// Rarity chip tap handler.
  ///   • Tapping the SAME rarity twice clears the filter (back to All).
  ///   • Tapping a different rarity selects it.
  void _onSelectRarity(AchievementRarity r) {
    setState(() => _filter = _filter == r ? null : r);
  }

  /// "All" chip tap handler — always clears the filter.
  void _onSelectAll() {
    setState(() => _filter = null);
  }

  void _openDetails(Achievement a) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AchievementDetailsSheet(achievement: a),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Achievements',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              _totalCount == 0
                  ? '—'
                  : '$_unlockedCount / $_totalCount unlocked',
              style: const TextStyle(color: _muted, fontSize: 11),
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: _primary));
    }

    if (_noUser) {
      return const _CenteredMessage(
        icon: Icons.lock_outline,
        title: 'Sign in to view your achievements',
        subtitle:
            'Your achievement cabinet is tied to your account. Sign in and come back to see your progress.',
      );
    }

    if (_errored) {
      return _CenteredMessage(
        icon: Icons.cloud_off,
        title: 'Couldn\'t load achievements',
        subtitle: 'Something went wrong while fetching your cabinet.',
        actionLabel: 'Retry',
        onAction: _load,
      );
    }

    if (_achievements.isEmpty) {
      return const _CenteredMessage(
        icon: Icons.emoji_events_outlined,
        title: 'No achievements yet',
        subtitle:
            'Start completing goals, building streaks, and growing your roadmap to unlock achievements.',
      );
    }

    final filtered = _filtered;

    return RefreshIndicator(
      color: _primary,
      backgroundColor: _surface,
      onRefresh: _load,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: _SummaryCard(
                unlocked: _unlockedCount,
                total: _totalCount,
                progress: _overallProgress,
              ).animate().fadeIn(duration: 220.ms),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: _FilterRow(
                selected: _filter,
                onSelectAll: _onSelectAll,
                onSelectRarity: _onSelectRarity,
              ).animate().fadeIn(delay: 60.ms),
            ),
          ),
          if (filtered.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _CenteredMessage(
                icon: Icons.filter_alt_off_outlined,
                title: 'No achievements in this rarity yet',
                subtitle:
                    'Try a different rarity, or clear the filter to see all achievements.',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  // Responsive: 2 columns on typical phones, 3 on wider
                  // ones. Never below 2 so cards stay readable.
                  final width = constraints.crossAxisExtent;
                  final columns = width >= 640 ? 3 : 2;
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.82,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _AchievementCell(
                        achievement: filtered[i],
                        onTap: () => _openDetails(filtered[i]),
                      ).animate().fadeIn(delay: (i * 35).ms, duration: 240.ms),
                      childCount: filtered.length,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// SUMMARY CARD — unlocked / total + overall progress
// ══════════════════════════════════════════════════════════════════════

class _SummaryCard extends StatelessWidget {
  final int unlocked;
  final int total;
  final double progress;

  const _SummaryCard({
    required this.unlocked,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (progress.clamp(0.0, 1.0) * 100).round();

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
              const Icon(Icons.emoji_events,
                  color: Color(0xFFA78BFA), size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Achievement Cabinet',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              Text(
                '$pct%',
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
              value: progress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: const Color(0xFF0F0F20),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF7C3AED)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$unlocked of $total achievements unlocked',
            style: const TextStyle(
                color: Color(0xFF888899),
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// FILTER ROW — rarity chips
// ══════════════════════════════════════════════════════════════════════

class _FilterRow extends StatelessWidget {
  final AchievementRarity? selected;
  final VoidCallback onSelectAll;
  final ValueChanged<AchievementRarity> onSelectRarity;

  const _FilterRow({
    required this.selected,
    required this.onSelectAll,
    required this.onSelectRarity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _chip(
            label: 'All',
            isSelected: selected == null,
            colors: const [Color(0xFF7C3AED), Color(0xFFA78BFA)],
            onTap: onSelectAll,
          ),
          const SizedBox(width: 8),
          ...AchievementRarity.values.map((r) {
            final colors = r.gradientHex.map((c) => Color(c)).toList();
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _chip(
                label: r.label,
                isSelected: selected == r,
                colors: colors,
                onTap: () => onSelectRarity(r),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool isSelected,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(colors: colors) : null,
          color: isSelected ? null : const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colors[0] : const Color(0xFF2A2A40),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF888899),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// ACHIEVEMENT CELL — grid card
// ══════════════════════════════════════════════════════════════════════

class _AchievementCell extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback onTap;

  const _AchievementCell({
    required this.achievement,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = achievement.rarity.gradientHex.map((c) => Color(c)).toList();
    final locked = !achievement.isUnlocked;

    // UI-side safe progress — never mutate the model.
    final target = achievement.progressTarget;
    final current =
        achievement.progressCurrent < 0 ? 0 : achievement.progressCurrent;
    final safeTarget = target < 0 ? 0 : target;
    final safeProgress =
        achievement.progress.isNaN ? 0.0 : achievement.progress.clamp(0.0, 1.0);

    final showNumericProgress = locked && safeTarget > 1;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        gradientColors: locked
            ? null
            : [
                colors[0].withOpacity(0.20),
                colors[1].withOpacity(0.08),
              ],
        borderColor:
            locked ? const Color(0xFF2A2A40) : colors[0].withOpacity(0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: locked ? null : LinearGradient(colors: colors),
                    color: locked ? const Color(0xFF2A2A40) : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: locked
                        ? const Icon(Icons.lock,
                            color: Color(0xFF444455), size: 20)
                        : Text(achievement.icon,
                            style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: locked ? const Color(0xFF2A2A40) : colors[0],
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              achievement.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: locked ? const Color(0xFF888899) : Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Expanded(
              child: Text(
                achievement.description,
                style: const TextStyle(
                    color: Color(0xFF888899), fontSize: 10, height: 1.3),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            if (!locked)
              LinearProgressIndicator(
                value: 1.0,
                minHeight: 3,
                backgroundColor: colors[0].withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation(colors[0]),
              )
            else if (showNumericProgress)
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: safeProgress,
                      minHeight: 3,
                      backgroundColor: const Color(0xFF2A2A40),
                      valueColor:
                          const AlwaysStoppedAnimation(Color(0xFF7C3AED)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$current/$safeTarget',
                    style:
                        const TextStyle(color: Color(0xFF888899), fontSize: 9),
                  ),
                ],
              )
            else
              const SizedBox(height: 3),
            const SizedBox(height: 4),
            Text(
              locked
                  ? achievement.rarity.label
                  : '+${achievement.xpBonus} XP earned',
              style: TextStyle(
                color: locked ? const Color(0xFF444455) : colors[0],
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// DETAILS SHEET — real data, read-only
// ══════════════════════════════════════════════════════════════════════

class _AchievementDetailsSheet extends StatelessWidget {
  final Achievement achievement;

  const _AchievementDetailsSheet({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final colors = achievement.rarity.gradientHex.map((c) => Color(c)).toList();
    final locked = !achievement.isUnlocked;

    final target =
        achievement.progressTarget < 0 ? 0 : achievement.progressTarget;
    final current =
        achievement.progressCurrent < 0 ? 0 : achievement.progressCurrent;
    final safeProgress =
        achievement.progress.isNaN ? 0.0 : achievement.progress.clamp(0.0, 1.0);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A40),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: locked ? null : LinearGradient(colors: colors),
                    color: locked ? const Color(0xFF2A2A40) : null,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: locked
                        ? const Icon(Icons.lock,
                            color: Color(0xFF444455), size: 24)
                        : Text(achievement.icon,
                            style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: locked
                              ? const Color(0xFF2A2A40)
                              : colors[0].withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: locked
                                ? const Color(0xFF2A2A40)
                                : colors[0].withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          achievement.rarity.label,
                          style: TextStyle(
                              color:
                                  locked ? const Color(0xFF888899) : colors[0],
                              fontSize: 10,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              achievement.description,
              style: const TextStyle(
                  color: Color(0xFFCCCCDD), fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 18),
            if (locked) ...[
              const Text(
                'CURRENT PROGRESS',
                style: TextStyle(
                    color: Color(0xFF888899),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: safeProgress,
                        minHeight: 6,
                        backgroundColor: const Color(0xFF2A2A40),
                        valueColor:
                            const AlwaysStoppedAnimation(Color(0xFF7C3AED)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    target > 0 ? '$current / $target' : '$current',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '+${achievement.xpBonus} XP reward when unlocked',
                style: const TextStyle(
                    color: Color(0xFFA78BFA),
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors[0].withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors[0].withOpacity(0.35)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: colors[0], size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Unlocked',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '+${achievement.xpBonus} XP earned',
                            style: TextStyle(
                                color: colors[0],
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'UNLOCKED ON',
                style: TextStyle(
                    color: Color(0xFF888899),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4),
              ),
              const SizedBox(height: 4),
              Text(
                _formatUnlockedAt(achievement.unlockedAt),
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ],
            const SizedBox(height: 18),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close',
                    style: TextStyle(color: Color(0xFF888899))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatUnlockedAt(DateTime? at) {
    if (at == null) return '—';
    final d = at.toLocal();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    final hh = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$dd/$mm/$yyyy · $hh:$min';
  }
}

// ══════════════════════════════════════════════════════════════════════
// CENTERED MESSAGE — loading-safe empty / error / no-user state
// ══════════════════════════════════════════════════════════════════════

class _CenteredMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _CenteredMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF444455), size: 56),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xFF888899), fontSize: 13, height: 1.4),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  actionLabel!,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
