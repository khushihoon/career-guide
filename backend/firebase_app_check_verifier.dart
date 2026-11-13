// backend/firebase_app_check_verifier.dart
//
// Server-side verification of a Firebase App Check token (the value of the
// "X-Firebase-AppCheck" request header) for a Dart backend.
//
// WHY THIS FILE EXISTS
//   Firebase's Admin SDKs verify App Check tokens for Node.js, Python and Go.
//   For other languages Firebase documents manual JWT verification
//   ("Verify App Check tokens from a custom backend"). This file implements
//   those documented steps in pure Dart:
//
//     1. Fetch the App Check public keys (JWKS) from
//        https://firebaseappcheck.googleapis.com/v1/jwks
//     2. Verify the token signature (RS256).
//     3. Require header alg = RS256.
//     4. Require header typ = JWT.
//     5. Require iss = https://firebaseappcheck.googleapis.com/<PROJECT_NUMBER>
//     6. Require the token not to be expired (exp).
//     7. Require aud to contain projects/<PROJECT_NUMBER>
//     8. Require a non-empty sub (the Firebase App ID), optionally one that is
//        in an allow-list of your own app IDs.
//
//   Both issuer and audience use the Firebase project NUMBER, not the
//   project ID.
//
// ADDITIONAL HARDENING (not from the Firebase page, added here on purpose)
//   * The token is never trusted before its signature is verified.
//   * Only RS256 is accepted, and the algorithm is checked BEFORE any key is
//     used, so "none" / HS256 / key-confusion tricks are rejected.
//   * The header parameters jku, x5u, x5c, jwk and crit make the token
//     invalid. Keys are ONLY ever taken from the Google JWKS endpoint. A URL
//     or key embedded in a token is never fetched or used.
//   * Token size is limited (8 KB) and must be strict base64url.
//   * Weak RSA keys (< minModulusBits, default 2048) are ignored.
//   * Key cache is bounded: at most [maxKeyAge] (6 hours, as the Firebase
//     page allows), or a shorter Cache-Control max-age if Google sends one.
//   * Key rotation: a token with an unknown `kid` triggers at most ONE
//     refetch per [unknownKidRefreshInterval] (default 5 min) and all
//     concurrent refreshes share ONE network call (single-flight). An
//     attacker sending random `kid` values cannot cause a fetch flood.
//   * If a refresh fails, cached keys keep working until they are
//     [maxKeyAge] old; after that the result is `unavailable`.
//   * Results distinguish INVALID tokens (answer 401) from INFRASTRUCTURE
//     problems such as the JWKS endpoint being unreachable (answer 503).
//   * This file never logs and never puts token contents into `reason`.
//
// LIBRARY AND LIMITATIONS
//   * Uses `package:pointycastle` ONLY for the RSA PKCS#1 v1.5 / SHA-256
//     signature primitive. JWT parsing and every claim check is done here so
//     there is no JWT-library behaviour to second-guess. pointycastle is a
//     widely used pure-Dart crypto library; it is not constant-time audited,
//     which is acceptable because only PUBLIC keys and public data are used.
//   * No replay protection. Firebase only offers token consumption
//     (replay protection) through the Node.js/Python Admin SDKs and it needs
//     a service account. A stolen App Check token stays valid until it
//     expires; keep the App Check token TTL short in the Firebase Console.
//   * App Check proves "this request comes from a genuine registered app
//     instance", not which USER sent it. Always combine it with Firebase
//     Auth verification.
//   * A token minted by the Debug provider is cryptographically identical to
//     a real one. Use a separate Firebase project for development and delete
//     debug tokens from the production project.
//   * Pure Dart, no dart:io: it can be unit-tested with a fake HTTP client.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:pointycastle/export.dart' as pc;

enum AppCheckStatus { valid, invalid, unavailable }

class AppCheckResult {
  const AppCheckResult(this.status, {this.appId, this.reason});

  final AppCheckStatus status;

  /// The Firebase App ID (the token `sub`) when [status] is valid.
  final String? appId;

  /// Short machine-readable code for server logs. Never token contents.
  final String? reason;
}

class FirebaseAppCheckVerifier {
  FirebaseAppCheckVerifier({
    required this.projectNumber,
    Set<String> allowedAppIds = const <String>{},
    http.Client? client,
    DateTime Function()? clock,
    Uri? jwksUri,
    this.timeout = const Duration(seconds: 5),
    this.maxKeyAge = const Duration(hours: 6),
    this.unknownKidRefreshInterval = const Duration(minutes: 5),
    this.softRefreshRetryInterval = const Duration(seconds: 30),
    this.initialLoadRetryInterval = const Duration(seconds: 5),
    this.minModulusBits = 2048,
  })  : allowedAppIds = Set<String>.unmodifiable(allowedAppIds),
        jwksUri = jwksUri ?? defaultJwksUri,
        _client = client ?? http.Client(),
        _clock = clock ?? DateTime.now;

  /// The Firebase project NUMBER (digits only), not the project ID.
  final String projectNumber;

  /// If not empty, the token `sub` (Firebase App ID) must be one of these.
  final Set<String> allowedAppIds;

  final Uri jwksUri;
  final Duration timeout;
  final Duration maxKeyAge;
  final Duration unknownKidRefreshInterval;
  final Duration softRefreshRetryInterval;
  final Duration initialLoadRetryInterval;
  final int minModulusBits;

  final http.Client _client;
  final DateTime Function() _clock;

  static final Uri defaultJwksUri =
      Uri.parse('https://firebaseappcheck.googleapis.com/v1/jwks');

  static const int maxTokenLength = 8192;
  static const int _maxJwksBytes = 262144;
  static const String _sha256DigestIdHex = '0609608648016503040201';
  static const Set<String> _rejectedHeaderParams = <String>{
    'jku',
    'x5u',
    'x5c',
    'jwk',
    'crit',
  };

  static final RegExp _base64UrlPattern = RegExp(r'^[A-Za-z0-9_-]+$');
  static final RegExp _projectNumberPattern = RegExp(r'^\d{1,20}$');

  // Key cache state.
  Map<String, _RsaKey> _keys = const <String, _RsaKey>{};
  DateTime? _fetchedAt;
  DateTime? _softExpiry;
  DateTime? _lastAttempt;
  Future<bool>? _refreshInFlight;
  int _jwksFetchCount = 0;

  /// Number of JWKS network fetches attempted so far (useful in tests).
  int get jwksFetchCount => _jwksFetchCount;

  /// Verifies the raw value of the `X-Firebase-AppCheck` header.
  Future<AppCheckResult> verify(String? token) async {
    if (!_projectNumberPattern.hasMatch(projectNumber)) {
      return const AppCheckResult(AppCheckStatus.unavailable,
          reason: 'misconfigured_project_number');
    }

    final raw = token?.trim() ?? '';
    if (raw.isEmpty) return _invalid('missing_token');
    if (raw.length > maxTokenLength) return _invalid('token_too_large');

    final parts = raw.split('.');
    if (parts.length != 3 ||
        parts.any((p) => p.isEmpty || !_base64UrlPattern.hasMatch(p))) {
      return _invalid('malformed');
    }

    final header = _decodeObject(parts[0]);
    final payload = _decodeObject(parts[1]);
    final signature = _decodeBytes(parts[2]);
    if (header == null || payload == null || signature == null) {
      return _invalid('malformed');
    }

    // Header checks happen BEFORE any key is looked up or used.
    if (header['alg'] != 'RS256') return _invalid('alg_not_rs256');
    if (header['typ'] != 'JWT') return _invalid('typ_not_jwt');
    for (final param in _rejectedHeaderParams) {
      if (header.containsKey(param)) return _invalid('header_param_rejected');
    }
    final kid = header['kid'];
    if (kid is! String || kid.isEmpty || kid.length > 128) {
      return _invalid('kid_missing');
    }

    final lookup = await _keyForKid(kid);
    final key = lookup.key;
    if (key == null) {
      return AppCheckResult(lookup.status, reason: lookup.reason);
    }

    final signingInput =
        Uint8List.fromList(ascii.encode('${parts[0]}.${parts[1]}'));
    if (!_verifyRs256(key, signingInput, signature)) {
      return _invalid('bad_signature');
    }

    // Claims are trusted only after the signature is verified.
    final nowSec = _clock().millisecondsSinceEpoch ~/ 1000;
    if (payload['iss'] != 'https://firebaseappcheck.googleapis.com/$projectNumber') {
      return _invalid('iss_mismatch');
    }
    if (!_audienceMatches(payload['aud'])) return _invalid('aud_mismatch');
    final exp = payload['exp'];
    if (exp is! num || exp <= nowSec) return _invalid('expired');
    final sub = payload['sub'];
    if (sub is! String || sub.trim().isEmpty || sub.length > 256) {
      return _invalid('sub_missing');
    }
    if (allowedAppIds.isNotEmpty && !allowedAppIds.contains(sub)) {
      return _invalid('app_id_not_allowed');
    }

    return AppCheckResult(AppCheckStatus.valid, appId: sub);
  }

  AppCheckResult _invalid(String reason) =>
      AppCheckResult(AppCheckStatus.invalid, reason: reason);

  bool _audienceMatches(Object? aud) {
    final expected = 'projects/$projectNumber';
    if (aud is String) return aud == expected;
    if (aud is List) return aud.any((e) => e is String && e == expected);
    return false;
  }

  // ── Decoding helpers ────────────────────────────────────────────

  Map<String, dynamic>? _decodeObject(String segment) {
    try {
      final bytes = base64Url.decode(base64Url.normalize(segment));
      final value = jsonDecode(utf8.decode(bytes));
      if (value is! Map) return null;
      return Map<String, dynamic>.from(value);
    } catch (_) {
      return null;
    }
  }

  Uint8List? _decodeBytes(String segment) {
    try {
      return Uint8List.fromList(
          base64Url.decode(base64Url.normalize(segment)));
    } catch (_) {
      return null;
    }
  }

  // ── Signature ───────────────────────────────────────────────────

  static bool _verifyRs256(
      _RsaKey key, Uint8List message, Uint8List signature) {
    try {
      // RFC 8017: the signature must be exactly as long as the modulus.
      if (signature.length != key.modulusBytes) return false;
      final signer = pc.RSASigner(pc.SHA256Digest(), _sha256DigestIdHex);
      signer.init(
        false,
        pc.PublicKeyParameter<pc.RSAPublicKey>(
            pc.RSAPublicKey(key.modulus, key.exponent)),
      );
      return signer.verifySignature(message, pc.RSASignature(signature));
    } catch (_) {
      return false;
    }
  }

  // ── Key management (cache, rotation, single-flight) ─────────────

  bool _hasUsableKeys(DateTime now) {
    final fetchedAt = _fetchedAt;
    return fetchedAt != null &&
        _keys.isNotEmpty &&
        now.difference(fetchedAt) < maxKeyAge;
  }

  bool _isFresh(DateTime now) {
    final soft = _softExpiry;
    return _hasUsableKeys(now) && soft != null && now.isBefore(soft);
  }

  bool _mayAttemptRefresh(DateTime now, Duration minInterval) {
    // Joining a refresh that is already running costs nothing.
    if (_refreshInFlight != null) return true;
    final last = _lastAttempt;
    return last == null || now.difference(last) >= minInterval;
  }

  Future<_KeyLookup> _keyForKid(String kid) async {
    var now = _clock();
    final usable = _hasUsableKeys(now);
    final fresh = _isFresh(now);

    if (fresh) {
      final known = _keys[kid];
      if (known != null) return _KeyLookup.found(known);
    }

    // Either no usable keys, soft-expired keys, or an unknown kid with fresh
    // keys. Decide how soon another network attempt is allowed.
    final minInterval = !usable
        ? initialLoadRetryInterval
        : (fresh ? unknownKidRefreshInterval : softRefreshRetryInterval);

    bool? refreshed; // null: no attempt was made (throttled)
    if (_mayAttemptRefresh(now, minInterval)) {
      refreshed = await _refresh();
    }

    now = _clock();
    if (!_hasUsableKeys(now)) {
      return const _KeyLookup.failure(
          AppCheckStatus.unavailable, 'jwks_unavailable');
    }
    final key = _keys[kid];
    if (key != null) return _KeyLookup.found(key);
    if (refreshed == false) {
      // We could not refresh, so we cannot tell whether this kid is genuine.
      return const _KeyLookup.failure(
          AppCheckStatus.unavailable, 'jwks_unavailable');
    }
    return const _KeyLookup.failure(AppCheckStatus.invalid, 'unknown_kid');
  }

  Future<bool> _refresh() {
    final existing = _refreshInFlight;
    if (existing != null) return existing;
    final future = _fetchKeys().whenComplete(() {
      _refreshInFlight = null;
    });
    _refreshInFlight = future;
    return future;
  }

  /// Never throws. Returns true when a fresh, non-empty key set was stored.
  Future<bool> _fetchKeys() async {
    _lastAttempt = _clock();
    _jwksFetchCount++;
    try {
      final response = await _client.get(
        jwksUri,
        headers: const <String, String>{'Accept': 'application/json'},
      ).timeout(timeout);
      if (response.statusCode != 200) return false;
      if (response.bodyBytes.length > _maxJwksBytes) return false;

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map || decoded['keys'] is! List) return false;

      final keys = <String, _RsaKey>{};
      for (final item in decoded['keys'] as List) {
        final key = _parseJwk(item);
        if (key != null) keys[key.kid] = key;
      }
      if (keys.isEmpty) return false;

      final now = _clock();
      _keys = Map<String, _RsaKey>.unmodifiable(keys);
      _fetchedAt = now;
      _softExpiry = now.add(_ttlFrom(response.headers['cache-control']));
      return true;
    } catch (_) {
      return false;
    }
  }

  Duration _ttlFrom(String? cacheControl) {
    var ttl = maxKeyAge;
    if (cacheControl != null) {
      final match =
          RegExp(r'max-age=(\d+)').firstMatch(cacheControl.toLowerCase());
      final seconds = int.tryParse(match?.group(1) ?? '');
      if (seconds != null && seconds < 86400) {
        final fromServer = Duration(seconds: seconds);
        if (fromServer < ttl) ttl = fromServer;
      }
    }
    if (ttl < const Duration(minutes: 1)) ttl = const Duration(minutes: 1);
    return ttl;
  }

  _RsaKey? _parseJwk(Object? item) {
    if (item is! Map) return null;
    if (item['kty'] != 'RSA') return null;
    final kid = item['kid'];
    final n = item['n'];
    final e = item['e'];
    if (kid is! String || kid.isEmpty || kid.length > 128) return null;
    if (n is! String || e is! String) return null;
    final alg = item['alg'];
    if (alg != null && alg != 'RS256') return null;
    final use = item['use'];
    if (use != null && use != 'sig') return null;

    final nBytes = _decodeBytes(n);
    final eBytes = _decodeBytes(e);
    if (nBytes == null || eBytes == null) return null;
    if (nBytes.isEmpty || eBytes.isEmpty) return null;

    final modulus = _bigIntFromBytes(nBytes);
    final exponent = _bigIntFromBytes(eBytes);
    if (modulus.bitLength < minModulusBits) return null;
    if (exponent < BigInt.from(3) || !exponent.isOdd) return null;

    return _RsaKey(kid, modulus, exponent, (modulus.bitLength + 7) ~/ 8);
  }

  static BigInt _bigIntFromBytes(List<int> bytes) {
    var result = BigInt.zero;
    for (final b in bytes) {
      result = (result << 8) | BigInt.from(b);
    }
    return result;
  }
}

class _RsaKey {
  const _RsaKey(this.kid, this.modulus, this.exponent, this.modulusBytes);
  final String kid;
  final BigInt modulus;
  final BigInt exponent;
  final int modulusBytes;
}

class _KeyLookup {
  const _KeyLookup.found(_RsaKey this.key)
      : status = AppCheckStatus.valid,
        reason = null;
  const _KeyLookup.failure(this.status, this.reason) : key = null;

  final _RsaKey? key;
  final AppCheckStatus status;
  final String? reason;
}