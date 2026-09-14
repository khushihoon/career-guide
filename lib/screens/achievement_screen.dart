// ══════════════════════════════════════════════════════════════════════
// lib/screens/achievement_screen.dart
// NEW — Achievement badge cabinet with rarity filtering
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
  static const _bg      = Color(0xFF0F0F1A);
  static const _primary = Color(0xFF7C3AED);
  static const _muted   = Color(0xFF888899);

  final _service = AchievementService();
  List<Achievement> _achievements = [];
  bool _loading = true;
  AchievementRarity? _filter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    setState(() => _loading = true);
    final list = await _service.fetchUserAchievements(uid);
    if (mounted) setState(() { _achievements = list; _loading = false; });
  }

  List<Achievement> get _filtered => _filter == null
      ? _achievements
      : _achievements.where((a) => a.rarity == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final unlocked = _achievements.where((a) => a.isUnlocked).length;
    final total    = _achievements.length;

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
            const Text('Achievements',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
            Text('$unlocked / $total unlocked',
                style: const TextStyle(color: _muted, fontSize: 11)),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _primary))
          : Column(
              children: [
                _FilterRow(
                  selected: _filter,
                  onSelect: (r) =>
                      setState(() => _filter = _filter == r ? null : r),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _AchievementCell(
                      achievement: _filtered[i],
                    ).animate().fadeIn(delay: (i * 40).ms),
                  ),
                ),
              ],
            ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final AchievementRarity? selected;
  final ValueChanged<AchievementRarity> onSelect;

  const _FilterRow({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: AchievementRarity.values.map((r) {
          final isSelected = selected == r;
          final colors = r.gradientHex.map((c) => Color(c)).toList();
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelect(r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(colors: colors)
                      : null,
                  color: isSelected
                      ? null
                      : const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? colors[0]
                        : const Color(0xFF2A2A40),
                  ),
                ),
                child: Text(
                  r.label,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF888899),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AchievementCell extends StatelessWidget {
  final Achievement achievement;
  const _AchievementCell({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final colors = achievement.rarity.gradientHex
        .map((c) => Color(c))
        .toList();
    final locked = !achievement.isUnlocked;

    return GlassCard(
      padding: const EdgeInsets.all(14),
      gradientColors: locked
          ? null
          : [
              colors[0].withOpacity(0.2),
              colors[1].withOpacity(0.1),
            ],
      borderColor: locked
          ? const Color(0xFF2A2A40)
          : colors[0].withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: locked
                      ? null
                      : LinearGradient(colors: colors),
                  color: locked
                      ? const Color(0xFF2A2A40)
                      : null,
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
              // Rarity pip
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: locked
                      ? const Color(0xFF2A2A40)
                      : colors[0],
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            achievement.title,
            style: TextStyle(
              color: locked ? const Color(0xFF444455) : Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            achievement.description,
            style: const TextStyle(
                color: Color(0xFF888899), fontSize: 10, height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          if (!locked) ...[
            LinearProgressIndicator(
              value: 1.0,
              minHeight: 3,
              backgroundColor: colors[0].withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(colors[0]),
            ),
          ] else if (achievement.progressTarget > 1) ...[
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: achievement.progress,
                    minHeight: 3,
                    backgroundColor: const Color(0xFF2A2A40),
                    valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF7C3AED)),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${achievement.progressCurrent}/${achievement.progressTarget}',
                  style: const TextStyle(
                      color: Color(0xFF888899), fontSize: 9),
                ),
              ],
            ),
          ],
          const SizedBox(height: 4),
          Text(
            locked
                ? achievement.rarity.label
                : '+${achievement.xpBonus} XP earned',
            style: TextStyle(
              color: locked
                  ? const Color(0xFF444455)
                  : colors[0],
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}