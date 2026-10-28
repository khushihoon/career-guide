// ══════════════════════════════════════════════════════════════════════
// lib/services/achievement_service.dart
//
// Career Journey Achievement Engine.
//
// Converts real signals already exposed by CopilotController (profile,
// streak, roadmap, level) plus caller-supplied counts (total goals,
// current level) into unlockable achievements across the full career
// pipeline. Designed as a long-term professional career-progression
// system, not just a game badge feed.
//
// ARCHITECTURE NOTES
// ──────────────────
// • Public API is unchanged and byte-compatible with the previous
//   version:
//     - fetchUserAchievements(String uid) → Future<List<Achievement>>
//     - checkAndUnlock({uid, state, totalGoalsCompleted, currentLevel})
//       → Future<List<Achievement>>
// • Every existing achievement id and its current unlock condition is
//   preserved exactly.
// • Each achievement is described by a single _AchievementRule entry in
//   a private rule table. Rules are pure functions of a small, immutable
//   signal snapshot, so adding a future career achievement is a matter
//   of appending one rule — the engine itself never needs rewriting.
// • The signal snapshot only carries fields the current architecture
//   actually exposes. Anything not yet available is simply absent, and
//   rules that require it stay locked at 0 — never fabricated.
//
// CONCURRENCY / PERSISTENCE
// ─────────────────────────
// The achievements document stores two arrays:
//   • `unlocked`   — append-only history: [{id, unlockedAt}, ...]
//   • `inProgress` — mutable: [{id, progressCurrent}, ...] for LOCKED ids
//
// The whole unlock + progress reconciliation is performed inside a single
// Firestore transaction. Inside the transaction the engine re-reads the
// current document, computes the authoritative set of already-unlocked
// ids from THAT snapshot, determines which candidates are genuinely new,
// builds the final `inProgress` list from the current snapshot, and
// awards XP only for the ids that transitioned from locked to unlocked
// during that transaction. This makes the operation safe against
// concurrent checkAndUnlock() calls:
//   • an id already unlocked in Firestore is never re-written into
//     `inProgress`, even if a stale pre-transaction snapshot said it was
//     locked;
//   • XP can never be double-awarded for the same achievement;
//   • historical `unlockedAt` timestamps are never replaced (the entries
//     are written via arrayUnion so a duplicate id would be a no-op).
//
// Firestore parsing is defensive: malformed entries in `unlocked` or
// `inProgress` are skipped individually rather than failing the whole
// fetch, and legacy documents without these arrays are treated as empty
// rather than as errors.
// ══════════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/achievement_models.dart';
import '../models/copilot_models.dart'; // existing models

// ── Immutable signal snapshot ─────────────────────────────────────────
//
// Only fields the current architecture actually exposes are included.
// Anything not yet available (DSA, projects, portfolio, interviews, job
// applications, career readiness) is intentionally absent — future rules
// can be added by extending this snapshot only once the corresponding
// real data becomes available through the existing parameters.
class _Signals {
  final bool hasProfile;
  final int currentStreak;
  final bool hasRoadmap;
  final int totalGoalsCompleted;
  final int currentLevel;

  const _Signals({
    required this.hasProfile,
    required this.currentStreak,
    required this.hasRoadmap,
    required this.totalGoalsCompleted,
    required this.currentLevel,
  });

  static _Signals from({
    required CopilotState state,
    required int totalGoalsCompleted,
    required int currentLevel,
  }) =>
      _Signals(
        hasProfile: state.hasProfile,
        currentStreak: state.currentStreak,
        hasRoadmap: state.roadmap != null,
        totalGoalsCompleted: totalGoalsCompleted,
        currentLevel: currentLevel,
      );
}

// ── Rule descriptor ───────────────────────────────────────────────────
//
// Pure, side-effect-free description of one achievement:
//   • `progress` maps the current signal snapshot to a clamped integer
//     progress value used for the inProgress row.
//   • `unlocked` returns true only when the real condition is satisfied.
//
// Rules must never touch Firestore, UI, or any other mutable state.
class _AchievementRule {
  final int Function(_Signals s) progress;
  final bool Function(_Signals s) unlocked;

  const _AchievementRule({
    required this.progress,
    required this.unlocked,
  });
}

class AchievementService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Rule table ──────────────────────────────────────────────────────
  //
  // Every existing achievement id and its current unlock condition is
  // preserved here. Rules are keyed by the achievement id already used
  // in AchievementCatalog, so no model change is needed. New career
  // achievements can be added later by appending one rule — this table
  // is the single place that needs extending.
  static final Map<String, _AchievementRule> _rules = {
    // ── Career / profile milestones ─────────────────────────────────
    'profile_complete': _AchievementRule(
      progress: (s) => s.hasProfile ? 1 : 0,
      unlocked: (s) => s.hasProfile,
    ),

    // ── Learning / consistency ──────────────────────────────────────
    'first_goal': _AchievementRule(
      progress: (s) => s.totalGoalsCompleted >= 1 ? 1 : 0,
      unlocked: (s) => s.totalGoalsCompleted >= 1,
    ),
    'goals_5': _AchievementRule(
      progress: (s) => s.totalGoalsCompleted.clamp(0, 5),
      unlocked: (s) => s.totalGoalsCompleted >= 5,
    ),
    'goals_25': _AchievementRule(
      progress: (s) => s.totalGoalsCompleted.clamp(0, 25),
      unlocked: (s) => s.totalGoalsCompleted >= 25,
    ),
    'goals_100': _AchievementRule(
      progress: (s) => s.totalGoalsCompleted.clamp(0, 100),
      unlocked: (s) => s.totalGoalsCompleted >= 100,
    ),

    // ── Roadmap milestones ──────────────────────────────────────────
    'roadmap_started': _AchievementRule(
      progress: (s) => s.hasRoadmap ? 1 : 0,
      unlocked: (s) => s.hasRoadmap,
    ),

    // ── Streak / consistency ────────────────────────────────────────
    'three_day_streak': _AchievementRule(
      progress: (s) => s.currentStreak.clamp(0, 3),
      unlocked: (s) => s.currentStreak >= 3,
    ),
    'week_streak': _AchievementRule(
      progress: (s) => s.currentStreak.clamp(0, 7),
      unlocked: (s) => s.currentStreak >= 7,
    ),
    'month_streak': _AchievementRule(
      progress: (s) => s.currentStreak.clamp(0, 30),
      unlocked: (s) => s.currentStreak >= 30,
    ),
    'hundred_day_streak': _AchievementRule(
      progress: (s) => s.currentStreak.clamp(0, 100),
      unlocked: (s) => s.currentStreak >= 100,
    ),

    // ── Long-term mastery (level) ───────────────────────────────────
    'level_5': _AchievementRule(
      progress: (s) => s.currentLevel.clamp(0, 5),
      unlocked: (s) => s.currentLevel >= 5,
    ),
    'level_10': _AchievementRule(
      progress: (s) => s.currentLevel.clamp(0, 10),
      unlocked: (s) => s.currentLevel >= 10,
    ),
    'level_20': _AchievementRule(
      progress: (s) => s.currentLevel.clamp(0, 20),
      unlocked: (s) => s.currentLevel >= 20,
    ),
  };

  // ── Fetch user's unlocked + in-progress achievements ───────────────
  Future<List<Achievement>> fetchUserAchievements(String uid) async {
    try {
      final doc = await _db.collection('achievements').doc(uid).get();
      if (!doc.exists) return _allWithProgress({}, {});

      final data = doc.data()!;
      final unlockedMap = _parseUnlocked(data['unlocked']);
      final progressMap = _parseInProgress(data['inProgress']);

      return _allWithProgress(unlockedMap, progressMap);
    } catch (_) {
      return AchievementCatalog.all;
    }
  }

  /// Defensive parse of the `unlocked` array. Skips malformed entries
  /// individually so one bad record cannot break the whole fetch.
  Map<String, DateTime> _parseUnlocked(dynamic raw) {
    final result = <String, DateTime>{};
    if (raw is! List) return result;
    for (final entry in raw) {
      if (entry is! Map) continue;
      final id = entry['id'];
      final at = entry['unlockedAt'];
      if (id is! String || id.isEmpty) continue;
      DateTime? when;
      if (at is int) {
        when = DateTime.fromMillisecondsSinceEpoch(at);
      } else if (at is num) {
        when = DateTime.fromMillisecondsSinceEpoch(at.toInt());
      }
      if (when == null) continue;
      // If a duplicate id somehow exists, keep the EARLIEST unlock time
      // so the historical record is never shifted forward.
      final existing = result[id];
      if (existing == null || when.isBefore(existing)) {
        result[id] = when;
      }
    }
    return result;
  }

  /// Defensive parse of the `inProgress` array. Skips malformed entries
  /// individually and ignores negative/non-numeric progress.
  Map<String, int> _parseInProgress(dynamic raw) {
    final result = <String, int>{};
    if (raw is! List) return result;
    for (final entry in raw) {
      if (entry is! Map) continue;
      final id = entry['id'];
      final current = entry['progressCurrent'];
      if (id is! String || id.isEmpty) continue;
      int value;
      if (current is int) {
        value = current;
      } else if (current is num) {
        value = current.toInt();
      } else {
        continue;
      }
      if (value < 0) value = 0;
      result[id] = value;
    }
    return result;
  }

  List<Achievement> _allWithProgress(
    Map<String, DateTime> unlockedMap,
    Map<String, int> progressMap,
  ) {
    return AchievementCatalog.all.map((a) {
      final unlockedAt = unlockedMap[a.id];
      final current = progressMap[a.id] ?? 0;
      final target = a.progressTarget;
      return Achievement(
        id: a.id,
        title: a.title,
        description: a.description,
        icon: a.icon,
        rarity: a.rarity,
        xpBonus: a.xpBonus,
        unlockedAt: unlockedAt,
        progressTarget: target,
        progressCurrent: unlockedAt != null ? target : current,
        progress: unlockedAt != null
            ? 1.0
            : target <= 0
                ? 0.0
                : (current / target).clamp(0.0, 1.0),
      );
    }).toList();
  }

  // ── Check all conditions after a state change ──────────────────────
  /// Returns the list of achievements newly unlocked in this call.
  ///
  /// The reconciliation happens entirely inside a Firestore transaction
  /// so that concurrent calls cannot produce duplicate unlock records,
  /// cannot re-award XP for the same achievement, and cannot leave a
  /// stale inProgress row for an achievement that is already unlocked.
  Future<List<Achievement>> checkAndUnlock({
    required String uid,
    required CopilotState state,
    required int totalGoalsCompleted,
    required int currentLevel,
  }) async {
    final signals = _Signals.from(
      state: state,
      totalGoalsCompleted: totalGoalsCompleted,
      currentLevel: currentLevel,
    );

    // Compute the desired unlock candidates from the CURRENT real
    // signals. These candidates are then reconciled against the
    // authoritative Firestore state inside the transaction — this list
    // is a set of *possibilities*, not a decision.
    final candidates = <Achievement>[];
    for (final achievement in AchievementCatalog.all) {
      final rule = _rules[achievement.id];
      final unlocked = rule?.unlocked(signals) ?? false;
      if (unlocked) candidates.add(achievement);
    }

    return _applyUnlocks(
      uid: uid,
      signals: signals,
      candidates: candidates,
    );
  }

  /// Authoritative unlock + progress application.
  ///
  /// Runs in a single Firestore transaction that re-reads the current
  /// achievements document and:
  ///   • determines the authoritative set of already-unlocked ids from
  ///     that transaction snapshot (never from a stale pre-transaction
  ///     read);
  ///   • computes the truly-new unlocks as candidates minus already-
  ///     unlocked;
  ///   • rebuilds `inProgress` from the current locked set, ensuring no
  ///     unlocked achievement can be written back into it;
  ///   • awards XP only for the ids that transitioned from locked to
  ///     unlocked inside this transaction.
  Future<List<Achievement>> _applyUnlocks({
    required String uid,
    required _Signals signals,
    required List<Achievement> candidates,
  }) async {
    final docRef = _db.collection('achievements').doc(uid);
    final userRef = _db.collection('users').doc(uid);

    final confirmedNew = <Achievement>[];

    await _db.runTransaction((tx) async {
      final snapshot = await tx.get(docRef);
      final data = snapshot.data() ?? <String, dynamic>{};

      // Authoritative unlock state — read INSIDE the transaction.
      final alreadyUnlocked = _parseUnlocked(data['unlocked']).keys.toSet();

      // Truly new unlocks: candidates that are not already unlocked in
      // Firestore as of this transaction.
      final candidateIds = candidates.map((a) => a.id).toSet();
      final toPersist = <Achievement>[];
      for (final a in candidates) {
        if (alreadyUnlocked.contains(a.id)) continue;
        toPersist.add(a);
      }

      // Rebuild inProgress from scratch, using the CURRENT signal
      // snapshot and the CURRENT authoritative unlock set (including the
      // ids we are about to unlock in this transaction). Only LOCKED
      // achievements get a row.
      final toPersistIds = toPersist.map((a) => a.id).toSet();
      final finalInProgress = <Map<String, dynamic>>[];
      for (final achievement in AchievementCatalog.all) {
        final id = achievement.id;
        if (alreadyUnlocked.contains(id)) continue; // already unlocked
        if (toPersistIds.contains(id)) continue; // unlocking right now

        final rule = _rules[id];
        final current = rule?.progress(signals) ?? 0;
        finalInProgress.add({
          'id': id,
          'progressCurrent': current,
        });
      }

      // Sanity: nothing outside the catalog should be resurrected into
      // inProgress either. candidateIds is intentionally not used here
      // beyond dedup above; the catalog is the single source of ids.
      // ignore: unused_local_variable
      final _ = candidateIds;

      final now = DateTime.now().millisecondsSinceEpoch;
      final newEntries =
          toPersist.map((a) => {'id': a.id, 'unlockedAt': now}).toList();

      final update = <String, dynamic>{
        'inProgress': finalInProgress,
      };
      if (newEntries.isNotEmpty) {
        // arrayUnion is safe against a concurrent write that already
        // added the same id — the entry is a no-op and the existing
        // historical unlockedAt timestamp is preserved.
        update['unlocked'] = FieldValue.arrayUnion(newEntries);
      }

      tx.set(docRef, update, SetOptions(merge: true));

      // Award XP only for the ids that transitioned from locked to
      // unlocked inside this transaction. Because toPersist excludes
      // anything already present in the authoritative snapshot, the
      // same achievement can never award XP twice.
      final totalBonus = toPersist.fold<int>(0, (s, a) => s + a.xpBonus);
      if (totalBonus > 0) {
        tx.set(
          userRef,
          {'totalXp': FieldValue.increment(totalBonus)},
          SetOptions(merge: true),
        );
      }

      confirmedNew.addAll(toPersist);
    });

    return confirmedNew;
  }
}
