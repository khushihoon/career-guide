
// ══════════════════════════════════════════════════════════════════════
// lib/widgets/achievement_overlay.dart
//
// Listens to EngagementController.achievementUnlocked and
// EngagementController.leveledUp streams and shows a bottom-slide popup
// for each event. Works on top of ANY screen automatically — no
// per-screen code needed.
//
// Presentation / lifecycle layer only:
//   • No Firestore, no API, no service calls
//   • No XP calculation, no achievement unlocking, no progress writes
//   • Achievement + level-up banners are queued and shown sequentially
//     so they never visually collide
//   • All subscriptions and overlays are lifecycle-safe
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
  StreamSubscription<Achievement>? _achievementSub;
  StreamSubscription<XpLevel>?     _levelUpSub;

  /// Unified notification queue. Only one notification is shown at a
  /// time; achievement and level-up banners are interleaved in the order
  /// their events arrived.
  final List<_PendingNotification> _queue = [];
  bool _showing = false;

  /// Ids of achievements currently queued or being shown — used for
  /// lightweight UI-level duplicate suppression so the same unlock event
  /// can't be shown twice in a row. This is NOT a database and does not
  /// affect AchievementService in any way.
  final Set<String> _visibleAchievementKeys = <String>{};

  /// Active overlay entry (only one at a time) and its auto-dismiss timer.
  OverlayEntry? _activeEntry;
  Timer? _dismissTimer;
  bool _entryInserted = false;

  // ── Lifecycle ───────────────────────────────────────────────────────

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attachListeners();
  }

  void _attachListeners() {
    // Always cancel previous subscriptions first so repeated
    // didChangeDependencies calls never accumulate listeners.
    _achievementSub?.cancel();
    _achievementSub = null;
    _levelUpSub?.cancel();
    _levelUpSub = null;

    final ctrl = EngagementProvider.maybeOf(context);
    if (ctrl == null) return;

    _achievementSub = ctrl.achievementUnlocked.listen(_onAchievementUnlocked);
    _levelUpSub     = ctrl.leveledUp.listen(_onLevelUp);
  }

  void _onAchievementUnlocked(Achievement a) {
    if (!mounted) return;
    final key = _achievementKey(a);
    if (_visibleAchievementKeys.contains(key)) return;
    _visibleAchievementKeys.add(key);
    _queue.add(_PendingNotification.achievement(a, key));
    _showNext();
  }

  void _onLevelUp(XpLevel level) {
    if (!mounted) return;
    _queue.add(_PendingNotification.levelUp(level));
    _showNext();
  }

  /// Stable-ish key for UI duplicate suppression. Prefers an `id` field
  /// if the model exposes one; otherwise falls back to title + rarity
  /// which is enough to avoid the same banner flashing twice in a row.
  String _achievementKey(Achievement a) {
    // ignore: avoid_dynamic_calls
    final dynamic dyn = a;
    try {
      final id = dyn.id;
      if (id is String && id.isNotEmpty) return 'id:$id';
    } catch (_) {
      // Model does not expose an id — fall through.
    }
    return 'k:${a.title}|${a.rarityLabel}';
  }

  // ── Notification pipeline ──────────────────────────────────────────

  void _showNext() {
    if (!mounted) return;
    if (_showing) return;
    if (_queue.isEmpty) return;

    final next = _queue.removeAt(0);
    _showing = true;

    switch (next.kind) {
      case _NotificationKind.achievement:
        _showAchievementBanner(next.achievement!, next.key!);
        break;
      case _NotificationKind.levelUp:
        _showLevelUpBanner(next.level!);
        break;
    }
  }

  void _showAchievementBanner(Achievement a, String bannerKey) {
    final rarityColor = _parseHexColor(a.rarityColor, const Color(0xFF7C3AED));

    _insertOverlay(
      builder: (_) => Positioned(
        bottom: 90,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: _AchievementBanner(
            achievement: a,
            rarityColor: rarityColor,
          )
              .animate()
              .slideY(
                begin: 1.5,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOutBack,
              )
              .fadeIn(duration: 300.ms),
        ),
      ),
      // Always clear the suppression key when this notification is
      // resolved — whether it was shown and dismissed, or could not be
      // inserted at all.
      onResolved: () {
        _visibleAchievementKeys.remove(bannerKey);
      },
    );
  }

  void _showLevelUpBanner(XpLevel level) {
    final color = _parseHexColor(level.color, const Color(0xFF7C3AED));

    _insertOverlay(
      builder: (_) => Positioned(
        bottom: 90,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: _LevelUpBanner(level: level, color: color)
              .animate()
              .slideY(
                begin: 1.5,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOutBack,
              )
              .fadeIn(duration: 300.ms),
        ),
      ),
    );
  }

  /// Inserts a single overlay entry and schedules its safe removal.
  /// Only one entry is active at a time.
  ///
  /// [onResolved] is invoked exactly once when this notification is
  /// finished — either after the normal dismissal timer fires, or when
  /// insertion could not proceed (missing overlay / insert error). It is
  /// NOT invoked from dispose(), so callers must not rely on it to clean
  /// up resources that outlive the widget.
  void _insertOverlay({
    required WidgetBuilder builder,
    void Function()? onResolved,
  }) {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      // No overlay available — clean up any per-notification state and
      // continue with the next queued one.
      onResolved?.call();
      _finishCurrent();
      return;
    }

    final entry = OverlayEntry(builder: builder);
    _activeEntry  = entry;
    _entryInserted = false;

    try {
      overlay.insert(entry);
      _entryInserted = true;
    } catch (_) {
      _activeEntry = null;
      _entryInserted = false;
      onResolved?.call();
      _finishCurrent();
      return;
    }

    _dismissTimer?.cancel();
    _dismissTimer = Timer(const Duration(seconds: 3), () {
      _safeRemoveOverlay();
      onResolved?.call();
      _finishCurrent();
    });
  }

  /// Removes the active overlay entry exactly once, tolerating any
  /// lifecycle race that may have already removed it.
  void _safeRemoveOverlay() {
    final entry = _activeEntry;
    _activeEntry = null;
    if (entry == null) return;
    if (!_entryInserted) return;
    _entryInserted = false;
    try {
      entry.remove();
    } catch (_) {
      // Already removed — safe to ignore.
    }
  }

  void _finishCurrent() {
    _showing = false;
    if (!mounted) return;
    // Small gap between notifications for readability.
    Future.delayed(const Duration(milliseconds: 150), () {
      if (!mounted) return;
      _showNext();
    });
  }

  @override
  void dispose() {
    _achievementSub?.cancel();
    _levelUpSub?.cancel();
    _achievementSub = null;
    _levelUpSub = null;

    _dismissTimer?.cancel();
    _dismissTimer = null;

    _safeRemoveOverlay();
    _queue.clear();
    _visibleAchievementKeys.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

// ── Queue model ────────────────────────────────────────────────────────

enum _NotificationKind { achievement, levelUp }

class _PendingNotification {
  final _NotificationKind kind;
  final Achievement? achievement;
  final XpLevel? level;

  /// Suppression key carried alongside an achievement notification so it
  /// can be released exactly once when the notification is resolved.
  final String? key;

  const _PendingNotification._({
    required this.kind,
    this.achievement,
    this.level,
    this.key,
  });

  factory _PendingNotification.achievement(Achievement a, String key) =>
      _PendingNotification._(
        kind: _NotificationKind.achievement,
        achievement: a,
        key: key,
      );

  factory _PendingNotification.levelUp(XpLevel level) =>
      _PendingNotification._(
        kind: _NotificationKind.levelUp,
        level: level,
      );
}

// ── Safe color parsing ────────────────────────────────────────────────

/// Parses a hex color string defensively. Accepts values with or without
/// a leading `#` or `0x`, and pads to 6 hex digits when needed. On any
/// failure, returns [fallback].
Color _parseHexColor(String? value, Color fallback) {
  if (value == null) return fallback;
  var v = value.trim();
  if (v.isEmpty) return fallback;

  if (v.startsWith('#')) v = v.substring(1);
  if (v.startsWith('0x') || v.startsWith('0X')) v = v.substring(2);

  if (v.length == 3) {
    // Expand shorthand e.g. 'abc' → 'aabbcc'
    v = v.split('').map((c) => '$c$c').join();
  }
  if (v.length == 6) {
    v = 'FF$v';
  }
  if (v.length != 8) return fallback;

  final parsed = int.tryParse(v, radix: 16);
  if (parsed == null) return fallback;
  return Color(parsed);
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
    return Semantics(
      liveRegion: true,
      label:
          'Achievement unlocked: ${achievement.title}. ${achievement.description}. Plus ${achievement.xpReward} XP.',
      child: Container(
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
      ),
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
    return Semantics(
      liveRegion: true,
      label:
          'Level up! You are now ${level.title}, level ${level.level}.',
      child: Container(
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
      ),
    );
  }
}