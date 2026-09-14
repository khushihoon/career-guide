// ══════════════════════════════════════════════════════════════════════
// lib/services/achievement_service.dart
// NEW — Achievement Engine: checks conditions, unlocks badges, awards XP
// Compatible with existing CopilotController / CopilotProvider
// ══════════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/achievement_models.dart';
import '../models/copilot_models.dart';   // existing models

class AchievementService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Fetch user's unlocked + in-progress achievements ───────────────
  Future<List<Achievement>> fetchUserAchievements(String uid) async {
    try {
      final doc = await _db.collection('achievements').doc(uid).get();
      if (!doc.exists) return _allWithProgress({}, {});

      final data = doc.data()!;
      final unlockedRaw =
          List<Map<String, dynamic>>.from(data['unlocked'] as List? ?? []);
      final inProgressRaw =
          List<Map<String, dynamic>>.from(data['inProgress'] as List? ?? []);

      final unlockedMap = {
        for (final e in unlockedRaw)
          e['id'] as String: DateTime.fromMillisecondsSinceEpoch(
              e['unlockedAt'] as int)
      };
      final progressMap = {
        for (final e in inProgressRaw)
          e['id'] as String: e['progressCurrent'] as int
      };

      return _allWithProgress(unlockedMap, progressMap);
    } catch (_) {
      return AchievementCatalog.all;
    }
  }

  List<Achievement> _allWithProgress(
    Map<String, DateTime> unlockedMap,
    Map<String, int> progressMap,
  ) {
    return AchievementCatalog.all.map((a) {
      final unlockedAt = unlockedMap[a.id];
      final current    = progressMap[a.id] ?? 0;
      return Achievement(
        id: a.id,
        title: a.title,
        description: a.description,
        icon: a.icon,
        rarity: a.rarity,
        xpBonus: a.xpBonus,
        unlockedAt: unlockedAt,
        progressTarget: a.progressTarget,
        progressCurrent: unlockedAt != null ? a.progressTarget : current,
        progress: unlockedAt != null
            ? 1.0
            : (current / a.progressTarget).clamp(0.0, 1.0),
      );
    }).toList();
  }

  // ── Check all conditions after a state change ──────────────────────
  /// Returns list of newly unlocked achievements (for toast notifications)
  Future<List<Achievement>> checkAndUnlock({
    required String uid,
    required CopilotState state,
    required int totalGoalsCompleted,
    required int currentLevel,
  }) async {
    final existing = await fetchUserAchievements(uid);
    final alreadyUnlocked = existing
        .where((a) => a.isUnlocked)
        .map((a) => a.id)
        .toSet();

    final toUnlock = <Achievement>[];
    final progressUpdates = <Map<String, dynamic>>[];

    for (final achievement in AchievementCatalog.all) {
      if (alreadyUnlocked.contains(achievement.id)) continue;

      int current = 0;
      bool shouldUnlock = false;

      switch (achievement.id) {
        case 'first_goal':
          current = totalGoalsCompleted >= 1 ? 1 : 0;
          shouldUnlock = totalGoalsCompleted >= 1;
          break;
        case 'profile_complete':
          current = state.hasProfile ? 1 : 0;
          shouldUnlock = state.hasProfile;
          break;
        case 'three_day_streak':
          current = state.currentStreak.clamp(0, 3);
          shouldUnlock = state.currentStreak >= 3;
          break;
        case 'goals_5':
          current = totalGoalsCompleted.clamp(0, 5);
          shouldUnlock = totalGoalsCompleted >= 5;
          break;
        case 'week_streak':
          current = state.currentStreak.clamp(0, 7);
          shouldUnlock = state.currentStreak >= 7;
          break;
        case 'goals_25':
          current = totalGoalsCompleted.clamp(0, 25);
          shouldUnlock = totalGoalsCompleted >= 25;
          break;
        case 'level_5':
          current = currentLevel.clamp(0, 5);
          shouldUnlock = currentLevel >= 5;
          break;
        case 'roadmap_started':
          current = state.roadmap != null ? 1 : 0;
          shouldUnlock = state.roadmap != null;
          break;
        case 'month_streak':
          current = state.currentStreak.clamp(0, 30);
          shouldUnlock = state.currentStreak >= 30;
          break;
        case 'level_10':
          current = currentLevel.clamp(0, 10);
          shouldUnlock = currentLevel >= 10;
          break;
        case 'goals_100':
          current = totalGoalsCompleted.clamp(0, 100);
          shouldUnlock = totalGoalsCompleted >= 100;
          break;
        case 'hundred_day_streak':
          current = state.currentStreak.clamp(0, 100);
          shouldUnlock = state.currentStreak >= 100;
          break;
        case 'level_20':
          current = currentLevel.clamp(0, 20);
          shouldUnlock = currentLevel >= 20;
          break;
      }

      progressUpdates.add({
        'id': achievement.id,
        'progressCurrent': current,
      });

      if (shouldUnlock) {
        toUnlock.add(achievement);
      }
    }

    if (toUnlock.isNotEmpty) {
      await _persistUnlocks(uid, toUnlock, progressUpdates);
    } else if (progressUpdates.isNotEmpty) {
      await _persistProgress(uid, progressUpdates);
    }

    return toUnlock;
  }

  Future<void> _persistUnlocks(
    String uid,
    List<Achievement> toUnlock,
    List<Map<String, dynamic>> progressUpdates,
  ) async {
    final batch = _db.batch();
    final ref = _db.collection('achievements').doc(uid);

    final now = DateTime.now().millisecondsSinceEpoch;
    final newEntries = toUnlock
        .map((a) => {'id': a.id, 'unlockedAt': now})
        .toList();

    batch.set(
      ref,
      {
        'unlocked': FieldValue.arrayUnion(newEntries),
        'inProgress': progressUpdates,
      },
      SetOptions(merge: true),
    );

    // Also add bonus XP to user profile
    final totalBonus = toUnlock.fold(0, (s, a) => s + a.xpBonus);
    if (totalBonus > 0) {
      batch.update(
        _db.collection('users').doc(uid),
        {'totalXp': FieldValue.increment(totalBonus)},
      );
    }

    await batch.commit();
  }

  Future<void> _persistProgress(
    String uid,
    List<Map<String, dynamic>> progressUpdates,
  ) async {
    await _db
        .collection('achievements')
        .doc(uid)
        .set({'inProgress': progressUpdates}, SetOptions(merge: true));
  }
}