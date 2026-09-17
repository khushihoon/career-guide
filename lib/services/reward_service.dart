
// ══════════════════════════════════════════════════════════════════════
// lib/services/reward_service.dart
//
// Daily reward box, streak shield, surprise rewards, and daily check-in.
//
// Firestore is the authoritative source of truth for every persistent
// reward. SharedPreferences is only a local cache.
//
//   • Daily box claim and daily check-in are idempotent via a single
//     Firestore transaction that atomically checks eligibility, marks
//     the reward claimed, and awards XP. Repeated or concurrent calls
//     cannot double-award XP.
//   • Streak shield consumption is atomic — concurrent calls can never
//     drive the shield count below zero.
//   • Surprise reward uses dart:math Random() for ~15% probability per
//     goal-completion event. A per-day guard on rewards/{uid} ensures at
//     most ONE surprise reward per local day, so a duplicate event
//     cannot produce a second reward. This is intentionally a DAILY cap
//     (not per-event deduplication), which keeps the change small and
//     backward-compatible without requiring event IDs from callers.
//
// All existing public methods, parameter types, return types, reward
// amounts, messages, and RewardResult remain compatible.
// ══════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum RewardType { xp, streakShield, xpMultiplier, badge }

class RewardResult {
  final RewardType type;
  final int xpAmount;
  final String message;
  final String emoji;
  final bool isBonus;

  const RewardResult({
    required this.type,
    required this.xpAmount,
    required this.message,
    required this.emoji,
    this.isBonus = false,
  });
}

class RewardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final math.Random _random = math.Random();

  // Field names on rewards/{uid}. Only small, additive, backward-
  // compatible fields are used. The two legacy fields (dailyBoxClaimed,
  // streakShieldCount) are preserved so existing stored documents keep
  // working without migration.
  //
  //   dailyBoxClaimed   — legacy boolean flag, kept for backward compat.
  //   dailyBoxClaimedOn — authoritative local-date key of the last box.
  //   lastCheckInOn     — authoritative local-date key of the last check-in.
  //   streakShieldCount — integer shield count.
  //   surpriseRollDate  — local-date key of the last awarded surprise.
  //                       At most one surprise reward per local day.
  static const String _dailyBoxField      = 'dailyBoxClaimed';
  static const String _dailyBoxDateKey    = 'dailyBoxClaimedOn';
  static const String _checkInDateKey     = 'lastCheckInOn';
  static const String _shieldsField       = 'streakShieldCount';
  static const String _surpriseDateKey    = 'surpriseRollDate';

  // ── Daily reward box ───────────────────────────────────────────────

  Future<bool> canClaimDailyBox(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final localKey = 'daily_box_${_todayKey()}';
    if (prefs.getBool(localKey) ?? false) return false;

    try {
      final doc = await _db.collection('rewards').doc(uid).get();
      final data = doc.data() ?? <String, dynamic>{};
      final claimedOn = data[_dailyBoxDateKey];
      if (claimedOn is String && claimedOn == _todayKey()) {
        await prefs.setBool(localKey, true);
        return false;
      }
      return true;
    } catch (_) {
      // Local cache opinion is the fallback for UI rendering.
      return true;
    }
  }

  /// Claims today's daily reward box.
  ///
  /// Runs a single Firestore transaction that re-checks the authoritative
  /// date field, then atomically marks the box claimed and increments
  /// totalXp. The legacy `dailyBoxClaimed` boolean is kept in sync as
  /// `true` for backward compatibility with any older code that reads
  /// it. SharedPreferences is synchronized only after the transaction
  /// succeeds.
  Future<RewardResult> claimDailyBox(String uid, int currentStreak) async {
    final today = _todayKey();
    final prefs = await SharedPreferences.getInstance();
    final localKey = 'daily_box_$today';

    if (prefs.getBool(localKey) ?? false) {
      return const RewardResult(
        type: RewardType.xp,
        xpAmount: 0,
        message: 'Already claimed today!',
        emoji: '📦',
      );
    }

    // Reward scaling is unchanged from the previous version.
    final int xp;
    final String msg;
    final String emoji;
    final bool isBonus;
    if (currentStreak >= 30) {
      xp = 100;
      msg = 'Legendary streak bonus!';
      emoji = '👑';
      isBonus = true;
    } else if (currentStreak >= 7) {
      xp = 60;
      msg = 'Week streak reward!';
      emoji = '🔥';
      isBonus = true;
    } else if (currentStreak >= 3) {
      xp = 35;
      msg = 'Streak bonus XP!';
      emoji = '⚡';
      isBonus = false;
    } else {
      xp = 20;
      msg = 'Daily reward claimed!';
      emoji = '🎁';
      isBonus = false;
    }

    final rewardsRef = _db.collection('rewards').doc(uid);
    final userRef    = _db.collection('users').doc(uid);

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
            // Legacy boolean flag for backward compatibility.
            _dailyBoxField: true,
            // Authoritative local-date key.
            _dailyBoxDateKey: today,
          },
          SetOptions(merge: true),
        );

        if (xp > 0) {
          tx.set(
            userRef,
            {'totalXp': FieldValue.increment(xp)},
            SetOptions(merge: true),
          );
        }
      });
    } catch (_) {
      // Do NOT touch local cache on failure — the reward stays claimable.
      rethrow;
    }

    if (alreadyClaimed) {
      await prefs.setBool(localKey, true);
      return const RewardResult(
        type: RewardType.xp,
        xpAmount: 0,
        message: 'Already claimed today!',
        emoji: '📦',
      );
    }

    await prefs.setBool(localKey, true);

    return RewardResult(
      type: RewardType.xp,
      xpAmount: xp,
      message: msg,
      emoji: emoji,
      isBonus: isBonus,
    );
  }

  // ── Streak shield ──────────────────────────────────────────────────

  Future<int> getStreakShieldCount(String uid) async {
    try {
      final doc = await _db.collection('rewards').doc(uid).get();
      if (!doc.exists) return 0;
      final raw = doc.data()?[_shieldsField];
      if (raw is int) return raw < 0 ? 0 : raw;
      if (raw is num) {
        final v = raw.toInt();
        return v < 0 ? 0 : v;
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }

  /// Atomically consumes one streak shield.
  Future<bool> useStreakShield(String uid) async {
    final rewardsRef = _db.collection('rewards').doc(uid);
    bool consumed = false;

    try {
      await _db.runTransaction((tx) async {
        final snapshot = await tx.get(rewardsRef);
        final data = snapshot.data() ?? <String, dynamic>{};
        final raw = data[_shieldsField];

        int count = 0;
        if (raw is int) {
          count = raw;
        } else if (raw is num) {
          count = raw.toInt();
        }

        if (count <= 0) {
          consumed = false;
          return;
        }

        tx.set(
          rewardsRef,
          {_shieldsField: FieldValue.increment(-1)},
          SetOptions(merge: true),
        );
        consumed = true;
      });
    } catch (_) {
      return false;
    }

    return consumed;
  }

  // ── Daily check-in ─────────────────────────────────────────────────

  Future<bool> canCheckIn(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final localKey = 'checkin_${_todayKey()}';
    if (prefs.getBool(localKey) ?? false) return false;

    try {
      final doc = await _db.collection('rewards').doc(uid).get();
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

  /// Performs today's check-in exactly once.
  Future<int> performCheckIn(String uid) async {
    const xp = 10;
    final today = _todayKey();
    final prefs = await SharedPreferences.getInstance();
    final localKey = 'checkin_$today';

    if (prefs.getBool(localKey) ?? false) return 0;

    final rewardsRef = _db.collection('rewards').doc(uid);
    final userRef    = _db.collection('users').doc(uid);

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

        tx.set(
          rewardsRef,
          {_checkInDateKey: today},
          SetOptions(merge: true),
        );

        tx.set(
          userRef,
          {
            'totalXp': FieldValue.increment(xp),
            'lastActiveAt': DateTime.now().millisecondsSinceEpoch,
          },
          SetOptions(merge: true),
        );
      });
    } catch (_) {
      rethrow;
    }

    if (alreadyCheckedIn) {
      await prefs.setBool(localKey, true);
      return 0;
    }

    await prefs.setBool(localKey, true);
    return xp;
  }

  // ── Surprise reward ────────────────────────────────────────────────

  /// Rolls a surprise reward after a goal-completion event.
  ///
  /// Behaviour:
  ///   • ~15% probability per call, using dart:math Random().
  ///   • If the roll triggers AND no surprise has already been awarded
  ///     on the current local day, awards 50 XP and records
  ///     `surpriseRollDate` on rewards/{uid}.
  ///   • If a surprise has already been awarded today, the call is a
  ///     no-op and returns null. This is a DAILY CAP, not per-event
  ///     deduplication: at most one surprise reward can be granted per
  ///     local day. Further legitimate goal-completion events later in
  ///     the same day will not roll again. On the next local day the
  ///     guard resets naturally via the date key.
  ///
  /// This keeps the public signature unchanged and avoids adding an
  /// event-ID parameter that would require caller changes.
  Future<RewardResult?> rollSurpriseReward(String uid) async {
    // ~15% probability per event.
    final roll = _random.nextInt(100);
    if (roll >= 15) return null;

    final today = _todayKey();
    final rewardsRef = _db.collection('rewards').doc(uid);
    final userRef    = _db.collection('users').doc(uid);

    // Daily cap: at most one surprise reward per local day, enforced
    // authoritatively in Firestore.
    bool alreadyRolledToday = false;
    try {
      await _db.runTransaction((tx) async {
        final snapshot = await tx.get(rewardsRef);
        final data = snapshot.data() ?? <String, dynamic>{};
        final lastRoll = data[_surpriseDateKey];

        if (lastRoll is String && lastRoll == today) {
          alreadyRolledToday = true;
          return;
        }

        tx.set(
          rewardsRef,
          {_surpriseDateKey: today},
          SetOptions(merge: true),
        );

        tx.set(
          userRef,
          {'totalXp': FieldValue.increment(50)},
          SetOptions(merge: true),
        );
      });
    } catch (_) {
      // Fail closed — no reward on transaction failure.
      return null;
    }

    if (alreadyRolledToday) return null;

    const surprises = [
      RewardResult(
        type: RewardType.xp,
        xpAmount: 50,
        message: 'Mystery bonus XP!',
        emoji: '🎲',
        isBonus: true,
      ),
      RewardResult(
        type: RewardType.xp,
        xpAmount: 50,
        message: 'Lucky learner bonus!',
        emoji: '🍀',
        isBonus: true,
      ),
      RewardResult(
        type: RewardType.xp,
        xpAmount: 50,
        message: 'AI approved your hustle!',
        emoji: '🤖',
        isBonus: true,
      ),
    ];

    final idx = _random.nextInt(surprises.length);
    return surprises[idx];
  }

  // ── Helpers ────────────────────────────────────────────────────────

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}_${now.month}_${now.day}';
  }
}
