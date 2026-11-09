// test/firebase_token_verifier_test.dart
//
// Run with:  flutter test test/firebase_token_verifier_test.dart
//
// Google is faked with MockClient. These tests check OUR logic: claim checks,
// how Google's answers are interpreted, and error classification. They do not
// (and cannot) check Google's real signature verification.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../backend/firebase_token_verifier.dart';

const _project = 'career-test';
final _now = DateTime.utc(2026, 11, 7, 12);
int get _nowSec => _now.millisecondsSinceEpoch ~/ 1000;

String _b64(Object o) =>
    base64Url.encode(utf8.encode(jsonEncode(o))).replaceAll('=', '');

String _token({
  Map<String, dynamic>? header,
  Map<String, dynamic>? claims,
}) {
  final h = header ?? {'alg': 'RS256', 'kid': 'abc', 'typ': 'JWT'};
  final c = <String, dynamic>{
    'iss': 'https://securetoken.google.com/$_project',
    'aud': _project,
    'sub': 'user-1',
    'iat': _nowSec - 60,
    'exp': _nowSec + 3000,
    ...?claims,
  };
  return '${_b64(h)}.${_b64(c)}.signature';
}

String _lookupOk({
  String localId = 'user-1',
  bool disabled = false,
  String? validSince,
}) =>
    jsonEncode({
      'users': [
        {
          'localId': localId,
          if (disabled) 'disabled': true,
          if (validSince != null) 'validSince': validSince,
        }
      ]
    });

FirebaseTokenVerifier _verifier(MockClient client,
        {String apiKey = 'key', String project = _project}) =>
    FirebaseTokenVerifier(
      apiKey: apiKey,
      projectId: project,
      client: client,
      clock: () => _now,
    );

MockClient _google(String body,
        [int code = 200, void Function(http.Request)? spy]) =>
    MockClient((r) async {
      spy?.call(r);
      return http.Response(body, code);
    });

void main() {
  group('valid tokens', () {
    test('a good token gives the uid and calls Google correctly', () async {
      http.Request? seen;
      final v = _verifier(_google(_lookupOk(), 200, (r) => seen = r));
      final res = await v.verifyHeader('Bearer ${_token()}');
      expect(res.status, TokenStatus.valid);
      expect(res.uid, 'user-1');
      expect(seen!.url.host, 'identitytoolkit.googleapis.com');
      expect(seen!.url.path, '/v1/accounts:lookup');
      expect(seen!.url.queryParameters['key'], 'key');
      expect((jsonDecode(seen!.body) as Map)['idToken'], isNotEmpty);
    });

    test('"bearer" is accepted in any letter case', () async {
      final v = _verifier(_google(_lookupOk()));
      expect((await v.verifyHeader('bearer ${_token()}')).status,
          TokenStatus.valid);
    });
  });

  group('header and shape', () {
    for (final h in <String?>[
      null,
      '',
      'Bearer',
      'Bearer ',
      'Basic abc',
      'abc'
    ]) {
      test('rejects header: $h', () async {
        var calls = 0;
        final v = _verifier(_google(_lookupOk(), 200, (_) => calls++));
        expect((await v.verifyHeader(h)).status, TokenStatus.invalid);
        expect(calls, 0); // no call to Google for junk
      });
    }

    test('rejects tokens that are not three parts or are too long', () async {
      final v = _verifier(_google(_lookupOk()));
      expect((await v.verifyHeader('Bearer a.b')).status, TokenStatus.invalid);
      expect((await v.verifyHeader('Bearer a..c')).status, TokenStatus.invalid);
      expect((await v.verifyHeader('Bearer ${'a' * 9000}')).status,
          TokenStatus.invalid);
      expect((await v.verifyHeader('Bearer not.base64!.x')).status,
          TokenStatus.invalid);
    });
  });

  group('local claim checks (no call to Google)', () {
    final bad = <String, String>{
      'wrong audience': _token(claims: {'aud': 'other-project'}),
      'wrong issuer':
          _token(claims: {'iss': 'https://securetoken.google.com/other'}),
      'issuer from accounts.google.com':
          _token(claims: {'iss': 'https://accounts.google.com'}),
      'expired': _token(claims: {'exp': _nowSec - 10}),
      'exp missing': _token(claims: {'exp': null}),
      'issued in the future': _token(claims: {'iat': _nowSec + 4000}),
      'no subject': _token(claims: {'sub': ''}),
      'alg none': _token(header: {'alg': 'none', 'kid': 'abc'}),
      'alg HS256': _token(header: {'alg': 'HS256', 'kid': 'abc'}),
      'no kid': _token(header: {'alg': 'RS256'}),
    };
    for (final e in bad.entries) {
      test('rejects ${e.key}', () async {
        var calls = 0;
        final v = _verifier(_google(_lookupOk(), 200, (_) => calls++));
        expect((await v.verifyHeader('Bearer ${e.value}')).status,
            TokenStatus.invalid);
        expect(calls, 0);
      });
    }
  });

  group('how Google answers are read', () {
    test('400 / 401 / 403 mean the token is invalid', () async {
      for (final code in <int>[400, 401, 403]) {
        final v = _verifier(_google('{}', code));
        expect((await v.verifyHeader('Bearer ${_token()}')).status,
            TokenStatus.invalid,
            reason: '$code');
      }
    });

    test('5xx, 429 and 404 mean unavailable, not invalid', () async {
      for (final code in <int>[500, 503, 429, 404]) {
        final v = _verifier(_google('{}', code));
        expect((await v.verifyHeader('Bearer ${_token()}')).status,
            TokenStatus.unavailable,
            reason: '$code');
      }
    });

    test('network error and timeout mean unavailable', () async {
      final v1 =
          _verifier(MockClient((r) async => throw http.ClientException('x')));
      expect((await v1.verifyHeader('Bearer ${_token()}')).status,
          TokenStatus.unavailable);
      final v2 = FirebaseTokenVerifier(
        apiKey: 'k',
        projectId: _project,
        clock: () => _now,
        timeout: const Duration(milliseconds: 20),
        client: MockClient((r) async {
          await Future<void>.delayed(const Duration(milliseconds: 300));
          return http.Response(_lookupOk(), 200);
        }),
      );
      expect((await v2.verifyHeader('Bearer ${_token()}')).status,
          TokenStatus.unavailable);
    });

    test('uid from Google must equal the token subject', () async {
      final v = _verifier(_google(_lookupOk(localId: 'someone-else')));
      expect((await v.verifyHeader('Bearer ${_token()}')).status,
          TokenStatus.invalid);
    });

    test('disabled accounts are rejected', () async {
      final v = _verifier(_google(_lookupOk(disabled: true)));
      expect((await v.verifyHeader('Bearer ${_token()}')).status,
          TokenStatus.invalid);
    });

    test('tokens issued before validSince (revoked) are rejected', () async {
      final v = _verifier(_google(_lookupOk(validSince: '${_nowSec - 10}')));
      expect((await v.verifyHeader('Bearer ${_token()}')).status,
          TokenStatus.invalid);
      final ok = _verifier(_google(_lookupOk(validSince: '${_nowSec - 3600}')));
      expect((await ok.verifyHeader('Bearer ${_token()}')).status,
          TokenStatus.valid);
    });

    test('empty users, bad shape and non-JSON are invalid', () async {
      for (final body in <String>[
        '{"users":[]}',
        '{"users":"x"}',
        '[]',
        'not json'
      ]) {
        final v = _verifier(_google(body));
        expect((await v.verifyHeader('Bearer ${_token()}')).status,
            TokenStatus.invalid,
            reason: body);
      }
    });
  });

  group('server configuration', () {
    test('missing API key or project id never accepts a token', () async {
      for (final v in <FirebaseTokenVerifier>[
        _verifier(_google(_lookupOk()), apiKey: ''),
        _verifier(_google(_lookupOk()), project: ''),
      ]) {
        final res = await v.verifyHeader('Bearer ${_token()}');
        expect(res.status, TokenStatus.unavailable);
        expect(res.uid, isNull);
      }
    });
  });
}
