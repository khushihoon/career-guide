// ══════════════════════════════════════════════════════════════════════
// lib/screens/career_levels_screen.dart
//
// ONE reusable, data-driven screen that shows the levels for a career —
// used for EVERY category (Software, AI & Data, Cloud, Security, Design,
// Emerging, Testing, Specialized). No per-career screens exist anywhere.
//
// Pass exactly one of:
//   - staticCareer    (lessons already exist — from career_level_data.dart)
//   - generatedCareer (lessons are generated on demand — from
//                       dynamic_career_paths.dart)
//
// Tapping a level navigates to LevelLessonsScreen, which shows that
// level's real lessons (never a fake/estimated count).
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

import '../data/courses/career_level_data.dart';
import '../data/courses/dynamic_career_paths.dart';
import '../data/courses/course_generator_config.dart';
import 'level_lessons_screen.dart';

class CareerLevelsScreen extends StatelessWidget {
  final String careerTitle;
  final String emoji;
  final StaticCareerPath? staticCareer;
  final GeneratedCareerPath? generatedCareer;

  /// When true, every level under [generatedCareer] shows
  /// CourseGeneratorConfig.lessonsPerDynamicLevel individually
  /// generated/cached lessons (Security, Design, Emerging, Testing,
  /// Specialized) instead of one combined course per level (Cloud &
  /// DevOps, which leaves this false — its existing behaviour is
  /// completely unchanged).
  final bool multiLesson;

  const CareerLevelsScreen({
    super.key,
    required this.careerTitle,
    required this.emoji,
    this.staticCareer,
    this.generatedCareer,
    this.multiLesson = false,
  }) : assert(
          (staticCareer == null) != (generatedCareer == null),
          'Pass exactly one of staticCareer or generatedCareer.',
        );

  static const _bg = Color(0xFF0F0F1A);
  static const _surface = Color(0xFF1A1A2E);
  static const _border = Color(0xFF2A2A40);
  static const _primary = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted = Color(0xFF888899);
  static const _green = Color(0xFF4ADE80);
  static const _amber = Color(0xFFF59E0B);
  static const _red = Color(0xFFEF4444);

  bool get _isStatic => staticCareer != null;

  int get _levelCount =>
      _isStatic ? staticCareer!.levels.length : generatedCareer!.levels.length;

  Color _diffColor(String? d) => d == 'Easy'
      ? _green
      : d == 'Hard'
          ? _red
          : _amber; // Medium / unknown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: Text('$emoji $careerTitle',
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Text(
                _isStatic
                    ? '$_levelCount levels · ${staticCareer!.totalLessons} lessons'
                    : '$_levelCount levels · AI-generated on demand',
                style: const TextStyle(color: _muted, fontSize: 13),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                itemCount: _levelCount,
                itemBuilder: (context, i) {
                  final levelNum = i + 1;
                  final title = _isStatic
                      ? staticCareer!.levels[i].levelTitle
                      : generatedCareer!.levels[i].levelTitle;
                  final difficulty =
                      _isStatic ? null : generatedCareer!.levels[i].difficulty;
                  final lessonCount = _isStatic
                      ? staticCareer!.levels[i].lessons.length
                      : (multiLesson
                          ? CourseGeneratorConfig.lessonsPerDynamicLevel
                          : 1); // one AI-generated course = one lesson for that level

                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LevelLessonsScreen(
                          careerTitle: careerTitle,
                          levelTitle: title,
                          staticLessons: _isStatic
                              ? staticCareer!.levels[i].lessons
                              : null,
                          generatedCareer: _isStatic ? null : generatedCareer,
                          generatedLevel:
                              _isStatic ? null : generatedCareer!.levels[i],
                          multiLesson: multiLesson,
                        ),
                      ),
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
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: _primary.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text('$levelNum',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Row(children: [
                                if (difficulty != null) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _diffColor(difficulty)
                                          .withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(difficulty,
                                        style: TextStyle(
                                            color: _diffColor(difficulty),
                                            fontSize: 10)),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  '$lessonCount ${lessonCount == 1 ? "lesson" : "lessons"}',
                                  style: const TextStyle(
                                      color: _muted, fontSize: 11),
                                ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
