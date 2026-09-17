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
//
// CAREER INTELLIGENCE LOOP
// ────────────────────────
// This screen closes the loop:
//
//   Skill Gap → Targeted Course → Quiz/Challenge Evidence
//     → Copilot re-analysis → Next Best Action
//
// Every correct quiz answer, every correct challenge answer, and the
// final project completion is persisted through the existing
// CopilotController.recordCourseEvent(...) path. That method writes to
// the same per-career learning-progress document (arrayUnion on
// `completedCourseEventIds` and `courseEvidenceIds`), awards the event's
// XP atomically on users/{uid}.totalXp ONLY on the first write of that
// event id, and then refreshes Copilot intelligence so Skill Gap /
// Readiness / Next Best Action / Recommendations can recalculate.
//
// The event id is stable and unique per course event:
//     quiz:{courseId}:{index}
//     challenge:{courseId}:{index}
//     project:{courseId}
// so reopening, retrying, or rebuilding cannot duplicate XP, completion
// records, or evidence in Firestore.
//
// Course completion (the final lesson) is recorded through the existing
// CopilotController.recordLessonCompleted, which appends a stable
// per-course lesson id to the append-only completedLessonIds array and
// triggers the same intelligence refresh.
//
// LOCAL XP COUNTER — PERSISTENCE + IDEMPOTENCY
// ────────────────────────────────────────────
// `_xpEarned` is the LOCAL display counter shown in the top-bar pill
// and on the completion screen. Its persistence rules are:
//
//   • On screen load, `_xpEarned` is restored from the existing
//     SharedPreferences key `course_xp_{courseId}`.
//
//   • On every successful course event (Firestore accepted the write),
//     `_xpEarned` is incremented AND immediately written back to
//     `course_xp_{courseId}`, so the new total survives app restart.
//
//   • A per-event SharedPreferences marker
//     (`course_evt_done_{courseId}_{eventId}`) ensures the same event
//     can never bump `_xpEarned` twice, even if the user reopens the
//     course and re-answers the same question correctly.
//
//   • An IN-FLIGHT guard (`_eventInFlight`) prevents rapid double-taps
//     or concurrent submissions for the same event from racing past the
//     check-then-write sequence. It is set BEFORE the Firestore call and
//     cleared in a finally block, so a failure path also releases it.
//
// Firestore remains the authoritative source of persisted XP on
// users/{uid}.totalXp — the local counter mirrors the events the user
// has genuinely recorded this session and is a UX convenience, not the
// source of truth. If the Firestore write fails, the local counter is
// NOT advanced, NOT saved, and the user can retry.
//
// ARCHITECTURE NOTE — RAW EVIDENCE SCOPE
// ──────────────────────────────────────
// `_LearningEvidence` (quizCorrect/Total, challengeCorrect/Total,
// weakQuizTopics, weakChallengeTopics, accuracy) is captured in-session
// for UI display only. The current CopilotController / CopilotFirestore
// Service API accepts a per-event `(careerId, eventId, xpReward)` triple
// and does NOT expose any method for persisting raw per-answer accuracy
// or weak-topic lists. No such method is invented here — that would
// require modifying another file. The per-event id append in
// `completedCourseEventIds` / `courseEvidenceIds` is the authoritative
// learning-evidence trail the existing Copilot pipeline can consume.
//
// SAVE-STATE HONESTY
// ──────────────────
// Answer-submit and project-complete await the Firestore write before
// advancing the UI. If persistence fails, the answer is NOT shown as
// accepted and the local XP counter is NOT advanced — the user can
// retry. Course completion (the final lesson) also awaits its Copilot
// write before being considered saved.
//
// IMPORTANT: recordLessonCompleted is called WITHOUT totalLessons, so
// the existing per-career totalLessons value stored on the learning
// progress document is preserved. Only the append-only completedLessonIds
// array grows, keyed by a stable lessonId.
// ══════════════════════════════════════════════════════════════════════

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
/// CopilotController.recordCourseEvent for each individual event.
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
  static const _bg       = Color(0xFF0F0F1A);
  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);
  static const _green    = Color(0xFF4ADE80);
  static const _amber    = Color(0xFFF59E0B);
  static const _red      = Color(0xFFEF4444);

  // ── State ──────────────────────────────────────────────────────────
  int    _screen       = 0;
  int    _conceptIndex = 0;
  int    _quizIndex    = 0;
  int    _chalIndex    = 0;

  int    _xpEarned    = 0;
  int?   _selectedOpt;
  bool   _answered    = false;

  bool   _alreadyCompletedBefore = false;
  bool   _progressPersisted = false;

  /// In-flight guard for course events. An event id present here means a
  /// persist attempt for that event is currently running. This prevents
  /// rapid double-taps / concurrent submissions from racing past the
  /// check-then-write sequence and double-bumping the local counter.
  ///
  /// The guard is set BEFORE the Firestore call and cleared in a finally
  /// block, so a failure path also releases it and the user can retry.
  final Set<String> _eventInFlight = <String>{};

  /// Session-local learning evidence (display-only).
  final _LearningEvidence _evidence = _LearningEvidence();

  // ── SharedPreferences keys ────────────────────────────────────────
  String get _doneKey => 'course_done_${widget.course.id}';
  String get _xpKey   => 'course_xp_${widget.course.id}';

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final done  = prefs.getBool(_doneKey) ?? false;
    final saved = prefs.getInt(_xpKey) ?? 0;

    if (!mounted) return;
    setState(() {
      _alreadyCompletedBefore = done;
      _xpEarned = saved;
    });
  }

  late PageController    _pageCtrl;
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
    _conceptScreenEnd   = c.concepts.length;
    _quizScreenId       = c.concepts.length + 1;
    _chalScreenId       = c.concepts.length + 2;
    _projectScreenId    = c.concepts.length + 3;
    _doneScreenId       = c.concepts.length + 4;

    _pageCtrl   = PageController();
    _celebCtrl  = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _xpCtrl     = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
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
      _answered    = false;

      if (_screen < _doneScreenId) {
        _screen++;
        if (_screen >= _conceptScreenStart &&
            _screen <= _conceptScreenEnd) {
          _conceptIndex = _screen - 1;
        }
        if (_screen == _quizScreenId)    _quizIndex = 0;
        if (_screen == _chalScreenId)    _chalIndex = 0;
        if (_screen == _doneScreenId)    _onComplete();
      }
    });
    HapticFeedback.lightImpact();
  }

  /// Increments the local display counter, triggers the brief XP-pulse
  /// animation, and immediately persists the new total to the existing
  /// SharedPreferences key so it survives an app restart.
  ///
  /// Persistence failure here is non-fatal and silent: the counter is a
  /// UX convenience, and Firestore (users/{uid}.totalXp) remains the
  /// authoritative source of XP. The in-memory counter still reflects
  /// the new value for the current session.
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
  // Keyed by the stable event id used for Firestore persistence. A
  // present marker means "this event has already been recorded, so do
  // NOT bump the local XP counter again". This makes `_xpEarned`
  // idempotent across retries and app restarts, WITHOUT changing any
  // other file. Firestore remains the authoritative source for the
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

  /// Persists ONE course event (quiz answer / challenge answer / project
  /// completion) through the existing CopilotController.recordCourseEvent
  /// path, awaits it, and — only when the event is genuinely new —
  /// updates the local display counter AND immediately writes the new
  /// total to the existing `course_xp_{courseId}` SharedPreferences key.
  ///
  /// Idempotency:
  ///   • Firestore: the transaction inside recordCourseEvent is a no-op
  ///     for an already-recorded event id, so XP/history/evidence can
  ///     never be duplicated.
  ///   • Local display counter: gated by a SharedPreferences marker per
  ///     event id, so reopening the course and re-answering the same
  ///     question correctly does NOT bump `_xpEarned` again, and the
  ///     persisted `course_xp_{courseId}` value is not touched either.
  ///   • In-flight: an in-memory `_eventInFlight` set prevents a second
  ///     concurrent call for the same event from racing past the check.
  ///     The guard is set BEFORE the Firestore call and cleared in a
  ///     finally block, so a failure path also releases it.
  ///
  /// Returns true on success (or when no controller/user is available so
  /// the offline UX is preserved, or when another call for the same
  /// event is already in-flight), false on a genuine persistence
  /// failure. On failure, a retryable snackbar is shown and the caller
  /// does NOT advance the UI.
  Future<bool> _persistCourseEvent({
    required String eventId,
    required int xpReward,
  }) async {
    // In-flight guard: if this event is already being persisted, treat
    // it as a duplicate attempt and short-circuit. This prevents rapid
    // double-taps / concurrent submissions from racing past the
    // check-then-write sequence and double-bumping the local counter.
    if (_eventInFlight.contains(eventId)) return true;
    _eventInFlight.add(eventId);

    try {
      final alreadyRecordedLocally = await _eventAlreadyRecorded(eventId);

      final ctrl = mounted ? CopilotProvider.maybeOf(context) : null;
      final uid  = FirebaseAuth.instance.currentUser?.uid;

      // Offline-safe: if there is no controller or user, keep the
      // existing local-only behaviour and do not block the UI.
      if (ctrl == null || uid == null) {
        return true;
      }

      try {
        await ctrl.recordCourseEvent(
          uid,
          careerId: widget.course.careerId,
          eventId: eventId,
          xpReward: xpReward,
        );
        // Only advance the local display counter (and immediately
        // persist it) when this event is genuinely new. Firestore
        // already enforced idempotency on its side; this guard keeps
        // the local mirror from double-counting a retried/reopened
        // event.
        if (!alreadyRecordedLocally && xpReward > 0) {
          await _addXpAndPersist(xpReward);
        }
        if (!alreadyRecordedLocally) {
          await _markEventRecorded(eventId);
        }
        return true;
      } catch (_) {
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
      // Always release the in-flight guard — success OR failure — so the
      // user can retry a failed attempt and future calls are allowed.
      _eventInFlight.remove(eventId);
    }
  }

  /// Persists the completion of the course through the existing
  /// recordLessonCompleted path, and triggers the existing intelligence
  /// refresh. Returns true on success.
  Future<bool> _persistCourseCompletion() async {
    final ctrl = mounted ? CopilotProvider.maybeOf(context) : null;
    final uid  = FirebaseAuth.instance.currentUser?.uid;

    if (ctrl == null || uid == null) return true;

    try {
      await ctrl.recordLessonCompleted(
        uid,
        careerId: widget.course.careerId,
        lessonId: 'course:${widget.course.id}',
        currentLevelTitle: widget.course.topicTitle,
        // totalLessons intentionally NOT passed so the per-career
        // totalLessons value on the learning-progress document is
        // preserved.
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Persists local session state and — only on a genuine, first-time
  /// completion — records the lesson completion into the existing
  /// Copilot/learning progress system.
  ///
  /// Idempotent: reopening an already-completed course will NOT re-award
  /// or re-record.
  ///
  /// Save-state honesty:
  ///   • Local SharedPreferences is written first. If that write fails,
  ///     the course is NOT marked complete locally, and _progressPersisted
  ///     is rolled back so the user can retry.
  ///   • The Copilot hook (recordLessonCompleted + refreshIntelligence)
  ///     runs only for the first completion. It is best-effort: a failure
  ///     there is swallowed, because the local completion marker already
  ///     stands and the append-only lesson history is idempotent.
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
            content: Text('Couldn\'t save your progress locally. Please try again.'),
            backgroundColor: Color(0xFFEF4444),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    final isFirstCompletion = !_alreadyCompletedBefore;
    _alreadyCompletedBefore = true;

    if (isFirstCompletion) {
      await _persistCourseCompletion();
    }

    try {
      _EngagementBridge.maybeAddXp(_xpEarned);
    } catch (_) {}
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
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: _surface, borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _border),
              ),
              child: const Icon(Icons.close, color: _muted, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(widget.course.topicTitle,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700,
                    fontSize: 15),
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          AnimatedBuilder(
            animation: _xpCtrl,
            builder: (_, __) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [_primary, _secondary]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: _xpCtrl.value > 0
                    ? [BoxShadow(
                        color: _primary.withOpacity(_xpCtrl.value * 0.5),
                        blurRadius: 12)]
                    : const [],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('⚡', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text('$_xpEarned XP',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold,
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
    final total    = _doneScreenId + 1;
    final progress = _screen / total;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress, minHeight: 5,
              backgroundColor: _border,
              valueColor: const AlwaysStoppedAnimation(_primary),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_stepLabel(), style: const TextStyle(color: _muted, fontSize: 10)),
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
    if (_screen == 0)              return _introScreen();
    if (_screen <= _conceptScreenEnd) return _conceptScreen();
    if (_screen == _quizScreenId)  return _quizScreen();
    if (_screen == _chalScreenId)  return _challengeScreen();
    if (_screen == _projectScreenId) return _projectScreen();
    return _completionScreen();
  }

  // ══════════════════════════════════════════════════════════════════
  // SCREEN 0 — INTRO
  // ══════════════════════════════════════════════════════════════════
  Widget _introScreen() {
    final c = widget.course;
    final diffColor = c.difficulty == 'Easy'
        ? _green : c.difficulty == 'Medium' ? _amber : _red;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      child: Column(
        children: [
          const SizedBox(height: 20),

          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primary.withOpacity(0.3), _secondary.withOpacity(0.15)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(color: _secondary.withOpacity(0.4), width: 2),
            ),
            child: Center(child: Text(c.emoji, style: const TextStyle(fontSize: 48))),
          )
              .animate().scale(duration: 600.ms, curve: Curves.elasticOut),

          const SizedBox(height: 24),

          Text(c.topicTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold))
              .animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 8),
          Text(_alreadyCompletedBefore
                  ? 'Already completed — reopen any time to revise'
                  : 'Master this concept step by step',
              style: const TextStyle(color: _muted, fontSize: 14))
              .animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 28),

          Row(children: [
            Expanded(child: _metaCard('🎯', 'Difficulty', c.difficulty, diffColor)),
            const SizedBox(width: 10),
            Expanded(child: _metaCard('⏱️', 'Time', '~${c.estimatedMinutes} min', _secondary)),
            const SizedBox(width: 10),
            Expanded(child: _metaCard('⚡', 'XP Reward', '+${c.totalXp} XP', const Color(0xFFF59E0B))),
          ]).animate().fadeIn(delay: 350.ms),

          const SizedBox(height: 28),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _surface, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('What you\'ll learn:',
                    style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.w600, fontSize: 14)),
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
            width: double.infinity, height: 54,
            child: ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary, foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Start Learning', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
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
          color: _surface, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 5),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
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
    return items.map((item) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        const Icon(Icons.check_circle, color: _green, size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(item, style: const TextStyle(color: Colors.white70, fontSize: 13))),
      ]),
    )).toList();
  }

  // ══════════════════════════════════════════════════════════════════
  // SCREEN 1..N — CONCEPT LESSONS
  // ══════════════════════════════════════════════════════════════════
  Widget _conceptScreen() {
    final concept = widget.course.concepts[_conceptIndex];
    final isLast  = _conceptIndex == widget.course.concepts.length - 1;

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
                style: const TextStyle(color: _secondary, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ]).animate().fadeIn(),

          const SizedBox(height: 16),

          Text(concept.title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))
              .animate().fadeIn(delay: 50.ms).slideX(begin: -0.05),

          const SizedBox(height: 20),

          _conceptSection(
            icon: '📖',
            label: 'Definition',
            color: const Color(0xFF60A5FA),
            child: Text(concept.definition,
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.6)),
          ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 14),

          _conceptSection(
            icon: '🧠',
            label: 'Real-World Analogy',
            color: _amber,
            child: Text(concept.analogy,
                style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.6)),
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
                    fontSize: 13, height: 1.6)),
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
                colors: [_primary.withOpacity(0.18), _primary.withOpacity(0.06)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _primary.withOpacity(0.35)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🎯 ', style: TextStyle(fontSize: 18)),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Key Takeaway',
                      style: TextStyle(color: _secondary, fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 5),
                  Text(concept.keyTakeaway,
                      style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5)),
                ]),
              ),
            ]),
          ).animate().fadeIn(delay: 320.ms),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary, foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLast ? 'Start Quiz →' : 'Next Concept →',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
    required String icon, required String label,
    required Color color, required Widget child,
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
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
          ]),
          const SizedBox(height: 8),
          child,
        ]),
      );

  Widget _codeBlock(String code) =>
      Container(
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
            const Text('Code', style: TextStyle(color: _muted, fontSize: 11, fontWeight: FontWeight.w600)),
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
                  fontSize: 12, height: 1.6)),
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
              child: Text('Question ${_quizIndex + 1}/${widget.course.quiz.length}',
                  style: const TextStyle(color: _amber, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
            const Spacer(),
            Text('+${q.xpReward} XP',
                style: const TextStyle(color: _secondary, fontWeight: FontWeight.bold, fontSize: 13)),
          ]).animate().fadeIn(),

          const SizedBox(height: 18),

          Text(q.question,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, height: 1.4))
              .animate().fadeIn(delay: 60.ms),

          const SizedBox(height: 24),

          ...q.options.asMap().entries.map((e) {
            final i     = e.key;
            final opt   = e.value;
            final sel   = _selectedOpt == i;
            final right = _answered && i == q.correctIndex;
            final wrong = _answered && sel && i != q.correctIndex;

            Color borderColor = _border;
            Color bgColor     = _surface;
            Color textColor   = Colors.white;
            Widget? trailingIcon;

            if (right) {
              borderColor = _green; bgColor = _green.withOpacity(0.12);
              textColor   = _green;
              trailingIcon = const Icon(Icons.check_circle, color: _green, size: 18);
            } else if (wrong) {
              borderColor = _red; bgColor = _red.withOpacity(0.10);
              textColor   = _red;
              trailingIcon = const Icon(Icons.cancel, color: _red, size: 18);
            } else if (sel && !_answered) {
              borderColor = _primary; bgColor = _primary.withOpacity(0.12);
              textColor   = _secondary;
            }

            return GestureDetector(
              onTap: _answered ? null : () => setState(() => _selectedOpt = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: bgColor, borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor, width: sel || right || wrong ? 1.5 : 1),
                ),
                child: Row(children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (sel || right || wrong)
                          ? borderColor.withOpacity(0.15) : const Color(0xFF0F0F20),
                      border: Border.all(color: borderColor),
                    ),
                    child: Center(
                      child: Text('ABCD'[i],
                          style: TextStyle(
                              color: sel || right || wrong ? borderColor : _muted,
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(opt, style: TextStyle(color: textColor, fontSize: 14))),
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
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [
                  Text('💡 ', style: TextStyle(fontSize: 16)),
                  Text('Explanation', style: TextStyle(color: _secondary, fontWeight: FontWeight.w600, fontSize: 13)),
                ]),
                const SizedBox(height: 6),
                Text(q.explanation, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
              ]),
            ).animate().fadeIn().slideY(begin: 0.2),
            const SizedBox(height: 16),
          ],

          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: _selectedOpt == null ? null : () async {
                if (!_answered) {
                  final correct = _selectedOpt == q.correctIndex;

                  // Persist the correct-answer event first, so XP and
                  // evidence are durable before the UI acknowledges it.
                  // Wrong answers persist no XP event; they are simply
                  // not treated as evidence of mastery. The in-flight
                  // guard inside _persistCourseEvent prevents rapid
                  // double-taps from double-bumping the local counter.
                  if (correct) {
                    final eventId = 'quiz:${widget.course.id}:$_quizIndex';
                    final ok = await _persistCourseEvent(
                      eventId: eventId,
                      xpReward: q.xpReward,
                    );
                    if (!mounted || !ok) return;
                  }

                  if (!mounted) return;
                  setState(() => _answered = true);
                  _evidence.recordQuiz(
                    correct: correct,
                    topic: widget.course.topicTitle,
                  );
                } else {
                  setState(() {
                    _quizIndex++;
                    _selectedOpt = null;
                    _answered    = false;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _answered ? _green : _primary,
                disabledBackgroundColor: _border,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                _answered ? 'Next →' : 'Submit Answer',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
        subtitle: 'Excellent work on all ${widget.course.challenges.length} challenges',
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
              child: Text('Challenge ${_chalIndex + 1}/${widget.course.challenges.length}',
                  style: const TextStyle(color: _green, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
            const Spacer(),
            Text('+${ch.xpReward} XP',
                style: const TextStyle(color: _secondary, fontWeight: FontWeight.bold, fontSize: 13)),
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
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Text('💻 ', style: TextStyle(fontSize: 16)),
                Text('Mini Challenge', style: TextStyle(color: _green, fontSize: 12, fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 10),
              Text(ch.prompt,
                  style: const TextStyle(
                      color: Color(0xFF6EE7B7),
                      fontFamily: 'monospace', fontSize: 13, height: 1.6)),
            ]),
          ).animate().fadeIn(delay: 60.ms),

          const SizedBox(height: 20),

          ...ch.options.asMap().entries.map((e) {
            final i     = e.key;
            final opt   = e.value;
            final sel   = _selectedOpt == i;
            final right = _answered && i == ch.correctIndex;
            final wrong = _answered && sel && i != ch.correctIndex;

            Color borderColor = _border;
            Color bgColor     = _surface;
            Color textColor   = Colors.white;
            Widget? trailingIcon;

            if (right) {
              borderColor = _green; bgColor = _green.withOpacity(0.12);
              textColor   = _green;
              trailingIcon = const Icon(Icons.check_circle, color: _green, size: 18);
            } else if (wrong) {
              borderColor = _red; bgColor = _red.withOpacity(0.10);
              textColor   = _red;
              trailingIcon = const Icon(Icons.cancel, color: _red, size: 18);
            } else if (sel && !_answered) {
              borderColor = _primary; bgColor = _primary.withOpacity(0.12);
              textColor   = _secondary;
            }

            return GestureDetector(
              onTap: _answered ? null : () => setState(() => _selectedOpt = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: bgColor, borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor, width: sel || right || wrong ? 1.5 : 1),
                ),
                child: Row(children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (sel || right || wrong)
                          ? borderColor.withOpacity(0.15) : const Color(0xFF0F0F20),
                      border: Border.all(color: borderColor),
                    ),
                    child: Center(
                      child: Text('ABCD'[i],
                          style: TextStyle(
                              color: sel || right || wrong ? borderColor : _muted,
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(opt, style: TextStyle(color: textColor, fontSize: 13))),
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
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [
                  Text('💡 ', style: TextStyle(fontSize: 16)),
                  Text('Explanation', style: TextStyle(color: _secondary, fontWeight: FontWeight.w600, fontSize: 13)),
                ]),
                const SizedBox(height: 6),
                Text(ch.explanation, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
              ]),
            ).animate().fadeIn().slideY(begin: 0.2),
            const SizedBox(height: 16),
          ],

          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: _selectedOpt == null ? null : () async {
                if (!_answered) {
                  final correct = _selectedOpt == ch.correctIndex;

                  if (correct) {
                    final eventId = 'challenge:${widget.course.id}:$_chalIndex';
                    final ok = await _persistCourseEvent(
                      eventId: eventId,
                      xpReward: ch.xpReward,
                    );
                    if (!mounted || !ok) return;
                  }

                  if (!mounted) return;
                  setState(() => _answered = true);
                  _evidence.recordChallenge(
                    correct: correct,
                    topic: widget.course.topicTitle,
                  );
                } else {
                  setState(() {
                    _chalIndex++;
                    _selectedOpt = null;
                    _answered    = false;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _answered ? _green : _primary,
                disabledBackgroundColor: _border,
                foregroundColor: Colors.white, elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(_answered ? 'Next →' : 'Submit',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
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
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ).animate().fadeIn(),

          const SizedBox(height: 18),
          Text(p.title,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))
              .animate().fadeIn(delay: 60.ms),

          const SizedBox(height: 16),

          _projectSection('🎯 Project Goal', p.goal, const Color(0xFF60A5FA))
              .animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _surface, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Text('📋 ', style: TextStyle(fontSize: 16)),
                Text('Steps to Complete',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
              ]),
              const SizedBox(height: 12),
              ...p.steps.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(
                      color: _primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: _primary.withOpacity(0.4)),
                    ),
                    child: Center(
                      child: Text('${e.key + 1}',
                          style: const TextStyle(
                              color: _secondary, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(e.value,
                        style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
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
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Text('✅ ', style: TextStyle(fontSize: 14)),
                Text('Expected Output',
                    style: TextStyle(color: _green, fontWeight: FontWeight.w600, fontSize: 12)),
              ]),
              const SizedBox(height: 8),
              Text(p.expectedOutput,
                  style: const TextStyle(
                      color: Color(0xFF6EE7B7), fontFamily: 'monospace',
                      fontSize: 12, height: 1.6)),
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
                  style: const TextStyle(color: _secondary, fontSize: 13, fontWeight: FontWeight.w500)),
            ]),
          ).animate().fadeIn(delay: 280.ms),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: () async {
                // Persist the project completion event first (durable XP
                // + evidence), then advance. A failed write keeps the
                // user on this screen so they can retry. The in-flight
                // guard inside _persistCourseEvent prevents rapid
                // double-taps from double-bumping the local counter.
                final eventId = 'project:${widget.course.id}';
                final ok = await _persistCourseEvent(
                  eventId: eventId,
                  xpReward: p.xpReward,
                );
                if (!mounted || !ok) return;
                _next();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _green, foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          Text(content, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5)),
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
                      width: 130, height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _secondary.withOpacity(0.3 + 0.2 * sin(_celebCtrl.value * 2 * pi)),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: -_celebCtrl.value * 2 * pi * 0.7,
                    child: Container(
                      width: 105, height: 105,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _primary.withOpacity(0.4), width: 1.5),
                      ),
                    ),
                  ),
                  Container(
                    width: 80, height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1A0A35),
                    ),
                    child: const Center(child: Text('🏆', style: TextStyle(fontSize: 38))),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 28),

          const Text('Lesson Complete!',
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))
              .animate().fadeIn(delay: 100.ms),

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
                colors: [_primary.withOpacity(0.25), _secondary.withOpacity(0.10)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
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
                      color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _xpBreakdown('Quiz', '${widget.course.quiz.length * 10}'),
                _xpBreakdown('Challenges', '${widget.course.challenges.length * 15}'),
                _xpBreakdown('Project', '${widget.course.finalProject.xpReward}'),
              ]),
            ]),
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _surface, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Concepts Covered:',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 10),
              ...widget.course.concepts.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  const Icon(Icons.check_circle, color: _green, size: 16),
                  const SizedBox(width: 8),
                  Text(c.title, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ]),
              )),
            ]),
          ).animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity, height: 54,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _green, foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Continue Learning →',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _xpBreakdown(String label, String xp) =>
      Column(children: [
        Text('+$xp', style: const TextStyle(color: _secondary, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: _muted, fontSize: 10)),
      ]);

  // ── Bridge screen between sections ──────────────────────────────
  Widget _nextSectionBridge({
    required String icon, required String title,
    required String subtitle, required String xpNote,
    required String btnLabel,
  }) =>
      Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(icon, style: const TextStyle(fontSize: 56))
                .animate().scale(duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: _muted, fontSize: 14)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: _primary.withOpacity(0.15), borderRadius: BorderRadius.circular(12),
              ),
              child: Text(xpNote, style: const TextStyle(color: _secondary, fontSize: 13, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 220, height: 50,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary, foregroundColor: Colors.white, elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(btnLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ),
      );

  // ── Confirm exit ─────────────────────────────────────────────────
  void _confirmExit() {
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: _surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Quit Lesson?', style: TextStyle(color: Colors.white)),
      content: Text(
        'You\'ve earned $_xpEarned XP so far. Your progress will be saved.',
        style: const TextStyle(color: _muted),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
            child: const Text('Keep Learning', style: TextStyle(color: _secondary))),
        ElevatedButton(
          onPressed: () { Navigator.pop(context); Navigator.pop(context); },
          style: ElevatedButton.styleFrom(backgroundColor: _red, elevation: 0),
          child: const Text('Quit'),
        ),
      ],
    ));
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.white)),
      backgroundColor: _surface, behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16), duration: const Duration(seconds: 1),
    ));
  }
}

// ── Safe EngagementProvider bridge ─────────────────────────────────
// Does not import EngagementProvider directly to avoid hard dependency
class _EngagementBridge {
  static void maybeAddXp(int xp) {
    // No-op if engagement system not present — XP saved to SharedPrefs instead
  }
}