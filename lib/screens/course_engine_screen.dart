// ══════════════════════════════════════════════════════════════════════
// lib/screens/course_engine_screen.dart
//
// In-App Course Learning Engine — 7 screens in one StatefulWidget:
//
//  Screen 0 — Intro         (title, difficulty, XP, Start button)
//  Screen 1..N — Concepts   (definition, analogy, example, code)
//  Screen N+1 — Quiz        (4 MCQ questions, +10 XP each)
//  Screen N+2 — Challenges  (mini logic challenges, +15 XP each)
//  Screen N+3 — Final Project (goal, steps, expected output)
//  Screen N+4 — Completion  (animation, total XP, next button)

// CAREER INTELLIGENCE LOOP
// ────────────────────────
// This screen closes the loop:
//
//   Skill Gap → Targeted Course → Quiz/Challenge Evidence
//     → Copilot re-analysis → Next Best Action
//
// Every quiz answer, every challenge answer, and the final project
// completion is persisted through the existing
// CopilotController.recordCourseEvent(...) path. That method writes to
// the same per-career learning-progress document (arrayUnion on
// `completedCourseEventIds` and `courseEvidenceIds`), awards the event's
// XP atomically on users/{uid}.totalXp ONLY on the first write of that
// event id, and then refreshes Copilot intelligence so Skill Gap /
// Readiness / Next Best Action / Recommendations can recalculate.
//
// The event id is stable and unique per course event:
//     quiz:{courseId}:{index}           (correct answer — mastery, XP)
//     quiz_miss:{courseId}:{index}      (wrong answer — weakness, 0 XP)
//     challenge:{courseId}:{index}      (correct answer — mastery, XP)
//     challenge_miss:{courseId}:{index} (wrong answer — weakness, 0 XP)
//     project:{courseId}
// so reopening, retrying, or rebuilding cannot duplicate XP, completion
// records, or evidence in Firestore. The existing (correct-answer) event
// ids are preserved exactly; the *_miss ids are purely additive weakness
// evidence and never award XP.
//
// Course completion (the final lesson) is recorded through the existing
// CopilotController.recordLessonCompleted, which appends a stable
// per-course lesson id to the append-only completedLessonIds array and
// triggers the same intelligence refresh.
//
// LOCAL XP COUNTER — PERSISTENCE + IDEMPOTENCY
// ────────────────────────────────────────────
// `_xpEarned` is the LOCAL display counter shown in the top-bar pill
// and on the completion screen. It is a UX mirror, not the source of
// truth. Firestore's users/{uid}.totalXp is authoritative.
//
//   • On screen load, `_xpEarned` is restored from the existing
//     SharedPreferences key `course_xp_{courseId}`.
//
//   • On every course event confirmed by Firestore (a NEW event id),
//     `_xpEarned` is incremented AND immediately written back to
//     `course_xp_{courseId}`.
//
//   • The per-event SharedPreferences marker
//     (`course_evt_done_{courseId}_{eventId}`) is a cache that MIRRORS
//     Firestore state. It is set ONLY after Firestore confirms the
//     event exists, and is never itself the authority on whether an
//     event is new.
//
//   • An IN-FLIGHT guard (`_eventInFlight`) prevents rapid double-taps
//     or concurrent submissions for the same event from racing past the
//     check-then-write sequence. Set BEFORE the Firestore call, cleared
//     in a finally block.
//
// OFFLINE EVENT RELIABILITY — PENDING QUEUE
// ─────────────────────────────────────────
// If the device is offline (no controller / no authenticated user) or
// the Firestore call fails with a transport error, the event is NOT
// silently reported as saved and NO local XP is awarded. Instead the
// event is written to a lightweight local pending queue
// (`course_pending_events_{courseId}`). It is retried:
//   • when the screen loads (post-frame, from _loadProgress), and
//   • opportunistically after any successful online persistence
//     (so a reconnection mid-session flushes the queue).
// When Firestore finally accepts the event, the pending record is
// removed, the local marker is set, and local XP is awarded exactly
// once. Firestore's transactional idempotency remains the ultimate
// authority — retries can never double-award XP or duplicate evidence.
//
// COURSE COMPLETION — RETRYABLE COPILOT SYNC
// ──────────────────────────────────────────
// Local completion (SharedPreferences `course_done_{courseId}`) is
// written first, preserving the existing offline UX. The Copilot
// completion sync (recordLessonCompleted) is treated as a separate,
// retryable step guarded by its own marker
// (`course_copilot_synced_{courseId}`) that is set ONLY after Firestore
// confirms. If the Firestore call fails, the marker stays unset and the
// sync is retried on the next _onComplete() or on the next screen load
// via _loadProgress(). recordLessonCompleted is idempotent on
// lessonId, so retries can never duplicate completion or XP.
//
// TOPIC EVIDENCE
// ──────────────
// The current model (course_content_data.dart) does not expose a
// per-question `topic` / `concept` field on quiz or challenge objects
// — the only referenced fields on those objects are question/prompt,
// options, correctIndex, explanation, and xpReward. To avoid inventing
// data or referencing a field that does not exist, the topic metadata
// uses the course-level `topicTitle` (a real, existing value) and the
// per-question granularity is preserved via `questionIndex` /
// `challengeIndex` metadata keys. If course_content_data.dart later
// exposes a per-question topic/concept field, that exact value should
// be substituted here.
//
// IMPORTANT: recordLessonCompleted is called WITHOUT totalLessons, so
// the existing per-career totalLessons value stored on the learning
// progress document is preserved. Only the append-only completedLessonIds
// array grows, keyed by a stable lessonId.
//
// NEXT-BUTTON FIX
// ────────────────
// In the Quiz and Challenge screens, the Submit/Next button's enabled
// state depends on BOTH `_answered` and `_selectedOpt`:
//   • Before answering (`_answered == false`): enabled only when an
//     option has been selected (`_selectedOpt != null`).
//   • After answering (`_answered == true`): always enabled, even if
//     `_selectedOpt` is null, so the user can never get stuck unable to
//     press "Next →". Submit/advance branching is untouched.
// ══════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course_content_data.dart';
import '../services/copilot_controller.dart';
import '../services/copilot_provider.dart';

// ── Public entry point ────────────────────────────────────────────────

class CourseEngineScreen extends StatefulWidget {
  final TopicCourse course;

  const CourseEngineScreen({super.key, required this.course});

  @override
  State<CourseEngineScreen> createState() => _CourseEngineScreenState();
}

/// Session-local learning evidence. Lives only on screen state; used for
/// UI display. The authoritative persistence happens via
/// CopilotController.recordCourseEvent for each individual event, and
/// per-event correctness/topic is forwarded as event metadata so Copilot
/// can reason about real mastery and weakness.
class _LearningEvidence {
  int quizCorrect = 0;
  int quizTotal = 0;
  int challengeCorrect = 0;
  int challengeTotal = 0;

  /// Topic labels the user answered incorrectly, in the order seen.
  final List<String> weakQuizTopics = <String>[];
  final List<String> weakChallengeTopics = <String>[];

  void recordQuiz({required bool correct, required String topic}) {
    quizTotal += 1;
    if (correct) {
      quizCorrect += 1;
    } else {
      weakQuizTopics.add(topic);
    }
  }

  void recordChallenge({required bool correct, required String topic}) {
    challengeTotal += 1;
    if (correct) {
      challengeCorrect += 1;
    } else {
      weakChallengeTopics.add(topic);
    }
  }

  double get quizAccuracy => quizTotal == 0 ? 0 : quizCorrect / quizTotal;
  double get challengeAccuracy =>
      challengeTotal == 0 ? 0 : challengeCorrect / challengeTotal;
}

class _CourseEngineScreenState extends State<CourseEngineScreen>
    with TickerProviderStateMixin {
  // ── Design tokens ─────────────────────────────────────────────────
  static const _bg = Color(0xFF0F0F1A);
  static const _surface = Color(0xFF1A1A2E);
  static const _border = Color(0xFF2A2A40);
  static const _primary = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted = Color(0xFF888899);
  static const _green = Color(0xFF4ADE80);
  static const _amber = Color(0xFFF59E0B);
  static const _red = Color(0xFFEF4444);

  // ── State ──────────────────────────────────────────────────────────
  int _screen = 0;
  int _conceptIndex = 0;
  int _quizIndex = 0;
  int _chalIndex = 0;

  int _xpEarned = 0;
  int _quizXpEarned = 0;
  int _challengeXpEarned = 0;
  int _projectXpEarned = 0;
  int? _selectedOpt;
  bool _answered = false;

  bool _alreadyCompletedBefore = false;
  bool _progressPersisted = false;

  /// In-flight guard for course events. An event id present here means a
  /// persist attempt for that event is currently running. Prevents
  /// rapid double-taps / concurrent submissions from racing past the
  /// check-then-write sequence and double-bumping the local counter.
  /// Set BEFORE the Firestore call and cleared in a finally block.
  final Set<String> _eventInFlight = <String>{};

  /// Session-local learning evidence (display-only).
  final _LearningEvidence _evidence = _LearningEvidence();

  // ── SharedPreferences keys ────────────────────────────────────────
  String get _doneKey => 'course_done_${widget.course.id}';
  String get _xpKey => 'course_xp_${widget.course.id}';

  /// Marker that the Copilot completion sync (recordLessonCompleted) has
  /// been confirmed by Firestore. Set ONLY after a successful call, so
  /// a failed sync stays retryable across screen loads.
  String get _copilotSyncKey => 'course_copilot_synced_${widget.course.id}';

  /// Lightweight offline pending-event queue. A single JSON array of
  /// records, each with { eventId, xpReward, eventType?, topic?,
  /// correct?, questionIndex?, challengeIndex? }. Cleared entry-by-entry
  /// as Firestore accepts each event. Kept entirely local — no new
  /// database, no new service.
  String get _pendingKey => 'course_pending_events_${widget.course.id}';

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final done = prefs.getBool(_doneKey) ?? false;
    final saved = prefs.getInt(_xpKey) ?? 0;
    final copilotSynced = prefs.getBool(_copilotSyncKey) ?? false;

    if (!mounted) return;
    setState(() {
      _alreadyCompletedBefore = done;
      // Temporary UI mirror only. It is immediately replaced by the
      // persisted Firestore evidence below when online.
      _xpEarned = saved;
    });

    await _syncAuthoritativeCourseProgress();

    // Retry any pending events queued while offline in a previous
    // session — deferred so the first frame paints immediately.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _retryPendingEvents();
    });

    // Retryable Copilot completion sync: if the course was marked
    // locally complete but the Copilot completion sync never succeeded
    // (e.g. the Firestore call failed on the previous attempt), retry
    // it now. recordLessonCompleted is idempotent on lessonId, so
    // retrying can never duplicate completion or XP.
    if (done && !copilotSynced) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _ensureCopilotCompletionSynced();
      });
    }
  }

  /// Rebuilds the Learn-tab XP display from persisted course evidence.
  /// Promised rewards, SharedPreferences alone, and course.totalXp are never
  /// treated as earned XP.
  Future<void> _syncAuthoritativeCourseProgress() async {
    final ctrl = mounted ? CopilotProvider.maybeOf(context) : null;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (ctrl == null || uid == null || widget.course.careerId.isEmpty) return;

    try {
      final breakdown = await ctrl.getCourseXpBreakdown(
        uid,
        careerId: widget.course.careerId,
        courseId: widget.course.id,
      );
      if (!mounted) return;
      setState(() {
        _quizXpEarned = breakdown['quiz'] ?? 0;
        _challengeXpEarned = breakdown['challenge'] ?? 0;
        _projectXpEarned = breakdown['project'] ?? 0;
        _xpEarned = breakdown['total'] ?? 0;
      });
    } catch (_) {}
  }

  late PageController _pageCtrl;
  late AnimationController _celebCtrl;
  late AnimationController _xpCtrl;

  late final int _conceptScreenStart;
  late final int _conceptScreenEnd;
  late final int _quizScreenId;
  late final int _chalScreenId;
  late final int _projectScreenId;
  late final int _doneScreenId;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    final c = widget.course;
    _conceptScreenStart = 1;
    _conceptScreenEnd = c.concepts.length;
    _quizScreenId = c.concepts.length + 1;
    _chalScreenId = c.concepts.length + 2;
    _projectScreenId = c.concepts.length + 3;
    _doneScreenId = c.concepts.length + 4;

    _pageCtrl = PageController();
    _celebCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
    _xpCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _celebCtrl.dispose();
    _xpCtrl.dispose();
    super.dispose();
  }

  void _next() {
    setState(() {
      _selectedOpt = null;
      _answered = false;

      if (_screen < _doneScreenId) {
        _screen++;
        if (_screen >= _conceptScreenStart && _screen <= _conceptScreenEnd) {
          _conceptIndex = _screen - 1;
        }
        if (_screen == _quizScreenId) _quizIndex = 0;
        if (_screen == _chalScreenId) _chalIndex = 0;
        if (_screen == _doneScreenId) _onComplete();
      }
    });
    HapticFeedback.lightImpact();
  }

  /// Increments the local display counter, triggers the brief XP-pulse
  /// animation, and immediately persists the new total to the existing
  /// SharedPreferences key so it survives an app restart.
  ///
  /// This is a UX mirror only — Firestore (users/{uid}.totalXp) remains
  /// the authoritative source of XP. Persistence failure here is
  /// non-fatal and silent; the in-memory counter still reflects the new
  /// value for the current session.
  Future<void> _addXpAndPersist(int amount) async {
    setState(() => _xpEarned += amount);
    _xpCtrl.forward(from: 0);
    HapticFeedback.mediumImpact();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_xpKey, _xpEarned);
    } catch (_) {
      // Best-effort local mirror — Firestore stays authoritative.
    }
  }

  // ── Local idempotency marker for the display XP counter ─────────────
  //
  // Keyed by the stable event id used for Firestore persistence. The
  // marker MIRRORS Firestore state — it is written only after Firestore
  // confirms the event exists. It is a fast-path cache, never the
  // authority on XP. Firestore remains the authoritative source for
  // persisted XP on users/{uid}.totalXp.
  String _eventMarkerKey(String eventId) =>
      'course_evt_done_${widget.course.id}_$eventId';

  Future<bool> _eventAlreadyRecorded(String eventId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_eventMarkerKey(eventId)) ?? false;
    } catch (_) {
      // If SharedPreferences is unavailable, assume not recorded so the
      // Firestore call is still made (its transaction is idempotent).
      return false;
    }
  }

  Future<void> _markEventRecorded(String eventId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_eventMarkerKey(eventId), true);
    } catch (_) {
      // Best-effort. Firestore is still authoritative for XP and history.
    }
  }

  // ── Offline pending-event queue (local, lightweight) ────────────────
  //
  // A single JSON-encoded array under `course_pending_events_{courseId}`.
  // No new database, no new service — just SharedPreferences. This is
  // the ONLY mechanism that records events Firestore has not yet
  // accepted, so offline answers are never silently lost and never
  // falsely reported as saved.

  Future<List<Map<String, dynamic>>> _loadPendingEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_pendingKey);
      if (raw == null || raw.isEmpty) return <Map<String, dynamic>>[];
      final decoded = jsonDecode(raw);
      if (decoded is! List) return <Map<String, dynamic>>[];
      return decoded
          .whereType<Map>()
          .map((m) => m.cast<String, dynamic>())
          .toList();
    } catch (_) {
      return <Map<String, dynamic>>[];
    }
  }

  Future<bool> _savePendingEvents(List<Map<String, dynamic>> events) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_pendingKey, jsonEncode(events));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _queuePendingEvent(Map<String, dynamic> record) async {
    try {
      final events = await _loadPendingEvents();
      final eventId = record['eventId'];
      if (eventId is! String) return false;
      // Idempotent queue: never enqueue the same event id twice.
      if (events.any((e) => e['eventId'] == eventId)) return true;
      events.add(record);
      return await _savePendingEvents(events);
    } catch (_) {
      return false;
    }
  }

  Future<void> _removePendingEvent(String eventId) async {
    try {
      final events = await _loadPendingEvents();
      final filtered = events.where((e) => e['eventId'] != eventId).toList();
      if (filtered.length == events.length) return;
      await _savePendingEvents(filtered);
    } catch (_) {
      // Best-effort. If removal fails, the event will be re-checked and
      // skipped on the next retry (Firestore is still idempotent).
    }
  }

  /// Flushes queued offline events against Firestore. Stops early if
  /// Firestore is still unreachable, so remaining events stay queued.
  /// Idempotent end-to-end: Firestore rejects duplicate event ids and
  /// the local marker prevents double-awarding the display counter.
  Future<void> _retryPendingEvents() async {
    final ctrl = mounted ? CopilotProvider.maybeOf(context) : null;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (ctrl == null || uid == null) return;

    final pending = await _loadPendingEvents();
    if (pending.isEmpty) return;

    for (final evt in pending) {
      final eventId = evt['eventId'];
      if (eventId is! String) continue;
      if (_eventInFlight.contains(eventId)) continue;

      // If Firestore already recorded this event on a prior attempt,
      // just clear the queue entry.
      if (await _eventAlreadyRecorded(eventId)) {
        await _removePendingEvent(eventId);
        continue;
      }

      final xpReward =
          (evt['xpReward'] is num) ? (evt['xpReward'] as num).toInt() : 0;

      final metadata = <String, dynamic>{};
      if (evt['eventType'] != null) metadata['eventType'] = evt['eventType'];
      if (evt['topic'] != null) metadata['topic'] = evt['topic'];
      if (evt['correct'] != null) metadata['correct'] = evt['correct'];
      if (evt['questionIndex'] != null)
        metadata['questionIndex'] = evt['questionIndex'];
      if (evt['challengeIndex'] != null)
        metadata['challengeIndex'] = evt['challengeIndex'];

      _eventInFlight.add(eventId);
      try {
        final wasNewlyRecorded = await ctrl.recordCourseEvent(
          uid,
          careerId: widget.course.careerId,
          eventId: eventId,
          xpReward: xpReward,
          eventType: evt['eventType'] as String?,
          topic: evt['topic'] as String?,
          correct: evt['correct'] as bool?,
        );

        // Pending retries are exactly-once too: only a newly-created
        // Firestore event can increase the local mirror.
        if (wasNewlyRecorded && xpReward > 0) {
          await _addXpAndPersist(xpReward);
        }
        await _syncAuthoritativeCourseProgress();
        await _markEventRecorded(eventId);
        await _removePendingEvent(eventId);
      } catch (_) {
        // Still offline / transient failure — stop and leave the rest
        // queued. No XP was awarded.
        break;
      } finally {
        _eventInFlight.remove(eventId);
      }
    }
  }

  /// Persists ONE course event through the existing
  /// CopilotController.recordCourseEvent path.
  ///
  /// Authority & idempotency:
  ///   • Firestore is authoritative. `recordCourseEvent` returns whether
  ///     THIS call actually wrote a new event (`true`) or found the id
  ///     already present (`false`). The local XP mirror is advanced only
  ///     on `true` — a missing local marker is never treated as proof
  ///     that an event is new.
  ///   • The local SharedPreferences marker mirrors Firestore state and
  ///     is only a fast-path cache. It never authoritatively decides XP.
  ///   • In-flight guard prevents racing duplicate submissions.
  ///
  /// Offline behavior:
  ///   • If no controller / user is available, the event is written to
  ///     the local pending queue and NO local XP is awarded. The call
  ///     returns true so the UI can advance (preserving the existing
  ///     offline UX), but the event is not treated as saved until
  ///     Firestore confirms it via _retryPendingEvents.
  ///   • If the Firestore call throws, the event is queued and the call
  ///     returns false so the caller does not advance (existing retry
  ///     snackbar behavior).
  ///
  /// Evidence metadata: `eventType`, `topic`, `correct`, and (for quiz /
  /// challenge) an index key are forwarded through the existing optional
  /// metadata parameter, so the Copilot intelligence loop can
  /// distinguish persistent mastery from persistent weakness.
  Future<bool> _persistCourseEvent({
    required String eventId,
    required int xpReward,
    String? eventType,
    String? topic,
    bool? correct,
    Map<String, dynamic>? extraMetadata,
  }) async {
    if (_eventInFlight.contains(eventId)) return true;
    _eventInFlight.add(eventId);

    // Build the pending record up front so every failure path can queue
    // the exact same payload without duplicating construction code.
    final pendingRecord = <String, dynamic>{
      'eventId': eventId,
      'xpReward': xpReward,
      if (eventType != null) 'eventType': eventType,
      if (topic != null) 'topic': topic,
      if (correct != null) 'correct': correct,
      if (extraMetadata != null) ...extraMetadata,
    };

    try {
      final ctrl = mounted ? CopilotProvider.maybeOf(context) : null;
      final uid = FirebaseAuth.instance.currentUser?.uid;

      // ── Offline path ────────────────────────────────────────────
      // No controller / user: queue the event locally, do NOT award
      // local XP, do NOT mark it as recorded. Preserve the existing
      // offline UX (return true so the UI can advance) — the event
      // will be flushed later by _retryPendingEvents.
      if (ctrl == null || uid == null) {
        final queued = await _queuePendingEvent(pendingRecord);
        return queued;
      }

      // Local marker present → Firestore already has the event (the
      // marker is only written after Firestore confirmation). Clear any
      // stale pending entry and short-circuit.
      if (await _eventAlreadyRecorded(eventId)) {
        await _removePendingEvent(eventId);
        return true;
      }

      final metadata = <String, dynamic>{
        if (eventType != null) 'eventType': eventType,
        if (topic != null) 'topic': topic,
        if (correct != null) 'correct': correct,
        if (extraMetadata != null) ...extraMetadata,
      };

      try {
        // Firestore is authoritative. Its transactional write tells us
        // whether THIS call actually recorded a new event (`true`) or
        // the event id already existed (`false`, idempotent no-op).
        final wasNewlyRecorded = await ctrl.recordCourseEvent(
          uid,
          careerId: widget.course.careerId,
          eventId: eventId,
          xpReward: xpReward,
          eventType: eventType,
          topic: topic,
          correct: correct,
        );

        // The local mirror advances ONLY when Firestore says this call
        // created a NEW evidence event. Duplicate/retry calls add 0 XP.
        if (wasNewlyRecorded && xpReward > 0) {
          await _addXpAndPersist(xpReward);
        }
        await _syncAuthoritativeCourseProgress();
        await _markEventRecorded(eventId);
        await _removePendingEvent(eventId);

        // Opportunistic flush of older queued events now that we know
        // Firestore is reachable in this session.
        unawaited(_retryPendingEvents());
        return true;
      } catch (_) {
        // Firestore call failed. Queue the event so it is not lost,
        // keep the existing failure UX (return false so the caller
        // does not advance and the user can retry).
        await _queuePendingEvent(pendingRecord);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Couldn\'t save your progress. Please try again.'),
              backgroundColor: Color(0xFFEF4444),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return false;
      }
    } finally {
      _eventInFlight.remove(eventId);
    }
  }

  /// Persists the completion of the course through the existing
  /// recordLessonCompleted path, and triggers the existing intelligence
  /// refresh. Returns true on success, false on a genuine persistence
  /// failure. Offline (no controller/user) returns true so the existing
  /// offline UX is preserved — the sync marker is only set when the
  /// controller + user were actually present.
  Future<bool> _persistCourseCompletion() async {
    final ctrl = mounted ? CopilotProvider.maybeOf(context) : null;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (ctrl == null || uid == null) return true;

    try {
      final saved = await ctrl.recordLessonCompleted(
        uid,
        careerId: widget.course.careerId,
        lessonId: 'course:${widget.course.id}',
        currentLevelTitle: widget.course.topicTitle,
        // totalLessons intentionally NOT passed so the per-career
        // totalLessons value on the learning-progress document is
        // preserved.
      );
      return saved;
    } catch (_) {
      return false;
    }
  }

  /// Retryable Copilot completion sync.
  ///
  /// Idempotent:
  ///   • If the local sync marker is already set, no-op.
  ///   • Otherwise call the existing recordLessonCompleted path. On
  ///     success, set the local marker. On failure, leave the marker
  ///     unset so the sync is retried on the next _onComplete() or on
  ///     the next screen load via _loadProgress().
  ///   • When offline (no controller/user), the sync is not marked as
  ///     done, so it is attempted again later.
  ///
  /// recordLessonCompleted is idempotent on lessonId, so retrying can
  /// never duplicate completion or XP.
  Future<bool> _ensureCopilotCompletionSynced() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_copilotSyncKey) ?? false) return true;
    } catch (_) {
      // If prefs are unavailable, fall through and attempt the sync.
    }

    final ctrl = mounted ? CopilotProvider.maybeOf(context) : null;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final ok = await _persistCourseCompletion();
    if (!ok) return false;

    // Only mark the sync as complete when Firestore was actually
    // reachable (controller + user present). Offline completions remain
    // pending and are retried later.
    if (ctrl != null && uid != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_copilotSyncKey, true);
      } catch (_) {
        // Best-effort marker. If it fails, we retry next time — the
        // Firestore call itself is idempotent.
      }
    }
    return true;
  }

  /// Persists local session state and records the lesson completion into
  /// the existing Copilot/learning progress system.
  ///
  /// Save-state honesty:
  ///   • Local SharedPreferences is written first. If that write fails,
  ///     the course is NOT marked complete locally, and _progressPersisted
  ///     is rolled back so the user can retry.
  ///   • The Copilot completion sync is awaited and retryable. Its own
  ///     marker is set only after Firestore confirms, so a failed sync
  ///     remains retryable on the next screen load or completion.
  ///   • The append-only lesson history is idempotent, so retries cannot
  ///     duplicate completion or XP.
  Future<void> _onComplete() async {
    if (_progressPersisted) return;
    _progressPersisted = true;

    final prefs = await SharedPreferences.getInstance();

    bool localSaved = false;
    try {
      await prefs.setBool(_doneKey, true);
      await prefs.setInt(_xpKey, _xpEarned);
      localSaved = true;
    } catch (_) {
      localSaved = false;
    }

    if (!localSaved) {
      _progressPersisted = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Couldn\'t save your progress locally. Please try again.'),
            backgroundColor: Color(0xFFEF4444),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    _alreadyCompletedBefore = true;

    // Retryable Copilot completion sync. Local completion stands even
    // if this fails; the sync marker gates whether Firestore confirmed.
    await _ensureCopilotCompletionSynced();

    await _syncAuthoritativeCourseProgress();
  }

  // ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildProgressBar(),
            Expanded(child: _buildCurrentScreen()),
          ],
        ),
      ),
    );
  }

  // ── Top bar ──────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _confirmExit(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _border),
              ),
              child: const Icon(Icons.close, color: _muted, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(widget.course.topicTitle,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          AnimatedBuilder(
            animation: _xpCtrl,
            builder: (_, __) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_primary, _secondary]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: _xpCtrl.value > 0
                    ? [
                        BoxShadow(
                            color: _primary.withOpacity(_xpCtrl.value * 0.5),
                            blurRadius: 12)
                      ]
                    : const [],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('⚡', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text('$_xpEarned XP',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Progress bar ─────────────────────────────────────────────────
  Widget _buildProgressBar() {
    final total = _doneScreenId + 1;
    final progress = _screen / total;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: _border,
              valueColor: const AlwaysStoppedAnimation(_primary),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_stepLabel(),
                  style: const TextStyle(color: _muted, fontSize: 10)),
              Text('${(_screen / total * 100).toInt()}%',
                  style: const TextStyle(color: _secondary, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  String _stepLabel() {
    if (_screen == 0) return 'Introduction';
    if (_screen <= _conceptScreenEnd)
      return 'Concept ${_screen}/${widget.course.concepts.length}';
    if (_screen == _quizScreenId) return 'Quiz';
    if (_screen == _chalScreenId) return 'Challenges';
    if (_screen == _projectScreenId) return 'Final Project';
    return 'Complete!';
  }

  Widget _buildCurrentScreen() {
    if (_screen == 0) return _introScreen();
    if (_screen <= _conceptScreenEnd) return _conceptScreen();
    if (_screen == _quizScreenId) return _quizScreen();
    if (_screen == _chalScreenId) return _challengeScreen();
    if (_screen == _projectScreenId) return _projectScreen();
    return _completionScreen();
  }

  // ══════════════════════════════════════════════════════════════════
  // SCREEN 0 — INTRO
  // ══════════════════════════════════════════════════════════════════
  Widget _introScreen() {
    final c = widget.course;
    final diffColor = c.difficulty == 'Easy'
        ? _green
        : c.difficulty == 'Medium'
            ? _amber
            : _red;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _primary.withOpacity(0.3),
                  _secondary.withOpacity(0.15)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(color: _secondary.withOpacity(0.4), width: 2),
            ),
            child: Center(
                child: Text(c.emoji, style: const TextStyle(fontSize: 48))),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 24),
          Text(c.topicTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold))
              .animate()
              .fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          Text(
                  _alreadyCompletedBefore
                      ? 'Already completed — reopen any time to revise'
                      : 'Master this concept step by step',
                  style: const TextStyle(color: _muted, fontSize: 14))
              .animate()
              .fadeIn(delay: 300.ms),
          const SizedBox(height: 28),
          Row(children: [
            Expanded(
                child: _metaCard('🎯', 'Difficulty', c.difficulty, diffColor)),
            const SizedBox(width: 10),
            Expanded(
                child: _metaCard(
                    '⏱️', 'Time', '~${c.estimatedMinutes} min', _secondary)),
            const SizedBox(width: 10),
            Expanded(
                child: _metaCard('⚡', 'XP Reward', '+${c.totalXp} XP',
                    const Color(0xFFF59E0B))),
          ]).animate().fadeIn(delay: 350.ms),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('What you\'ll learn:',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                const SizedBox(height: 12),
                ..._buildLearnList(c),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _primary.withOpacity(0.25)),
            ),
            child: Text(c.intro,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 13, height: 1.6)),
          ).animate().fadeIn(delay: 450.ms),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Start Learning',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _metaCard(String emoji, String label, String value, Color color) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 5),
          Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          Text(label, style: const TextStyle(color: _muted, fontSize: 10)),
        ]),
      );

  List<Widget> _buildLearnList(TopicCourse c) {
    final items = [
      '${c.concepts.length} core concepts explained simply',
      '${c.quiz.length} quiz questions to test yourself',
      '${c.challenges.length} interactive mini challenges',
      'Final project with step-by-step guide',
    ];
    return items
        .map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                const Icon(Icons.check_circle, color: _green, size: 16),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(item,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13))),
              ]),
            ))
        .toList();
  }

  // ══════════════════════════════════════════════════════════════════
  // SCREEN 1..N — CONCEPT LESSONS
  // ══════════════════════════════════════════════════════════════════
  Widget _conceptScreen() {
    final concept = widget.course.concepts[_conceptIndex];
    final isLast = _conceptIndex == widget.course.concepts.length - 1;

    return SingleChildScrollView(
      key: ValueKey('concept_$_conceptIndex'),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _primary.withOpacity(0.3)),
              ),
              child: Text(
                'Concept ${_conceptIndex + 1}/${widget.course.concepts.length}',
                style: const TextStyle(
                    color: _secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ]).animate().fadeIn(),
          const SizedBox(height: 16),
          Text(concept.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold))
              .animate()
              .fadeIn(delay: 50.ms)
              .slideX(begin: -0.05),
          const SizedBox(height: 20),
          _conceptSection(
            icon: '📖',
            label: 'Definition',
            color: const Color(0xFF60A5FA),
            child: Text(concept.definition,
                style: const TextStyle(
                    color: Colors.white, fontSize: 14, height: 1.6)),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 14),
          _conceptSection(
            icon: '🧠',
            label: 'Real-World Analogy',
            color: _amber,
            child: Text(concept.analogy,
                style: const TextStyle(
                    color: Colors.white, fontSize: 13, height: 1.6)),
          ).animate().fadeIn(delay: 160.ms),
          const SizedBox(height: 14),
          _conceptSection(
            icon: '💡',
            label: 'Example',
            color: _green,
            child: Text(concept.example,
                style: const TextStyle(
                    color: Color(0xFF6EE7B7),
                    fontFamily: 'monospace',
                    fontSize: 13,
                    height: 1.6)),
          ).animate().fadeIn(delay: 220.ms),
          if (concept.codeSnippet != null) ...[
            const SizedBox(height: 14),
            _codeBlock(concept.codeSnippet!).animate().fadeIn(delay: 270.ms),
          ],
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _primary.withOpacity(0.18),
                  _primary.withOpacity(0.06)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _primary.withOpacity(0.35)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🎯 ', style: TextStyle(fontSize: 18)),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Key Takeaway',
                          style: TextStyle(
                              color: _secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                      const SizedBox(height: 5),
                      Text(concept.keyTakeaway,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13, height: 1.5)),
                    ]),
              ),
            ]),
          ).animate().fadeIn(delay: 320.ms),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLast ? 'Start Quiz →' : 'Next Concept →',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 380.ms),
        ],
      ),
    );
  }

  Widget _conceptSection({
    required String icon,
    required String label,
    required Color color,
    required Widget child,
  }) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('$icon ', style: const TextStyle(fontSize: 16)),
            Text(label,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w600, fontSize: 12)),
          ]),
          const SizedBox(height: 8),
          child,
        ]),
      );

  Widget _codeBlock(String code) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A14),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF333345)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Text('💻 ', style: TextStyle(fontSize: 13)),
            const Text('Code',
                style: TextStyle(
                    color: _muted, fontSize: 11, fontWeight: FontWeight.w600)),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: code));
                _snack('Code copied!');
              },
              child: const Row(children: [
                Icon(Icons.copy, color: _muted, size: 13),
                SizedBox(width: 3),
                Text('Copy', style: TextStyle(color: _muted, fontSize: 10)),
              ]),
            ),
          ]),
          const SizedBox(height: 10),
          SelectableText(code,
              style: const TextStyle(
                  color: Color(0xFF6EE7B7),
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.6)),
        ]),
      );

  // ══════════════════════════════════════════════════════════════════
  // QUIZ SCREEN
  // ══════════════════════════════════════════════════════════════════
  Widget _quizScreen() {
    if (_quizIndex >= widget.course.quiz.length) {
      return _nextSectionBridge(
        icon: '🎉',
        title: 'Quiz Complete!',
        subtitle: 'You answered all ${widget.course.quiz.length} questions',
        xpNote: '+${widget.course.quiz.length * 10} XP from quiz',
        btnLabel: 'Mini Challenges →',
      );
    }

    final q = widget.course.quiz[_quizIndex];

    return SingleChildScrollView(
      key: ValueKey('quiz_$_quizIndex'),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _amber.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _amber.withOpacity(0.3)),
              ),
              child: Text(
                  'Question ${_quizIndex + 1}/${widget.course.quiz.length}',
                  style: const TextStyle(
                      color: _amber,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ),
            const Spacer(),
            Text('+${q.xpReward} XP',
                style: const TextStyle(
                    color: _secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ]).animate().fadeIn(),
          const SizedBox(height: 18),
          Text(q.question,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.4))
              .animate()
              .fadeIn(delay: 60.ms),
          const SizedBox(height: 24),
          ...q.options.asMap().entries.map((e) {
            final i = e.key;
            final opt = e.value;
            final sel = _selectedOpt == i;
            final right = _answered && i == q.correctIndex;
            final wrong = _answered && sel && i != q.correctIndex;

            Color borderColor = _border;
            Color bgColor = _surface;
            Color textColor = Colors.white;
            Widget? trailingIcon;

            if (right) {
              borderColor = _green;
              bgColor = _green.withOpacity(0.12);
              textColor = _green;
              trailingIcon =
                  const Icon(Icons.check_circle, color: _green, size: 18);
            } else if (wrong) {
              borderColor = _red;
              bgColor = _red.withOpacity(0.10);
              textColor = _red;
              trailingIcon = const Icon(Icons.cancel, color: _red, size: 18);
            } else if (sel && !_answered) {
              borderColor = _primary;
              bgColor = _primary.withOpacity(0.12);
              textColor = _secondary;
            }

            return GestureDetector(
              onTap: _answered ? null : () => setState(() => _selectedOpt = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: borderColor,
                      width: sel || right || wrong ? 1.5 : 1),
                ),
                child: Row(children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (sel || right || wrong)
                          ? borderColor.withOpacity(0.15)
                          : const Color(0xFF0F0F20),
                      border: Border.all(color: borderColor),
                    ),
                    child: Center(
                      child: Text('ABCD'[i],
                          style: TextStyle(
                              color:
                                  sel || right || wrong ? borderColor : _muted,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(opt,
                          style: TextStyle(color: textColor, fontSize: 14))),
                  if (trailingIcon != null) trailingIcon,
                ]),
              ),
            ).animate().fadeIn(delay: Duration(milliseconds: 100 + i * 60));
          }),
          const SizedBox(height: 8),
          if (_answered) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _secondary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _secondary.withOpacity(0.25)),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [
                      Text('💡 ', style: TextStyle(fontSize: 16)),
                      Text('Explanation',
                          style: TextStyle(
                              color: _secondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ]),
                    const SizedBox(height: 6),
                    Text(q.explanation,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13, height: 1.5)),
                  ]),
            ).animate().fadeIn().slideY(begin: 0.2),
            const SizedBox(height: 16),
          ],
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: (!_answered && _selectedOpt == null)
                  ? null
                  : () async {
                      if (!_answered) {
                        final correct = _selectedOpt == q.correctIndex;

                        // Persist the answer as durable evidence FIRST.
                        //   • Correct → existing mastery event id, XP awarded.
                        //   • Wrong   → additive `quiz_miss:` weakness event,
                        //               0 XP, does not block a later correct
                        //               retry (different event id).
                        // Offline: queued locally; no XP awarded until
                        // Firestore confirms.
                        final eventId = correct
                            ? 'quiz:${widget.course.id}:$_quizIndex'
                            : 'quiz_miss:${widget.course.id}:$_quizIndex';

                        final ok = await _persistCourseEvent(
                          eventId: eventId,
                          xpReward: correct ? q.xpReward : 0,
                          eventType: correct ? 'quiz' : 'quiz_miss',
                          // No per-question topic field is exposed by the
                          // current model, so the real course topicTitle is
                          // used. Per-question granularity is preserved via
                          // the additive questionIndex metadata key.
                          topic: widget.course.topicTitle,
                          correct: correct,
                          extraMetadata: {'questionIndex': _quizIndex},
                        );
                        if (!mounted || !ok) return;

                        setState(() => _answered = true);
                        _evidence.recordQuiz(
                          correct: correct,
                          topic: widget.course.topicTitle,
                        );
                      } else {
                        setState(() {
                          _quizIndex++;
                          _selectedOpt = null;
                          _answered = false;
                        });
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _answered ? _green : _primary,
                disabledBackgroundColor: _border,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                _answered ? 'Next →' : 'Submit Answer',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // CHALLENGE SCREEN
  // ══════════════════════════════════════════════════════════════════
  Widget _challengeScreen() {
    if (_chalIndex >= widget.course.challenges.length) {
      return _nextSectionBridge(
        icon: '🏆',
        title: 'Challenges Done!',
        subtitle:
            'Excellent work on all ${widget.course.challenges.length} challenges',
        xpNote: '+${widget.course.challenges.length * 15} XP from challenges',
        btnLabel: 'Final Project →',
      );
    }

    final ch = widget.course.challenges[_chalIndex];

    return SingleChildScrollView(
      key: ValueKey('chal_$_chalIndex'),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _green.withOpacity(0.3)),
              ),
              child: Text(
                  'Challenge ${_chalIndex + 1}/${widget.course.challenges.length}',
                  style: const TextStyle(
                      color: _green,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ),
            const Spacer(),
            Text('+${ch.xpReward} XP',
                style: const TextStyle(
                    color: _secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ]).animate().fadeIn(),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1A0F),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _green.withOpacity(0.3)),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Text('💻 ', style: TextStyle(fontSize: 16)),
                Text('Mini Challenge',
                    style: TextStyle(
                        color: _green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 10),
              Text(ch.prompt,
                  style: const TextStyle(
                      color: Color(0xFF6EE7B7),
                      fontFamily: 'monospace',
                      fontSize: 13,
                      height: 1.6)),
            ]),
          ).animate().fadeIn(delay: 60.ms),
          const SizedBox(height: 20),
          ...ch.options.asMap().entries.map((e) {
            final i = e.key;
            final opt = e.value;
            final sel = _selectedOpt == i;
            final right = _answered && i == ch.correctIndex;
            final wrong = _answered && sel && i != ch.correctIndex;

            Color borderColor = _border;
            Color bgColor = _surface;
            Color textColor = Colors.white;
            Widget? trailingIcon;

            if (right) {
              borderColor = _green;
              bgColor = _green.withOpacity(0.12);
              textColor = _green;
              trailingIcon =
                  const Icon(Icons.check_circle, color: _green, size: 18);
            } else if (wrong) {
              borderColor = _red;
              bgColor = _red.withOpacity(0.10);
              textColor = _red;
              trailingIcon = const Icon(Icons.cancel, color: _red, size: 18);
            } else if (sel && !_answered) {
              borderColor = _primary;
              bgColor = _primary.withOpacity(0.12);
              textColor = _secondary;
            }

            return GestureDetector(
              onTap: _answered ? null : () => setState(() => _selectedOpt = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: borderColor,
                      width: sel || right || wrong ? 1.5 : 1),
                ),
                child: Row(children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (sel || right || wrong)
                          ? borderColor.withOpacity(0.15)
                          : const Color(0xFF0F0F20),
                      border: Border.all(color: borderColor),
                    ),
                    child: Center(
                      child: Text('ABCD'[i],
                          style: TextStyle(
                              color:
                                  sel || right || wrong ? borderColor : _muted,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(opt,
                          style: TextStyle(color: textColor, fontSize: 13))),
                  if (trailingIcon != null) trailingIcon,
                ]),
              ),
            ).animate().fadeIn(delay: Duration(milliseconds: 80 + i * 55));
          }),
          if (_answered) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _secondary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _secondary.withOpacity(0.25)),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [
                      Text('💡 ', style: TextStyle(fontSize: 16)),
                      Text('Explanation',
                          style: TextStyle(
                              color: _secondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ]),
                    const SizedBox(height: 6),
                    Text(ch.explanation,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13, height: 1.5)),
                  ]),
            ).animate().fadeIn().slideY(begin: 0.2),
            const SizedBox(height: 16),
          ],
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: (!_answered && _selectedOpt == null)
                  ? null
                  : () async {
                      if (!_answered) {
                        final correct = _selectedOpt == ch.correctIndex;

                        // Persist mastery (correct) or weakness (incorrect)
                        // as durable evidence, exactly like the quiz screen.
                        final eventId = correct
                            ? 'challenge:${widget.course.id}:$_chalIndex'
                            : 'challenge_miss:${widget.course.id}:$_chalIndex';

                        final ok = await _persistCourseEvent(
                          eventId: eventId,
                          xpReward: correct ? ch.xpReward : 0,
                          eventType: correct ? 'challenge' : 'challenge_miss',
                          // See quiz screen comment — no per-challenge topic
                          // field exists on the current model, so topicTitle is
                          // used and granularity is preserved via
                          // challengeIndex metadata.
                          topic: widget.course.topicTitle,
                          correct: correct,
                          extraMetadata: {'challengeIndex': _chalIndex},
                        );
                        if (!mounted || !ok) return;

                        setState(() => _answered = true);
                        _evidence.recordChallenge(
                          correct: correct,
                          topic: widget.course.topicTitle,
                        );
                      } else {
                        setState(() {
                          _chalIndex++;
                          _selectedOpt = null;
                          _answered = false;
                        });
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _answered ? _green : _primary,
                disabledBackgroundColor: _border,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(_answered ? 'Next →' : 'Submit',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // FINAL PROJECT SCREEN
  // ══════════════════════════════════════════════════════════════════
  Widget _projectScreen() {
    final p = widget.course.finalProject;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_primary, _secondary]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('🚀 Final Project',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ).animate().fadeIn(),
          const SizedBox(height: 18),
          Text(p.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold))
              .animate()
              .fadeIn(delay: 60.ms),
          const SizedBox(height: 16),
          _projectSection('🎯 Project Goal', p.goal, const Color(0xFF60A5FA))
              .animate()
              .fadeIn(delay: 100.ms),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Text('📋 ', style: TextStyle(fontSize: 16)),
                Text('Steps to Complete',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
              ]),
              const SizedBox(height: 12),
              ...p.steps.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _primary.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: _primary.withOpacity(0.4)),
                            ),
                            child: Center(
                              child: Text('${e.key + 1}',
                                  style: const TextStyle(
                                      color: _secondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(e.value,
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    height: 1.4)),
                          ),
                        ]),
                  )),
            ]),
          ).animate().fadeIn(delay: 160.ms),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1A0F),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _green.withOpacity(0.3)),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Text('✅ ', style: TextStyle(fontSize: 14)),
                Text('Expected Output',
                    style: TextStyle(
                        color: _green,
                        fontWeight: FontWeight.w600,
                        fontSize: 12)),
              ]),
              const SizedBox(height: 8),
              Text(p.expectedOutput,
                  style: const TextStyle(
                      color: Color(0xFF6EE7B7),
                      fontFamily: 'monospace',
                      fontSize: 12,
                      height: 1.6)),
            ]),
          ).animate().fadeIn(delay: 220.ms),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _primary.withOpacity(0.25)),
            ),
            child: Row(children: [
              const Text('⚡ ', style: TextStyle(fontSize: 18)),
              Text('Complete this project to earn +${p.xpReward} XP bonus!',
                  style: const TextStyle(
                      color: _secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
            ]),
          ).animate().fadeIn(delay: 280.ms),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () async {
                final eventId = 'project:${widget.course.id}';
                final ok = await _persistCourseEvent(
                  eventId: eventId,
                  xpReward: p.xpReward,
                  eventType: 'project',
                  topic: widget.course.topicTitle,
                  correct: true,
                );
                if (!mounted || !ok) return;
                _next();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Mark Project Complete ✓',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ).animate().fadeIn(delay: 340.ms),
        ],
      ),
    );
  }

  Widget _projectSection(String title, String content, Color color) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          Text(content,
              style: const TextStyle(
                  color: Colors.white, fontSize: 13, height: 1.5)),
        ]),
      );

  // ══════════════════════════════════════════════════════════════════
  // COMPLETION SCREEN
  // ══════════════════════════════════════════════════════════════════
  Widget _completionScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      child: Column(
        children: [
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _celebCtrl,
            builder: (_, __) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: _celebCtrl.value * 2 * pi,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _secondary.withOpacity(
                              0.3 + 0.2 * sin(_celebCtrl.value * 2 * pi)),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: -_celebCtrl.value * 2 * pi * 0.7,
                    child: Container(
                      width: 105,
                      height: 105,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: _primary.withOpacity(0.4), width: 1.5),
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1A0A35),
                    ),
                    child: const Center(
                        child: Text('🏆', style: TextStyle(fontSize: 38))),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          const Text('Lesson Complete!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold))
              .animate()
              .fadeIn(delay: 100.ms),
          const SizedBox(height: 8),
          Text(
            '${widget.course.topicTitle} — Completed ✓',
            textAlign: TextAlign.center,
            style: const TextStyle(color: _secondary, fontSize: 15),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _primary.withOpacity(0.25),
                  _secondary.withOpacity(0.10)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _primary.withOpacity(0.4), width: 1.5),
            ),
            child: Column(children: [
              const Text('⚡ XP Earned',
                  style: TextStyle(color: _muted, fontSize: 13)),
              const SizedBox(height: 6),
              Text('+$_xpEarned XP',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _xpBreakdown('Quiz', '$_quizXpEarned'),
                _xpBreakdown('Challenges', '$_challengeXpEarned'),
                _xpBreakdown('Project', '$_projectXpEarned'),
              ]),
            ]),
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Concepts Covered:',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
              const SizedBox(height: 10),
              ...widget.course.concepts.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(children: [
                      const Icon(Icons.check_circle, color: _green, size: 16),
                      const SizedBox(width: 8),
                      Text(c.title,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13)),
                    ]),
                  )),
            ]),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Continue Learning →',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _xpBreakdown(String label, String xp) => Column(children: [
        Text('+$xp',
            style: const TextStyle(
                color: _secondary, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: _muted, fontSize: 10)),
      ]);

  // ── Bridge screen between sections ──────────────────────────────
  Widget _nextSectionBridge({
    required String icon,
    required String title,
    required String subtitle,
    required String xpNote,
    required String btnLabel,
  }) =>
      Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(icon, style: const TextStyle(fontSize: 56))
                .animate()
                .scale(duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: _muted, fontSize: 14)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: _primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(xpNote,
                  style: const TextStyle(
                      color: _secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 220,
              height: 50,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(btnLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ),
      );

  // ── Confirm exit ─────────────────────────────────────────────────
  void _confirmExit() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: _surface,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text('Quit Lesson?',
                  style: TextStyle(color: Colors.white)),
              content: Text(
                'You\'ve earned $_xpEarned XP so far. Your progress will be saved.',
                style: const TextStyle(color: _muted),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Keep Learning',
                        style: TextStyle(color: _secondary))),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _red, elevation: 0),
                  child: const Text('Quit'),
                ),
              ],
            ));
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.white)),
      backgroundColor: _surface,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 1),
    ));
  }
}
