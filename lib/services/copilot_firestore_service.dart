// ═══════════════════════════════════════════════════════════════════════════
// lib/services/copilot_firestore_service.dart
// Firestore CRUD for every copilot collection.
//
// FINAL PRODUCTION VERSION — Authoritative Career Evidence Layer
//
// ───────────────────────────────────────────────────────────────────────────
// TRANSACTION INVARIANT (applies to EVERY transaction in this file)
// ───────────────────────────────────────────────────────────────────────────
// Firestore transactions require all reads to happen before any writes.
// Every transaction here follows this order strictly:
//   1. READ every document needed for the decision.
//   2. COMPUTE the write payload.
//   3. WRITE.
// No read is ever performed after the first write inside the same
// transaction. Transaction retries therefore re-run the entire
// read → compute → write sequence against fresh data, which is what
// makes all idempotency guarantees below retry-safe and concurrency-safe.
//
// ───────────────────────────────────────────────────────────────────────────
// GOAL STATE AUTHORITY
// ───────────────────────────────────────────────────────────────────────────
// toggleGoalCompletion() derives the requested next state from the
// authoritative Firestore goal document — never from the caller's UI
// object. `goal.isCompleted` is advisory only. A stale UI snapshot can
// therefore never produce a bogus flip, a duplicate XP award, or a
// duplicate lifetime increment.
//
// toggleGoalCompletion() returns a [GoalToggleResult] carrying the
// authoritative final state (`isCompleted`) together with a flag
// (`becameCompleted`) that is true only when this call was a genuine
// first-time false → true completion whose canonical completion record
// did not already exist.
//
// ───────────────────────────────────────────────────────────────────────────
// GOAL COMPLETION IDENTITY — ONE CANONICAL, CAREER-AGNOSTIC RECORD
// ───────────────────────────────────────────────────────────────────────────
// Every genuine goal completion is identified by ONE canonical,
// career-agnostic record id:
//
//     goal:{goalId}
//
// This id is written to a single canonical location that exists whether
// or not a careerId is available:
//
//     users/{uid}/copilot_goal_events/{goal:{goalId}}
//
// This canonical record is the authoritative idempotency identity for
// BOTH the goal XP award AND the lifetime totalGoalsCompleted counter.
// It is the SAME record regardless of careerId availability, so the
// no-career path has exactly the same persistent, retry-safe,
// concurrency-safe idempotency as the career path.
//
// When a real careerId is ALSO available, the existing structured
// career-event layer is written as a parallel evidence record at:
//
//     users/{uid}/copilot_learning_progress/{careerId}/events/goal:{goalId}
//
// (unchanged path, unchanged schema, backward compatible).
//
// ───────────────────────────────────────────────────────────────────────────
// GOAL COMPLETION — EXACTLY-ONCE, ON EVERY AXIS
// ───────────────────────────────────────────────────────────────────────────
// On a genuine false → true transition of a goal:
//   • The canonical goal-completion record is read inside the transaction.
//   • If it already exists:
//       - XP is NOT awarded again.
//       - totalGoalsCompleted is NOT incremented again.
//       - The record is not rewritten (recordedAt remains stable).
//       - The career-side structured event (if any) is also left as-is.
//       - becameCompleted is false.
//   • If it does not exist:
//       - XP is awarded exactly once.
//       - totalGoalsCompleted is incremented exactly once.
//       - The canonical record is written once.
//       - The career-side structured event is written once (only when a
//         real careerId is present — no fake/synthetic bucket is ever
//         created).
//       - becameCompleted is true.
// All of the above are written in the SAME transaction as the goal flip,
// so XP, lifetime count, and both evidence records are atomic.
//
// true → false:
//   • Flips the goal's current state only.
//   • Does NOT decrement totalGoalsCompleted.
//   • Does NOT remove historical XP.
//   • Does NOT delete or rewrite the canonical record or the career-side
//     structured event. History is preserved.
//   • becameCompleted is false.
//
// ───────────────────────────────────────────────────────────────────────────
// TOTAL GOALS COMPLETED (users/{uid}.totalGoalsCompleted)
// ───────────────────────────────────────────────────────────────────────────
// Authoritative lifetime count of successfully completed goals. Incremented
// at most once per canonical goal-completion record. A missing field safely
// reads as 0. Never derived from progressHistory or daily snapshots.
//
// ───────────────────────────────────────────────────────────────────────────
// AUTHORITATIVE XP READ
// ───────────────────────────────────────────────────────────────────────────
// getUserTotalXp(uid) returns users/{uid}.totalXp as int, or 0 when the
// document/field is missing or invalid. It NEVER derives XP from
// progressHistory and NEVER mutates state — it is a pure read helper.
//
// ───────────────────────────────────────────────────────────────────────────
// STRUCTURED CAREER EVENT LAYER
// ───────────────────────────────────────────────────────────────────────────
// users/{uid}/copilot_learning_progress/{careerId}/events/{eventId}
// remains the primary career-scoped evidence trail. Structured evidence is
// written only under a real careerId — synthetic buckets are never created.
// Every structured event writer reads its event document inside its own
// transaction before writing, so retries and concurrent calls cannot
// duplicate, rewrite, or lose historical evidence.
//
// recordCourseEvent() returns Future<bool>: true when THIS call newly
// recorded the event (and therefore awarded XP inside the transaction),
// false when the event already existed (idempotent no-op) or the inputs
// were invalid. Firestore remains the sole XP authority — callers must
// not add XP logic of their own.
//
// ───────────────────────────────────────────────────────────────────────────
// CAREER ID NORMALIZATION
// ───────────────────────────────────────────────────────────────────────────
// Every career id is normalized by _safeId() before being used in a
// document path or event id. Readers and writers use the same
// normalization, so the same career identity always resolves to the same
// document. Existing short, safe career ids pass through unchanged, so
// previously-stored data keeps resolving.
//
// ───────────────────────────────────────────────────────────────────────────
// FIRESTORE LIMITS / SCALABILITY
// ───────────────────────────────────────────────────────────────────────────
// • Batch writes are chunked (450 ops/batch, safely below the 500 limit).
// • Document ids are capped well below the byte limit; oversized ids are
//   replaced with a deterministic, collision-resistant digest.
// • Metadata maps are bounded by key count, key length, and string length.
// • Historical arrays grow via FieldValue.arrayUnion (atomic, idempotent),
//   never via full-document rewrites on the hot path.
// • saveLearningProgress() writes only current-state fields; historical
//   arrays are only ever extended atomically.
// • getCopilotContext() reads run concurrently; only the career-scoped
//   learning progress is read sequentially because it depends on the
//   resolved careerId.
// ═══════════════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/copilot_models.dart';

/// Event types supported by the structured career-evidence subcollection.
class CopilotEventType {
  static const String lesson         = 'lesson';
  static const String quiz           = 'quiz';
  static const String challenge      = 'challenge';
  static const String project        = 'project';
  static const String goal           = 'goal';
  static const String jobApplication = 'jobApplication';
  static const String interview      = 'interview';
  static const String topicEvidence  = 'topicEvidence';

  static const List<String> all = [
    lesson,
    quiz,
    challenge,
    project,
    goal,
    jobApplication,
    interview,
    topicEvidence,
  ];
}

/// Authoritative result of a goal toggle operation.
///
///   • [isCompleted]      — the final authoritative state of the goal
///                          after the toggle, as observed in Firestore.
///   • [becameCompleted]  — true ONLY when this call was a genuine
///                          first-time false → true completion whose
///                          canonical completion record did not already
///                          exist (i.e. XP and the lifetime counter were
///                          awarded by THIS call). False for
///                          true → false flips and for idempotent
///                          re-completions where the canonical record
///                          already existed.
class GoalToggleResult {
  final bool isCompleted;
  final bool becameCompleted;

  const GoalToggleResult({
    required this.isCompleted,
    required this.becameCompleted,
  });

  /// Safe default for invalid inputs (missing uid / goal id / goal doc).
  static const GoalToggleResult notToggled = GoalToggleResult(
    isCompleted: false,
    becameCompleted: false,
  );
}

class CopilotFirestoreService {
  static final FirebaseFirestore _db   = FirebaseFirestore.instance;
  static final FirebaseAuth      _auth = FirebaseAuth.instance;

  // ── Safety constants ──────────────────────────────────────────────────────
  static const int _batchChunkSize = 450;
  static const int _maxIdBytes     = 1400;

  static const int _maxMetadataKeys      = 12;
  static const int _maxMetadataKeyLen    = 40;
  static const int _maxMetadataStringLen = 200;

  // ── helpers ────────────────────────────────────────────────────────────────

  static DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  /// Returns a Firestore-safe document-id string derived deterministically
  /// from [raw].
  ///
  /// Short, safe ASCII ids pass through unchanged so previously-stored
  /// event ids keep resolving to the same documents. Oversized ids are
  /// replaced with a deterministic, collision-resistant digest that stays
  /// well within Firestore's byte limit. Characters Firestore rejects
  /// ('/', control chars) are escaped.
  static String _safeId(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return '';

    final utf8Len = _utf8ByteLength(t);
    if (utf8Len <= _maxIdBytes && !_needsEscaping(t)) {
      return t;
    }

    final digest = _stableHashHex(t);
    const prefixLen = 24;
    final prefix = t.length <= prefixLen ? t : t.substring(0, prefixLen);
    final safePrefix = _escapeForDocId(prefix);
    return '$safePrefix~$digest';
  }

  static bool _needsEscaping(String s) {
    for (final rune in s.runes) {
      if (rune == 0x2F) return true;
      if (rune < 0x20) return true;
      if (rune == 0x7F) return true;
    }
    return false;
  }

  static String _escapeForDocId(String s) {
    final buf = StringBuffer();
    for (final rune in s.runes) {
      if (rune == 0x2F) {
        buf.write('%2F');
      } else if (rune < 0x20 || rune == 0x7F) {
        buf.write('%');
        buf.write(rune.toRadixString(16).padLeft(2, '0').toUpperCase());
      } else {
        buf.writeCharCode(rune);
      }
    }
    return buf.toString();
  }

  static int _utf8ByteLength(String s) {
    var n = 0;
    for (final rune in s.runes) {
      if (rune <= 0x7F) {
        n += 1;
      } else if (rune <= 0x7FF) {
        n += 2;
      } else if (rune <= 0xFFFF) {
        n += 3;
      } else {
        n += 4;
      }
    }
    return n;
  }

  static String _stableHashHex(String s) {
    var hash = BigInt.parse('0xcbf29ce484222325');
    final prime = BigInt.parse('0x100000001b3');
    final mask = BigInt.parse('0xFFFFFFFFFFFFFFFF');
    for (final codeUnit in s.codeUnits) {
      hash = (hash ^ BigInt.from(codeUnit)) & mask;
      hash = (hash * prime) & mask;
    }
    return hash.toRadixString(16).padLeft(16, '0');
  }

  // ── Skill Profile ──────────────────────────────────────────────────────────

  static Future<void> saveSkillProfile(UserSkillProfile profile) =>
      _userDoc(profile.uid)
          .collection('copilot')
          .doc('skill_profile')
          .set(profile.toFirestore());

  static Future<UserSkillProfile?> getSkillProfile(String uid) async {
    final snap = await _userDoc(uid)
        .collection('copilot')
        .doc('skill_profile')
        .get();
    if (!snap.exists || snap.data() == null) return null;
    return UserSkillProfile.fromFirestore(snap.data()!);
  }

  static Stream<UserSkillProfile?> skillProfileStream(String uid) =>
      _userDoc(uid)
          .collection('copilot')
          .doc('skill_profile')
          .snapshots()
          .map((s) =>
              s.exists && s.data() != null
                  ? UserSkillProfile.fromFirestore(s.data()!)
                  : null);

  // ── Skill Gaps ─────────────────────────────────────────────────────────────

  static Future<void> saveSkillGaps(String uid, List<SkillGap> gaps) async {
    final col = _userDoc(uid).collection('copilot_skill_gaps');
    final existing = await col.get();

    final refsToDelete = existing.docs.map((d) => d.reference).toList();
    final writes = <_BatchOp>[
      for (final r in refsToDelete) _BatchOp.delete(r),
      for (int i = 0; i < gaps.length; i++)
        _BatchOp.set(col.doc('gap_$i'), gaps[i].toFirestore()),
    ];

    await _commitChunked(writes);
  }

  static Future<List<SkillGap>> getSkillGaps(String uid) async {
    final snap = await _userDoc(uid)
        .collection('copilot_skill_gaps')
        .orderBy('priority')
        .get();
    return snap.docs.map((d) => SkillGap.fromFirestore(d.data())).toList();
  }

  // ── Personalized Roadmap ───────────────────────────────────────────────────

  static Future<void> saveRoadmap(PersonalizedRoadmap roadmap) =>
      _userDoc(roadmap.uid)
          .collection('copilot')
          .doc('roadmap')
          .set(roadmap.toFirestore());

  static Future<PersonalizedRoadmap?> getRoadmap(String uid) async {
    final snap =
        await _userDoc(uid).collection('copilot').doc('roadmap').get();
    if (!snap.exists || snap.data() == null) return null;
    return PersonalizedRoadmap.fromFirestore(snap.data()!);
  }

  static Stream<PersonalizedRoadmap?> roadmapStream(String uid) =>
      _userDoc(uid)
          .collection('copilot')
          .doc('roadmap')
          .snapshots()
          .map((s) =>
              s.exists && s.data() != null
                  ? PersonalizedRoadmap.fromFirestore(s.data()!)
                  : null);

  /// Marks a roadmap phase complete inside a Firestore transaction.
  /// Read happens first; writes happen after.
  static Future<void> completeRoadmapPhase(
      String uid, int phaseIndex) async {
    final doc = _userDoc(uid).collection('copilot').doc('roadmap');

    await _db.runTransaction((tx) async {
      // READ
      final snap = await tx.get(doc);
      if (!snap.exists || snap.data() == null) return;

      final roadmap = PersonalizedRoadmap.fromFirestore(snap.data()!);
      if (phaseIndex < 0 || phaseIndex >= roadmap.phases.length) return;

      // COMPUTE
      final phases = roadmap.phases.map((p) {
        if (p.phaseNumber == phaseIndex) {
          return RoadmapPhase(
            phaseNumber: p.phaseNumber,
            title: p.title,
            description: p.description,
            skills: p.skills,
            resources: p.resources,
            estimatedDuration: p.estimatedDuration,
            isCompleted: true,
            isUnlocked: p.isUnlocked,
          );
        }
        if (p.phaseNumber == phaseIndex + 1) {
          return RoadmapPhase(
            phaseNumber: p.phaseNumber,
            title: p.title,
            description: p.description,
            skills: p.skills,
            resources: p.resources,
            estimatedDuration: p.estimatedDuration,
            isCompleted: p.isCompleted,
            isUnlocked: true,
          );
        }
        return p;
      }).toList();

      // WRITE
      tx.set(
        doc,
        roadmap.copyWith(phases: phases, currentPhaseIndex: phaseIndex + 1)
            .toFirestore(),
      );
    });
  }

  // ── Daily Goals ────────────────────────────────────────────────────────────

  static String _todayKey() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  /// Persists a batch of daily goals.
  ///
  /// Each goal id is scoped by the caller and includes the date, so a
  /// repeated save of the same goals for the same day writes to the same
  /// documents with the same content — idempotent by construction. The
  /// per-goal document is written with SetOptions(merge: true) so any
  /// additional fields a future writer may add are not clobbered.
  static Future<void> saveDailyGoals(
      String uid, List<DailyGoal> goals) async {
    if (goals.isEmpty) return;

    final writes = <_BatchOp>[
      for (final g in goals)
        _BatchOp.set(
          _userDoc(uid).collection('copilot_daily_goals').doc(g.id),
          g.toFirestore(),
        ),
    ];

    await _commitChunked(writes);
  }

  static Future<List<DailyGoal>> getTodayGoals(String uid) async {
    final snap = await _userDoc(uid)
        .collection('copilot_daily_goals')
        .where('date', isEqualTo: _todayKey())
        .get();
    return snap.docs.map((d) => DailyGoal.fromFirestore(d.data())).toList();
  }

  static Stream<List<DailyGoal>> todayGoalsStream(String uid) =>
      _userDoc(uid)
          .collection('copilot_daily_goals')
          .where('date', isEqualTo: _todayKey())
          .snapshots()
          .map((s) =>
              s.docs.map((d) => DailyGoal.fromFirestore(d.data())).toList());

  /// Toggles a goal's completion state and, on the genuine false → true
  /// transition, awards goal XP and increments the lifetime counter,
  /// atomically, in a single Firestore transaction.
  ///
  /// STATE AUTHORITY
  ///   • The current completion state is READ from the Firestore goal
  ///     document — NOT from the caller's UI object.
  ///   • The requested next state is the inverse of the authoritative
  ///     value, so stale UI, duplicate taps, and mis-ordered retries
  ///     cannot corrupt the goal's state.
  ///
  /// COMPLETION IDENTITY (career-agnostic)
  ///   • One canonical user-level record per goal id:
  ///       users/{uid}/copilot_goal_events/goal:{goalId}
  ///     This record is the SINGLE authoritative idempotency identity for
  ///     both the XP award and the lifetime totalGoalsCompleted increment,
  ///     and it exists independently of careerId availability.
  ///
  /// STRUCTURED CAREER EVIDENCE (career-scoped, optional)
  ///   • When a real careerId is available, a parallel evidence record is
  ///     written to the existing structured career-event layer at:
  ///       users/{uid}/copilot_learning_progress/{careerId}/events/goal:{goalId}
  ///     The path and schema are unchanged; no fake/synthetic career
  ///     bucket is ever created.
  ///
  /// EXACTLY-ONCE
  ///   • XP: awarded only when the canonical goal-completion record does
  ///     not already exist.
  ///   • totalGoalsCompleted: incremented only under the same condition.
  ///   • Canonical record: written only under the same condition.
  ///   • Career-side structured event: written only under the same
  ///     condition AND only when a real careerId exists.
  ///
  /// true → false
  ///   • Flips the goal's state only.
  ///   • Never decrements the lifetime counter, never removes historical
  ///     XP, and never deletes or rewrites the canonical record or the
  ///     career-side structured event. History is preserved.
  ///
  /// RESULT
  ///   • Returns a [GoalToggleResult] carrying the final authoritative
  ///     goal state and a flag that is true only for a genuine first-time
  ///     false → true completion.
  ///
  /// Every transaction read happens before every transaction write.
  static Future<GoalToggleResult> toggleGoalCompletion(
    String uid,
    DailyGoal goal, {
    String? careerId,
  }) async {
    if (uid.isEmpty || goal.id.isEmpty) {
      return GoalToggleResult.notToggled;
    }

    final goalRef = _userDoc(uid)
        .collection('copilot_daily_goals')
        .doc(goal.id);
    final userRef = _userDoc(uid);

    // Canonical, career-agnostic completion record id.
    final canonicalEventId = 'goal:${goal.id}';
    final canonicalRef     = _goalEventDoc(uid, canonicalEventId);

    // Optional career-scoped structured evidence.
    final resolvedCareerId =
        (careerId != null && careerId.isNotEmpty) ? _safeId(careerId) : null;
    final hasCareer = resolvedCareerId != null && resolvedCareerId.isNotEmpty;

    final careerEventRef = hasCareer
        ? _eventDoc(uid, resolvedCareerId, canonicalEventId)
        : null;

    return _db.runTransaction<GoalToggleResult>((tx) async {
      // ── READ PHASE ─────────────────────────────────────────────────
      final goalSnap = await tx.get(goalRef);
      if (!goalSnap.exists || goalSnap.data() == null) {
        return GoalToggleResult.notToggled;
      }

      // Canonical completion record — the idempotency identity.
      final canonicalSnap = await tx.get(canonicalRef);
      final alreadyCompleted =
          canonicalSnap.exists && canonicalSnap.data() != null;

      // Career-side structured event (when a real careerId exists).
      final careerSnap = careerEventRef != null
          ? await tx.get(careerEventRef)
          : null;
      final careerEventExists = careerSnap != null && careerSnap.exists;

      // ── COMPUTE PHASE ──────────────────────────────────────────────
      final data = goalSnap.data()!;
      final currentCompleted =
          data['isCompleted'] is bool ? data['isCompleted'] as bool : false;

      // Firestore is the authoritative source of the goal's state.
      final requestedNewState = !currentCompleted;
      if (currentCompleted == requestedNewState) {
        // Not reachable in practice because requestedNewState is defined
        // as the inverse of currentCompleted — kept as a defensive guard.
        return GoalToggleResult(
          isCompleted: currentCompleted,
          becameCompleted: false,
        );
      }

      final isCompleting = !currentCompleted && requestedNewState;
      final reward =
          data['xpReward'] is num ? (data['xpReward'] as num).toInt() : 0;

      // XP / lifetime counter / canonical record: awarded only on a
      // genuine completion whose canonical record does not already exist.
      // This makes them all exactly-once across retries, concurrent
      // calls, and true → false → true cycles.
      final shouldAwardCompletion = isCompleting && !alreadyCompleted;
      final shouldAwardXp         = shouldAwardCompletion && reward > 0;

      // Career-side structured event: written only under the same
      // condition AND only when a real careerId exists.
      final shouldWriteCareerEvent =
          shouldAwardCompletion && careerEventRef != null && !careerEventExists;

      // ── WRITE PHASE ────────────────────────────────────────────────
      tx.update(goalRef, {'isCompleted': requestedNewState});

      if (shouldAwardXp) {
        tx.set(
          userRef,
          {'totalXp': FieldValue.increment(reward)},
          SetOptions(merge: true),
        );
      }

      if (shouldAwardCompletion) {
        // Lifetime counter — increments exactly once per canonical
        // completion record, independent of careerId availability.
        tx.set(
          userRef,
          {'totalGoalsCompleted': FieldValue.increment(1)},
          SetOptions(merge: true),
        );

        // Canonical, career-agnostic completion record — the single
        // authoritative identity protecting XP and the lifetime counter.
        tx.set(
          canonicalRef,
          {
            'eventId': canonicalEventId,
            'eventType': CopilotEventType.goal,
            'careerId': resolvedCareerId,
            'goalId': goal.id,
            'topic': goal.linkedSkill,
            'correct': true,
            'xp': reward,
            'metadata': _boundedMetadata({
              'goalId': goal.id,
              'category': goal.category.label,
              'date': goal.date,
            }),
            'recordedAt': DateTime.now().toIso8601String(),
          },
          SetOptions(merge: true),
        );
      }

      if (shouldWriteCareerEvent) {
        tx.set(
          careerEventRef!,
          {
            'eventId': canonicalEventId,
            'eventType': CopilotEventType.goal,
            'careerId': resolvedCareerId,
            'topic': goal.linkedSkill,
            'correct': true,
            'xp': reward,
            'metadata': _boundedMetadata({
              'goalId': goal.id,
              'category': goal.category.label,
              'date': goal.date,
            }),
            'recordedAt': DateTime.now().toIso8601String(),
          },
          SetOptions(merge: true),
        );
      }

      return GoalToggleResult(
        isCompleted: requestedNewState,
        becameCompleted: shouldAwardCompletion,
      );
    });
  }

  /// Authoritative lifetime count of successfully completed goals.
  ///
  /// Reads users/{uid}.totalGoalsCompleted. Returns 0 when the document
  /// or field is missing, or when the stored value is not a valid
  /// non-negative integer. Never derived from progressHistory — the
  /// daily snapshot is not a lifetime source of truth.
  static Future<int> getTotalGoalsCompleted(String uid) async {
    if (uid.isEmpty) return 0;
    final snap = await _userDoc(uid).get();
    if (!snap.exists || snap.data() == null) return 0;
    final raw = snap.data()!['totalGoalsCompleted'];
    if (raw is int) return raw < 0 ? 0 : raw;
    if (raw is num) {
      final v = raw.toInt();
      return v < 0 ? 0 : v;
    }
    return 0;
  }

  /// Authoritative total XP for the user.
  ///
  /// Reads users/{uid}.totalXp and returns it as a non-negative int.
  /// Returns 0 when the document or field is missing, or when the value
  /// is malformed/negative. This is a pure read helper — it NEVER derives
  /// XP from progress history and NEVER mutates state.
  static Future<int> getUserTotalXp(String uid) async {
    if (uid.isEmpty) return 0;
    final snap = await _userDoc(uid).get();
    if (!snap.exists || snap.data() == null) return 0;
    final raw = snap.data()!['totalXp'];
    if (raw is int) return raw < 0 ? 0 : raw;
    if (raw is num) {
      final v = raw.toInt();
      return v < 0 ? 0 : v;
    }
    return 0;
  }

  // ── Progress ───────────────────────────────────────────────────────────────

  static Future<void> syncTodayProgress(
      String uid, List<DailyGoal> todayGoals) async {
    final today     = _todayKey();
    final completed = todayGoals.where((g) => g.isCompleted).toList();
    final xp        = completed.fold(0, (sum, g) => sum + g.xpReward);
    final completedSkills = completed
        .where((g) => g.linkedSkill != null)
        .map((g) => g.linkedSkill!)
        .toList();

    final data = ProgressEntry(
      id: '${uid}_$today',
      uid: uid,
      date: DateTime.now(),
      xpEarned: xp,
      goalsCompleted: completed.length,
      totalGoals: todayGoals.length,
      completedSkills: completedSkills,
    ).toFirestore();

    await _userDoc(uid)
        .collection('copilot_progress')
        .doc('${uid}_$today')
        .set(data, SetOptions(merge: true));
  }

  static Future<List<ProgressEntry>> getProgressHistory(
      String uid, {int limit = 30}) async {
    final safeLimit = limit <= 0 ? 30 : (limit > 90 ? 90 : limit);
    final snap = await _userDoc(uid)
        .collection('copilot_progress')
        .orderBy('date', descending: true)
        .limit(safeLimit)
        .get();
    return snap.docs
        .map((d) => ProgressEntry.fromFirestore(d.data()))
        .toList();
  }

  static Stream<List<ProgressEntry>> progressStream(String uid) {
    final sevenAgo =
        DateTime.now().subtract(const Duration(days: 7)).toIso8601String();
    return _userDoc(uid)
        .collection('copilot_progress')
        .where('date', isGreaterThan: sevenAgo)
        .orderBy('date', descending: false)
        .snapshots()
        .map((s) =>
            s.docs.map((d) => ProgressEntry.fromFirestore(d.data())).toList());
  }

  // ════════════════════════════════════════════════════════════════════════
  // ─── STRUCTURED EVENT LAYER ────────────────────────────────────────────
  // ════════════════════════════════════════════════════════════════════════

  static DocumentReference<Map<String, dynamic>> _copilotDoc(
          String uid, String docId) =>
      _userDoc(uid).collection('copilot').doc(docId);

  static DocumentReference<Map<String, dynamic>> _eventDoc(
          String uid, String careerId, String eventId) =>
      _userDoc(uid)
          .collection('copilot_learning_progress')
          .doc(careerId)
          .collection('events')
          .doc(eventId);

  static CollectionReference<Map<String, dynamic>> _eventsCol(
          String uid, String careerId) =>
      _userDoc(uid)
          .collection('copilot_learning_progress')
          .doc(careerId)
          .collection('events');

  /// Canonical, career-agnostic goal-completion record. Used as the
  /// single authoritative idempotency identity for goal XP and the
  /// lifetime totalGoalsCompleted counter, independent of careerId
  /// availability.
  static DocumentReference<Map<String, dynamic>> _goalEventDoc(
          String uid, String eventId) =>
      _userDoc(uid).collection('copilot_goal_events').doc(eventId);

  static Map<String, dynamic> _boundedMetadata(Map<String, dynamic>? raw) {
    if (raw == null || raw.isEmpty) return const <String, dynamic>{};

    final out = <String, dynamic>{};
    for (final entry in raw.entries) {
      if (out.length >= _maxMetadataKeys) break;
      final key = entry.key;
      if (key is! String || key.isEmpty) continue;
      final safeKey = key.length > _maxMetadataKeyLen
          ? key.substring(0, _maxMetadataKeyLen)
          : key;

      final v = entry.value;
      if (v == null) continue;

      if (v is String) {
        final trimmed = v.trim();
        if (trimmed.isEmpty) continue;
        out[safeKey] = trimmed.length > _maxMetadataStringLen
            ? trimmed.substring(0, _maxMetadataStringLen)
            : trimmed;
      } else if (v is num) {
        final d = v.toDouble();
        if (d.isNaN || d.isInfinite) continue;
        out[safeKey] = v;
      } else if (v is bool) {
        out[safeKey] = v;
      }
    }
    return out;
  }

  static Future<void> _commitChunked(List<_BatchOp> ops) async {
    if (ops.isEmpty) return;
    for (var i = 0; i < ops.length; i += _batchChunkSize) {
      final end = (i + _batchChunkSize < ops.length)
          ? i + _batchChunkSize
          : ops.length;
      final batch = _db.batch();
      for (var j = i; j < end; j++) {
        ops[j].applyTo(batch);
      }
      await batch.commit();
    }
  }

  // ── Career Context ──────────────────────────────────────────────────────

  static Future<void> saveCareerContext(String uid, CareerContext career) =>
      _copilotDoc(uid, 'career_context')
          .set(career.toFirestore(), SetOptions(merge: true));

  static Future<CareerContext?> getCareerContext(String uid) async {
    final snap = await _copilotDoc(uid, 'career_context').get();
    if (!snap.exists || snap.data() == null) return null;
    return CareerContext.fromFirestore(snap.data()!);
  }

  static Stream<CareerContext?> careerContextStream(String uid) =>
      _copilotDoc(uid, 'career_context').snapshots().map((s) =>
          s.exists && s.data() != null
              ? CareerContext.fromFirestore(s.data()!)
              : null);

  // ── Learning Progress ───────────────────────────────────────────────────

  static DocumentReference<Map<String, dynamic>> _learningProgressDoc(
          String uid, String careerId) =>
      _userDoc(uid).collection('copilot_learning_progress').doc(careerId);

  /// Writes only the current-state fields of a [LearningProgressContext].
  /// Historical arrays are NOT touched, so concurrent appends via
  /// appendCompletedLesson() and recordCourseEvent() cannot be clobbered
  /// by a stale snapshot.
  static Future<void> saveLearningProgress(
          String uid, LearningProgressContext progress) async {
    final safeCareerId = _safeId(progress.careerId);
    if (safeCareerId.isEmpty) return;
    final ref = _learningProgressDoc(uid, safeCareerId);
    final data = <String, dynamic>{
      'careerId': safeCareerId,
      'totalLessons': progress.totalLessons,
      'currentLevelTitle': progress.currentLevelTitle,
      'lastLessonId': progress.lastLessonId,
      'updatedAt': progress.updatedAt.toIso8601String(),
    };
    await ref.set(data, SetOptions(merge: true));
  }

  /// Explicit FULL snapshot write — including historical arrays. Only for
  /// maintenance/migration flows that have freshly re-read the document.
  static Future<void> saveLearningProgressSnapshot(
          String uid, LearningProgressContext progress) async {
    final safeCareerId = _safeId(progress.careerId);
    if (safeCareerId.isEmpty) return;
    await _learningProgressDoc(uid, safeCareerId)
        .set(progress.toFirestore(), SetOptions(merge: true));
  }

  static Future<LearningProgressContext?> getLearningProgress(
      String uid, String careerId) async {
    final safeCareerId = _safeId(careerId);
    if (safeCareerId.isEmpty) return null;
    final snap = await _learningProgressDoc(uid, safeCareerId).get();
    if (!snap.exists || snap.data() == null) return null;
    return LearningProgressContext.fromFirestore(snap.data()!);
  }

  static Stream<LearningProgressContext?> learningProgressStream(
      String uid, String careerId) {
    final safeCareerId = _safeId(careerId);
    if (safeCareerId.isEmpty) {
      return const Stream<LearningProgressContext?>.empty();
    }
    return _learningProgressDoc(uid, safeCareerId).snapshots().map((s) =>
        s.exists && s.data() != null
            ? LearningProgressContext.fromFirestore(s.data()!)
            : null);
  }

  /// Appends a completed lesson id and writes the structured lesson event
  /// in ONE transaction. All reads happen before all writes.
  ///
  /// Idempotency:
  ///   • The structured event document is the idempotency authority.
  ///   • If it already exists, the transaction writes only the
  ///     arrayUnion onto the learning-progress document; the event doc
  ///     (and its recordedAt) is left untouched.
  ///   • Retries and concurrent calls cannot duplicate the event.
  static Future<void> appendCompletedLesson(
    String uid, {
    required String careerId,
    required String lessonId,
    int? totalLessons,
    String? currentLevelTitle,
  }) async {
    if (careerId.isEmpty || lessonId.isEmpty) return;

    final safeCareerId = _safeId(careerId);
    final safeLessonId = _safeId(lessonId);
    if (safeCareerId.isEmpty || safeLessonId.isEmpty) return;

    final learningRef = _learningProgressDoc(uid, safeCareerId);
    final eventId     = 'lesson:$safeLessonId';
    final eventRef    = _eventDoc(uid, safeCareerId, eventId);

    await _db.runTransaction((tx) async {
      // READ
      final eventSnap = await tx.get(eventRef);
      final eventExists = eventSnap.exists;

      // COMPUTE
      final data = <String, dynamic>{
        'careerId': safeCareerId,
        'completedLessonIds': FieldValue.arrayUnion([safeLessonId]),
        'lastLessonId': safeLessonId,
        'updatedAt': DateTime.now().toIso8601String(),
      };
      if (totalLessons != null) data['totalLessons'] = totalLessons;
      if (currentLevelTitle != null) {
        data['currentLevelTitle'] = currentLevelTitle;
      }

      // WRITE
      tx.set(learningRef, data, SetOptions(merge: true));

      if (!eventExists) {
        tx.set(eventRef, {
          'eventId': eventId,
          'eventType': CopilotEventType.lesson,
          'careerId': safeCareerId,
          'topic': currentLevelTitle,
          'correct': null,
          'xp': 0,
          'metadata': _boundedMetadata({
            'lessonId': safeLessonId,
            if (totalLessons != null) 'totalLessons': totalLessons,
            if (currentLevelTitle != null)
              'currentLevelTitle': currentLevelTitle,
          }),
          'recordedAt': DateTime.now().toIso8601String(),
        });
      }
    });
  }

  /// Persists ONE course learning event.
  ///
  /// The structured event document is the PRIMARY idempotency authority.
  /// The transaction reads the event document FIRST, then writes. If the
  /// event already exists, the whole call is a no-op — no XP, no array
  /// update, no timestamp rewrite. Retries and concurrent calls cannot
  /// duplicate the event, the XP, or the evidence arrays.
  ///
  /// RESULT
  ///   • Returns `true` when THIS call newly recorded the event and
  ///     therefore awarded XP inside the transaction.
  ///   • Returns `false` when the event already existed (idempotent
  ///     no-op) or when the inputs were invalid — nothing was recorded
  ///     and nothing should be awarded.
  ///
  /// Firestore remains the SOLE XP authority. Callers must not add XP
  /// logic of their own based on this result.
  static Future<bool> recordCourseEvent(
    String uid, {
    required String careerId,
    required String eventId,
    required int xpReward,
    String? eventType,
    String? topic,
    bool? correct,
  }) async {
    if (careerId.isEmpty || eventId.isEmpty) return false;

    final safeCareerId = _safeId(careerId);
    final safeEventId  = _safeId(eventId);
    if (safeCareerId.isEmpty || safeEventId.isEmpty) return false;

    final learningRef = _learningProgressDoc(uid, safeCareerId);
    final userRef     = _userDoc(uid);
    final eventRef    = _eventDoc(uid, safeCareerId, safeEventId);

    final resolvedEventType = eventType ??
        (safeEventId.startsWith('quiz:')
            ? CopilotEventType.quiz
            : safeEventId.startsWith('challenge:')
                ? CopilotEventType.challenge
                : safeEventId.startsWith('project:')
                    ? CopilotEventType.project
                    : safeEventId.startsWith('lesson:')
                        ? CopilotEventType.lesson
                        : CopilotEventType.topicEvidence);

    return _db.runTransaction<bool>((tx) async {
      // READ
      final eventSnap = await tx.get(eventRef);
      if (eventSnap.exists) return false; // already recorded — no-op

      // WRITE
      tx.set(eventRef, {
        'eventId': safeEventId,
        'eventType': resolvedEventType,
        'careerId': safeCareerId,
        'topic': topic,
        'correct': correct,
        'xp': xpReward,
        'metadata': const <String, dynamic>{},
        'recordedAt': DateTime.now().toIso8601String(),
      });

      tx.set(
        learningRef,
        {
          'careerId': safeCareerId,
          'completedCourseEventIds': FieldValue.arrayUnion([safeEventId]),
          'courseEvidenceIds': FieldValue.arrayUnion([safeEventId]),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        SetOptions(merge: true),
      );

      if (xpReward > 0) {
        tx.set(
          userRef,
          {'totalXp': FieldValue.increment(xpReward)},
          SetOptions(merge: true),
        );
      }

      return true;
    });
  }

  /// Generic structured career-evidence writer. Reads before writes.
  /// Returns the transaction result directly, so Firestore retries cannot
  /// desynchronize an outer variable.
  static Future<bool> recordCareerEvent(
    String uid, {
    required String careerId,
    required String eventId,
    required String eventType,
    required DateTime recordedAt,
    String? topic,
    bool? correct,
    int xpReward = 0,
    Map<String, dynamic>? metadata,
  }) async {
    if (careerId.isEmpty || eventId.isEmpty || eventType.isEmpty) {
      return false;
    }

    final safeCareerId = _safeId(careerId);
    final safeEventId  = _safeId(eventId);
    if (safeCareerId.isEmpty || safeEventId.isEmpty) return false;

    final eventRef = _eventDoc(uid, safeCareerId, safeEventId);
    final userRef  = _userDoc(uid);

    return _db.runTransaction<bool>((tx) async {
      // READ
      final snap = await tx.get(eventRef);
      if (snap.exists) return false; // already recorded

      // WRITE
      tx.set(eventRef, {
        'eventId': safeEventId,
        'eventType': eventType,
        'careerId': safeCareerId,
        'topic': topic,
        'correct': correct,
        'xp': xpReward,
        'metadata': _boundedMetadata(metadata),
        'recordedAt': recordedAt.toIso8601String(),
      });

      if (xpReward > 0) {
        tx.set(
          userRef,
          {'totalXp': FieldValue.increment(xpReward)},
          SetOptions(merge: true),
        );
      }

      return true;
    });
  }

  static Future<List<Map<String, dynamic>>> getCareerEvents(
    String uid,
    String careerId, {
    String? eventType,
    int limit = 50,
  }) async {
    final safeCareerId = _safeId(careerId);
    if (safeCareerId.isEmpty) return const [];
    final safeLimit = limit <= 0 ? 50 : (limit > 200 ? 200 : limit);

    Query<Map<String, dynamic>> q = _eventsCol(uid, safeCareerId);
    if (eventType != null && eventType.isNotEmpty) {
      q = q.where('eventType', isEqualTo: eventType);
    }
    q = q.orderBy('recordedAt', descending: true).limit(safeLimit);

    final snap = await q.get();
    return snap.docs.map((d) => d.data()).toList();
  }

  static Future<Map<String, dynamic>?> getCareerEvent(
    String uid,
    String careerId,
    String eventId,
  ) async {
    final safeCareerId = _safeId(careerId);
    final safeEventId  = _safeId(eventId);
    if (safeCareerId.isEmpty || safeEventId.isEmpty) return null;
    final snap = await _eventDoc(uid, safeCareerId, safeEventId).get();
    if (!snap.exists || snap.data() == null) return null;
    return snap.data();
  }

  // ── Project Progress ────────────────────────────────────────────────────

  static Future<void> saveProjectProgress(
          String uid, ProjectProgressContext progress) =>
      _copilotDoc(uid, 'project_progress')
          .set(progress.toFirestore(), SetOptions(merge: true));

  static Future<ProjectProgressContext?> getProjectProgress(
      String uid) async {
    final snap = await _copilotDoc(uid, 'project_progress').get();
    if (!snap.exists || snap.data() == null) return null;
    return ProjectProgressContext.fromFirestore(snap.data()!);
  }

  static Stream<ProjectProgressContext?> projectProgressStream(
          String uid) =>
      _copilotDoc(uid, 'project_progress').snapshots().map((s) =>
          s.exists && s.data() != null
              ? ProjectProgressContext.fromFirestore(s.data()!)
              : null);

  /// Appends a completed project and, when a real [careerId] is supplied,
  /// writes the structured project event — atomically.
  ///
  /// Idempotency:
  ///   • The structured event document (when a careerId is present) is
  ///     the idempotency authority for the event layer.
  ///   • The progress document uses FieldValue.arrayUnion, so repeated
  ///     calls cannot duplicate the project id in the historical array.
  ///   • When no careerId is present, no event document is written (no
  ///     fake bucket); the arrayUnion remains idempotent by construction.
  static Future<void> appendCompletedProject(
    String uid,
    String projectId, {
    int? totalProjects,
    String? currentProjectId,
    String? careerId,
  }) async {
    final safeProjectId = _safeId(projectId);
    if (safeProjectId.isEmpty) return;

    final progressRef = _copilotDoc(uid, 'project_progress');
    final resolvedCareerId =
        (careerId != null && careerId.isNotEmpty) ? _safeId(careerId) : null;
    final hasCareer = resolvedCareerId != null && resolvedCareerId.isNotEmpty;

    final eventId  = 'project:$safeProjectId';
    final eventRef = hasCareer
        ? _eventDoc(uid, resolvedCareerId, eventId)
        : null;

    await _db.runTransaction((tx) async {
      // READ
      final eventSnap = eventRef != null ? await tx.get(eventRef) : null;
      final eventExists = eventSnap != null && eventSnap.exists;

      // WRITE
      final progressData = <String, dynamic>{
        'completedProjectIds': FieldValue.arrayUnion([safeProjectId]),
        'updatedAt': DateTime.now().toIso8601String(),
      };
      if (totalProjects != null) progressData['totalProjects'] = totalProjects;
      if (currentProjectId != null) {
        progressData['currentProjectId'] = currentProjectId;
      }
      tx.set(progressRef, progressData, SetOptions(merge: true));

      if (eventRef != null && !eventExists) {
        tx.set(eventRef, {
          'eventId': eventId,
          'eventType': CopilotEventType.project,
          'careerId': resolvedCareerId,
          'topic': null,
          'correct': null,
          'xp': 0,
          'metadata': _boundedMetadata({
            'projectId': safeProjectId,
            if (totalProjects != null) 'totalProjects': totalProjects,
            if (currentProjectId != null)
              'currentProjectId': currentProjectId,
          }),
          'recordedAt': DateTime.now().toIso8601String(),
        });
      }
    });
  }

  // ── Job Progress ────────────────────────────────────────────────────────

  static Future<void> saveJobProgress(String uid, JobProgressContext progress) =>
      _copilotDoc(uid, 'job_progress')
          .set(progress.toFirestore(), SetOptions(merge: true));

  static Future<JobProgressContext?> getJobProgress(String uid) async {
    final snap = await _copilotDoc(uid, 'job_progress').get();
    if (!snap.exists || snap.data() == null) return null;
    return JobProgressContext.fromFirestore(snap.data()!);
  }

  static Stream<JobProgressContext?> jobProgressStream(String uid) =>
      _copilotDoc(uid, 'job_progress').snapshots().map((s) =>
          s.exists && s.data() != null
              ? JobProgressContext.fromFirestore(s.data()!)
              : null);

  /// Appends an applied job and, when a real [careerId] is supplied,
  /// writes the structured jobApplication event — atomically.
  ///
  /// Idempotency: arrayUnion on the historical array plus event-existence
  /// check inside the same transaction. Retries cannot duplicate.
  static Future<void> appendAppliedJob(
    String uid,
    String jobId, {
    String? careerId,
  }) async {
    final safeJobId = _safeId(jobId);
    if (safeJobId.isEmpty) return;

    final progressRef = _copilotDoc(uid, 'job_progress');
    final resolvedCareerId =
        (careerId != null && careerId.isNotEmpty) ? _safeId(careerId) : null;
    final hasCareer = resolvedCareerId != null && resolvedCareerId.isNotEmpty;

    final eventId  = 'jobApplication:$safeJobId';
    final eventRef = hasCareer
        ? _eventDoc(uid, resolvedCareerId, eventId)
        : null;

    await _db.runTransaction((tx) async {
      // READ
      final eventSnap = eventRef != null ? await tx.get(eventRef) : null;
      final eventExists = eventSnap != null && eventSnap.exists;

      // WRITE
      tx.set(
        progressRef,
        {
          'appliedJobIds': FieldValue.arrayUnion([safeJobId]),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        SetOptions(merge: true),
      );

      if (eventRef != null && !eventExists) {
        tx.set(eventRef, {
          'eventId': eventId,
          'eventType': CopilotEventType.jobApplication,
          'careerId': resolvedCareerId,
          'topic': null,
          'correct': null,
          'xp': 0,
          'metadata': _boundedMetadata({'jobId': safeJobId}),
          'recordedAt': DateTime.now().toIso8601String(),
        });
      }
    });
  }

  static Future<void> appendSavedJob(String uid, String jobId) async {
    final safeJobId = _safeId(jobId);
    if (safeJobId.isEmpty) return;
    await _copilotDoc(uid, 'job_progress').set({
      'savedJobIds': FieldValue.arrayUnion([safeJobId]),
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  static Future<void> incrementJobOffers(String uid, {int by = 1}) async {
    await _copilotDoc(uid, 'job_progress').set({
      'offersReceived': FieldValue.increment(by),
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  // ── Interview Progress ──────────────────────────────────────────────────

  static Future<void> saveInterviewProgress(
          String uid, InterviewProgressContext progress) =>
      _copilotDoc(uid, 'interview_progress')
          .set(progress.toFirestore(), SetOptions(merge: true));

  static Future<InterviewProgressContext?> getInterviewProgress(
      String uid) async {
    final snap = await _copilotDoc(uid, 'interview_progress').get();
    if (!snap.exists || snap.data() == null) return null;
    return InterviewProgressContext.fromFirestore(snap.data()!);
  }

  static Stream<InterviewProgressContext?> interviewProgressStream(
          String uid) =>
      _copilotDoc(uid, 'interview_progress').snapshots().map((s) =>
          s.exists && s.data() != null
              ? InterviewProgressContext.fromFirestore(s.data()!)
              : null);

  /// Appends a completed interview and, when a real [careerId] is supplied,
  /// writes the structured interview event — atomically.
  ///
  /// Idempotency:
  ///   • The interview progress document tracks completedInterviewIds;
  ///     a repeated call with the same interviewId is a no-op for
  ///     mockInterviewsDone and averageScore.
  ///   • The structured event document (when a careerId exists) is the
  ///     idempotency authority for the event layer and is not rewritten
  ///     on retries.
  static Future<void> appendCompletedInterview(
    String uid,
    String interviewId, {
    double? score,
    String? careerId,
  }) async {
    final safeInterviewId = _safeId(interviewId);
    if (safeInterviewId.isEmpty) return;

    final progressRef = _copilotDoc(uid, 'interview_progress');
    final resolvedCareerId =
        (careerId != null && careerId.isNotEmpty) ? _safeId(careerId) : null;
    final hasCareer = resolvedCareerId != null && resolvedCareerId.isNotEmpty;

    final eventId  = 'interview:$safeInterviewId';
    final eventRef = hasCareer
        ? _eventDoc(uid, resolvedCareerId, eventId)
        : null;

    await _db.runTransaction((tx) async {
      // READ
      final progressSnap = await tx.get(progressRef);
      final eventSnap = eventRef != null ? await tx.get(eventRef) : null;

      final eventExists = eventSnap != null && eventSnap.exists;

      // COMPUTE
      final current = (progressSnap.exists && progressSnap.data() != null)
          ? InterviewProgressContext.fromFirestore(progressSnap.data()!)
          : InterviewProgressContext(updatedAt: DateTime.now());

      final alreadyRecorded =
          current.completedInterviewIds.contains(safeInterviewId);

      // WRITE
      if (!alreadyRecorded) {
        final updated =
            current.withInterviewCompleted(safeInterviewId, score: score);
        tx.set(
          progressRef,
          updated.toFirestore(),
          SetOptions(merge: true),
        );
      }

      if (eventRef != null && !eventExists) {
        tx.set(eventRef, {
          'eventId': eventId,
          'eventType': CopilotEventType.interview,
          'careerId': resolvedCareerId,
          'topic': null,
          'correct': null,
          'xp': 0,
          'metadata': _boundedMetadata({
            if (score != null) 'score': score,
            'interviewId': safeInterviewId,
          }),
          'recordedAt': DateTime.now().toIso8601String(),
        });
      }
    });
  }

  // ── Career Readiness ────────────────────────────────────────────────────

  static Future<void> saveCareerReadiness(
          String uid, CareerReadiness readiness) =>
      _copilotDoc(uid, 'readiness')
          .set(readiness.toFirestore(), SetOptions(merge: true));

  static Future<CareerReadiness?> getCareerReadiness(String uid) async {
    final snap = await _copilotDoc(uid, 'readiness').get();
    if (!snap.exists || snap.data() == null) return null;
    return CareerReadiness.fromFirestore(snap.data()!);
  }

  static Stream<CareerReadiness?> careerReadinessStream(String uid) =>
      _copilotDoc(uid, 'readiness').snapshots().map((s) =>
          s.exists && s.data() != null
              ? CareerReadiness.fromFirestore(s.data()!)
              : null);

  // ── Next Best Actions ───────────────────────────────────────────────────

  static Future<void> saveNextAction(String uid, NextBestAction action) =>
      _userDoc(uid)
          .collection('copilot_next_actions')
          .doc(action.id)
          .set(action.toFirestore(), SetOptions(merge: true));

  static Future<List<NextBestAction>> getNextActions(
    String uid, {
    bool onlyPending = false,
    int limit = 50,
  }) async {
    final safeLimit = limit <= 0 ? 50 : (limit > 200 ? 200 : limit);

    Query<Map<String, dynamic>> q =
        _userDoc(uid).collection('copilot_next_actions');
    if (onlyPending) q = q.where('isCompleted', isEqualTo: false);
    q = q.orderBy('priority').limit(safeLimit);

    final snap = await q.get();
    final actions =
        snap.docs.map((d) => NextBestAction.fromFirestore(d.data())).toList();
    actions.sort((a, b) => a.priority.compareTo(b.priority));
    return actions;
  }

  static Stream<List<NextBestAction>> nextActionsStream(
    String uid, {
    bool onlyPending = false,
    int limit = 50,
  }) {
    final safeLimit = limit <= 0 ? 50 : (limit > 200 ? 200 : limit);

    Query<Map<String, dynamic>> q =
        _userDoc(uid).collection('copilot_next_actions');
    if (onlyPending) q = q.where('isCompleted', isEqualTo: false);
    q = q.orderBy('priority').limit(safeLimit);

    return q.snapshots().map((s) {
      final actions =
          s.docs.map((d) => NextBestAction.fromFirestore(d.data())).toList();
      actions.sort((a, b) => a.priority.compareTo(b.priority));
      return actions;
    });
  }

  static Future<void> completeNextAction(String uid, String actionId) async {
    await _userDoc(uid)
        .collection('copilot_next_actions')
        .doc(actionId)
        .set({'isCompleted': true}, SetOptions(merge: true));
  }

  // ── Copilot Recommendations ─────────────────────────────────────────────

  static Future<void> saveRecommendation(
          String uid, CopilotRecommendation recommendation) =>
      _userDoc(uid)
          .collection('copilot_recommendations')
          .doc(recommendation.id)
          .set(recommendation.toFirestore(), SetOptions(merge: true));

  static Future<List<CopilotRecommendation>> getRecommendations(
    String uid, {
    bool onlyActive = false,
    int limit = 50,
  }) async {
    final safeLimit = limit <= 0 ? 50 : (limit > 200 ? 200 : limit);

    Query<Map<String, dynamic>> q =
        _userDoc(uid).collection('copilot_recommendations');
    if (onlyActive) q = q.where('isDismissed', isEqualTo: false);
    q = q.orderBy('priority').limit(safeLimit);

    final snap = await q.get();
    final recs = snap.docs
        .map((d) => CopilotRecommendation.fromFirestore(d.data()))
        .toList();
    recs.sort((a, b) => a.priority.compareTo(b.priority));
    return recs;
  }

  static Stream<List<CopilotRecommendation>> recommendationsStream(
    String uid, {
    bool onlyActive = false,
    int limit = 50,
  }) {
    final safeLimit = limit <= 0 ? 50 : (limit > 200 ? 200 : limit);

    Query<Map<String, dynamic>> q =
        _userDoc(uid).collection('copilot_recommendations');
    if (onlyActive) q = q.where('isDismissed', isEqualTo: false);
    q = q.orderBy('priority').limit(safeLimit);

    return q.snapshots().map((s) {
      final recs = s.docs
          .map((d) => CopilotRecommendation.fromFirestore(d.data()))
          .toList();
      recs.sort((a, b) => a.priority.compareTo(b.priority));
      return recs;
    });
  }

  static Future<void> dismissRecommendation(
      String uid, String recommendationId) async {
    await _userDoc(uid)
        .collection('copilot_recommendations')
        .doc(recommendationId)
        .set({'isDismissed': true}, SetOptions(merge: true));
  }

  // ── Composite Copilot Context ───────────────────────────────────────────

  static Future<CopilotContext> getCopilotContext(
    String uid, {
    String? careerId,
  }) async {
    final results = await Future.wait([
      getSkillProfile(uid),
      getSkillGaps(uid),
      getRoadmap(uid),
      getTodayGoals(uid),
      getProgressHistory(uid),
      getCareerContext(uid),
      getProjectProgress(uid),
      getJobProgress(uid),
      getInterviewProgress(uid),
      getCareerReadiness(uid),
      getNextActions(uid),
      getRecommendations(uid),
    ]);

    final skillProfile    = results[0]  as UserSkillProfile?;
    final skillGaps       = results[1]  as List<SkillGap>;
    final roadmap         = results[2]  as PersonalizedRoadmap?;
    final todayGoals      = results[3]  as List<DailyGoal>;
    final progressHistory = results[4]  as List<ProgressEntry>;
    final career          = results[5]  as CareerContext?;
    final projectProgress = results[6]  as ProjectProgressContext?;
    final jobProgress     = results[7]  as JobProgressContext?;
    final interviewProgress = results[8] as InterviewProgressContext?;
    final readiness       = results[9]  as CareerReadiness?;
    final nextActions     = results[10] as List<NextBestAction>;
    final recommendations = results[11] as List<CopilotRecommendation>;

    // Career-scoped learning progress: resolved through the same
    // normalization used by its writer, so a careerId that was stored
    // via _safeId() will resolve to the same document on read.
    final resolvedCareerId = careerId ?? career?.careerId;
    final safeCareerId = (resolvedCareerId != null &&
            resolvedCareerId.isNotEmpty)
        ? _safeId(resolvedCareerId)
        : '';

    final learningProgress = safeCareerId.isNotEmpty
        ? await getLearningProgress(uid, safeCareerId)
        : null;

    final state = CopilotState(
      skillProfile: skillProfile,
      skillGaps: skillGaps,
      roadmap: roadmap,
      todayGoals: todayGoals,
      progressHistory: progressHistory,
    );

    return CopilotContext(
      state: state,
      career: career,
      learningProgress: learningProgress,
      projectProgress: projectProgress,
      jobProgress: jobProgress,
      interviewProgress: interviewProgress,
      readiness: readiness,
      nextActions: nextActions,
      recommendations: recommendations,
    );
  }

  /// Persists the current-state side of a [CopilotContext].
  ///
  /// Historical arrays (learning progress arrays, project/job/interview
  /// histories) are intentionally NOT written by this method — they are
  /// extended only by their dedicated append* / record* writers using
  /// atomic arrayUnion + event-existence checks. This prevents a stale
  /// snapshot from clobbering newer concurrent data.
  static Future<void> saveCopilotContext(
    String uid,
    CopilotContext context,
  ) async {
    final futures = <Future<void>>[];

    if (context.state.skillProfile != null) {
      futures.add(saveSkillProfile(context.state.skillProfile!));
    }
    if (context.state.roadmap != null) {
      futures.add(saveRoadmap(context.state.roadmap!));
    }
    if (context.career != null) {
      futures.add(saveCareerContext(uid, context.career!));
    }
    if (context.learningProgress.careerId.isNotEmpty) {
      // saveLearningProgress writes only current-state fields; historical
      // arrays are left untouched.
      futures.add(saveLearningProgress(uid, context.learningProgress));
    }

    // Progress contexts are written as current-state documents. Their
    // historical arrays (completedProjectIds, appliedJobIds,
    // completedInterviewIds, ...) are owned by the dedicated append*
    // writers and are never clobbered here.
    futures.add(saveProjectProgress(uid, context.projectProgress));
    futures.add(saveJobProgress(uid, context.jobProgress));
    futures.add(saveInterviewProgress(uid, context.interviewProgress));
    futures.add(saveCareerReadiness(uid, context.readiness));

    await Future.wait(futures);
  }
}

// ── Internal batch-op helper ──────────────────────────────────────────────

class _BatchOp {
  final DocumentReference<Map<String, dynamic>> ref;
  final Map<String, dynamic>? data;
  final bool isDelete;

  const _BatchOp._({
    required this.ref,
    this.data,
    required this.isDelete,
  });

  factory _BatchOp.set(
          DocumentReference<Map<String, dynamic>> ref,
          Map<String, dynamic> data) =>
      _BatchOp._(ref: ref, data: data, isDelete: false);

  factory _BatchOp.delete(DocumentReference<Map<String, dynamic>> ref) =>
      _BatchOp._(ref: ref, isDelete: true);

  void applyTo(WriteBatch batch) {
    if (isDelete) {
      batch.delete(ref);
    } else if (data != null) {
      batch.set(ref, data!, SetOptions(merge: true));
    }
  }
}