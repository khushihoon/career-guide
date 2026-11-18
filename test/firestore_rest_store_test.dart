// test/firestore_rest_store_test.dart
//
// Tests the privileged REST adapter against an in-process FAKE Firestore
// (http MockClient). The fake implements the parts of the Firestore REST API
// the adapter uses — beginTransaction, document GET with ?transaction=,
// commit with preconditions / updateMask / updateTransforms, rollback — and
// enforces optimistic concurrency. It is NOT the real Firestore: the real
// service must still be exercised once against a Firestore emulator or a
// staging project (see PHASE3_STAGE2_NOTES.md).
//
// Run: flutter test test/firestore_rest_store_test.dart
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../backend/firestore_rest_store.dart';
import '../backend/xp_gateway_core.dart';
import '../lib/data/courses/dynamic_career_paths.dart';
import '../lib/services/local_course_generator.dart';

const String _root = '/v1/projects/proj/databases/(default)/documents';
const String _rootName = 'projects/proj/databases/(default)/documents';

class FakeTokens implements AccessTokenProvider {
  int invalidations = 0;
  @override
  Future<String> accessToken() async => 'test-token';
  @override
  void invalidate() => invalidations++;
}

class FakeFirestore {
  final Map<String, Json> docs = <String, Json>{};
  final Map<String, int> versions = <String, int>{};
  final Map<String, Map<String, int>> txReads = <String, Map<String, int>>{};
  final List<http.Request> requests = <http.Request>[];
  int _tx = 0;
  int abortNextCommits = 0;
  int failNextCommitStatus = 0;
  int unauthorizedOnce = 0;

  int count(String suffix) =>
      requests.where((r) => r.url.path.endsWith(suffix)).length;

  http.Response _json(int status, Map<String, dynamic> body) =>
      http.Response(jsonEncode(body), status,
          headers: {'content-type': 'application/json'});

  Future<http.Response> handle(http.Request r) async {
    await Future<void>.delayed(Duration.zero); // let concurrent txs interleave
    requests.add(r);
    final path = r.url.path;

    if (unauthorizedOnce > 0) {
      unauthorizedOnce--;
      return _json(401, {
        'error': {'status': 'UNAUTHENTICATED'}
      });
    }
    if (path == '$_root:beginTransaction') {
      final id = 'tx${++_tx}';
      txReads[id] = <String, int>{};
      return _json(200, {'transaction': id});
    }
    if (path == '$_root:rollback') return _json(200, {});
    if (path == '$_root:commit') return _commit(r);
    if (r.method == 'GET' && path.startsWith('$_root/')) {
      final docPath = path
          .substring(_root.length + 1)
          .split('/')
          .map(Uri.decodeComponent)
          .join('/');
      final tx = r.url.queryParameters['transaction'];
      if (tx != null) txReads[tx]?[docPath] = versions[docPath] ?? 0;
      final d = docs[docPath];
      if (d == null) {
        return _json(404, {
          'error': {'status': 'NOT_FOUND'}
        });
      }
      return _json(
          200, {'name': '$_rootName/$docPath', 'fields': encodeFields(d)});
    }
    return _json(400, {
      'error': {'status': 'INVALID_ARGUMENT'}
    });
  }

  http.Response _commit(http.Request r) {
    final body = jsonDecode(r.body) as Map;
    final txId = body['transaction'] as String;
    final writes = (body['writes'] as List).cast<Map>();

    if (abortNextCommits > 0) {
      abortNextCommits--;
      return _json(409, {
        'error': {'status': 'ABORTED'}
      });
    }
    if (failNextCommitStatus > 0) {
      final s = failNextCommitStatus;
      failNextCommitStatus = 0;
      return http.Response(
          jsonEncode({
            'error': {
              'status': 'PERMISSION_DENIED',
              'message': 'secret-detail-xyz'
            }
          }),
          s);
    }
    for (final e in (txReads[txId] ?? const <String, int>{}).entries) {
      if ((versions[e.key] ?? 0) != e.value) {
        return _json(409, {
          'error': {'status': 'ABORTED'}
        });
      }
    }

    final work = <String, Json>{
      for (final e in docs.entries)
        e.key:
            Map<String, dynamic>.from(jsonDecode(jsonEncode(e.value)) as Map),
    };
    final touched = <String>{};
    for (final w in writes) {
      final upd = w['update'] as Map;
      final name = upd['name'] as String;
      final docPath = name.substring('$_rootName/'.length);
      final cd = w['currentDocument'] as Map?;
      if (cd != null && cd['exists'] == false && docs.containsKey(docPath)) {
        return _json(409, {
          'error': {'status': 'ALREADY_EXISTS'}
        });
      }
      final fields = decodeFields((upd['fields'] as Map?) ?? const {});
      final hasMask = w.containsKey('updateMask');
      work[docPath] = hasMask
          ? <String, dynamic>{...?work[docPath], ...fields}
          : <String, dynamic>{...fields};
      final transforms = (w['updateTransforms'] as List?) ?? const [];
      for (final t in transforms.cast<Map>()) {
        final f = t['fieldPath'] as String;
        final d = work[docPath]!;
        if (t.containsKey('increment')) {
          final inc =
              int.parse((t['increment'] as Map)['integerValue'] as String);
          d[f] = ((d[f] as num?) ?? 0) + inc;
        } else if (t.containsKey('appendMissingElements')) {
          final list = List<dynamic>.from((d[f] as List?) ?? const []);
          for (final v
              in ((t['appendMissingElements'] as Map)['values'] as List)) {
            final s = (v as Map)['stringValue'];
            if (!list.contains(s)) list.add(s);
          }
          d[f] = list;
        }
      }
      touched.add(docPath);
    }
    docs
      ..clear()
      ..addAll(work);
    for (final p in touched) {
      versions[p] = (versions[p] ?? 0) + 1;
    }
    return _json(200, {'commitTime': '2026-11-14T10:00:00Z'});
  }
}

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
  late FakeFirestore fake;
  late FakeTokens tokens;
  late FirestoreRestStore store;
  late XpGateway gw;

  FirestoreRestStore makeStore({int maxAttempts = 10}) => FirestoreRestStore(
        projectId: 'proj',
        tokens: tokens,
        client: MockClient(fake.handle),
        maxAttempts: maxAttempts,
        backoff: (_) => Duration.zero,
      );

  setUp(() {
    fake = FakeFirestore();
    tokens = FakeTokens();
    fake.docs['users/alice'] = {'name': 'Alice', 'totalXp': 100};
    store = makeStore();
    gw = XpGateway(store: store, clock: () => DateTime.utc(2026, 11, 14, 10));
  });

  String careerId = '', courseId = '';
  late List<Map> quiz;
  setUp(() {
    final c = pickCourse();
    careerId = c.careerId;
    final course = LocalCourseGenerator.generateCourse(
        careerId: c.careerId, level: c.level, lessonIndex: 1);
    courseId = course['id'] as String;
    quiz = (course['quiz'] as List).cast<Map>();
  });

  CourseEventRequest correctQuiz(int i) => CourseEventRequest(
      careerId: careerId,
      courseId: courseId,
      kind: 'quiz',
      index: i,
      selectedIndex: quiz[i]['correctIndex'] as int);

  int totalXp() => (fake.docs['users/alice']!['totalXp'] as num).toInt();

  group('gateway through the REST adapter', () {
    test('writes the expected documents with correct REST semantics', () async {
      final xp = (quiz[0]['xpReward'] as num).toInt();
      final r = await gw.recordCourseEvent('alice', correctQuiz(0));
      expect(r.awarded, isTrue);

      // Persisted state
      expect(totalXp(), 100 + xp);
      expect(fake.docs['users/alice']!['totalXp'], isA<int>());
      final eventPath =
          'users/alice/copilot_learning_progress/$careerId/events/quiz:$courseId:0';
      expect(fake.docs[eventPath]!['xp'], xp);
      expect(
          fake.docs['leaderboard/global/entries/alice']!['totalXp'], 100 + xp);

      // Request protocol
      final log = fake.requests;
      expect(log.first.url.path, '$_root:beginTransaction');
      final commitIdx = log.indexWhere((q) => q.url.path == '$_root:commit');
      expect(commitIdx, greaterThan(0));
      for (var i = 0; i < log.length; i++) {
        if (log[i].method == 'GET') {
          expect(i < commitIdx, isTrue, reason: 'all reads precede the commit');
          expect(log[i].url.queryParameters['transaction'], 'tx1');
        }
      }
      expect(
          log.every((q) => q.headers['Authorization'] == 'Bearer test-token'),
          isTrue);

      final commit = jsonDecode(log[commitIdx].body) as Map;
      expect(commit['transaction'], 'tx1');
      final writes = (commit['writes'] as List).cast<Map>();
      final eventWrite = writes.firstWhere(
          (w) => (w['update'] as Map)['name'] == '$_rootName/$eventPath');
      expect(eventWrite['currentDocument'], {'exists': false},
          reason: 'event row must be an atomic create-if-absent');
      final userWrite = writes.firstWhere(
          (w) => (w['update'] as Map)['name'] == '$_rootName/users/alice');
      expect(userWrite['updateMask'], {'fieldPaths': <String>[]});
      expect(
          (userWrite['updateTransforms'] as List).first,
          {
            'fieldPath': 'totalXp',
            'increment': {'integerValue': xp.toString()}
          },
          reason: 'XP is a server-side increment, never a client-computed set');
    });

    test('ABORTED commits are retried in a NEW transaction; XP is awarded once',
        () async {
      fake.abortNextCommits = 2;
      final xp = (quiz[0]['xpReward'] as num).toInt();
      final r = await gw.recordCourseEvent('alice', correctQuiz(0));
      expect(r.awarded, isTrue);
      expect(totalXp(), 100 + xp);
      expect(fake.count(':beginTransaction'), 3);
    });

    test('persistent contention gives up after maxAttempts and writes nothing',
        () async {
      final s = makeStore(maxAttempts: 3);
      final g =
          XpGateway(store: s, clock: () => DateTime.utc(2026, 11, 14, 10));
      fake.abortNextCommits = 100;
      final before = jsonEncode(fake.docs);
      await expectLater(
          g.recordCourseEvent('alice', correctQuiz(0)),
          throwsA(isA<XpStoreException>()
              .having((e) => e.retryable, 'retryable', true)));
      expect(jsonEncode(fake.docs), before);
      expect(fake.count(':beginTransaction'), 3);
    });

    test(
        '6 concurrent identical requests award exactly once (optimistic locking)',
        () async {
      final xp = (quiz[0]['xpReward'] as num).toInt();
      final rs = await Future.wait(List.generate(
          6, (_) => gw.recordCourseEvent('alice', correctQuiz(0))));
      expect(rs.where((r) => r.awarded).length, 1);
      expect(totalXp(), 100 + xp);
    });

    test(
        'create-if-absent precondition failure becomes a re-read, not a duplicate',
        () async {
      // Another writer creates the event row between our read and commit.
      final eventPath =
          'users/alice/copilot_learning_progress/$careerId/events/quiz:$courseId:0';
      var injected = false;
      final racing = MockClient((req) async {
        if (!injected && req.url.path == '$_root:commit') {
          injected = true;
          fake.docs[eventPath] = {
            'xp': 5,
            'eventType': 'quiz'
          }; // no version bump
        }
        return fake.handle(req);
      });
      final s = FirestoreRestStore(
          projectId: 'proj',
          tokens: tokens,
          client: racing,
          backoff: (_) => Duration.zero);
      final g =
          XpGateway(store: s, clock: () => DateTime.utc(2026, 11, 14, 10));
      final r = await g.recordCourseEvent('alice', correctQuiz(0));
      expect(r.awarded, isFalse);
      expect(r.reason, 'already_recorded');
      expect(totalXp(), 100);
    });
  });

  group('failures', () {
    test(
        'non-retryable commit failure: error propagates, nothing applied, rolled back, no body leak',
        () async {
      fake.failNextCommitStatus = 403;
      final before = jsonEncode(fake.docs);
      Object? caught;
      try {
        await gw.recordCourseEvent('alice', correctQuiz(0));
      } catch (e) {
        caught = e;
      }
      expect(caught, isA<XpStoreException>());
      final ex = caught as XpStoreException;
      expect(ex.httpStatus, 403);
      expect(ex.retryable, isFalse);
      expect(ex.toString().contains('secret-detail-xyz'), isFalse);
      expect(jsonEncode(fake.docs), before);
      expect(fake.count(':rollback'), greaterThanOrEqualTo(1));
    });

    test('a 401 invalidates the cached token and retries once', () async {
      fake.unauthorizedOnce = 1;
      final r = await gw.recordCourseEvent('alice', correctQuiz(0));
      expect(r.awarded, isTrue);
      expect(tokens.invalidations, 1);
    });

    test('reading after writing is refused and nothing is committed', () async {
      await expectLater(store.runTransaction((tx) async {
        tx.merge('users/alice', {'a': 1});
        await tx.get('users/alice');
      }), throwsA(isA<StateError>()));
      expect(fake.count(':commit'), 0);
    });

    test('a field both set and incremented is refused', () async {
      await expectLater(store.runTransaction((tx) async {
        tx.merge('users/alice', {'totalXp': 5});
        tx.increment('users/alice', {'totalXp': 5});
      }), throwsA(isA<StateError>()));
      expect(totalXp(), 100);
    });

    test('rejections thrown by the body roll back and write nothing', () async {
      await expectLater(store.runTransaction((tx) async {
        await tx.get('users/alice');
        throw const GatewayRejection(409, 'x', 'x');
      }), throwsA(isA<GatewayRejection>()));
      expect(fake.count(':commit'), 0);
      expect(fake.count(':rollback'), 1);
    });
  });

  group('encoding', () {
    test(
        'document ids are percent-encoded per segment (a literal "%2F" id stays literal)',
        () async {
      await store.runTransaction((tx) async {
        final d =
            await tx.get('users/u1/copilot_goal_events/a%2Fb~0123456789abcdef');
        expect(d, isNull);
        return null;
      });
      final get = fake.requests.firstWhere((q) => q.method == 'GET');
      expect(get.url.path.endsWith('a%252Fb~0123456789abcdef'), isTrue,
          reason: get.url.path);
    });

    test('odd field names are quoted in updateMask', () async {
      await store.runTransaction((tx) async {
        tx.merge('users/alice', {'a-b': 1, 'ok_name': 2});
      });
      final commit =
          fake.requests.firstWhere((q) => q.url.path == '$_root:commit');
      final write =
          ((jsonDecode(commit.body) as Map)['writes'] as List).first as Map;
      expect((write['updateMask'] as Map)['fieldPaths'], ['`a-b`', 'ok_name']);
    });

    test('value encode/decode round-trips every supported type', () {
      final original = <String, dynamic>{
        'n': null,
        'b': true,
        'small': -7,
        'big': 5000000000,
        'd': 1.5,
        's': 'Caf\u00e9 \u{1f680}',
        'list': [
          1,
          'two',
          null,
          [3]
        ],
        'map': {
          'x': 1,
          'inner': {'y': 'z'}
        },
        'emptyList': <dynamic>[],
        'emptyMap': <String, dynamic>{},
      };
      final enc = encodeFields(original);
      expect(enc['big'], {'integerValue': '5000000000'});
      expect(enc['small'], {'integerValue': '-7'});
      expect(decodeFields(jsonDecode(jsonEncode(enc)) as Map), original);
    });

    test('unsupported / non-finite values are refused', () {
      expect(() => encodeValue(DateTime.now()), throwsArgumentError);
      expect(() => encodeValue(double.nan), throwsArgumentError);
      expect(() => encodeValue(double.infinity), throwsArgumentError);
    });
  });

  group('fromEnvironment fails closed', () {
    test('missing project id', () {
      expect(() => FirestoreRestStore.fromEnvironment({}), throwsStateError);
    });
    test('no credentials configured', () {
      expect(
          () => FirestoreRestStore.fromEnvironment(
              {'FIREBASE_PROJECT_ID': 'proj'}),
          throwsStateError);
    });
    test('metadata mode needs no secret', () {
      final s = FirestoreRestStore.fromEnvironment({
        'FIREBASE_PROJECT_ID': 'proj',
        'XP_FIRESTORE_CREDENTIALS': 'metadata',
      }, client: MockClient(fake.handle));
      expect(s.projectId, 'proj');
    });
    test(
        'invalid JSON / invalid base64 / wrong project / bad key are refused without echoing secrets',
        () {
      final badKey = jsonEncode({
        'type': 'service_account',
        'project_id': 'proj',
        'client_email': 'svc@proj.iam.gserviceaccount.com',
        'private_key':
            '-----BEGIN PRIVATE KEY-----\nTOP-SECRET-KEY\n-----END PRIVATE KEY-----\n',
      });
      final wrongProject = jsonEncode({
        'type': 'service_account',
        'project_id': 'other',
        'client_email': 'svc@other.iam.gserviceaccount.com',
        'private_key':
            '-----BEGIN PRIVATE KEY-----\nTOP-SECRET-KEY\n-----END PRIVATE KEY-----\n',
      });
      final cases = <Map<String, String>>[
        {'GOOGLE_SERVICE_ACCOUNT_JSON': '{not json'},
        {'GOOGLE_SERVICE_ACCOUNT_JSON_B64': '***not-base64***'},
        {'GOOGLE_SERVICE_ACCOUNT_JSON': wrongProject},
        {'GOOGLE_SERVICE_ACCOUNT_JSON': badKey},
        {'GOOGLE_SERVICE_ACCOUNT_JSON_B64': base64.encode(utf8.encode(badKey))},
      ];
      for (final extra in cases) {
        try {
          FirestoreRestStore.fromEnvironment(
              {'FIREBASE_PROJECT_ID': 'proj', ...extra});
          fail('should have refused: ${extra.keys.first}');
        } on StateError catch (e) {
          expect(e.message.contains('TOP-SECRET-KEY'), isFalse);
        }
      }
    });
  });
}
