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
//   unavailable  -> we could not reach/understand Google (answer 503)
//
// The FIREBASE_WEB_API_KEY is a public project key (it ships inside every
// Firebase app). It is NOT an Admin credential.

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

enum TokenStatus { valid, invalid, unavailable }

class TokenResult {
  const TokenResult(this.status, [this.uid]);
  final TokenStatus status;
  final String? uid;
}

class FirebaseTokenVerifier {
  FirebaseTokenVerifier({
    required this.apiKey,
    required this.projectId,
    http.Client? client,
    DateTime Function()? clock,
    this.timeout = const Duration(seconds: 8),
  })  : _client = client ?? http.Client(),
        _clock = clock ?? DateTime.now;

  final String apiKey;
  final String projectId;
  final Duration timeout;
  final http.Client _client;
  final DateTime Function() _clock;

  static const int _maxTokenLength = 8192;
  static const int _clockSkewSeconds = 300;

  Future<TokenResult> verifyHeader(String? authorizationHeader) async {
    if (apiKey.trim().isEmpty || projectId.trim().isEmpty) {
      // Server is misconfigured: never accept anything.
      return const TokenResult(TokenStatus.unavailable);
    }
    final header = authorizationHeader ?? '';
    if (header.length < 8 ||
        header.substring(0, 7).toLowerCase() != 'bearer ') {
      return const TokenResult(TokenStatus.invalid);
    }
    final token = header.substring(7).trim();
    if (token.isEmpty || token.length > _maxTokenLength) {
      return const TokenResult(TokenStatus.invalid);
    }

    final claims = _checkClaims(token);
    if (claims == null) return const TokenResult(TokenStatus.invalid);

    return _lookup(token, claims);
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
      if (body['iss'] != 'https://securetoken.google.com/$projectId')
        return null;
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
      return const TokenResult(TokenStatus.unavailable);
    } catch (_) {
      return const TokenResult(TokenStatus.unavailable);
    }

    final code = response.statusCode;
    if (code == 400 || code == 401 || code == 403) {
      return const TokenResult(TokenStatus.invalid);
    }
    if (code != 200) return const TokenResult(TokenStatus.unavailable);

    try {
      final value = jsonDecode(response.body);
      if (value is! Map || value['users'] is! List) {
        return const TokenResult(TokenStatus.invalid);
      }
      final users = value['users'] as List;
      if (users.isEmpty || users.first is! Map) {
        return const TokenResult(TokenStatus.invalid);
      }
      final user = users.first as Map;
      final localId = user['localId']?.toString() ?? '';
      if (localId.isEmpty || localId != claims['sub']) {
        return const TokenResult(TokenStatus.invalid);
      }
      if (user['disabled'] == true) {
        return const TokenResult(TokenStatus.invalid);
      }
      // Tokens issued before the account's validSince were revoked.
      final validSince = int.tryParse(user['validSince']?.toString() ?? '');
      final iat = (claims['iat'] as num).toInt();
      if (validSince != null && iat < validSince) {
        return const TokenResult(TokenStatus.invalid);
      }
      return TokenResult(TokenStatus.valid, localId);
    } catch (_) {
      return const TokenResult(TokenStatus.invalid);
    }
  }
}
