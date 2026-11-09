// test/course_generator_service_test.dart
//
// Run with:  flutter test test/course_generator_service_test.dart
//
// No internet and no real backend are used. Network answers are faked with
// http's MockClient. SharedPreferences is faked in memory.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ai_career_app/data/courses/course_generator_config.dart';
import 'package:ai_career_app/services/course_generator_service.dart';
import 'package:ai_career_app/services/local_course_generator.dart';

const _career = 'sec_ethical_hacking_ai';
const _cat = 'cyber_security';
const _lvlTitle = 'Web Application Exploitation';
const _prefix = CourseGeneratorConfig.cacheKeyPrefix;
const _courseKey = '${_prefix}${_career}_level3_lesson2';
const _listKey = '${_prefix}${_career}_level3_lessonlist';
const _ver = CourseGeneratorConfig.localContentVersion;
const _schema = CourseGeneratorConfig.cacheSchemaVersion;

Future<LessonListResult> _lessonsInfo({
  int level = 3,
  int count = 10,
  String levelTitle = _lvlTitle,
}) =>
    CourseGeneratorService.generateOrLoadLessonListWithInfo(
      careerId: _career,
      careerTitle: 'Ethical Hacking & Penetration Testing',
      categoryId: _cat,
      level: level,
      levelTitle: levelTitle,
      difficulty: 'Medium',
      lessonCount: count,
    );

Future<List<LessonStub>> _lessons({int count = 10}) async =>
    (await _lessonsInfo(count: count)).lessons;

Future<CourseLoadResult> _courseInfo({int lesson = 2, bool force = false}) =>
    CourseGeneratorService.generateOrLoadCourseWithInfo(
      careerId: _career,
      careerTitle: 'Ethical Hacking & Penetration Testing',
      categoryId: _cat,
      level: 3,
      levelTitle: 'ignored title',
      topics: const ['ignored'],
      difficulty: 'Medium',
      lessonIndex: lesson,
      forceRegenerate: force,
    );

Future<dynamic> _course({int lesson = 2, bool force = false}) async =>
    (await _courseInfo(lesson: lesson, force: force)).course;

Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

/// A saved course entry exactly as the service would write it, with
/// optional overrides for metadata.
Map<String, dynamic> _courseEntry({
  String source = 'local-template',
  String origin = 'local-template',
  int? contentVersion = _ver,
  int schema = _schema,
  int level = 3,
  int? lesson = 2,
  String careerId = _career,
  bool withMeta = true,
}) {
  final j = LocalCourseGenerator.generateCourse(
      careerId: _career, level: 3, lessonIndex: 2);
  j['careerId'] = careerId;
  if (withMeta) {
    j['source'] = source;
    j['origin'] = origin;
    j['cacheSchema'] = schema;
    j['level'] = level;
    j['lessonIndex'] = lesson;
    if (contentVersion != null) {
      j['contentVersion'] = contentVersion;
    } else {
      j.remove('contentVersion');
    }
  } else {
    j.remove('source');
  }
  return j;
}

Map<String, dynamic> _listEntry({
  String careerId = _career,
  int level = 3,
  String levelTitle = _lvlTitle,
  int count = 10,
  List<dynamic>? lessons,
  String source = 'local-template',
  int? contentVersion = _ver,
  int schema = _schema,
  int? lessonCount,
}) {
  final gen = LocalCourseGenerator.generateLessonList(
      careerId: _career, level: 3, lessonCount: count);
  final l = lessons ?? (gen['lessons'] as List);
  return <String, dynamic>{
    'kind': 'lessonlist',
    'cacheSchema': schema,
    'careerId': careerId,
    'level': level,
    'levelTitle': levelTitle,
    'lessonCount': lessonCount ?? l.length,
    'source': source,
    'origin': source,
    'lessons': l,
    if (contentVersion != null) 'contentVersion': contentVersion,
  };
}

Future<void> _put(String key, Object value) async =>
    (await _prefs()).setString(key, jsonEncode(value));

// ── Fake backend answers ──────────────────────────────────────────

Map<String, dynamic> _courseEnvelope({
  int level = 3,
  int? lesson = 2,
  String careerId = _career,
  String categoryId = _cat,
  bool mock = false,
  void Function(Map<String, dynamic> env, Map<String, dynamic> course)? tweak,
}) {
  final course = LocalCourseGenerator.generateCourse(
      careerId: _career, level: 3, lessonIndex: 2)
    ..['topicTitle'] = 'From the backend';
  final env = <String, dynamic>{
    'success': true,
    'mock': mock,
    'request': <String, dynamic>{
      'careerId': careerId,
      'categoryId': categoryId,
      'level': level,
      'lessonIndex': lesson,
    },
    'course': course,
  };
  tweak?.call(env, course);
  return env;
}

Map<String, dynamic> _listEnvelope({
  int count = 10,
  int reqCount = 10,
  String careerId = _career,
  int level = 3,
  void Function(Map<String, dynamic> env)? tweak,
}) {
  final env = <String, dynamic>{
    'success': true,
    'mock': false,
    'request': <String, dynamic>{
      'careerId': careerId,
      'categoryId': _cat,
      'level': level,
      'lessonCount': reqCount,
    },
    'lessonList': LocalCourseGenerator.generateLessonList(
        careerId: _career, level: 3, lessonCount: count),
  };
  tweak?.call(env);
  return env;
}

const _utf8Json = {'content-type': 'application/json; charset=utf-8'};

MockClient _answer(Object body, [int code = 200]) => MockClient((r) async =>
    http.Response(body is String ? body : jsonEncode(body), code,
        headers: _utf8Json));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    CourseGeneratorService.resetForTest();
  });

  // ═══════════════════════════════════════════════════════════════
  group('No backend (default): offline-first', () {
    test('lesson list works with no network at all', () async {
      var calls = 0;
      CourseGeneratorService.httpClient = MockClient((r) async {
        calls++;
        throw http.ClientException('Failed to fetch', r.url);
      });
      final r = await _lessonsInfo();
      expect(r.lessons.length, 10);
      expect(r.lessons.map((s) => s.title).toSet().length, 10);
      expect(calls, 0);
      expect(r.info.origin, GenerationOrigin.local);
      expect(r.info.fromCache, isFalse);
      expect(CourseGeneratorService.lastSource, 'local-template');
    });

    test('lesson 2 opens as the correct, fully structured course', () async {
      final course = await _course(lesson: 2);
      expect(course.id, '${_career}_level3_lesson2');
      expect(course.topicTitle, startsWith('SQL injection'));
      expect(course.careerId, _career);
      expect(course.categoryId, _cat);
      expect(course.concepts.length, CourseGeneratorConfig.conceptsPerLesson);
      expect(course.quiz.length, CourseGeneratorConfig.quizQuestionsPerLesson);
      expect(course.challenges.length, CourseGeneratorConfig.challengesPerLesson);
      expect(course.finalProject.steps, isNotEmpty);
      for (final q in course.quiz) {
        expect(q.options.length, 4);
        expect(q.correctIndex, inInclusiveRange(0, 3));
      }
    });

    test('unknown career gives a safe message with no internal details',
        () async {
      Future<void> check(Future<dynamic> Function() f, String start) async {
        try {
          await f();
          fail('should have thrown');
        } on CourseGenerationException catch (e) {
          final t = e.toString();
          expect(t, startsWith(start));
          expect(t, contains('not available'));
          expect(t, isNot(contains('dynamic_career_paths')));
          expect(t, isNot(contains('local_curriculum')));
          expect(t, isNot(contains('does_not_exist')));
        }
      }

      await check(
          () => CourseGeneratorService.generateOrLoadLessonList(
                careerId: 'does_not_exist',
                careerTitle: 'X',
                categoryId: 'x',
                level: 1,
                levelTitle: 'X',
                difficulty: 'Easy',
              ),
          'Lesson list generation failed');
      await check(
          () => CourseGeneratorService.generateOrLoadCourse(
                careerId: 'does_not_exist',
                careerTitle: 'X',
                categoryId: 'x',
                level: 1,
                levelTitle: 'X',
                topics: const [],
                difficulty: 'Easy',
                lessonIndex: 1,
              ),
          'Course generation failed');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  group('Source tracking', () {
    test('fresh then cached: label changes to cache(...)', () async {
      final first = await _courseInfo();
      expect(first.info.label, 'local-template');
      expect(CourseGeneratorService.lastSource, 'local-template');

      final second = await _courseInfo();
      expect(second.info.fromCache, isTrue);
      expect(second.info.origin, GenerationOrigin.local);
      expect(second.info.label, 'cache(local-template)');
      expect(CourseGeneratorService.lastSource, 'cache(local-template)');
    });

    test('a lesson-list call does not overwrite course info', () async {
      await _courseInfo();
      final courseInfo = CourseGeneratorService.lastCourseInfo;
      await _lessonsInfo();
      expect(CourseGeneratorService.lastCourseInfo, same(courseInfo));
      expect(CourseGeneratorService.lastListInfo, isNotNull);
      expect(CourseGeneratorService.lastInfo, same(CourseGeneratorService.lastListInfo));
    });

    test('backend failure is labelled local-fallback, and cached as such',
        () async {
      CourseGeneratorService.backendBaseUrlOverride = 'https://backend.test';
      CourseGeneratorService.httpClient = _answer('{}', 500);
      final first = await _courseInfo();
      expect(first.info.origin, GenerationOrigin.localFallback);
      expect(first.info.label, 'local-fallback');
      expect(first.info.backendIssue, BackendIssue.http);

      final second = await _courseInfo();
      expect(second.info.fromCache, isTrue);
      expect(second.info.label, 'cache(local-fallback)');
    });

    test('backend success is labelled backend, and cached as backend',
        () async {
      CourseGeneratorService.backendBaseUrlOverride = 'https://backend.test';
      CourseGeneratorService.httpClient = _answer(_courseEnvelope());
      final first = await _courseInfo();
      expect(first.course.topicTitle, 'From the backend');
      expect(first.info.label, 'backend');
      expect(first.info.backendIssue, isNull);

      // Backend now down: cached real AI content is still returned.
      CourseGeneratorService.httpClient = _answer('{}', 500);
      final second = await _courseInfo();
      expect(second.course.topicTitle, 'From the backend');
      expect(second.info.label, 'cache(backend)');
    });

    test('no backend configured: backendIssue stays null', () async {
      final r = await _courseInfo();
      expect(r.info.backendIssue, isNull);
      expect(CourseGeneratorService.lastBackendError, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  group('Course cache: behaviour', () {
    test('different lessons use different cache entries', () async {
      final a = await _course(lesson: 1);
      final b = await _course(lesson: 2);
      expect(a.id, isNot(b.id));
      expect(a.topicTitle, isNot(b.topicTitle));
      expect((await CourseGeneratorService.getAllCachedCourses()).length, 2);
    });

    test('saved entry carries version and identity metadata', () async {
      await _course(lesson: 2);
      final map =
          jsonDecode((await _prefs()).getString(_courseKey)!) as Map<String, dynamic>;
      expect(map['source'], 'local-template');
      expect(map['contentVersion'], _ver);
      expect(map['cacheSchema'], _schema);
      expect(map['level'], 3);
      expect(map['lessonIndex'], 2);
      expect(map['id'], '${_career}_level3_lesson2');
    });

    test('clearGeneratedCache removes courses, lesson lists and index only',
        () async {
      await _lessons();
      await _course(lesson: 1);
      final prefs = await _prefs();
      await prefs.setBool('course_done_${_career}_level3_lesson1', true);
      await prefs.setInt('course_xp_${_career}_level3_lesson1', 40);

      await CourseGeneratorService.clearGeneratedCache();

      expect(prefs.getKeys().where((k) => k.startsWith(_prefix)), isEmpty);
      expect(await CourseGeneratorService.isCourseCached(_career, 3, lessonIndex: 1),
          isFalse);
      expect(await CourseGeneratorService.getAllCachedCourses(), isEmpty);
      expect(prefs.getBool('course_done_${_career}_level3_lesson1'), isTrue);
      expect(prefs.getInt('course_xp_${_career}_level3_lesson1'), 40);
      expect((await _lessons()).length, 10);
    });

    test('forceRegenerate rebuilds even when cached', () async {
      await _course(lesson: 2);
      final again = await _courseInfo(lesson: 2, force: true);
      expect(again.info.fromCache, isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  group('Course cache: versioning and identity', () {
    test('local content with an OLD contentVersion is rebuilt', () async {
      await _put(_courseKey, _courseEntry(contentVersion: _ver - 1));
      expect(await CourseGeneratorService.isCourseCached(_career, 3, lessonIndex: 2),
          isFalse);
      final r = await _courseInfo();
      expect(r.info.fromCache, isFalse);
      final map =
          jsonDecode((await _prefs()).getString(_courseKey)!) as Map<String, dynamic>;
      expect(map['contentVersion'], _ver);
    });

    test('local content with NO contentVersion is rebuilt', () async {
      await _put(_courseKey, _courseEntry(contentVersion: null));
      expect(await CourseGeneratorService.isCourseCached(_career, 3, lessonIndex: 2),
          isFalse);
    });

    test('backend content is kept even if contentVersion is missing',
        () async {
      await _put(
          _courseKey,
          _courseEntry(source: 'backend', origin: 'backend', contentVersion: null)
            ..['topicTitle'] = 'Kept AI course');
      final r = await _courseInfo();
      expect(r.info.fromCache, isTrue);
      expect(r.info.origin, GenerationOrigin.backend);
      expect(r.course.topicTitle, 'Kept AI course');
    });

    test('old cache with no metadata at all is still accepted (compat)',
        () async {
      await _put(_courseKey, _courseEntry(withMeta: false));
      final r = await _courseInfo();
      expect(r.info.fromCache, isTrue);
    });

    test('other cacheSchema is rebuilt', () async {
      await _put(_courseKey, _courseEntry(schema: _schema + 1));
      expect(await CourseGeneratorService.isCourseCached(_career, 3, lessonIndex: 2),
          isFalse);
    });

    test('entry for another level or lesson under this key is rebuilt',
        () async {
      await _put(_courseKey, _courseEntry(level: 4));
      expect(await CourseGeneratorService.isCourseCached(_career, 3, lessonIndex: 2),
          isFalse);
      await _put(_courseKey, _courseEntry(lesson: 5));
      expect(await CourseGeneratorService.isCourseCached(_career, 3, lessonIndex: 2),
          isFalse);
      await _put(_courseKey, _courseEntry(lesson: null));
      expect(await CourseGeneratorService.isCourseCached(_career, 3, lessonIndex: 2),
          isFalse);
    });

    test('entry for another career under this key is rebuilt', () async {
      await _put(_courseKey, _courseEntry(careerId: 'qa_sdet_ai'));
      expect(await CourseGeneratorService.isCourseCached(_career, 3, lessonIndex: 2),
          isFalse);
    });

    test('entry whose id does not match its key is rebuilt', () async {
      await _put(_courseKey, _courseEntry()..['id'] = 'something_else');
      expect(await CourseGeneratorService.isCourseCached(_career, 3, lessonIndex: 2),
          isFalse);
    });

    test('corrupt JSON, invalid content and old placeholders are rebuilt',
        () async {
      final prefs = await _prefs();
      await prefs.setString(_courseKey, '{not json');
      expect(await CourseGeneratorService.isCourseCached(_career, 3, lessonIndex: 2),
          isFalse);
      expect(prefs.containsKey(_courseKey), isFalse); // removed

      await _put(_courseKey, _courseEntry()..['concepts'] = <dynamic>[]);
      expect(await CourseGeneratorService.isCourseCached(_career, 3, lessonIndex: 2),
          isFalse);

      final legacy = _courseEntry(withMeta: false);
      ((legacy['concepts'] as List).first as Map)['definition'] =
          'Old topic explained clearly for Career learners.';
      await _put(_courseKey, legacy);
      expect(await CourseGeneratorService.isCourseCached(_career, 3, lessonIndex: 2),
          isFalse);
      final course = await _course(lesson: 2);
      expect(course.concepts.length, CourseGeneratorConfig.conceptsPerLesson);
    });

    test('saved progress keys are never touched by a cache rebuild', () async {
      final prefs = await _prefs();
      await prefs.setBool('course_done_${_career}_level3_lesson2', true);
      await prefs.setInt('course_xp_${_career}_level3_lesson2', 25);
      await _put(_courseKey, _courseEntry(contentVersion: _ver - 1));
      await _course(lesson: 2);
      expect(prefs.getBool('course_done_${_career}_level3_lesson2'), isTrue);
      expect(prefs.getInt('course_xp_${_career}_level3_lesson2'), 25);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  group('Lesson list: cache identity and validation', () {
    test('list is saved with identity metadata and hidden from course list',
        () async {
      await _lessons();
      final map =
          jsonDecode((await _prefs()).getString(_listKey)!) as Map<String, dynamic>;
      expect(map['kind'], 'lessonlist');
      expect(map['careerId'], _career);
      expect(map['level'], 3);
      expect(map['levelTitle'], _lvlTitle);
      expect(map['lessonCount'], 10);
      expect(map['contentVersion'], _ver);
      expect(await CourseGeneratorService.getAllCachedCourses(), isEmpty);
    });

    test('asking for FEWER lessons returns the first N from cache', () async {
      await _lessons(count: 10);
      final r = await _lessonsInfo(count: 5);
      expect(r.info.fromCache, isTrue);
      expect(r.lessons.map((s) => s.index).toList(), [1, 2, 3, 4, 5]);
    });

    test('asking for MORE lessons rebuilds and replaces the entry', () async {
      await _lessons(count: 10);
      final r = await _lessonsInfo(count: 20);
      expect(r.info.fromCache, isFalse);
      expect(r.lessons.length, 20);
      expect(r.lessons.map((s) => s.index).toList(),
          List<int>.generate(20, (i) => i + 1));
      final map =
          jsonDecode((await _prefs()).getString(_listKey)!) as Map<String, dynamic>;
      expect(map['lessonCount'], 20);
      final again = await _lessonsInfo(count: 10);
      expect(again.info.fromCache, isTrue);
      expect(again.lessons.length, 10);
    });

    test('lessonCount outside 1..50 throws a safe error', () async {
      for (final n in <int>[0, 51, -1]) {
        expect(() => _lessonsInfo(count: n),
            throwsA(isA<CourseGenerationException>()));
      }
    });

    test('old bare-list cache is discarded and rebuilt', () async {
      await _put(_listKey, [
        {'index': 1, 'title': 'What Every X Professional Should Know'},
      ]);
      final r = await _lessonsInfo();
      expect(r.info.fromCache, isFalse);
      expect(r.lessons.length, 10);
    });

    test('changed level title, career, level or schema is rebuilt', () async {
      await _put(_listKey, _listEntry());
      expect((await _lessonsInfo(levelTitle: 'A different title')).info.fromCache,
          isFalse);
      await _put(_listKey, _listEntry(careerId: 'qa_sdet_ai'));
      expect((await _lessonsInfo()).info.fromCache, isFalse);
      await _put(_listKey, _listEntry(level: 4));
      expect((await _lessonsInfo()).info.fromCache, isFalse);
      await _put(_listKey, _listEntry(schema: _schema + 1));
      expect((await _lessonsInfo()).info.fromCache, isFalse);
    });

    test('stale or missing local contentVersion is rebuilt', () async {
      await _put(_listKey, _listEntry(contentVersion: _ver - 1));
      expect((await _lessonsInfo()).info.fromCache, isFalse);
      await _put(_listKey, _listEntry(contentVersion: null));
      expect((await _lessonsInfo()).info.fromCache, isFalse);
    });

    test('an intact entry IS used', () async {
      await _put(_listKey, _listEntry());
      final r = await _lessonsInfo();
      expect(r.info.fromCache, isTrue);
      expect(r.info.label, 'cache(local-template)');
    });

    test('duplicate titles, index gaps or wrong lessonCount are rebuilt',
        () async {
      final lessons = (LocalCourseGenerator.generateLessonList(
              careerId: _career, level: 3)['lessons'] as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      final dup = lessons.map((m) => Map<String, dynamic>.from(m)).toList();
      dup[1]['title'] = dup[0]['title'];
      await _put(_listKey, _listEntry(lessons: dup));
      expect((await _lessonsInfo()).info.fromCache, isFalse);

      final gap = lessons.map((m) => Map<String, dynamic>.from(m)).toList();
      gap[4]['index'] = 99;
      await _put(_listKey, _listEntry(lessons: gap));
      expect((await _lessonsInfo()).info.fromCache, isFalse);

      await _put(_listKey, _listEntry(lessonCount: 7));
      expect((await _lessonsInfo()).info.fromCache, isFalse);

      await _put(_listKey, _listEntry(lessons: <dynamic>[]));
      expect((await _lessonsInfo()).info.fromCache, isFalse);
    });

    test('corrupt lesson-list cache is rebuilt', () async {
      await (await _prefs()).setString(_listKey, 'garbage');
      expect((await _lessons()).length, 10);
    });
  });

  // ═══════════════════════════════════════════════════════════════
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

    test('rejects a course with no concepts', () {
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

    test('lesson list accepts the envelope and sorts by index', () {
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

    test('lesson list rejects duplicates, empty, gaps, zero-based and repeats',
        () {
      void bad(List<Map<String, Object>> l) => expect(
          () => CourseGeneratorService.lessonListFromJson(jsonEncode({'lessons': l})),
          throwsA(isA<FormatException>()));
      bad([
        {'index': 1, 'title': 'A'},
        {'index': 2, 'title': 'a'},
      ]);
      bad([]);
      bad([
        {'index': 1, 'title': 'A'},
        {'index': 3, 'title': 'B'},
      ]);
      bad([
        {'index': 0, 'title': 'A'},
        {'index': 1, 'title': 'B'},
      ]);
      bad([
        {'index': 1, 'title': 'A'},
        {'index': 1, 'title': 'B'},
      ]);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  group('Optional backend (faked network)', () {
    setUp(() {
      CourseGeneratorService.backendBaseUrlOverride = 'https://backend.test';
    });

    test('Web "Failed to fetch" falls back to local, safe message', () async {
      CourseGeneratorService.httpClient = MockClient(
          (r) async => throw http.ClientException('Failed to fetch', r.url));
      final r = await _lessonsInfo();
      expect(r.lessons.length, 10);
      expect(r.info.origin, GenerationOrigin.localFallback);
      expect(r.info.backendIssue, BackendIssue.network);
      final msg = CourseGeneratorService.lastBackendError!;
      expect(msg, isNot(contains('backend.test')));
      expect(msg, isNot(contains('Failed to fetch')));
    });

    test('HTTP errors never leak server text', () async {
      for (final code in <int>[500, 502, 404]) {
        CourseGeneratorService.httpClient =
            _answer('SECRET stack trace at /srv/app.dart:12', code);
        final r = await _courseInfo(lesson: 3, force: true);
        expect(r.course.concepts, isNotEmpty);
        expect(r.info.backendIssue, BackendIssue.http);
        expect(CourseGeneratorService.lastBackendError, isNot(contains('SECRET')));
        expect(CourseGeneratorService.lastBackendError, isNot(contains('/srv')));
      }
    });

    test('401 and 403 are reported as authRejected', () async {
      for (final code in <int>[401, 403]) {
        CourseGeneratorService.httpClient = _answer('{"error":"x"}', code);
        final r = await _courseInfo(lesson: 3, force: true);
        expect(r.info.backendIssue, BackendIssue.authRejected);
        expect(r.course.concepts, isNotEmpty);
      }
    });

    test('mock=true is ignored', () async {
      CourseGeneratorService.httpClient = _answer(_courseEnvelope(mock: true));
      final r = await _courseInfo();
      expect(r.course.topicTitle, startsWith('SQL injection'));
      expect(r.info.backendIssue, BackendIssue.mockMode);
    });

    test('success:false, invalid JSON, empty body and non-object', () async {
      for (final body in <String>[
        '{"success":false,"error":"x"}',
        '<html>oops</html>',
        '',
        '[1,2,3]',
      ]) {
        CourseGeneratorService.httpClient = _answer(body);
        final r = await _courseInfo(force: true);
        expect(r.course.topicTitle, startsWith('SQL injection'), reason: body);
        expect(r.info.origin, GenerationOrigin.localFallback, reason: body);
      }
    });

    test('over-size answer is rejected', () async {
      CourseGeneratorService.httpClient = _answer('x' * 1000001);
      final r = await _courseInfo();
      expect(r.info.backendIssue, BackendIssue.tooLarge);
    });

    test('course that fails validation is rejected', () async {
      CourseGeneratorService.httpClient = _answer(_courseEnvelope(
          tweak: (env, course) => course['concepts'] = <dynamic>[]));
      final r = await _courseInfo();
      expect(r.info.backendIssue, BackendIssue.invalidResponse);
      expect(r.course.concepts.length, 5);
    });

    final mismatches = <String, void Function(Map<String, dynamic>, Map<String, dynamic>)>{
      'wrong careerId in request': (e, c) => (e['request'] as Map)['careerId'] = 'qa_sdet_ai',
      'wrong categoryId in request': (e, c) => (e['request'] as Map)['categoryId'] = 'design_product',
      'wrong level in request': (e, c) => (e['request'] as Map)['level'] = 4,
      'wrong lessonIndex in request': (e, c) => (e['request'] as Map)['lessonIndex'] = 3,
      'lessonIndex missing where required': (e, c) => (e['request'] as Map)['lessonIndex'] = null,
      'no request block at all': (e, c) => e.remove('request'),
      'request is not an object': (e, c) => e['request'] = 'hello',
      'course careerId is another career': (e, c) => c['careerId'] = 'qa_sdet_ai',
      'course categoryId is another category': (e, c) => c['categoryId'] = 'design_product',
    };
    for (final entry in mismatches.entries) {
      test('identity check rejects: ${entry.key}', () async {
        CourseGeneratorService.httpClient =
            _answer(_courseEnvelope(tweak: entry.value));
        final r = await _courseInfo();
        expect(r.info.backendIssue, BackendIssue.identityMismatch);
        expect(r.course.topicTitle, startsWith('SQL injection'));
        expect(r.info.origin, GenerationOrigin.localFallback);
      });
    }

    test('identity check: whole-level request must not get a lesson answer',
        () async {
      // Ask for a whole level (lessonIndex null) but backend says lesson 2.
      CourseGeneratorService.httpClient = _answer(_courseEnvelope(lesson: 2));
      final r = await CourseGeneratorService.generateOrLoadCourseWithInfo(
        careerId: 'cloud_devops_engineer_ai',
        careerTitle: 'DevOps Engineer',
        categoryId: 'cloud_devops',
        level: 2,
        levelTitle: 'Containerisation with Docker',
        topics: const ['x'],
        difficulty: 'Medium',
      );
      expect(r.info.backendIssue, BackendIssue.identityMismatch);
      expect(r.course.careerId, 'cloud_devops_engineer_ai');
    });

    test('a valid answer for the right lesson is used', () async {
      late http.Request seen;
      CourseGeneratorService.authTokenProvider = () async => 'token123';
      CourseGeneratorService.httpClient = MockClient((r) async {
        seen = r;
        return http.Response(jsonEncode(_courseEnvelope()), 200,
            headers: _utf8Json);
      });
      final r = await _courseInfo();
      expect(r.course.topicTitle, 'From the backend');
      expect(r.info.origin, GenerationOrigin.backend);
      expect(seen.url.toString(), 'https://backend.test/generate-course');
      expect(seen.headers['Authorization'], 'Bearer token123');
      final body = jsonDecode(seen.body) as Map<String, dynamic>;
      expect(body['careerId'], _career);
      expect(body['categoryId'], _cat);
      expect(body['level'], 3);
      expect(body['lessonIndex'], 2);
    });

    test('login token is sent over https and localhost only', () async {
      Future<String?> headerFor(String base) async {
        CourseGeneratorService.backendBaseUrlOverride = base;
        CourseGeneratorService.authTokenProvider = () async => 'tok';
        String? h;
        CourseGeneratorService.httpClient = MockClient((r) async {
          h = r.headers['Authorization'];
          return http.Response('{}', 500);
        });
        await _courseInfo(lesson: 4, force: true);
        return h;
      }

      expect(await headerFor('https://backend.test'), 'Bearer tok');
      expect(await headerFor('http://localhost:8080'), 'Bearer tok');
      expect(await headerFor('http://10.0.2.2:8080'), 'Bearer tok');
      expect(await headerFor('http://backend.test'), isNull);
      expect(await headerFor('http://192.168.1.20:8080'), isNull);
    });

    test('no token provider and no Firebase user: no Authorization header',
        () async {
      String? h = 'unset';
      CourseGeneratorService.httpClient = MockClient((r) async {
        h = r.headers['Authorization'];
        return http.Response('{}', 500);
      });
      await _courseInfo();
      expect(h, isNull);
    });

    // ── lesson list from the backend ──
    test('valid backend lesson list is used and cached as backend', () async {
      CourseGeneratorService.httpClient = _answer(_listEnvelope());
      final first = await _lessonsInfo();
      expect(first.info.origin, GenerationOrigin.backend);
      CourseGeneratorService.httpClient = _answer('{}', 500);
      final second = await _lessonsInfo();
      expect(second.info.label, 'cache(backend)');
    });

    test('backend lesson list: wrong count, wrong identity, bad indices',
        () async {
      CourseGeneratorService.httpClient = _answer(_listEnvelope(count: 5, reqCount: 5));
      var r = await _lessonsInfo(count: 10);
      expect(r.info.backendIssue, BackendIssue.invalidResponse);
      expect(r.lessons.length, 10);

      await CourseGeneratorService.clearGeneratedCache();
      CourseGeneratorService.httpClient = _answer(_listEnvelope(reqCount: 7));
      r = await _lessonsInfo();
      expect(r.info.backendIssue, BackendIssue.identityMismatch);

      await CourseGeneratorService.clearGeneratedCache();
      CourseGeneratorService.httpClient = _answer(_listEnvelope(careerId: 'qa_sdet_ai'));
      r = await _lessonsInfo();
      expect(r.info.backendIssue, BackendIssue.identityMismatch);

      await CourseGeneratorService.clearGeneratedCache();
      CourseGeneratorService.httpClient = _answer(_listEnvelope(level: 4));
      r = await _lessonsInfo();
      expect(r.info.backendIssue, BackendIssue.identityMismatch);

      await CourseGeneratorService.clearGeneratedCache();
      CourseGeneratorService.httpClient = _answer(_listEnvelope(
          tweak: (env) => (((env['lessonList'] as Map)['lessons'] as List).first as Map)['index'] = 0));
      r = await _lessonsInfo();
      expect(r.info.backendIssue, BackendIssue.invalidResponse);

      await CourseGeneratorService.clearGeneratedCache();
      CourseGeneratorService.httpClient = _answer(_listEnvelope(tweak: (env) => env.remove('request')));
      r = await _lessonsInfo();
      expect(r.info.backendIssue, BackendIssue.identityMismatch);
    });

    test('invalid backend lesson lists never reach the cache as backend',
        () async {
      CourseGeneratorService.httpClient = _answer(_listEnvelope(reqCount: 7));
      await _lessonsInfo();
      final map =
          jsonDecode((await _prefs()).getString(_listKey)!) as Map<String, dynamic>;
      expect(map['source'], 'local-template');
      expect(map['origin'], 'local-fallback');
    });
  });
}