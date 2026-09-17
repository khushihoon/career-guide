// ══════════════════════════════════════════════════════════════════════
// lib/screens/leaderboard_screen.dart
// Global & Weekly leaderboard — presentation/orchestration layer only.
//
// All leaderboard data flows through LeaderboardService. This screen
// never touches Firestore directly, never calculates ranking, and never
// awards XP.
//
// Reliability improvements over the previous version:
//   • Every async callback checks `mounted` before setState.
//   • Global and Weekly loading have independent error states so a
//     failed load is never shown as "empty leaderboard".
//   • Pull-to-refresh now truly awaits the refresh future.
//   • Current user's rank is looked up via
//     LeaderboardService.getCurrentUserRank using the user's actual
//     total XP resolved from the existing leaderboard data flow when
//     they are not already present in the loaded top list.
//   • Podium avatars fail gracefully to initials on broken images.
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/quest_models.dart';
import '../services/leaderboard_service.dart';
import '../widgets/glassmorphism_card.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});
  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  static const _bg        = Color(0xFF0F0F1A);
  static const _surface   = Color(0xFF1A1A2E);
  static const _primary   = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted     = Color(0xFF888899);

  late TabController _tabs;
  final _service = LeaderboardService();

  List<LeaderboardEntry> _global = const [];
  List<LeaderboardEntry> _weekly = const [];

  bool _loadingGlobal = true;
  bool _loadingWeekly = true;

  /// User-facing error strings (null = no error). Kept separate so a
  /// failed load is never presented as an empty list.
  String? _globalError;
  String? _weeklyError;

  /// Current user's global rank, resolved lazily when the user is not
  /// already present in the loaded top list. null means "not resolved
  /// yet" or "unavailable".
  int? _currentUserGlobalRank;
  int? _currentUserGlobalXp;

  String? _uid;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _uid = FirebaseAuth.instance.currentUser?.uid;
    _loadGlobal();
    _loadWeekly();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  // ── Data loading ───────────────────────────────────────────────────

  Future<void> _loadGlobal() async {
    if (!mounted) return;
    setState(() {
      _loadingGlobal = true;
      _globalError = null;
    });

    try {
      final data = await _service.fetchGlobalTop(currentUid: _uid);

      // Resolve current user's global rank only when they are not
      // already present in the returned top list.
      int? resolvedRank;
      int? resolvedXp;
      final meInList = _uid == null
          ? null
          : data
              .where((e) => e.isCurrentUser)
              .cast<LeaderboardEntry?>()
              .firstOrNull;

      if (meInList != null) {
        resolvedRank = meInList.rank;
        resolvedXp = meInList.totalXp;
      } else if (_uid != null) {
        // The current user is not in the returned top list. Resolve the
        // user's actual total XP from the existing leaderboard data
        // flow before requesting their global rank.
        //
        // The existing public API used to fetch the current user's
        // entry is `fetchFriendsLeaderboard` — passing an empty friend
        // list still includes the current user, and returns their
        // global entry if it exists.
        try {
          final mineList = await _service.fetchFriendsLeaderboard(
            uid: _uid!,
            friendUids: const [],
          );
          final mine = mineList
              .where((e) => e.isCurrentUser)
              .cast<LeaderboardEntry?>()
              .firstOrNull;

          if (mine != null) {
            resolvedXp = mine.totalXp;
          }

          if (resolvedXp != null) {
            final rank =
                await _service.getCurrentUserRank(_uid!, resolvedXp);
            if (rank > 0) {
              resolvedRank = rank;
            }
          }
        } catch (_) {
          // Silently ignore — banner is optional.
        }
      }

      if (!mounted) return;
      setState(() {
        _global = data;
        _loadingGlobal = false;
        _globalError = null;
        _currentUserGlobalRank = resolvedRank;
        _currentUserGlobalXp = resolvedXp;
      });
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

  // ── Build ──────────────────────────────────────────────────────────

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
        title: const Text(
          'Leaderboard',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: _primary,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.white,
          unselectedLabelColor: _muted,
          tabs: const [
            Tab(text: '🌍 Global'),
            Tab(text: '📅 This Week'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _BoardList(
            entries: _global,
            loading: _loadingGlobal,
            error: _globalError,
            onRefresh: _loadGlobal,
            emptyMsg: 'No global rankings yet.',
            currentUserGlobalRank: _currentUserGlobalRank,
            currentUserGlobalXp: _currentUserGlobalXp,
            isGlobalBoard: true,
          ),
          _BoardList(
            entries: _weekly,
            loading: _loadingWeekly,
            error: _weeklyError,
            onRefresh: _loadWeekly,
            emptyMsg: 'No weekly rankings yet. Complete goals to rank!',
            currentUserGlobalRank: null,
            currentUserGlobalXp: null,
            isGlobalBoard: false,
          ),
        ],
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

  /// Current user's global rank (only set for the Global tab). Weekly
  /// rank is intentionally not shown because LeaderboardService does not
  /// expose a weekly rank API.
  final int? currentUserGlobalRank;
  final int? currentUserGlobalXp;
  final bool isGlobalBoard;

  const _BoardList({
    required this.entries,
    required this.loading,
    required this.error,
    required this.onRefresh,
    required this.emptyMsg,
    required this.currentUserGlobalRank,
    required this.currentUserGlobalXp,
    required this.isGlobalBoard,
  });

  static const _bg        = Color(0xFF0F0F1A);
  static const _primary   = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(color: _primary),
      );
    }

    if (error != null) {
      return _ErrorState(message: error!, onRetry: onRefresh);
    }

    if (entries.isEmpty) {
      return RefreshIndicator(
        color: _secondary,
        backgroundColor: const Color(0xFF1A1A2E),
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 120),
          children: [
            const Icon(Icons.emoji_events_outlined,
                color: Color(0xFF444455), size: 56),
            const SizedBox(height: 16),
            Text(
              emptyMsg,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xFF888899), fontSize: 13, height: 1.4),
            ),
          ],
        ),
      );
    }

    // Rank banner: only shown when the user's global rank is known and
    // outside the visible top list. Weekly board does not show a rank
    // banner (no weekly rank API exists).
    final meInList = entries.where((e) => e.isCurrentUser).firstOrNull;
    final showBanner = isGlobalBoard &&
        meInList == null &&
        currentUserGlobalRank != null;

    return RefreshIndicator(
      color: _secondary,
      backgroundColor: const Color(0xFF1A1A2E),
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          if (entries.length >= 3)
            _Podium(top3: entries.take(3).toList())
                .animate()
                .fadeIn(duration: 500.ms),

          const SizedBox(height: 16),

          if (showBanner)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                padding: const EdgeInsets.all(12),
                gradientColors: [
                  _primary.withOpacity(0.2),
                  _secondary.withOpacity(0.1),
                ],
                borderColor: _primary.withOpacity(0.4),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: _secondary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Your global rank: #$currentUserGlobalRank',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    if (currentUserGlobalXp != null)
                      Text('$currentUserGlobalXp XP',
                          style: const TextStyle(
                              color: _secondary, fontSize: 13)),
                  ],
                ),
              ),
            ),

          ...entries.skip(entries.length >= 3 ? 3 : 0)
              .toList()
              .asMap()
              .entries
              .map((e) => LeaderboardTile(entry: e.value)
                  .animate()
                  .fadeIn(delay: (e.key * 30).ms)),
        ],
      ),
    );
  }
}

// ── Error state ───────────────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  static const _primary = Color(0xFF7C3AED);
  static const _muted   = Color(0xFF888899);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off,
                color: Color(0xFF444455), size: 56),
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
              style: TextStyle(color: _muted, fontSize: 12, height: 1.4),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => onRetry(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
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

// ── Podium for top 3 ──────────────────────────────────────────────────
class _Podium extends StatelessWidget {
  final List<LeaderboardEntry> top3;
  const _Podium({required this.top3});

  @override
  Widget build(BuildContext context) {
    final first  = top3[0];
    final second = top3.length > 1 ? top3[1] : null;
    final third  = top3.length > 2 ? top3[2] : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (second != null)
          Expanded(child: _PodiumColumn(entry: second, height: 90, emoji: '🥈')),
        Expanded(child: _PodiumColumn(entry: first, height: 120, emoji: '🥇')),
        if (third != null)
          Expanded(child: _PodiumColumn(entry: third, height: 70, emoji: '🥉')),
      ],
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  final LeaderboardEntry entry;
  final double height;
  final String emoji;

  const _PodiumColumn({
    required this.entry,
    required this.height,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    final initial = entry.displayName.isNotEmpty
        ? entry.displayName[0].toUpperCase()
        : '?';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            _SafeAvatar(
              radius: 26,
              photoUrl: entry.photoUrl,
              fallbackInitial: initial,
            ),
            Text(emoji, style: const TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          entry.displayName.split(' ').first,
          style: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${entry.totalXp} XP',
          style: const TextStyle(color: Color(0xFFA78BFA), fontSize: 10),
        ),
        const SizedBox(height: 6),
        Container(
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF7C3AED).withOpacity(0.3),
                const Color(0xFF7C3AED).withOpacity(0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            border: Border.all(
                color: const Color(0xFF7C3AED).withOpacity(0.3)),
          ),
        ),
      ],
    );
  }
}

// ── Safe avatar with initials fallback ────────────────────────────────
class _SafeAvatar extends StatelessWidget {
  final double radius;
  final String? photoUrl;
  final String fallbackInitial;

  const _SafeAvatar({
    required this.radius,
    required this.photoUrl,
    required this.fallbackInitial,
  });

  @override
  Widget build(BuildContext context) {
    final hasUrl = photoUrl != null && photoUrl!.isNotEmpty;

    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFF7C3AED).withOpacity(0.3),
      // Use foregroundImage so we can attach an error handler that falls
      // back gracefully to the child (initials) when the image fails.
      foregroundImage: hasUrl ? NetworkImage(photoUrl!) : null,
      onForegroundImageError: hasUrl ? (_, __) {} : null,
      child: Text(
        fallbackInitial,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.7,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}