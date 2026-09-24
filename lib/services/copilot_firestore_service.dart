// ═══════════════════════════════════════════════════════════════════════════
// lib/services/copilot_firestore_service.dart
// Firestore CRUD for every copilot collection.
//
// PRODUCTION V2 — Career-Isolated / Backward-Compatible — MODEL CONTRACT v1
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
// GOAL COMPLETION IDENTITY
// ───────────────────────────────────────────────────────────────────────────
// Career-scoped goal completions use a career-specific canonical id:
//
//     {careerId}__goal_{goalId}
//
// This prevents the same authored goal id from consuming another career's
// completion/XP. The original goal:{goalId} document remains the legacy
// compatibility path when no real careerId is available.
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
// CAREER-ISOLATED LEGACY FALLBACKS (PHASE 1 HARDENING)
// ───────────────────────────────────────────────────────────────────────────
// Every career-scoped getter that falls back to a legacy (pre-career-scoping)
// document must verify that legacy document genuinely belongs to the
// resolved career before returning it. getRoadmap(), getProjectProgress(),
// getJobProgress(), getInterviewProgress(), and getCareerReadiness() already
// enforced this. getSkillProfile() now enforces the identical guard: when a
// specific career is active but has no career-scoped profile saved yet, the
// legacy global profile is returned ONLY if its own targetRole resolves to
// that same career id. This prevents a different career's legacy profile
// from silently leaking into the active career's context. The storage layer
// — not the UI — enforces this boundary.
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
// • getCopilotContext() resolves the active career first, then reads every
//   career-scoped source using that same career identity; legacy global data
//   is used only as an explicit compatibility fallback.
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
  static String _safeId(String? raw) {
    final t = (raw ?? '').trim();
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

  /// Backward-compatible writer.
  ///
  /// New writes are career-scoped. The career comes from the profile's
  /// targetRole; the old global document is only read as a legacy fallback.
  static Future<void> saveSkillProfile(UserSkillProfile profile) async {
    if (profile.uid.isEmpty) return;
    final careerId = profile.targetRole.careerId;
    if (careerId.isNotEmpty) {
      await saveCareerSkillProfile(profile, careerId);
      return;
    }

    // Compatibility for older profiles that genuinely have no career id.
    await _userDoc(profile.uid)
        .collection('copilot')
        .doc('skill_profile')
        .set(profile.toFirestore(), SetOptions(merge: true));
  }

  /// Reads the active career profile when the active career is known.
  /// Falls back to the legacy global profile only when no active career
  /// context can be resolved.
  ///
  /// CAREER-ISOLATION GUARD (Phase 1 hardening):
  /// When a specific career IS active but has no career-scoped profile
  /// saved yet, the legacy global profile is returned ONLY if it
  /// genuinely belongs to that same career (its own targetRole resolves
  /// to the same careerId). This mirrors the identical guard already
  /// enforced by getRoadmap(), getProjectProgress(), getJobProgress(),
  /// getInterviewProgress() and getCareerReadiness() — a different
  /// career's legacy profile must never leak into this career's context.
  static Future<UserSkillProfile?> getSkillProfile(String uid) async {
    final career = await getCareerContext(uid);
    final careerId = career?.careerId;
    if (careerId != null && careerId.isNotEmpty) {
      final scoped = await getCareerSkillProfile(uid, careerId);
      if (scoped != null) return scoped;
    }

    final snap = await _userDoc(uid)
        .collection('copilot')
        .doc('skill_profile')
        .get();
    if (!snap.exists || snap.data() == null) return null;
    final legacy = UserSkillProfile.fromFirestore(snap.data()!);

    if (careerId != null && careerId.isNotEmpty) {
      // Guard: only honour the legacy fallback when it truly belongs to
      // the currently active career.
      return legacy.targetRole.careerId == careerId ? legacy : null;
    }
    return legacy;
  }

  /// Stream of the active career profile. Legacy global data is used only
  /// when the active career has no scoped profile yet.
  static Stream<UserSkillProfile?> skillProfileStream(String uid) {
    return careerContextStream(uid).asyncExpand((career) {
      final careerId = career?.careerId;
      if (careerId != null && careerId.isNotEmpty) {
        return _careerCopilotDoc(uid, 'skill_profile', careerId)
            .snapshots()
            .map((s) => s.exists && s.data() != null
                ? UserSkillProfile.fromFirestore(s.data()!)
                : null);
      }
      return _userDoc(uid)
          .collection('copilot')
          .doc('skill_profile')
          .snapshots()
          .map((s) => s.exists && s.data() != null
              ? UserSkillProfile.fromFirestore(s.data()!)
              : null);
    });
  }

  /// Stores the editable skill profile for a specific career.
  ///
  /// This is a small current-state snapshot, not a second progress database.
  /// It lets a user switch:
  ///   Software Engineer -> Prompt Engineer -> Software Engineer
  /// and restore the Software Engineer profile that was active before.
  static Future<void> saveCareerSkillProfile(
    UserSkillProfile profile,
    String careerId,
  ) async {
    final safeCareerId = _safeId(careerId);
    if (profile.uid.isEmpty || safeCareerId.isEmpty) return;

    await _careerCopilotDoc(
      profile.uid,
      'skill_profile',
      safeCareerId,
    ).set(
      profile.toFirestore(),
      SetOptions(merge: true),
    );
  }

  static Future<UserSkillProfile?> getCareerSkillProfile(
    String uid,
    String careerId,
  ) async {
    final safeCareerId = _safeId(careerId);
    if (uid.isEmpty || safeCareerId.isEmpty) return null;

    final snap = await _careerCopilotDoc(
      uid,
      'skill_profile',
      safeCareerId,
    ).get();

    if (!snap.exists || snap.data() == null) return null;
    return UserSkillProfile.fromFirestore(snap.data()!);
  }

  // ── Skill Gaps ─────────────────────────────────────────────────────────────

  /// Saves the CURRENT skill-gap snapshot while also preserving an
  /// append-only assessment snapshot for historical analysis.
  ///
  /// The current collection remains backward compatible with the existing
  /// UI/read path. Historical snapshots are never deleted.
  /// KNOWN LIMITATION (documented, not fixed in this pass — see rationale
  /// below): the delete-existing + write-new sequence here is NOT wrapped
  /// in a single atomic transaction. Two genuinely concurrent calls to
  /// saveSkillGaps() for the SAME uid+career (e.g. two rapid re-analysis
  /// triggers) could theoretically interleave their query→delete→write
  /// steps. In practice this is low-risk and self-healing:
  ///   • Each gap's document id is deterministic
  ///     (`{careerId}__gap_{skillNameId}`), so two concurrent writes for
  ///     the SAME skill converge to the same document via merge — never
  ///     a duplicate.
  ///   • The only edge case is a gap present in an OLDER generation but
  ///     absent from a NEWER one surviving an interleaved delete — and
  ///     the very next analysis run (which always re-derives the full
  ///     gap set from current evidence) corrects it.
  /// A fully atomic fix would require restructuring this collection
  /// around a single per-career document (a larger schema change), which
  /// is not justified by the narrow, self-correcting risk above — see
  /// the "do not overengineer" principle in the standing contract.
  static Future<void> saveSkillGaps(
      String uid, List<SkillGap> gaps, {String? careerId}) async {
    if (uid.isEmpty) return;

    final resolvedCareerId = careerId ??
        (gaps.isEmpty ? '' : (gaps.first.careerId ?? ''));
    final safeCareerId = _safeId(resolvedCareerId);
    final col = _userDoc(uid).collection('copilot_skill_gaps');

    // New canonical writes always carry an explicit career id.
    final writes = <_BatchOp>[];

    if (safeCareerId.isNotEmpty) {
      final existing = await col
          .where('careerId', isEqualTo: safeCareerId)
          .get();

      for (final d in existing.docs) {
        writes.add(_BatchOp.delete(d.reference));
      }

      for (final gap in gaps) {
        final id = _safeId(gap.skillName);
        if (id.isEmpty) continue;
        final data = {
          ...gap.toFirestore(),
          'careerId': safeCareerId,
        };
        writes.add(
          _BatchOp.set(
            col.doc('${safeCareerId}__gap_$id'),
            data,
          ),
        );
      }
    } else {
      // Compatibility path for genuinely unscoped legacy data.
      final existing = await col.get();
      for (final d in existing.docs) {
        final existingCareer = d.data()['careerId'] as String? ?? '';
        if (existingCareer.isEmpty) {
          writes.add(_BatchOp.delete(d.reference));
        }
      }
      for (final gap in gaps) {
        final id = _safeId(gap.skillName);
        if (id.isNotEmpty) {
          writes.add(_BatchOp.set(col.doc('gap_$id'), gap.toFirestore()));
        }
      }
    }

    await _commitChunked(writes);

    // Historical snapshots are append-only and never deleted.
    final historyCol = _userDoc(uid).collection('copilot_skill_gap_history');
    final snapshotId =
        '${DateTime.now().toUtc().millisecondsSinceEpoch}_${safeCareerId.isEmpty ? 'general' : safeCareerId}';
    await historyCol.doc(snapshotId).set({
      'snapshotId': snapshotId,
      'recordedAt': DateTime.now().toUtc().toIso8601String(),
      'careerId': resolvedCareerId,
      'gaps': gaps.map((g) => g.toFirestore()).toList(),
    });
  }

  /// CAREER-ISOLATION HARDENING (Phase 2):
  /// When a real [careerId] is supplied, this now queries directly by
  /// `careerId` (a single-equality Firestore filter, no composite index
  /// required) instead of reading every gap the user has ever had across
  /// every career and filtering client-side — fewer reads, same result.
  ///
  /// When no career is resolved (`careerId` is null/empty), this
  /// previously returned EVERY stored gap regardless of which career it
  /// belonged to — silently blending multiple explicit careers' gaps
  /// together the moment more than one career had ever been used. That
  /// violated career isolation at the storage layer. It now returns only
  /// genuinely unscoped (legacy, pre-career-isolation) gaps — the same
  /// "missing/empty careerId = legacy" contract saveSkillGaps() already
  /// uses on write.
  static Future<List<SkillGap>> getSkillGaps(String uid, {String? careerId}) async {
    final col = _userDoc(uid).collection('copilot_skill_gaps');
    final safeCareerId = careerId == null ? '' : _safeId(careerId);

    if (safeCareerId.isNotEmpty) {
      final snap = await col.where('careerId', isEqualTo: safeCareerId).get();
      final items =
          snap.docs.map((d) => SkillGap.fromFirestore(d.data())).toList();
      items.sort((a, b) => a.priority.compareTo(b.priority));
      return items;
    }

    final snap = await col.orderBy('priority').get();
    return snap.docs
        .map((d) => SkillGap.fromFirestore(d.data()))
        .where((g) => g.careerId == null || g.careerId!.isEmpty)
        .toList();
  }

  // ── Personalized Roadmap ───────────────────────────────────────────────────

  static Future<void> saveRoadmap(PersonalizedRoadmap roadmap) =>
      _careerCopilotDoc(roadmap.uid, 'roadmap', roadmap.targetRole.careerId)
          .set(roadmap.toFirestore(), SetOptions(merge: true));

  static Future<PersonalizedRoadmap?> getRoadmap(String uid, {String? careerId}) async {
    var snap = await _careerCopilotDoc(uid, 'roadmap', careerId).get();
    if (snap.exists && snap.data() != null) return PersonalizedRoadmap.fromFirestore(snap.data()!);
    if (careerId != null && careerId.isNotEmpty) {
      snap = await _copilotDoc(uid, 'roadmap').get();
      if (snap.exists && snap.data() != null) {
        final legacy = PersonalizedRoadmap.fromFirestore(snap.data()!);
        if (legacy.targetRole.careerId == careerId) return legacy;
      }
    }
    return null;
  }

  static Stream<PersonalizedRoadmap?> roadmapStream(String uid, {String? careerId}) =>
      _careerCopilotDoc(uid, 'roadmap', careerId).snapshots().map((s) =>
          s.exists && s.data() != null
              ? PersonalizedRoadmap.fromFirestore(s.data()!)
              : null);

  /// Marks a roadmap phase complete inside a Firestore transaction.
  /// Read happens first; writes happen after.
  static Future<void> completeRoadmapPhase(
      String uid, int phaseIndex, {String? careerId}) async {
    final doc = _careerCopilotDoc(uid, 'roadmap', careerId);

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
      String uid, List<DailyGoal> goals, {String? careerId}) async {
    if (goals.isEmpty) return;
    final safeCareerId = careerId == null ? '' : _safeId(careerId);
    final writes = <_BatchOp>[
      for (final g in goals)
        _BatchOp.set(
          _userDoc(uid).collection('copilot_daily_goals').doc(g.id),
          {...g.toFirestore(), if (safeCareerId.isNotEmpty) 'careerId': safeCareerId},
        ),
    ];
    await _commitChunked(writes);
  }

  static Future<List<DailyGoal>> getTodayGoals(String uid, {String? careerId}) async {
    final snap = await _userDoc(uid)
        .collection('copilot_daily_goals')
        .where('date', isEqualTo: _todayKey())
        .get();
    final safeCareerId = careerId == null ? '' : _safeId(careerId);
    if (safeCareerId.isEmpty) {
      return snap.docs.map((d) => DailyGoal.fromFirestore(d.data())).toList();
    }
    return snap.docs
        .where((d) => _safeId(d.data()['careerId'] as String? ?? '') == safeCareerId)
        .map((d) => DailyGoal.fromFirestore(d.data()))
        .toList();
  }

  static Stream<List<DailyGoal>> todayGoalsStream(String uid, {String? careerId}) {
    return _userDoc(uid)
        .collection('copilot_daily_goals')
        .where('date', isEqualTo: _todayKey())
        .snapshots()
        .map((s) {
          final safeCareerId = careerId == null ? '' : _safeId(careerId);
          final docs = safeCareerId.isEmpty
              ? s.docs
              : s.docs.where((d) =>
                  _safeId(d.data()['careerId'] as String? ?? '') == safeCareerId);
          return docs.map((d) => DailyGoal.fromFirestore(d.data())).toList();
        });
  }

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

    // Career-scoped completions use career-scoped idempotency so the same
    // authored goal id can be completed independently in different careers.
    final resolvedCareerId =
        (careerId != null && careerId.isNotEmpty) ? _safeId(careerId) : null;
    final hasCareer = resolvedCareerId != null && resolvedCareerId.isNotEmpty;
    final safeGoalId = _safeId(goal.id);
    final canonicalEventId = hasCareer
        ? 'goal:${resolvedCareerId}:$safeGoalId'
        : 'goal:$safeGoalId';
    final canonicalRef = hasCareer
        ? _careerGoalEventDoc(uid, resolvedCareerId!, safeGoalId)
        : _goalEventDoc(uid, canonicalEventId);

    final careerEventRef = hasCareer
        ? _eventDoc(uid, resolvedCareerId, 'goal:$safeGoalId')
        : null;

    return _db.runTransaction<GoalToggleResult>((tx) async {
      // ── READ PHASE ─────────────────────────────────────────────────
      final goalSnap = await tx.get(goalRef);
      if (!goalSnap.exists || goalSnap.data() == null) {
        return GoalToggleResult.notToggled;
      }

      // Canonical completion record — the idempotency identity.
      final canonicalSnap = await tx.get(canonicalRef);

      // Career-side structured event (when a real careerId exists).
      final careerSnap = careerEventRef != null
          ? await tx.get(careerEventRef)
          : null;
      final careerEventExists = careerSnap != null && careerSnap.exists;
      final alreadyCompleted =
          (canonicalSnap.exists && canonicalSnap.data() != null) ||
          careerEventExists;

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
        if (hasCareer) {
          tx.set(
            _learningProgressDoc(uid, resolvedCareerId!),
            {
              'careerId': resolvedCareerId,
              'careerTotalXp': FieldValue.increment(reward),
              'updatedAt': DateTime.now().toIso8601String(),
            },
            SetOptions(merge: true),
          );
        }
      }

      if (shouldAwardCompletion) {
        // Lifetime counter — increments exactly once per canonical
        // completion record, independent of careerId availability.
        tx.set(
          userRef,
          {'totalGoalsCompleted': FieldValue.increment(1)},
          SetOptions(merge: true),
        );

        // Canonical completion record — career-scoped when a real career is
        // active; legacy global identity only for the no-career path.
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

  /// Live authoritative lifetime XP stream.
  ///
  /// Every XP source that writes the authoritative users/{uid}.totalXp
  /// field is reflected here immediately. UI/controller layers must use
  /// this stream instead of deriving lifetime XP from daily snapshots.
  static Stream<int> totalXpStream(String uid) {
    if (uid.isEmpty) return const Stream<int>.empty();
    return _userDoc(uid).snapshots().map((snap) {
      final raw = snap.data()?['totalXp'];
      if (raw is int) return raw < 0 ? 0 : raw;
      if (raw is num) {
        final value = raw.toInt();
        return value < 0 ? 0 : value;
      }
      return 0;
    });
  }

  /// Returns real XP activity since [since], combining the two existing
  /// authoritative XP histories: RewardService reward history and the
  /// career-scoped Copilot evidence ledger. This is used only for
  /// time-window activity metrics; lifetime XP remains users/{uid}.totalXp.
  static Future<int> getXpActivitySince(String uid, DateTime since) async {
    if (uid.isEmpty) return 0;
    var total = 0;

    // RewardService authoritative reward history.
    try {
      final rewardDocs = await _db
          .collection('rewards')
          .doc(uid)
          .collection('history')
          .get();
      for (final doc in rewardDocs.docs) {
        final data = doc.data();
        final timestamp = DateTime.tryParse(
          data['timestamp'] as String? ?? '',
        );
        final xp = data['xpAmount'];
        if (timestamp != null && !timestamp.isBefore(since) && xp is num) {
          total += xp.toInt();
        }
      }
    } catch (_) {}

    // Career-scoped Copilot evidence. This covers goals, quizzes,
    // challenges, projects and any other XP-bearing career event.
    try {
      final careerDocs = await _userDoc(uid)
          .collection('copilot_learning_progress')
          .get();
      for (final careerDoc in careerDocs.docs) {
        final events = await careerDoc.reference.collection('events').get();
        for (final event in events.docs) {
          final data = event.data();
          final timestamp = DateTime.tryParse(
            data['recordedAt'] as String? ?? '',
          );
          final xp = data['xp'];
          if (timestamp != null && !timestamp.isBefore(since) && xp is num) {
            total += xp.toInt();
          }
        }
      }
    } catch (_) {}

    return total < 0 ? 0 : total;
  }

  // ── Career XP ─────────────────────────────────────────────────────────────

  /// Returns XP earned inside one career. Lifetime/global XP remains
  /// users/{uid}.totalXp. Career XP is derived from immutable career events
  /// so older histories remain correct even before careerTotalXp existed.
  static Future<int> getCareerTotalXp(String uid, String careerId) async {
    final safeCareerId = _safeId(careerId);
    if (uid.isEmpty || safeCareerId.isEmpty) return 0;

    // The event ledger is the durable evidence source. The aggregate field
    // is maintained as a fast mirror for future server-side use, but it is
    // not trusted over historical events during this client-side read.
    final events = await _eventsCol(uid, safeCareerId).get();
    var total = 0;
    for (final event in events.docs) {
      final xp = event.data()['xp'];
      if (xp is num && xp.toInt() > 0) total += xp.toInt();
    }
    return total;
  }

  /// Returns authoritative earned XP for one course, broken down by
  /// event type. Only persisted evidence is counted; promised course.totalXp
  /// values and local UI counters are never used.
  static Future<Map<String, int>> getCourseXpBreakdown(
    String uid,
    String careerId,
    String courseId,
  ) async {
    final safeCareerId = _safeId(careerId);
    final safeCourseId = _safeId(courseId);
    if (uid.isEmpty || safeCareerId.isEmpty || safeCourseId.isEmpty) {
      return const {'quiz': 0, 'challenge': 0, 'project': 0, 'lesson': 0, 'total': 0};
    }

    var quiz = 0;
    var challenge = 0;
    var project = 0;
    var lesson = 0;
    final events = await _eventsCol(uid, safeCareerId).get();
    for (final doc in events.docs) {
      final data = doc.data();
      final eventId = data['eventId'] as String? ?? doc.id;
      final xp = data['xp'];
      if (xp is! num || xp.toInt() <= 0) continue;
      if (!eventId.contains(safeCourseId)) continue;
      final amount = xp.toInt();
      switch (data['eventType']) {
        case CopilotEventType.quiz:
          quiz += amount;
          break;
        case CopilotEventType.challenge:
          challenge += amount;
          break;
        case CopilotEventType.project:
          project += amount;
          break;
        case CopilotEventType.lesson:
          lesson += amount;
          break;
      }
    }
    return {
      'quiz': quiz,
      'challenge': challenge,
      'project': project,
      'lesson': lesson,
      'total': quiz + challenge + project + lesson,
    };
  }

  static Future<List<Map<String, dynamic>>> getCareerXpEvents(
      String uid, String careerId, {int limit = 100}) async {
    final safeCareerId = _safeId(careerId);
    if (uid.isEmpty || safeCareerId.isEmpty) return const [];
    final safeLimit = limit <= 0 ? 100 : (limit > 500 ? 500 : limit);
    final snap = await _eventsCol(uid, safeCareerId).get();
    final events = snap.docs
        .map((d) => d.data())
        .where((e) => e['xp'] is num && (e['xp'] as num).toInt() > 0)
        .toList();
    events.sort((a, b) =>
        ((b['recordedAt'] as String?) ?? '')
            .compareTo((a['recordedAt'] as String?) ?? ''));
    return events.length > safeLimit ? events.sublist(0, safeLimit) : events;
  }

  // ── Progress ───────────────────────────────────────────────────────────────

  /// Persists the daily progress snapshot. New career-scoped writes use a
  /// career-specific document id so two careers can both have progress on
  /// the same day without overwriting one another.
  static Future<void> syncTodayProgress(
      String uid, List<DailyGoal> todayGoals, {String? careerId}) async {
    final today = _todayKey();
    final completed = todayGoals.where((g) => g.isCompleted).toList();
    final xp = completed.fold(0, (sum, g) => sum + g.xpReward);
    final completedSkills = completed
        .where((g) => g.linkedSkill != null)
        .map((g) => g.linkedSkill!)
        .toList();

    final safeCareerId = careerId == null ? '' : _safeId(careerId);
    final docId = safeCareerId.isEmpty
        ? '${uid}_$today'
        : '${uid}_${today}_$safeCareerId';

    final data = <String, dynamic>{
      ...ProgressEntry(
        id: docId,
        uid: uid,
        date: DateTime.now(),
        xpEarned: xp,
        goalsCompleted: completed.length,
        totalGoals: todayGoals.length,
        completedSkills: completedSkills,
      ).toFirestore(),
      if (safeCareerId.isNotEmpty) 'careerId': safeCareerId,
    };

    await _userDoc(uid)
        .collection('copilot_progress')
        .doc(docId)
        .set(data, SetOptions(merge: true));
  }

  /// CAREER-ISOLATION HARDENING (Phase 2):
  /// When no career is resolved, this previously returned the most recent
  /// progress entries across EVERY career the user has ever used — mixing
  /// Career A's and Career B's daily XP/goal history into one feed. This
  /// fed straight into `CopilotState.progressHistory`, which the streak
  /// and (compatibility) XP getters, and the Hub's weekly-XP chart, all
  /// read from — so the leak was directly user-visible.
  ///
  /// `ProgressEntry` itself does not carry a `careerId` field (only the
  /// raw stored document does, added by `syncTodayProgress` only when a
  /// real career was active), so the check is performed on the raw
  /// document map before it is turned into a model — the model layer
  /// cannot express this filter after the fact.
  ///
  /// The read is bounded (never more than 500 raw docs) so an "empty
  /// career" resolution can never trigger an unbounded collection scan.
  static Future<List<ProgressEntry>> getProgressHistory(
      String uid, {int limit = 30, String? careerId}) async {
    final safeLimit = limit <= 0 ? 30 : (limit > 90 ? 90 : limit);
    final col = _userDoc(uid).collection('copilot_progress');

    if (careerId != null && careerId.isNotEmpty) {
      final safeCareerId = _safeId(careerId);
      if (safeCareerId.isEmpty) return const [];
      final snap = await col.where('careerId', isEqualTo: safeCareerId).get();
      final entries = snap.docs
          .map((d) => ProgressEntry.fromFirestore(d.data()))
          .toList();
      entries.sort((a, b) => b.date.compareTo(a.date));
      return entries.length > safeLimit ? entries.sublist(0, safeLimit) : entries;
    }

    final rawLimit = (safeLimit * 5) > 500 ? 500 : safeLimit * 5;
    final snap = await col
        .orderBy('date', descending: true)
        .limit(rawLimit)
        .get();
    final entries = snap.docs
        .where((d) {
          final raw = d.data()['careerId'] as String?;
          return raw == null || raw.isEmpty;
        })
        .map((d) => ProgressEntry.fromFirestore(d.data()))
        .toList();
    return entries.length > safeLimit ? entries.sublist(0, safeLimit) : entries;
  }

  static Stream<List<ProgressEntry>> progressStream(
      String uid, {String? careerId}) {
    final col = _userDoc(uid).collection('copilot_progress');
    if (careerId != null && careerId.isNotEmpty) {
      final safeCareerId = _safeId(careerId);
      if (safeCareerId.isEmpty) return const Stream<List<ProgressEntry>>.empty();
      return col.where('careerId', isEqualTo: safeCareerId).snapshots().map((s) {
        final entries = s.docs
            .map((d) => ProgressEntry.fromFirestore(d.data()))
            .toList();
        entries.sort((a, b) => a.date.compareTo(b.date));
        return entries;
      });
    }

    final sevenAgo =
        DateTime.now().subtract(const Duration(days: 7)).toIso8601String();
    // Same isolation guard as getProgressHistory()'s no-career branch:
    // only genuinely unscoped (legacy) entries qualify when no career is
    // resolved, checked on the raw document since ProgressEntry itself
    // does not carry a careerId field.
    return col
        .where('date', isGreaterThan: sevenAgo)
        .orderBy('date', descending: false)
        .snapshots()
        .map((s) => s.docs
            .where((d) {
              final raw = d.data()['careerId'] as String?;
              return raw == null || raw.isEmpty;
            })
            .map((d) => ProgressEntry.fromFirestore(d.data()))
            .toList());
  }

  // ════════════════════════════════════════════════════════════════════════
  // ─── STRUCTURED EVENT LAYER ────────────────────────────────────────────
  // ════════════════════════════════════════════════════════════════════════

  static DocumentReference<Map<String, dynamic>> _copilotDoc(
          String uid, String docId) =>
      _userDoc(uid).collection('copilot').doc(docId);

  static DocumentReference<Map<String, dynamic>> _careerCopilotDoc(
      String uid, String baseId, String? careerId) {
    final safe = careerId == null ? '' : _safeId(careerId);
    return _copilotDoc(uid, safe.isEmpty ? baseId : '${baseId}_$safe');
  }

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

  /// Legacy canonical goal-completion record. Career-scoped goal
  /// completions use _careerGoalEventDoc(); this helper is retained for
  /// backward compatibility when no careerId is available.
  static DocumentReference<Map<String, dynamic>> _goalEventDoc(
          String uid, String eventId) =>
      _userDoc(uid).collection('copilot_goal_events').doc(eventId);

  static DocumentReference<Map<String, dynamic>> _careerGoalEventDoc(
      String uid, String careerId, String goalId) =>
      _userDoc(uid)
          .collection('copilot_goal_events')
          .doc('${_safeId(careerId)}__goal_${_safeId(goalId)}');

  static DocumentReference<Map<String, dynamic>> _jobOfferEventDoc(
          String uid, String eventId) =>
      _userDoc(uid).collection('copilot_job_offer_events').doc(eventId);

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
    final safeXpReward = xpReward < 0 ? 0 : xpReward;
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
        'xp': safeXpReward,
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

      if (safeXpReward > 0) {
        tx.set(
          userRef,
          {'totalXp': FieldValue.increment(safeXpReward)},
          SetOptions(merge: true),
        );
        tx.set(
          learningRef,
          {
            'careerId': safeCareerId,
            'careerTotalXp': FieldValue.increment(safeXpReward),
            'updatedAt': DateTime.now().toIso8601String(),
          },
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
    final safeXpReward = xpReward < 0 ? 0 : xpReward;

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
        'xp': safeXpReward,
        'metadata': _boundedMetadata(metadata),
        'recordedAt': recordedAt.toIso8601String(),
      });

      if (safeXpReward > 0) {
        tx.set(
          userRef,
          {'totalXp': FieldValue.increment(safeXpReward)},
          SetOptions(merge: true),
        );
        tx.set(
          _learningProgressDoc(uid, safeCareerId),
          {
            'careerId': safeCareerId,
            'careerTotalXp': FieldValue.increment(safeXpReward),
            'updatedAt': DateTime.now().toIso8601String(),
          },
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
      _careerCopilotDoc(uid, 'project_progress', progress.careerId)
          .set(progress.toFirestore(), SetOptions(merge: true));

  // Used by saveCopilotContext so a stale read-model cannot clobber
  // completedProjectIds/projectMilestones history.
  static Future<void> _saveProjectCurrentState(
      String uid, ProjectProgressContext progress) =>
      _careerCopilotDoc(uid, 'project_progress', progress.careerId).set({
        'totalProjects': progress.totalProjects,
        'currentProjectId': progress.currentProjectId,
        'careerId': progress.careerId,
        'updatedAt': progress.updatedAt.toIso8601String(),
      }, SetOptions(merge: true));

  static Future<ProjectProgressContext?> getProjectProgress(
      String uid, {String? careerId}) async {
    var snap = await _careerCopilotDoc(uid, 'project_progress', careerId).get();
    if (snap.exists && snap.data() != null) return ProjectProgressContext.fromFirestore(snap.data()!);
    if (careerId != null && careerId.isNotEmpty) {
      snap = await _copilotDoc(uid, 'project_progress').get();
      if (snap.exists && snap.data() != null) {
        final legacy = ProjectProgressContext.fromFirestore(snap.data()!);
        if (legacy.careerId == careerId) return legacy;
      }
    }
    return null;
  }

  static Stream<ProjectProgressContext?> projectProgressStream(
          String uid, {String? careerId}) =>
      _careerCopilotDoc(uid, 'project_progress', careerId).snapshots().map((s) =>
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

    final resolvedCareerId =
        (careerId != null && careerId.isNotEmpty) ? _safeId(careerId) : null;
    final progressRef = _careerCopilotDoc(uid, 'project_progress', resolvedCareerId);
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
      if (resolvedCareerId != null && resolvedCareerId.isNotEmpty) {
        progressData['careerId'] = resolvedCareerId;
      }
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

  /// Records a project milestone without replacing the project's existing
  /// milestone history. Uses a transaction so concurrent completions merge
  /// against the latest Firestore state.
  static Future<void> appendCompletedProjectMilestone(
    String uid,
    String projectId,
    String milestoneId, {
    String? careerId,
  }) async {
    final safeProjectId = _safeId(projectId);
    final safeMilestoneId = _safeId(milestoneId);
    if (safeProjectId.isEmpty || safeMilestoneId.isEmpty) return;

    final ref = _careerCopilotDoc(uid, 'project_progress', careerId);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final data = snap.data() ?? <String, dynamic>{};
      final raw = (data['projectMilestones'] as Map?) ?? const {};
      final milestones = <String, dynamic>{};
      raw.forEach((key, value) {
        milestones[key.toString()] = List<dynamic>.from(value as List? ?? const []);
      });
      final existing = List<dynamic>.from(
          milestones[safeProjectId] as List? ?? const []);
      if (!existing.contains(safeMilestoneId)) {
        existing.add(safeMilestoneId);
      }
      milestones[safeProjectId] = existing;

      final write = <String, dynamic>{
        'projectMilestones': milestones,
        'updatedAt': DateTime.now().toIso8601String(),
      };
      if (careerId != null && careerId.isNotEmpty) {
        write['careerId'] = _safeId(careerId);
      }
      tx.set(ref, write, SetOptions(merge: true));
    });
  }

  // ── Job Progress ────────────────────────────────────────────────────────

  static Future<void> saveJobProgress(String uid, JobProgressContext progress) =>
      _careerCopilotDoc(uid, 'job_progress', progress.careerId)
          .set(progress.toFirestore(), SetOptions(merge: true));

  static Future<void> _saveJobCurrentState(
      String uid, JobProgressContext progress) =>
      _careerCopilotDoc(uid, 'job_progress', progress.careerId).set({
        'offersReceived': progress.offersReceived,
        'careerId': progress.careerId,
        'applicationStates': progress.applicationStates,
        'updatedAt': progress.updatedAt.toIso8601String(),
      }, SetOptions(merge: true));

  static Future<JobProgressContext?> getJobProgress(String uid, {String? careerId}) async {
    var snap = await _careerCopilotDoc(uid, 'job_progress', careerId).get();
    if (snap.exists && snap.data() != null) return JobProgressContext.fromFirestore(snap.data()!);
    if (careerId != null && careerId.isNotEmpty) {
      snap = await _copilotDoc(uid, 'job_progress').get();
      if (snap.exists && snap.data() != null) {
        final legacy = JobProgressContext.fromFirestore(snap.data()!);
        if (legacy.careerId == careerId) return legacy;
      }
    }
    return null;
  }

  static Stream<JobProgressContext?> jobProgressStream(String uid, {String? careerId}) =>
      _careerCopilotDoc(uid, 'job_progress', careerId).snapshots().map((s) =>
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
    String applicationState = 'applied',
  }) async {
    final safeJobId = _safeId(jobId);
    if (safeJobId.isEmpty) return;

    final resolvedCareerId =
        (careerId != null && careerId.isNotEmpty) ? _safeId(careerId) : null;
    final progressRef = _careerCopilotDoc(uid, 'job_progress', resolvedCareerId);
    final eventId = 'jobApplication:$safeJobId';
    final eventRef = resolvedCareerId != null && resolvedCareerId.isNotEmpty
        ? _eventDoc(uid, resolvedCareerId, eventId)
        : null;

    await _db.runTransaction((tx) async {
      final progressSnap = await tx.get(progressRef);
      final eventSnap = eventRef != null ? await tx.get(eventRef) : null;
      final eventExists = eventSnap != null && eventSnap.exists;

      final current = progressSnap.exists && progressSnap.data() != null
          ? JobProgressContext.fromFirestore(progressSnap.data()!)
          : JobProgressContext(updatedAt: DateTime.now());
      final next = current.withApplicationState(
        safeJobId,
        applicationState.trim().isEmpty ? 'applied' : applicationState.trim(),
      ).withJobApplied(safeJobId);

      tx.set(progressRef, next.toFirestore(), SetOptions(merge: true));
      if (resolvedCareerId != null && resolvedCareerId.isNotEmpty) {
        tx.set(progressRef, {'careerId': resolvedCareerId}, SetOptions(merge: true));
      }

      if (eventRef != null && !eventExists) {
        tx.set(eventRef, {
          'eventId': eventId,
          'eventType': CopilotEventType.jobApplication,
          'careerId': resolvedCareerId,
          'topic': null,
          'correct': null,
          'xp': 0,
          'metadata': _boundedMetadata({
            'jobId': safeJobId,
            'state': applicationState,
          }),
          'recordedAt': DateTime.now().toIso8601String(),
        });
      }
    });
  }

  static Future<void> appendSavedJob(
    String uid,
    String jobId, {
    String? careerId,
  }) async {
    final safeJobId = _safeId(jobId);
    if (safeJobId.isEmpty) return;

    final safeCareerId =
        careerId == null || careerId.isEmpty ? '' : _safeId(careerId);

    if (safeCareerId.isNotEmpty) {
      await _careerCopilotDoc(uid, 'job_progress', safeCareerId).set({
        'careerId': safeCareerId,
        'savedJobIds': FieldValue.arrayUnion([safeJobId]),
        'updatedAt': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
      return;
    }

    // Legacy compatibility only. New controller flows should always pass
    // the active career id.
    await _copilotDoc(uid, 'job_progress').set({
      'savedJobIds': FieldValue.arrayUnion([safeJobId]),
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  /// Legacy compatibility counter.
  ///
  /// This method is intentionally not the authoritative offer recorder.
  /// New flows must use recordJobOffer() with a stable offerId so the
  /// reward/counting operation is idempotent.
  static Future<void> incrementJobOffers(String uid, {int by = 1}) async {
    final safeBy = by < 0 ? 0 : by;
    if (safeBy == 0) return;
    await _copilotDoc(uid, 'job_progress').set({
      'offersReceived': FieldValue.increment(safeBy),
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  /// Idempotent offer recorder. The existing incrementJobOffers() method
  /// remains for legacy callers, but new flows should supply a stable offerId.
  static Future<bool> recordJobOffer(
    String uid, {
    required String offerId,
    String? careerId,
    String? jobId,
  }) async {
    final safeOfferId = _safeId(offerId);
    if (safeOfferId.isEmpty) return false;
    final resolvedCareerId =
        (careerId != null && careerId.isNotEmpty) ? _safeId(careerId) : null;
    final eventId = 'jobOffer:$safeOfferId';
    final eventRef = resolvedCareerId != null && resolvedCareerId.isNotEmpty
        ? _eventDoc(uid, resolvedCareerId, eventId)
        : _jobOfferEventDoc(uid, eventId);
    final progressRef = _copilotDoc(uid, 'job_progress');

    return _db.runTransaction<bool>((tx) async {
      final eventSnap = await tx.get(eventRef);
      if (eventSnap.exists) return false;
      tx.set(eventRef, {
        'eventId': eventId,
        'eventType': 'jobOffer',
        if (resolvedCareerId != null) 'careerId': resolvedCareerId,
        'topic': jobId,
        'correct': null,
        'xp': 0,
        'metadata': _boundedMetadata({'offerId': safeOfferId, if (jobId != null) 'jobId': jobId}),
        'recordedAt': DateTime.now().toIso8601String(),
      });
      tx.set(progressRef, {
        'offersReceived': FieldValue.increment(1),
        if (resolvedCareerId != null) 'careerId': resolvedCareerId,
        'updatedAt': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
      return true;
    });
  }

  // ── Interview Progress ──────────────────────────────────────────────────

  /// Backward-compatible current-state writer.
  ///
  /// Historical interview attempts are authoritative only through
  /// appendCompletedInterview(). This method intentionally does not write
  /// completedInterviewIds, attempts, or derived score history from a
  /// potentially stale caller snapshot.
  static Future<void> saveInterviewProgress(
      String uid,
      InterviewProgressContext progress,
  ) =>
      _saveInterviewCurrentState(uid, progress);

  static Future<void> _saveInterviewCurrentState(
      String uid, InterviewProgressContext progress) =>
      _careerCopilotDoc(uid, 'interview_progress', progress.careerId).set({
        'careerId': progress.careerId,
        'updatedAt': progress.updatedAt.toIso8601String(),
      }, SetOptions(merge: true));

  static Future<InterviewProgressContext?> getInterviewProgress(
      String uid, {String? careerId}) async {
    var snap = await _careerCopilotDoc(uid, 'interview_progress', careerId).get();
    if (snap.exists && snap.data() != null) return InterviewProgressContext.fromFirestore(snap.data()!);
    if (careerId != null && careerId.isNotEmpty) {
      snap = await _copilotDoc(uid, 'interview_progress').get();
      if (snap.exists && snap.data() != null) {
        final legacy = InterviewProgressContext.fromFirestore(snap.data()!);
        if (legacy.careerId == careerId) return legacy;
      }
    }
    return null;
  }

  static Stream<InterviewProgressContext?> interviewProgressStream(
          String uid, {String? careerId}) =>
      _careerCopilotDoc(uid, 'interview_progress', careerId).snapshots().map((s) =>
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
    final safeScore = score == null ? null : score.clamp(0.0, 100.0).toDouble();

    final resolvedCareerId =
        (careerId != null && careerId.isNotEmpty) ? _safeId(careerId) : null;
    final progressRef = _careerCopilotDoc(uid, 'interview_progress', resolvedCareerId);
    final eventId = 'interview:$safeInterviewId';
    final eventRef = resolvedCareerId != null && resolvedCareerId.isNotEmpty
        ? _eventDoc(uid, resolvedCareerId, eventId)
        : null;

    await _db.runTransaction((tx) async {
      final progressSnap = await tx.get(progressRef);
      final eventSnap = eventRef != null ? await tx.get(eventRef) : null;
      final eventExists = eventSnap != null && eventSnap.exists;

      final current = progressSnap.exists && progressSnap.data() != null
          ? InterviewProgressContext.fromFirestore(progressSnap.data()!)
          : InterviewProgressContext(updatedAt: DateTime.now());

      // IMPORTANT: always append the attempt. Repeating an interview is
      // legitimate history and must not be discarded just because its ID
      // already exists in completedInterviewIds.
      final updated = current.withInterviewCompleted(
        safeInterviewId,
        score: safeScore,
      );

      tx.set(progressRef, updated.toFirestore(), SetOptions(merge: true));
      if (resolvedCareerId != null && resolvedCareerId.isNotEmpty) {
        tx.set(progressRef, {'careerId': resolvedCareerId}, SetOptions(merge: true));
      }

      // One career event per interview identity; attempt-level history lives
      // in InterviewProgressContext.attempts.
      if (eventRef != null && !eventExists) {
        tx.set(eventRef, {
          'eventId': eventId,
          'eventType': CopilotEventType.interview,
          'careerId': resolvedCareerId,
          'topic': null,
          'correct': null,
          'xp': 0,
          'metadata': _boundedMetadata({
            if (safeScore != null) 'score': safeScore,
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
      _careerCopilotDoc(uid, 'readiness', readiness.careerId)
          .set(readiness.toFirestore(), SetOptions(merge: true));

  static Future<CareerReadiness?> getCareerReadiness(String uid, {String? careerId}) async {
    var snap = await _careerCopilotDoc(uid, 'readiness', careerId).get();
    if (snap.exists && snap.data() != null) return CareerReadiness.fromFirestore(snap.data()!);
    if (careerId != null && careerId.isNotEmpty) {
      snap = await _copilotDoc(uid, 'readiness').get();
      if (snap.exists && snap.data() != null) {
        final legacy = CareerReadiness.fromFirestore(snap.data()!);
        if (legacy.careerId == careerId) return legacy;
      }
    }
    return null;
  }

  static Stream<CareerReadiness?> careerReadinessStream(String uid, {String? careerId}) =>
      _careerCopilotDoc(uid, 'readiness', careerId).snapshots().map((s) =>
          s.exists && s.data() != null
              ? CareerReadiness.fromFirestore(s.data()!)
              : null);

  // ── Next Best Actions ───────────────────────────────────────────────────

  static Future<void> saveNextAction(String uid, NextBestAction action) async {
    final data = action.toFirestore();
    final careerId = action.careerId;
    if (careerId != null && careerId.isNotEmpty) {
      data['careerId'] = _safeId(careerId);
    }
    await _userDoc(uid)
        .collection('copilot_next_actions')
        .doc(action.id)
        .set(data, SetOptions(merge: true));
  }

  /// CAREER-ISOLATION HARDENING (Phase 2):
  /// When no career is resolved, this previously returned every
  /// NextBestAction across every career the user has ever used. It now
  /// returns only genuinely unscoped (legacy) actions — never a blend of
  /// two different careers' next steps. When a real careerId IS supplied,
  /// behaviour is unchanged (already correctly scoped via the Firestore
  /// query).
  static Future<List<NextBestAction>> getNextActions(
    String uid, {
    bool onlyPending = false,
    int limit = 50,
    String? careerId,
  }) async {
    final safeLimit = limit <= 0 ? 50 : (limit > 200 ? 200 : limit);

    Query<Map<String, dynamic>> q =
        _userDoc(uid).collection('copilot_next_actions');
    final safeCareerId = careerId == null ? '' : _safeId(careerId);

    if (onlyPending) q = q.where('isCompleted', isEqualTo: false);

    List<NextBestAction> actions;
    if (safeCareerId.isNotEmpty) {
      q = q.where('careerId', isEqualTo: safeCareerId);
      final snap = await q.get();
      actions =
          snap.docs.map((d) => NextBestAction.fromFirestore(d.data())).toList();
    } else {
      final snap = await q.get();
      actions = snap.docs
          .map((d) => NextBestAction.fromFirestore(d.data()))
          .where((a) => a.careerId == null || a.careerId!.isEmpty)
          .toList();
    }

    actions.sort((a, b) => a.priority.compareTo(b.priority));
    if (actions.length > safeLimit) {
      return actions.sublist(0, safeLimit);
    }
    return actions;
  }

  /// See getNextActions() — identical career-isolation guard applied to
  /// the live stream variant.
  static Stream<List<NextBestAction>> nextActionsStream(
    String uid, {
    bool onlyPending = false,
    int limit = 50,
    String? careerId,
  }) {
    final safeLimit = limit <= 0 ? 50 : (limit > 200 ? 200 : limit);

    Query<Map<String, dynamic>> q =
        _userDoc(uid).collection('copilot_next_actions');
    final safeCareerId = careerId == null ? '' : _safeId(careerId);

    if (onlyPending) q = q.where('isCompleted', isEqualTo: false);
    if (safeCareerId.isNotEmpty) {
      q = q.where('careerId', isEqualTo: safeCareerId);
    }

    return q.snapshots().map((s) {
      var actions =
          s.docs.map((d) => NextBestAction.fromFirestore(d.data())).toList();
      if (safeCareerId.isEmpty) {
        actions = actions
            .where((a) => a.careerId == null || a.careerId!.isEmpty)
            .toList();
      }
      actions.sort((a, b) => a.priority.compareTo(b.priority));
      if (actions.length > safeLimit) {
        return actions.sublist(0, safeLimit);
      }
      return actions;
    });
  }

  static Future<void> completeNextAction(
    String uid,
    String actionId, {
    String? careerId,
  }) async {
    if (uid.isEmpty || actionId.isEmpty) return;

    final ref = _userDoc(uid)
        .collection('copilot_next_actions')
        .doc(actionId);

    await _db.runTransaction((tx) async {
      // READ PHASE
      final snap = await tx.get(ref);
      if (!snap.exists || snap.data() == null) return;

      final activeCareerSnap =
          await tx.get(_copilotDoc(uid, 'career_context'));
      final activeCareerId = activeCareerSnap.exists &&
              activeCareerSnap.data() != null
          ? _safeId(
              activeCareerSnap.data()!['careerId'] as String? ?? '',
            )
          : '';

      final data = snap.data()!;
      final storedCareerId = _safeId(data['careerId'] as String? ?? '');
      final requestedCareerId = careerId == null || careerId.isEmpty
          ? activeCareerId
          : _safeId(careerId);

      // A career-scoped action can only be completed from the same career.
      if (storedCareerId.isNotEmpty &&
          requestedCareerId.isNotEmpty &&
          storedCareerId != requestedCareerId) {
        return;
      }

      tx.set(
        ref,
        {
          'isCompleted': true,
          'completedAt': DateTime.now().toIso8601String(),
        },
        SetOptions(merge: true),
      );
    });
  }

  // ── Copilot Recommendations ─────────────────────────────────────────────

  static Future<void> saveRecommendation(
      String uid,
      CopilotRecommendation recommendation,
  ) async {
    final data = recommendation.toFirestore();
    final careerId = recommendation.careerId;
    if (careerId != null && careerId.isNotEmpty) {
      data['careerId'] = _safeId(careerId);
    }
    await _userDoc(uid)
        .collection('copilot_recommendations')
        .doc(recommendation.id)
        .set(data, SetOptions(merge: true));
  }

  /// CAREER-ISOLATION HARDENING (Phase 2):
  /// Identical guard to getNextActions() — when no career is resolved,
  /// only genuinely unscoped (legacy) recommendations are returned,
  /// never a blend of multiple explicit careers' recommendations.
  static Future<List<CopilotRecommendation>> getRecommendations(
    String uid, {
    bool onlyActive = false,
    int limit = 50,
    String? careerId,
  }) async {
    final safeLimit = limit <= 0 ? 50 : (limit > 200 ? 200 : limit);

    Query<Map<String, dynamic>> q =
        _userDoc(uid).collection('copilot_recommendations');
    final safeCareerId = careerId == null ? '' : _safeId(careerId);

    if (onlyActive) q = q.where('isDismissed', isEqualTo: false);

    List<CopilotRecommendation> recs;
    if (safeCareerId.isNotEmpty) {
      q = q.where('careerId', isEqualTo: safeCareerId);
      final snap = await q.get();
      recs = snap.docs
          .map((d) => CopilotRecommendation.fromFirestore(d.data()))
          .toList();
    } else {
      final snap = await q.get();
      recs = snap.docs
          .map((d) => CopilotRecommendation.fromFirestore(d.data()))
          .where((r) => r.careerId == null || r.careerId!.isEmpty)
          .toList();
    }

    recs.sort((a, b) => a.priority.compareTo(b.priority));
    if (recs.length > safeLimit) {
      return recs.sublist(0, safeLimit);
    }
    return recs;
  }

  /// See getRecommendations() — identical career-isolation guard applied
  /// to the live stream variant.
  static Stream<List<CopilotRecommendation>> recommendationsStream(
    String uid, {
    bool onlyActive = false,
    int limit = 50,
    String? careerId,
  }) {
    final safeLimit = limit <= 0 ? 50 : (limit > 200 ? 200 : limit);

    Query<Map<String, dynamic>> q =
        _userDoc(uid).collection('copilot_recommendations');
    final safeCareerId = careerId == null ? '' : _safeId(careerId);

    if (onlyActive) q = q.where('isDismissed', isEqualTo: false);
    if (safeCareerId.isNotEmpty) {
      q = q.where('careerId', isEqualTo: safeCareerId);
    }

    return q.snapshots().map((s) {
      var recs = s.docs
          .map((d) => CopilotRecommendation.fromFirestore(d.data()))
          .toList();
      if (safeCareerId.isEmpty) {
        recs = recs
            .where((r) => r.careerId == null || r.careerId!.isEmpty)
            .toList();
      }
      recs.sort((a, b) => a.priority.compareTo(b.priority));
      if (recs.length > safeLimit) {
        return recs.sublist(0, safeLimit);
      }
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
    final career = await getCareerContext(uid);
    final resolvedCareerId =
        (careerId != null && careerId.isNotEmpty)
            ? careerId
            : career?.careerId;

    final results = await Future.wait([
      resolvedCareerId != null && resolvedCareerId.isNotEmpty
          ? getCareerSkillProfile(uid, resolvedCareerId)
          : getSkillProfile(uid),
      getSkillGaps(uid, careerId: resolvedCareerId),
      getRoadmap(uid, careerId: resolvedCareerId),
      getTodayGoals(uid, careerId: resolvedCareerId),
      getProgressHistory(uid, careerId: resolvedCareerId),
      Future.value(career),
      getProjectProgress(uid, careerId: resolvedCareerId),
      getJobProgress(uid, careerId: resolvedCareerId),
      getInterviewProgress(uid, careerId: resolvedCareerId),
      getCareerReadiness(uid, careerId: resolvedCareerId),
      getNextActions(uid, careerId: resolvedCareerId),
      getRecommendations(uid, careerId: resolvedCareerId),
    ]);

    final skillProfile      = results[0] as UserSkillProfile?;
    final skillGaps         = results[1] as List<SkillGap>;
    final roadmap            = results[2] as PersonalizedRoadmap?;
    final todayGoals         = results[3] as List<DailyGoal>;
    final progressHistory    = results[4] as List<ProgressEntry>;
    final resolvedCareer     = results[5] as CareerContext?;
    final projectProgress    = results[6] as ProjectProgressContext?;
    final jobProgress        = results[7] as JobProgressContext?;
    final interviewProgress  = results[8] as InterviewProgressContext?;
    final readiness           = results[9] as CareerReadiness?;
    final nextActions         = results[10] as List<NextBestAction>;
    final recommendations     = results[11] as List<CopilotRecommendation>;

    final finalCareerId =
        resolvedCareerId ?? resolvedCareer?.careerId;

    final learningProgress =
        finalCareerId != null && finalCareerId.isNotEmpty
            ? await getLearningProgress(uid, finalCareerId)
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
      career: resolvedCareer,
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
      final profile = context.state.skillProfile!;
      final careerId = context.career?.careerId ?? profile.targetRole.careerId;
      if (careerId.isNotEmpty) {
        futures.add(saveCareerSkillProfile(profile, careerId));
      } else {
        // Genuine legacy/unscoped profile only.
        futures.add(saveSkillProfile(profile));
      }
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
    // historical arrays (completedProjectIds, appliedJobIds, attempts,
    // completedInterviewIds, ...) are owned by the dedicated append*
    // writers and are never clobbered here.
    futures.add(_saveProjectCurrentState(uid, context.projectProgress));
    futures.add(_saveJobCurrentState(uid, context.jobProgress));
    futures.add(_saveInterviewCurrentState(uid, context.interviewProgress));
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