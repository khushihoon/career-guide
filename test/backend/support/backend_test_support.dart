// test/backend/support/backend_test_support.dart
//
// Shared helpers for the backend tests (not a test file itself):
//   * FakeTokenVerifier / FakeAppCheckVerifier  – deterministic stand-ins for
//     the real verifiers, so the guard and the servers can be tested without
//     any network and without real Firebase tokens.
//   * productionEnv()      – a valid production-like environment map.
//   * buildGuard()         – builds an ApiSecurityGuard from an environment.
//   * sendRequest()        – a tiny dart:io HTTP client for loopback servers.
//
// The real verifiers have their own dedicated test files.

import 'dart:convert';
import 'dart:io';

import '../../../backend/api_security_guard.dart';
import '../../../backend/firebase_app_check_verifier.dart';
import '../../../backend/firebase_token_verifier.dart';

const String kProjectNumber = '123456789012';
const String kAppId = '1:123456789012:android:abc123';

/// Headers that the fake verifiers accept.
const Map<String, String> kGoodHeaders = <String, String>{
  'Authorization': 'Bearer good',
  'X-Firebase-AppCheck': 'ac-good',
};

/// Stand-in for FirebaseTokenVerifier. Behaviour is decided by the exact
/// Authorization header value.
class FakeTokenVerifier extends FirebaseTokenVerifier {
  FakeTokenVerifier() : super(apiKey: 'fake-key', projectId: 'fake-project');

  int calls = 0;

  final Map<String, TokenResult> table = <String, TokenResult>{
    'Bearer good': const TokenResult(TokenStatus.valid, 'uid-1'),
    'Bearer good2': const TokenResult(TokenStatus.valid, 'uid-2'),
    'Bearer down':
        const TokenResult(TokenStatus.unavailable, null, 'network'),
  };

  @override
  Future<TokenResult> verifyHeader(String? authorizationHeader) async {
    calls++;
    return table[authorizationHeader] ??
        const TokenResult(TokenStatus.invalid, null, 'claims');
  }
}

/// Stand-in for FirebaseAppCheckVerifier. Behaviour is decided by the exact
/// token value: 'ac-good' is valid, 'ac-down' is an outage, a missing token
/// is invalid, everything else is invalid.
class FakeAppCheckVerifier extends FirebaseAppCheckVerifier {
  FakeAppCheckVerifier() : super(projectNumber: kProjectNumber);

  int calls = 0;

  @override
  Future<AppCheckResult> verify(String? token) async {
    calls++;
    if (token == 'ac-good') {
      return const AppCheckResult(AppCheckStatus.valid, appId: kAppId);
    }
    if (token == 'ac-down') {
      return const AppCheckResult(AppCheckStatus.unavailable,
          reason: 'jwks_unavailable');
    }
    if (token == null || token.isEmpty) {
      return const AppCheckResult(AppCheckStatus.invalid,
          reason: 'missing_token');
    }
    return const AppCheckResult(AppCheckStatus.invalid,
        reason: 'bad_signature');
  }
}

/// A valid production-like environment. [extra] overrides / adds entries.
Map<String, String> productionEnv([Map<String, String> extra = const {}]) =>
    <String, String>{
      'CAREER_GUIDE_ENV': 'production',
      'FIREBASE_WEB_API_KEY': 'web-api-key',
      'FIREBASE_PROJECT_ID': 'demo-project',
      'FIREBASE_PROJECT_NUMBER': kProjectNumber,
      'APP_CHECK_ALLOWED_APP_IDS': kAppId,
      'CAREER_GUIDE_BIND_ADDRESS': '127.0.0.1',
      'COURSE_ALLOWED_ORIGINS': 'https://app.example.com',
      'CAREER_GUIDE_ALLOWED_ORIGINS': 'https://app.example.com',
      ...extra,
    };

/// Builds a guard from [env] that uses the supplied fakes.
ApiSecurityGuard buildGuard(
  Map<String, String> env, {
  required FakeTokenVerifier tokenVerifier,
  required FakeAppCheckVerifier appCheckVerifier,
  DateTime Function()? clock,
  void Function(String)? log,
}) {
  final config = SecurityConfig.fromEnvironment(env);
  return ApiSecurityGuard(
    config: config,
    tokenVerifier: tokenVerifier,
    appCheckVerifier: appCheckVerifier,
    clock: clock,
    log: log,
  );
}

class TestResponse {
  TestResponse(this.status, this.body, this.headers);

  final int status;
  final String body;
  final HttpHeaders headers;

  dynamic get json => jsonDecode(body);
  Map<String, dynamic> get map => Map<String, dynamic>.from(json as Map);
  String? header(String name) => headers.value(name);
}

/// Sends one request to a loopback test server.
///
/// [jsonBody] is JSON-encoded. [rawBody] is sent as-is. [contentType]
/// defaults to application/json when a body is present.
Future<TestResponse> sendRequest(
  HttpServer server,
  String method,
  String path, {
  Map<String, String> headers = const <String, String>{},
  Object? jsonBody,
  String? rawBody,
  String? contentType,
}) async {
  final client = HttpClient();
  try {
    final request = await client.openUrl(
      method,
      Uri.parse('http://127.0.0.1:${server.port}$path'),
    );
    headers.forEach((name, value) => request.headers.set(name, value));

    final String? text =
        rawBody ?? (jsonBody == null ? null : jsonEncode(jsonBody));
    if (text != null) {
      final bytes = utf8.encode(text);
      request.headers.contentType =
          ContentType.parse(contentType ?? 'application/json');
      request.contentLength = bytes.length;
      request.add(bytes);
    }

    final response = await request.close();
    final body = await utf8.decodeStream(response);
    return TestResponse(response.statusCode, body, response.headers);
  } finally {
    client.close(force: true);
  }
}