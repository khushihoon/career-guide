// ══════════════════════════════════════════════════════════════════════
// lib/widgets/glassmorphism_card.dart
// Reusable glassmorphism card, XP bar, level badge, achievement toast,
// quest card, daily reward box, AI companion card, and leaderboard tile.
//
// UI-only: every widget here displays data given to it and triggers
// callbacks passed in. No business logic, no Firestore, no service calls.
// ══════════════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/quest_models.dart';      // LevelSystem, LeaderboardEntry
import '../models/achievement_models.dart';

// ── Design tokens (shared across all widgets) ─────────────────────────
const _kBg       = Color(0xFF0F0F1A);
const _kSurface  = Color(0xFF1A1A2E);
const _kBorder   = Color(0xFF2A2A40);
const _kPrimary  = Color(0xFF7C3AED);
const _kSecondary= Color(0xFFA78BFA);
const _kMuted    = Color(0xFF888899);

// ════════════════════════════════════════════════════════════════════════
// GlassCard — frosted glass container
// ════════════════════════════════════════════════════════════════════════
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
    this.borderColor,
    this.backgroundColor,
    this.gradientColors,
    this.onTap,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final interactive = widget.onTap != null;

    Widget content = ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: BackdropFilter(
        // Moderate blur — enough for the frosted effect without hurting
        // scroll performance on low-end devices.
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AnimatedScale(
          scale: _pressed ? 0.985 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Container(
            padding: widget.padding ?? const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: widget.gradientColors != null
                  ? LinearGradient(
                      colors: widget.gradientColors!,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: widget.gradientColors == null
                  ? (widget.backgroundColor ?? _kSurface.withOpacity(0.8))
                  : null,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: widget.borderColor ?? _kBorder.withOpacity(0.6),
                width: 1,
              ),
            ),
            child: widget.child,
          ),
        ),
      ),
    );

    if (!interactive) {
      return Semantics(container: true, child: content);
    }

    return Semantics(
      container: true,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: content,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
// XpProgressBar — level + animated progress bar
// ════════════════════════════════════════════════════════════════════════
class XpProgressBar extends StatelessWidget {
  final int totalXp;
  final bool compact;

  const XpProgressBar({
    super.key,
    required this.totalXp,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final safeXp    = totalXp < 0 ? 0 : totalXp;
    final level     = LevelSystem.levelFor(safeXp);
    final title     = LevelSystem.titleFor(safeXp);
    final progress  = LevelSystem.progressInLevel(safeXp).clamp(0.0, 1.0);
    final xpToNext  = LevelSystem.xpForNextLevel(safeXp);
    final atMaxLvl  = xpToNext <= 0;

    if (compact) {
      return _compact(level, progress);
    }

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      gradientColors: [
        _kPrimary.withOpacity(0.18),
        _kSecondary.withOpacity(0.08),
      ],
      borderColor: _kPrimary.withOpacity(0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _LevelBadge(level: level),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      atMaxLvl
                          ? 'Max level reached'
                          : '$xpToNext XP to Level ${level + 1}',
                      style: const TextStyle(
                          color: _kMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Text(
                '$safeXp XP',
                style: const TextStyle(
                  color: _kSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 7,
                decoration: BoxDecoration(
                  color: _kBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 7,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_kPrimary, _kSecondary],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: _kPrimary.withOpacity(0.5),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ).animate().scaleX(
                    duration: 800.ms,
                    curve: Curves.easeOut,
                    alignment: Alignment.centerLeft,
                  ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _compact(int level, double progress) => Row(
        children: [
          _LevelBadge(level: level, size: 28),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: _kBorder,
                valueColor: const AlwaysStoppedAnimation(_kPrimary),
              ),
            ),
          ),
        ],
      );
}

class _LevelBadge extends StatelessWidget {
  final int level;
  final double size;
  const _LevelBadge({required this.level, this.size = 40});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_kPrimary, _kSecondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(size * 0.28),
          boxShadow: [
            BoxShadow(
              color: _kPrimary.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$level',
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.38,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}

// ════════════════════════════════════════════════════════════════════════
// AchievementToast — overlay that pops up on badge unlock
// ════════════════════════════════════════════════════════════════════════
class AchievementToast extends StatelessWidget {
  final Achievement achievement;

  const AchievementToast({super.key, required this.achievement});

  /// Tracks the currently-visible toast id per overlay so two rapid
  /// unlocks of the SAME achievement can't stack visually. This is UI
  /// state only — unlocking logic remains in AchievementService.
  static final Set<String> _visibleIds = <String>{};

  static void show(BuildContext context, Achievement achievement) {
    if (_visibleIds.contains(achievement.id)) return;
    _visibleIds.add(achievement.id);

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      _visibleIds.remove(achievement.id);
      return;
    }

    late OverlayEntry entry;
    bool removed = false;
    void safeRemove() {
      if (removed) return;
      removed = true;
      _visibleIds.remove(achievement.id);
      if (entry.mounted) entry.remove();
    }

    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        child: _AchievementToastWidget(
          achievement: achievement,
          onDismiss: safeRemove,
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 4), safeRemove);
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _AchievementToastWidget extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback onDismiss;
  const _AchievementToastWidget(
      {required this.achievement, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final colors = achievement.rarity.gradientHex
        .map((c) => Color(c))
        .toList();
    final top = colors.isNotEmpty ? colors[0] : _kPrimary;
    final bottom = colors.length > 1 ? colors[1] : _kSecondary;

    return Material(
      color: Colors.transparent,
      child: Semantics(
        button: true,
        label:
            'Achievement unlocked: ${achievement.title}. Tap to dismiss.',
        child: GestureDetector(
          onTap: onDismiss,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  top.withOpacity(0.95),
                  bottom.withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: top.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(achievement.icon,
                    style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Achievement Unlocked!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              achievement.rarity.label.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        achievement.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '+${achievement.xpBonus} XP',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              .animate()
              .slideY(begin: -1, duration: 400.ms, curve: Curves.easeOut)
              .fadeIn(duration: 300.ms),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
// QuestCard — single quest tile with progress
// ════════════════════════════════════════════════════════════════════════
class QuestCard extends StatelessWidget {
  final Quest quest;
  final VoidCallback? onClaim;

  const QuestCard({super.key, required this.quest, this.onClaim});

  @override
  Widget build(BuildContext context) {
    final isCompleted = quest.isCompleted;
    final isExpired   = quest.isExpired && !isCompleted;

    final current = quest.progressCurrent < 0 ? 0 : quest.progressCurrent;
    final target  = quest.progressTarget <= 0 ? 0 : quest.progressTarget;
    final remaining = target > current ? target - current : 0;
    final progress = quest.progressPercent.isNaN
        ? 0.0
        : quest.progressPercent.clamp(0.0, 1.0);

    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderColor: isCompleted
          ? _kPrimary.withOpacity(0.5)
          : _kBorder.withOpacity(0.5),
      gradientColors: isCompleted
          ? [_kPrimary.withOpacity(0.15), _kSecondary.withOpacity(0.07)]
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon bubble
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted
                  ? _kPrimary.withOpacity(0.2)
                  : _kBorder.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                quest.type.emoji,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quest.title,
                  style: TextStyle(
                    color: isExpired ? _kMuted : Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration:
                        isExpired ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  quest.description,
                  style: const TextStyle(color: _kMuted, fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 4,
                          backgroundColor: _kBorder,
                          valueColor: AlwaysStoppedAnimation(
                            isCompleted
                                ? const Color(0xFF6EE7B7)
                                : _kPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      target > 0 ? '$current/$target' : '$current',
                      style: const TextStyle(
                          color: _kMuted, fontSize: 10),
                    ),
                  ],
                ),
                if (!isCompleted && !isExpired && remaining > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    '$remaining to go',
                    style: const TextStyle(
                        color: _kMuted, fontSize: 10),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          // XP badge or claim button
          if (isCompleted && onClaim != null)
            Semantics(
              button: true,
              label: 'Claim ${quest.xpReward} XP',
              child: GestureDetector(
                onTap: onClaim,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [_kPrimary, _kSecondary]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Claim',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _kPrimary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${quest.xpReward}',
                style: const TextStyle(
                    color: _kSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
// DailyRewardBox — animated reward box widget
// ════════════════════════════════════════════════════════════════════════
class DailyRewardBox extends StatefulWidget {
  final bool canClaim;
  final VoidCallback onClaim;
  final int streak;

  const DailyRewardBox({
    super.key,
    required this.canClaim,
    required this.onClaim,
    required this.streak,
  });

  @override
  State<DailyRewardBox> createState() => _DailyRewardBoxState();
}

class _DailyRewardBoxState extends State<DailyRewardBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.canClaim) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(DailyRewardBox old) {
    super.didUpdateWidget(old);
    if (widget.canClaim && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!widget.canClaim && _pulse.isAnimating) {
      _pulse.stop();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _handleClaim() async {
    if (_submitting || !widget.canClaim) return;
    setState(() => _submitting = true);
    try {
      // Callback is expected to be fast and non-blocking; UI lock only
      // prevents obvious repeated taps.
      widget.onClaim();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canTap = widget.canClaim && !_submitting;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, child) => GlassCard(
        padding: const EdgeInsets.all(14),
        borderColor: widget.canClaim
            ? Color.lerp(
                  _kPrimary.withOpacity(0.3),
                  _kSecondary.withOpacity(0.8),
                  _pulse.value,
                ) ??
                _kPrimary
            : _kBorder,
        gradientColors: widget.canClaim
            ? [
                _kPrimary.withOpacity(0.1 + 0.08 * _pulse.value),
                _kSecondary.withOpacity(0.05),
              ]
            : null,
        onTap: canTap ? _handleClaim : null,
        child: child!,
      ),
      child: Semantics(
        button: widget.canClaim,
        label: widget.canClaim
            ? 'Open daily reward box'
            : 'Daily reward already claimed',
        child: Row(
          children: [
            Text(
              widget.canClaim ? '🎁' : '✅',
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.canClaim
                        ? 'Daily Reward Ready!'
                        : 'Daily Reward Claimed',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.canClaim
                        ? 'Tap to claim your ${widget.streak >= 7 ? "streak bonus" : "daily XP"}'
                        : 'Come back tomorrow for more XP',
                    style: const TextStyle(
                        color: _kMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
            if (widget.canClaim)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [_kPrimary, _kSecondary]),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: _kPrimary.withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Open',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
// AI Companion Card
// ════════════════════════════════════════════════════════════════════════
class CompanionCard extends StatelessWidget {
  final String greeting;
  final String advice;
  final VoidCallback? onChat;

  const CompanionCard({
    super.key,
    required this.greeting,
    required this.advice,
    this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      gradientColors: [
        const Color(0xFF1E1040),
        _kPrimary.withOpacity(0.2),
      ],
      borderColor: _kPrimary.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_kPrimary, _kSecondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _kPrimary.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Copilot',
                      style: TextStyle(
                        color: _kSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      greeting,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _kPrimary.withOpacity(0.25),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline,
                    color: _kSecondary, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    advice,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onChat != null) ...[
            const SizedBox(height: 10),
            Semantics(
              button: true,
              label: 'Chat with Copilot',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onChat,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      'Chat with Copilot',
                      style: TextStyle(
                          color: _kSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios,
                        size: 10, color: _kSecondary),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
// LeaderboardTile — single rank row
// ════════════════════════════════════════════════════════════════════════
class LeaderboardTile extends StatelessWidget {
  final LeaderboardEntry entry;

  const LeaderboardTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final isTop3 = entry.rank >= 1 && entry.rank <= 3;
    final rankEmoji = entry.rank == 1
        ? '🥇'
        : entry.rank == 2
            ? '🥈'
            : entry.rank == 3
                ? '🥉'
                : null;

    return Semantics(
      container: true,
      label: entry.isCurrentUser
          ? 'You are ranked ${entry.rank}, level ${entry.level}, ${entry.totalXp} XP'
          : '${entry.displayName}, rank ${entry.rank}, level ${entry.level}, ${entry.totalXp} XP',
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: entry.isCurrentUser
              ? _kPrimary.withOpacity(0.15)
              : _kSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: entry.isCurrentUser
                ? _kPrimary.withOpacity(0.4)
                : _kBorder,
          ),
        ),
        child: Row(
          children: [
            // Rank
            SizedBox(
              width: 32,
              child: rankEmoji != null
                  ? Text(rankEmoji,
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center)
                  : Text(
                      '#${entry.rank}',
                      style: TextStyle(
                        color: entry.isCurrentUser
                            ? _kSecondary
                            : _kMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
            const SizedBox(width: 10),
            // Avatar
            CircleAvatar(
              radius: 18,
              backgroundColor: _kPrimary.withOpacity(0.3),
              backgroundImage: entry.photoUrl != null
                  ? NetworkImage(entry.photoUrl!)
                  : null,
              child: entry.photoUrl == null
                  ? Text(
                      entry.displayName.isNotEmpty
                          ? entry.displayName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            // Name + level
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.isCurrentUser
                        ? '${entry.displayName} (You)'
                        : entry.displayName,
                    style: TextStyle(
                      color: entry.isCurrentUser
                          ? Colors.white
                          : Colors.white70,
                      fontSize: 13,
                      fontWeight: entry.isCurrentUser
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Level ${entry.level} · ${LevelSystem.titleFor(entry.totalXp)}',
                    style: const TextStyle(
                        color: _kMuted, fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // XP
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry.totalXp} XP',
                  style: TextStyle(
                    color: isTop3 ? _kSecondary : Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '+${entry.weeklyXp} this week',
                  style:
                      const TextStyle(color: _kMuted, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}