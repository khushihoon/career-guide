import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';

/// Builds the security headers for calls to the app's own backend.
///
/// Authorization: Bearer <Firebase ID token>
/// X-Firebase-AppCheck: <App Check token>
///
/// Missing, failed, or slow token retrieval omits that header. The backend
/// remains responsible for rejecting an unauthenticated/unattested request.
/// Tokens are never logged. Callers decide which URLs may receive tokens.
class BackendAuthHeaders {
  BackendAuthHeaders._();

  static const String authorizationHeaderName = 'Authorization';
  static const String appCheckHeaderName = 'X-Firebase-AppCheck';
  static const Duration tokenTimeout = Duration(seconds: 8);

  /// Returns the current Firebase App Check token, or null if unavailable.
  static Future<String?> defaultAppCheckToken({
    bool forceRefresh = false,
  }) async {
    try {
      final token = await FirebaseAppCheck.instance
          .getToken(forceRefresh)
          .timeout(tokenTimeout);
      if (token == null || token.isEmpty) return null;
      return token;
    } catch (_) {
      return null;
    }
  }

  /// Returns security headers. A provider failure never prevents the request.
  static Future<Map<String, String>> build({
    required Future<String?> Function() idTokenProvider,
    Future<String?> Function()? appCheckProvider,
  }) async {
    final headers = <String, String>{};

    final idToken = await _safe(idTokenProvider);
    if (idToken != null && idToken.isNotEmpty) {
      headers[authorizationHeaderName] = 'Bearer $idToken';
    }

    final appCheck = appCheckProvider ?? () => defaultAppCheckToken();
    final appCheckToken = await _safe(appCheck);
    if (appCheckToken != null && appCheckToken.isNotEmpty) {
      headers[appCheckHeaderName] = appCheckToken;
    }
    return headers;
  }

  static Future<String?> _safe(Future<String?> Function() provider) async {
    try {
      return await provider().timeout(tokenTimeout);
    } catch (_) {
      return null;
    }
  }
}
