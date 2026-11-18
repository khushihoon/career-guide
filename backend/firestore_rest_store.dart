// ══════════════════════════════════════════════════════════════════════
// backend/firestore_rest_store.dart
//
// PRIVILEGED Firestore adapter for the XP gateway (XpStore / XpTx).
//
// SECURITY LAYER 4 — Firestore IAM authorization. This file is the ONLY place
// that holds server credentials. It knows nothing about users, App Check or
// ApiSecurityGuard, and the gateway core knows nothing about credentials.
//
// DEPENDENCIES: package:http and package:pointycastle only (both already used
// by the Phase 2 backend). No googleapis / firebase_admin package.
//
// CREDENTIALS (fail closed: missing/invalid configuration => StateError, the
// server refuses to start)
//   Preferred (no key at all): XP_FIRESTORE_CREDENTIALS=metadata
//     -> the hosting platform's attached service account / workload identity
//        via the Google metadata server. Only works on Google-managed hosts.
//   Fallback: a service-account key held ONLY in the host's secret store:
//     GOOGLE_SERVICE_ACCOUNT_JSON       (raw JSON)   or
//     GOOGLE_SERVICE_ACCOUNT_JSON_B64   (base64 of the JSON)
//   The key's project_id must equal FIREBASE_PROJECT_ID.
//   The key, the private key and access tokens are never logged and never put
//   into exception messages.
//
// MINIMUM IAM for the service account: ONLY "Cloud Datastore User"
//   (roles/datastore.user). No Owner/Editor, no Firebase Admin, no Storage,
//   no Auth admin. OAuth scope requested: .../auth/datastore.
//
// TRANSACTION SEMANTICS
//   • beginTransaction -> reads (GET ?transaction=) -> commit(writes).
//   • Reads after the first staged write throw StateError.
//   • `create` => Write.currentDocument.exists=false (atomic create-if-absent).
//   • increment / arrayUnion => server-side field transforms (atomic).
//   • On ABORTED / ALREADY_EXISTS / FAILED_PRECONDITION / 429 / 5xx the WHOLE
//     body is re-run in a new transaction (reads happen again), so a retry
//     sees the row a concurrent request created and awards nothing twice.
// ══════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart' as pc;

import 'xp_gateway_core.dart';

// ═══════════════════════════════════════════════════════════════════
// Errors
// ═══════════════════════════════════════════════════════════════════

class XpStoreException implements Exception {
  const XpStoreException(this.code, {this.httpStatus, this.retryable = false});
  final String code;
  final int? httpStatus;
  final bool retryable;
  @override
  String toString() => 'XpStoreException($code, http=$httpStatus)';
}

// ═══════════════════════════════════════════════════════════════════
// Access tokens
// ═══════════════════════════════════════════════════════════════════

abstract class AccessTokenProvider {
  Future<String> accessToken();

  /// Drop any cached token (called after a 401).
  void invalidate();
}

/// Tokens from the Google metadata server (attached service account /
/// workload identity on Google-managed runtimes). Holds no secret.
class MetadataServerTokenProvider implements AccessTokenProvider {
  MetadataServerTokenProvider({http.Client? client, DateTime Function()? clock})
      : _client = client ?? http.Client(),
        _clock = clock ?? DateTime.now;

  final http.Client _client;
  final DateTime Function() _clock;
  _Cached? _cached;
  Future<String>? _inFlight;

  static final Uri _uri = Uri.parse(
      'http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token');

  @override
  void invalidate() => _cached = null;

  @override
  Future<String> accessToken() {
    final c = _cached;
    if (c != null && c.expiresAt.isAfter(_clock().add(const Duration(seconds: 60)))) {
      return Future<String>.value(c.token);
    }
    return _inFlight ??= _refresh().whenComplete(() => _inFlight = null);
  }

  Future<String> _refresh() async {
    final http.Response r;
    try {
      r = await _client.get(_uri, headers: const {'Metadata-Flavor': 'Google'}).timeout(const Duration(seconds: 5));
    } catch (_) {
      throw const XpStoreException('auth_unavailable', retryable: true);
    }
    return _parseTokenResponse(r, _clock, (c) => _cached = c);
  }
}

/// OAuth2 JWT-bearer flow with a service-account key (RS256 via pointycastle).
class ServiceAccountTokenProvider implements AccessTokenProvider {
  ServiceAccountTokenProvider._(this._email, this._key, this._tokenUri,
      this._client, this._clock);

  factory ServiceAccountTokenProvider.fromJson(
    Map<String, dynamic> json, {
    http.Client? client,
    DateTime Function()? clock,
  }) {
    final email = json['client_email'];
    final pem = json['private_key'];
    if (json['type'] != 'service_account' ||
        email is! String ||
        email.isEmpty ||
        pem is! String ||
        !pem.contains('BEGIN PRIVATE KEY')) {
      throw StateError('The service-account credential is not valid.');
    }
    final tokenUriRaw = (json['token_uri'] as String?) ?? 'https://oauth2.googleapis.com/token';
    final tokenUri = Uri.tryParse(tokenUriRaw);
    if (tokenUri == null ||
        tokenUri.scheme != 'https' ||
        !(tokenUri.host == 'oauth2.googleapis.com' || tokenUri.host.endsWith('.googleapis.com'))) {
      throw StateError('The service-account token endpoint is not trusted.');
    }
    return ServiceAccountTokenProvider._(
      email,
      parsePkcs8RsaPrivateKey(pem),
      tokenUri,
      client ?? http.Client(),
      clock ?? DateTime.now,
    );
  }

  final String _email;
  final pc.RSAPrivateKey _key;
  final Uri _tokenUri;
  final http.Client _client;
  final DateTime Function() _clock;
  _Cached? _cached;
  Future<String>? _inFlight;

  static const String scope = 'https://www.googleapis.com/auth/datastore';

  @override
  void invalidate() => _cached = null;

  @override
  Future<String> accessToken() {
    final c = _cached;
    if (c != null && c.expiresAt.isAfter(_clock().add(const Duration(seconds: 60)))) {
      return Future<String>.value(c.token);
    }
    return _inFlight ??= _refresh().whenComplete(() => _inFlight = null);
  }

  Future<String> _refresh() async {
    final nowSec = _clock().toUtc().millisecondsSinceEpoch ~/ 1000;
    final header = _b64Json({'alg': 'RS256', 'typ': 'JWT'});
    final claims = _b64Json({
      'iss': _email,
      'scope': scope,
      'aud': _tokenUri.toString(),
      'iat': nowSec,
      'exp': nowSec + 3600,
    });
    final signingInput = '$header.$claims';
    final signer = pc.RSASigner(pc.SHA256Digest(), '0609608648016503040201')
      ..init(true, pc.PrivateKeyParameter<pc.RSAPrivateKey>(_key));
    final sig = signer.generateSignature(Uint8List.fromList(utf8.encode(signingInput)));
    final assertion = '$signingInput.${_b64(sig.bytes)}';

    final http.Response r;
    try {
      r = await _client.post(
        _tokenUri,
        headers: const {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
          'assertion': assertion,
        },
      ).timeout(const Duration(seconds: 8));
    } catch (_) {
      throw const XpStoreException('auth_unavailable', retryable: true);
    }
    return _parseTokenResponse(r, _clock, (c) => _cached = c);
  }

  static String _b64(List<int> bytes) =>
      base64Url.encode(bytes).replaceAll('=', '');
  static String _b64Json(Map<String, dynamic> m) =>
      _b64(utf8.encode(jsonEncode(m)));
}

class _Cached {
  const _Cached(this.token, this.expiresAt);
  final String token;
  final DateTime expiresAt;
}

String _parseTokenResponse(
    http.Response r, DateTime Function() clock, void Function(_Cached) store) {
  if (r.statusCode != 200) {
    throw XpStoreException('auth_failed',
        httpStatus: r.statusCode, retryable: r.statusCode >= 500);
  }
  try {
    final m = jsonDecode(r.body) as Map;
    final token = m['access_token'];
    final ttl = (m['expires_in'] as num?)?.toInt() ?? 300;
    if (token is! String || token.isEmpty) {
      throw const FormatException('no token');
    }
    store(_Cached(token, clock().add(Duration(seconds: ttl))));
    return token;
  } catch (_) {
    throw const XpStoreException('auth_failed');
  }
}

/// PKCS#8 PEM ("BEGIN PRIVATE KEY") -> RSA private key.
pc.RSAPrivateKey parsePkcs8RsaPrivateKey(String pem) {
  try {
    final b64 = pem
        .replaceAll(RegExp(r'-----[A-Z ]+-----'), '')
        .replaceAll(RegExp(r'\s+'), '');
    final der = Uint8List.fromList(base64.decode(b64));
    final top = ASN1Parser(der).nextObject() as ASN1Sequence;
    final octet = top.elements![2];
    final inner = ASN1Parser(octet.valueBytes!).nextObject() as ASN1Sequence;
    BigInt big(int i) => (inner.elements![i] as ASN1Integer).integer!;
    // RSAPrivateKey ::= SEQUENCE { version, n, e, d, p, q, ... }
    return pc.RSAPrivateKey(big(1), big(3), big(4), big(5));
  } catch (_) {
    throw StateError('The service-account private key could not be parsed.');
  }
}

// ═══════════════════════════════════════════════════════════════════
// Value encoding (Dart <-> Firestore REST)
// ═══════════════════════════════════════════════════════════════════

Map<String, dynamic> encodeValue(dynamic v) {
  if (v == null) return {'nullValue': null};
  if (v is bool) return {'booleanValue': v};
  if (v is int) return {'integerValue': v.toString()};
  if (v is double) {
    if (v.isNaN || v.isInfinite) throw ArgumentError('non-finite number');
    return {'doubleValue': v};
  }
  if (v is String) return {'stringValue': v};
  if (v is List) return {'arrayValue': {'values': v.map(encodeValue).toList()}};
  if (v is Map) {
    return {'mapValue': {'fields': encodeFields(Map<String, dynamic>.from(v))}};
  }
  throw ArgumentError('unsupported value type ${v.runtimeType}');
}

Map<String, dynamic> encodeFields(Map<String, dynamic> m) =>
    m.map((k, v) => MapEntry(k, encodeValue(v)));

dynamic decodeValue(Map v) {
  if (v.containsKey('nullValue')) return null;
  if (v.containsKey('booleanValue')) return v['booleanValue'] as bool;
  if (v.containsKey('integerValue')) return int.parse(v['integerValue'] as String);
  if (v.containsKey('doubleValue')) return (v['doubleValue'] as num).toDouble();
  if (v.containsKey('stringValue')) return v['stringValue'] as String;
  if (v.containsKey('timestampValue')) return v['timestampValue'] as String;
  if (v.containsKey('mapValue')) {
    return decodeFields(((v['mapValue'] as Map)['fields'] as Map?) ?? const {});
  }
  if (v.containsKey('arrayValue')) {
    final values = ((v['arrayValue'] as Map)['values'] as List?) ?? const [];
    return values.map((e) => decodeValue(e as Map)).toList();
  }
  return null; // reference / bytes / geo values are not used by the gateway
}

Map<String, dynamic> decodeFields(Map f) =>
    f.map((k, v) => MapEntry(k as String, decodeValue(v as Map)));

String _fieldPath(String key) => RegExp(r'^[A-Za-z_][A-Za-z0-9_]*$').hasMatch(key)
    ? key
    : '`${key.replaceAll(r'\', r'\\').replaceAll('`', r'\`')}`';

// ═══════════════════════════════════════════════════════════════════
// Store
// ═══════════════════════════════════════════════════════════════════

class FirestoreRestStore implements XpStore {
  FirestoreRestStore({
    required this.projectId,
    required this.tokens,
    http.Client? client,
    this.timeout = const Duration(seconds: 8),
    this.maxAttempts = 10,
    Duration Function(int attempt)? backoff,
    this.host = 'firestore.googleapis.com',
  })  : _client = client ?? http.Client(),
        _backoff = backoff ?? ((a) => Duration(milliseconds: 80 * a * a)) {
    if (maxAttempts < 1 || maxAttempts > 20) {
      throw ArgumentError.value(
        maxAttempts,
        'maxAttempts',
        'Must be between 1 and 20.',
      );
    }
    if (projectId.trim().isEmpty) {
      throw ArgumentError.value(projectId, 'projectId', 'Must not be empty.');
    }
    if (host.trim().isEmpty || host.contains('/') || host.contains('@')) {
      throw ArgumentError.value(host, 'host', 'Must be a hostname.');
    }
  }

  final String projectId;
  final AccessTokenProvider tokens;
  final Duration timeout;
  final int maxAttempts;
  final String host;
  final http.Client _client;
  final Duration Function(int) _backoff;

  /// Builds the store from the environment. Throws [StateError] (fail closed)
  /// when anything is missing or inconsistent.
  static FirestoreRestStore fromEnvironment(Map<String, String> env,
      {http.Client? client}) {
    String read(String k) => (env[k] ?? '').trim();
    final projectId = read('FIREBASE_PROJECT_ID');
    if (projectId.isEmpty) {
      throw StateError('FIREBASE_PROJECT_ID is required for the XP gateway.');
    }
    final mode = read('XP_FIRESTORE_CREDENTIALS').toLowerCase();
    if (mode == 'metadata') {
      return FirestoreRestStore(
          projectId: projectId,
          tokens: MetadataServerTokenProvider(client: client),
          client: client);
    }
    var raw = read('GOOGLE_SERVICE_ACCOUNT_JSON');
    final b64 = read('GOOGLE_SERVICE_ACCOUNT_JSON_B64');
    if (raw.isEmpty && b64.isNotEmpty) {
      try {
        raw = utf8.decode(base64.decode(b64));
      } catch (_) {
        throw StateError('GOOGLE_SERVICE_ACCOUNT_JSON_B64 is not valid base64.');
      }
    }
    if (raw.isEmpty) {
      throw StateError('No Firestore credentials configured. Set '
          'XP_FIRESTORE_CREDENTIALS=metadata or provide a service-account '
          'secret (GOOGLE_SERVICE_ACCOUNT_JSON[_B64]).');
    }
    final Map<String, dynamic> json;
    try {
      json = Map<String, dynamic>.from(jsonDecode(raw) as Map);
    } catch (_) {
      throw StateError('The service-account credential is not valid JSON.');
    }
    if (json['project_id'] != projectId) {
      throw StateError('The service-account project does not match '
          'FIREBASE_PROJECT_ID.');
    }
    return FirestoreRestStore(
      projectId: projectId,
      tokens: ServiceAccountTokenProvider.fromJson(json, client: client),
      client: client,
    );
  }

  String get _docsRoot => 'projects/$projectId/databases/(default)/documents';

  @override
  Future<T> runTransaction<T>(Future<T> Function(XpTx tx) body) async {
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      final txId = await _begin();
      final tx = _RestTx(this, txId);
      try {
        final result = await body(tx);
        if (tx._pending.isEmpty) {
          await _rollbackQuiet(txId); // read-only: release the transaction
          return result;
        }
        await _commit(tx);
        return result;
      } on XpStoreException catch (e) {
        await _rollbackQuiet(txId);
        if (e.retryable && attempt < maxAttempts) {
          await Future<void>.delayed(_backoff(attempt));
          continue;
        }
        rethrow;
      } catch (_) {
        await _rollbackQuiet(txId); // GatewayRejection, StateError, ...
        rethrow;
      }
    }
    throw const XpStoreException('contention', retryable: true);
  }

  // ── REST calls ──────────────────────────────────────────────────

  Future<String> _begin() async {
    final body = <String, dynamic>{
      'options': {'readWrite': <String, dynamic>{}},
    };
    final r = await _send('POST', _uri(':beginTransaction'), body);
    final m = _decodeObject(r);
    final id = m['transaction'];
    if (id is! String || id.isEmpty) {
      throw const XpStoreException('bad_response');
    }
    return id;
  }

  Future<Json?> _read(String path, String txId) async {
    final uri = _uri('/${_encodePath(path)}', {'transaction': txId});
    try {
      final r = await _send('GET', uri, null);
      final m = _decodeObject(r);
      final fields = m['fields'];
      return fields is Map ? decodeFields(fields) : <String, dynamic>{};
    } on XpStoreException catch (e) {
      if (e.httpStatus == 404) return null;
      rethrow;
    }
  }

  Future<void> _commit(_RestTx tx) async {
    final writes = tx._pending.entries
        .map((e) => e.value.toWrite('$_docsRoot/${e.key}'))
        .toList();
    await _send('POST', _uri(':commit'),
        <String, dynamic>{'writes': writes, 'transaction': tx.id});
  }

  Future<void> _rollbackQuiet(String txId) async {
    try {
      await _send('POST', _uri(':rollback'), {'transaction': txId});
    } catch (_) {/* best effort */}
  }

  /// Builds a Firestore REST URI without re-encoding already escaped path
  /// segments. Uri.https() escapes percent signs in its path argument again,
  /// corrupting literal percent-containing document IDs.
  Uri _uri(String suffix, [Map<String, String>? query]) {
    final raw = Uri.parse('https://$host/v1/$_docsRoot$suffix');
    return query == null || query.isEmpty
        ? raw
        : raw.replace(queryParameters: query);
  }

  /// Encodes each resource-path segment independently. Slashes between
  /// segments remain separators; slashes inside a document ID are escaped.
  static String _encodePath(String path) =>
      path.split('/').map(Uri.encodeComponent).join('/');

  Future<http.Response> _send(String method, Uri uri, Object? body,
      {bool retried401 = false}) async {
    final token = await tokens.accessToken();
    final req = http.Request(method, uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Content-Type'] = 'application/json';
    if (body != null) req.body = jsonEncode(body);

    final http.Response r;
    try {
      r = await http.Response.fromStream(
          await _client.send(req).timeout(timeout));
    } on TimeoutException {
      throw const XpStoreException('timeout', retryable: true);
    } catch (_) {
      throw const XpStoreException('network', retryable: true);
    }

    if (r.statusCode >= 200 && r.statusCode < 300) return r;
    if (r.statusCode == 401 && !retried401) {
      tokens.invalidate();
      return _send(method, uri, body, retried401: true);
    }
    final status = _errorStatus(r);
    final retryable = r.statusCode == 429 ||
        r.statusCode >= 500 ||
        r.statusCode == 409 ||
        status == 'ABORTED' ||
        status == 'ALREADY_EXISTS' ||
        status == 'FAILED_PRECONDITION';
    // Error BODIES are never copied into exceptions (they can echo data).
    throw XpStoreException(status ?? 'http_${r.statusCode}',
        httpStatus: r.statusCode, retryable: retryable && r.statusCode != 404);
  }

  static String? _errorStatus(http.Response r) {
    try {
      final m = jsonDecode(r.body);
      final s = (m is Map && m['error'] is Map) ? (m['error'] as Map)['status'] : null;
      return s is String ? s : null;
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic> _decodeObject(http.Response r) {
    try {
      return Map<String, dynamic>.from(jsonDecode(r.body) as Map);
    } catch (_) {
      throw const XpStoreException('bad_response');
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// Transaction
// ═══════════════════════════════════════════════════════════════════

class _PendingDoc {
  bool create = false;
  final Json fields = <String, dynamic>{};
  final Map<String, num> increments = <String, num>{};
  final Map<String, List<String>> unions = <String, List<String>>{};

  Map<String, dynamic> toWrite(String name) {
    for (final k in [...increments.keys, ...unions.keys]) {
      if (fields.containsKey(k)) {
        throw StateError('field "$k" is both set and transformed');
      }
    }
    final write = <String, dynamic>{
      'update': {'name': name, 'fields': encodeFields(fields)},
    };
    if (create) {
      write['currentDocument'] = {'exists': false};
    } else {
      write['updateMask'] = {'fieldPaths': fields.keys.map(_fieldPath).toList()};
    }
    final transforms = <Map<String, dynamic>>[
      for (final e in increments.entries)
        {
          'fieldPath': _fieldPath(e.key),
          'increment': e.value is int
              ? {'integerValue': e.value.toString()}
              : {'doubleValue': e.value.toDouble()},
        },
      for (final e in unions.entries)
        {
          'fieldPath': _fieldPath(e.key),
          'appendMissingElements': {
            'values': e.value.map((v) => {'stringValue': v}).toList(),
          },
        },
    ];
    if (transforms.isNotEmpty) write['updateTransforms'] = transforms;
    return write;
  }
}

class _RestTx implements XpTx {
  _RestTx(this._store, this.id);
  final FirestoreRestStore _store;
  final String id;
  final Map<String, _PendingDoc> _pending = <String, _PendingDoc>{};

  _PendingDoc _doc(String path) => _pending.putIfAbsent(path, _PendingDoc.new);

  @override
  Future<Json?> get(String path) {
    if (_pending.isNotEmpty) {
      throw StateError('Reads must happen before the first write.');
    }
    return _store._read(path, id);
  }

  @override
  void create(String path, Json data) {
    final d = _doc(path);
    d.create = true;
    d.fields.addAll(data);
  }

  @override
  void merge(String path, Json data) => _doc(path).fields.addAll(data);

  @override
  void increment(String path, Map<String, num> deltas) {
    final d = _doc(path);
    deltas.forEach((k, v) => d.increments[k] = (d.increments[k] ?? 0) + v);
  }

  @override
  void arrayUnion(String path, String field, List<String> values) {
    final list = _doc(path).unions.putIfAbsent(field, () => <String>[]);
    for (final v in values) {
      if (!list.contains(v)) list.add(v);
    }
  }
}