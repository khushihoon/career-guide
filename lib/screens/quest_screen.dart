// ══════════════════════════════════════════════════════════════════════
// lib/screens/quest_screen.dart
//
// Career Quest / Mission Center — Daily / Weekly / Monthly quests.
//
// UI layer only. All quest generation, progress, persistence, and
// duplicate-reward protection remain in QuestService. This screen:
//   • displays quest state,
//   • handles taps,
//   • calls existing service methods,
//   • shows feedback.
//
// Preserved from the previous version:
//   • QuestScreen extends StatefulWidget
//   • TabBar with Daily / Weekly / Monthly
//   • QuestService.fetchQuests / claimQuestReward usage
//   • Quest model + GlassCard usage
//   • dark purple visual language
//
// Reliability improvements:
//   • Pull-to-refresh now actually reloads quests.
//   • Claim button guards against double-tap and shows inline loading.
//   • Success snackbar is only shown if the service call succeeds.
//   • Errors show a red snackbar and keep the quest claimable.
//   • Auth-null shows a clean state instead of a blank screen.
//   • Empty tab state is handled per tab.
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/quest_models.dart';
import '../services/quest_service.dart';
import '../widgets/glassmorphism_card.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen>
    with SingleTickerProviderStateMixin {
  static const _bg        = Color(0xFF0F0F1A);
  static const _primary   = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted     = Color(0xFF888899);
  static const _border    = Color(0xFF2A2A40);

  late TabController _tabs;
  final _questService = QuestService();

  List<Quest> _quests = const [];
  bool _loading = true;
  String? _uid;

  /// Quest ids currently being claimed — used ONLY for temporary UI
  /// state (disabling the button, showing an inline spinner). The
  /// permanent duplicate-reward protection lives in QuestService.
  final Set<String> _claiming = <String>{};

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _uid = FirebaseAuth.instance.currentUser?.uid;
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (!mounted) return;

    setState(() {
      _uid = uid;
      _loading = true;
    });

    if (uid == null) {
      if (!mounted) return;
      setState(() {
        _quests = const [];
        _loading = false;
      });
      return;
    }

    try {
      final quests = await _questService.fetchQuests(uid);
      if (!mounted) return;
      setState(() {
        _quests = quests;
        _loading = false;
      });
    } catch (_) {
      // QuestService already falls back to default quests on Firestore
      // failure. If it ever throws, we still avoid a white screen.
      if (!mounted) return;
      setState(() {
        _quests = const [];
        _loading = false;
      });
    }
  }

  /// Reload without toggling the full-screen loader — used by
  /// pull-to-refresh and after a successful claim so the UI does not
  /// flicker back to a spinner.
  Future<void> _reloadSilently() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (!mounted) return;
      setState(() => _quests = const []);
      return;
    }
    try {
      final quests = await _questService.fetchQuests(uid);
      if (!mounted) return;
      setState(() => _quests = quests);
    } catch (_) {
      // Swallow — silent reload must not throw into the framework.
    }
  }

  Future<void> _claimQuest(Quest quest) async {
    final uid = _uid ?? FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Guard against double-tap for the same quest.
    if (_claiming.contains(quest.id)) return;
    setState(() => _claiming.add(quest.id));

    bool success = false;
    try {
      await _questService.claimQuestReward(uid, quest);
      success = true;
    } catch (_) {
      success = false;
    } finally {
      if (mounted) {
        setState(() => _claiming.remove(quest.id));
      }
    }

    // Reload after the claim attempt (success or failure) so the UI
    // reflects the authoritative state either way.
    await _reloadSilently();

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('+${quest.xpReward} XP claimed! 🎉'),
          backgroundColor: _primary,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Couldn\'t claim reward. Please try again.'),
          backgroundColor: Color(0xFFEF4444),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  List<Quest> _filtered(QuestType type) =>
      _quests.where((q) => q.type == type).toList();

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
          'Quests',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: _primary,
          indicatorWeight: 2.5,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.white,
          unselectedLabelColor: _muted,
          labelStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: '🌅 Daily'),
            Tab(text: '📅 Weekly'),
            Tab(text: '🗓️ Monthly'),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_uid == null) {
      return const _CenteredState(
        icon: Icons.lock_outline,
        title: 'Sign in to view your quests',
        subtitle:
            'Your daily, weekly, and monthly quests are tied to your account.',
      );
    }

    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: _primary),
      );
    }

    return TabBarView(
      controller: _tabs,
      children: [
        _QuestList(
          quests: _filtered(QuestType.daily),
          onClaim: _claimQuest,
          claiming: _claiming,
          onRefresh: _reloadSilently,
          emptyMsg: 'Daily quests refresh at midnight.',
        ),
        _QuestList(
          quests: _filtered(QuestType.weekly),
          onClaim: _claimQuest,
          claiming: _claiming,
          onRefresh: _reloadSilently,
          emptyMsg: 'Weekly quests refresh every Monday.',
        ),
        _QuestList(
          quests: _filtered(QuestType.monthly),
          onClaim: _claimQuest,
          claiming: _claiming,
          onRefresh: _reloadSilently,
          emptyMsg: 'Monthly quests refresh on the 1st.',
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// QUEST LIST — summary + cards per tab
// ══════════════════════════════════════════════════════════════════════

class _QuestList extends StatelessWidget {
  final List<Quest> quests;
  final Future<void> Function(Quest) onClaim;
  final Set<String> claiming;
  final Future<void> Function() onRefresh;
  final String emptyMsg;

  const _QuestList({
    required this.quests,
    required this.onClaim,
    required this.claiming,
    required this.onRefresh,
    required this.emptyMsg,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFFA78BFA),
      backgroundColor: const Color(0xFF1A1A2E),
      onRefresh: onRefresh,
      child: quests.isEmpty
          ? _emptyScrollable(emptyMsg)
          : _content(context),
    );
  }

  Widget _emptyScrollable(String message) {
    // Use a scrollable so RefreshIndicator still works on an empty tab.
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 120),
      children: [
        const Icon(Icons.emoji_events_outlined,
            color: Color(0xFF444455), size: 56),
        const SizedBox(height: 16),
        const Text(
          'No quests available right now.',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Color(0xFF888899), fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 20),
        const Text(
          'Pull down to refresh',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF888899), fontSize: 11),
        ),
      ],
    );
  }

  Widget _content(BuildContext context) {
    final completed = quests.where((q) => q.isCompleted).length;
    final totalXp   = quests.fold<int>(0, (s, q) => s + q.xpReward);
    final earnedXp  = quests
        .where((q) => q.isCompleted)
        .fold<int>(0, (s, q) => s + q.xpReward);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(18),
      children: [
        _SummaryCard(
          completed: completed,
          total: quests.length,
          earnedXp: earnedXp,
          totalXp: totalXp,
        ).animate().fadeIn(duration: 220.ms),
        const SizedBox(height: 16),
        ...quests.asMap().entries.map((e) {
          final quest = e.value;
          final isClaiming = claiming.contains(quest.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: QuestCard(
              quest: quest,
              onClaim: quest.isCompleted && !isClaiming
                  ? () => onClaim(quest)
                  : null,
            )
                .animate()
                .fadeIn(delay: (e.key * 50).ms, duration: 240.ms)
                .slideY(begin: 0.15, end: 0, duration: 240.ms),
          );
        }),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// SUMMARY CARD — completion + XP
// ══════════════════════════════════════════════════════════════════════

class _SummaryCard extends StatelessWidget {
  final int completed;
  final int total;
  final int earnedXp;
  final int totalXp;

  const _SummaryCard({
    required this.completed,
    required this.total,
    required this.earnedXp,
    required this.totalXp,
  });

  @override
  Widget build(BuildContext context) {
    // Safe percentage: never NaN, never out of [0, 100].
    final double fraction =
        total <= 0 ? 0.0 : (completed / total).clamp(0.0, 1.0);
    final int pct = (fraction * 100).round();

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      gradientColors: [
        const Color(0xFF7C3AED).withOpacity(0.15),
        const Color(0xFFA78BFA).withOpacity(0.06),
      ],
      borderColor: const Color(0xFF7C3AED).withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$completed / $total Completed',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$earnedXp / $totalXp XP earned',
                      style: const TextStyle(
                          color: Color(0xFF888899), fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                '$pct%',
                style: const TextStyle(
                  color: Color(0xFFA78BFA),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 8,
              backgroundColor: const Color(0xFF0F0F20),
              valueColor:
                  const AlwaysStoppedAnimation(Color(0xFF7C3AED)),
            ),
          ),
        ],
      ),
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