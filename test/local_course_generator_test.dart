// test/local_course_generator_test.dart
//
// Run with:  flutter test test/local_course_generator_test.dart
//
// These tests need NO internet, NO backend and NO API key.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:ai_career_app/data/courses/course_generator_config.dart';
import 'package:ai_career_app/data/courses/dynamic_career_paths.dart';
import 'package:ai_career_app/data/courses/local_curriculum.dart';
import 'package:ai_career_app/services/local_course_generator.dart';

GeneratedCareerPath _path(String id) =>
    dynamicCareerPaths.firstWhere((p) => p.careerId == id);

void main() {
  group('Curriculum data', () {
    test('every level with empty topics has >= 4 curated topics', () {
      for (final p in dynamicCareerPaths) {
        for (final l in p.levels) {
          if (l.topics.isNotEmpty) {
            expect(l.topics.length, greaterThanOrEqualTo(4),
                reason: '${p.careerId} level ${l.level}');
          } else {
            final t = LocalCurriculum.topicsFor(p.careerId, l.level);
            expect(t, isNotNull, reason: '${p.careerId} level ${l.level}');
            expect(t!.length, greaterThanOrEqualTo(4),
                reason: '${p.careerId} level ${l.level}');
            for (final topic in t) {
              expect(topic.name.trim(), isNotEmpty);
              expect(topic.desc.trim(), isNotEmpty);
            }
          }
        }
      }
    });

    test('topic names are unique inside each career', () {
      for (final id in LocalCurriculum.careerIds) {
        final names = <String>[];
        for (var lv = 1; lv <= LocalCurriculum.levelCount(id); lv++) {
          names.addAll(LocalCurriculum.topicsFor(id, lv)!.map((t) => t.name));
        }
        expect(names.toSet().length, names.length, reason: id);
      }
    });

    test('every curriculum career id exists in dynamicCareerPaths', () {
      final ids = dynamicCareerPaths.map((p) => p.careerId).toSet();
      for (final id in LocalCurriculum.careerIds) {
        expect(ids.contains(id), isTrue, reason: id);
      }
    });

    test('curriculum level count matches the career path level count', () {
      for (final id in LocalCurriculum.careerIds) {
        expect(LocalCurriculum.levelCount(id), _path(id).levels.length,
            reason: id);
      }
    });
  });

  group('Lesson list', () {
    test('every career and level gives 10 unique, valid lesson titles', () {
      for (final p in dynamicCareerPaths) {
        for (final l in p.levels) {
          final j = LocalCourseGenerator.generateLessonList(
              careerId: p.careerId, level: l.level);
          expect(
              CourseJsonValidator.validateLessonList(j,
                  expectedCount: CourseGeneratorConfig.lessonsPerDynamicLevel),
              isEmpty,
              reason: '${p.careerId} level ${l.level}');
          expect(j['source'], LocalCourseGenerator.source);
        }
      }
    });

    test('titles are not the old repeated generic titles', () {
      final j = LocalCourseGenerator.generateLessonList(
          careerId: 'sec_ethical_hacking_ai', level: 2);
      final titles =
          (j['lessons'] as List).map((e) => (e as Map)['title'] as String);
      expect(titles.any((t) => t.contains('Port scanning with Nmap')), isTrue);
      expect(titles.any((t) => t.contains('What Every')), isFalse);
    });

    test('20 lessons are still unique (angles cycle)', () {
      final j = LocalCourseGenerator.generateLessonList(
          careerId: 'qa_sdet_ai', level: 1, lessonCount: 20);
      expect(CourseJsonValidator.validateLessonList(j, expectedCount: 20),
          isEmpty);
    });

    test('50 lessons are still unique (parts cycle)', () {
      final j = LocalCourseGenerator.generateLessonList(
          careerId: 'qa_sdet_ai', level: 1, lessonCount: 50);
      expect(CourseJsonValidator.validateLessonList(j, expectedCount: 50),
          isEmpty);
    });

    test('lessonCount 0 and 51 are rejected', () {
      expect(
          () => LocalCourseGenerator.generateLessonList(
              careerId: 'qa_sdet_ai', level: 1, lessonCount: 0),
          throwsA(isA<LocalGenerationException>()));
      expect(
          () => LocalCourseGenerator.generateLessonList(
              careerId: 'qa_sdet_ai', level: 1, lessonCount: 51),
          throwsA(isA<LocalGenerationException>()));
    });

    test('unknown career or level throws instead of returning fake data', () {
      expect(
          () => LocalCourseGenerator.generateLessonList(
              careerId: 'does_not_exist', level: 1),
          throwsA(isA<LocalGenerationException>()));
      expect(
          () => LocalCourseGenerator.generateLessonList(
              careerId: 'qa_sdet_ai', level: 99),
          throwsA(isA<LocalGenerationException>()));
    });
  });

  group('Course content', () {
    test('every career, level and lesson makes a strictly valid course', () {
      for (final p in dynamicCareerPaths) {
        for (final l in p.levels) {
          for (var i = 1;
              i <= CourseGeneratorConfig.lessonsPerDynamicLevel;
              i++) {
            final c = LocalCourseGenerator.generateCourse(
                careerId: p.careerId, level: l.level, lessonIndex: i);
            final problems =
                CourseJsonValidator.validate(c, strictCounts: true);
            expect(problems, isEmpty,
                reason: '${p.careerId} L${l.level} lesson $i: $problems');
            expect(c['careerId'], p.careerId);
            expect(c['categoryId'], p.categoryId);
            expect(c['difficulty'], l.difficulty);
            expect(c['id'], '${p.careerId}_level${l.level}_lesson$i');
          }
        }
      }
    });

    test('whole-level course (Cloud & DevOps style) is valid', () {
      for (final id in <String>[
        'cloud_devops_engineer_ai',
        'cloud_solutions_engineer_ai'
      ]) {
        for (final l in _path(id).levels) {
          final c =
              LocalCourseGenerator.generateCourse(careerId: id, level: l.level);
          expect(CourseJsonValidator.validate(c, strictCounts: true), isEmpty,
              reason: '$id level ${l.level}');
          expect(c['id'], '${id}_level${l.level}');
          expect(c['topicTitle'], l.levelTitle);
        }
      }
    });

    test('XP values follow the config and totalXp is the exact sum', () {
      final c = LocalCourseGenerator.generateCourse(
          careerId: 'design_ux_ui_ai', level: 3, lessonIndex: 2);
      final quiz = (c['quiz'] as List).cast<Map>();
      final chal = (c['challenges'] as List).cast<Map>();
      for (final q in quiz) {
        expect(q['xpReward'], CourseGeneratorConfig.defaultQuizXp);
      }
      for (final q in chal) {
        expect(q['xpReward'], CourseGeneratorConfig.defaultChallengeXp);
      }
      final project = c['finalProject'] as Map;
      expect(project['xpReward'], CourseGeneratorConfig.defaultProjectXp);
      expect(
          c['totalXp'],
          quiz.length * CourseGeneratorConfig.defaultQuizXp +
              chal.length * CourseGeneratorConfig.defaultChallengeXp +
              CourseGeneratorConfig.defaultProjectXp);
    });

    test('quiz answers match the real topic descriptions', () {
      final describe = RegExp(r'^Which statement best describes "(.+)"\?$');
      final fromDesc =
          RegExp(r'^Which topic is described by this sentence: "(.+)"$');
      var checked = 0;
      for (final careerId in LocalCurriculum.careerIds) {
        for (final l in _path(careerId).levels) {
          final topics = LocalCurriculum.topicsFor(careerId, l.level)!;
          for (var i = 1; i <= 10; i++) {
            final c = LocalCourseGenerator.generateCourse(
                careerId: careerId, level: l.level, lessonIndex: i);
            for (final q in (c['quiz'] as List).cast<Map>()) {
              final text = q['question'] as String;
              final opts = (q['options'] as List).cast<String>();
              final ci = q['correctIndex'] as int;
              final m1 = describe.firstMatch(text);
              if (m1 != null) {
                final t = topics.firstWhere((t) => t.name == m1.group(1));
                expect(opts[ci], t.desc);
                checked++;
              }
              final m2 = fromDesc.firstMatch(text);
              if (m2 != null) {
                final t = topics.firstWhere((t) => t.desc == m2.group(1));
                expect(opts[ci], t.name);
                checked++;
              }
            }
          }
        }
      }
      expect(checked, greaterThan(500));
    });

    test('correct answer position varies (not always the first option)', () {
      final positions = <int>{};
      for (var i = 1; i <= 10; i++) {
        final c = LocalCourseGenerator.generateCourse(
            careerId: 'sec_soc_analyst_ai', level: 3, lessonIndex: i);
        for (final q in (c['quiz'] as List).cast<Map>()) {
          positions.add(q['correctIndex'] as int);
        }
      }
      expect(positions.length, greaterThan(1));
    });

    test('different lessons give different content', () {
      final a = LocalCourseGenerator.generateCourse(
          careerId: 'sec_ethical_hacking_ai', level: 3, lessonIndex: 1);
      final b = LocalCourseGenerator.generateCourse(
          careerId: 'sec_ethical_hacking_ai', level: 3, lessonIndex: 2);
      expect(a['topicTitle'], isNot(b['topicTitle']));
      expect(jsonEncode(a['concepts']), isNot(jsonEncode(b['concepts'])));
      expect(jsonEncode(a['quiz']), isNot(jsonEncode(b['quiz'])));
    });

    test('lesson topic appears in its own course', () {
      final c = LocalCourseGenerator.generateCourse(
          careerId: 'sec_ethical_hacking_ai', level: 3, lessonIndex: 2);
      expect(c['topicTitle'], startsWith('SQL injection'));
      final first = (c['concepts'] as List).first as Map;
      expect(first['title'], 'SQL injection');
      expect(first['definition'], contains('database query'));
    });

    test('output is deterministic', () {
      final a = LocalCourseGenerator.generateCourse(
          careerId: 'qa_sdet_ai', level: 4, lessonIndex: 5);
      final b = LocalCourseGenerator.generateCourse(
          careerId: 'qa_sdet_ai', level: 4, lessonIndex: 5);
      expect(jsonEncode(a), jsonEncode(b));
    });

    test('content is marked as local template, not AI', () {
      final c = LocalCourseGenerator.generateCourse(
          careerId: 'qa_sdet_ai', level: 4, lessonIndex: 5);
      expect(c['source'], 'local-template');
      expect(c['intro'], contains('offline curriculum'));
    });

    test('bad lessonIndex or career throws', () {
      expect(
          () => LocalCourseGenerator.generateCourse(
              careerId: 'qa_sdet_ai', level: 1, lessonIndex: 0),
          throwsA(isA<LocalGenerationException>()));
      expect(
          () => LocalCourseGenerator.generateCourse(
              careerId: 'nope', level: 1, lessonIndex: 1),
          throwsA(isA<LocalGenerationException>()));
    });
  });

  group('Validator', () {
    Map<String, dynamic> good() => LocalCourseGenerator.generateCourse(
        careerId: 'qa_sdet_ai', level: 2, lessonIndex: 1);

    test('accepts a good course', () {
      expect(CourseJsonValidator.validate(good(), strictCounts: true), isEmpty);
    });

    test('rejects an empty concepts list', () {
      final j = good()..['concepts'] = <dynamic>[];
      expect(CourseJsonValidator.validate(j), isNotEmpty);
    });

    test('rejects correctIndex out of range', () {
      final j = jsonDecode(jsonEncode(good())) as Map<String, dynamic>;
      ((j['quiz'] as List).first as Map)['correctIndex'] = 9;
      expect(CourseJsonValidator.validate(j), isNotEmpty);
    });

    test('rejects duplicate options', () {
      final j = jsonDecode(jsonEncode(good())) as Map<String, dynamic>;
      ((j['quiz'] as List).first as Map)['options'] = ['A', 'A', 'B', 'C'];
      expect(CourseJsonValidator.validate(j), isNotEmpty);
    });

    test('rejects wrong option count', () {
      final j = jsonDecode(jsonEncode(good())) as Map<String, dynamic>;
      ((j['challenges'] as List).first as Map)['options'] = ['A', 'B'];
      expect(CourseJsonValidator.validate(j), isNotEmpty);
    });

    test('rejects missing final project and bad difficulty', () {
      final j = jsonDecode(jsonEncode(good())) as Map<String, dynamic>;
      j.remove('finalProject');
      j['difficulty'] = 'Impossible';
      expect(CourseJsonValidator.validate(j).length, greaterThanOrEqualTo(2));
    });
  });
}
