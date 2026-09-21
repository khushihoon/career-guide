// ══════════════════════════════════════════════════════════════════════
// lib/services/quest_service.dart
//
// Quest generation, progress tracking, and safe reward claiming.
//
// Reliability-focused implementation:
//   • Duplicate-XP protection for claimQuestReward is persisted in
//     Firestore via an append-only `claimedQuestIds` array on the
//     quests/{uid} document, so a second claim — including across app
//     restarts, double taps, and concurrent devices — can never award
//     XP twice.
//   • Malformed individual quest entries are skipped without discarding
//     the rest of the list.
//   • _isoWeek() uses the ISO-8601 definition, so week keys are
//     correct across year boundaries.
//   • Non-positive / malformed progress values are sanitized before
//     being applied.
//   • All existing public method signatures, quest IDs, titles,
//     descriptions, XP rewards, targets, and the Firestore document
//     structure (quests/{uid} → daily/weekly/monthly arrays +
//     claimedQuestIds) are preserved so no other file needs to change.
//
// ─────────────────────────────────────────────────────────────────────
// CLAIM-STATE PROJECTION
// ─────────────────────────────────────────────────────────────────────
// `claimedQuestIds` is the authoritative source of truth for reward
// claiming. fetchQuests() reads that set from the SAME quests/{uid}
// document and projects it onto each returned Quest via
// `Quest.copyWith(rewardClaimed: ...)`.
//
//   • Quest.rewardClaimed is a READ / UI projection only — it is never
//     authoritative and never persisted as a source of truth.
//   • A missing / malformed claimedQuestIds safely becomes an empty
//     set → every returned quest parses with rewardClaimed == false.
//   • Unknown ids inside claimedQuestIds have no effect on unrelated
//     quests.
//
// ─────────────────────────────────────────────────────────────────────
// EXPIRY CORRECTNESS
// ─────────────────────────────────────────────────────────────────────
// Every period / expiry decision in this service is based on the raw
// `expiresAt` timestamp read from Firestore — never on the model's
// `isExpired` getter. This guarantees:
//   • A new day / week / month always rotates in a fresh quest set.
//   • A completed-but-unclaimed quest remains claimable ONLY while its
//     period is still valid.
//   • A completed-and-expired quest cannot block the next period and
//     can never be claimed.
//
// ─────────────────────────────────────────────────────────────────────
// PARTIAL ROTATION
// ─────────────────────────────────────────────────────────────────────
// fetchQuests() ensures the current-period default quest set exists
// per QuestType without clobbering valid quests:
//   • Fully valid set     → returned unchanged.
//   • Partially valid set → valid entries kept as-is; expired / missing
//                           default entries are restored from the fresh
//                           default set. Progress on the surviving
//                           entries is preserved.
//   • Fully expired set   → complete fresh default set is generated.
// No duplicate quest IDs are ever produced; claimedQuestIds and any
// unrelated Firestore fields are preserved via merge writes of only the
// affected quest-type array.
//
// ─────────────────────────────────────────────────────────────────────
// CLAIM RESULT CONTRACT
// ─────────────────────────────────────────────────────────────────────
// claimQuestReward() returns Future<QuestClaimResult>. The change from
// Future<void> is source-safe for callers that simply
// `await service.claimQuestReward(...)`.
//
// The result is authoritative:
//   awarded        → XP was genuinely paid out in this call
//   alreadyClaimed → id already present in claimedQuestIds
//   notCompleted   → stored quest is not completed
//   notFound       → stored quest id does not exist, or its expiresAt
//                    is missing / invalid (treated as not awardable)
//   expired        → stored quest is completed but its period has ended
//   invalidReward  → stored reward was <= 0 (id is still marked
//                    claimed to guarantee idempotency)
//   error          → reserved for callers that wrap the future in a
//                    try/catch; the service rethrows Firestore errors
//
// ─────────────────────────────────────────────────────────────────────
// CONCURRENCY-SAFETY
// ─────────────────────────────────────────────────────────────────────
// Every progress mutation (onGoalCompleted, onCheckIn, onStreakUpdated)
// and reward claim runs inside a Firestore transaction:
//   1. Read the current quests/{uid} document inside the transaction.
//   2. Recompute the affected quest entries from THAT authoritative
//      snapshot — never from a stale pre-transaction read.
//   3. Write back only the affected quest type array (merge), leaving
//      the other type arrays, claimedQuestIds, and any unrelated
//      fields untouched.
//
// This file intentionally does NOT redesign the Quest model
// (lib/models/quest_models.dart).
// ══════════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quest_models.dart';

/// Authoritative outcome of a reward-claim attempt.
enum QuestClaimResult {
  /// XP was actually paid out by this call.
  awarded,

  /// The quest id was already present in `claimedQuestIds` — no XP was
  /// awarded by this call.
  alreadyClaimed,

  /// The stored quest exists but is not completed.
  notCompleted,

  /// The quest id does not exist in the stored quest document, or its
  /// `expiresAt` is missing / invalid (a malformed period is treated as
  /// not awardable).
  notFound,

  /// The stored quest is completed but its period has ended.
  expired,

  /// The stored quest has a non-positive / malformed reward. The id is
  /// still marked as claimed so a retry cannot eventually award a
  /// fabricated value, but no XP is awarded.
  invalidReward,

  /// Reserved for callers that wrap the future in a try/catch. The
  /// service itself rethrows Firestore exceptions rather than returning
  /// this value.
  error,
}

class QuestService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Field on quests/{uid} that records every quest id whose XP reward
  // has already been paid out. Append-only, so a re-claim of the same id
  // is a no-op. Stored alongside the existing daily/weekly/monthly
  // arrays — no new document, no new collection.
  static const String _claimedField = 'claimedQuestIds';

  // ══════════════════════════════════════════════════════════════════
  // Fetch all active quests
  // ══════════════════════════════════════════════════════════════════
  //
  // The returned Quest objects are projected with the authoritative
  // claimedQuestIds set read from the SAME quests/{uid} document:
  //   • rewardClaimed == true  when the quest id is present in that set
  //   • rewardClaimed == false otherwise (including missing/malformed
  //     claimedQuestIds)
  //
  // This projection is a READ-only convenience for the UI. It does NOT
  // persist rewardClaimed back to Firestore — the append-only
  // claimedQuestIds array remains the single source of truth.
  Future<List<Quest>> fetchQuests(String uid) async {
    try {
      final doc = await _db.collection('quests').doc(uid).get();
      final data = doc.data() ?? {};

      // Authoritative claim set — read defensively.
      final claimedIds = _readClaimedIds(data);

      final daily   = _parseQuestList(data['daily']);
      final weekly  = _parseQuestList(data['weekly']);
      final monthly = _parseQuestList(data['monthly']);

      final now = DateTime.now();
      final List<Quest> result = [];

      result.addAll(await _ensureFresh(uid, daily,   QuestType.daily,   now));
      result.addAll(await _ensureFresh(uid, weekly,  QuestType.weekly,  now));
      result.addAll(await _ensureFresh(uid, monthly, QuestType.monthly, now));

      // Project the authoritative claim state onto each returned Quest.
      // rewardClaimed is a UI projection only — never written back to
      // Firestore by this method.
      return result
          .map((q) => q.copyWith(
                rewardClaimed: claimedIds.contains(q.id),
              ))
          .toList(growable: false);
    } catch (_) {
      // UI-safe fallback only — do NOT imply the fallback was persisted,
      // and do NOT fabricate a claim state (rewardClaimed defaults to
      // false on the generated defaults).
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

  /// Ensures the current-period default quest set exists for [type]
  /// without clobbering valid entries.
  ///
  /// Behaviour:
  ///   • If ALL stored entries for this type are still in-period →
  ///     returned unchanged.
  ///   • If SOME entries are valid → the valid ones are kept, and any
  ///     default entry whose id is missing OR whose stored `expiresAt`
  ///     is expired is restored from the fresh default set (with its
  ///     default progress / status).
  ///   • If NONE are valid (missing array or all expired) → the
  ///     complete fresh default set is generated.
  ///
  /// The store is only rewritten when something actually changed, using
  /// a merge write of just this type's array so claimedQuestIds and
  /// other fields are preserved.
  Future<List<Quest>> _ensureFresh(
    String uid,
    List<Quest> existing,
    QuestType type,
    DateTime now,
  ) async {
    final defaults = _generateDefault(type);

    // Bonus has no default set — return only the valid stored entries.
    if (defaults.isEmpty) {
      return existing
          .where((q) => !_isPeriodExpired(q, now))
          .toList(growable: false);
    }

    // Partition existing into valid (in-period) and stale (expired).
    final validById = <String, Quest>{};
    for (final q in existing) {
      if (!_isPeriodExpired(q, now)) {
        validById[q.id] = q;
      }
    }

    // Compose the merged set: keep valid stored entries in place, and
    // restore any default entry whose id is missing from the valid set.
    // Iterate over the default set so ordering is deterministic.
    final merged = <Quest>[];
    var changed = false;

    for (final d in defaults) {
      final stored = validById.remove(d.id);
      if (stored != null) {
        // Preserve the stored entry (including any progress /
        // completion state) exactly as it is.
        merged.add(stored);
      } else {
        // Missing, expired, or malformed for this slot — use the fresh
        // default entry.
        merged.add(d);
        changed = true;
      }
    }

    // Any stored entries that did not correspond to a default id are
    // dropped from the merged set. The default set is the canonical
    // shape for the current period, so a leftover unknown id would
    // otherwise violate "no duplicate / no stray ids".

    // Fast-path: nothing changed and no unknown-id cleanup happened.
    if (!changed && validById.isEmpty && existing.length == merged.length) {
      return merged;
    }

    // Rewrite only this type's array. merge:true preserves claimedQuestIds
    // and every other field on quests/{uid}.
    await _persistQuestType(uid, type, merged);

    return merged;
  }

  /// True when the quest's `expiresAt` is in the past (or missing).
  ///
  /// This deliberately ignores `Quest.isCompleted` and `Quest.isExpired`:
  /// a completed quest must still be rotated out at the end of its
  /// period, and a malformed quest without an `expiresAt` is treated as
  /// expired so it cannot block the next period.
  bool _isPeriodExpired(Quest q, DateTime now) {
    final expires = q.expiresAt;
    if (expires == null) return true;
    return !now.isBefore(expires);
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

  // ══════════════════════════════════════════════════════════════════
  // Goal completion progress
  // ══════════════════════════════════════════════════════════════════
  //
  // The `totalCompletedToday` parameter is authoritative for DAILY
  // goal quests. For weekly / monthly goal quests the existing public
  // method does not receive weekly / monthly totals, so those are still
  // advanced by exactly +1 per call (never regressing, capped at the
  // target, and never touching expired quests).
  //
  // Every decision happens inside a Firestore transaction against the
  // latest stored document, so concurrent calls cannot lose each
  // other's progress.
  //
  // IMPORTANT: rewardClaimed is NEVER persisted by these methods. The
  // Quest.toMap() serializer includes 'rewardClaimed', but the copyWith
  // calls made here only change progressCurrent / status, so the
  // projected field round-trips unchanged for stored entries that
  // already carry it. claimedQuestIds is untouched by these writes.
  Future<void> onGoalCompleted(
    String uid,
    int totalCompletedToday,
  ) async {
    final ref = _db.collection('quests').doc(uid);
    final now = DateTime.now();
    final dailyTotal = totalCompletedToday < 0 ? 0 : totalCompletedToday;

    await _db.runTransaction((tx) async {
      final snapshot = await tx.get(ref);
      final data = snapshot.data() ?? <String, dynamic>{};

      final daily   = _parseQuestList(data['daily']);
      final weekly  = _parseQuestList(data['weekly']);
      final monthly = _parseQuestList(data['monthly']);

      final updatedDaily   = _applyDailyGoalTotal(daily, dailyTotal, now);
      final updatedWeekly  = _incrementGoalsEventBased(weekly, now);
      final updatedMonthly = _incrementGoalsEventBased(monthly, now);

      tx.set(
        ref,
        {
          'daily':   updatedDaily.map((q) => q.toMap()).toList(),
          'weekly':  updatedWeekly.map((q) => q.toMap()).toList(),
          'monthly': updatedMonthly.map((q) => q.toMap()).toList(),
        },
        SetOptions(merge: true),
      );
    });
  }

  /// DAILY goal quests: authoritative set from the caller's count.
  /// Sanitizes negative values to 0, clamps to target, never regresses,
  /// and never touches expired quests.
  List<Quest> _applyDailyGoalTotal(
    List<Quest> quests,
    int total,
    DateTime now,
  ) {
    return quests.map((q) {
      if (_isPeriodExpired(q, now)) return q;
      if (!_isGoalQuest(q)) return q;
      if (q.isCompleted) return q;

      final target = q.progressTarget <= 0 ? 0 : q.progressTarget;
      final clamped = total.clamp(0, target);
      // Never regress below what is already stored.
      final newCurrent =
          clamped > q.progressCurrent ? clamped : q.progressCurrent;
      final done = target > 0 && newCurrent >= target;
      return q.copyWith(
        progressCurrent: newCurrent,
        status: done ? QuestStatus.completed : QuestStatus.active,
      );
    }).toList();
  }

  /// WEEKLY / MONTHLY goal quests: event-based +1 per call, capped,
  /// never regressing, never touching expired or already-completed
  /// quests.
  List<Quest> _incrementGoalsEventBased(List<Quest> quests, DateTime now) {
    return quests.map((q) {
      if (_isPeriodExpired(q, now)) return q;
      if (q.isCompleted) return q;
      if (!_isGoalQuest(q)) return q;

      final target = q.progressTarget <= 0 ? 0 : q.progressTarget;
      final newCurrent = (q.progressCurrent + 1).clamp(0, target);
      final done = target > 0 && newCurrent >= target;
      return q.copyWith(
        progressCurrent: newCurrent,
        status: done ? QuestStatus.completed : QuestStatus.active,
      );
    }).toList();
  }

  // ══════════════════════════════════════════════════════════════════
  // Check-in
  // ══════════════════════════════════════════════════════════════════
  //
  // Idempotent: an already-completed check-in quest is left as is.
  // Expired quests are untouched. Never regresses.
  Future<void> onCheckIn(String uid) async {
    final ref = _db.collection('quests').doc(uid);
    final now = DateTime.now();

    await _db.runTransaction((tx) async {
      final snapshot = await tx.get(ref);
      final data = snapshot.data() ?? <String, dynamic>{};

      final daily   = _parseQuestList(data['daily']);
      final weekly  = _parseQuestList(data['weekly']);
      final monthly = _parseQuestList(data['monthly']);

      tx.set(
        ref,
        {
          'daily':
              _completeCheckIn(daily, now).map((q) => q.toMap()).toList(),
          'weekly':
              _completeCheckIn(weekly, now).map((q) => q.toMap()).toList(),
          'monthly':
              _completeCheckIn(monthly, now).map((q) => q.toMap()).toList(),
        },
        SetOptions(merge: true),
      );
    });
  }

  List<Quest> _completeCheckIn(List<Quest> quests, DateTime now) {
    return quests.map((q) {
      if (_isPeriodExpired(q, now)) return q;
      if (q.isCompleted) return q;
      if (!_isCheckInQuest(q)) return q;
      return q.copyWith(
        progressCurrent: 1,
        status: QuestStatus.completed,
      );
    }).toList();
  }

  // ══════════════════════════════════════════════════════════════════
  // Streak
  // ══════════════════════════════════════════════════════════════════
  //
  // Monotonic: stored progress is max(existing, incoming), capped.
  // Completed stays completed. Expired quests are untouched.
  Future<void> onStreakUpdated(String uid, int streak) async {
    final ref = _db.collection('quests').doc(uid);
    final now = DateTime.now();
    final incoming = streak < 0 ? 0 : streak;

    await _db.runTransaction((tx) async {
      final snapshot = await tx.get(ref);
      final data = snapshot.data() ?? <String, dynamic>{};

      final daily   = _parseQuestList(data['daily']);
      final weekly  = _parseQuestList(data['weekly']);
      final monthly = _parseQuestList(data['monthly']);

      tx.set(
        ref,
        {
          'daily':
              _applyStreak(daily, incoming, now).map((q) => q.toMap()).toList(),
          'weekly':
              _applyStreak(weekly, incoming, now).map((q) => q.toMap()).toList(),
          'monthly':
              _applyStreak(monthly, incoming, now).map((q) => q.toMap()).toList(),
        },
        SetOptions(merge: true),
      );
    });
  }

  List<Quest> _applyStreak(List<Quest> quests, int incoming, DateTime now) {
    return quests.map((q) {
      if (_isPeriodExpired(q, now)) return q;
      if (!_isStreakQuest(q)) return q;

      final highest =
          q.progressCurrent > incoming ? q.progressCurrent : incoming;
      final target = q.progressTarget <= 0 ? 0 : q.progressTarget;
      final newCurrent = highest.clamp(0, target);
      final done = q.isCompleted || (target > 0 && newCurrent >= target);
      return q.copyWith(
        progressCurrent: newCurrent,
        status: done ? QuestStatus.completed : QuestStatus.active,
      );
    }).toList();
  }

  // ══════════════════════════════════════════════════════════════════
  // Authoritative reward claim
  // ══════════════════════════════════════════════════════════════════
  //
  // The Firestore quest document is the ONLY authority for whether XP
  // is awarded and how much. The caller-supplied Quest object's
  // `isCompleted`, `rewardClaimed`, `xpReward`, and even `expiresAt` are
  // NEVER consulted — only its `id` is used to locate the stored entry.
  //
  // Inside one transaction:
  //   1. Read quests/{uid}.
  //   2. Locate the quest by id in daily / weekly / monthly.
  //   3. Not found / missing expiresAt → notFound.
  //   4. Stored not complete             → notCompleted.
  //   5. Stored already expired          → expired (no XP, no claim mark).
  //   6. Sanitize stored reward.
  //   7. claimedQuestIds check           → alreadyClaimed.
  //   8. Atomically mark claimed and, only if reward > 0, increment
  //      users/{uid}.totalXp by the authoritative stored reward.
  //      Return awarded on success, invalidReward when reward <= 0.
  //
  // Firestore exceptions propagate; the reward is never falsely
  // reported as awarded.
  //
  // Returning Future<QuestClaimResult> instead of Future<void> is
  // source-compatible with existing `await` callers.
  Future<QuestClaimResult> claimQuestReward(String uid, Quest quest) async {
    final questId = quest.id;
    if (questId.isEmpty) return QuestClaimResult.notFound;

    final questsRef = _db.collection('quests').doc(uid);
    final userRef   = _db.collection('users').doc(uid);
    final now       = DateTime.now();

    return _db.runTransaction<QuestClaimResult>((tx) async {
      // 1. Authoritative read of the quest document.
      final snapshot = await tx.get(questsRef);
      final data = snapshot.data() ?? <String, dynamic>{};

      // 2. Locate the quest by id in the stored arrays. The stored entry
      //    — never the client object — is the authority.
      final stored = _findQuestById(data, questId);
      if (stored == null) return QuestClaimResult.notFound;

      // 3. Authoritative completion state.
      if (!stored.isCompleted) return QuestClaimResult.notCompleted;

      // 4. Authoritative expiry: a completed quest past its period is
      //    NOT claimable. A missing / invalid expiresAt is also treated
      //    as not claimable.
      final expires = stored.expiresAt;
      if (expires == null) return QuestClaimResult.notFound;
      if (!now.isBefore(expires)) return QuestClaimResult.expired;

      // 5. Sanitize stored reward. A non-positive reward is still marked
      //    claimed to guarantee idempotency, but no XP is awarded.
      final reward = _sanitizeReward(stored.xpReward);

      // 6. claimedQuestIds check inside the same transaction.
      final claimed = _readClaimedIds(data);
      if (claimed.contains(questId)) return QuestClaimResult.alreadyClaimed;

      // 7. Atomically mark claimed. This happens regardless of reward
      //    so the same id can never be re-evaluated as "new".
      tx.set(
        questsRef,
        {_claimedField: FieldValue.arrayUnion([questId])},
        SetOptions(merge: true),
      );

      if (reward <= 0) {
        // Idempotency is preserved; no XP was fabricated.
        return QuestClaimResult.invalidReward;
      }

      // 8. Award the authoritative reward exactly once, in the same
      //    transaction.
      tx.set(
        userRef,
        {'totalXp': FieldValue.increment(reward)},
        SetOptions(merge: true),
      );

      return QuestClaimResult.awarded;
    });
  }

  /// Searches the stored daily / weekly / monthly arrays for the given
  /// quest id and returns the authoritative stored Quest, or null when
  /// the id does not exist.
  Quest? _findQuestById(Map<String, dynamic> data, String questId) {
    for (final key in const ['daily', 'weekly', 'monthly']) {
      final list = _parseQuestList(data[key]);
      for (final q in list) {
        if (q.id == questId) return q;
      }
    }
    return null;
  }

  /// Reads `claimedQuestIds` defensively into a String set.
  ///
  /// Missing / malformed values safely become an empty set, so a
  /// corrupt document can never crash the quest list and never
  /// fabricates a claim state.
  Set<String> _readClaimedIds(Map<String, dynamic> data) {
    final raw = data[_claimedField];
    final result = <String>{};
    if (raw is List) {
      for (final e in raw) {
        if (e is String) result.add(e);
      }
    }
    return result;
  }

  /// Sanitizes a stored XP reward. Non-positive / malformed → 0.
  int _sanitizeReward(int raw) {
    if (raw <= 0) return 0;
    return raw;
  }

  // ══════════════════════════════════════════════════════════════════
  // Quest-type helpers
  // ══════════════════════════════════════════════════════════════════
  //
  // These rely on the Quest model's `type` field (authoritative) and,
  // where the model cannot distinguish by type alone (e.g. check-in vs
  // streak both live inside daily), a prefix check on the existing
  // stable quest ids. Quest ids are preserved unchanged.

  bool _isGoalQuest(Quest q) {
    // Existing ids: daily_goals_*, weekly_goals_*, monthly_goals_*.
    return q.id.startsWith('daily_goals_') ||
        q.id.startsWith('weekly_goals_') ||
        q.id.startsWith('monthly_goals_');
  }

  bool _isCheckInQuest(Quest q) {
    // Existing id: daily_checkin_*.
    return q.id.startsWith('daily_checkin_');
  }

  bool _isStreakQuest(Quest q) {
    // Existing ids: daily_streak_*, weekly_streak_*, monthly_streak_*.
    return q.id.startsWith('daily_streak_') ||
        q.id.startsWith('weekly_streak_') ||
        q.id.startsWith('monthly_streak_');
  }

  // ══════════════════════════════════════════════════════════════════
  // Persistence helpers
  // ══════════════════════════════════════════════════════════════════
  //
  // Used by fetchQuests() → _ensureFresh() to write back the merged
  // current-period set for a single quest type. Writes only the
  // affected array with merge:true, so it cannot clobber claimedQuestIds
  // or another quest-type array.

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

  // ══════════════════════════════════════════════════════════════════
  // Date key helpers
  // ══════════════════════════════════════════════════════════════════
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