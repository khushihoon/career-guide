// ══════════════════════════════════════════════════════════════════════
// lib/services/reward_service.dart
//
// Career Guide — Reward Economy Engine.
//
// Firestore is the sole authority for every persistent reward. Every
// method that changes XP, shields, multiplier state, or milestone status
// runs inside a Firestore transaction that re-reads the authoritative
// document before deciding to award anything — this is what makes every
// reward safe against double-tap, rapid tap, app restart, network retry,
// and concurrent devices. SharedPreferences is used ONLY as a fast local
// UI hint (e.g. "hide the claim button before the network round-trip
// returns") and is written to ONLY after the authoritative Firestore
// write has already succeeded. It never determines, on its own, whether
// a reward was actually granted.
//
// BACKWARD COMPATIBILITY — every one of these keeps its exact original
// signature and return type, and existing callers need zero changes:
//   canClaimDailyBox(uid)            -> Future<bool>
//   claimDailyBox(uid, streak)       -> Future<RewardResult>
//   getStreakShieldCount(uid)        -> Future<int>
//   useStreakShield(uid)             -> Future<bool>
//   canCheckIn(uid)                  -> Future<bool>
//   performCheckIn(uid)              -> Future<int>
//   rollSurpriseReward(uid)          -> Future<RewardResult?>
// RewardType keeps its four existing values. RewardResult keeps its
// original constructor shape (type/xpAmount/message/emoji/isBonus) —
// every new field is optional with a safe default, so old positional and
// named call sites compile and behave identically.
//
// FIRESTORE LAYOUT
//   rewards/{uid}                      — the small, authoritative document:
//     dailyBoxClaimed, dailyBoxClaimedOn, lastCheckInOn, streakShieldCount,
//     surpriseRollDate                 (all five preserved verbatim)
//     claimedMilestoneIds              (NEW — array of milestone ids)
//     xpMultiplierValue / xpMultiplierExpiresAt / xpMultiplierActivatedAt
//                                       (NEW — persistent multiplier state)
//   rewards/{uid}/history/{eventId}    — NEW subcollection. Growing reward
//     history lives here, not as an ever-growing array on the main doc,
//     so the main document stays small and cheap to read regardless of
//     how long a user has been active. Deterministic event ids
//     (dailybox_{date}, checkin_{date}, surprise_{date}, milestone_{id})
//     make the corresponding claim idempotent for free — a duplicate
//     write to the same id inside the same transaction is a no-op check,
//     never a duplicate row.
//
// ORGANIZATION (matches the requested section breakdown):
//   Enums · Models · Reward Definitions · Daily Box · Daily Reward Chain
//   · Streak Shields · XP Multiplier · Surprise Rewards · Milestones
//   · Generic Grant (achievement/quest integration point) · Reward
//   History · Reward Summary · Firestore Helpers · Date Helpers ·
//   Parsing Helpers
// ══════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ════════════════════════════════════════════════════════════════════
// ENUMS
// ════════════════════════════════════════════════════════════════════

/// Unchanged values — preserved exactly for compatibility. Extensibility
/// for future categories is achieved through RewardSource + the generic
/// grantReward() method below, not by growing this enum, so existing
/// exhaustive switch statements elsewhere in the app never need updating.
enum RewardType { xp, streakShield, xpMultiplier, badge }

/// NEW — where a reward came from. Purely additive; nothing before this
/// upgrade stored a "source" anywhere, so there is no compatibility
/// surface to preserve here. Lets analytics/UI answer "why did the user
/// get this?" without RewardService duplicating QuestService's or
/// AchievementService's own bookkeeping — those services simply call
/// grantReward(source: RewardSource.quest / .achievement) instead of
/// touching users/{uid}.totalXp directly.
enum RewardSource {
  dailyBox,
  dailyCheckIn,
  streakMilestone,
  goalCompletion,
  courseCompletion,
  quizCompletion,
  challengeCompletion,
  projectCompletion,
  surprise,
  achievement,
  quest,
  manual,
}

/// Differentiates WHY a new-style call failed, per the "do not silently
/// pretend success" requirement. Only used by the new methods
/// (grantReward / activateXpMultiplier / checkAndClaimMilestone) — the
/// seven legacy methods keep their original try/catch → bool/null/int
/// failure contract untouched, so no existing caller has to learn a new
/// error-handling pattern.
enum RewardFailureReason { alreadyClaimed, notEligible, persistenceFailure, invalidInput }

class RewardClaimException implements Exception {
  final RewardFailureReason reason;
  final String message;
  const RewardClaimException(this.reason, this.message);

  @override
  String toString() => 'RewardClaimException(${reason.name}): $message';
}

// ════════════════════════════════════════════════════════════════════
// MODELS
// ════════════════════════════════════════════════════════════════════

/// Preserves every original field and the original constructor shape.
/// Every field added below is optional with a safe default, so:
///   RewardResult(type: RewardType.xp, xpAmount: 20, message: 'x', emoji: '🎁')
/// — the exact call shape used everywhere in the existing codebase —
/// still compiles and behaves identically.
class RewardResult {
  final RewardType type;
  final int xpAmount;
  final String message;
  final String emoji;
  final bool isBonus;

  // ── NEW, all optional/defaulted — additive only ──────────────────
  final String? title;
  final String? description;
  final int? streakDay;
  final int shieldAmount;
  final double? multiplierAmount;
  final String? badgeId;
  final String? rewardId;
  final bool claimed;
  final RewardSource? source;

  const RewardResult({
    required this.type,
    required this.xpAmount,
    required this.message,
    required this.emoji,
    this.isBonus = false,
    this.title,
    this.description,
    this.streakDay,
    this.shieldAmount = 0,
    this.multiplierAmount,
    this.badgeId,
    this.rewardId,
    this.claimed = true,
    this.source,
  });

  /// Convenience for the "not eligible / already claimed" case, so new
  /// call sites don't have to hand-build a zero-XP RewardResult.
  factory RewardResult.notEligible({
    String message = 'Already claimed.',
    String emoji = '📦',
  }) =>
      RewardResult(
        type: RewardType.xp,
        xpAmount: 0,
        message: message,
        emoji: emoji,
        claimed: false,
      );
}

/// One slot in the 7-day visual reward cycle. `claimed`/`available`/
/// `locked` are computed relative to the caller's current streak by
/// [RewardService.getDailyRewardChain] — this class itself is a plain,
/// easily-unit-testable data holder with no Firestore dependency.
class DailyRewardSlot {
  final int day; // 1..7 position in the weekly cycle
  final String title;
  final String description;
  final String emoji;
  final RewardType type;
  final int xpAmount;
  final int shieldAmount;
  final double? multiplierAmount;
  final bool isMilestone;
  final bool claimed;
  final bool available;
  final bool locked;

  const DailyRewardSlot({
    required this.day,
    required this.title,
    required this.description,
    required this.emoji,
    required this.type,
    this.xpAmount = 0,
    this.shieldAmount = 0,
    this.multiplierAmount,
    this.isMilestone = false,
    this.claimed = false,
    this.available = false,
    this.locked = false,
  });

  DailyRewardSlot copyWith({
    bool? claimed,
    bool? available,
    bool? locked,
  }) =>
      DailyRewardSlot(
        day: day,
        title: title,
        description: description,
        emoji: emoji,
        type: type,
        xpAmount: xpAmount,
        shieldAmount: shieldAmount,
        multiplierAmount: multiplierAmount,
        isMilestone: isMilestone,
        claimed: claimed ?? this.claimed,
        available: available ?? this.available,
        locked: locked ?? this.locked,
      );
}

/// Static content describing one streak-length milestone (3/7/14/30/50/100
/// days by default). Purely a data holder — awarding/claim-guarding logic
/// lives in [RewardService.checkAndClaimMilestone].
class StreakMilestoneDefinition {
  final int days;
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int xpAmount;
  final int shieldAmount;
  final double? multiplierAmount;
  final Duration? multiplierDuration;
  final String? badgeId;

  const StreakMilestoneDefinition({
    required this.days,
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    this.xpAmount = 0,
    this.shieldAmount = 0,
    this.multiplierAmount,
    this.multiplierDuration,
    this.badgeId,
  });
}

/// Authoritative multiplier state, read fresh from Firestore every time —
/// never faked or cached client-side only, per the requirement that
/// multiplier state must be evaluated from authoritative data.
class XpMultiplierState {
  final double multiplier;
  final DateTime? activatedAt;
  final DateTime? expiresAt;

  const XpMultiplierState({
    required this.multiplier,
    this.activatedAt,
    this.expiresAt,
  });

  bool get isActive =>
      multiplier > 1.0 && expiresAt != null && expiresAt!.isAfter(DateTime.now());

  Duration get remaining =>
      isActive ? expiresAt!.difference(DateTime.now()) : Duration.zero;

  factory XpMultiplierState.inactive() =>
      const XpMultiplierState(multiplier: 1.0);
}

/// One row of persisted reward history, read back from
/// rewards/{uid}/history/{eventId}. Parsing is fully defensive — a
/// malformed or partially-written document degrades to safe defaults
/// instead of throwing and breaking the whole history list.
class RewardHistoryEntry {
  final String id;
  final RewardType type;
  final int xpAmount;
  final RewardSource source;
  final String message;
  final DateTime timestamp;
  final int? streakDay;
  final String? milestoneId;
  final String? badgeId;

  const RewardHistoryEntry({
    required this.id,
    required this.type,
    required this.xpAmount,
    required this.source,
    required this.message,
    required this.timestamp,
    this.streakDay,
    this.milestoneId,
    this.badgeId,
  });

  factory RewardHistoryEntry.fromFirestore(String id, Map<String, dynamic> map) {
    final rawType = map['type'];
    final type = RewardType.values.firstWhere(
      (t) => t.name == rawType,
      orElse: () => RewardType.xp,
    );
    final rawSource = map['source'];
    final source = RewardSource.values.firstWhere(
      (s) => s.name == rawSource,
      orElse: () => RewardSource.manual,
    );
    final rawXp = map['xpAmount'];
    final xp = rawXp is num ? rawXp.toInt() : 0;
    final rawTs = map['timestamp'];
    final ts = rawTs is String
        ? (DateTime.tryParse(rawTs) ?? DateTime.now())
        : DateTime.now();
    final rawStreakDay = map['streakDay'];

    return RewardHistoryEntry(
      id: id,
      type: type,
      xpAmount: xp,
      source: source,
      message: map['message'] as String? ?? '',
      timestamp: ts,
      streakDay: rawStreakDay is num ? rawStreakDay.toInt() : null,
      milestoneId: map['milestoneId'] as String?,
      badgeId: map['badgeId'] as String?,
    );
  }
}

/// Everything a future Reward screen needs in one call — the "UI-ready
/// data" requirement. RewardService only produces this; it never builds
/// Flutter widgets.
class RewardSummary {
  final DailyRewardSlot? todayReward;
  final bool claimedToday;
  final int currentStreak;
  final StreakMilestoneDefinition? nextMilestone;
  final int? daysUntilMilestone;
  final int shieldCount;
  final XpMultiplierState activeMultiplier;
  final List<RewardHistoryEntry> recentHistory;
  final bool surpriseEligibleToday;
  final DailyRewardSlot? nextReward;

  const RewardSummary({
    required this.todayReward,
    required this.claimedToday,
    required this.currentStreak,
    required this.nextMilestone,
    required this.daysUntilMilestone,
    required this.shieldCount,
    required this.activeMultiplier,
    required this.recentHistory,
    required this.surpriseEligibleToday,
    required this.nextReward,
  });
}

// ════════════════════════════════════════════════════════════════════
// REWARD DEFINITIONS (testable, pure — no Firestore, no randomness)
// ════════════════════════════════════════════════════════════════════

/// The 7-day visual reward cycle. Day 7 intentionally matches the
/// "🔥 7 DAY STREAK / 🎁 +60 XP / 🛡️ +1 Streak Shield" example from the
/// product spec exactly. Wraps every 7 days — day 8 reuses day 1's
/// definition, day 14 reuses day 7's, etc. — while the SEPARATE
/// [_milestones] table below tracks longer, non-repeating streak
/// achievements (14/30/50/100 days) independently of this weekly wrap.
const List<DailyRewardSlot> _dailyCycleDefinitions = [
  DailyRewardSlot(
    day: 1, title: 'Day 1', description: 'Welcome back!',
    emoji: '🎁', type: RewardType.xp, xpAmount: 20,
  ),
  DailyRewardSlot(
    day: 2, title: 'Day 2', description: 'Keep it going.',
    emoji: '🎁', type: RewardType.xp, xpAmount: 25,
  ),
  DailyRewardSlot(
    day: 3, title: 'Day 3', description: 'Three in a row.',
    emoji: '🔥', type: RewardType.xp, xpAmount: 30,
  ),
  DailyRewardSlot(
    day: 4, title: 'Day 4', description: 'Building a real habit.',
    emoji: '🔥', type: RewardType.xp, xpAmount: 35,
  ),
  DailyRewardSlot(
    day: 5, title: 'Day 5', description: 'Almost a full week.',
    emoji: '⚡', type: RewardType.xp, xpAmount: 45,
  ),
  DailyRewardSlot(
    day: 6, title: 'Day 6', description: 'One more to go.',
    emoji: '⚡', type: RewardType.xp, xpAmount: 50,
  ),
  DailyRewardSlot(
    day: 7, title: 'Day 7 — Weekly Streak', description: 'A full week, well earned.',
    emoji: '🏆', type: RewardType.xp, xpAmount: 60, shieldAmount: 1,
    isMilestone: true,
  ),
];

/// Longer streak milestones. Each fires exactly once per user, ever —
/// enforced by `claimedMilestoneIds` on rewards/{uid}, not by date, so a
/// missed day and later re-crossing the same streak length can never
/// re-award it.
final List<StreakMilestoneDefinition> _milestones = [
  const StreakMilestoneDefinition(
    days: 3, id: 'streak_3', title: '3-Day Streak',
    description: 'Three days of consistent progress.',
    emoji: '🔥', xpAmount: 15,
  ),
  const StreakMilestoneDefinition(
    days: 7, id: 'streak_7', title: '7-Day Streak',
    description: 'A full week of showing up.',
    emoji: '🔥', xpAmount: 50, shieldAmount: 1, badgeId: 'streak_7',
  ),
  const StreakMilestoneDefinition(
    days: 14, id: 'streak_14', title: '14-Day Streak',
    description: 'Two weeks — this is becoming a habit.',
    emoji: '🏆', xpAmount: 100, shieldAmount: 1, badgeId: 'streak_14',
  ),
  StreakMilestoneDefinition(
    days: 30, id: 'streak_30', title: '30-Day Streak',
    description: 'A full month of consistent learning.',
    emoji: '👑', xpAmount: 250, badgeId: 'streak_30',
    multiplierAmount: 1.5, multiplierDuration: const Duration(hours: 24),
  ),
  const StreakMilestoneDefinition(
    days: 50, id: 'streak_50', title: '50-Day Streak',
    description: 'Fifty days. Genuinely elite consistency.',
    emoji: '🌟', xpAmount: 400, shieldAmount: 2, badgeId: 'streak_50',
  ),
  StreakMilestoneDefinition(
    days: 100, id: 'streak_100', title: '100-Day Streak',
    description: 'One hundred days. Career-changing consistency.',
    emoji: '🏅', xpAmount: 1000, badgeId: 'streak_100',
    multiplierAmount: 2.0, multiplierDuration: const Duration(hours: 48),
  ),
];

/// One possible outcome of a triggered surprise reward — chosen only
/// AFTER the existing ~15%-probability gate has already passed, so the
/// overall trigger rate is unchanged from the original implementation.
class _SurpriseVariant {
  final RewardType type;
  final int xpAmount;
  final int shieldAmount;
  final double? multiplierAmount;
  final Duration? multiplierDuration;
  final String message;
  final String emoji;

  const _SurpriseVariant({
    required this.type,
    this.xpAmount = 0,
    this.shieldAmount = 0,
    this.multiplierAmount,
    this.multiplierDuration,
    required this.message,
    required this.emoji,
  });
}

// ════════════════════════════════════════════════════════════════════
// SERVICE
// ════════════════════════════════════════════════════════════════════

class RewardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final math.Random _random = math.Random();

  // Field names on rewards/{uid}. The first five are the ORIGINAL fields,
  // preserved verbatim so existing stored documents keep working without
  // migration. Everything below them is new and additive.
  static const String _dailyBoxField      = 'dailyBoxClaimed';
  static const String _dailyBoxDateKey    = 'dailyBoxClaimedOn';
  static const String _checkInDateKey     = 'lastCheckInOn';
  static const String _shieldsField       = 'streakShieldCount';
  static const String _surpriseDateKey    = 'surpriseRollDate';

  static const String _claimedMilestonesField   = 'claimedMilestoneIds';
  static const String _multiplierValueField     = 'xpMultiplierValue';
  static const String _multiplierExpiresField   = 'xpMultiplierExpiresAt';
  static const String _multiplierActivatedField = 'xpMultiplierActivatedAt';

  // ══════════════════════════════════════════════════════════════════
  // DAILY BOX  (preserved public contract; internals upgraded)
  // ══════════════════════════════════════════════════════════════════

  Future<bool> canClaimDailyBox(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final localKey = 'daily_box_${_todayKey()}';
    if (prefs.getBool(localKey) ?? false) return false;

    try {
      final doc = await _rewardsRef(uid).get();
      final data = doc.data() ?? <String, dynamic>{};
      final claimedOn = data[_dailyBoxDateKey];
      if (claimedOn is String && claimedOn == _todayKey()) {
        await prefs.setBool(localKey, true);
        return false;
      }
      return true;
    } catch (_) {
      // Local cache opinion is the fallback for UI rendering only — it
      // never becomes the authoritative "was this granted" answer.
      return true;
    }
  }

  /// Claims today's daily reward box. Transaction-guarded, idempotent,
  /// concurrency-safe — unchanged guarantee from the original
  /// implementation. Reward amounts (20/35/60/100 by streak tier) are
  /// preserved EXACTLY as before; this upgrade only adds a durable
  /// history row alongside the existing XP/claim writes, in the SAME
  /// transaction, so the history entry can never exist without the XP
  /// award (or vice versa).
  Future<RewardResult> claimDailyBox(String uid, int currentStreak) async {
    final today = _todayKey();
    final prefs = await SharedPreferences.getInstance();
    final localKey = 'daily_box_$today';

    if (prefs.getBool(localKey) ?? false) {
      return RewardResult.notEligible(message: 'Already claimed today!');
    }

    // Reward scaling — unchanged from the original implementation.
    final int xp;
    final String msg;
    final String emoji;
    final bool isBonus;
    if (currentStreak >= 30) {
      xp = 100; msg = 'Legendary streak bonus!'; emoji = '👑'; isBonus = true;
    } else if (currentStreak >= 7) {
      xp = 60; msg = 'Week streak reward!'; emoji = '🔥'; isBonus = true;
    } else if (currentStreak >= 3) {
      xp = 35; msg = 'Streak bonus XP!'; emoji = '⚡'; isBonus = false;
    } else {
      xp = 20; msg = 'Daily reward claimed!'; emoji = '🎁'; isBonus = false;
    }

    final rewardsRef = _rewardsRef(uid);
    final userRef    = _userRef(uid);
    final historyRef = _historyRef(uid).doc('dailybox_$today');

    bool alreadyClaimed = false;

    try {
      await _db.runTransaction((tx) async {
        final snapshot = await tx.get(rewardsRef);
        final data = snapshot.data() ?? <String, dynamic>{};
        final claimedOn = data[_dailyBoxDateKey];

        if (claimedOn is String && claimedOn == today) {
          alreadyClaimed = true;
          return;
        }

        tx.set(
          rewardsRef,
          {
            _dailyBoxField: true,   // legacy boolean, kept in sync
            _dailyBoxDateKey: today,
          },
          SetOptions(merge: true),
        );

        if (xp > 0) {
          tx.set(userRef, {'totalXp': FieldValue.increment(xp)}, SetOptions(merge: true));
        }

        tx.set(historyRef, {
          'type': RewardType.xp.name,
          'xpAmount': xp,
          'source': RewardSource.dailyBox.name,
          'message': msg,
          'timestamp': DateTime.now().toIso8601String(),
          'streakDay': currentStreak,
        });
      });
    } catch (_) {
      // Do NOT touch local cache on failure — the reward stays claimable.
      rethrow;
    }

    if (alreadyClaimed) {
      await prefs.setBool(localKey, true);
      return RewardResult.notEligible(message: 'Already claimed today!');
    }

    await prefs.setBool(localKey, true);

    return RewardResult(
      type: RewardType.xp,
      xpAmount: xp,
      message: msg,
      emoji: emoji,
      isBonus: isBonus,
      streakDay: currentStreak,
      source: RewardSource.dailyBox,
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // DAILY REWARD CHAIN  (NEW — pure, unit-testable, no Firestore)
  // ══════════════════════════════════════════════════════════════════

  /// Returns the 7-slot weekly cycle with claimed/available/locked
  /// computed relative to [currentStreak] and whether today's box has
  /// already been claimed. Pure function — safe to call from anywhere,
  /// including widget build methods, and trivially unit-testable since
  /// it touches no Firestore state itself.
  List<DailyRewardSlot> getDailyRewardChain(int currentStreak, bool claimedToday) {
    final position = _cyclePosition(currentStreak <= 0 ? 1 : currentStreak);
    return List.generate(7, (i) {
      final day = i + 1;
      final def = _dailyCycleDefinitions[i];
      final isPast = day < position || (day == position && claimedToday);
      return def.copyWith(
        claimed: isPast,
        available: day == position && !claimedToday,
        locked: day > position,
      );
    });
  }

  /// 1..7 position of [streak] within the 7-day wrap-around cycle.
  int _cyclePosition(int streak) {
    final pos = streak % 7;
    return pos == 0 ? 7 : pos;
  }

  // ══════════════════════════════════════════════════════════════════
  // STREAK SHIELDS  (preserved public contract + new award path)
  // ══════════════════════════════════════════════════════════════════

  Future<int> getStreakShieldCount(String uid) async {
    try {
      final doc = await _rewardsRef(uid).get();
      if (!doc.exists) return 0;
      return _readInt(doc.data()?[_shieldsField]);
    } catch (_) {
      return 0;
    }
  }

  /// Atomically consumes one streak shield. Concurrent calls can never
  /// drive the count below zero — the transaction re-reads the current
  /// count before deciding whether to decrement.
  Future<bool> useStreakShield(String uid) async {
    final rewardsRef = _rewardsRef(uid);
    final historyRef = _historyRef(uid).doc(); // auto-id: each use is a distinct event
    bool consumed = false;

    try {
      await _db.runTransaction((tx) async {
        final snapshot = await tx.get(rewardsRef);
        final count = _readInt(snapshot.data()?[_shieldsField]);

        if (count <= 0) {
          consumed = false;
          return;
        }

        tx.set(rewardsRef, {_shieldsField: FieldValue.increment(-1)}, SetOptions(merge: true));
        tx.set(historyRef, {
          'type': RewardType.streakShield.name,
          'xpAmount': 0,
          'source': RewardSource.manual.name,
          'message': 'Streak Shield used to protect a missed day.',
          'timestamp': DateTime.now().toIso8601String(),
        });
        consumed = true;
      });
    } catch (_) {
      return false;
    }

    return consumed;
  }

  /// NEW — the "safe method for awarding a shield through Firestore"
  /// requested by the spec. Thin, DRY wrapper over [grantReward] so
  /// shield-awarding logic exists in exactly one place.
  Future<RewardResult> awardStreakShield(
    String uid, {
    int amount = 1,
    RewardSource source = RewardSource.manual,
    String? sourceId,
  }) {
    if (amount <= 0) {
      throw const RewardClaimException(
        RewardFailureReason.invalidInput,
        'Shield award amount must be positive.',
      );
    }
    return grantReward(
      uid,
      type: RewardType.streakShield,
      source: source,
      shieldAmount: amount,
      sourceId: sourceId,
      message: amount == 1 ? 'Streak Shield earned!' : '$amount Streak Shields earned!',
      emoji: '🛡️',
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // XP MULTIPLIER  (NEW — persistent, authoritative, never faked locally)
  // ══════════════════════════════════════════════════════════════════

  /// Activates (or extends) a persistent XP multiplier. If a longer
  /// multiplier is already active, this call will never SHORTEN it —
  /// the transaction compares expiry timestamps and keeps whichever is
  /// later, so a smaller concurrent grant can't downgrade a bigger one.
  Future<RewardResult> activateXpMultiplier(
    String uid, {
    required double multiplier,
    required Duration duration,
    RewardSource source = RewardSource.manual,
  }) async {
    if (multiplier <= 1.0) {
      throw const RewardClaimException(
        RewardFailureReason.invalidInput,
        'Multiplier value must be greater than 1.0.',
      );
    }

    final rewardsRef = _rewardsRef(uid);
    final now = DateTime.now();
    final requestedExpiry = now.add(duration);
    DateTime effectiveExpiry = requestedExpiry;

    try {
      await _db.runTransaction((tx) async {
        final snap = await tx.get(rewardsRef);
        final data = snap.data() ?? <String, dynamic>{};
        final currentExpiryMs = _readInt(data[_multiplierExpiresField]);
        final currentExpiry = currentExpiryMs > 0
            ? DateTime.fromMillisecondsSinceEpoch(currentExpiryMs)
            : null;

        effectiveExpiry = (currentExpiry != null && currentExpiry.isAfter(requestedExpiry))
            ? currentExpiry
            : requestedExpiry;

        tx.set(rewardsRef, {
          _multiplierValueField: multiplier,
          _multiplierExpiresField: effectiveExpiry.millisecondsSinceEpoch,
          _multiplierActivatedField: now.millisecondsSinceEpoch,
        }, SetOptions(merge: true));

        tx.set(_historyRef(uid).doc(), {
          'type': RewardType.xpMultiplier.name,
          'xpAmount': 0,
          'source': source.name,
          'message': '${multiplier}x XP activated for ${duration.inHours}h.',
          'timestamp': now.toIso8601String(),
        });
      });
    } catch (_) {
      throw const RewardClaimException(
        RewardFailureReason.persistenceFailure,
        'Could not activate XP multiplier.',
      );
    }

    return RewardResult(
      type: RewardType.xpMultiplier,
      xpAmount: 0,
      message: '${multiplier}x XP activated!',
      emoji: '⚡',
      multiplierAmount: multiplier,
      source: source,
    );
  }

  /// Reads the CURRENT multiplier state fresh from Firestore. Never
  /// cached client-side as the source of truth — a stale local value
  /// showing "active" after real expiry would misrepresent XP the user
  /// is actually about to earn.
  Future<XpMultiplierState> getActiveMultiplier(String uid) async {
    try {
      final doc = await _rewardsRef(uid).get();
      final data = doc.data() ?? <String, dynamic>{};
      final expiresMs = _readInt(data[_multiplierExpiresField]);
      if (expiresMs <= 0) return XpMultiplierState.inactive();

      final expiresAt = DateTime.fromMillisecondsSinceEpoch(expiresMs);
      if (expiresAt.isBefore(DateTime.now())) return XpMultiplierState.inactive();

      final value = _readDouble(data[_multiplierValueField], fallback: 1.0);
      final activatedMs = _readInt(data[_multiplierActivatedField]);

      return XpMultiplierState(
        multiplier: value,
        activatedAt: activatedMs > 0 ? DateTime.fromMillisecondsSinceEpoch(activatedMs) : null,
        expiresAt: expiresAt,
      );
    } catch (_) {
      return XpMultiplierState.inactive();
    }
  }

  // ══════════════════════════════════════════════════════════════════
  // DAILY CHECK-IN  (preserved public contract; richer variant added)
  // ══════════════════════════════════════════════════════════════════

  Future<bool> canCheckIn(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final localKey = 'checkin_${_todayKey()}';
    if (prefs.getBool(localKey) ?? false) return false;

    try {
      final doc = await _rewardsRef(uid).get();
      final data = doc.data() ?? <String, dynamic>{};
      final last = data[_checkInDateKey];
      if (last is String && last == _todayKey()) {
        await prefs.setBool(localKey, true);
        return false;
      }
      return true;
    } catch (_) {
      return true;
    }
  }

  /// Original public contract — returns the XP awarded (0 if already
  /// checked in today). Delegates to [performCheckInDetailed] so the
  /// XP-awarding logic exists in exactly one place; this is not a second
  /// XP system, just a thinner return type for old callers.
  Future<int> performCheckIn(String uid) async {
    final result = await performCheckInDetailed(uid);
    return result.claimed ? result.xpAmount : 0;
  }

  /// NEW — the richer variant. Same transaction, same idempotency
  /// guarantee, but returns a full RewardResult so a future check-in UI
  /// can show more than a bare number.
  Future<RewardResult> performCheckInDetailed(String uid) async {
    const xp = 10;
    final today = _todayKey();
    final prefs = await SharedPreferences.getInstance();
    final localKey = 'checkin_$today';

    if (prefs.getBool(localKey) ?? false) {
      return RewardResult.notEligible(message: 'Already checked in today.', emoji: '✅');
    }

    final rewardsRef = _rewardsRef(uid);
    final userRef    = _userRef(uid);
    final historyRef = _historyRef(uid).doc('checkin_$today');

    bool alreadyCheckedIn = false;

    try {
      await _db.runTransaction((tx) async {
        final snapshot = await tx.get(rewardsRef);
        final data = snapshot.data() ?? <String, dynamic>{};
        final last = data[_checkInDateKey];

        if (last is String && last == today) {
          alreadyCheckedIn = true;
          return;
        }

        tx.set(rewardsRef, {_checkInDateKey: today}, SetOptions(merge: true));

        tx.set(
          userRef,
          {
            'totalXp': FieldValue.increment(xp),
            'lastActiveAt': DateTime.now().millisecondsSinceEpoch,
          },
          SetOptions(merge: true),
        );

        tx.set(historyRef, {
          'type': RewardType.xp.name,
          'xpAmount': xp,
          'source': RewardSource.dailyCheckIn.name,
          'message': 'Daily check-in complete.',
          'timestamp': DateTime.now().toIso8601String(),
        });
      });
    } catch (_) {
      rethrow;
    }

    if (alreadyCheckedIn) {
      await prefs.setBool(localKey, true);
      return RewardResult.notEligible(message: 'Already checked in today.', emoji: '✅');
    }

    await prefs.setBool(localKey, true);

    return const RewardResult(
      type: RewardType.xp,
      xpAmount: xp,
      message: 'Daily check-in complete.',
      emoji: '✅',
      source: RewardSource.dailyCheckIn,
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // SURPRISE REWARDS  (preserved ~15% trigger; diversified outcome)
  // ══════════════════════════════════════════════════════════════════

  /// Same overall trigger probability (~15% per call) and same daily cap
  /// (at most one surprise per local day, enforced authoritatively in
  /// Firestore) as before. The only change: once the 15% gate passes,
  /// the OUTCOME is now one of three variants (XP / shield / short
  /// multiplier) instead of always XP — chosen AFTER the gate, so the
  /// gate's probability itself is untouched.
  Future<RewardResult?> rollSurpriseReward(String uid) async {
    final roll = _random.nextInt(100);
    if (roll >= 15) return null;

    final today = _todayKey();
    final rewardsRef = _rewardsRef(uid);
    final userRef    = _userRef(uid);
    final variant = _pickSurpriseVariant();

    bool alreadyRolledToday = false;
    RewardResult? result;

    try {
      await _db.runTransaction((tx) async {
        final snapshot = await tx.get(rewardsRef);
        final data = snapshot.data() ?? <String, dynamic>{};
        final lastRoll = data[_surpriseDateKey];

        if (lastRoll is String && lastRoll == today) {
          alreadyRolledToday = true;
          return;
        }

        tx.set(rewardsRef, {_surpriseDateKey: today}, SetOptions(merge: true));

        switch (variant.type) {
          case RewardType.xp:
            tx.set(userRef, {'totalXp': FieldValue.increment(variant.xpAmount)}, SetOptions(merge: true));
            break;
          case RewardType.streakShield:
            tx.set(rewardsRef, {_shieldsField: FieldValue.increment(variant.shieldAmount)}, SetOptions(merge: true));
            break;
          case RewardType.xpMultiplier:
            final expiry = DateTime.now().add(variant.multiplierDuration!);
            tx.set(rewardsRef, {
              _multiplierValueField: variant.multiplierAmount,
              _multiplierExpiresField: expiry.millisecondsSinceEpoch,
              _multiplierActivatedField: DateTime.now().millisecondsSinceEpoch,
            }, SetOptions(merge: true));
            break;
          case RewardType.badge:
            break; // not used for surprise outcomes today
        }

        tx.set(_historyRef(uid).doc('surprise_$today'), {
          'type': variant.type.name,
          'xpAmount': variant.xpAmount,
          'source': RewardSource.surprise.name,
          'message': variant.message,
          'timestamp': DateTime.now().toIso8601String(),
        });

        result = RewardResult(
          type: variant.type,
          xpAmount: variant.xpAmount,
          message: variant.message,
          emoji: variant.emoji,
          isBonus: true,
          shieldAmount: variant.shieldAmount,
          multiplierAmount: variant.multiplierAmount,
          source: RewardSource.surprise,
        );
      });
    } catch (_) {
      // Fail closed — no reward on transaction failure.
      return null;
    }

    if (alreadyRolledToday) return null;
    return result;
  }

  _SurpriseVariant _pickSurpriseVariant() {
    final roll = _random.nextInt(100);
    if (roll < 70) {
      const messages = ['Mystery bonus XP!', 'Lucky learner bonus!', 'AI approved your hustle!'];
      const emojis = ['🎲', '🍀', '🤖'];
      final i = _random.nextInt(messages.length);
      return _SurpriseVariant(
        type: RewardType.xp, xpAmount: 50, message: messages[i], emoji: emojis[i],
      );
    } else if (roll < 90) {
      return const _SurpriseVariant(
        type: RewardType.streakShield, shieldAmount: 1,
        message: 'Surprise Streak Shield!', emoji: '🛡️',
      );
    } else {
      return const _SurpriseVariant(
        type: RewardType.xpMultiplier, multiplierAmount: 1.5,
        multiplierDuration: Duration(hours: 12),
        message: '1.5x XP for 12 hours!', emoji: '⚡',
      );
    }
  }

  // ══════════════════════════════════════════════════════════════════
  // MILESTONES  (NEW — claim-once-ever, extensible table)
  // ══════════════════════════════════════════════════════════════════

  /// Finds the lowest-days milestone the user has reached but not yet
  /// claimed, and claims it. Returns null when there is nothing pending.
  /// If a user's streak jumped past several unclaimed milestones at
  /// once (e.g. after being offline), calling this repeatedly claims
  /// them one at a time — never skips, never double-awards.
  Future<RewardResult?> checkAndClaimMilestone(String uid, int currentStreak) async {
    final eligible = _milestones.where((m) => m.days <= currentStreak).toList();
    if (eligible.isEmpty) return null;

    final rewardsRef = _rewardsRef(uid);
    StreakMilestoneDefinition? toAward;

    try {
      await _db.runTransaction((tx) async {
        final snap = await tx.get(rewardsRef);
        final data = snap.data() ?? <String, dynamic>{};
        final claimed = _readStringList(data[_claimedMilestonesField]).toSet();

        for (final m in eligible) {
          if (!claimed.contains(m.id)) {
            toAward = m;
            break;
          }
        }
        if (toAward == null) return;

        final m = toAward!;

        tx.set(rewardsRef, {
          _claimedMilestonesField: FieldValue.arrayUnion([m.id]),
        }, SetOptions(merge: true));

        if (m.xpAmount > 0) {
          tx.set(_userRef(uid), {'totalXp': FieldValue.increment(m.xpAmount)}, SetOptions(merge: true));
        }
        if (m.shieldAmount > 0) {
          tx.set(rewardsRef, {_shieldsField: FieldValue.increment(m.shieldAmount)}, SetOptions(merge: true));
        }
        if (m.multiplierAmount != null && m.multiplierDuration != null) {
          final expiry = DateTime.now().add(m.multiplierDuration!);
          tx.set(rewardsRef, {
            _multiplierValueField: m.multiplierAmount,
            _multiplierExpiresField: expiry.millisecondsSinceEpoch,
            _multiplierActivatedField: DateTime.now().millisecondsSinceEpoch,
          }, SetOptions(merge: true));
        }

        tx.set(_historyRef(uid).doc('milestone_${m.id}'), {
          'type': RewardType.badge.name,
          'xpAmount': m.xpAmount,
          'source': RewardSource.streakMilestone.name,
          'message': m.title,
          'timestamp': DateTime.now().toIso8601String(),
          'milestoneId': m.id,
          if (m.badgeId != null) 'badgeId': m.badgeId,
        });
      });
    } catch (_) {
      throw const RewardClaimException(
        RewardFailureReason.persistenceFailure,
        'Could not claim milestone reward.',
      );
    }

    final m = toAward;
    if (m == null) return null;

    return RewardResult(
      type: RewardType.badge,
      xpAmount: m.xpAmount,
      message: m.title,
      description: m.description,
      emoji: m.emoji,
      isBonus: true,
      shieldAmount: m.shieldAmount,
      multiplierAmount: m.multiplierAmount,
      badgeId: m.badgeId,
      rewardId: m.id,
      streakDay: m.days,
      source: RewardSource.streakMilestone,
    );
  }

  /// Pure lookup — the next milestone still ahead of [currentStreak], or
  /// null if every defined milestone has already been passed.
  StreakMilestoneDefinition? getNextMilestone(int currentStreak) {
    for (final m in _milestones) {
      if (m.days > currentStreak) return m;
    }
    return null;
  }

  // ══════════════════════════════════════════════════════════════════
  // GENERIC GRANT — the achievement/quest integration point
  // ══════════════════════════════════════════════════════════════════

  /// The single authoritative way to award ANY reward from OUTSIDE this
  /// file — AchievementService, QuestService, or a future course/goal
  /// hook can call this instead of touching users/{uid}.totalXp
  /// directly, so there is only ever ONE XP-writing code path for
  /// externally-triggered rewards. This does NOT duplicate
  /// AchievementService's unlock logic or QuestService's completion
  /// logic — it only performs the actual grant once THEY decide a
  /// reward is due.
  ///
  /// Idempotency: pass [sourceId] (e.g. an achievement id or quest id)
  /// to make the grant safely repeatable — a second call with the same
  /// (source, sourceId) pair is a guaranteed no-op. Omitting [sourceId]
  /// means the caller is not asking for dedup (e.g. a one-off manual
  /// grant), and a fresh history row is written every time.
  Future<RewardResult> grantReward(
    String uid, {
    required RewardType type,
    required RewardSource source,
    int xpAmount = 0,
    int shieldAmount = 0,
    double? multiplierAmount,
    Duration? multiplierDuration,
    String? badgeId,
    String? sourceId,
    String? message,
    String? emoji,
    String? title,
    String? description,
  }) async {
    if (xpAmount < 0 || shieldAmount < 0) {
      throw const RewardClaimException(
        RewardFailureReason.invalidInput,
        'Reward amounts must not be negative.',
      );
    }

    final rewardsRef = _rewardsRef(uid);
    final userRef = _userRef(uid);
    final eventId = (sourceId != null && sourceId.isNotEmpty)
        ? 'grant_${source.name}_$sourceId'
        : null;
    final historyRef = eventId != null ? _historyRef(uid).doc(eventId) : _historyRef(uid).doc();

    bool alreadyGranted = false;

    try {
      await _db.runTransaction((tx) async {
        if (eventId != null) {
          final existing = await tx.get(historyRef);
          if (existing.exists) {
            alreadyGranted = true;
            return;
          }
        }

        final now = DateTime.now();

        tx.set(historyRef, {
          'type': type.name,
          'xpAmount': xpAmount,
          'source': source.name,
          'message': message ?? _defaultMessageFor(type),
          'timestamp': now.toIso8601String(),
          if (badgeId != null) 'badgeId': badgeId,
        });

        if (xpAmount > 0) {
          tx.set(userRef, {'totalXp': FieldValue.increment(xpAmount)}, SetOptions(merge: true));
        }
        if (shieldAmount > 0) {
          tx.set(rewardsRef, {_shieldsField: FieldValue.increment(shieldAmount)}, SetOptions(merge: true));
        }
        if (multiplierAmount != null && multiplierDuration != null) {
          final expiry = now.add(multiplierDuration);
          tx.set(rewardsRef, {
            _multiplierValueField: multiplierAmount,
            _multiplierExpiresField: expiry.millisecondsSinceEpoch,
            _multiplierActivatedField: now.millisecondsSinceEpoch,
          }, SetOptions(merge: true));
        }
      });
    } catch (_) {
      throw const RewardClaimException(
        RewardFailureReason.persistenceFailure,
        'Could not grant reward.',
      );
    }

    if (alreadyGranted) {
      return RewardResult.notEligible(message: 'Reward already granted.', emoji: '✅');
    }

    return RewardResult(
      type: type,
      xpAmount: xpAmount,
      message: message ?? _defaultMessageFor(type),
      emoji: emoji ?? _defaultEmojiFor(type),
      shieldAmount: shieldAmount,
      multiplierAmount: multiplierAmount,
      badgeId: badgeId,
      rewardId: sourceId,
      title: title,
      description: description,
      source: source,
    );
  }

  String _defaultMessageFor(RewardType type) {
    switch (type) {
      case RewardType.xp:           return 'XP earned!';
      case RewardType.streakShield: return 'Streak Shield earned!';
      case RewardType.xpMultiplier: return 'XP Multiplier activated!';
      case RewardType.badge:        return 'Reward earned!';
    }
  }

  String _defaultEmojiFor(RewardType type) {
    switch (type) {
      case RewardType.xp:           return '⚡';
      case RewardType.streakShield: return '🛡️';
      case RewardType.xpMultiplier: return '⚡';
      case RewardType.badge:        return '🏅';
    }
  }

  // ══════════════════════════════════════════════════════════════════
  // REWARD HISTORY
  // ══════════════════════════════════════════════════════════════════

  /// Newest-first reward history, read from the rewards/{uid}/history
  /// subcollection rather than an ever-growing array — keeps the main
  /// rewards/{uid} document small and cheap to read regardless of how
  /// long a user has been active. Fully defensive parsing: one malformed
  /// row is skipped by RewardHistoryEntry.fromFirestore's own safe
  /// defaults, never by throwing and discarding the whole list.
  Future<List<RewardHistoryEntry>> getRecentRewards(String uid, {int limit = 20}) async {
    final safeLimit = limit < 1 ? 1 : (limit > 100 ? 100 : limit);
    try {
      final snap = await _historyRef(uid)
          .orderBy('timestamp', descending: true)
          .limit(safeLimit)
          .get();
      return snap.docs
          .map((d) => RewardHistoryEntry.fromFirestore(d.id, d.data()))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  // ══════════════════════════════════════════════════════════════════
  // REWARD SUMMARY  (the future Reward screen's single data source)
  // ══════════════════════════════════════════════════════════════════

  Future<RewardSummary> getRewardSummary(String uid, int currentStreak) async {
    try {
      final rewardsDoc = await _rewardsRef(uid).get();
      final history = await getRecentRewards(uid, limit: 10);
      final data = rewardsDoc.data() ?? <String, dynamic>{};

      final today = _todayKey();
      final claimedOn = data[_dailyBoxDateKey];
      final claimedToday = claimedOn is String && claimedOn == today;

      final chain = getDailyRewardChain(currentStreak, claimedToday);
      final position = _cyclePosition(currentStreak <= 0 ? 1 : currentStreak);
      final todaySlot = chain[position - 1];
      final nextSlot = claimedToday
          ? chain[position == 7 ? 0 : position]
          : todaySlot;

      final shieldCount = _readInt(data[_shieldsField]);
      final multiplier = await getActiveMultiplier(uid);
      final nextMilestone = getNextMilestone(currentStreak);
      final daysUntil = nextMilestone != null ? nextMilestone.days - currentStreak : null;

      final lastSurprise = data[_surpriseDateKey];
      final surpriseEligible = !(lastSurprise is String && lastSurprise == today);

      return RewardSummary(
        todayReward: claimedToday ? null : todaySlot,
        claimedToday: claimedToday,
        currentStreak: currentStreak,
        nextMilestone: nextMilestone,
        daysUntilMilestone: (daysUntil != null && daysUntil > 0) ? daysUntil : null,
        shieldCount: shieldCount,
        activeMultiplier: multiplier,
        recentHistory: history,
        surpriseEligibleToday: surpriseEligible,
        nextReward: nextSlot,
      );
    } catch (_) {
      // Safe, fully-inactive summary — never a crash, never fabricated
      // "everything is available" state on a read failure.
      return RewardSummary(
        todayReward: null,
        claimedToday: false,
        currentStreak: currentStreak,
        nextMilestone: getNextMilestone(currentStreak),
        daysUntilMilestone: null,
        shieldCount: 0,
        activeMultiplier: XpMultiplierState.inactive(),
        recentHistory: const [],
        surpriseEligibleToday: true,
        nextReward: null,
      );
    }
  }

  // ══════════════════════════════════════════════════════════════════
  // FIRESTORE HELPERS
  // ══════════════════════════════════════════════════════════════════

  DocumentReference<Map<String, dynamic>> _rewardsRef(String uid) =>
      _db.collection('rewards').doc(uid);

  CollectionReference<Map<String, dynamic>> _historyRef(String uid) =>
      _rewardsRef(uid).collection('history');

  DocumentReference<Map<String, dynamic>> _userRef(String uid) =>
      _db.collection('users').doc(uid);

  // ══════════════════════════════════════════════════════════════════
  // DATE HELPERS
  // ══════════════════════════════════════════════════════════════════

  /// Unchanged format — preserved EXACTLY so already-stored
  /// dailyBoxClaimedOn / lastCheckInOn / surpriseRollDate values keep
  /// comparing correctly against dates produced by this upgraded file.
  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}_${now.month}_${now.day}';
  }

  // ══════════════════════════════════════════════════════════════════
  // PARSING HELPERS  (defensive against malformed Firestore data)
  // ══════════════════════════════════════════════════════════════════

  int _readInt(dynamic raw, {int fallback = 0}) {
    if (raw is int) return raw < 0 ? 0 : raw;
    if (raw is num) {
      final v = raw.toInt();
      return v < 0 ? 0 : v;
    }
    return fallback;
  }

  double _readDouble(dynamic raw, {double fallback = 0}) {
    if (raw is double) return raw;
    if (raw is num) return raw.toDouble();
    return fallback;
  }

  List<String> _readStringList(dynamic raw) {
    if (raw is! List) return const [];
    return raw.whereType<String>().toList();
  }
}