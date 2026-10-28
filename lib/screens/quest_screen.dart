// ══════════════════════════════════════════════════════════════════════
// lib/features/copilot/screens/quest_screen.dart
//
// Career Quest / Mission Center — cinematic, gamified visual upgrade.
//
// ARCHITECTURE
// ────────────
// This screen is a PRESENTATION / ORCHESTRATION layer only:
//   • QuestService owns quest loading and transaction-safe claiming,
//     and is the authoritative source for QuestClaimResult values.
//   • CopilotFirestoreService.getUserTotalXp(uid) owns the authoritative
//     lifetime XP used for the header Level + XP chip.
//   • CopilotController (via CopilotProvider) remains the source for the
//     current streak.
//   • No second XP source, no second claim transaction, no duplicate
//     recommendation engine is introduced here.
//
// AUTHORITATIVE LIFETIME XP
// ─────────────────────────
// The header reads lifetime XP from
// CopilotFirestoreService.getUserTotalXp(uid), the same authoritative
// source used across the current Copilot architecture (users/{uid}.totalXp).
//   • If the read fails, the header omits the XP/level chip rather than
//     fabricating a value.
//   • ctrl.state.totalXp is used only as a non-authoritative fallback
//     when the authoritative read has never succeeded — never as a
//     value to combine with the authoritative one.
//
// CLAIM FLOW (finalized)
// ──────────────────────
// QuestService.claimQuestReward returns QuestClaimResult. Only
// QuestClaimResult.awarded means XP was actually paid. The screen:
//   1. Guards with _claiming (per-quest, in-flight only).
//   2. Awaits QuestService.claimQuestReward(uid, quest).
//   3. On QuestClaimResult.awarded:
//        - refresh quests and authoritative XP
//        - locate the refreshed quest by id and show the XP burst
//          using that refreshed quest's authoritative reward
//        - show a success snackbar
//   4. On any non-awarded result:
//        - no XP burst, no success snackbar, no fake XP
//        - show a short, user-friendly message
//        - refresh so the UI reflects the authoritative state
//
// CLAIM STATE
// ───────────
// Whether a quest's reward has been claimed is projected by QuestService
// onto Quest.rewardClaimed (via Quest.copyWith). The screen reads
// quest.canClaimReward / quest.rewardClaimed directly. It does NOT
// maintain a second persistent claim-state source. The only local
// temporary guard is `_claiming`, which prevents duplicate taps while a
// request is in flight.
//
// VISUAL DESIGN
// ─────────────
// All existing GlassCard glassmorphism, hero cards, tabs, progress
// indicators, XP burst overlay, motivational card, and animations are
// preserved unchanged.
// ══════════════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/quest_models.dart';
import '../../services/quest_service.dart';
import '../../services/copilot_provider.dart';
import '../../services/copilot_firestore_service.dart';
import '../../widgets/glassmorphism_card.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen>
    with TickerProviderStateMixin {
  // ── Palette ──────────────────────────────────────────────────────
  static const _bg = Color(0xFF0A0A14);
  static const _surface = Color(0xFF1A1A2E);
  static const _border = Color(0xFF2A2A40);
  static const _primary = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted = Color(0xFF888899);
  static const _pink = Color(0xFFEC4899);
  static const _blue = Color(0xFF3B82F6);
  static const _orange = Color(0xFFF59E0B);
  static const _green = Color(0xFF4ADE80);

  static const _tabTypes = [
    QuestType.daily,
    QuestType.weekly,
    QuestType.monthly,
    QuestType.bonus,
  ];

  late final AnimationController _bgCtrl;
  int _activeTab = 0;

  final _questService = QuestService();

  List<Quest> _quests = const [];
  bool _loading = true;
  String? _uid;

  /// Authoritative lifetime XP — populated from
  /// CopilotFirestoreService.getUserTotalXp(uid). Never fabricated.
  /// Null means "not yet available", which is rendered as an omitted
  /// chip rather than a fake number.
  int? _authoritativeXp;

  /// Monotonic token used to discard stale async refresh results (from
  /// an older uid or an older refresh cycle).
  int _refreshToken = 0;

  /// In-flight guard per quest — prevents duplicate taps while a claim
  /// request is running. Permanent duplicate-reward protection lives in
  /// QuestService (authoritative claimedQuestIds), not here.
  final Set<String> _claiming = <String>{};

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _uid = FirebaseAuth.instance.currentUser?.uid;
    _load();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    super.dispose();
  }

  // ── Data loading ─────────────────────────────────────────────────

  /// Single coherent load: fetches quests and authoritative lifetime XP
  /// for the current uid. Authoritative XP read failures are non-fatal
  /// and leave `_authoritativeXp` at its last known value (or null).
  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (!mounted) return;

    final token = ++_refreshToken;

    setState(() {
      _uid = uid;
      _loading = true;
    });

    if (uid == null) {
      if (!mounted) return;
      setState(() {
        _quests = const [];
        _authoritativeXp = null;
        _loading = false;
      });
      return;
    }

    // 1. Fetch quests.
    List<Quest> quests = const [];
    try {
      quests = await _questService.fetchQuests(uid);
    } catch (_) {
      quests = const [];
    }

    // 2. Fetch authoritative lifetime XP — same source used across the
    //    current Copilot architecture (users/{uid}.totalXp). Never
    //    fabricated; on failure leave the previous value in place.
    int? xp;
    try {
      final v = await CopilotFirestoreService.getUserTotalXp(uid);
      if (v >= 0) xp = v;
    } catch (_) {
      xp = null;
    }

    if (!mounted || token != _refreshToken) return;
    setState(() {
      _quests = quests;
      if (xp != null) _authoritativeXp = xp;
      _loading = false;
    });
  }

  /// Silent refresh — used after a claim and by pull-to-refresh.
  /// Fetches quests and authoritative lifetime XP in the same cycle so
  /// the header and the quest cards both reflect the authoritative
  /// Firestore state.
  Future<void> _reloadSilently() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (!mounted) return;

    final token = ++_refreshToken;

    if (uid == null) {
      setState(() {
        _quests = const [];
        _authoritativeXp = null;
      });
      return;
    }

    List<Quest> quests = _quests;
    try {
      quests = await _questService.fetchQuests(uid);
    } catch (_) {
      // Keep the last known quest list.
    }

    int? xp;
    try {
      final v = await CopilotFirestoreService.getUserTotalXp(uid);
      if (v >= 0) xp = v;
    } catch (_) {
      xp = null;
    }

    if (!mounted || token != _refreshToken) return;
    setState(() {
      _quests = quests;
      if (xp != null) _authoritativeXp = xp;
    });
  }

  // ── Claim flow ───────────────────────────────────────────────────

  Future<void> _claimQuest(Quest quest) async {
    final uid = _uid ?? FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // In-flight guard: prevent duplicate taps on the same quest while a
    // claim request is running. QuestService provides the permanent
    // idempotency guard.
    if (_claiming.contains(quest.id)) return;

    // Fast local guard — only claim when the projected state says so.
    // The authoritative decision still happens inside QuestService.
    if (!quest.canClaimReward) return;

    setState(() => _claiming.add(quest.id));

    QuestClaimResult result = QuestClaimResult.error;
    bool threw = false;
    try {
      result = await _questService.claimQuestReward(uid, quest);
    } catch (_) {
      threw = true;
    } finally {
      if (mounted) setState(() => _claiming.remove(quest.id));
    }

    // Refresh from authoritative sources regardless of the outcome so
    // the UI reflects whatever Firestore actually recorded.
    await _reloadSilently();
    if (!mounted) return;

    if (threw) {
      // Unexpected failure — no burst, no success feedback.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't claim reward. Please try again."),
          backgroundColor: Color(0xFFEF4444),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    switch (result) {
      case QuestClaimResult.awarded:
        // Locate the refreshed quest to read its authoritative reward.
        // If it cannot be found we do NOT fabricate an XP amount — the
        // success feedback is shown without the XP-number burst.
        Quest? refreshedQuest;
        for (final q in _quests) {
          if (q.id == quest.id) {
            refreshedQuest = q;
            break;
          }
        }

        if (refreshedQuest != null) {
          _showXpBurst('+${refreshedQuest.xpReward} XP');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${quest.title} complete! 🎉'),
            backgroundColor: _primary,
            duration: const Duration(seconds: 2),
          ),
        );
        break;

      case QuestClaimResult.alreadyClaimed:
        _snack('Reward already claimed.', _secondary);
        break;

      case QuestClaimResult.notCompleted:
        _snack('Complete the quest first.', _orange);
        break;

      case QuestClaimResult.notFound:
        _snack('Quest is no longer available.', _orange);
        break;

      case QuestClaimResult.expired:
        _snack('This quest has expired.', _orange);
        break;

      case QuestClaimResult.invalidReward:
        _snack('This quest reward is unavailable.', _orange);
        break;

      case QuestClaimResult.error:
        _snack("Couldn't claim reward. Please try again.", _orange);
        break;
    }
  }

  void _snack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<Quest> _filtered(QuestType type) =>
      _quests.where((q) => q.type == type).toList();

  // ── "+XP" burst overlay ────────────────────────────────────────────

  void _showXpBurst(String text) {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: MediaQuery.of(ctx).size.height * 0.32,
        left: 0,
        right: 0,
        child: IgnorePointer(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_primary, _pink]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: _primary.withOpacity(0.6),
                      blurRadius: 30,
                      spreadRadius: 2),
                ],
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.4, 0.4),
                  end: const Offset(1, 1),
                  duration: 380.ms,
                  curve: Curves.elasticOut,
                )
                .then(delay: 500.ms)
                .fadeOut(duration: 400.ms)
                .slideY(begin: 0, end: -0.6, duration: 400.ms),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 1400), () {
      entry.remove();
    });
  }

  // ── Build ───────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final ctrl = CopilotProvider.maybeOf(context);
    final streak = ctrl?.state.currentStreak;

    // Authoritative lifetime XP is the primary source for the header.
    // The Copilot state value is only used as a non-authoritative
    // fallback when the authoritative read has never succeeded — never
    // added to it.
    final int? displayXp = _authoritativeXp ??
        (ctrl?.state.totalXp != null && ctrl!.state.totalXp >= 0
            ? ctrl.state.totalXp
            : null);

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          _GlowBackground(controller: _bgCtrl),
          SafeArea(
            child: _uid == null
                ? _buildAuthGate()
                : Column(
                    children: [
                      _buildHeader(displayXp, streak),
                      const SizedBox(height: 14),
                      _buildTabs(),
                      const SizedBox(height: 8),
                      Expanded(child: _buildBody()),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────

  Widget _buildHeader(int? totalXp, int? streak) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 16),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (rect) => const LinearGradient(
                    colors: [Colors.white, _secondary],
                  ).createShader(rect),
                  child: const Text(
                    'Quests',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                const Text(
                  'Complete missions. Build momentum. Level up.',
                  style: TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          if (totalXp != null) _xpChip(totalXp),
          if (streak != null) ...[
            const SizedBox(width: 8),
            _streakChip(streak),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _xpChip(int xp) {
    final level = LevelSystem.levelFor(xp);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_primary, _secondary]),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: _primary.withOpacity(0.4), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Lv.$level',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          const Icon(Icons.bolt, size: 12, color: Colors.white),
          Text('$xp',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _streakChip(int streak) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _orange.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 12))
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.2, 1.2),
                duration: 700.ms,
              ),
          const SizedBox(width: 4),
          Text('$streak',
              style: const TextStyle(
                  color: _orange, fontSize: 12, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  // ── Tabs ────────────────────────────────────────────────────────

  Widget _buildTabs() {
    const labels = ['🌅 Daily', '📅 Weekly', '🗓️ Monthly', '✨ Bonus'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _surface.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: List.generate(_tabTypes.length, (i) {
            final selected = _activeTab == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _activeTab = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    gradient: selected
                        ? const LinearGradient(colors: [_primary, _pink])
                        : null,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                                color: _primary.withOpacity(0.45),
                                blurRadius: 14),
                          ]
                        : const [],
                  ),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected ? Colors.white : _muted,
                      fontSize: 12.5,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    ).animate().fadeIn(delay: 80.ms, duration: 300.ms);
  }

  // ── Body ────────────────────────────────────────────────────────

  Widget _buildAuthGate() {
    return const _CenteredState(
      icon: Icons.lock_outline,
      title: 'Sign in to view your quests',
      subtitle:
          'Your daily, weekly, and monthly quests are tied to your account.',
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: _primary));
    }

    final type = _tabTypes[_activeTab];
    final quests = _filtered(type);
    final emptyMsg = switch (type) {
      QuestType.daily => 'Daily quests refresh at midnight.',
      QuestType.weekly => 'Weekly quests refresh every Monday.',
      QuestType.monthly => 'Monthly quests refresh on the 1st.',
      QuestType.bonus => 'Bonus missions appear here when active.',
    };

    return RefreshIndicator(
      key: ValueKey(type),
      color: _secondary,
      backgroundColor: _surface,
      onRefresh: _reloadSilently,
      child: quests.isEmpty
          ? _emptyScrollable(emptyMsg)
          : _questContent(quests, type),
    );
  }

  Widget _emptyScrollable(String message) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 110),
      children: [
        const Icon(Icons.emoji_events_outlined,
            color: Color(0xFF444455), size: 56),
        const SizedBox(height: 16),
        const Text(
          'No quests available right now.',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted, fontSize: 12, height: 1.4)),
        const SizedBox(height: 20),
        const Text('Pull down to refresh',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 11)),
      ],
    );
  }

  Widget _questContent(List<Quest> quests, QuestType type) {
    // completed = quests whose progress has actually reached its target.
    final completed = quests.where((q) => q.isCompleted).length;

    // totalXp = potential reward available in this tab (informational).
    final totalXp = quests.fold<int>(0, (s, q) => s + q.xpReward);

    // earnedXp = XP whose reward was actually claimed (authoritative
    // projection from QuestService). Completed-but-unclaimed quests do
    // NOT count here — only quests whose rewardClaimed projection is
    // true.
    final earnedXp = quests
        .where((q) => q.isRewardClaimed)
        .fold<int>(0, (s, q) => s + q.xpReward);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      children: [
        _missionsHeroCard(type, quests.length, completed, earnedXp, totalXp)
            .animate()
            .fadeIn(duration: 260.ms)
            .slideY(begin: 0.08, end: 0),
        const SizedBox(height: 16),
        ...quests.asMap().entries.map((e) {
          final quest = e.value;
          final isClaiming = _claiming.contains(quest.id);

          // Claim button is enabled purely from the authoritative
          // projected state returned by QuestService. No local
          // permanent claim-state source is consulted.
          final canClaim = quest.canClaimReward && !isClaiming;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _QuestMissionCard(
              quest: quest,
              isClaiming: isClaiming,
              onClaim: canClaim ? () => _claimQuest(quest) : null,
            )
                .animate()
                .fadeIn(delay: (60 + e.key * 60).ms, duration: 260.ms)
                .slideY(begin: 0.15, end: 0, duration: 280.ms),
          );
        }),
        const SizedBox(height: 6),
        _motivationCard(quests)
            .animate()
            .fadeIn(delay: 200.ms, duration: 300.ms),
      ],
    );
  }

  Widget _missionsHeroCard(
    QuestType type,
    int total,
    int completed,
    int earnedXp,
    int totalXp,
  ) {
    final fraction = total <= 0 ? 0.0 : (completed / total).clamp(0.0, 1.0);
    final resetLabel = switch (type) {
      QuestType.daily => 'Resets at midnight',
      QuestType.weekly => 'Resets every Monday',
      QuestType.monthly => 'Resets on the 1st',
      QuestType.bonus => 'Limited-time missions',
    };

    return GlassCard(
      borderRadius: 22,
      padding: const EdgeInsets.all(18),
      gradientColors: [
        _primary.withOpacity(0.22),
        _pink.withOpacity(0.10),
      ],
      borderColor: _primary.withOpacity(0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Today's Missions",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text('$total mission${total == 1 ? '' : 's'} · $resetLabel',
                        style: const TextStyle(color: _muted, fontSize: 11.5)),
                  ],
                ),
              ),
              Container(
                width: 54,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [_primary, _pink]),
                  boxShadow: [
                    BoxShadow(color: _primary.withOpacity(0.4), blurRadius: 14),
                  ],
                ),
                child: Text('$completed/$total',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: fraction),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (_, v, __) => LinearProgressIndicator(
                value: v,
                minHeight: 9,
                backgroundColor: const Color(0xFF0F0F20),
                valueColor: const AlwaysStoppedAnimation(_secondary),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.bolt, size: 14, color: _orange),
              const SizedBox(width: 4),
              Text('$earnedXp / $totalXp XP earned',
                  style: const TextStyle(color: _muted, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _motivationCard(List<Quest> quests) {
    final remaining =
        quests.where((q) => !q.isCompleted && !q.isExpired).length;
    final title =
        remaining == 0 ? 'All missions complete! 🎉' : 'Complete all missions';
    final subtitle = remaining == 0
        ? 'You cleared everything here — check back for more soon.'
        : '$remaining mission${remaining == 1 ? '' : 's'} left. Keep building your career momentum 🚀';

    return GlassCard(
      borderRadius: 18,
      padding: const EdgeInsets.all(16),
      gradientColors: [_blue.withOpacity(0.14), _primary.withOpacity(0.08)],
      borderColor: _blue.withOpacity(0.3),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _blue.withOpacity(0.18),
            ),
            child: Icon(
              remaining == 0 ? Icons.emoji_events : Icons.rocket_launch,
              color: _blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        color: _muted, fontSize: 11.5, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// GLOW BACKGROUND — soft, slowly-breathing blurred color blobs
// ══════════════════════════════════════════════════════════════════════

class _GlowBackground extends StatelessWidget {
  final AnimationController controller;
  const _GlowBackground({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value; // 0..1, breathing
        return Stack(
          children: [
            Positioned(
              top: -120 + (t * 20),
              left: -80,
              child: _blob(const Color(0xFF7C3AED), 260, 0.35 + t * 0.1),
            ),
            Positioned(
              top: 140 - (t * 16),
              right: -100,
              child: _blob(const Color(0xFFEC4899), 240, 0.28 + t * 0.08),
            ),
            Positioned(
              bottom: -140,
              left: -60,
              child: _blob(const Color(0xFF3B82F6), 260, 0.24 + t * 0.08),
            ),
            Positioned(
              bottom: 60 + (t * 14),
              right: -40,
              child: _blob(const Color(0xFFF59E0B), 180, 0.18 + t * 0.06),
            ),
          ],
        );
      },
    );
  }

  Widget _blob(Color color, double size, double opacity) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color.withOpacity(opacity), color.withOpacity(0)],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// QUEST MISSION CARD — premium single-quest card
// ══════════════════════════════════════════════════════════════════════

class _QuestMissionCard extends StatelessWidget {
  final Quest quest;
  final bool isClaiming;
  final VoidCallback? onClaim;

  const _QuestMissionCard({
    required this.quest,
    required this.isClaiming,
    required this.onClaim,
  });

  static const _border = Color(0xFF2A2A40);
  static const _primary = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted = Color(0xFF888899);
  static const _green = Color(0xFF4ADE80);
  static const _pink = Color(0xFFEC4899);

  /// Whether this quest's visual state is "rewarded" — completed and
  /// authoritative rewardClaimed is true. Completion alone is not
  /// enough; the claim state comes from QuestService's projection.
  bool get _rewarded => quest.isCompleted && quest.rewardClaimed;

  /// Whether this quest's visual state is "done but not yet claimed".
  bool get _completedUnclaimed => quest.isCompleted && !quest.rewardClaimed;

  @override
  Widget build(BuildContext context) {
    final current = quest.progressCurrent < 0 ? 0 : quest.progressCurrent;
    final target = quest.progressTarget <= 0 ? 0 : quest.progressTarget;
    final progress = quest.progressPercent.isNaN
        ? 0.0
        : quest.progressPercent.clamp(0.0, 1.0);
    final isExpired = quest.isExpired && !quest.isCompleted;

    // Visual "green" state when the reward has been claimed; a
    // completed-but-unclaimed quest keeps the standard look so the
    // Claim button stays visually prominent.
    final isGreen = _rewarded;

    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      borderColor: isGreen ? _green.withOpacity(0.5) : _border.withOpacity(0.6),
      gradientColors:
          isGreen ? [_green.withOpacity(0.14), _green.withOpacity(0.04)] : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon bubble
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: isGreen
                  ? const LinearGradient(colors: [_green, Color(0xFF22C55E)])
                  : const LinearGradient(colors: [_primary, _pink]),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: (isGreen ? _green : _primary).withOpacity(0.35),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Center(
              child: Text(
                isGreen ? '✓' : quest.type.emoji,
                style: const TextStyle(fontSize: 19, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        quest.title,
                        style: TextStyle(
                          color: isExpired ? _muted : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          decoration:
                              isExpired ? TextDecoration.lineThrough : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_rewarded)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _green.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('DONE',
                            style: TextStyle(
                                color: _green,
                                fontSize: 9,
                                fontWeight: FontWeight.w800)),
                      )
                    else if (_completedUnclaimed)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _secondary.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('READY',
                            style: TextStyle(
                                color: _secondary,
                                fontSize: 9,
                                fontWeight: FontWeight.w800)),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  quest.description,
                  style: const TextStyle(
                      color: _muted, fontSize: 11.5, height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Progress bar with glow
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: progress),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutCubic,
                          builder: (_, v, __) => Stack(
                            children: [
                              Container(
                                  height: 6, color: const Color(0xFF0F0F20)),
                              FractionallySizedBox(
                                widthFactor: v,
                                child: Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isGreen
                                          ? [_green, const Color(0xFF22C55E)]
                                          : [_primary, _pink],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (isGreen ? _green : _primary)
                                            .withOpacity(0.5),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      target > 0 ? '$current/$target' : '$current',
                      style: const TextStyle(color: _muted, fontSize: 10),
                    ),
                  ],
                ),

                if (!quest.isCompleted &&
                    !isExpired &&
                    target > 0 &&
                    current < target) ...[
                  const SizedBox(height: 4),
                  Text('${target - current} to go',
                      style: const TextStyle(color: _muted, fontSize: 10)),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Action / reward
          _trailing(),
        ],
      ),
    );
  }

  Widget _trailing() {
    // Claim button only when the authoritative projection says the
    // reward can be claimed and no claim is currently in flight.
    if (onClaim != null) {
      return GestureDetector(
        onTap: onClaim,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [_primary, _pink]),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: _primary.withOpacity(0.4), blurRadius: 10),
            ],
          ),
          child: const Text('Claim',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700)),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              begin: const Offset(1, 1),
              end: const Offset(1.04, 1.04),
              duration: 900.ms,
            ),
      );
    }

    if (isClaiming) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: _secondary),
      );
    }

    if (_rewarded) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _green.withOpacity(0.14),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.check_rounded, color: _green, size: 16),
      );
    }

    // Not yet completed — show the reward value as informational.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('+${quest.xpReward}',
          style: const TextStyle(
              color: _secondary, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// CENTERED STATE — auth-required / fallback
// ══════════════════════════════════════════════════════════════════════

class _CenteredState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _CenteredState({
    required this.icon,
    required this.title,
    required this.subtitle,
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
          ],
        ),
      ),
    );
  }
}
