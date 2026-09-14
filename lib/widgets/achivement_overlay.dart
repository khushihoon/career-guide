// ══════════════════════════════════════════════════════════════════════
// lib/widgets/achievement_overlay.dart
//
// Listens to EngagementController.achievementUnlocked stream.
// Shows a bottom-slide achievement popup whenever an achievement unlocks.
// Works on top of ANY screen automatically — no per-screen code needed.
// ══════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import '../models/engagement_models.dart';


class AchievementOverlay extends StatefulWidget {
  final Widget child;
  const AchievementOverlay({super.key, required this.child});

  @override
  State<AchievementOverlay> createState() => _AchievementOverlayState();
}

class _AchievementOverlayState extends State<AchievementOverlay> {
  StreamSubscription<Achievement>? _sub;
  final List<Achievement> _queue = [];
  bool _showing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sub?.cancel();
    final ctrl = EngagementProvider.maybeOf(context);
    if (ctrl != null) {
      _sub = ctrl.achievementUnlocked.listen((a) {
        _queue.add(a);
        _showNext();
      });

      // Level-up listener
      ctrl.leveledUp.listen((level) {
        if (mounted) _showLevelUp(level);
      });
    }
  }

  void _showNext() {
    if (_showing || _queue.isEmpty || !mounted) return;
    _showing = true;
    final achievement = _queue.removeAt(0);
    _showAchievementBanner(achievement);
  }

  void _showAchievementBanner(Achievement a) {
    final rarityColor =
        Color(int.parse('FF${a.rarityColor}', radix: 16));

    final overlay = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 90,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: _AchievementBanner(
            achievement: a,
            rarityColor: rarityColor,
          ).animate()
            .slideY(begin: 1.5, end: 0, duration: 400.ms,
                    curve: Curves.easeOutBack)
            .fadeIn(duration: 300.ms),
        ),
      ),
    );

    Overlay.of(context).insert(overlay);

    Future.delayed(const Duration(seconds: 3), () {
      overlay.remove();
      _showing = false;
      _showNext();
    });
  }

  void _showLevelUp(XpLevel level) {
    final color = Color(int.parse('FF${level.color}', radix: 16));

    final overlay = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 90,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: _LevelUpBanner(level: level, color: color)
              .animate()
              .slideY(begin: 1.5, end: 0, duration: 400.ms,
                      curve: Curves.easeOutBack)
              .fadeIn(duration: 300.ms),
        ),
      ),
    );

    Overlay.of(context).insert(overlay);
    Future.delayed(const Duration(seconds: 3), overlay.remove);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

// ── Achievement Banner Widget ─────────────────────────────────────────
class _AchievementBanner extends StatelessWidget {
  final Achievement achievement;
  final Color       rarityColor;

  const _AchievementBanner({
    required this.achievement,
    required this.rarityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: rarityColor.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: rarityColor.withOpacity(0.25),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(children: [
        // Emoji with glow
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: rarityColor.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: rarityColor.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: rarityColor.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(achievement.emoji,
                style: const TextStyle(fontSize: 26)),
          ),
        ),
        const SizedBox(width: 12),

        // Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: rarityColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '🏆 ${achievement.rarityLabel.toUpperCase()} ACHIEVEMENT',
                    style: TextStyle(
                        color: rarityColor,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5),
                  ),
                ),
              ]),
              const SizedBox(height: 3),
              Text(achievement.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Text(achievement.description,
                  style: const TextStyle(
                      color: Color(0xFF888899), fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // XP reward
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '+${achievement.xpReward}',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
        ),
      ]),
    );
  }
}

// ── Level Up Banner Widget ────────────────────────────────────────────
class _LevelUpBanner extends StatelessWidget {
  final XpLevel level;
  final Color   color;

  const _LevelUpBanner({required this.level, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.25), const Color(0xFF1A1A2E)],
          begin: Alignment.topLeft,
          end:   Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color:      color.withOpacity(0.3),
            blurRadius: 24,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Row(children: [
        Text(level.emoji, style: const TextStyle(fontSize: 36))
            .animate()
            .scale(duration: 400.ms, curve: Curves.elasticOut),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('LEVEL UP!',
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 1.2)),
              const SizedBox(height: 2),
              Text('You\'re now ${level.title}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              Text('Level ${level.level} · Keep going! 🚀',
                  style: const TextStyle(
                      color: Color(0xFF888899), fontSize: 12)),
            ],
          ),
        ),
      ]),
    );
  }
}