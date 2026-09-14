// ══════════════════════════════════════════════════════════════════════
// lib/screens/quest_screen.dart
// NEW — Daily / Weekly / Monthly Quests screen
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/quest_models.dart';
import '../services/quest_service.dart';
import '../services/reward_service.dart';
import '../widgets/glassmorphism_card.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});
  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen>
    with SingleTickerProviderStateMixin {
  static const _bg      = Color(0xFF0F0F1A);
  static const _primary = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted   = Color(0xFF888899);

  late TabController _tabs;
  final _questService  = QuestService();
  final _rewardService = RewardService();

  List<Quest> _quests = [];
  bool _loading = true;
  String? _uid;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _uid  = FirebaseAuth.instance.currentUser?.uid;
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (_uid == null) return;
    setState(() => _loading = true);
    final quests = await _questService.fetchQuests(_uid!);
    if (mounted) setState(() { _quests = quests; _loading = false; });
  }

  Future<void> _claimQuest(Quest quest) async {
    if (_uid == null) return;
    await _questService.claimQuestReward(_uid!, quest);
    _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('+${quest.xpReward} XP claimed! 🎉'),
          backgroundColor: _primary,
          duration: const Duration(seconds: 2),
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
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.white,
          unselectedLabelColor: _muted,
          labelStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: '🌅 Daily'),
            Tab(text: '📅 Weekly'),
            Tab(text: '🗓️ Monthly'),
          ],
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: _primary))
          : TabBarView(
              controller: _tabs,
              children: [
                _QuestList(
                  quests: _filtered(QuestType.daily),
                  onClaim: _claimQuest,
                  emptyMsg: 'Daily quests refresh at midnight.',
                ),
                _QuestList(
                  quests: _filtered(QuestType.weekly),
                  onClaim: _claimQuest,
                  emptyMsg: 'Weekly quests refresh every Monday.',
                ),
                _QuestList(
                  quests: _filtered(QuestType.monthly),
                  onClaim: _claimQuest,
                  emptyMsg: 'Monthly quests refresh on the 1st.',
                ),
              ],
            ),
    );
  }
}

class _QuestList extends StatelessWidget {
  final List<Quest> quests;
  final Future<void> Function(Quest) onClaim;
  final String emptyMsg;

  const _QuestList({
    required this.quests,
    required this.onClaim,
    required this.emptyMsg,
  });

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty) {
      return Center(
        child: Text(emptyMsg,
            style: const TextStyle(color: Color(0xFF888899), fontSize: 13)),
      );
    }

    final completed = quests.where((q) => q.isCompleted).length;
    final totalXp   = quests.fold(0, (s, q) => s + q.xpReward);
    final earnedXp  = quests
        .where((q) => q.isCompleted)
        .fold(0, (s, q) => s + q.xpReward);

    return RefreshIndicator(
      color: const Color(0xFFA78BFA),
      backgroundColor: const Color(0xFF1A1A2E),
      onRefresh: () async {},
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // Progress summary
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            gradientColors: [
              const Color(0xFF7C3AED).withOpacity(0.15),
              const Color(0xFFA78BFA).withOpacity(0.06),
            ],
            borderColor: const Color(0xFF7C3AED).withOpacity(0.3),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$completed / ${quests.length} completed',
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
                  '${quests.isEmpty ? 0 : (completed / quests.length * 100).toInt()}%',
                  style: const TextStyle(
                    color: Color(0xFFA78BFA),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),

          const SizedBox(height: 16),

          ...quests.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: QuestCard(
                  quest: e.value,
                  onClaim: e.value.isCompleted
                      ? () => onClaim(e.value)
                      : null,
                ).animate().fadeIn(delay: (e.key * 60).ms).slideY(begin: 0.2),
              )),
        ],
      ),
    );
  }
}