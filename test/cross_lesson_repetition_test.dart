// test/cross_lesson_repetition_test.dart
//
// Run with:  flutter test test/cross_lesson_repetition_test.dart
//
// Checks how much the 10 lessons of one level repeat each other.
//
// Limits are set from a Python re-implementation of the selection logic
// (measured: exact repeated quiz questions about 1.8%, exact repeated concept
// cards about 32%). They were NOT measured by running this Dart code.
//
// Each level has only 4 topics, so the same IDEA is inevitably asked in
// several lessons of a level. The tests therefore limit EXACT repetition
// (same wording and same answer), and require every lesson to have its own
// title and its own opening concept.

import 'package:flutter_test/flutter_test.dart';

import 'package:ai_career_app/data/courses/dynamic_career_paths.dart';
import 'package:ai_career_app/data/courses/local_curriculum.dart';
import 'package:ai_career_app/services/local_course_generator.dart';

void main() {
  test('lessons of a level have unique titles and unique opening concepts', () {
    for (final id in LocalCurriculum.careerIds) {
      for (final l
          in dynamicCareerPaths.firstWhere((p) => p.careerId == id).levels) {
        final titles = <String>{};
        final firstCards = <String>{};
        for (var i = 1; i <= 20; i++) {
          final c = LocalCourseGenerator.generateCourse(
              careerId: id, level: l.level, lessonIndex: i);
          expect(titles.add(c['topicTitle'] as String), isTrue,
              reason: '$id L${l.level} lesson $i title repeats');
          final first = (c['concepts'] as List).first as Map;
          final key = '${first['title']}|${first['example']}';
          expect(firstCards.add(key), isTrue,
              reason: '$id L${l.level} lesson $i opening concept repeats');
        }
      }
    }
  });

  test('exact repeated quiz questions stay under 10% per career', () {
    for (final id in LocalCurriculum.careerIds) {
      var total = 0;
      var repeated = 0;
      for (final l
          in dynamicCareerPaths.firstWhere((p) => p.careerId == id).levels) {
        final perLesson = <List<String>>[];
        final counts = <String, int>{};
        for (var i = 1; i <= 10; i++) {
          final c = LocalCourseGenerator.generateCourse(
              careerId: id, level: l.level, lessonIndex: i);
          final keys = (c['quiz'] as List)
              .map((q) {
                final m = q as Map;
                final opts = (m['options'] as List).cast<String>();
                return '${m['question']}|${opts[m['correctIndex'] as int]}';
              })
              .toSet()
              .toList();
          perLesson.add(keys);
          for (final k in keys) {
            counts[k] = (counts[k] ?? 0) + 1;
          }
        }
        for (final keys in perLesson) {
          for (final k in keys) {
            total++;
            if (counts[k]! > 1) repeated++;
          }
        }
      }
      expect(repeated / total, lessThan(0.10),
          reason: '$id: $repeated of $total quiz questions repeat exactly');
    }
  });

  test('exact repeated concept cards stay under 45% per career', () {
    for (final id in LocalCurriculum.careerIds) {
      var total = 0;
      var repeated = 0;
      for (final l
          in dynamicCareerPaths.firstWhere((p) => p.careerId == id).levels) {
        final perLesson = <Set<String>>[];
        final counts = <String, int>{};
        for (var i = 1; i <= 10; i++) {
          final c = LocalCourseGenerator.generateCourse(
              careerId: id, level: l.level, lessonIndex: i);
          final keys = (c['concepts'] as List).map((x) {
            final m = x as Map;
            return '${m['title']}|${m['definition']}|${m['analogy']}|${m['example']}|${m['keyTakeaway']}';
          }).toSet();
          perLesson.add(keys);
          for (final k in keys) {
            counts[k] = (counts[k] ?? 0) + 1;
          }
        }
        for (final keys in perLesson) {
          for (final k in keys) {
            total++;
            if (counts[k]! > 1) repeated++;
          }
        }
      }
      expect(repeated / total, lessThan(0.45),
          reason: '$id: $repeated of $total concept cards repeat exactly');
    }
  });
}
