// ══════════════════════════════════════════════════════════════════════
// lib/screens/generated_course_levels_screen.dart
//
// Shows the levels for one AI-generated career path. Tapping a level
// calls CourseGeneratorService.generateOrLoadCourse (cache-aware) and
// opens the result in the EXISTING CourseEngineScreen — same as any
// static lesson.
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

import '../data/courses/dynamic_career_paths.dart';
import '../services/course_generator_service.dart';
import 'course_engine_screen.dart';

class GeneratedCourseLevelsScreen extends StatefulWidget {
  final GeneratedCareerPath career;
  const GeneratedCourseLevelsScreen({super.key, required this.career});

  @override
  State<GeneratedCourseLevelsScreen> createState() =>
      _GeneratedCourseLevelsScreenState();
}

class _GeneratedCourseLevelsScreenState
    extends State<GeneratedCourseLevelsScreen> {
  static const _bg = Color(0xFF0F0F1A);
  static const _surface = Color(0xFF1A1A2E);
  static const _border = Color(0xFF2A2A40);
  static const _primary = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted = Color(0xFF888899);
  static const _green = Color(0xFF4ADE80);
  static const _amber = Color(0xFFF59E0B);
  static const _red = Color(0xFFEF4444);

  final Set<int> _loadingLevels = {};
  final Map<int, bool> _cachedLevels = {};

  @override
  void initState() {
    super.initState();
    _refreshCacheStatus();
  }

  Future<void> _refreshCacheStatus() async {
    for (final lvl in widget.career.levels) {
      final cached = await CourseGeneratorService.isCourseCached(
        widget.career.careerId,
        lvl.level,
      );
      if (mounted) setState(() => _cachedLevels[lvl.level] = cached);
    }
  }

  Color _diffColor(String d) => d == 'Easy'
      ? _green
      : d == 'Medium'
          ? _amber
          : _red;

  Future<void> _openLevel(GeneratedLevel lvl) async {
    if (_loadingLevels.contains(lvl.level)) return;
    setState(() => _loadingLevels.add(lvl.level));

    try {
      final course = await CourseGeneratorService.generateOrLoadCourse(
        careerId: widget.career.careerId,
        careerTitle: widget.career.careerTitle,
        categoryId: widget.career.categoryId,
        level: lvl.level,
        levelTitle: lvl.levelTitle,
        topics: lvl.topics,
        difficulty: lvl.difficulty,
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
          SnackBar(content: Text('Could not generate course: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingLevels.remove(lvl.level));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: Text(widget.career.careerTitle,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          itemCount: widget.career.levels.length,
          itemBuilder: (_, i) {
            final lvl = widget.career.levels[i];
            final loading = _loadingLevels.contains(lvl.level);
            final cached = _cachedLevels[lvl.level] ?? false;

            return GestureDetector(
              onTap: loading ? null : () => _openLevel(lvl),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: cached ? _green.withOpacity(0.4) : _border,
                  ),
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
                      child: Text('${lvl.level}',
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
                        Text(lvl.levelTitle,
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
                                  _diffColor(lvl.difficulty).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(lvl.difficulty,
                                style: TextStyle(
                                    color: _diffColor(lvl.difficulty),
                                    fontSize: 10)),
                          ),
                          const SizedBox(width: 6),
                          Text('${lvl.topics.length} topics',
                              style:
                                  const TextStyle(color: _muted, fontSize: 11)),
                        ]),
                      ],
                    ),
                  ),
                  if (loading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: _secondary),
                    )
                  else if (cached)
                    const Icon(Icons.check_circle, color: _green, size: 20)
                  else
                    const Icon(Icons.arrow_forward_ios_rounded,
                        color: _muted, size: 16),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}
