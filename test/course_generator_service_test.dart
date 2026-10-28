// test/course_generator_service_test.dart
//
// Run with:  flutter test test/course_generator_service_test.dart
//
// No internet and no real backend are used. Network answers are faked
// with http's MockClient.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ai_career_app/data/courses/course_generator_config.dart';
import 'package:ai_career_app/services/course_generator_service.dart';
import 'package:ai_career_app/services/local_course_generator.dart';

const _career = 'sec_ethical_hacking_ai';
const _prefix = CourseGeneratorConfig.cacheKeyPrefix;

Future<List<LessonStub>> _lessons({int level = 3}) =>
    CourseGeneratorService.generateOrLoadLessonList(
      careerId: _career,
      careerTitle: 'Ethical Hacking & Penetration Testing',
      categoryId: 'cyber_security',
      level: level,
      levelTitle: 'Web Application Exploitation',
      difficulty: 'Medium',
    );

Future<dynamic> _course({int lesson = 2, bool force = false}) =>
    CourseGeneratorService.generateOrLoadCourse(
      careerId: _career,
      careerTitle: 'Ethical Hacking & Penetration Testing',
      categoryId: 'cyber_security',
      level: 3,
      levelTitle: 'ignored title',
      topics: const ['ignored'],
      difficulty: 'Medium',
      lessonIndex: lesson,
      forceRegenerate: force,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    CourseGeneratorService.resetForTest();
  });

  group('No backend (default)', () {
    test('lesson list works with no network at all (original regression)',
        () async {
      var networkCalls = 0;
      CourseGeneratorService.httpClient = MockClient((r) async {
        networkCalls++;
        throw http.ClientException('Failed to fetch', r.url);
      });

      final stubs = await _lessons();
      expect(stubs.length, CourseGeneratorConfig.lessonsPerDynamicLevel);
      expect(stubs.map((s) => s.title).toSet().length, stubs.length);
      expect(stubs.first.index, 1);
      expect(networkCalls, 0);
      expect(CourseGeneratorService.lastSource, 'local-template');
    });

    test('lesson 2 opens as the correct course with the right structure',
        () async {
      final course = await _course(lesson: 2);
      expect(course.id, '${_career}_level3_lesson2');
      expect(course.topicTitle, startsWith('SQL injection'));
      expect(course.careerId, _career);
      expect(course.categoryId, 'cyber_security');
      expect(course.concepts.length, CourseGeneratorConfig.conceptsPerLesson);
      expect(course.quiz.length, CourseGeneratorConfig.quizQuestionsPerLesson);
      expect(
          course.challenges.length, CourseGeneratorConfig.challengesPerLesson);
      expect(course.finalProject.steps, isNotEmpty);
      for (final q in course.quiz) {
        expect(q.options.length, 4);
        expect(q.correctIndex, inInclusiveRange(0, 3));
      }
    });

    test('different lessons use different cache entries', () async {
      final a = await _course(lesson: 1);
      final b = await _course(lesson: 2);
      expect(a.id, isNot(b.id));
      expect(a.topicTitle, isNot(b.topicTitle));
      final all = await CourseGeneratorService.getAllCachedCourses();
      expect(all.length, 2);
    });

    test('course is cached and returned from cache next time', () async {
      expect(
          await CourseGeneratorService.isCourseCached(_career, 3,
              lessonIndex: 2),
          isFalse);
      final first = await _course(lesson: 2);
      expect(
          await CourseGeneratorService.isCourseCached(_career, 3,
              lessonIndex: 2),
          isTrue);
      final second = await _course(lesson: 2);
      expect(second.id, first.id);
      expect(second.topicTitle, first.topicTitle);
      expect(second.quiz.first.question, first.quiz.first.question);
    });

    test('lesson list is cached and not in the course list', () async {
      await _lessons();
      final prefs = await SharedPreferences.getInstance();
      expect(
          prefs.containsKey('${_prefix}${_career}_level3_lessonlist'), isTrue);
      expect(await CourseGeneratorService.getAllCachedCourses(), isEmpty);
    });

    test('clearGeneratedCache removes courses, lesson lists and index only',
        () async {
      await _lessons();
      await _course(lesson: 1);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('course_done_${_career}_level3_lesson1', true);
      await prefs.setInt('course_xp_${_career}_level3_lesson1', 40);

      await CourseGeneratorService.clearGeneratedCache();

      expect(prefs.getKeys().where((k) => k.startsWith(_prefix)), isEmpty);
      expect(
          await CourseGeneratorService.isCourseCached(_career, 3,
              lessonIndex: 1),
          isFalse);
      expect(await CourseGeneratorService.getAllCachedCourses(), isEmpty);
      // saved progress is untouched
      expect(prefs.getBool('course_done_${_career}_level3_lesson1'), isTrue);
      expect(prefs.getInt('course_xp_${_career}_level3_lesson1'), 40);
      // and everything can be generated again
      expect((await _lessons()).length, 10);
    });

    test('corrupt course cache is detected and rebuilt', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${_prefix}${_career}_level3_lesson2', '{not json');
      expect(
          await CourseGeneratorService.isCourseCached(_career, 3,
              lessonIndex: 2),
          isFalse);
      final course = await _course(lesson: 2);
      expect(course.concepts, isNotEmpty);
    });

    test('invalid-but-parseable cache (empty concepts) is rebuilt', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          '${_prefix}${_career}_level3_lesson2',
          jsonEncode({
            'id': 'x',
            'topicTitle': 'x',
            'careerId': _career,
            'categoryId': 'c',
            'difficulty': 'Easy',
            'estimatedMinutes': 5,
            'totalXp': 5,
            'intro': 'x',
            'emoji': 'x',
            'concepts': [],
            'quiz': [],
            'challenges': [],
          }));
      final course = await _course(lesson: 2);
      expect(course.concepts.length, CourseGeneratorConfig.conceptsPerLesson);
    });

    test('old placeholder mock course in the cache is replaced', () async {
      final legacy = LocalCourseGenerator.generateCourse(
          careerId: _career, level: 3, lessonIndex: 2);
      ((legacy['concepts'] as List).first as Map)['definition'] =
          'Old topic explained clearly for Career learners.';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          '${_prefix}${_career}_level3_lesson2', jsonEncode(legacy));
      expect(
          await CourseGeneratorService.isCourseCached(_career, 3,
              lessonIndex: 2),
          isFalse);
      final course = await _course(lesson: 2);
      expect(course.concepts.first.definition,
          isNot(contains('explained clearly for')));
    });

    test('corrupt lesson-list cache is rebuilt', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          '${_prefix}${_career}_level3_lessonlist', 'garbage');
      expect((await _lessons()).length, 10);
    });

    test('forceRegenerate rebuilds even when cached', () async {
      await _course(lesson: 2);
      final again = await _course(lesson: 2, force: true);
      expect(again.id, '${_career}_level3_lesson2');
    });

    test('unknown career gives a clear error, not an empty list', () async {
      expect(
        () => CourseGeneratorService.generateOrLoadLessonList(
          careerId: 'does_not_exist',
          careerTitle: 'X',
          categoryId: 'x',
          level: 1,
          levelTitle: 'X',
          difficulty: 'Easy',
        ),
        throwsA(predicate((e) =>
            e.toString().contains('Lesson list generation failed') &&
            e.toString().contains('Unknown career id'))),
      );
    });

    test('lessonCount outside 1..50 is rejected', () async {
      expect(
        () => CourseGeneratorService.generateLessonList(
          careerId: _career,
          careerTitle: 'X',
          categoryId: 'x',
          level: 1,
          levelTitle: 'X',
          difficulty: 'Easy',
          lessonCount: 51,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('courseFromJson / lessonListFromJson', () {
    test('accepts a plain course and a {course: ...} envelope', () {
      final j = LocalCourseGenerator.generateCourse(
          careerId: _career, level: 3, lessonIndex: 1);
      final a = CourseGeneratorService.courseFromJson(jsonEncode(j));
      final b = CourseGeneratorService.courseFromJson(
          jsonEncode({'success': true, 'mock': false, 'course': j}));
      expect(a.topicTitle, b.topicTitle);
      expect(a.quiz.length, 5);
    });

    test('rejects a course with no concepts instead of showing an empty one',
        () {
      final j = LocalCourseGenerator.generateCourse(
          careerId: _career, level: 3, lessonIndex: 1)
        ..['concepts'] = <dynamic>[];
      expect(() => CourseGeneratorService.courseFromJson(jsonEncode(j)),
          throwsA(isA<FormatException>()));
    });

    test('rejects non-object JSON', () {
      expect(() => CourseGeneratorService.courseFromJson('[1,2]'),
          throwsA(isA<FormatException>()));
      expect(() => CourseGeneratorService.lessonListFromJson('"hi"'),
          throwsA(isA<FormatException>()));
    });

    test('lesson list accepts the {lessonList: ...} envelope and sorts', () {
      final stubs = CourseGeneratorService.lessonListFromJson(jsonEncode({
        'lessonList': {
          'lessons': [
            {'index': 2, 'title': 'B'},
            {'index': 1, 'title': 'A'},
          ]
        }
      }));
      expect(stubs.map((s) => s.title).toList(), ['A', 'B']);
    });

    test('lesson list rejects duplicates and empty lists', () {
      expect(
          () => CourseGeneratorService.lessonListFromJson(jsonEncode({
                'lessons': [
                  {'index': 1, 'title': 'A'},
                  {'index': 2, 'title': 'a'},
                ]
              })),
          throwsA(isA<FormatException>()));
      expect(
          () => CourseGeneratorService.lessonListFromJson(
              jsonEncode({'lessons': []})),
          throwsA(isA<FormatException>()));
    });
  });

  group('Optional backend (faked network)', () {
    setUp(() {
      CourseGeneratorService.backendBaseUrlOverride = 'http://backend.test';
    });

    test('network failure (Web "Failed to fetch") falls back to local',
        () async {
      CourseGeneratorService.httpClient = MockClient(
          (r) async => throw http.ClientException('Failed to fetch', r.url));
      final stubs = await _lessons();
      expect(stubs.length, 10);
      expect(CourseGeneratorService.lastSource, 'local-fallback');
      expect(
          CourseGeneratorService.lastBackendError, contains('Failed to fetch'));
    });

    test('HTTP 500 and 403 fall back to local with the reason recorded',
        () async {
      for (final code in <int>[500, 403]) {
        CourseGeneratorService.httpClient =
            MockClient((r) async => http.Response('{}', code));
        final course = await _course(lesson: 3, force: true);
        expect(course.concepts, isNotEmpty);
        expect(CourseGeneratorService.lastBackendError, contains('$code'));
      }
    });

    test('backend mock=true is ignored and local content is used', () async {
      CourseGeneratorService.httpClient = MockClient((r) async {
        return http.Response(
            jsonEncode({
              'success': true,
              'mock': true,
              'course': {'id': 'x'}
            }),
            200);
      });
      final course = await _course(lesson: 2);
      expect(course.topicTitle, startsWith('SQL injection'));
      expect(CourseGeneratorService.lastBackendError, contains('mock mode'));
    });

    test('invalid backend JSON falls back to local', () async {
      CourseGeneratorService.httpClient =
          MockClient((r) async => http.Response('<html>oops</html>', 200));
      final course = await _course(lesson: 2);
      expect(course.concepts, isNotEmpty);
      expect(CourseGeneratorService.lastBackendError, contains('invalid JSON'));
    });

    test('backend course that fails validation falls back to local', () async {
      CourseGeneratorService.httpClient = MockClient((r) async {
        return http.Response(
            jsonEncode({
              'success': true,
              'mock': false,
              'course': {'id': 'x', 'concepts': []}
            }),
            200);
      });
      final course = await _course(lesson: 2);
      expect(course.concepts.length, 5);
      expect(CourseGeneratorService.lastBackendError, contains('invalid'));
    });

    test('a valid real backend answer is used and sent the right request',
        () async {
      late http.Request seen;
      final good = LocalCourseGenerator.generateCourse(
          careerId: _career, level: 3, lessonIndex: 2)
        ..['topicTitle'] = 'From the backend';
      CourseGeneratorService.authTokenProvider = () async => 'token123';
      CourseGeneratorService.httpClient = MockClient((r) async {
        seen = r;
        return http.Response(
          jsonEncode({'success': true, 'mock': false, 'course': good}),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });
      final course = await _course(lesson: 2, force: true);
      expect(
        CourseGeneratorService.lastSource,
        'backend',
        reason: 'Backend error: ${CourseGeneratorService.lastBackendError}',
      );
      expect(course.topicTitle, 'From the backend');
      expect(CourseGeneratorService.lastSource, 'backend');
      expect(seen.url.toString(), 'http://backend.test/generate-course');
      expect(seen.headers['Authorization'], 'Bearer token123');
      final body = jsonDecode(seen.body) as Map<String, dynamic>;
      expect(body['careerId'], _career);
      expect(body['level'], 3);
      expect(body['lessonIndex'], 2);
      expect((body['prompt'] as String), isNotEmpty);
    });

    test('backend lesson list with the wrong count falls back to local',
        () async {
      CourseGeneratorService.httpClient = MockClient((r) async {
        return http.Response(
            jsonEncode({
              'success': true,
              'mock': false,
              'lessonList': {
                'lessons': [
                  {'index': 1, 'title': 'Only one'}
                ]
              }
            }),
            200);
      });
      final stubs = await _lessons();
      expect(stubs.length, 10);
      expect(CourseGeneratorService.lastBackendError, contains('invalid'));
    });
  });
}
