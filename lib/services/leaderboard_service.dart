// ══════════════════════════════════════════════════════════════════════
// lib/services/leaderboard_service.dart
// NEW — Global leaderboard, friends leaderboard, weekly rankings
// ══════════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quest_models.dart';   // LeaderboardEntry is here

class LeaderboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Sync current user's XP to leaderboard ─────────────────────────
  Future<void> syncUserToLeaderboard({
    required String uid,
    required String displayName,
    String? photoUrl,
    required int totalXp,
    required int level,
    required int weeklyXp,
  }) async {
    final entry = {
      'displayName': displayName,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'totalXp': totalXp,
      'level': level,
      'weeklyXp': weeklyXp,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };

    // Global all-time
    await _db
        .collection('leaderboard')
        .doc('global')
        .collection('entries')
        .doc(uid)
        .set(entry, SetOptions(merge: true));

    // Weekly (resets every Monday — keyed by ISO week)
    final weekId = _currentWeekId();
    await _db
        .collection('leaderboard')
        .doc('weekly_$weekId')
        .collection('entries')
        .doc(uid)
        .set({...entry, 'xp': weeklyXp}, SetOptions(merge: true));
  }

  // ── Fetch global top 100 ───────────────────────────────────────────
  Future<List<LeaderboardEntry>> fetchGlobalTop(
      {int limit = 50, String? currentUid}) async {
    try {
      final snap = await _db
          .collection('leaderboard')
          .doc('global')
          .collection('entries')
          .orderBy('totalXp', descending: true)
          .limit(limit)
          .get();

      return _mapEntries(snap.docs, currentUid);
    } catch (_) {
      return [];
    }
  }

  // ── Fetch weekly top ───────────────────────────────────────────────
  Future<List<LeaderboardEntry>> fetchWeeklyTop(
      {int limit = 50, String? currentUid}) async {
    try {
      final weekId = _currentWeekId();
      final snap = await _db
          .collection('leaderboard')
          .doc('weekly_$weekId')
          .collection('entries')
          .orderBy('xp', descending: true)
          .limit(limit)
          .get();

      return _mapEntries(snap.docs, currentUid);
    } catch (_) {
      return [];
    }
  }

  // ── Fetch friends leaderboard ─────────────────────────────────────
  Future<List<LeaderboardEntry>> fetchFriendsLeaderboard({
    required String uid,
    required List<String> friendUids,
  }) async {
    if (friendUids.isEmpty) return [];
    try {
      final allUids = [uid, ...friendUids];
      // Firestore 'whereIn' limited to 30 items
      final batch = allUids.take(30).toList();

      final snap = await _db
          .collection('leaderboard')
          .doc('global')
          .collection('entries')
          .where(FieldPath.documentId, whereIn: batch)
          .get();

      final entries = _mapEntries(snap.docs, uid);
      entries.sort((a, b) => b.totalXp.compareTo(a.totalXp));
      return entries;
    } catch (_) {
      return [];
    }
  }

  // ── Current user's rank in global ─────────────────────────────────
  Future<int> getCurrentUserRank(String uid, int userXp) async {
    try {
      final snap = await _db
          .collection('leaderboard')
          .doc('global')
          .collection('entries')
          .where('totalXp', isGreaterThan: userXp)
          .count()
          .get();
      return (snap.count ?? 0) + 1;
    } catch (_) {
      return 0;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────
  List<LeaderboardEntry> _mapEntries(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    String? currentUid,
  ) {
    return docs.asMap().entries.map((e) {
      final rank = e.key + 1;
      final doc  = e.value;
      return LeaderboardEntry(
        uid: doc.id,
        displayName: (doc.data()['displayName'] as String?) ?? 'Learner',
        photoUrl: doc.data()['photoUrl'] as String?,
        totalXp: (doc.data()['totalXp'] as int?) ?? 0,
        level: (doc.data()['level'] as int?) ?? 1,
        rank: rank,
        weeklyXp: (doc.data()['weeklyXp'] as int?) ??
            (doc.data()['xp'] as int?) ?? 0,
        isCurrentUser: doc.id == currentUid,
      );
    }).toList();
  }

  String _currentWeekId() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return '${monday.year}_${monday.month}_${monday.day}';
  }
}