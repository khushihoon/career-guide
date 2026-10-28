// ══════════════════════════════════════════════════════════════════════
// lib/services/leaderboard_service.dart
// Global leaderboard, weekly rankings, and friends leaderboard.
//
// Data access only:
//   • Never awards XP
//   • Never unlocks achievements, completes quests, or touches rewards
//   • Never writes user progress — only mirrors caller-supplied XP into
//     leaderboard documents
//
// Reliability improvements over the previous version:
//   • Weekly period is derived from UTC, so every user worldwide sees the
//     same week ID (previously device-local, which could split a week).
//   • Global + weekly sync is written in a single atomic Firestore batch.
//   • Stale / out-of-order syncs are prevented via a Firestore
//     transaction that refuses to overwrite newer XP with older XP.
//   • Friends leaderboard safely chunks whereIn queries so large friend
//     lists are not silently truncated.
//   • Mapping is defensive against malformed numeric / string fields.
// ══════════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/quest_models.dart'; // LeaderboardEntry is here

class LeaderboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Firestore's maximum length for a `whereIn` list. Used to chunk large
  /// friend lists into safe batches.
  static const int _whereInChunkSize = 30;

  /// Bounds for the `limit` parameter on top-N queries. Prevents invalid
  /// or wasteful queries while preserving normal existing usage.
  static const int _minLimit = 1;
  static const int _maxLimit = 100;

  // ── Sync current user's XP to leaderboard ─────────────────────────
  //
  // Atomic across global + weekly via a Firestore transaction that also
  // refuses to regress a user's XP. If a newer sync already wrote a
  // higher totalXp than this call is trying to write, the write is
  // skipped for that document instead of overwriting newer data with
  // older data.
  Future<void> syncUserToLeaderboard({
    required String uid,
    required String displayName,
    String? photoUrl,
    required int totalXp,
    required int level,
    required int weeklyXp,
  }) async {
    if (uid.isEmpty) return;

    final safeTotalXp = totalXp < 0 ? 0 : totalXp;
    final safeWeeklyXp = weeklyXp < 0 ? 0 : weeklyXp;
    final safeLevel = level < 1 ? 1 : level;

    final globalRef = _db
        .collection('leaderboard')
        .doc('global')
        .collection('entries')
        .doc(uid);

    final weekId = _currentWeekIdUtc();
    final weeklyRef = _db
        .collection('leaderboard')
        .doc('weekly_$weekId')
        .collection('entries')
        .doc(uid);

    final nowMs = DateTime.now().millisecondsSinceEpoch;

    try {
      await _db.runTransaction((tx) async {
        // Read both current entries so we can compare against the newest
        // XP already persisted.
        final globalSnap = await tx.get(globalRef);
        final weeklySnap = await tx.get(weeklyRef);

        final currentGlobalXp = _readInt(globalSnap.data()?['totalXp']);
        final currentWeeklyXp = _readInt(
            weeklySnap.data()?['xp'] ?? weeklySnap.data()?['weeklyXp']);

        // Skip writes that would only move XP backwards. Equality is
        // still allowed so name/photo/level updates can flow through.
        final globalShouldWrite = safeTotalXp >= currentGlobalXp;
        final weeklyShouldWrite = safeWeeklyXp >= currentWeeklyXp;

        if (!globalShouldWrite && !weeklyShouldWrite) {
          return;
        }

        if (globalShouldWrite) {
          final globalEntry = <String, dynamic>{
            'displayName': displayName.isEmpty ? 'Learner' : displayName,
            if (photoUrl != null) 'photoUrl': photoUrl,
            'totalXp': safeTotalXp,
            'level': safeLevel,
            'weeklyXp': safeWeeklyXp,
            'updatedAt': nowMs,
          };
          tx.set(globalRef, globalEntry, SetOptions(merge: true));
        }

        if (weeklyShouldWrite) {
          final weeklyEntry = <String, dynamic>{
            'displayName': displayName.isEmpty ? 'Learner' : displayName,
            if (photoUrl != null) 'photoUrl': photoUrl,
            'totalXp': safeTotalXp,
            'level': safeLevel,
            'weeklyXp': safeWeeklyXp,
            'xp': safeWeeklyXp,
            'updatedAt': nowMs,
          };
          tx.set(weeklyRef, weeklyEntry, SetOptions(merge: true));
        }
      });
    } catch (e) {
      // Never crash the caller because of a leaderboard sync issue. Log
      // without exposing sensitive info.
      debugPrint('LeaderboardService.syncUserToLeaderboard failed: $e');
    }
  }

  // ── Fetch global top ───────────────────────────────────────────────
  Future<List<LeaderboardEntry>> fetchGlobalTop({
    int limit = 50,
    String? currentUid,
  }) async {
    final safeLimit = _normalizeLimit(limit);
    try {
      final snap = await _db
          .collection('leaderboard')
          .doc('global')
          .collection('entries')
          .orderBy('totalXp', descending: true)
          .limit(safeLimit)
          .get();

      return _mapEntries(snap.docs, currentUid);
    } catch (e) {
      debugPrint('LeaderboardService.fetchGlobalTop failed: $e');
      return const [];
    }
  }

  // ── Fetch weekly top ───────────────────────────────────────────────
  Future<List<LeaderboardEntry>> fetchWeeklyTop({
    int limit = 50,
    String? currentUid,
  }) async {
    final safeLimit = _normalizeLimit(limit);
    try {
      final weekId = _currentWeekIdUtc();
      final snap = await _db
          .collection('leaderboard')
          .doc('weekly_$weekId')
          .collection('entries')
          .orderBy('xp', descending: true)
          .limit(safeLimit)
          .get();

      return _mapEntries(snap.docs, currentUid);
    } catch (e) {
      debugPrint('LeaderboardService.fetchWeeklyTop failed: $e');
      return const [];
    }
  }

  // ── Fetch friends leaderboard ─────────────────────────────────────
  //
  // Friend lists larger than Firestore's whereIn limit are safely chunked
  // — no valid friend is discarded. The current user is always included.
  Future<List<LeaderboardEntry>> fetchFriendsLeaderboard({
    required String uid,
    required List<String> friendUids,
  }) async {
    if (uid.isEmpty && friendUids.isEmpty) return const [];

    // Build the de-duplicated UID set: always include the caller first,
    // then every non-empty, valid friend UID.
    final uniqueUids = <String>{};
    if (uid.isNotEmpty) uniqueUids.add(uid);
    for (final f in friendUids) {
      if (f.isNotEmpty) uniqueUids.add(f);
    }
    if (uniqueUids.isEmpty) return const [];

    final allUids = uniqueUids.toList();

    try {
      final entries = <LeaderboardEntry>[];
      for (var i = 0; i < allUids.length; i += _whereInChunkSize) {
        final chunk = allUids.sublist(
          i,
          (i + _whereInChunkSize) > allUids.length
              ? allUids.length
              : (i + _whereInChunkSize),
        );

        final snap = await _db
            .collection('leaderboard')
            .doc('global')
            .collection('entries')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        // Preserve current-user identification on every chunk.
        entries.addAll(_mapEntries(snap.docs, uid));
      }

      entries.sort((a, b) => b.totalXp.compareTo(a.totalXp));
      return entries;
    } catch (e) {
      debugPrint('LeaderboardService.fetchFriendsLeaderboard failed: $e');
      return const [];
    }
  }

  // ── Current user's rank in global ─────────────────────────────────
  //
  // Competition-style ranking: number of users with strictly greater XP
  // plus one. Ties share the same rank (two users at 1000 XP are both
  // rank 1). Uses a bounded count query, never downloads the full list.
  //
  // `uid` is preserved for backward compatibility with existing callers.
  Future<int> getCurrentUserRank(String uid, int userXp) async {
    final safeXp = userXp < 0 ? 0 : userXp;
    try {
      final snap = await _db
          .collection('leaderboard')
          .doc('global')
          .collection('entries')
          .where('totalXp', isGreaterThan: safeXp)
          .count()
          .get();
      return (snap.count ?? 0) + 1;
    } catch (e) {
      debugPrint('LeaderboardService.getCurrentUserRank failed: $e');
      return 0;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────

  /// Maps Firestore documents to [LeaderboardEntry] defensively. Bad
  /// numeric values fall back to safe defaults; never invents user info.
  List<LeaderboardEntry> _mapEntries(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    String? currentUid,
  ) {
    return docs.asMap().entries.map((e) {
      final rank = e.key + 1;
      final doc = e.value;
      final data = doc.data();

      final rawName = data['displayName'];
      final displayName =
          (rawName is String && rawName.isNotEmpty) ? rawName : 'Learner';

      final rawPhoto = data['photoUrl'];
      final photoUrl =
          (rawPhoto is String && rawPhoto.isNotEmpty) ? rawPhoto : null;

      final totalXp = _readInt(data['totalXp']);
      final level = _readInt(data['level'], fallback: 1, minimum: 1);
      final weeklyXp = _readInt(
        data['weeklyXp'] ?? data['xp'],
      );

      return LeaderboardEntry(
        uid: doc.id,
        displayName: displayName,
        photoUrl: photoUrl,
        totalXp: totalXp,
        level: level,
        rank: rank,
        weeklyXp: weeklyXp,
        isCurrentUser: doc.id == currentUid,
      );
    }).toList();
  }

  /// Defensive int reader. Accepts int / num / numeric String; anything
  /// else falls back to a safe default.
  int _readInt(
    dynamic raw, {
    int fallback = 0,
    int minimum = 0,
  }) {
    int value;
    if (raw is int) {
      value = raw;
    } else if (raw is num) {
      value = raw.toInt();
    } else if (raw is String) {
      value = int.tryParse(raw) ?? fallback;
    } else {
      value = fallback;
    }
    return value < minimum ? minimum : value;
  }

  /// Clamps the query limit into a safe, sensible range.
  int _normalizeLimit(int requested) {
    if (requested < _minLimit) return _minLimit;
    if (requested > _maxLimit) return _maxLimit;
    return requested;
  }

  /// Week identifier derived from a consistent UTC Monday. Produces the
  /// same `YYYY_M_D` shape as before, so existing weekly collections keep
  /// working without migration; only the reference frame changes from
  /// device-local to UTC so every user worldwide sees the same week.
  String _currentWeekIdUtc() {
    final nowUtc = DateTime.now().toUtc();
    // DateTime.weekday: Mon=1 ... Sun=7
    final mondayUtc = DateTime.utc(
      nowUtc.year,
      nowUtc.month,
      nowUtc.day,
    ).subtract(Duration(days: nowUtc.weekday - 1));
    return '${mondayUtc.year}_${mondayUtc.month}_${mondayUtc.day}';
  }
}
