import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:ai_career_app/services/claude_service.dart';

void main() {
  late List<http.Request> seen;

  setUp(() {
    seen = <http.Request>[];
    ClaudeService.backendBaseUrlOverride = 'https://api.example.com/';
    ClaudeService.retryBaseDelay = Duration.zero;
    ClaudeService.tokenProvider = ({bool forceRefresh = false}) async =>
        forceRefresh ? 'fresh-token' : 'test-token';
  });

  http.Response ok(String text) => http.Response(
      jsonEncode({'success': true, 'content': text, 'usage': {}}), 200);

  test('calls backend with bearer token, never sends an API key', () async {
    ClaudeService.httpClient = MockClient((req) async {
      seen.add(req);
      return ok('Hello from Aria');
    });

    final out = await ClaudeService.sendMessage(
      message: 'Best AI career?',
      history: [ClaudeService.createUserMessage('Best AI career?')],
    );

    expect(out, 'Hello from Aria');
    expect(
        seen.single.url.toString(), 'https://api.example.com/claude/messages');
    expect(seen.single.headers['Authorization'], 'Bearer test-token');
    expect(seen.single.headers.containsKey('x-api-key'), isFalse);
  });

  test('does not duplicate the current user message', () async {
    ClaudeService.httpClient = MockClient((req) async {
      seen.add(req);
      return ok('fine');
    });
    await ClaudeService.sendMessage(
      message: 'Hi there',
      history: [ClaudeService.createUserMessage('Hi there')],
    );
    final msgs = jsonDecode(seen.single.body)['messages'] as List;
    expect(msgs.length, 1);
  });

  test('refuses to call backend when signed out', () async {
    ClaudeService.tokenProvider = ({bool forceRefresh = false}) async => null;
    ClaudeService.httpClient = MockClient((req) async {
      seen.add(req);
      return ok('x');
    });
    await expectLater(
      ClaudeService.sendMessage(message: 'Hi', history: const []),
      throwsA(isA<Exception>()),
    );
    expect(seen, isEmpty);
  });

  test('retries once with a refreshed token after 401', () async {
    var calls = 0;
    ClaudeService.httpClient = MockClient((req) async {
      seen.add(req);
      calls++;
      return calls == 1 ? http.Response('{}', 401) : ok('after refresh');
    });
    final out =
        await ClaudeService.sendMessage(message: 'Hi', history: const []);
    expect(out, 'after refresh');
    expect(seen.last.headers['Authorization'], 'Bearer fresh-token');
  });

  test('retries transient 503 then succeeds', () async {
    var calls = 0;
    ClaudeService.httpClient = MockClient((req) async {
      calls++;
      return calls < 3 ? http.Response('{}', 503) : ok('finally');
    });
    final out =
        await ClaudeService.sendMessage(message: 'Hi', history: const []);
    expect(out, 'finally');
    expect(calls, 3);
  });

  test('does not retry 429 and hides provider body', () async {
    var calls = 0;
    ClaudeService.httpClient = MockClient((req) async {
      calls++;
      return http.Response('{"error":"secret provider detail"}', 429);
    });
    await expectLater(
      ClaudeService.sendMessage(message: 'Hi', history: const []),
      throwsA(
          predicate((e) => !e.toString().contains('secret provider detail'))),
    );
    expect(calls, 1);
  });

  test('plain http / empty backend URL is not "configured"', () {
    ClaudeService.backendBaseUrlOverride = 'http://evil.example.com';
    expect(ClaudeService.isBackendConfigured, isFalse);
    ClaudeService.backendBaseUrlOverride = '';
    expect(ClaudeService.isBackendConfigured, isFalse);
    ClaudeService.backendBaseUrlOverride = 'https://ok.example.com';
    expect(ClaudeService.isBackendConfigured, isTrue);
  });
}
