// backend/xp_gateway_http_routes.dart
//
// HTTP adapter for the trusted XP gateway.
// Call only after ApiSecurityGuard.authorize() succeeds and pass the UID
// returned by the verified Firebase ID token. Never accept a UID from JSON.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'firestore_rest_store.dart';
import 'xp_gateway_core.dart';

class XpGatewayHttpRoutes {
  XpGatewayHttpRoutes(this.gateway);

  final XpGateway gateway;

  bool matches(HttpRequest request) =>
      request.method == 'POST' &&
      (request.uri.path == '/xp/course-event' ||
          request.uri.path == '/xp/complete-goal');

  /// Returns true when this adapter handled the request.
  ///
  /// [verifiedUid] must come from GuardDecision.uid after Firebase token
  /// verification. Do not pass a request-body UID here.
  Future<bool> handle(
    HttpRequest request, {
    required String? verifiedUid,
    int maxBodyBytes = 65536,
  }) async {
    if (!matches(request)) return false;

    if (verifiedUid == null || verifiedUid.isEmpty) {
      await _send(request, 401, {
        'success': false,
        'error': 'A verified Firebase identity is required.',
      });
      return true;
    }

    final contentType = request.headers.contentType;
    if (contentType == null || contentType.mimeType != 'application/json') {
      await _send(request, 415, {
        'success': false,
        'error': 'Content-Type must be application/json.',
      });
      return true;
    }

    try {
      final data = await _readJson(request, maxBodyBytes);
      final GatewayResult result;

      if (request.uri.path == '/xp/course-event') {
        result = await gateway.recordCourseEvent(
          verifiedUid,
          CourseEventRequest.fromJson(data),
        );
      } else {
        result = await gateway.completeGoal(
          verifiedUid,
          GoalRequest.fromJson(data),
        );
      }

      await _send(request, 200, {
        'success': true,
        'result': result.toJson(),
      });
    } on GatewayRejection catch (e) {
      await _send(request, e.status, {
        'success': false,
        'error': e.message,
        'code': e.code,
      });
    } on XpStoreException {
      // Never expose Firestore, credential, or infrastructure details.
      await _send(request, 503, {
        'success': false,
        'error': 'XP service is temporarily unavailable. Please try again.',
      });
    } on _XpBodyTooLarge {
      await _send(request, 413, {
        'success': false,
        'error': 'Request body is too large.',
      });
    } on _XpBodyTimeout {
      await _send(request, 408, {
        'success': false,
        'error': 'Request body timed out.',
      });
    } on FormatException {
      await _send(request, 400, {
        'success': false,
        'error': 'Request body must be valid JSON.',
      });
    } catch (_) {
      await _send(request, 500, {
        'success': false,
        'error': 'Internal server error.',
      });
    }

    return true;
  }

  static Future<Map<String, dynamic>> _readJson(
    HttpRequest request,
    int maxBytes,
  ) async {
    if (maxBytes < 1) {
      throw ArgumentError.value(maxBytes, 'maxBytes');
    }
    if (request.contentLength > maxBytes) {
      throw const _XpBodyTooLarge();
    }

    final bytes = BytesBuilder(copy: false);
    final watch = Stopwatch()..start();

    try {
      await for (final chunk in request.timeout(const Duration(seconds: 10))) {
        bytes.add(chunk);
        if (bytes.length > maxBytes) {
          throw const _XpBodyTooLarge();
        }
        if (watch.elapsed > const Duration(seconds: 15)) {
          throw const _XpBodyTimeout();
        }
      }
    } on TimeoutException {
      throw const _XpBodyTimeout();
    }

    final decoded = jsonDecode(utf8.decode(
      bytes.takeBytes(),
      allowMalformed: false,
    ));

    if (decoded is! Map) {
      throw const FormatException('Expected a JSON object.');
    }
    return Map<String, dynamic>.from(decoded);
  }

  static Future<void> _send(
    HttpRequest request,
    int status,
    Map<String, dynamic> body,
  ) async {
    request.response
      ..statusCode = status
      ..headers.contentType = ContentType.json
      ..headers.set('Cache-Control', 'no-store')
      ..headers.set('X-Content-Type-Options', 'nosniff')
      ..write(jsonEncode(body));

    await request.response.close();
  }
}

class _XpBodyTooLarge implements Exception {
  const _XpBodyTooLarge();
}

class _XpBodyTimeout implements Exception {
  const _XpBodyTimeout();
}
