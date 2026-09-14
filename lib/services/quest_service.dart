// ══════════════════════════════════════════════════════════════════════
// lib/services/quest_service.dart
// NEW — Quest generation, tracking, and completion
// ══════════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quest_models.dart';
import '../models/copilot_models.dart';

class QuestService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Fetch all active quests ────────────────────────────────────────
  Future<List<Quest>> fetchQuests(String uid) async {
    try {
      final doc = await _db.collection('quests').doc(uid).get();
      final data = doc.data() ?? {};

      final daily   = _parseQuestList(data['daily']);
      final weekly  = _parseQuestList(data['weekly']);
      final monthly = _parseQuestList(data['monthly']);

      // Regenerate stale quests
      final now = DateTime.now();
      final List<Quest> result = [];

      result.addAll(await _ensureFresh(uid, daily,   QuestType.daily,   now));
      result.addAll(await _ensureFresh(uid, weekly,  QuestType.weekly,  now));
      result.addAll(await _ensureFresh(uid, monthly, QuestType.monthly, now));

      return result;
    } catch (_) {
      return _generateDefault(QuestType.daily)
        ..addAll(_generateDefault(QuestType.weekly))
        ..addAll(_generateDefault(QuestType.monthly));
    }
  }

  List<Quest> _parseQuestList(dynamic raw) {
    if (raw == null) return [];
    try {
      final list = raw as List;
      return list
          .map((e) => Quest.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Quest>> _ensureFresh(
    String uid,
    List<Quest> existing,
    QuestType type,
    DateTime now,
  ) async {
    // Check if any are expired or missing
    final valid = existing
        .where((q) => !q.isExpired && q.status != QuestStatus.expired)
        .toList();

    if (valid.isNotEmpty) return valid;

    // Generate new ones
    final fresh = _generateDefault(type);
    await _persistQuestType(uid, type, fresh);
    return fresh;
  }

  List<Quest> _generateDefault(QuestType type) {
    final now = DateTime.now();

    switch (type) {
      case QuestType.daily:
        final expires = DateTime(now.year, now.month, now.day, 23, 59, 59);
        return [
          Quest(
            id: 'daily_goals_3_${_dateKey(now)}',
            title: 'Triple Threat',
            description: 'Complete 3 daily goals today',
            type: QuestType.daily,
            status: QuestStatus.active,
            xpReward: 60,
            progressCurrent: 0,
            progressTarget: 3,
            expiresAt: expires,
            isAiGenerated: true,
          ),
          Quest(
            id: 'daily_checkin_${_dateKey(now)}',
            title: 'Show Up',
            description: 'Open the app and check in today',
            type: QuestType.daily,
            status: QuestStatus.active,
            xpReward: 20,
            progressCurrent: 0,
            progressTarget: 1,
            expiresAt: expires,
            isAiGenerated: false,
          ),
          Quest(
            id: 'daily_streak_${_dateKey(now)}',
            title: 'Keep the Fire',
            description: 'Maintain your learning streak',
            type: QuestType.daily,
            status: QuestStatus.active,
            xpReward: 30,
            progressCurrent: 0,
            progressTarget: 1,
            expiresAt: expires,
            isAiGenerated: false,
          ),
        ];

      case QuestType.weekly:
        final monday = now.subtract(Duration(days: now.weekday - 1));
        final expires = DateTime(
            monday.year, monday.month, monday.day + 6, 23, 59, 59);
        return [
          Quest(
            id: 'weekly_goals_15_${_weekKey(now)}',
            title: 'Weekly Warrior',
            description: 'Complete 15 goals this week',
            type: QuestType.weekly,
            status: QuestStatus.active,
            xpReward: 300,
            progressCurrent: 0,
            progressTarget: 15,
            expiresAt: expires,
            isAiGenerated: true,
          ),
          Quest(
            id: 'weekly_streak_5_${_weekKey(now)}',
            title: 'Consistency King',
            description: 'Maintain streak for 5 days this week',
            type: QuestType.weekly,
            status: QuestStatus.active,
            xpReward: 200,
            progressCurrent: 0,
            progressTarget: 5,
            expiresAt: expires,
            isAiGenerated: false,
          ),
        ];

      case QuestType.monthly:
        final expires = DateTime(now.year, now.month + 1, 1)
            .subtract(const Duration(seconds: 1));
        return [
          Quest(
            id: 'monthly_goals_50_${_monthKey(now)}',
            title: 'Monthly Milestone',
            description: 'Complete 50 goals this month',
            type: QuestType.monthly,
            status: QuestStatus.active,
            xpReward: 1000,
            progressCurrent: 0,
            progressTarget: 50,
            expiresAt: expires,
            isAiGenerated: true,
          ),
          Quest(
            id: 'monthly_streak_20_${_monthKey(now)}',
            title: 'Iron Will',
            description: 'Maintain a 20-day streak this month',
            type: QuestType.monthly,
            status: QuestStatus.active,
            xpReward: 750,
            progressCurrent: 0,
            progressTarget: 20,
            expiresAt: expires,
            isAiGenerated: false,
          ),
        ];

      case QuestType.bonus:
        return [];
    }
  }

  // ── Update quest progress after goal completion ────────────────────
  Future<void> onGoalCompleted(String uid, int totalCompletedToday) async {
    final quests = await fetchQuests(uid);
    final updated = <Quest>[];

    for (final q in quests) {
      if (q.isCompleted || q.isExpired) {
        updated.add(q);
        continue;
      }
      // "goals" quests increment on each completion
      if (q.id.contains('goals')) {
        final newCurrent = (q.progressCurrent + 1).clamp(0, q.progressTarget);
        final newStatus = newCurrent >= q.progressTarget
            ? QuestStatus.completed
            : QuestStatus.active;
        updated.add(q.copyWith(
          progressCurrent: newCurrent,
          status: newStatus,
        ));
      } else {
        updated.add(q);
      }
    }

    await _persistAll(uid, updated);
  }

  Future<void> onCheckIn(String uid) async {
    final quests = await fetchQuests(uid);
    final updated = quests.map((q) {
      if (!q.isCompleted && q.id.contains('checkin')) {
        return q.copyWith(progressCurrent: 1, status: QuestStatus.completed);
      }
      return q;
    }).toList();
    await _persistAll(uid, updated);
  }

  Future<void> onStreakUpdated(String uid, int streak) async {
    final quests = await fetchQuests(uid);
    final updated = quests.map((q) {
      if (!q.isCompleted && q.id.contains('streak')) {
        final newCurrent = streak.clamp(0, q.progressTarget);
        final done = newCurrent >= q.progressTarget;
        return q.copyWith(
          progressCurrent: newCurrent,
          status: done ? QuestStatus.completed : QuestStatus.active,
        );
      }
      return q;
    }).toList();
    await _persistAll(uid, updated);
  }

  // ── XP reward for completing a quest ──────────────────────────────
  Future<void> claimQuestReward(String uid, Quest quest) async {
    if (!quest.isCompleted) return;
    await _db.collection('users').doc(uid).update({
      'totalXp': FieldValue.increment(quest.xpReward),
    });
  }

  // ── Persistence helpers ────────────────────────────────────────────
  Future<void> _persistAll(String uid, List<Quest> quests) async {
    final daily   = quests.where((q) => q.type == QuestType.daily).toList();
    final weekly  = quests.where((q) => q.type == QuestType.weekly).toList();
    final monthly = quests.where((q) => q.type == QuestType.monthly).toList();

    await _db.collection('quests').doc(uid).set({
      'daily':   daily.map((q) => q.toMap()).toList(),
      'weekly':  weekly.map((q) => q.toMap()).toList(),
      'monthly': monthly.map((q) => q.toMap()).toList(),
    }, SetOptions(merge: true));
  }

  Future<void> _persistQuestType(
      String uid, QuestType type, List<Quest> quests) async {
    await _db.collection('quests').doc(uid).set({
      type.name: quests.map((q) => q.toMap()).toList(),
    }, SetOptions(merge: true));
  }

  String _dateKey(DateTime d)  => '${d.year}${d.month}${d.day}';
  String _weekKey(DateTime d)  => '${d.year}W${_isoWeek(d)}';
  String _monthKey(DateTime d) => '${d.year}M${d.month}';

  int _isoWeek(DateTime d) {
    final startOfYear = DateTime(d.year, 1, 1);
    final diff = d.difference(startOfYear).inDays;
    return (diff / 7).ceil();
  }
}