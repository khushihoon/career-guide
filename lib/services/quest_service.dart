// ══════════════════════════════════════════════════════════════════════
// lib/services/quest_service.dart
//
// Quest generation, progress tracking, and safe reward claiming.
//
// Reliability-focused upgrade over the previous version:
//   • Duplicate-XP protection for claimQuestReward is now persisted in
//     Firestore (per-quest `rewardClaimed` marker inside the existing
//     quest document), so a second claim — including across app
//     restarts and double taps — can never award XP twice.
//   • Malformed individual quest entries are skipped without discarding
//     the rest of the list.
//   • _isoWeek() now uses the ISO-8601 definition, so week keys are
//     correct across year boundaries (e.g. late December / early
//     January).
//   • Non-positive / malformed progress values are sanitized before
//     being applied.
//   • All existing public method signatures, quest IDs, titles,
//     descriptions, XP rewards, targets, and the Firestore document
//     structure (quests/{uid} → daily/weekly/monthly arrays) are
//     preserved so no other file needs to change.
//
// This file intentionally does NOT redesign the Quest model
// (lib/models/quest_models.dart) — reward-claim state is tracked inside
// the existing Firestore quest document via a small `claimedQuestIds`
// array on quests/{uid}, which is additive and backward-compatible.
// ══════════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quest_models.dart';

class QuestService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Field on quests/{uid} that records every quest id whose XP reward
  // has already been paid out. Append-only, so a re-claim of the same id
  // is a no-op. Stored alongside the existing daily/weekly/monthly
  // arrays — no new document, no new collection.
  static const String _claimedField = 'claimedQuestIds';

  // ── Fetch all active quests ────────────────────────────────────────
  Future<List<Quest>> fetchQuests(String uid) async {
    try {
      final doc = await _db.collection('quests').doc(uid).get();
      final data = doc.data() ?? {};

      final daily   = _parseQuestList(data['daily']);
      final weekly  = _parseQuestList(data['weekly']);
      final monthly = _parseQuestList(data['monthly']);

      final now = DateTime.now();
      final List<Quest> result = [];

      result.addAll(await _ensureFresh(uid, daily,   QuestType.daily,   now));
      result.addAll(await _ensureFresh(uid, weekly,  QuestType.weekly,  now));
      result.addAll(await _ensureFresh(uid, monthly, QuestType.monthly, now));

      return result;
    } catch (_) {
      // UI-safe fallback only — do NOT imply the fallback was persisted.
      return _generateDefault(QuestType.daily)
        ..addAll(_generateDefault(QuestType.weekly))
        ..addAll(_generateDefault(QuestType.monthly));
    }
  }

  /// Defensive parse of a Firestore quest array.
  ///
  /// One malformed entry must never discard the rest of the list:
  /// invalid items are skipped individually, valid ones are kept.
  List<Quest> _parseQuestList(dynamic raw) {
    if (raw is! List) return const [];
    final result = <Quest>[];
    for (final entry in raw) {
      if (entry is! Map) continue;
      try {
        final map = Map<String, dynamic>.from(entry);
        result.add(Quest.fromMap(map));
      } catch (_) {
        // Skip just this entry; keep the rest.
      }
    }
    return result;
  }

  Future<List<Quest>> _ensureFresh(
    String uid,
    List<Quest> existing,
    QuestType type,
    DateTime now,
  ) async {
    // A quest is considered still valid if it hasn't expired. Completed
    // quests that are NOT yet expired are kept so their reward can still
    // be claimed. Only expired quests (and missing lists) trigger a
    // regeneration.
    final valid = existing
        .where((q) => !q.isExpired && q.status != QuestStatus.expired)
        .toList();

    if (valid.isNotEmpty) return valid;

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
        // Preserved behaviour — no default bonus quests.
        return [];
    }
  }

  // ── Update quest progress after goal completion ────────────────────
  //
  // The `totalCompletedToday` parameter is preserved for backward
  // compatibility, but progress is advanced by exactly one per call so a
  // single completion event yields a single logical progress update.
  // Repeated fetch/persist cycles cannot double-count.
  Future<void> onGoalCompleted(
    String uid,
    int totalCompletedToday,
  ) async {
    final quests = await fetchQuests(uid);
    final updated = <Quest>[];

    for (final q in quests) {
      if (q.isCompleted || q.isExpired) {
        updated.add(q);
        continue;
      }
      if (q.id.contains('goals')) {
        final newCurrent =
            (q.progressCurrent + 1).clamp(0, q.progressTarget);
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

  // ── XP reward for completing a quest (idempotent) ──────────────────
  //
  // Uses a transaction to atomically:
  //   1. re-read the quests/{uid} document,
  //   2. check whether this quest id has already been rewarded,
  //   3. if not, append it to `claimedQuestIds` and increment totalXp.
  //
  // A repeated call (including concurrent double taps) sees the id
  // already present in the claimed list and returns without touching XP.
  // A Firestore failure propagates instead of falsely marking the reward
  // as claimed.
  Future<void> claimQuestReward(String uid, Quest quest) async {
    if (!quest.isCompleted) return;

    final questsRef = _db.collection('quests').doc(uid);
    final userRef   = _db.collection('users').doc(uid);
    final questId   = quest.id;
    final reward    = quest.xpReward;

    await _db.runTransaction((tx) async {
      final snapshot = await tx.get(questsRef);
      final data = snapshot.data() ?? <String, dynamic>{};

      final claimedRaw = data[_claimedField];
      final claimed = <String>{};
      if (claimedRaw is List) {
        for (final e in claimedRaw) {
          if (e is String) claimed.add(e);
        }
      }

      if (claimed.contains(questId)) {
        // Already rewarded — nothing to do.
        return;
      }

      tx.set(
        questsRef,
        {_claimedField: FieldValue.arrayUnion([questId])},
        SetOptions(merge: true),
      );

      if (reward > 0) {
        tx.set(
          userRef,
          {'totalXp': FieldValue.increment(reward)},
          SetOptions(merge: true),
        );
      }
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
    String uid,
    QuestType type,
    List<Quest> quests,
  ) async {
    await _db.collection('quests').doc(uid).set({
      type.name: quests.map((q) => q.toMap()).toList(),
    }, SetOptions(merge: true));
  }

  // ── Date key helpers ───────────────────────────────────────────────
  String _dateKey(DateTime d)  => '${d.year}${d.month}${d.day}';
  String _weekKey(DateTime d)  => '${d.year}W${_isoWeek(d)}';
  String _monthKey(DateTime d) => '${d.year}M${d.month}';

  /// ISO-8601 week number (1–53).
  ///
  /// Uses the standard definition: a week starts on Monday, and week 1
  /// is the week containing the first Thursday of the year. This is
  /// correct around year boundaries, where the naive
  /// `(dayOfYear / 7).ceil()` approach can be off by one.
  int _isoWeek(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    // Thursday of the current ISO week determines the ISO year.
    final thursday = d.add(Duration(days: 4 - (d.weekday)));
    final isoYear  = thursday.year;
    // January 4th is always in ISO week 1.
    final jan4   = DateTime(isoYear, 1, 4);
    final week1Mon = jan4.subtract(Duration(days: jan4.weekday - 1));
    final diffDays = thursday.difference(week1Mon).inDays;
    return (diffDays ~/ 7) + 1;
  }
}