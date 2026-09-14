// ══════════════════════════════════════════════════════════════════════
// lib/screens/leaderboard_screen.dart
// NEW — Global & Weekly leaderboard screen
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
  static const _bg       = Color(0xFF0F0F1A);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);

  late TabController _tabs;
  final _service = LeaderboardService();

  List<LeaderboardEntry> _global  = [];
  List<LeaderboardEntry> _weekly  = [];
  bool _loadingGlobal  = true;
  bool _loadingWeekly  = true;
  String? _uid;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _uid  = FirebaseAuth.instance.currentUser?.uid;
    _loadGlobal();
    _loadWeekly();
  }

  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  Future<void> _loadGlobal() async {
    setState(() => _loadingGlobal = true);
    final data = await _service.fetchGlobalTop(currentUid: _uid);
    if (mounted) setState(() { _global = data; _loadingGlobal = false; });
  }

  Future<void> _loadWeekly() async {
    setState(() => _loadingWeekly = true);
    final data = await _service.fetchWeeklyTop(currentUid: _uid);
    if (mounted) setState(() { _weekly = data; _loadingWeekly = false; });
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
            onRefresh: _loadGlobal,
            emptyMsg: 'No global rankings yet.',
          ),
          _BoardList(
            entries: _weekly,
            loading: _loadingWeekly,
            onRefresh: _loadWeekly,
            emptyMsg: 'No weekly rankings yet. Complete goals to rank!',
          ),
        ],
      ),
    );
  }
}

class _BoardList extends StatelessWidget {
  final List<LeaderboardEntry> entries;
  final bool loading;
  final VoidCallback onRefresh;
  final String emptyMsg;

  const _BoardList({
    required this.entries,
    required this.loading,
    required this.onRefresh,
    required this.emptyMsg,
  });

  static const _primary   = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
          child: CircularProgressIndicator(color: _primary));
    }
    if (entries.isEmpty) {
      return Center(
          child: Text(emptyMsg,
              style: const TextStyle(
                  color: Color(0xFF888899), fontSize: 13)));
    }

    // Find the current user's position (may be > visible top 50)
    final currentEntry = entries.where((e) => e.isCurrentUser).firstOrNull;

    return RefreshIndicator(
      color: _secondary,
      backgroundColor: const Color(0xFF1A1A2E),
      onRefresh: () async => onRefresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Top 3 hero podium
          if (entries.length >= 3)
            _Podium(top3: entries.take(3).toList())
                .animate()
                .fadeIn(duration: 500.ms),

          const SizedBox(height: 16),

          // User's position banner (if not in visible list)
          if (currentEntry != null && currentEntry.rank > 50)
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
                      'Your rank: #${currentEntry.rank}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text('${currentEntry.totalXp} XP',
                        style: const TextStyle(
                            color: _secondary, fontSize: 13)),
                  ],
                ),
              ),
            ),

          // Full list (skip top 3 already shown in podium)
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFF7C3AED).withOpacity(0.3),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  : null,
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
        // Podium base
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