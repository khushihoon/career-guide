// ══════════════════════════════════════════════════════════════════════
// lib/screens/leaderboard_screen.dart
// Global & Weekly leaderboard — presentation/orchestration layer only.
//
// All leaderboard data flows through LeaderboardService. This screen
// never touches Firestore directly, never calculates ranking, and never
// awards XP.
//
// FINAL UPGRADE (this revision)
// ─────────────────────────────
//   • Automatic periodic refresh while the screen is mounted (lightweight,
//     disposed on unmount). Pull-to-refresh still works.
//   • Real in-session change detection: previous vs current XP and rank
//     are compared after every successful refresh, using ONLY actual
//     values returned by LeaderboardService.
//   • Single combined cinematic celebration popup (priority: Top-1 >
//     Combined rank+XP > Rank climb > XP gain). No stacked dialogs.
//   • XP number animates smoothly from old to new on the current-user
//     card; a temporary green "+X XP" burst shows the delta.
//   • Rank number animates smoothly; when the rank improves an
//     "↑ X positions" indicator appears on the rank banner.
//   • Premium design preserved: deep navy background + purple/blue
//     atmospheric glow, glowing trophy header, animated tabs, rounded
//     cards, current-user card highlight, cinematic podium, elegant
//     empty state with a floating trophy, and the "Be the Top Learner!"
//     bottom CTA.
//   • Independent Global / Weekly loading and error states preserved.
//   • All async callbacks check `mounted` before setState.
// ══════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/quest_models.dart';
import '../services/leaderboard_service.dart';

// ── Palette (shared, file-private constants) ────────────────────────
const Color _kBgDeep = Color(0xFF05050C);
const Color _kBgNavy = Color(0xFF0A0A1A);
const Color _kSurface = Color(0xFF141424);
const Color _kSurfaceHi = Color(0xFF1A1A2E);
const Color _kBorder = Color(0xFF23233A);
const Color _kPrimary = Color(0xFF7C3AED);
const Color _kSecondary = Color(0xFFA78BFA);
const Color _kMuted = Color(0xFF888899);
const Color _kGold = Color(0xFFFFD24A);
const Color _kSilver = Color(0xFFD1D5DB);
const Color _kBronze = Color(0xFFCD7F32);
const Color _kGreen = Color(0xFF4ADE80);

// ── Entry point ───────────────────────────────────────────────────────

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  final _service = LeaderboardService();

  /// Lightweight periodic refresh — cancelled on dispose.
  Timer? _refreshTimer;

  List<LeaderboardEntry> _global = const [];
  List<LeaderboardEntry> _weekly = const [];

  bool _loadingGlobal = true;
  bool _loadingWeekly = true;

  String? _globalError;
  String? _weeklyError;

  /// Current user's actual global rank / XP. Nullable so a brand-new
  /// user with no entry at all simply does not show a rank banner.
  int? _currentUserGlobalRank;
  int? _currentUserGlobalXp;

  /// In-session previous values (used only for change detection).
  int? _prevGlobalRank;
  int? _prevGlobalXp;

  /// The most recent XP delta to render as a burst on the current-user
  /// card. Cleared once it has played out.
  int? _xpBurst;

  /// The most recent rank-improvement delta to render on the rank
  /// banner. Cleared once it has played out.
  int? _rankUpDelta;

  /// Guards against stacking celebrations when refreshes overlap.
  bool _popupShowing = false;

  String? _uid;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _uid = FirebaseAuth.instance.currentUser?.uid;
    _loadGlobal(isFirstLoad: true);
    _loadWeekly();
    _startPeriodicRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _tabs.dispose();
    super.dispose();
  }

  // ── Periodic refresh ───────────────────────────────────────────────
  void _startPeriodicRefresh() {
    // 45 s strikes a balance between feeling live and keeping Firestore
    // reads reasonable. The first refresh is triggered by initState.
    _refreshTimer = Timer.periodic(const Duration(seconds: 45), (_) {
      if (!mounted) return;
      _loadGlobal();
      _loadWeekly();
    });
  }

  // ── Data loading ───────────────────────────────────────────────────

  Future<void> _loadGlobal({bool isFirstLoad = false}) async {
    if (!mounted) return;
    setState(() {
      _loadingGlobal = true;
      _globalError = null;
    });

    try {
      final data = await _service.fetchGlobalTop(currentUid: _uid);

      // Resolve the current user's global rank / XP. Prefer the entry
      // from the top list when present; otherwise fall back to the
      // existing friends-board + getCurrentUserRank path.
      int? resolvedRank;
      int? resolvedXp;

      LeaderboardEntry? meInList;
      for (final e in data) {
        if (e.isCurrentUser) {
          meInList = e;
          break;
        }
      }

      if (meInList != null) {
        resolvedRank = meInList.rank;
        resolvedXp = meInList.totalXp;
      } else if (_uid != null) {
        try {
          final mineList = await _service.fetchFriendsLeaderboard(
            uid: _uid!,
            friendUids: const [],
          );
          LeaderboardEntry? mine;
          for (final e in mineList) {
            if (e.isCurrentUser) {
              mine = e;
              break;
            }
          }
          if (mine != null) {
            resolvedXp = mine.totalXp;
          }
          if (resolvedXp != null) {
            final rank = await _service.getCurrentUserRank(_uid!, resolvedXp);
            if (rank > 0) resolvedRank = rank;
          }
        } catch (_) {
          // Silent — the rank banner is optional.
        }
      }

      if (!mounted) return;

      // Snapshot previous values BEFORE overwriting them.
      final prevRank = _prevGlobalRank;
      final prevXp = _prevGlobalXp;

      // Compute XP delta only when we have both endpoints and it grew.
      final int? xpDelta =
          (prevXp != null && resolvedXp != null && resolvedXp > prevXp)
              ? (resolvedXp - prevXp)
              : null;

      // Compute rank improvement only when we have both endpoints and
      // the new rank is strictly better (numerically smaller).
      final bool rankImproved =
          prevRank != null && resolvedRank != null && resolvedRank < prevRank;
      final int? rankUpBy = rankImproved ? (prevRank! - resolvedRank!) : null;

      setState(() {
        _global = data;
        _loadingGlobal = false;
        _globalError = null;
        _prevGlobalRank = resolvedRank ?? prevRank;
        _prevGlobalXp = resolvedXp ?? prevXp;
        _currentUserGlobalRank = resolvedRank;
        _currentUserGlobalXp = resolvedXp;
        _xpBurst = xpDelta;
        _rankUpDelta = rankUpBy;
      });

      // Clear the transient bursts after their animation window so a
      // later refresh with no change does not keep re-rendering them.
      if (xpDelta != null) {
        Future<void>.delayed(const Duration(milliseconds: 2600), () {
          if (!mounted) return;
          setState(() => _xpBurst = null);
        });
      }
      if (rankUpBy != null) {
        Future<void>.delayed(const Duration(milliseconds: 2600), () {
          if (!mounted) return;
          setState(() => _rankUpDelta = null);
        });
      }

      // Fire the celebration only after the first successful load and
      // only when something meaningful changed.
      if (!isFirstLoad) {
        _maybeCelebrate(
          prevRank: prevRank,
          newRank: resolvedRank,
          xpDelta: xpDelta,
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingGlobal = false;
        _globalError = 'Couldn\'t load the global leaderboard.';
      });
    }
  }

  Future<void> _loadWeekly() async {
    if (!mounted) return;
    setState(() {
      _loadingWeekly = true;
      _weeklyError = null;
    });

    try {
      final data = await _service.fetchWeeklyTop(currentUid: _uid);
      if (!mounted) return;
      setState(() {
        _weekly = data;
        _loadingWeekly = false;
        _weeklyError = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingWeekly = false;
        _weeklyError = 'Couldn\'t load this week\'s leaderboard.';
      });
    }
  }

  // ── Celebration logic (single combined popup, priority ordered) ────

  void _maybeCelebrate({
    required int? prevRank,
    required int? newRank,
    required int? xpDelta,
  }) {
    if (!mounted || _popupShowing) return;

    // Top-1 must be a genuine transition INTO #1, not a first-load
    // snapshot and not a user who was already #1.
    final bool reachedTop = newRank == 1 && prevRank != null && prevRank > 1;

    final bool rankImproved =
        prevRank != null && newRank != null && newRank < prevRank;

    final bool hasXp = xpDelta != null && xpDelta > 0;

    if (!reachedTop && !rankImproved && !hasXp) return;

    final payload = _CelebrationPayload(
      xpDelta: hasXp ? xpDelta : null,
      oldRank: rankImproved ? prevRank : null,
      newRank: rankImproved ? newRank : null,
      isTopOne: reachedTop,
    );

    if (!payload.hasAnything) return;

    _popupShowing = true;
    _showCinematicPopup(payload).whenComplete(() {
      _popupShowing = false;
    });
  }

  Future<void> _showCinematicPopup(_CelebrationPayload payload) async {
    if (!mounted) return;
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'close',
      barrierColor: Colors.black.withOpacity(0.72),
      transitionDuration: const Duration(milliseconds: 380),
      pageBuilder: (_, __, ___) => _CelebrationPopup(payload: payload),
      transitionBuilder: (_, anim, __, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(scale: curved, child: child),
        );
      },
    );
  }

  // ── Build ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgDeep,
      body: Stack(
        children: [
          const _AtmosphericBackground(),
          SafeArea(
            child: Column(
              children: [
                _PremiumHeader(onBack: () => Navigator.pop(context))
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: -0.12),
                const SizedBox(height: 8),
                _PremiumTabBar(controller: _tabs)
                    .animate()
                    .fadeIn(delay: 80.ms, duration: 400.ms),
                const SizedBox(height: 4),
                Expanded(
                  child: TabBarView(
                    controller: _tabs,
                    children: [
                      _BoardList(
                        entries: _global,
                        loading: _loadingGlobal,
                        error: _globalError,
                        onRefresh: () => _loadGlobal(),
                        emptyMsg: 'No global rankings yet.',
                        currentUserGlobalRank: _currentUserGlobalRank,
                        currentUserGlobalXp: _currentUserGlobalXp,
                        xpDelta: _xpBurst,
                        rankUpDelta: _rankUpDelta,
                        isGlobalBoard: true,
                      ),
                      _BoardList(
                        entries: _weekly,
                        loading: _loadingWeekly,
                        error: _weeklyError,
                        onRefresh: _loadWeekly,
                        emptyMsg:
                            'No weekly rankings yet. Complete goals to rank!',
                        currentUserGlobalRank: null,
                        currentUserGlobalXp: null,
                        xpDelta: null,
                        rankUpDelta: null,
                        isGlobalBoard: false,
                      ),
                    ],
                  ),
                ),
                _BottomCTA()
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms)
                    .slideY(begin: 0.15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Celebration payload — one combined object drives the single popup
// ══════════════════════════════════════════════════════════════════════

class _CelebrationPayload {
  final int? xpDelta;
  final int? oldRank;
  final int? newRank;
  final bool isTopOne;

  const _CelebrationPayload({
    this.xpDelta,
    this.oldRank,
    this.newRank,
    this.isTopOne = false,
  });

  bool get hasAnything =>
      isTopOne ||
      (xpDelta != null && xpDelta! > 0) ||
      (oldRank != null && newRank != null && oldRank != newRank);

  bool get hasRankChange =>
      oldRank != null && newRank != null && oldRank != newRank;

  bool get hasXpChange => xpDelta != null && xpDelta! > 0;
}

// ══════════════════════════════════════════════════════════════════════
// Atmospheric background
// ══════════════════════════════════════════════════════════════════════

class _AtmosphericBackground extends StatelessWidget {
  const _AtmosphericBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_kBgNavy, _kBgDeep],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -160,
              left: -120,
              child: Container(
                width: 380,
                height: 380,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _kPrimary.withOpacity(0.28),
                      _kPrimary.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -180,
              right: -140,
              child: Container(
                width: 420,
                height: 420,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF3B82F6).withOpacity(0.18),
                      const Color(0xFF3B82F6).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Header
// ══════════════════════════════════════════════════════════════════════

class _PremiumHeader extends StatelessWidget {
  final VoidCallback onBack;
  const _PremiumHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
            onPressed: onBack,
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Leaderboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Learn • Practice • Grow • Compete',
                  style: TextStyle(
                    color: _kMuted,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const _GlowingTrophy(),
        ],
      ),
    );
  }
}

class _GlowingTrophy extends StatelessWidget {
  const _GlowingTrophy();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            _kPrimary.withOpacity(0.55),
            _kPrimary.withOpacity(0.15),
          ],
        ),
        border: Border.all(color: _kSecondary.withOpacity(0.55), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: _kPrimary.withOpacity(0.55),
            blurRadius: 22,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Center(
        child: Text('🏆', style: TextStyle(fontSize: 22)),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(
        begin: 1.0, end: 1.06, duration: 1800.ms, curve: Curves.easeInOut);
  }
}

// ══════════════════════════════════════════════════════════════════════
// Tab bar
// ══════════════════════════════════════════════════════════════════════

class _PremiumTabBar extends StatelessWidget {
  final TabController controller;
  const _PremiumTabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Container(
            height: 46,
            decoration: BoxDecoration(
              color: _kSurface.withOpacity(0.55),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _kBorder),
            ),
            child: Row(
              children: [
                _tabItem(
                  index: 0,
                  icon: Icons.public,
                  label: 'Global',
                  isSelected: controller.index == 0,
                ),
                _tabItem(
                  index: 1,
                  icon: Icons.calendar_month,
                  label: 'This Week',
                  isSelected: controller.index == 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _tabItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => controller.animateTo(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color:
                isSelected ? _kPrimary.withOpacity(0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  isSelected ? _kPrimary.withOpacity(0.55) : Colors.transparent,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: _kPrimary.withOpacity(0.35),
                      blurRadius: 14,
                    ),
                  ]
                : const [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? _kSecondary : _kMuted,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? _kSecondary : _kMuted,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Board list — shared layout for Global and Weekly
// ══════════════════════════════════════════════════════════════════════

class _BoardList extends StatelessWidget {
  final List<LeaderboardEntry> entries;
  final bool loading;
  final String? error;
  final Future<void> Function() onRefresh;
  final String emptyMsg;

  final int? currentUserGlobalRank;
  final int? currentUserGlobalXp;
  final int? xpDelta;
  final int? rankUpDelta;
  final bool isGlobalBoard;

  const _BoardList({
    required this.entries,
    required this.loading,
    required this.error,
    required this.onRefresh,
    required this.emptyMsg,
    required this.currentUserGlobalRank,
    required this.currentUserGlobalXp,
    required this.xpDelta,
    required this.rankUpDelta,
    required this.isGlobalBoard,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(color: _kPrimary),
      );
    }

    if (error != null) {
      return _ErrorState(message: error!, onRetry: onRefresh);
    }

    if (entries.isEmpty) {
      return RefreshIndicator(
        color: _kSecondary,
        backgroundColor: _kSurfaceHi,
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: const [
            SizedBox(height: 30),
            _EmptyLeaderboardState(),
            SizedBox(height: 40),
          ],
        ),
      );
    }

    // Determine whether the current user is visible in the list.
    LeaderboardEntry? meInList;
    for (final e in entries) {
      if (e.isCurrentUser) {
        meInList = e;
        break;
      }
    }

    final showRankBanner =
        isGlobalBoard && meInList == null && currentUserGlobalRank != null;

    // Show podium when there are at least 3 entries.
    final showPodium = entries.length >= 3;
    final listStart = showPodium ? 3 : 0;

    return RefreshIndicator(
      color: _kSecondary,
      backgroundColor: _kSurfaceHi,
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          if (showPodium)
            _Podium(top3: entries.take(3).toList())
                .animate()
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.08),
          if (showPodium) const SizedBox(height: 18),
          if (showRankBanner)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _CurrentUserBanner(
                rank: currentUserGlobalRank!,
                xp: currentUserGlobalXp,
                xpDelta: xpDelta,
                rankUpDelta: rankUpDelta,
              ).animate().fadeIn(duration: 350.ms),
            ),
          ...entries
              .skip(listStart)
              .toList()
              .asMap()
              .entries
              .map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _LeaderboardCard(
                      entry: e.value,
                      xpDelta: e.value.isCurrentUser && isGlobalBoard
                          ? xpDelta
                          : null,
                    )
                        .animate()
                        .fadeIn(delay: (e.key * 40).ms, duration: 320.ms)
                        .slideY(begin: 0.08),
                  )),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Empty state — cinematic glowing trophy
// ══════════════════════════════════════════════════════════════════════

class _EmptyLeaderboardState extends StatelessWidget {
  const _EmptyLeaderboardState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _kPrimary.withOpacity(0.28),
                        _kPrimary.withOpacity(0.0),
                      ],
                    ),
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(
                    begin: 0.94,
                    end: 1.06,
                    duration: 2200.ms,
                    curve: Curves.easeInOut),
                const Positioned(
                    top: 22, left: 32, child: _Sparkle(size: 14, delay: 0)),
                const Positioned(
                    top: 44, right: 28, child: _Sparkle(size: 10, delay: 400)),
                const Positioned(
                    bottom: 30,
                    left: 44,
                    child: _Sparkle(size: 12, delay: 800)),
                const Positioned(
                    bottom: 40,
                    right: 38,
                    child: _Sparkle(size: 8, delay: 1200)),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _kPrimary.withOpacity(0.85),
                        _kSecondary.withOpacity(0.35),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _kPrimary.withOpacity(0.65),
                        blurRadius: 40,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: _kSecondary.withOpacity(0.4),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🏆', style: TextStyle(fontSize: 56)),
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
                    begin: -4,
                    end: 4,
                    duration: 2200.ms,
                    curve: Curves.easeInOut),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'More learners will appear here!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          const Text(
            'Keep learning and earn XP to climb the leaderboard.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kMuted,
              fontSize: 13,
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  final double size;
  final int delay;
  const _Sparkle({required this.size, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.auto_awesome,
      size: size,
      color: _kSecondary.withOpacity(0.85),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(
          begin: 0.25,
          end: 1.0,
          duration: 1200.ms,
          delay: delay.ms,
          curve: Curves.easeInOut,
        );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Current-user rank banner
// ══════════════════════════════════════════════════════════════════════

class _CurrentUserBanner extends StatelessWidget {
  final int rank;
  final int? xp;
  final int? xpDelta;
  final int? rankUpDelta;

  const _CurrentUserBanner({
    required this.rank,
    required this.xp,
    required this.xpDelta,
    required this.rankUpDelta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _kPrimary.withOpacity(0.30),
            _kSecondary.withOpacity(0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _kPrimary.withOpacity(0.65), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: _kPrimary.withOpacity(0.40),
            blurRadius: 22,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _kPrimary.withOpacity(0.35),
              border: Border.all(color: _kSecondary.withOpacity(0.6)),
            ),
            child: const Center(
              child: Icon(Icons.person, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Global Rank',
                  style: TextStyle(
                    color: _kSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: rank.toDouble()),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOutCubic,
                      builder: (_, value, __) => Text(
                        '#${value.round()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (rankUpDelta != null && rankUpDelta! > 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        '↑ $rankUpDelta positions',
                        style: const TextStyle(
                          color: _kGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: -0.3, end: 0)
                          .then()
                          .fadeOut(delay: 2200.ms, duration: 600.ms),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (xp != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: xp!.toDouble()),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (_, value, __) => Text(
                    '${value.round()} XP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (xpDelta != null && xpDelta! > 0)
                  Text(
                    '+$xpDelta XP',
                    style: const TextStyle(
                      color: _kGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.3, end: 0)
                      .then()
                      .fadeOut(delay: 2400.ms, duration: 600.ms),
              ],
            ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Podium — cinematic top-3
// ══════════════════════════════════════════════════════════════════════

class _Podium extends StatelessWidget {
  final List<LeaderboardEntry> top3;
  const _Podium({required this.top3});

  @override
  Widget build(BuildContext context) {
    final first = top3[0];
    final second = top3.length > 1 ? top3[1] : null;
    final third = top3.length > 2 ? top3[2] : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (second != null)
          Expanded(
            child: _PodiumColumn(
              entry: second,
              height: 82,
              medal: '🥈',
              accent: _kSilver,
              delay: 100,
            ),
          ),
        Expanded(
          child: _PodiumColumn(
            entry: first,
            height: 118,
            medal: '🥇',
            accent: _kGold,
            delay: 0,
          ),
        ),
        if (third != null)
          Expanded(
            child: _PodiumColumn(
              entry: third,
              height: 66,
              medal: '🥉',
              accent: _kBronze,
              delay: 200,
            ),
          ),
      ],
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  final LeaderboardEntry entry;
  final double height;
  final String medal;
  final Color accent;
  final int delay;

  const _PodiumColumn({
    required this.entry,
    required this.height,
    required this.medal,
    required this.accent,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final initial =
        entry.displayName.isNotEmpty ? entry.displayName[0].toUpperCase() : '?';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.55),
                    blurRadius: 26,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: _SafeAvatar(
                radius: 28,
                photoUrl: entry.photoUrl,
                fallbackInitial: initial,
                borderColor: accent,
              ),
            ),
            Positioned(
              bottom: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _kSurfaceHi,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: accent.withOpacity(0.7)),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Text(
                  medal,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ).animate().fadeIn(delay: delay.ms, duration: 400.ms).scale(
            begin: const Offset(0.7, 0.7),
            duration: 500.ms,
            curve: Curves.easeOutBack),
        const SizedBox(height: 14),
        Text(
          entry.displayName.split(' ').first,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${entry.totalXp} XP',
          style: TextStyle(
            color: accent,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accent.withOpacity(0.32),
                accent.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            border: Border.all(color: accent.withOpacity(0.35)),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.18),
                blurRadius: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Leaderboard card
// ══════════════════════════════════════════════════════════════════════

class _LeaderboardCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final int? xpDelta;

  const _LeaderboardCard({required this.entry, this.xpDelta});

  @override
  Widget build(BuildContext context) {
    final isMe = entry.isCurrentUser;
    final initial =
        entry.displayName.isNotEmpty ? entry.displayName[0].toUpperCase() : '?';

    final levelTitle = LevelSystem.titleFor(entry.totalXp);
    final levelNumber = entry.level;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ? _kPrimary.withOpacity(0.10) : _kSurface.withOpacity(0.65),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMe ? _kPrimary.withOpacity(0.75) : _kBorder,
          width: isMe ? 1.4 : 1,
        ),
        boxShadow: isMe
            ? [
                BoxShadow(
                  color: _kPrimary.withOpacity(0.35),
                  blurRadius: 18,
                  spreadRadius: 0,
                ),
              ]
            : const [],
      ),
      child: Row(
        children: [
          _RankMedal(rank: entry.rank),
          const SizedBox(width: 10),
          _SafeAvatar(
            radius: 20,
            photoUrl: entry.photoUrl,
            fallbackInitial: initial,
            borderColor: isMe ? _kSecondary.withOpacity(0.85) : _kBorder,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        entry.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: isMe ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _kPrimary.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(6),
                          border:
                              Border.all(color: _kSecondary.withOpacity(0.7)),
                        ),
                        child: const Text(
                          'You',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Level $levelNumber • $levelTitle',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _kMuted,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: entry.totalXp.toDouble()),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                builder: (_, value, __) => Text(
                  '${value.round()} XP',
                  style: TextStyle(
                    color: isMe ? _kSecondary : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '+${entry.weeklyXp} this week',
                style: const TextStyle(
                  color: _kMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (xpDelta != null && xpDelta! > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '+$xpDelta XP',
                    style: const TextStyle(
                      color: _kGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.4, end: 0)
                      .then()
                      .fadeOut(delay: 2200.ms, duration: 600.ms),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankMedal extends StatelessWidget {
  final int rank;
  const _RankMedal({required this.rank});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color glow;
    String? emoji;

    switch (rank) {
      case 1:
        color = _kGold;
        glow = _kGold;
        emoji = '🥇';
        break;
      case 2:
        color = _kSilver;
        glow = _kSilver;
        emoji = '🥈';
        break;
      case 3:
        color = _kBronze;
        glow = _kBronze;
        emoji = '🥉';
        break;
      default:
        color = _kSecondary;
        glow = _kSecondary;
        emoji = null;
        break;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.30),
            color.withOpacity(0.06),
          ],
        ),
        border: Border.all(color: color.withOpacity(0.7), width: 1.2),
        boxShadow: emoji != null
            ? [
                BoxShadow(
                  color: glow.withOpacity(0.5),
                  blurRadius: 12,
                ),
              ]
            : const [],
      ),
      child: Center(
        child: emoji != null
            ? Text(emoji, style: const TextStyle(fontSize: 15))
            : Text(
                '$rank',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Safe avatar
// ══════════════════════════════════════════════════════════════════════

class _SafeAvatar extends StatelessWidget {
  final double radius;
  final String? photoUrl;
  final String fallbackInitial;
  final Color borderColor;

  const _SafeAvatar({
    required this.radius,
    required this.photoUrl,
    required this.fallbackInitial,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasUrl = photoUrl != null && photoUrl!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.25),
            blurRadius: 10,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: _kPrimary.withOpacity(0.30),
        foregroundImage: hasUrl ? NetworkImage(photoUrl!) : null,
        onForegroundImageError: hasUrl ? (_, __) {} : null,
        child: Text(
          fallbackInitial,
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 0.75,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Error state
// ══════════════════════════════════════════════════════════════════════

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, color: Color(0xFF444455), size: 56),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _kMuted, fontSize: 12, height: 1.4),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => onRetry(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Retry',
                  style: TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Bottom CTA
// ══════════════════════════════════════════════════════════════════════

class _BottomCTA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _kPrimary.withOpacity(0.35),
                _kPrimary.withOpacity(0.12),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _kPrimary.withOpacity(0.55), width: 1.1),
            boxShadow: [
              BoxShadow(
                color: _kPrimary.withOpacity(0.35),
                blurRadius: 22,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withOpacity(0.5),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🎯', style: TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Be the Top Learner!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Complete lessons, build skills, and earn XP\nto see your name at the top.',
                      style: TextStyle(
                        color: _kSecondary,
                        fontSize: 11.5,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white, size: 22),
            ],
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).boxShadow(
              begin: const BoxShadow(
                color: Colors.transparent,
                blurRadius: 0,
              ),
              end: BoxShadow(
                color: _kPrimary.withOpacity(0.55),
                blurRadius: 26,
                spreadRadius: 1,
              ),
              duration: 2400.ms,
              curve: Curves.easeInOut,
            ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Celebration popup — single, flexible, priority-ordered
// ══════════════════════════════════════════════════════════════════════

class _CelebrationPopup extends StatelessWidget {
  final _CelebrationPayload payload;
  const _CelebrationPopup({required this.payload});

  // Priority order: Top-1 dominates, then any combined rank+XP, then
  // rank-only, then XP-only.
  bool get _isTopOne => payload.isTopOne;
  bool get _isCombined =>
      !payload.isTopOne && payload.hasRankChange && payload.hasXpChange;
  bool get _isRankOnly =>
      !payload.isTopOne && payload.hasRankChange && !payload.hasXpChange;
  bool get _isXpOnly =>
      !payload.isTopOne && !payload.hasRankChange && payload.hasXpChange;

  String get _icon {
    if (_isTopOne) return '🏆';
    if (_isCombined) return '🚀';
    if (_isRankOnly) return '🚀';
    return '⚡';
  }

  String get _headline {
    if (_isTopOne) return "You're at the top!";
    if (_isCombined) return "You're climbing!";
    if (_isRankOnly) return "You're climbing!";
    return "You're making great progress!";
  }

  String get _message {
    if (_isTopOne) return 'Keep your momentum going!';
    if (_isCombined) {
      return 'Your learning is moving you up the leaderboard. Keep going! 🚀';
    }
    if (_isRankOnly) return 'Keep going!';
    return 'Keep going 🚀';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _kSurfaceHi.withOpacity(0.95),
                _kSurface.withOpacity(0.95),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _kPrimary.withOpacity(0.6), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: _kPrimary.withOpacity(0.55),
                blurRadius: 40,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Glowing icon
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _kPrimary.withOpacity(0.75),
                      _kSecondary.withOpacity(0.25),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _kPrimary.withOpacity(0.55),
                      blurRadius: 30,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(_icon, style: const TextStyle(fontSize: 40)),
                ),
              ).animate().scale(
                  begin: const Offset(0.6, 0.6),
                  duration: 600.ms,
                  curve: Curves.easeOutBack),
              const SizedBox(height: 18),
              Text(
                _headline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _kMuted,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),

              // Rank chip
              if (_isTopOne || _isCombined || _isRankOnly) ...[
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _kPrimary.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _kSecondary.withOpacity(0.55)),
                  ),
                  child: Text(
                    _isTopOne
                        ? 'Global Rank #1'
                        : '#${payload.oldRank} → #${payload.newRank}',
                    style: const TextStyle(
                      color: _kSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],

              // XP chip
              if (_isCombined ||
                  _isXpOnly ||
                  (_isTopOne && payload.hasXpChange)) ...[
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _kGreen.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _kGreen.withOpacity(0.55)),
                  ),
                  child: Text(
                    '+${payload.xpDelta} XP',
                    style: const TextStyle(
                      color: _kGreen,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
