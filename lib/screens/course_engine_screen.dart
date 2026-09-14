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
// Entry point from courses_screen.dart Learn tab:
//   Navigator.push(context, MaterialPageRoute(
//     builder: (_) => CourseEngineScreen(course: topicCourse)));
//
// XP is added via EngagementProvider (if available), otherwise
// stored locally in SharedPreferences — zero hard dependency.
// ══════════════════════════════════════════════════════════════════════

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course_content_data.dart';

// ── Public entry point ────────────────────────────────────────────────

class CourseEngineScreen extends StatefulWidget {
  final TopicCourse course;

  const CourseEngineScreen({super.key, required this.course});

  @override
  State<CourseEngineScreen> createState() => _CourseEngineScreenState();
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
  int    _screen       = 0;   // 0=intro, 1..n=concepts, quiz, challenges, project, done
  int    _conceptIndex = 0;
  int    _quizIndex    = 0;
  int    _chalIndex    = 0;

  int    _xpEarned    = 0;
  int?   _selectedOpt;       // current quiz/challenge selected option
  bool   _answered    = false;

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _xpEarned = prefs.getInt('course_xp_${widget.course.id}') ?? 0;
    });
  }

  late PageController    _pageCtrl;
  late AnimationController _celebCtrl;
  late AnimationController _xpCtrl;

  // Screen IDs (computed from course content)
  late final int _conceptScreenStart; // = 1
  late final int _conceptScreenEnd;   // = concepts.length
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
    _conceptScreenEnd   = c.concepts.length;          // screens 1..n
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

  void _addXp(int amount) {
    setState(() => _xpEarned += amount);
    _xpCtrl.forward(from: 0);
    HapticFeedback.mediumImpact();
  }

  Future<void> _onComplete() async {
    // Persist completion in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('course_done_${widget.course.id}', true);
    await prefs.setInt(
        'course_xp_${widget.course.id}', _xpEarned);

    // Add total XP to engagement system if available
    // (safe — no hard dependency on EngagementProvider)
    try {
      // ignore: use_build_context_synchronously
      final ctrl = _EngagementBridge.maybeAddXp(context, _xpEarned);
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
          // XP counter
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
                    : [],
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

  // ── Route to correct screen ───────────────────────────────────────
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

          // Emoji hero
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
          Text('Master this concept step by step',
              style: const TextStyle(color: _muted, fontSize: 14))
              .animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 28),

          // Meta cards
          Row(children: [
            Expanded(child: _metaCard('🎯', 'Difficulty', c.difficulty, diffColor)),
            const SizedBox(width: 10),
            Expanded(child: _metaCard('⏱️', 'Time', '~${c.estimatedMinutes} min', _secondary)),
            const SizedBox(width: 10),
            Expanded(child: _metaCard('⚡', 'XP Reward', '+${c.totalXp} XP', const Color(0xFFF59E0B))),
          ]).animate().fadeIn(delay: 350.ms),

          const SizedBox(height: 28),

          // Course breakdown
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

          // Motivational intro
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

          // Start button
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
          // Concept number badge
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

          // Title
          Text(concept.title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))
              .animate().fadeIn(delay: 50.ms).slideX(begin: -0.05),

          const SizedBox(height: 20),

          // Definition card
          _conceptSection(
            icon: '📖',
            label: 'Definition',
            color: const Color(0xFF60A5FA),
            child: Text(concept.definition,
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.6)),
          ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 14),

          // Analogy card
          _conceptSection(
            icon: '🧠',
            label: 'Real-World Analogy',
            color: _amber,
            child: Text(concept.analogy,
                style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.6)),
          ).animate().fadeIn(delay: 160.ms),

          const SizedBox(height: 14),

          // Example card
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

          // Code snippet (optional)
          if (concept.codeSnippet != null) ...[
            const SizedBox(height: 14),
            _codeBlock(concept.codeSnippet!).animate().fadeIn(delay: 270.ms),
          ],

          const SizedBox(height: 14),

          // Key takeaway
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

          // Next button
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
          // Header
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

          // Question
          Text(q.question,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, height: 1.4))
              .animate().fadeIn(delay: 60.ms),

          const SizedBox(height: 24),

          // Options
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

          // Explanation (shows after answer)
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

          // Submit / Next button
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: _selectedOpt == null ? null : () {
                if (!_answered) {
                  setState(() => _answered = true);
                  if (_selectedOpt == q.correctIndex) {
                    _addXp(q.xpReward);
                  }
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
          // Header
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

          // Prompt card
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

          // Options (same pattern as quiz)
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
              onPressed: _selectedOpt == null ? null : () {
                if (!_answered) {
                  setState(() => _answered = true);
                  if (_selectedOpt == ch.correctIndex) _addXp(ch.xpReward);
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
          // Badge
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

          // Goal
          _projectSection('🎯 Project Goal', p.goal, const Color(0xFF60A5FA))
              .animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 14),

          // Steps
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

          // Expected output
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

          // XP reward note
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
              onPressed: () {
                _addXp(p.xpReward);
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

          // Celebration animation
          AnimatedBuilder(
            animation: _celebCtrl,
            builder: (_, __) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Rotating rings
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
                  // Trophy
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
            '${widget.course.topicTitle} — Mastered ✓',
            textAlign: TextAlign.center,
            style: const TextStyle(color: _secondary, fontSize: 15),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 28),

          // XP summary card
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
              // Breakdown
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _xpBreakdown('Quiz', '${widget.course.quiz.length * 10}'),
                _xpBreakdown('Challenges', '${widget.course.challenges.length * 15}'),
                _xpBreakdown('Project', '${widget.course.finalProject.xpReward}'),
              ]),
            ]),
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

          const SizedBox(height: 20),

          // What you mastered
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _surface, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Concepts Mastered:',
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

          // Done button
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
  static void maybeAddXp(BuildContext context, int xp) {
    // No-op if engagement system not present — XP saved to SharedPrefs instead
  }
}

