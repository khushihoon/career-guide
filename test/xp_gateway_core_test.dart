// test/xp_gateway_core_test.dart
//
// Run: flutter test test/xp_gateway_core_test.dart
// (uses only flutter_test, which is already a dev dependency)
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../backend/firestore_rest_store.dart' show XpStoreException;
import '../backend/xp_gateway_core.dart';
import '../lib/data/courses/dynamic_career_paths.dart';
import '../lib/models/quest_models.dart' show LevelSystem;
import '../lib/services/goal_content_database.dart';
import '../lib/services/local_course_generator.dart';
import '../lib/services/safe_doc_id.dart';
import 'backend/support/memory_xp_store.dart';

final DateTime _now = DateTime.utc(2026, 11, 14, 10); // a Saturday
const String alice = 'alice';
const String bob = 'bob';

Future<void> expectRejection(Future<dynamic> f,
    {required int status, required String code}) async {
  try {
    await f;
  } on GatewayRejection catch (e) {
    expect(e.status, status, reason: 'status for $code');
    expect(e.code, code);
    return;
  }
  fail('expected GatewayRejection($status, $code) but the call succeeded');
}

/// First career + level the offline curriculum can generate.
({String careerId, int level}) pickCourse() {
  for (final p in dynamicCareerPaths) {
    for (final l in p.levels) {
      if (LocalCourseGenerator.supports(p.careerId, l.level)) {
        return (careerId: p.careerId, level: l.level);
      }
    }
  }
  throw StateError('no supported curriculum found');
}

void main() {
  late MemoryXpStore store;
  late XpGateway gw;
  late String careerId;
  late Map<String, dynamic> course;
  late String courseId;
  late List<Map> quiz;
  late List<Map> chal;

  String eventPath(String id, {String uid = alice}) =>
      'users/$uid/copilot_learning_progress/$careerId/events/${safeDocId(id)}';
  String progressPath({String uid = alice}) =>
      'users/$uid/copilot_learning_progress/$careerId';

  CourseEventRequest quizReq(int index, int selected) => CourseEventRequest(
      careerId: careerId,
      courseId: courseId,
      kind: 'quiz',
      index: index,
      selectedIndex: selected);
  CourseEventRequest chalReq(int index, int selected) => CourseEventRequest(
      careerId: careerId,
      courseId: courseId,
      kind: 'challenge',
      index: index,
      selectedIndex: selected);
  CourseEventRequest projectReq() => CourseEventRequest(
      careerId: careerId, courseId: courseId, kind: 'project');

  int userXp([String uid = alice]) =>
      ((store.docs['users/$uid']?['totalXp']) as num?)?.toInt() ?? 0;

  /// Answers every quiz question and challenge (alternating hit / miss so
  /// both evidence event types are exercised).
  Future<void> answerWholeCourse() async {
    for (var i = 0; i < quiz.length; i++) {
      final correct = quiz[i]['correctIndex'] as int;
      await gw.recordCourseEvent(
          alice, quizReq(i, i.isEven ? correct : (correct + 1) % 4));
    }
    for (var i = 0; i < chal.length; i++) {
      final correct = chal[i]['correctIndex'] as int;
      await gw.recordCourseEvent(
          alice, chalReq(i, i.isEven ? correct : (correct + 1) % 4));
    }
  }

  setUp(() {
    final c = pickCourse();
    careerId = c.careerId;
    course = LocalCourseGenerator.generateCourse(
        careerId: c.careerId, level: c.level, lessonIndex: 1);
    courseId = course['id'] as String;
    quiz = (course['quiz'] as List).cast<Map>();
    chal = (course['challenges'] as List).cast<Map>();
    store = MemoryXpStore();
    store.docs['users/$alice'] = {'name': 'Alice', 'totalXp': 100};
    store.docs['users/$bob'] = {'name': 'Bob', 'totalXp': 0};
    gw = XpGateway(store: store, clock: () => _now);
  });

  // ═══════════════════════════════════════════════════════════════
  group('course events — XP comes from trusted content', () {
    test(
        'correct quiz answer awards the CATALOG xp and writes the legacy shapes',
        () async {
      final correct = quiz[0]['correctIndex'] as int;
      final xp = (quiz[0]['xpReward'] as num).toInt();

      final r = await gw.recordCourseEvent(alice, quizReq(0, correct));

      expect(r.awarded, isTrue);
      expect(r.xp, xp);
      expect(userXp(), 100 + xp);

      final ev = store.docs[eventPath('quiz:$courseId:0')]!;
      expect(ev['eventType'], 'quiz');
      expect(ev['correct'], true);
      expect(ev['xp'], xp);
      expect(ev['careerId'], careerId);
      expect(ev['eventId'], 'quiz:$courseId:0');
      expect(ev['recordedAt'], isA<String>());

      final progress = store.docs[progressPath()]!;
      expect(progress['careerTotalXp'], xp);
      expect(progress['completedCourseEventIds'], ['quiz:$courseId:0']);
      expect(progress['courseEvidenceIds'], ['quiz:$courseId:0']);
    });

    test('FORGED payload fields are ignored: client xp / correct never count',
        () async {
      final correct = quiz[0]['correctIndex'] as int;
      final wrong = (correct + 1) % 4;
      final req = CourseEventRequest.fromJson({
        'careerId': careerId,
        'courseId': courseId,
        'kind': 'quiz',
        'index': 0,
        'selectedIndex': wrong,
        'xp': 99999,
        'xpReward': 99999,
        'correct': true,
        'totalXp': 1000000,
        'uid': bob,
      });
      final r = await gw.recordCourseEvent(alice, req);
      expect(r.xp, 0);
      expect(userXp(), 100); // untouched
      expect(userXp(bob), 0); // body "uid" ignored
      expect(store.docs[eventPath('quiz_miss:$courseId:0')]!['eventType'],
          'quiz_miss');
      expect(store.docs.containsKey(eventPath('quiz:$courseId:0')), isFalse);
    });

    test('forged answers: only the real correct option earns XP', () async {
      final correct = quiz[0]['correctIndex'] as int;
      for (var sel = 0; sel < 4; sel++) {
        final s = MemoryXpStore();
        s.docs['users/$alice'] = {'totalXp': 0};
        final g = XpGateway(store: s, clock: () => _now);
        final r = await g.recordCourseEvent(alice, quizReq(0, sel));
        expect(r.xp > 0, sel == correct, reason: 'selected $sel');
      }
    });

    test('a wrong answer does not block a later correct retry', () async {
      final correct = quiz[0]['correctIndex'] as int;
      await gw.recordCourseEvent(alice, quizReq(0, (correct + 1) % 4));
      final r = await gw.recordCourseEvent(alice, quizReq(0, correct));
      expect(r.awarded, isTrue);
      expect(r.xp, greaterThan(0));
    });

    test('challenge awards its own catalog xp', () async {
      final correct = chal[0]['correctIndex'] as int;
      final r = await gw.recordCourseEvent(alice, chalReq(0, correct));
      expect(r.xp, (chal[0]['xpReward'] as num).toInt());
      expect(store.docs[eventPath('challenge:$courseId:0')]!['eventType'],
          'challenge');
    });

    test('leaderboard rows are consistent with authoritative XP', () async {
      final correct = quiz[0]['correctIndex'] as int;
      await gw.recordCourseEvent(alice, quizReq(0, correct));
      final total = userXp();
      final g = store.docs['leaderboard/global/entries/$alice']!;
      final w = store.docs['leaderboard/weekly_2026_11_9/entries/$alice']!;
      expect(g['totalXp'], total);
      expect(w['totalXp'], total);
      expect(g['level'], LevelSystem.levelFor(total));
      expect(w['xp'], w['weeklyXp']);
      expect(w['weeklyXp'], total - 100);
      expect(g['displayName'], 'Alice');
    });

    test('zero-XP (miss) events do not touch totals or the leaderboard',
        () async {
      final correct = quiz[0]['correctIndex'] as int;
      await gw.recordCourseEvent(alice, quizReq(0, (correct + 1) % 4));
      expect(userXp(), 100);
      expect(
          store.docs.containsKey('leaderboard/global/entries/$alice'), isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  group('course events — replay and concurrency', () {
    test('replaying the same event awards nothing and changes nothing',
        () async {
      final correct = quiz[0]['correctIndex'] as int;
      await gw.recordCourseEvent(alice, quizReq(0, correct));
      final before = store.snapshot();
      final again = await gw.recordCourseEvent(alice, quizReq(0, correct));
      expect(again.awarded, isFalse);
      expect(again.reason, 'already_recorded');
      expect(store.snapshot(), before);
    });

    test('8 concurrent identical requests award exactly once (real races)',
        () async {
      final correct = quiz[0]['correctIndex'] as int;
      final xp = (quiz[0]['xpReward'] as num).toInt();
      final results = await Future.wait(List.generate(
          8, (_) => gw.recordCourseEvent(alice, quizReq(0, correct))));
      expect(results.where((r) => r.awarded).length, 1);
      expect(userXp(), 100 + xp);
      expect(
          (store.docs[progressPath()]!['completedCourseEventIds'] as List)
              .length,
          1);
      expect(store.bodyRuns, greaterThan(8),
          reason: 'losing transactions must have been retried');
    });

    test('concurrent DIFFERENT questions all award (no lost updates)',
        () async {
      var expected = 100;
      final futures = <Future<GatewayResult>>[];
      for (var i = 0; i < quiz.length; i++) {
        expected += (quiz[i]['xpReward'] as num).toInt();
        futures.add(gw.recordCourseEvent(
            alice, quizReq(i, quiz[i]['correctIndex'] as int)));
      }
      await Future.wait(futures);
      expect(userXp(), expected);
    });

    test('two users never affect each other', () async {
      final correct = quiz[0]['correctIndex'] as int;
      await Future.wait([
        gw.recordCourseEvent(alice, quizReq(0, correct)),
        gw.recordCourseEvent(bob, quizReq(0, correct)),
      ]);
      final xp = (quiz[0]['xpReward'] as num).toInt();
      expect(userXp(alice), 100 + xp);
      expect(userXp(bob), xp);
      expect(store.docs.containsKey(eventPath('quiz:$courseId:0', uid: bob)),
          isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  group('course events — invalid input', () {
    test('invalid / non-canonical course ids are rejected', () async {
      final bad = <String>[
        'not_a_course',
        '${careerId}_level', // no number
        '${careerId}_level0',
        '${careerId}_level02', // alias of level2 would mint a second id
        '${careerId}_level1_lesson0',
        '${careerId}_level1_lesson01',
        '${careerId}_level1_lesson9999',
        '${careerId}_level999',
        '${careerId}_level1_lesson2_extra',
        'other_career_level1_lesson1',
        '${careerId}_level1 ',
        '../${careerId}_level1',
      ];
      for (final id in bad) {
        final req = CourseEventRequest(
            careerId: careerId,
            courseId: id,
            kind: 'quiz',
            index: 0,
            selectedIndex: 0);
        try {
          await gw.recordCourseEvent(alice, req);
          fail('course id "$id" should have been rejected');
        } on GatewayRejection catch (e) {
          expect(e.status, anyOf(400, 422), reason: id);
        }
      }
      expect(userXp(), 100);
    });

    test('a course id belonging to a different career is rejected', () async {
      final req = CourseEventRequest(
          careerId: 'ml_engineer', // does not match the course's career
          courseId: courseId,
          kind: 'quiz',
          index: 0,
          selectedIndex: 0);
      await expectRejection(gw.recordCourseEvent(alice, req),
          status: 422, code: 'unknown_course');
    });

    test('invalid question indexes are rejected', () async {
      for (final i in <int?>[-1, quiz.length, quiz.length + 50, 100000, null]) {
        await expectRejection(
            gw.recordCourseEvent(
                alice,
                CourseEventRequest(
                    careerId: careerId,
                    courseId: courseId,
                    kind: 'quiz',
                    index: i,
                    selectedIndex: 0)),
            status: 422,
            code: 'bad_index');
      }
      for (final i in <int?>[-1, chal.length, 99, null]) {
        await expectRejection(
            gw.recordCourseEvent(
                alice,
                CourseEventRequest(
                    careerId: careerId,
                    courseId: courseId,
                    kind: 'challenge',
                    index: i,
                    selectedIndex: 0)),
            status: 422,
            code: 'bad_index');
      }
    });

    test('invalid selectedIndex values are rejected', () async {
      for (final s in <int?>[-1, 4, 5, 99, null]) {
        await expectRejection(
            gw.recordCourseEvent(
                alice,
                CourseEventRequest(
                    careerId: careerId,
                    courseId: courseId,
                    kind: 'quiz',
                    index: 0,
                    selectedIndex: s)),
            status: 400,
            code: 'bad_selected_index');
      }
    });

    test('malformed JSON bodies are rejected', () {
      expect(() => CourseEventRequest.fromJson({}),
          throwsA(isA<GatewayRejection>()));
      expect(
          () => CourseEventRequest.fromJson(
              {'careerId': careerId, 'courseId': courseId, 'kind': 'lesson'}),
          throwsA(isA<GatewayRejection>()));
      expect(
          () => CourseEventRequest.fromJson(
              {'careerId': 5, 'courseId': courseId, 'kind': 'quiz'}),
          throwsA(isA<GatewayRejection>()));
      expect(
          () => CourseEventRequest.fromJson(
              {'careerId': careerId, 'courseId': 'a\u0000b', 'kind': 'quiz'}),
          throwsA(isA<GatewayRejection>()));
    });

    test('an unverifiable identity is rejected before any work', () async {
      for (final uid in ['', 'a/b', 'x' * 129]) {
        await expectRejection(gw.recordCourseEvent(uid, quizReq(0, 0)),
            status: 401, code: 'bad_identity');
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════
  group('project XP — evidence gate (client "kind: project" proves nothing)',
      () {
    test('a bare project request earns nothing and writes nothing', () async {
      final before = store.snapshot();
      await expectRejection(gw.recordCourseEvent(alice, projectReq()),
          status: 409, code: 'prerequisites_missing');
      expect(store.snapshot(), before);
      expect(userXp(), 100);
    });

    test('partial evidence (quizzes only, no challenges) is not enough',
        () async {
      for (var i = 0; i < quiz.length; i++) {
        await gw.recordCourseEvent(
            alice, quizReq(i, quiz[i]['correctIndex'] as int));
      }
      await expectRejection(gw.recordCourseEvent(alice, projectReq()),
          status: 409, code: 'prerequisites_missing');
    });

    test('evidence for a DIFFERENT course does not count', () async {
      // Answer every question of lesson 2 (a different course id), then try
      // to claim lesson 1's project.
      final other = LocalCourseGenerator.generateCourse(
          careerId: careerId,
          level:
              int.parse(RegExp(r'_level(\d+)').firstMatch(courseId)!.group(1)!),
          lessonIndex: 2);
      final otherId = other['id'] as String;
      for (var i = 0; i < (other['quiz'] as List).length; i++) {
        await gw.recordCourseEvent(
            alice,
            CourseEventRequest(
                careerId: careerId,
                courseId: otherId,
                kind: 'quiz',
                index: i,
                selectedIndex: 0));
      }
      await expectRejection(gw.recordCourseEvent(alice, projectReq()),
          status: 409, code: 'prerequisites_missing');
    });

    test(
        'with server-recorded evidence for EVERY question, project XP is awarded once',
        () async {
      await answerWholeCourse();
      final projectXp =
          ((course['finalProject'] as Map)['xpReward'] as num).toInt();
      final r = await gw.recordCourseEvent(alice, projectReq());
      expect(r.awarded, isTrue);
      expect(r.xp, projectXp);
      expect(
          store.docs[eventPath('project:$courseId')]!['eventType'], 'project');

      final totalAfter = userXp();
      final again = await gw.recordCourseEvent(alice, projectReq());
      expect(again.awarded, isFalse);
      expect(userXp(), totalAfter);
    });

    test('concurrent project claims award once', () async {
      await answerWholeCourse();
      final before = userXp();
      final projectXp =
          ((course['finalProject'] as Map)['xpReward'] as num).toInt();
      final rs = await Future.wait(
          List.generate(6, (_) => gw.recordCourseEvent(alice, projectReq())));
      expect(rs.where((r) => r.awarded).length, 1);
      expect(userXp(), before + projectXp);
    });

    test('ProjectXpPolicy.disabled rejects every project XP request', () async {
      final strict = XpGateway(
        store: store,
        clock: () => _now,
        config: const XpGatewayConfig(
          projectPolicy: ProjectXpPolicy.disabled,
        ),
      );
      await answerWholeCourse();
      await expectRejection(strict.recordCourseEvent(alice, projectReq()),
          status: 403, code: 'project_xp_disabled');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  group('transaction failures', () {
    test('a failed commit applies NOTHING and the error propagates', () async {
      final before = store.snapshot();
      store.failNextCommitWith =
          const XpStoreException('permission_denied', httpStatus: 403);
      final correct = quiz[0]['correctIndex'] as int;
      await expectLater(gw.recordCourseEvent(alice, quizReq(0, correct)),
          throwsA(isA<XpStoreException>()));
      expect(store.snapshot(), before);
      // The same request can succeed afterwards (nothing was half-recorded).
      final r = await gw.recordCourseEvent(alice, quizReq(0, correct));
      expect(r.awarded, isTrue);
    });

    test('aborted commits are retried and still award exactly once', () async {
      store.abortNextCommits = 3;
      final correct = quiz[0]['correctIndex'] as int;
      final xp = (quiz[0]['xpReward'] as num).toInt();
      final r = await gw.recordCourseEvent(alice, quizReq(0, correct));
      expect(r.awarded, isTrue);
      expect(userXp(), 100 + xp);
      expect(store.commits, 1);
      expect(store.bodyRuns, 4);
    });

    test('a read failure propagates and leaves no partial state', () async {
      final before = store.snapshot();
      store.failNextReadWith =
          const XpStoreException('timeout', retryable: true);
      await expectLater(gw.recordCourseEvent(alice, quizReq(0, 0)),
          throwsA(isA<XpStoreException>()));
      expect(store.snapshot(), before);
    });

    test(
        'rejections thrown inside the transaction (e.g. evidence) leave no writes',
        () async {
      final before = store.snapshot();
      await expectRejection(gw.recordCourseEvent(alice, projectReq()),
          status: 409, code: 'prerequisites_missing');
      expect(store.snapshot(), before);
      expect(store.commits, 0);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  group('goals — idempotent MARK-COMPLETE (never a toggle)', () {
    final tpl = GoalContentDatabase.dailyForRole('Software Engineer').first;
    String gid(int i, {String date = '2026-11-14', String? template}) =>
        'software_engineer_${template ?? tpl.id}_${date}_$i';
    String goalPath(String id, {String uid = alice}) =>
        'users/$uid/copilot_daily_goals/$id';
    String canonicalPath(String id) =>
        'users/$alice/copilot_goal_events/software_engineer__goal_${safeDocId(id)}';
    String careerEventPath(String id) =>
        'users/$alice/copilot_learning_progress/software_engineer/events/goal:${safeDocId(id)}';

    void seedGoal(String id, {bool done = false, String uid = alice}) {
      store.docs[goalPath(id, uid: uid)] = {
        'id': id,
        'isCompleted': done,
        'xpReward': 500, // forged value: must be ignored
      };
    }

    GoalRequest req(String id) =>
        GoalRequest(careerId: 'software_engineer', goalId: id);

    test('awards the TEMPLATE xp, ignores the forged goal xpReward', () async {
      seedGoal(gid(0));
      final r = await gw.completeGoal(alice, req(gid(0)));
      expect(r.awarded, isTrue);
      expect(r.xp, tpl.xp);
      expect(r.isCompleted, isTrue);
      expect(userXp(), 100 + tpl.xp);
      expect(store.docs['users/$alice']!['totalGoalsCompleted'], 1);
      expect(store.docs[goalPath(gid(0))]!['isCompleted'], true);
      expect(store.docs[canonicalPath(gid(0))]!['xp'], tpl.xp);
      expect(store.docs[careerEventPath(gid(0))]!['eventType'], 'goal');
    });

    test('replay never awards twice and NEVER un-completes the goal', () async {
      seedGoal(gid(0));
      await gw.completeGoal(alice, req(gid(0)));
      final totalAfterFirst = userXp();
      for (var i = 0; i < 5; i++) {
        final r = await gw.completeGoal(alice, req(gid(0)));
        expect(r.awarded, isFalse);
        expect(r.xp, 0);
        expect(r.isCompleted, isTrue);
        expect(r.reason, 'already_completed');
        expect(store.docs[goalPath(gid(0))]!['isCompleted'], true);
      }
      expect(userXp(), totalAfterFirst);
      expect(store.docs['users/$alice']!['totalGoalsCompleted'], 1);
    });

    test('8 concurrent completions award exactly once', () async {
      seedGoal(gid(0));
      final rs = await Future.wait(
          List.generate(8, (_) => gw.completeGoal(alice, req(gid(0)))));
      expect(rs.where((r) => r.awarded).length, 1);
      expect(userXp(), 100 + tpl.xp);
      expect(store.docs['users/$alice']!['totalGoalsCompleted'], 1);
      expect(rs.every((r) => r.isCompleted == true), isTrue);
    });

    test('an award recorded earlier heals the flag but does not pay again',
        () async {
      seedGoal(gid(0), done: false);
      store.docs[canonicalPath(gid(0))] = {'xp': tpl.xp, 'eventType': 'goal'};
      final r = await gw.completeGoal(alice, req(gid(0)));
      expect(r.awarded, isFalse);
      expect(r.reason, 'already_awarded');
      expect(userXp(), 100);
      expect(store.docs[goalPath(gid(0))]!['isCompleted'], true);
    });

    test('a goal flagged complete without a ledger row pays nothing', () async {
      seedGoal(gid(1), done: true);
      final r = await gw.completeGoal(alice, req(gid(1)));
      expect(r.awarded, isFalse);
      expect(userXp(), 100);
    });

    test('leaderboard stays consistent after a goal award', () async {
      seedGoal(gid(0));
      await gw.completeGoal(alice, req(gid(0)));
      final g = store.docs['leaderboard/global/entries/$alice']!;
      expect(g['totalXp'], userXp());
      expect(g['level'], LevelSystem.levelFor(userXp()));
    });

    test('invalid goals are rejected', () async {
      seedGoal(gid(0, date: '2026-11-01')); // too old
      seedGoal(gid(0, date: '2026-12-31')); // too far ahead
      seedGoal(gid(4)); // index beyond 4 per day
      seedGoal(gid(0, template: 'does_not_exist'));
      await expectRejection(
          gw.completeGoal(alice, req(gid(0, date: '2026-11-01'))),
          status: 422,
          code: 'goal_date_out_of_range');
      await expectRejection(
          gw.completeGoal(alice, req(gid(0, date: '2026-12-31'))),
          status: 422,
          code: 'goal_date_out_of_range');
      await expectRejection(gw.completeGoal(alice, req(gid(4))),
          status: 422, code: 'goal_index_out_of_range');
      await expectRejection(
          gw.completeGoal(alice, req(gid(0, template: 'does_not_exist'))),
          status: 422,
          code: 'unknown_goal_template');
      await expectRejection(
          gw.completeGoal(
              alice,
              const GoalRequest(
                  careerId: 'web_developer',
                  goalId: 'web_developer_x_2026-11-14_0')),
          status: 422,
          code: 'unsupported_career');
      await expectRejection(
          gw.completeGoal(
              alice,
              const GoalRequest(
                  careerId: 'software_engineer', goalId: 'garbage')),
          status: 422,
          code: 'invalid_goal_id');
      await expectRejection(
          gw.completeGoal(
              alice,
              GoalRequest(
                  careerId: 'ml_engineer', goalId: gid(0))), // career mismatch
          status: 422,
          code: 'invalid_goal_id');
      expect(userXp(), 100);
    });

    test('a goal that does not exist cannot be completed', () async {
      await expectRejection(gw.completeGoal(alice, req(gid(2))),
          status: 404, code: 'goal_not_found');
    });

    test("one user cannot complete another user's goal", () async {
      seedGoal(gid(0), uid: alice);
      await expectRejection(gw.completeGoal(bob, req(gid(0))),
          status: 404, code: 'goal_not_found');
      expect(userXp(bob), 0);
      expect(store.docs[goalPath(gid(0))]!['isCompleted'], false);
    });

    test('a failed commit leaves the goal incomplete and unpaid', () async {
      seedGoal(gid(0));
      final before = store.snapshot();
      store.failNextCommitWith =
          const XpStoreException('unavailable', httpStatus: 503);
      await expectLater(gw.completeGoal(alice, req(gid(0))),
          throwsA(isA<XpStoreException>()));
      expect(store.snapshot(), before);
      final r = await gw.completeGoal(alice, req(gid(0)));
      expect(r.awarded, isTrue);
    });
  });

  test('GatewayResult JSON never contains an uid or secrets', () {
    final j = const GatewayResult(awarded: true, xp: 5, eventId: 'e').toJson();
    expect(jsonEncode(j).contains('uid'), isFalse);
  });
}
