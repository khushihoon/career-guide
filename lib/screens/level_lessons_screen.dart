// ══════════════════════════════════════════════════════════════════════
// lib/screens/level_lessons_screen.dart
//
// ONE reusable, data-driven screen showing the lessons inside a single
// level. Used for every career, static and AI-generated.
//
//   - Static level  -> staticLessons is a real List<TopicCourse> already
//                       loaded from course_content_data.dart's source
//                       files. Tapping a lesson opens CourseEngineScreen
//                       directly — no generation needed.
//   - Dynamic level, multiLesson == false (Cloud & DevOps — unchanged)
//                    -> generatedCareer + generatedLevel describe what to
//                       build. There is exactly one lesson (the level's
//                       AI-generated course). Tapping it calls
//                       CourseGeneratorService.generateOrLoadCourse
//                       (cache-aware) then opens CourseEngineScreen.
//   - Dynamic level, multiLesson == true (Security, Design, Emerging,
//                    Testing, Specialized) -> the level itself has NO
//                       hard-coded lesson content. On open, this screen
//                       calls CourseGeneratorService.generateOrLoadLessonList
//                       to get (and cache) exactly
//                       CourseGeneratorConfig.lessonsPerDynamicLevel lesson
//                       TITLES for this level. Each title is shown as its
//                       own lesson card; tapping one generates (and
//                       caches) that ONE lesson's full content via the
//                       SAME, unchanged generateOrLoadCourse used above —
//                       passed a lessonIndex so it gets its own cache
//                       entry distinct from every other lesson in the
//                       level.
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

import '../models/course_content_data.dart';
import '../data/courses/dynamic_career_paths.dart';
import '../services/course_generator_service.dart';
import 'course_engine_screen.dart';

class LevelLessonsScreen extends StatefulWidget {
  final String careerTitle;
  final String levelTitle;
  final List<TopicCourse>? staticLessons;
  final GeneratedCareerPath? generatedCareer;
  final GeneratedLevel? generatedLevel;

  /// True for Security, Design, Emerging, Testing, Specialized — shows
  /// CourseGeneratorConfig.lessonsPerDynamicLevel individually generated
  /// lessons instead of one combined course. False (default) preserves
  /// Cloud & DevOps's existing single-lesson-per-level behaviour exactly.
  final bool multiLesson;

  const LevelLessonsScreen({
    super.key,
    required this.careerTitle,
    required this.levelTitle,
    this.staticLessons,
    this.generatedCareer,
    this.generatedLevel,
    this.multiLesson = false,
  }) : assert(
          (staticLessons != null &&
                  generatedCareer == null &&
                  generatedLevel == null) ||
              (staticLessons == null &&
                  generatedCareer != null &&
                  generatedLevel != null),
          'Pass staticLessons OR (generatedCareer + generatedLevel), not both.',
        );

  @override
  State<LevelLessonsScreen> createState() => _LevelLessonsScreenState();
}

class _LevelLessonsScreenState extends State<LevelLessonsScreen> {
  static const _bg = Color(0xFF0F0F1A);
  static const _surface = Color(0xFF1A1A2E);
  static const _border = Color(0xFF2A2A40);
  static const _primary = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted = Color(0xFF888899);
  static const _green = Color(0xFF4ADE80);
  static const _amber = Color(0xFFF59E0B);
  static const _red = Color(0xFFEF4444);

  bool _generating = false;
  bool _cached = false;

  // ── Multi-lesson mode state (Security, Design, Emerging, Testing,
  //    Specialized) — a level's syllabus (list of lesson titles) and,
  //    for each one, whether that specific lesson has already been
  //    generated and cached.
  List<LessonStub>? _lessonStubs;
  bool _loadingList = false;
  String? _listError;
  final Set<int> _generatingIndex = {};
  final Set<int> _cachedIndex = {};

  bool get _isStatic => widget.staticLessons != null;

  @override
  void initState() {
    super.initState();
    if (_isStatic) return;
    if (widget.multiLesson) {
      _loadLessonList();
    } else {
      _refreshCacheStatus();
    }
  }

  Future<void> _loadLessonList() async {
    setState(() {
      _loadingList = true;
      _listError = null;
    });
    try {
      final stubs = await CourseGeneratorService.generateOrLoadLessonList(
        careerId: widget.generatedCareer!.careerId,
        careerTitle: widget.careerTitle,
        categoryId: widget.generatedCareer!.categoryId,
        level: widget.generatedLevel!.level,
        levelTitle: widget.generatedLevel!.levelTitle,
        difficulty: widget.generatedLevel!.difficulty,
      );
      if (!mounted) return;
      for (final stub in stubs) {
        final cached = await CourseGeneratorService.isCourseCached(
          widget.generatedCareer!.careerId,
          widget.generatedLevel!.level,
          lessonIndex: stub.index,
        );
        if (cached && mounted) {
          setState(() => _cachedIndex.add(stub.index));
        }
      }
      if (mounted) setState(() => _lessonStubs = stubs);
    } catch (e) {
      if (mounted) setState(() => _listError = e.toString());
    } finally {
      if (mounted) setState(() => _loadingList = false);
    }
  }

  Future<void> _openMultiLesson(LessonStub stub) async {
    if (_generatingIndex.contains(stub.index)) return;
    setState(() => _generatingIndex.add(stub.index));
    try {
      final course = await CourseGeneratorService.generateOrLoadCourse(
        careerId: widget.generatedCareer!.careerId,
        careerTitle: widget.careerTitle,
        categoryId: widget.generatedCareer!.categoryId,
        level: widget.generatedLevel!.level,
        levelTitle: stub.title,
        topics: [stub.title],
        difficulty: widget.generatedLevel!.difficulty,
        lessonIndex: stub.index,
      );
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CourseEngineScreen(course: course)),
      );
      if (mounted) setState(() => _cachedIndex.add(stub.index));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not generate lesson: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _generatingIndex.remove(stub.index));
    }
  }

  Future<void> _refreshCacheStatus() async {
    final cached = await CourseGeneratorService.isCourseCached(
      widget.generatedCareer!.careerId,
      widget.generatedLevel!.level,
    );
    if (mounted) setState(() => _cached = cached);
  }

  Future<void> _openGeneratedLesson() async {
    if (_generating) return;
    setState(() => _generating = true);
    try {
      final course = await CourseGeneratorService.generateOrLoadCourse(
        careerId: widget.generatedCareer!.careerId,
        careerTitle: widget.careerTitle,
        categoryId: widget.generatedCareer!.categoryId,
        level: widget.generatedLevel!.level,
        levelTitle: widget.generatedLevel!.levelTitle,
        topics: widget.generatedLevel!.topics,
        difficulty: widget.generatedLevel!.difficulty,
      );
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CourseEngineScreen(course: course)),
      );
      await _refreshCacheStatus();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not generate lesson: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  Color _diffColor(String d) => d == 'Easy'
      ? _green
      : d == 'Hard'
          ? _red
          : _amber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: Text(widget.levelTitle,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: _isStatic
            ? _buildStaticList()
            : (widget.multiLesson
                ? _buildMultiLessonList()
                : _buildGeneratedSingle()),
      ),
    );
  }

  // ── Static: real lessons from course_content_data.dart's source lists ──
  Widget _buildStaticList() {
    final lessons = widget.staticLessons!;
    if (lessons.isEmpty) {
      return const Center(
        child:
            Text('No lessons in this level.', style: TextStyle(color: _muted)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      itemCount: lessons.length,
      itemBuilder: (context, i) {
        final lesson = lessons[i];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CourseEngineScreen(course: lesson)),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child: Row(children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _primary.withOpacity(0.13),
                  shape: BoxShape.circle,
                ),
                child: Center(
                    child: Text(lesson.emoji,
                        style: const TextStyle(fontSize: 20))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lesson.topicTitle,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color:
                              _diffColor(lesson.difficulty).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(lesson.difficulty,
                            style: TextStyle(
                                color: _diffColor(lesson.difficulty),
                                fontSize: 10)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                          '~${lesson.estimatedMinutes}m · +${lesson.totalXp} XP',
                          style: const TextStyle(color: _muted, fontSize: 11)),
                    ]),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: _muted, size: 16),
            ]),
          ),
        );
      },
    );
  }

  // ── Dynamic: exactly one lesson for this level, generated on tap ──
  Widget _buildGeneratedSingle() {
    final lvl = widget.generatedLevel!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: _generating ? null : _openGeneratedLesson,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _cached ? _green.withOpacity(0.4) : _border,
            ),
          ),
          child: Row(children: [
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text('🧠', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lvl.levelTitle,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 5),
                  Text(
                    _cached
                        ? 'Ready — tap to open'
                        : 'Tap to generate this lesson',
                    style: const TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (_generating)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: _secondary),
              )
            else if (_cached)
              const Icon(Icons.check_circle, color: _green, size: 20)
            else
              const Icon(Icons.auto_awesome, color: _secondary, size: 20),
          ]),
        ),
      ),
    );
  }

  // ── Multi-lesson: the level's syllabus is generated once (and
  //    cached), then each of its lessons is generated/cached
  //    individually via the SAME generateOrLoadCourse used above,
  //    just distinguished by lessonIndex.
  Widget _buildMultiLessonList() {
    if (_loadingList) {
      return const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2.5, color: _secondary),
        ),
      );
    }

    if (_listError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: _red, size: 32),
              const SizedBox(height: 10),
              Text('Could not load lessons: $_listError',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: _muted, fontSize: 13)),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: _loadLessonList,
                child: const Text('Retry',
                    style: TextStyle(color: _secondary, fontSize: 13)),
              ),
            ],
          ),
        ),
      );
    }

    final stubs = _lessonStubs ?? const [];
    if (stubs.isEmpty) {
      return const Center(
        child:
            Text('No lessons in this level.', style: TextStyle(color: _muted)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      itemCount: stubs.length,
      itemBuilder: (context, i) {
        final stub = stubs[i];
        final generating = _generatingIndex.contains(stub.index);
        final cached = _cachedIndex.contains(stub.index);

        return GestureDetector(
          onTap: generating ? null : () => _openMultiLesson(stub),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: cached ? _green.withOpacity(0.4) : _border),
            ),
            child: Row(children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _primary.withOpacity(0.13),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('${stub.index}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(stub.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              if (generating)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: _secondary),
                )
              else if (cached)
                const Icon(Icons.check_circle, color: _green, size: 18)
              else
                const Icon(Icons.auto_awesome, color: _secondary, size: 18),
            ]),
          ),
        );
      },
    );
  }
}
