// ══════════════════════════════════════════════════════════════════════
// lib/services/reward_service.dart
// NEW — Daily reward box, streak shield, surprise rewards, check-in
// ══════════════════════════════════════════════════════════════════════

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

  // ── Daily reward box ───────────────────────────────────────────────
  Future<bool> canClaimDailyBox(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'daily_box_${_todayKey()}';
    return !(prefs.getBool(key) ?? false);
  }

  Future<RewardResult> claimDailyBox(String uid, int currentStreak) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'daily_box_${_todayKey()}';

    if (prefs.getBool(key) ?? false) {
      return const RewardResult(
        type: RewardType.xp,
        xpAmount: 0,
        message: 'Already claimed today!',
        emoji: '📦',
      );
    }

    // Streak-scaled XP reward
    int xp;
    String msg;
    String emoji;
    bool isBonus = false;

    if (currentStreak >= 30) {
      xp = 100; msg = 'Legendary streak bonus!'; emoji = '👑'; isBonus = true;
    } else if (currentStreak >= 7) {
      xp = 60;  msg = 'Week streak reward!';     emoji = '🔥'; isBonus = true;
    } else if (currentStreak >= 3) {
      xp = 35;  msg = 'Streak bonus XP!';        emoji = '⚡';
    } else {
      xp = 20;  msg = 'Daily reward claimed!';   emoji = '🎁';
    }

    // Persist
    await prefs.setBool(key, true);
    await _db.collection('users').doc(uid).update({
      'totalXp': FieldValue.increment(xp),
    });
    await _db.collection('rewards').doc(uid).set({
      'dailyBoxClaimed': DateTime.now().millisecondsSinceEpoch,
    }, SetOptions(merge: true));

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
      return (doc.data()?['streakShieldCount'] as int?) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// Uses one shield to protect streak from breaking
  Future<bool> useStreakShield(String uid) async {
    final count = await getStreakShieldCount(uid);
    if (count <= 0) return false;
    await _db.collection('rewards').doc(uid).update({
      'streakShieldCount': FieldValue.increment(-1),
    });
    return true;
  }

  // ── Daily check-in ─────────────────────────────────────────────────
  Future<bool> canCheckIn(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'checkin_${_todayKey()}';
    return !(prefs.getBool(key) ?? false);
  }

  Future<int> performCheckIn(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'checkin_${_todayKey()}';
    if (prefs.getBool(key) ?? false) return 0;

    const xp = 10;
    await prefs.setBool(key, true);
    await _db.collection('users').doc(uid).update({
      'totalXp': FieldValue.increment(xp),
      'lastActiveAt': DateTime.now().millisecondsSinceEpoch,
    });
    return xp;
  }

  // ── Surprise reward (random, low probability) ─────────────────────
  Future<RewardResult?> rollSurpriseReward(String uid) async {
    // 15% chance on each goal completion
    final roll = DateTime.now().millisecondsSinceEpoch % 100;
    if (roll > 15) return null;

    const xp = 50;
    await _db.collection('users').doc(uid).update({
      'totalXp': FieldValue.increment(xp),
    });

    final surprises = [
      const RewardResult(type: RewardType.xp, xpAmount: 50,
          message: 'Mystery bonus XP!', emoji: '🎲', isBonus: true),
      const RewardResult(type: RewardType.xp, xpAmount: 50,
          message: 'Lucky learner bonus!', emoji: '🍀', isBonus: true),
      const RewardResult(type: RewardType.xp, xpAmount: 50,
          message: 'AI approved your hustle!', emoji: '🤖', isBonus: true),
    ];

    final idx = DateTime.now().second % surprises.length;
    return surprises[idx];
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}_${now.month}_${now.day}';
  }
}