// backend/firebase_token_verifier.dart
//
// Server-side verification of a Firebase ID token ("Authorization: Bearer").
// Pure Dart (no dart:io) so it can be unit-tested with a fake HTTP client.
//
// Two layers, so one mistake cannot let a bad token through:
//
//  1. LOCAL CLAIM CHECKS on the token payload (cheap, no network):
//       alg is RS256, iss == https://securetoken.google.com/<projectId>,
//       aud == <projectId>, exp in the future, iat not in the future,
//       sub is present.
//     These checks are NOT trusted on their own, because the payload
//     could be forged. They only reject obviously wrong tokens early.
//
//  2. GOOGLE VERIFICATION through the Identity Toolkit "accounts:lookup"
//     REST call. Google checks the token signature, expiry and that the
//     account still exists. We then also require:
//       users[0].localId == sub,   user is not disabled,
//       token was issued after the account's validSince (revocation).
//
// Result:
//   valid        -> uid is set
//   invalid      -> the token is bad (answer 401)
//   unavailable  -> we could not reach/understand Google, or the server's own
//                   Firebase configuration (API key, quota) is wrong
//                   (answer 503)
//
// PHASE 2 ADDITIONS (the public API below is unchanged and backward
// compatible; every new constructor parameter is optional):
//   * TokenResult has an optional short `reason` code for server logs. It
//     never contains token contents.
//   * Google rejections are classified: a rejected TOKEN is `invalid`, but a
//     problem with OUR API key / quota / project configuration is
//     `unavailable`, so a server misconfiguration is not reported to callers
//     as "your token is bad".
//   * Optional bounded in-memory cache of SUCCESSFUL lookups
//     (`cacheTtl`, default disabled). An entry never outlives the token's own
//     `exp`. Revocation or disabling therefore takes effect within
//     `cacheTtl`. Failures are never cached.
//   * Concurrent verifications of the same token share one Google call.
//
// The FIREBASE_WEB_API_KEY is a public project key (it ships inside every
// Firebase app). It is NOT an Admin credential.

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

enum TokenStatus { valid, invalid, unavailable }

class TokenResult {
  const TokenResult(this.status, [this.uid, this.reason]);
  final TokenStatus status;
  final String? uid;

  /// Short machine-readable code for server logs (never token contents).
  final String? reason;
}

class FirebaseTokenVerifier {
  FirebaseTokenVerifier({
    required this.apiKey,
    required this.projectId,
    http.Client? client,
    DateTime Function()? clock,
    this.timeout = const Duration(seconds: 8),
    this.cacheTtl = Duration.zero,
    this.maxCacheEntries = 2000,
  })  : _client = client ?? http.Client(),
        _clock = clock ?? DateTime.now;

  final String apiKey;
  final String projectId;
  final Duration timeout;

  /// How long a successful lookup may be reused. `Duration.zero` disables the
  /// cache (default). Never exceeds the token's own expiry.
  final Duration cacheTtl;

  /// Upper bound on cached entries (memory protection).
  final int maxCacheEntries;

  final http.Client _client;
  final DateTime Function() _clock;

  final Map<String, _CachedUid> _cache = <String, _CachedUid>{};
  final Map<String, Future<TokenResult>> _inflight =
      <String, Future<TokenResult>>{};

  static const int _maxTokenLength = 8192;
  static const int _clockSkewSeconds = 300;

  /// Substrings of Google's error message that indicate OUR configuration or
  /// quota is at fault rather than the caller's token.
  static const List<String> _infrastructureMarkers = <String>[
    'API KEY',
    'API_KEY',
    'QUOTA',
    'PERMISSION_DENIED',
    'SERVICE_BLOCKED',
    'SERVICE_DISABLED',
    'ACCESS_NOT_CONFIGURED',
    'IP_ADDRESS_BLOCKED',
    'REFERER',
    'BILLING',
    'RESOURCE_EXHAUSTED',
    'PROJECT_NOT_FOUND',
  ];

  Future<TokenResult> verifyHeader(String? authorizationHeader) async {
    if (apiKey.trim().isEmpty || projectId.trim().isEmpty) {
      // Server is misconfigured: never accept anything.
      return const TokenResult(TokenStatus.unavailable, null, 'misconfigured');
    }
    final header = authorizationHeader ?? '';
    if (header.length < 8 ||
        header.substring(0, 7).toLowerCase() != 'bearer ') {
      return const TokenResult(TokenStatus.invalid, null, 'no_bearer');
    }
    final token = header.substring(7).trim();
    if (token.isEmpty || token.length > _maxTokenLength) {
      return const TokenResult(TokenStatus.invalid, null, 'bad_length');
    }

    final claims = _checkClaims(token);
    if (claims == null) {
      return const TokenResult(TokenStatus.invalid, null, 'claims');
    }

    final cachedUid = _cacheGet(token);
    if (cachedUid != null) {
      return TokenResult(TokenStatus.valid, cachedUid, 'cached');
    }

    // Share one Google call between concurrent requests with the same token.
    final pending = _inflight[token];
    if (pending != null) return pending;
    final future = _lookup(token, claims).whenComplete(() {
      _inflight.remove(token);
    });
    _inflight[token] = future;
    return future;
  }

  // ── Layer 1: local claim checks ─────────────────────────────────

  Map<String, dynamic>? _checkClaims(String token) {
    final parts = token.split('.');
    if (parts.length != 3 || parts.any((p) => p.isEmpty)) return null;
    try {
      final head = _decodeSegment(parts[0]);
      final body = _decodeSegment(parts[1]);
      if (head['alg'] != 'RS256') return null;
      final kid = head['kid'];
      if (kid is! String || kid.isEmpty) return null;

      final nowSec = _clock().millisecondsSinceEpoch ~/ 1000;
      if (body['iss'] != 'https://securetoken.google.com/$projectId') {
        return null;
      }
      if (body['aud'] != projectId) return null;
      final sub = body['sub'];
      if (sub is! String || sub.isEmpty || sub.length > 128) return null;
      final exp = body['exp'];
      final iat = body['iat'];
      if (exp is! num || exp <= nowSec) return null;
      if (iat is! num || iat > nowSec + _clockSkewSeconds) return null;
      return body;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _decodeSegment(String seg) {
    final bytes = base64Url.decode(base64Url.normalize(seg));
    final value = jsonDecode(utf8.decode(bytes));
    if (value is! Map) throw const FormatException('not an object');
    return Map<String, dynamic>.from(value);
  }

  // ── Layer 2: Google verification ────────────────────────────────

  Future<TokenResult> _lookup(String token, Map<String, dynamic> claims) async {
    final http.Response response;
    try {
      response = await _client
          .post(
            Uri.https('identitytoolkit.googleapis.com', '/v1/accounts:lookup',
                {'key': apiKey}),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'idToken': token}),
          )
          .timeout(timeout);
    } on TimeoutException {
      return const TokenResult(TokenStatus.unavailable, null, 'timeout');
    } catch (_) {
      return const TokenResult(TokenStatus.unavailable, null, 'network');
    }

    final code = response.statusCode;
    if (code == 400 || code == 401 || code == 403) {
      return _classifyRejection(response.body);
    }
    if (code != 200) {
      return TokenResult(TokenStatus.unavailable, null, 'http_$code');
    }

    try {
      final value = jsonDecode(response.body);
      if (value is! Map || value['users'] is! List) {
        return const TokenResult(TokenStatus.invalid, null, 'bad_response');
      }
      final users = value['users'] as List;
      if (users.isEmpty || users.first is! Map) {
        return const TokenResult(TokenStatus.invalid, null, 'no_user');
      }
      final user = users.first as Map;
      final localId = user['localId']?.toString() ?? '';
      if (localId.isEmpty || localId != claims['sub']) {
        return const TokenResult(TokenStatus.invalid, null, 'uid_mismatch');
      }
      if (user['disabled'] == true) {
        return const TokenResult(TokenStatus.invalid, null, 'disabled');
      }
      // Tokens issued before the account's validSince were revoked.
      final validSince = int.tryParse(user['validSince']?.toString() ?? '');
      final iat = (claims['iat'] as num).toInt();
      if (validSince != null && iat < validSince) {
        return const TokenResult(TokenStatus.invalid, null, 'revoked');
      }
      _cachePut(token, localId, claims);
      return TokenResult(TokenStatus.valid, localId);
    } catch (_) {
      return const TokenResult(TokenStatus.invalid, null, 'bad_response');
    }
  }

  /// A 400/401/403 from Google normally means the TOKEN was rejected
  /// (INVALID_ID_TOKEN, TOKEN_EXPIRED, USER_NOT_FOUND, USER_DISABLED, ...).
  /// But an invalid/blocked API key, an exhausted quota or a disabled API is a
  /// SERVER problem and must be reported as `unavailable` (503), not 401.
  TokenResult _classifyRejection(String body) {
    final message = _googleErrorMessage(body).toUpperCase();
    for (final marker in _infrastructureMarkers) {
      if (message.contains(marker)) {
        return const TokenResult(
            TokenStatus.unavailable, null, 'google_config');
      }
    }
    return const TokenResult(TokenStatus.invalid, null, 'rejected');
  }

  String _googleErrorMessage(String body) {
    try {
      final value = jsonDecode(body);
      if (value is Map && value['error'] is Map) {
        final message = (value['error'] as Map)['message'];
        if (message is String) return message;
      }
    } catch (_) {}
    return '';
  }

  // ── Bounded positive cache ──────────────────────────────────────

  String? _cacheGet(String token) {
    if (cacheTtl <= Duration.zero) return null;
    final entry = _cache[token];
    if (entry == null) return null;
    if (!entry.expiresAt.isAfter(_clock())) {
      _cache.remove(token);
      return null;
    }
    return entry.uid;
  }

  void _cachePut(String token, String uid, Map<String, dynamic> claims) {
    if (cacheTtl <= Duration.zero || maxCacheEntries <= 0) return;
    final now = _clock();
    var expiresAt = now.add(cacheTtl);
    final exp = claims['exp'];
    if (exp is num) {
      final tokenExpiry = DateTime.fromMillisecondsSinceEpoch(
          exp.toInt() * 1000,
          isUtc: true);
      if (tokenExpiry.isBefore(expiresAt)) expiresAt = tokenExpiry;
    }
    if (!expiresAt.isAfter(now)) return;

    if (_cache.length >= maxCacheEntries) {
      _cache.removeWhere((_, v) => !v.expiresAt.isAfter(now));
      while (_cache.length >= maxCacheEntries) {
        _cache.remove(_cache.keys.first);
      }
    }
    _cache[token] = _CachedUid(uid, expiresAt);
  }
}

class _CachedUid {
  const _CachedUid(this.uid, this.expiresAt);
  final String uid;
  final DateTime expiresAt;
}