import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/reward_service.dart';

class RewardScreen extends StatefulWidget {
  /// Current career streak must come from the app's existing
  /// authoritative streak/progress source.
  final int currentStreak;

  const RewardScreen({
    super.key,
    required this.currentStreak,
  });

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen>
    with TickerProviderStateMixin {
  final RewardService _rewardService = RewardService();

  RewardSummary? _summary;

  bool _loading = true;
  bool _claiming = false;
  String? _error;

  Timer? _countdownTimer;
  Duration _timeUntilTomorrow = Duration.zero;

  late final AnimationController _heroController;
  late final AnimationController _pulseController;
  late final AnimationController _celebrationController;

  @override
  void initState() {
    super.initState();

    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _startCountdown();
    _loadRewards();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _heroController.dispose();
    _pulseController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> _loadRewards() async {
    if (_uid.isEmpty) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Please sign in to view your rewards.';
      });
      return;
    }

    try {
      final summary = await _rewardService.getRewardSummary(
        _uid,
        widget.currentStreak,
      );

      if (!mounted) return;

      setState(() {
        _summary = summary;
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Could not load rewards. Please try again.';
      });
    }
  }

  Future<void> _claimDailyReward() async {
    if (_claiming || _uid.isEmpty) return;

    final summary = _summary;

    if (summary == null ||
        summary.claimedToday ||
        summary.todayReward == null) {
      return;
    }

    setState(() {
      _claiming = true;
    });

    try {
      final result = await _rewardService.claimDailyBox(
        _uid,
        widget.currentStreak,
      );

      if (!mounted) return;

      setState(() {
        _claiming = false;
      });

      if (!result.claimed) {
        await _loadRewards();
        return;
      }

      _celebrationController.forward(from: 0);

      await _showRewardClaimedDialog(result);

      if (!mounted) return;

      await _loadRewards();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _claiming = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Reward could not be claimed. Your reward is still safe.',
          ),
        ),
      );
    }
  }

  Future<void> _showRewardClaimedDialog(RewardResult result) async {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Reward claimed',
      barrierColor: Colors.black.withOpacity(0.72),
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (_, __, ___) {
        return _RewardCelebration(
          result: result,
          currentStreak: widget.currentStreak,
        );
      },
      transitionBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: curved,
            child: child,
          ),
        );
      },
    );
  }

  void _startCountdown() {
    _updateCountdown();

    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateCountdown(),
    );
  }

  void _updateCountdown() {
    final now = DateTime.now();

    final tomorrow = DateTime(
      now.year,
      now.month,
      now.day + 1,
    );

    final remaining = tomorrow.difference(now);

    if (!mounted) return;

    setState(() {
      _timeUntilTomorrow = remaining.isNegative ? Duration.zero : remaining;
    });
  }

  String _formatCountdown(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  int _todayRewardXp(RewardSummary summary) {
    final now = DateTime.now();

    return summary.recentHistory
        .where(
          (entry) =>
              entry.timestamp.year == now.year &&
              entry.timestamp.month == now.month &&
              entry.timestamp.day == now.day,
        )
        .fold<int>(
          0,
          (total, entry) => total + entry.xpAmount,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B16),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Rewards',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return _buildError();
    }

    final summary = _summary;

    if (summary == null) {
      return const Center(
        child: Text(
          'No reward data available.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRewards,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          _buildHero(summary),
          const SizedBox(height: 18),
          _buildTodayProgress(summary),
          const SizedBox(height: 18),
          _buildRewardJourney(summary),
          const SizedBox(height: 18),
          _buildMilestone(summary),
          const SizedBox(height: 18),
          _buildPowerUps(summary),
          const SizedBox(height: 18),
          _buildTomorrowCard(summary),
          const SizedBox(height: 18),
          _buildHistory(summary),
        ],
      ),
    );
  }

  Widget _buildHero(RewardSummary summary) {
    final today = summary.todayReward;

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _heroController,
        curve: Curves.easeOut,
      ),
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 0.94,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _heroController,
            curve: Curves.easeOutBack,
          ),
        ),
        child: _GlassCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (_, child) {
                  final scale = 1 + (_pulseController.value * 0.035);

                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.20),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      summary.claimedToday ? '🔥' : (today?.emoji ?? '🎁'),
                      style: const TextStyle(fontSize: 44),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                summary.claimedToday ? 'REWARD CLAIMED' : 'TODAY’S REWARD',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                summary.claimedToday
                    ? 'Great work today!'
                    : (today?.title ?? 'Keep your streak alive'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                summary.claimedToday
                    ? 'Your career momentum is still moving forward.'
                    : (today?.description ??
                        'Come back every day and keep learning.'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              _StreakPill(
                streak: summary.currentStreak,
              ),
              if (!summary.claimedToday && today != null) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _claiming ? null : _claimDailyReward,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF090C18),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: _claiming
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'CLAIM +${today.xpAmount} XP',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '🎁',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayProgress(RewardSummary summary) {
    final xp = _todayRewardXp(summary);

    return _SectionCard(
      title: 'TODAY’S REWARD XP',
      icon: '⚡',
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$xp XP',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Text(
            'earned today',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardJourney(RewardSummary summary) {
    final chain = _rewardService.getDailyRewardChain(
      summary.currentStreak,
      summary.claimedToday,
    );

    return _SectionCard(
      title: 'YOUR REWARD JOURNEY',
      icon: '🔥',
      child: Column(
        children: [
          const SizedBox(height: 4),
          SizedBox(
            height: 108,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: chain.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, index) {
                final slot = chain[index];

                return _RewardDayCard(
                  slot: slot,
                  current: slot.available,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestone(RewardSummary summary) {
    final milestone = summary.nextMilestone;

    if (milestone == null) {
      return _SectionCard(
        title: 'STREAK MILESTONE',
        icon: '🏆',
        child: const Text(
          'You have reached every current streak milestone. More rewards can be added as your journey grows.',
          style: TextStyle(
            color: Colors.white70,
            height: 1.45,
          ),
        ),
      );
    }

    final daysLeft = summary.daysUntilMilestone ?? 0;

    final progress = milestone.days == 0
        ? 0.0
        : (summary.currentStreak / milestone.days).clamp(0.0, 1.0);

    return _SectionCard(
      title: 'NEXT MILESTONE',
      icon: milestone.emoji,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                milestone.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '${milestone.days} days',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.white.withOpacity(0.08),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            daysLeft > 0
                ? '$daysLeft day${daysLeft == 1 ? '' : 's'} remaining'
                : 'Milestone ready!',
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (milestone.xpAmount > 0)
                _MiniReward(
                  icon: '⚡',
                  text: '+${milestone.xpAmount} XP',
                ),
              if (milestone.shieldAmount > 0)
                _MiniReward(
                  icon: '🛡️',
                  text: '+${milestone.shieldAmount} Shield',
                ),
              if (milestone.badgeId != null)
                const _MiniReward(
                  icon: '🏅',
                  text: 'Badge',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPowerUps(RewardSummary summary) {
    final multiplier = summary.activeMultiplier;

    return Row(
      children: [
        Expanded(
          child: _SmallGlassCard(
            icon: '🛡️',
            title: 'Shields',
            value: '${summary.shieldCount}',
            subtitle: 'available',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SmallGlassCard(
            icon: '⚡',
            title: 'Multiplier',
            value: multiplier.isActive ? '${multiplier.multiplier}x' : '1x',
            subtitle: multiplier.isActive
                ? _formatDuration(multiplier.remaining)
                : 'inactive',
          ),
        ),
      ],
    );
  }

  Widget _buildTomorrowCard(RewardSummary summary) {
    final next = summary.nextReward;

    return _GlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          const Text(
            '🌅',
            style: TextStyle(fontSize: 36),
          ),
          const SizedBox(height: 8),
          const Text(
            'COME BACK TOMORROW',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Your next reward is waiting for you.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            _formatCountdown(_timeUntilTomorrow),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 31,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'until the next daily reward',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),
          if (next != null) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    next.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          next.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          next.description,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (next.xpAmount > 0)
                    Text(
                      '+${next.xpAmount} XP',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHistory(RewardSummary summary) {
    if (summary.recentHistory.isEmpty) {
      return _SectionCard(
        title: 'RECENT REWARDS',
        icon: '📜',
        child: const Text(
          'Your reward history will appear here as you earn rewards.',
          style: TextStyle(
            color: Colors.white54,
            height: 1.4,
          ),
        ),
      );
    }

    return _SectionCard(
      title: 'RECENT REWARDS',
      icon: '📜',
      child: Column(
        children: summary.recentHistory.take(8).map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _sourceEmoji(entry.source),
                      style: const TextStyle(fontSize: 19),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.message.isEmpty
                            ? _sourceTitle(entry.source)
                            : entry.message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _formatDate(entry.timestamp),
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (entry.xpAmount > 0)
                  Text(
                    '+${entry.xpAmount} XP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: _GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '⚠️',
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 12),
              Text(
                _error ?? 'Something went wrong.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _loading = true;
                  });
                  _loadRewards();
                },
                child: const Text('TRY AGAIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return 'Expired';

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    return '${hours}h ${minutes}m left';
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();

    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/'
        '${local.year}';
  }

  String _sourceEmoji(RewardSource source) {
    switch (source) {
      case RewardSource.dailyBox:
        return '🎁';
      case RewardSource.dailyCheckIn:
        return '✅';
      case RewardSource.streakMilestone:
        return '🏆';
      case RewardSource.goalCompletion:
        return '🎯';
      case RewardSource.courseCompletion:
        return '📚';
      case RewardSource.quizCompletion:
        return '🧠';
      case RewardSource.challengeCompletion:
        return '⚔️';
      case RewardSource.projectCompletion:
        return '🚀';
      case RewardSource.surprise:
        return '🎲';
      case RewardSource.achievement:
        return '🏅';
      case RewardSource.quest:
        return '🎯';
      case RewardSource.manual:
        return '✨';
    }
  }

  String _sourceTitle(RewardSource source) {
    switch (source) {
      case RewardSource.dailyBox:
        return 'Daily Reward';
      case RewardSource.dailyCheckIn:
        return 'Daily Check-in';
      case RewardSource.streakMilestone:
        return 'Streak Milestone';
      case RewardSource.goalCompletion:
        return 'Goal Completed';
      case RewardSource.courseCompletion:
        return 'Course Completed';
      case RewardSource.quizCompletion:
        return 'Quiz Completed';
      case RewardSource.challengeCompletion:
        return 'Challenge Completed';
      case RewardSource.projectCompletion:
        return 'Project Completed';
      case RewardSource.surprise:
        return 'Surprise Reward';
      case RewardSource.achievement:
        return 'Achievement Reward';
      case RewardSource.quest:
        return 'Quest Reward';
      case RewardSource.manual:
        return 'Reward';
    }
  }
}

// ══════════════════════════════════════════════════════════════════════
// REWARD CLAIM CELEBRATION
// ══════════════════════════════════════════════════════════════════════

class _RewardCelebration extends StatelessWidget {
  final RewardResult result;
  final int currentStreak;

  const _RewardCelebration({
    required this.result,
    required this.currentStreak,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _GlassCard(
            padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  result.emoji,
                  style: const TextStyle(fontSize: 62),
                ),
                const SizedBox(height: 14),
                const Text(
                  'REWARD CLAIMED!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  result.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 22),
                if (result.xpAmount > 0)
                  Text(
                    '+${result.xpAmount} XP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                if (result.shieldAmount > 0) ...[
                  const SizedBox(height: 10),
                  Text(
                    '🛡️ +${result.shieldAmount} Streak Shield',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  '🔥 $currentStreak day streak',
                  style: const TextStyle(
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF080B16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: const Text(
                      'KEEP GOING 🚀',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// UI COMPONENTS
// ══════════════════════════════════════════════════════════════════════

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.065),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Colors.white.withOpacity(0.11),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _SmallGlassCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final String subtitle;

  const _SmallGlassCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardDayCard extends StatelessWidget {
  final DailyRewardSlot slot;
  final bool current;

  const _RewardDayCard({
    required this.slot,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 82,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: current
            ? Colors.white.withOpacity(0.14)
            : Colors.white.withOpacity(0.045),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: current
              ? Colors.white.withOpacity(0.30)
              : Colors.white.withOpacity(0.07),
          width: current ? 1.4 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            slot.emoji,
            style: TextStyle(
              fontSize: current ? 25 : 20,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'DAY ${slot.day}',
            style: TextStyle(
              color: slot.locked ? Colors.white30 : Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            slot.xpAmount > 0 ? '+${slot.xpAmount}' : 'Reward',
            style: TextStyle(
              color: slot.locked
                  ? Colors.white.withValues(alpha: 0.25)
                  : Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (slot.claimed)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                '✓',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StreakPill extends StatelessWidget {
  final int streak;

  const _StreakPill({
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.09),
        ),
      ),
      child: Text(
        '🔥 $streak DAY STREAK',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _MiniReward extends StatelessWidget {
  final String icon;
  final String text;

  const _MiniReward({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$icon $text',
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
