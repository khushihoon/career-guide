// backend/api_security_guard.dart
//
// Shared security layer for BOTH Dart backends
// (backend/course_generator_api.dart and
//  backend/company_intelligence_ingestion_server.dart).
//
// Pure Dart (no dart:io): every input is a plain value (header strings, an IP
// string, an environment map), so everything here can be unit-tested without
// opening sockets.
//
// WHAT IS IN THIS FILE
//   * SecurityConfig        – reads and VALIDATES the security environment.
//                             It fails closed: a bad production configuration
//                             throws SecurityConfigException and the server
//                             refuses to start.
//   * ApiSecurityGuard      – per request: per-IP limit -> Firebase Auth
//                             (reusing FirebaseTokenVerifier) -> App Check
//                             (FirebaseAppCheckVerifier) -> per-user limit.
//                             Returns 401 / 429 / 503 decisions. There is NO
//                             duplicate authentication logic here.
//   * AiUsageController     – per-user DAILY quotas, a GLOBAL daily cap, a
//                             global in-flight cap and a per-user in-flight cap
//                             for paid AI calls (OpenAI / Claude).
//   * BoundedRateLimiter, ConcurrencyGate, BoundedTtlCache, SingleFlight
//                             – small bounded building blocks (no unbounded
//                             maps anywhere).
//   * resolveClientIp       – X-Forwarded-For handling for a trusted proxy.
//
// ENVIRONMENT MODEL (CAREER_GUIDE_ENV is REQUIRED)
//   production   Firebase Auth AND App Check are ALWAYS enforced. No
//                environment variable can relax this. If APP_CHECK_MODE is
//                "monitor", or a *_AUTH_REQUIRED variable is set to a false
//                value, the server REFUSES TO START (loud, never silent).
//   staging      Auth enforced. APP_CHECK_MODE=monitor is allowed only for a
//                time-limited migration: APP_CHECK_MONITOR_UNTIL (ISO-8601,
//                at most 30 days in the future when the server starts) is
//                mandatory. After that moment App Check is enforced
//                automatically.
//   development  Auth optional (COURSE_AUTH_REQUIRED /
//                CAREER_GUIDE_REQUIRE_AUTH=true turns it on). App Check
//                defaults to monitor. Binding a non-loopback address is only
//                allowed when authentication is required.
//   anything else (including unset) -> the server refuses to start.
//
// ORDER OF CHECKS
//   Firebase Auth is verified first, then App Check (as required by the
//   Phase 2 specification). A cheap bounded per-IP limit runs before both so
//   unauthenticated floods cannot burn Firebase lookup quota.
//
// LIMITATIONS (be honest about them)
//   * Counters live in this process's memory. They reset when the instance
//     restarts and are NOT shared between instances. Run a single instance, or
//     add an edge/gateway limiter, and set hard monthly spend limits in the
//     OpenAI/Anthropic dashboards. In-memory limiting is burst protection, not
//     distributed, billing-grade protection.
//   * Per-user quotas can be bypassed by creating many accounts; that is what
//     the GLOBAL daily cap and the provider-side spend limits are for.

import 'dart:collection';

import 'firebase_app_check_verifier.dart';
import 'firebase_token_verifier.dart';

// ═══════════════════════════════════════════════════════════════════
// Messages (stable strings returned to callers)
// ═══════════════════════════════════════════════════════════════════

const String rateLimitMessage = 'Too many requests. Please try again shortly.';
const String _msgAuth = 'A valid Firebase ID token is required.';
const String _msgAppCheck = 'A valid App Check token is required.';
const String _msgAuthUnavailable =
    'Authentication service is temporarily unavailable. Please try again shortly.';
const String _msgAppCheckUnavailable =
    'App Check verification is temporarily unavailable. Please try again shortly.';

// ═══════════════════════════════════════════════════════════════════
// Configuration
// ═══════════════════════════════════════════════════════════════════

enum SecurityEnvironment { development, staging, production }

enum AppCheckMode { enforce, monitor }

class SecurityConfigException implements Exception {
  const SecurityConfigException(this.message);
  final String message;
  @override
  String toString() => 'SecurityConfigException: $message';
}

bool isLoopbackAddress(String value) {
  final v = value.trim().toLowerCase();
  return v == 'localhost' || v == '::1' || v == '[::1]' || v.startsWith('127.');
}

String _read(Map<String, String> env, String key) => (env[key] ?? '').trim();

bool _truthy(String value) {
  final v = value.trim().toLowerCase();
  return v == 'true' || v == '1' || v == 'yes';
}

int _intEnv(
  Map<String, String> env,
  String key,
  int fallback,
  int min,
  int max,
) {
  final parsed = int.tryParse(_read(env, key));
  if (parsed == null) return fallback;
  return parsed.clamp(min, max).toInt();
}

class SecurityConfig {
  const SecurityConfig({
    required this.environment,
    required this.authRequired,
    required this.appCheckMode,
    this.appCheckMonitorUntil,
    this.firebaseWebApiKey = '',
    this.firebaseProjectId = '',
    this.firebaseProjectNumber = '',
    this.appCheckAllowedAppIds = const <String>{},
    this.trustProxy = false,
    this.trustedProxyHops = 1,
    this.bindAddress = '127.0.0.1',
    this.preAuthIpPerMinute = 120,
    this.healthIpPerMinute = 300,
    this.maxTrackedKeys = 50000,
    this.claudeDailyPerUser = 100,
    this.courseAiDailyPerUser = 30,
    this.globalAiDailyLimit = 2000,
    this.aiMaxInFlight = 4,
    this.aiPerUserInFlight = 1,
  });

  final SecurityEnvironment environment;

  /// True when every protected route requires a valid Firebase ID token.
  final bool authRequired;

  final AppCheckMode appCheckMode;

  /// Only meaningful in monitor mode: from this moment App Check is enforced.
  final DateTime? appCheckMonitorUntil;

  final String firebaseWebApiKey;
  final String firebaseProjectId;
  final String firebaseProjectNumber;
  final Set<String> appCheckAllowedAppIds;

  final bool trustProxy;
  final int trustedProxyHops;
  final String bindAddress;

  final int preAuthIpPerMinute;
  final int healthIpPerMinute;
  final int maxTrackedKeys;

  final int claudeDailyPerUser;
  final int courseAiDailyPerUser;
  final int globalAiDailyLimit;
  final int aiMaxInFlight;
  final int aiPerUserInFlight;

  bool get isProduction => environment == SecurityEnvironment.production;

  /// Staging and production are "strict": explicit origins, no relaxations.
  bool get isStrict => environment != SecurityEnvironment.development;

  /// Whether a request at [now] must be REJECTED when App Check fails.
  bool appCheckEnforcedAt(DateTime now) {
    if (appCheckMode == AppCheckMode.enforce) return true;
    final until = appCheckMonitorUntil;
    return until != null && !now.toUtc().isBefore(until);
  }

  /// Non-secret one-line description for the startup log.
  String summary() =>
      'env=${environment.name}; auth=${authRequired ? 'required' : 'optional'}; '
      'appCheck=${appCheckMode.name}'
      '${appCheckMonitorUntil == null ? '' : ' (monitor until ${appCheckMonitorUntil!.toIso8601String()})'}';

  /// Reads and validates the environment. Throws [SecurityConfigException]
  /// when the configuration is unsafe or incomplete.
  factory SecurityConfig.fromEnvironment(
    Map<String, String> env, {
    DateTime Function()? clock,
  }) {
    final now = (clock ?? DateTime.now)().toUtc();

    // ── Environment class ──
    final envName = _read(env, 'CAREER_GUIDE_ENV').toLowerCase();
    final SecurityEnvironment environment;
    if (envName == 'production') {
      environment = SecurityEnvironment.production;
    } else if (envName == 'staging') {
      environment = SecurityEnvironment.staging;
    } else if (envName == 'development') {
      environment = SecurityEnvironment.development;
    } else {
      throw const SecurityConfigException(
          'CAREER_GUIDE_ENV must be set to "production", "staging" or '
          '"development".');
    }
    final strict = environment != SecurityEnvironment.development;

    // ── Authentication ──
    final authFlags = <String>[
      _read(env, 'COURSE_AUTH_REQUIRED'),
      _read(env, 'CAREER_GUIDE_REQUIRE_AUTH'),
    ];
    if (strict) {
      for (final flag in authFlags) {
        if (flag.isNotEmpty && !_truthy(flag)) {
          throw SecurityConfigException(
              'Authentication cannot be disabled when CAREER_GUIDE_ENV='
              '${environment.name}. Remove the *_AUTH_REQUIRED override.');
        }
      }
    }
    final authRequired = strict || authFlags.any(_truthy);

    // ── App Check mode ──
    final modeRaw = _read(env, 'APP_CHECK_MODE').toLowerCase();
    final AppCheckMode mode;
    if (modeRaw.isEmpty) {
      mode = strict ? AppCheckMode.enforce : AppCheckMode.monitor;
    } else if (modeRaw == 'enforce') {
      mode = AppCheckMode.enforce;
    } else if (modeRaw == 'monitor') {
      mode = AppCheckMode.monitor;
    } else {
      throw const SecurityConfigException(
          'APP_CHECK_MODE must be "enforce" or "monitor".');
    }
    if (mode == AppCheckMode.monitor &&
        environment == SecurityEnvironment.production) {
      throw const SecurityConfigException(
          'APP_CHECK_MODE=monitor is not allowed when '
          'CAREER_GUIDE_ENV=production. Production always enforces App Check.');
    }

    DateTime? monitorUntil;
    final untilRaw = _read(env, 'APP_CHECK_MONITOR_UNTIL');
    if (mode == AppCheckMode.monitor) {
      if (environment == SecurityEnvironment.staging && untilRaw.isEmpty) {
        throw const SecurityConfigException(
            'Staging monitor mode requires APP_CHECK_MONITOR_UNTIL (ISO-8601 '
            'date, at most 30 days ahead).');
      }
      if (untilRaw.isNotEmpty) {
        final parsed = DateTime.tryParse(untilRaw);
        if (parsed == null) {
          throw const SecurityConfigException(
              'APP_CHECK_MONITOR_UNTIL is not a valid ISO-8601 date.');
        }
        final until = parsed.toUtc();
        if (until.isAfter(now.add(const Duration(days: 30)))) {
          throw const SecurityConfigException(
              'APP_CHECK_MONITOR_UNTIL must be within 30 days of server '
              'start. Monitor mode is only for a short migration window.');
        }
        // A date in the past is accepted on purpose: App Check is then
        // enforced immediately (appCheckEnforcedAt).
        monitorUntil = until;
      }
    }

    // ── Firebase project values ──
    final apiKey = _read(env, 'FIREBASE_WEB_API_KEY');
    final projectId = _read(env, 'FIREBASE_PROJECT_ID');
    final projectNumber = _read(env, 'FIREBASE_PROJECT_NUMBER');
    final allowedAppIds = _read(env, 'APP_CHECK_ALLOWED_APP_IDS')
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet();

    if (projectNumber.isNotEmpty &&
        !RegExp(r'^\d{1,20}$').hasMatch(projectNumber)) {
      throw const SecurityConfigException(
          'FIREBASE_PROJECT_NUMBER must be the numeric Firebase project '
          'NUMBER (not the project ID).');
    }
    if (authRequired && (apiKey.isEmpty || projectId.isEmpty)) {
      throw const SecurityConfigException(
          'FIREBASE_WEB_API_KEY and FIREBASE_PROJECT_ID are required when '
          'authentication is enforced.');
    }
    if (strict) {
      if (projectNumber.isEmpty) {
        throw const SecurityConfigException(
            'FIREBASE_PROJECT_NUMBER is required for App Check verification.');
      }
      if (allowedAppIds.isEmpty) {
        throw const SecurityConfigException(
            'APP_CHECK_ALLOWED_APP_IDS (comma-separated Firebase App IDs) is '
            'required in production and staging.');
      }
    } else if (mode == AppCheckMode.enforce && projectNumber.isEmpty) {
      throw const SecurityConfigException(
          'APP_CHECK_MODE=enforce requires FIREBASE_PROJECT_NUMBER.');
    }

    // ── Network binding ──
    final bindRaw = _read(env, 'CAREER_GUIDE_BIND_ADDRESS');
    final bindAddress =
        bindRaw.isNotEmpty ? bindRaw : (strict ? '0.0.0.0' : '127.0.0.1');
    if (!isLoopbackAddress(bindAddress) && !authRequired) {
      throw const SecurityConfigException(
          'Binding a non-loopback address requires authentication. Set '
          'COURSE_AUTH_REQUIRED=true or bind 127.0.0.1.');
    }

    return SecurityConfig(
      environment: environment,
      authRequired: authRequired,
      appCheckMode: mode,
      appCheckMonitorUntil: monitorUntil,
      firebaseWebApiKey: apiKey,
      firebaseProjectId: projectId,
      firebaseProjectNumber: projectNumber,
      appCheckAllowedAppIds: Set<String>.unmodifiable(allowedAppIds),
      trustProxy: _truthy(_read(env, 'TRUST_PROXY')),
      trustedProxyHops: _intEnv(env, 'TRUSTED_PROXY_HOPS', 1, 1, 5),
      bindAddress: bindAddress,
      preAuthIpPerMinute:
          _intEnv(env, 'API_PRE_AUTH_IP_PER_MINUTE', 120, 1, 10000),
      healthIpPerMinute:
          _intEnv(env, 'API_HEALTH_IP_PER_MINUTE', 300, 1, 100000),
      maxTrackedKeys: _intEnv(env, 'API_MAX_TRACKED_KEYS', 50000, 100, 500000),
      claudeDailyPerUser: _intEnv(env, 'CLAUDE_DAILY_LIMIT', 100, 1, 10000),
      courseAiDailyPerUser: _intEnv(env, 'COURSE_AI_DAILY_LIMIT', 30, 1, 10000),
      globalAiDailyLimit:
          _intEnv(env, 'AI_GLOBAL_DAILY_LIMIT', 2000, 1, 1000000),
      aiMaxInFlight: _intEnv(env, 'AI_MAX_IN_FLIGHT', 4, 1, 64),
      aiPerUserInFlight: _intEnv(env, 'AI_USER_MAX_IN_FLIGHT', 1, 1, 8),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Client IP
// ═══════════════════════════════════════════════════════════════════

/// Best-effort real client address.
///
/// Without a trusted proxy the socket address is used and X-Forwarded-For is
/// IGNORED (a caller could forge it). Behind [hops] trusted reverse proxies
/// the entry appended by the OUTERMOST trusted proxy is the
/// [hops]-th from the end; entries to its left are caller-controlled.
/// Confirm the hop count for your hosting provider.
String resolveClientIp({
  required String remoteAddress,
  String? forwardedFor,
  required bool trustProxy,
  int hops = 1,
}) {
  if (trustProxy && forwardedFor != null && forwardedFor.trim().isNotEmpty) {
    final parts = forwardedFor
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isNotEmpty) {
      var index = parts.length - hops;
      if (index < 0) index = 0;
      final candidate = parts[index];
      if (candidate.length <= 64) return candidate;
    }
  }
  return remoteAddress.isEmpty ? 'unknown' : remoteAddress;
}

// ═══════════════════════════════════════════════════════════════════
// Bounded rate limiter (fixed window, LRU eviction)
// ═══════════════════════════════════════════════════════════════════

class RateDecision {
  const RateDecision(this.allowed, this.retryAfterSeconds);
  final bool allowed;
  final int retryAfterSeconds;
}

class _Window {
  _Window(this.start);
  final DateTime start;
  int count = 0;
}

/// Fixed-window counter per key. Memory is bounded by [maxKeys]: when the map
/// is full, expired windows are swept (at most every 10 s) and then the least
/// recently used keys are evicted.
class BoundedRateLimiter {
  BoundedRateLimiter({
    this.maxKeys = 50000,
    this.window = const Duration(minutes: 1),
  });

  final int maxKeys;
  final Duration window;

  final LinkedHashMap<String, _Window> _windows =
      LinkedHashMap<String, _Window>();
  DateTime? _lastSweep;

  int get trackedKeys => _windows.length;

  RateDecision check(String key, int limit, DateTime now) {
    var w = _windows.remove(key); // re-inserted below => most recently used
    if (w == null || now.difference(w.start) >= window) {
      w = _Window(now);
    }
    final allowed = w.count < limit;
    if (allowed) w.count++;
    _windows[key] = w;
    _evictIfNeeded(now);

    if (allowed) return const RateDecision(true, 0);
    var retry = window.inSeconds - now.difference(w.start).inSeconds;
    if (retry < 1) retry = 1;
    return RateDecision(false, retry);
  }

  void _evictIfNeeded(DateTime now) {
    if (_windows.length <= maxKeys) return;
    final lastSweep = _lastSweep;
    if (lastSweep == null ||
        now.difference(lastSweep) >= const Duration(seconds: 10)) {
      _lastSweep = now;
      _windows.removeWhere((_, w) => now.difference(w.start) >= window);
    }
    while (_windows.length > maxKeys) {
      _windows.remove(_windows.keys.first);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// Concurrency gate
// ═══════════════════════════════════════════════════════════════════

enum GateDenial { global, perKey }

class GateTicket {
  GateTicket._(this.denial, this._onRelease);

  final GateDenial? denial;
  void Function()? _onRelease;

  bool get granted => denial == null;

  /// Safe to call more than once.
  void release() {
    final callback = _onRelease;
    _onRelease = null;
    if (callback != null) callback();
  }
}

/// Limits concurrent work globally and per key. Memory is bounded by
/// [maxInFlight] (a per-key entry exists only while it holds a ticket).
class ConcurrencyGate {
  ConcurrencyGate({required this.maxInFlight, required this.perKeyInFlight});

  final int maxInFlight;
  final int perKeyInFlight;

  int _total = 0;
  final Map<String, int> _perKey = <String, int>{};

  int get inFlight => _total;

  GateTicket tryAcquire(String key) {
    if (_total >= maxInFlight) return GateTicket._(GateDenial.global, null);
    final current = _perKey[key] ?? 0;
    if (current >= perKeyInFlight) {
      return GateTicket._(GateDenial.perKey, null);
    }
    _total++;
    _perKey[key] = current + 1;
    return GateTicket._(null, () {
      _total--;
      final remaining = (_perKey[key] ?? 1) - 1;
      if (remaining <= 0) {
        _perKey.remove(key);
      } else {
        _perKey[key] = remaining;
      }
    });
  }
}

// ═══════════════════════════════════════════════════════════════════
// AI usage control (daily quotas + global cap + in-flight caps)
// ═══════════════════════════════════════════════════════════════════

class AiAdmission {
  AiAdmission._(this.allowed, this.status, this.error, this.retryAfterSeconds,
      this._onRelease);

  factory AiAdmission.denied(int status, String error, int retryAfterSeconds) =>
      AiAdmission._(false, status, error, retryAfterSeconds, null);

  factory AiAdmission._granted(void Function(bool refund) onRelease) =>
      AiAdmission._(true, 200, null, 0, onRelease);

  final bool allowed;
  final int status;
  final String? error;
  final int retryAfterSeconds;
  void Function(bool refund)? _onRelease;

  /// Must be called exactly once when the paid call finishes. Pass
  /// `refund: true` when the provider call failed for reasons that are not the
  /// user's fault (timeout, network error, provider 5xx) so it does not count
  /// against their quota or the global cap.
  void release({bool refund = false}) {
    final callback = _onRelease;
    _onRelease = null;
    if (callback != null) callback(refund);
  }
}

int secondsUntilNextUtcDay(DateTime now) {
  final u = now.toUtc();
  final next = DateTime.utc(u.year, u.month, u.day + 1);
  var seconds = next.difference(u).inSeconds;
  if (seconds < 1) seconds = 1;
  if (seconds > 86400) seconds = 86400;
  return seconds;
}

/// Controls access to PAID provider calls. Call [admit] only when a paid call
/// is actually about to be made (cache hits are free and never admitted).
class AiUsageController {
  AiUsageController({
    required this.globalDailyLimit,
    required int maxInFlight,
    required int perUserInFlight,
    this.maxTrackedUsers = 50000,
    DateTime Function()? clock,
  })  : _gate = ConcurrencyGate(
            maxInFlight: maxInFlight, perKeyInFlight: perUserInFlight),
        _clock = clock ?? DateTime.now;

  final int globalDailyLimit;
  final int maxTrackedUsers;
  final ConcurrencyGate _gate;
  final DateTime Function() _clock;

  String _day = '';
  int _globalCount = 0;
  final Map<String, int> _perUserCount = <String, int>{};

  int get globalUsedToday => _globalCount;
  int get inFlight => _gate.inFlight;

  void _rollDay(DateTime now) {
    final u = now.toUtc();
    final day = '${u.year}-${u.month}-${u.day}';
    if (day != _day) {
      _day = day;
      _globalCount = 0;
      _perUserCount.clear();
    }
  }

  AiAdmission admit({
    required String userKey,
    required String kind,
    required int userDailyLimit,
  }) {
    final now = _clock();
    _rollDay(now);
    final untilTomorrow = secondsUntilNextUtcDay(now);

    if (_globalCount >= globalDailyLimit) {
      return AiAdmission.denied(
          503,
          'AI service is temporarily unavailable. Please try again later.',
          untilTomorrow < 3600 ? untilTomorrow : 3600);
    }

    final dailyKey = '$kind|$userKey';
    final used = _perUserCount[dailyKey] ?? 0;
    if (used >= userDailyLimit) {
      return AiAdmission.denied(
          429,
          'Daily AI request limit reached. Please try again tomorrow.',
          untilTomorrow);
    }
    if (used == 0 && _perUserCount.length >= maxTrackedUsers) {
      return AiAdmission.denied(
          503, 'AI service is busy. Please try again shortly.', 30);
    }

    final ticket = _gate.tryAcquire(userKey);
    if (!ticket.granted) {
      if (ticket.denial == GateDenial.perKey) {
        return AiAdmission.denied(
            429,
            'Another AI request is still running. Please wait for it to finish.',
            3);
      }
      return AiAdmission.denied(
          503, 'AI service is busy. Please try again shortly.', 5);
    }

    _perUserCount[dailyKey] = used + 1;
    _globalCount++;
    final dayAtAdmission = _day;

    return AiAdmission._granted((bool refund) {
      ticket.release();
      if (refund && dayAtAdmission == _day) {
        final current = _perUserCount[dailyKey] ?? 0;
        if (current > 0) _perUserCount[dailyKey] = current - 1;
        if (_globalCount > 0) _globalCount--;
      }
    });
  }
}

// ═══════════════════════════════════════════════════════════════════
// Bounded TTL cache + single-flight
// ═══════════════════════════════════════════════════════════════════

class _CacheEntry<V> {
  const _CacheEntry(this.value, this.expiresAt, this.size);
  final V value;
  final DateTime expiresAt;
  final int size;
}

/// LRU cache with per-entry expiry, an entry-count bound and an optional
/// total-size bound (via [sizeOf]).
class BoundedTtlCache<V> {
  BoundedTtlCache({
    required this.maxEntries,
    this.maxTotalBytes,
    int Function(V value)? sizeOf,
    DateTime Function()? clock,
  })  : _sizeOf = sizeOf,
        _clock = clock ?? DateTime.now;

  final int maxEntries;
  final int? maxTotalBytes;
  final int Function(V value)? _sizeOf;
  final DateTime Function() _clock;

  final LinkedHashMap<String, _CacheEntry<V>> _map =
      LinkedHashMap<String, _CacheEntry<V>>();
  int _bytes = 0;

  int get length => _map.length;
  int get totalBytes => _bytes;

  V? get(String key) {
    final entry = _map.remove(key);
    if (entry == null) return null;
    _bytes -= entry.size;
    if (!entry.expiresAt.isAfter(_clock())) return null;
    _map[key] = entry; // most recently used
    _bytes += entry.size;
    return entry.value;
  }

  void put(String key, V value, Duration ttl) {
    _removeEntry(key);
    final sizer = _sizeOf;
    final size = sizer == null ? 0 : sizer(value);
    final limit = maxTotalBytes;
    if (limit != null && size > limit) return; // too big to cache
    _map[key] = _CacheEntry<V>(value, _clock().add(ttl), size);
    _bytes += size;
    _evict();
  }

  void remove(String key) => _removeEntry(key);

  void clear() {
    _map.clear();
    _bytes = 0;
  }

  void _removeEntry(String key) {
    final entry = _map.remove(key);
    if (entry != null) _bytes -= entry.size;
  }

  bool _overLimit() {
    final limit = maxTotalBytes;
    return _map.length > maxEntries || (limit != null && _bytes > limit);
  }

  void _evict() {
    if (!_overLimit()) return;
    final now = _clock();
    final expired = <String>[];
    _map.forEach((key, entry) {
      if (!entry.expiresAt.isAfter(now)) expired.add(key);
    });
    for (final key in expired) {
      _removeEntry(key);
    }
    while (_overLimit() && _map.isNotEmpty) {
      _removeEntry(_map.keys.first);
    }
  }
}

/// Coalesces identical concurrent work: the first caller for a key runs the
/// action, everyone else awaits the same future.
class SingleFlight<V> {
  final Map<String, Future<V>> _flights = <String, Future<V>>{};

  bool isRunning(String key) => _flights.containsKey(key);
  int get length => _flights.length;

  Future<V> run(String key, Future<V> Function() action) {
    final existing = _flights[key];
    if (existing != null) return existing;
    final future = Future<V>.sync(action).whenComplete(() {
      _flights.remove(key);
    });
    _flights[key] = future;
    return future;
  }
}

// ═══════════════════════════════════════════════════════════════════
// The guard
// ═══════════════════════════════════════════════════════════════════

class GuardDecision {
  const GuardDecision._(
      this.status, this.error, this.retryAfterSeconds, this.uid, this.rateKey);

  /// Request may proceed. [uid] is null only when authentication is optional
  /// (development) and no valid token was sent. [rateKey] identifies the
  /// caller ("uid:<uid>" or "ip:<ip>") for quotas.
  factory GuardDecision.pass({String? uid, required String rateKey}) =>
      GuardDecision._(200, null, 0, uid, rateKey);

  factory GuardDecision.unauthorized(String error) =>
      GuardDecision._(401, error, 0, null, '');

  factory GuardDecision.limited(int retryAfterSeconds) =>
      GuardDecision._(429, rateLimitMessage, retryAfterSeconds, null, '');

  factory GuardDecision.unavailable(String error, {int retryAfterSeconds = 5}) =>
      GuardDecision._(503, error, retryAfterSeconds, null, '');

  final int status;
  final String? error;
  final int retryAfterSeconds;
  final String? uid;
  final String rateKey;

  bool get allowed => status == 200;
}

class ApiSecurityGuard {
  ApiSecurityGuard({
    required this.config,
    FirebaseTokenVerifier? tokenVerifier,
    FirebaseAppCheckVerifier? appCheckVerifier,
    DateTime Function()? clock,
    void Function(String message)? log,
  })  : tokenVerifier = tokenVerifier ?? _defaultTokenVerifier(config),
        appCheckVerifier = appCheckVerifier ?? _defaultAppCheckVerifier(config),
        _clock = clock ?? DateTime.now,
        _log = log ?? _noLog,
        _ipLimiter = BoundedRateLimiter(maxKeys: config.maxTrackedKeys),
        _userLimiter = BoundedRateLimiter(maxKeys: config.maxTrackedKeys),
        ai = AiUsageController(
          globalDailyLimit: config.globalAiDailyLimit,
          maxInFlight: config.aiMaxInFlight,
          perUserInFlight: config.aiPerUserInFlight,
          maxTrackedUsers: config.maxTrackedKeys,
          clock: clock,
        );

  final SecurityConfig config;

  /// Null only when the Firebase API key / project ID are not configured
  /// (allowed in development when auth is optional).
  final FirebaseTokenVerifier? tokenVerifier;

  /// Null only when FIREBASE_PROJECT_NUMBER is not configured (allowed in
  /// development monitor mode).
  final FirebaseAppCheckVerifier? appCheckVerifier;

  /// Paid-AI quotas, global cap and in-flight limits.
  final AiUsageController ai;

  final DateTime Function() _clock;
  final void Function(String message) _log;
  final BoundedRateLimiter _ipLimiter;
  final BoundedRateLimiter _userLimiter;
  int _monitorEvents = 0;

  static void _noLog(String _) {}

  static FirebaseTokenVerifier? _defaultTokenVerifier(SecurityConfig c) {
    if (c.firebaseWebApiKey.isEmpty || c.firebaseProjectId.isEmpty) return null;
    return FirebaseTokenVerifier(
      apiKey: c.firebaseWebApiKey,
      projectId: c.firebaseProjectId,
      // Short positive cache: revocation/disable takes effect within 2 min.
      cacheTtl: const Duration(minutes: 2),
    );
  }

  static FirebaseAppCheckVerifier? _defaultAppCheckVerifier(SecurityConfig c) {
    if (c.firebaseProjectNumber.isEmpty) return null;
    return FirebaseAppCheckVerifier(
      projectNumber: c.firebaseProjectNumber,
      allowedAppIds: c.appCheckAllowedAppIds,
    );
  }

  /// Light per-IP limit for the public health endpoint.
  GuardDecision checkHealth(String clientIp) {
    final decision = _ipLimiter.check(
        'health|$clientIp', config.healthIpPerMinute, _clock());
    if (!decision.allowed) {
      return GuardDecision.limited(decision.retryAfterSeconds);
    }
    return GuardDecision.pass(rateKey: 'ip:$clientIp');
  }

  /// Full protection for a non-public route.
  ///
  /// [bucket] names the route class for the per-user limit (for example
  /// "general" or "claude"). [forceAuth] makes a route require a Firebase ID
  /// token even where [SecurityConfig.authRequired] is false (development).
  Future<GuardDecision> authorize({
    required String clientIp,
    required String? authorizationHeader,
    required String? appCheckHeader,
    required String bucket,
    required int userPerMinute,
    bool forceAuth = false,
  }) async {
    final now = _clock();

    // 1. Cheap, bounded per-IP limit BEFORE any verification work.
    final pre =
        _ipLimiter.check('pre|$clientIp', config.preAuthIpPerMinute, now);
    if (!pre.allowed) return GuardDecision.limited(pre.retryAfterSeconds);

    // 2. Firebase Auth (reuses FirebaseTokenVerifier; no duplicate logic).
    final mustAuth = config.authRequired || forceAuth;
    final hasAuthHeader = (authorizationHeader ?? '').trim().isNotEmpty;
    String? uid;
    if (mustAuth || hasAuthHeader) {
      final verifier = tokenVerifier;
      if (verifier == null) {
        if (mustAuth) return GuardDecision.unavailable(_msgAuthUnavailable);
      } else {
        final result = await verifier.verifyHeader(authorizationHeader);
        if (result.status == TokenStatus.valid && result.uid != null) {
          uid = result.uid;
        } else if (mustAuth) {
          if (result.status == TokenStatus.unavailable) {
            return GuardDecision.unavailable(_msgAuthUnavailable);
          }
          return GuardDecision.unauthorized(_msgAuth);
        }
      }
    }

    // 3. App Check.
    final enforced = config.appCheckEnforcedAt(now);
    final acVerifier = appCheckVerifier;
    if (acVerifier == null) {
      if (enforced) {
        return GuardDecision.unavailable(_msgAppCheckUnavailable);
      }
    } else {
      final ac = await acVerifier.verify(appCheckHeader);
      if (ac.status != AppCheckStatus.valid) {
        if (enforced) {
          if (ac.status == AppCheckStatus.unavailable) {
            return GuardDecision.unavailable(_msgAppCheckUnavailable);
          }
          return GuardDecision.unauthorized(_msgAppCheck);
        }
        _noteMonitorEvent(ac.status, ac.reason);
      }
    }

    // 4. Per-user (or per-IP when anonymous in development) limit. Per-user
    //    keys exist only after Auth + App Check succeeded, so anonymous
    //    traffic cannot evict real users' counters.
    final rateKey = uid != null ? 'uid:$uid' : 'ip:$clientIp';
    final rate = _userLimiter.check('$bucket|$rateKey', userPerMinute, now);
    if (!rate.allowed) return GuardDecision.limited(rate.retryAfterSeconds);

    return GuardDecision.pass(uid: uid, rateKey: rateKey);
  }

  /// Monitor mode accepts the request but records WHY it would have been
  /// rejected. Logged on the first event and then every 100th (no token or
  /// header contents, only a short reason code).
  void _noteMonitorEvent(AppCheckStatus status, String? reason) {
    _monitorEvents++;
    if (_monitorEvents == 1 || _monitorEvents % 100 == 0) {
      _log('App Check monitor mode: request would be rejected '
          '(${status.name}: ${reason ?? 'unknown'}); total=$_monitorEvents');
    }
  }
}