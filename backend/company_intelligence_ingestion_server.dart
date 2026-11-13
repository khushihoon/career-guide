import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../lib/services/company_intelligence_models.dart';
import '../lib/services/company_intelligence_live_source_catalog.dart';
import '../lib/services/company_source_adapters.dart';
import 'api_security_guard.dart';

/// Step 6E-4 — Company Intelligence ingestion backend.
///
/// This file is a pure-Dart HTTP server.
/// It deliberately does NOT import Flutter.
///
/// Responsibilities:
/// - expose a local HTTP ingestion API;
/// - fetch a configured public source URL when requested;
/// - normalize provider JSON through CompanySourceAdapter;
/// - return normalized job evidence and a truthful CompanyIntelligenceSnapshot;
/// - keep reference / observed / live information distinguishable.
///
/// Development server:
///   CAREER_GUIDE_ENV=development dart run backend/company_intelligence_ingestion_server.dart
///
/// Default:
///   http://localhost:8091
///
/// Endpoints (response contracts UNCHANGED):
///   GET  /health
///   POST /ingest
///   POST /ingest/source
///
/// POST /ingest accepts:
/// {
///   "companyId": "openai",
///   "companyName": "OpenAI",
///   "sourceType": "ashby",
///   "sourceUrl": "https://...",
///   "payload": "{...}"
/// }
///
/// POST /ingest/source accepts the same fields except payload.
/// The backend fetches sourceUrl itself.
///
/// PHASE 2 SECURITY HARDENING
///  * Authentication and App Check are verified by the shared
///    [ApiSecurityGuard] (reusing FirebaseTokenVerifier and
///    FirebaseAppCheckVerifier). Invalid credentials -> 401, verification
///    outage -> 503, limits -> 429. This file no longer has its own token
///    check.
///  * CAREER_GUIDE_ENV must be production | staging | development.
///    Production ALWAYS enforces Firebase Auth + App Check and refuses to
///    start on an invalid security configuration. A non-loopback bind address
///    requires authentication.
///  * Per-IP and per-user limits, all bounded in memory. X-Forwarded-For is
///    used only with TRUST_PROXY=true (see TRUSTED_PROXY_HOPS).
///  * Upstream fetches are bounded: at most INGESTION_MAX_IN_FLIGHT at once
///    (one per user), one shared fetch per source (single-flight), a 45 s
///    overall deadline, and a short in-memory cache
///    (INGESTION_CACHE_TTL_SECONDS, default 10 min) so users do not trigger
///    repeated provider calls. The response keeps the ORIGINAL fetch time in
///    `fetchedAt`, so the client's freshness check stays truthful.
///  * Route matching happens BEFORE authentication (unknown paths cost no
///    Firebase lookup) and the 404 body no longer lists endpoints in
///    staging/production.
///  * Errors caused by provider data are generic (no provider text leaks).
///  * Health stays public and minimal.
///  * The trusted source allow-list and the redirect protection are
///    UNCHANGED:
///  * This development server only consumes URLs explicitly supplied by the
///    caller.
///  * It does not scrape HTML pages.
///  * It does not invent skills, roles, salary, or hiring information.
///  * Skills/roles/technology fields are derived only from normalized job
///    evidence using the deterministic keyword extraction below.
///  * A company with zero live jobs is not presented as currently hiring.
///
/// Limitation: limits, quotas and the cache are in this process's memory.
/// They reset on restart and are not shared between instances.
class CompanyIntelligenceIngestionServer {
  static const int _maxRequestBytes = 64 * 1024;

  static const int _maxUpstreamBytes = 20 * 1024 * 1024;

  static const int _maxResponseBytes = 6 * 1024 * 1024;

  static const CompanySourceAdapterRegistry _adapterRegistry =
      CompanySourceAdapterRegistry();

  static const CompanyIntelligenceLiveSourceCatalog _sourceCatalog =
      CompanyIntelligenceLiveSourceCatalog();

  static Map<String, String> _env = Platform.environment;
  static SecurityConfig? _config;
  static ApiSecurityGuard? _guard;

  /// Shared cache of the (compacted, shape-validated) provider payload per
  /// trusted source, together with the time it was really fetched.
  static final BoundedTtlCache<_CachedPayload> _payloadCache =
      BoundedTtlCache<_CachedPayload>(
    maxEntries: 24,
    maxTotalBytes: 64 * 1024 * 1024,
    sizeOf: (_CachedPayload value) => value.payload.length,
  );
  static final SingleFlight<_CachedPayload> _flights =
      SingleFlight<_CachedPayload>();
  static ConcurrencyGate _fetchGate =
      ConcurrencyGate(maxInFlight: 4, perKeyInFlight: 1);

  // ── Environment ───────────────────────────────────────────────

  static String _envStr(String key) => (_env[key] ?? '').trim();

  static int _envInt(String key, int fallback, int min, int max) {
    final parsed = int.tryParse(_envStr(key));
    return parsed == null ? fallback : parsed.clamp(min, max).toInt();
  }

  static int get port => int.tryParse(_envStr('PORT')) ?? 8091;

  static int get _userPerMinute =>
      _envInt('INGESTION_USER_PER_MINUTE', 20, 1, 600);

  static Duration get _cacheTtl => Duration(
      seconds: _envInt('INGESTION_CACHE_TTL_SECONDS', 600, 30, 3600));

  // ── Start / serve ─────────────────────────────────────────────

  /// Validates configuration (fail closed) and binds the server. Parameters
  /// exist so tests can inject an environment, guard and an ephemeral port.
  static Future<HttpServer> bind({
    Map<String, String>? environment,
    ApiSecurityGuard? guard,
    int? port,
    DateTime Function()? clock,
  }) async {
    _env = environment ?? Platform.environment;

    final SecurityConfig config;
    try {
      config = SecurityConfig.fromEnvironment(_env, clock: clock);
    } on SecurityConfigException catch (e) {
      throw StateError(e.message);
    }

    _config = config;
    _guard =
        guard ?? ApiSecurityGuard(config: config, log: (m) => stderr.writeln(m));
    _payloadCache.clear();
    _fetchGate = ConcurrencyGate(
      maxInFlight: _envInt('INGESTION_MAX_IN_FLIGHT', 4, 1, 32),
      perKeyInFlight: 1,
    );

    final address = InternetAddress.tryParse(config.bindAddress);
    if (address == null) {
      throw StateError('CAREER_GUIDE_BIND_ADDRESS must be an IP address.');
    }
    final server = await HttpServer.bind(
        address, port ?? CompanyIntelligenceIngestionServer.port,
        shared: true);
    server.idleTimeout = const Duration(seconds: 15);
    return server;
  }

  static Future<void> start() async {
    final server = await bind();

    stdout.writeln(
        'Company Intelligence ingestion backend running on ${server.address.address}:${server.port}');
    stdout.writeln('Health: http://localhost:${server.port}/health');
    stdout.writeln('Security: ${_config!.summary()}');

    await serve(server);
  }

  static Future<void> serve(HttpServer server) async {
    await for (final request in server) {
      // Do not let one slow provider request block health checks or other users.
      unawaited(_handleRequest(request));
    }
  }

  // ── Request handling ──────────────────────────────────────────

  static Future<void> _handleRequest(HttpRequest request) async {
    final guard = _guard!;
    final config = _config!;
    final originAllowed = _applyCors(request);

    if (!originAllowed) {
      await _writeJson(
          request.response, HttpStatus.forbidden, <String, dynamic>{
        'success': false,
        'error': 'Origin is not allowed.'
      });

      return;
    }

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.noContent;

      await request.response.close();

      return;
    }

    try {
      final ip = resolveClientIp(
        remoteAddress: request.connectionInfo?.remoteAddress.address ?? '',
        forwardedFor: request.headers.value('x-forwarded-for'),
        trustProxy: config.trustProxy,
        hops: config.trustedProxyHops,
      );
      final path = request.uri.path;

      if (request.method == 'GET' && path == '/health') {
        final health = guard.checkHealth(ip);
        if (!health.allowed) {
          request.response.headers
              .set('Retry-After', '${health.retryAfterSeconds}');
          await _writeJson(
              request.response, HttpStatus.tooManyRequests, <String, dynamic>{
            'success': false,
            'error': rateLimitMessage,
          });
          return;
        }
        // Minimal and safe. `status: running` is what the Flutter client
        // checks. Mode/port are shown in development only.
        await _writeJson(
            request.response,
            HttpStatus.ok,
            config.isStrict
                ? <String, dynamic>{'success': true, 'status': 'running'}
                : <String, dynamic>{
                    'success': true,
                    'service': 'company_intelligence_ingestion',
                    'port': port,
                    'status': 'running',
                    'mode': 'local_development',
                  });
        return;
      }

      final isIngest = request.method == 'POST' && path == '/ingest';
      final isSource = request.method == 'POST' && path == '/ingest/source';
      if (!isIngest && !isSource) {
        // Route matching happens BEFORE authentication: unknown paths must
        // not cost a Firebase lookup.
        await _writeJson(
            request.response, HttpStatus.notFound, <String, dynamic>{
          'success': false,
          'error': 'Unknown ingestion endpoint.',
          if (!config.isStrict)
            'availableEndpoints': <String>[
              'GET /health',
              'POST /ingest',
              'POST /ingest/source'
            ],
        });
        return;
      }

      // Per-IP limit -> Firebase Auth -> App Check -> per-user limit.
      final decision = await guard.authorize(
        clientIp: ip,
        authorizationHeader:
            request.headers.value(HttpHeaders.authorizationHeader),
        appCheckHeader: request.headers.value('x-firebase-appcheck'),
        bucket: 'ingest',
        userPerMinute: _userPerMinute,
      );
      if (!decision.allowed) {
        if (decision.retryAfterSeconds > 0) {
          request.response.headers
              .set('Retry-After', '${decision.retryAfterSeconds}');
        }
        await _writeJson(request.response, decision.status, <String, dynamic>{
          'success': false,
          'error': decision.error,
        });
        return;
      }

      if (isIngest) {
        await _handleIngest(request);
      } else {
        await _handleSourceIngest(request, decision.rateKey);
      }
    } on _RequestTooLargeException {
      await _writeJson(request.response, 413, <String, dynamic>{
        'success': false,
        'error': 'Request body exceeds the allowed size.'
      });
    } on _BodyTimeout {
      await _writeJson(request.response, HttpStatus.requestTimeout,
          <String, dynamic>{
        'success': false,
        'error': 'Request body timed out.'
      });
    } on _Denied catch (e) {
      if (e.retryAfterSeconds > 0) {
        request.response.headers.set('Retry-After', '${e.retryAfterSeconds}');
      }
      await _writeJson(request.response, e.status, <String, dynamic>{
        'success': false,
        'error': e.error,
      });
    } on _UpstreamTooLargeException {
      await _writeJson(
          request.response, HttpStatus.badGateway, <String, dynamic>{
        'success': false,
        'error': 'The trusted source response exceeded the allowed size.'
      });
    } on _UpstreamInvalid {
      // Never forward provider text or parser messages to the caller.
      await _writeJson(
          request.response, HttpStatus.badGateway, <String, dynamic>{
        'success': false,
        'error': 'The trusted source returned an unexpected response.'
      });
    } on FormatException catch (error) {
      // Request validation messages (our own wording) for the caller's input.
      await _writeJson(request.response, HttpStatus.badRequest,
          <String, dynamic>{'success': false, 'error': error.message});
    } on TimeoutException {
      await _writeJson(
          request.response, HttpStatus.gatewayTimeout, <String, dynamic>{
        'success': false,
        'error': 'The source request timed out.'
      });
    } catch (error, stackTrace) {
      // Avoid logging payloads, tokens, provider response bodies, or raw URLs.
      stderr.writeln(
          'Company Intelligence ingestion failure (${error.runtimeType}).');

      if (_config?.isStrict != true) stderr.writeln(stackTrace);

      await _writeJson(
          request.response, HttpStatus.badGateway, <String, dynamic>{
        'success': false,
        'error': 'Company Intelligence ingestion failed safely.'
      });
    }
  }

  static Future<void> _handleIngest(HttpRequest request) async {
    final body = await _readJsonObject(request);

    final requestData = _parseIngestionRequest(
      body,
      requirePayload: true,
    );

    final result = _parsePayload(
      requestData: requestData,
      payload: requestData.payload!,
    );

    await _writeJson(
      request.response,
      HttpStatus.ok,
      result,
    );
  }

  static Future<void> _handleSourceIngest(
      HttpRequest request, String userKey) async {
    final body = await _readJsonObject(request);
    final requestData = _parseIngestionRequest(body, requirePayload: false);

    final cacheKey = '${requestData.sourceType.name}|${requestData.sourceUrl}';
    _CachedPayload? entry = _payloadCache.get(cacheKey);

    if (entry == null) {
      // Only the request that actually starts the upstream fetch takes an
      // in-flight slot; concurrent requests for the same source share it.
      GateTicket? ticket;
      if (!_flights.isRunning(cacheKey)) {
        ticket = _fetchGate.tryAcquire(userKey);
        if (!ticket.granted) {
          if (ticket.denial == GateDenial.perKey) {
            throw const _Denied(429,
                'Another refresh is still running. Please wait for it to finish.', 3);
          }
          throw const _Denied(
              503, 'The ingestion service is busy. Please try again shortly.', 5);
        }
      }
      try {
        entry = await _flights.run(cacheKey, () async {
          final upstreamPayload = await _fetchSource(requestData.sourceUrl)
              .timeout(const Duration(seconds: 45));
          // Ashby feeds include long descriptions/HTML. Compact server-side
          // so the existing Flutter client contract remains <= 2 MiB while
          // preserving the actual provider compensation object and useful
          // job evidence.
          final payload = requestData.sourceType == CompanySourceType.ashby
              ? _compactAshbyPayload(upstreamPayload)
              : upstreamPayload;
          // Reject wrong-shape provider data BEFORE it can be cached.
          _validateProviderPayloadShape(
            sourceType: requestData.sourceType,
            payload: payload,
          );
          final fresh = _CachedPayload(payload, DateTime.now().toUtc());
          _payloadCache.put(cacheKey, fresh, _cacheTtl);
          return fresh;
        });
      } on FormatException {
        throw const _UpstreamInvalid();
      } finally {
        ticket?.release();
      }
    }

    final resolved = entry!;
    final Map<String, dynamic> result;
    try {
      result = _parsePayload(
        requestData: requestData,
        payload: resolved.payload,
        fetchedAt: resolved.fetchedAt,
      );
    } on FormatException {
      throw const _UpstreamInvalid();
    }
    await _writeJson(request.response, HttpStatus.ok, result);
  }

  static String _compactAshbyPayload(String payload) {
    final decoded = jsonDecode(payload);
    if (decoded is! Map || decoded['jobs'] is! List) {
      throw const FormatException('Ashby response must contain a jobs array.');
    }
    final compactJobs = <Map<String, dynamic>>[];
    for (final raw in decoded['jobs'] as List) {
      if (raw is! Map) continue;
      final job = Map<String, dynamic>.from(raw);
      final id = job['id']?.toString().trim() ?? '';
      final title = job['title']?.toString().trim() ?? '';
      if (id.isEmpty || title.isEmpty || job['isListed'] == false) continue;

      String boundedText(dynamic value, int maxChars) {
        if (value is! String) return '';
        final normalized = value.replaceAll(RegExp(r'\s+'), ' ').trim();
        return normalized.length <= maxChars
            ? normalized
            : normalized.substring(0, maxChars);
      }

      compactJobs.add(<String, dynamic>{
        'id': id,
        'title': boundedText(job['title'], 240),
        'department': boundedText(job['department'], 160),
        'team': boundedText(job['team'], 160),
        'employmentType': boundedText(job['employmentType'], 100),
        'location': boundedText(job['location'], 240),
        'secondaryLocations': job['secondaryLocations'] is List
            ? (job['secondaryLocations'] as List)
                .take(20)
                .toList(growable: false)
            : const <dynamic>[],
        'publishedAt': job['publishedAt'],
        'isListed': job['isListed'],
        'isRemote': job['isRemote'],
        'workplaceType': boundedText(job['workplaceType'], 80),
        'address': boundedText(job['address'], 240),
        'jobUrl': boundedText(job['jobUrl'], 1000),
        'applyUrl': boundedText(job['applyUrl'], 1000),
        'descriptionPlain':
            boundedText(job['descriptionPlain'] ?? job['description'], 900),
        // Retain provider evidence exactly; do not synthesize compensation.
        if (job['compensation'] is Map) 'compensation': job['compensation'],
        'shouldDisplayCompensationOnJobPostings':
            job['shouldDisplayCompensationOnJobPostings'],
      });
    }
    final compactPayload = jsonEncode(<String, dynamic>{'jobs': compactJobs});
    if (utf8.encode(compactPayload).length > 2 * 1024 * 1024) {
      throw const _UpstreamTooLargeException();
    }
    return compactPayload;
  }

  static Future<Map<String, dynamic>> _readJsonObject(
      HttpRequest request) async {
    if (request.contentLength > _maxRequestBytes) {
      throw const _RequestTooLargeException();
    }

    final bytes = BytesBuilder(copy: false);
    final watch = Stopwatch()..start();

    try {
      // Per-chunk idle timeout plus an overall deadline against slow-body
      // (slowloris) clients.
      await for (final chunk in request.timeout(const Duration(seconds: 10))) {
        if (bytes.length + chunk.length > _maxRequestBytes) {
          throw const _RequestTooLargeException();
        }
        bytes.add(chunk);
        if (watch.elapsed > const Duration(seconds: 15)) {
          throw const _BodyTimeout();
        }
      }
    } on TimeoutException {
      throw const _BodyTimeout();
    }

    final body = utf8.decode(bytes.takeBytes());

    if (body.trim().isEmpty) {
      throw const FormatException('Request body is empty.');
    }

    final dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } on FormatException {
      throw const FormatException('Request body must be valid JSON.');
    }

    if (decoded is! Map) {
      throw const FormatException('Request body must be a JSON object.');
    }

    return Map<String, dynamic>.from(decoded);
  }

  static _IngestionRequest _parseIngestionRequest(
    Map<String, dynamic> body, {
    required bool requirePayload,
  }) {
    final companyId = _requiredString(
      body,
      'companyId',
    );

    final companyName = _requiredString(
      body,
      'companyName',
    );

    final sourceTypeValue = _requiredString(
      body,
      'sourceType',
    );

    final sourceType = _sourceTypeFromString(
      sourceTypeValue,
    );

    final sourceUrl = _requiredString(
      body,
      'sourceUrl',
    );

    _validateHttpsUrl(sourceUrl);

    _validateAgainstTrustedCatalog(
        companyId: companyId,
        companyName: companyName,
        sourceType: sourceType,
        sourceUrl: sourceUrl);

    final payload = body['payload']?.toString();

    if (requirePayload && (payload == null || payload.trim().isEmpty)) {
      throw const FormatException(
        'payload is required for /ingest.',
      );
    }

    return _IngestionRequest(
      companyId: companyId,
      companyName: companyName,
      sourceType: sourceType,
      sourceUrl: sourceUrl,
      payload: payload,
    );
  }

  static Map<String, dynamic> _parsePayload({
    required _IngestionRequest requestData,
    required String payload,
    DateTime? fetchedAt,
  }) {
    final adapter = _adapterRegistry.forType(
      requestData.sourceType,
    );

    if (adapter == null) {
      throw StateError(
        'No adapter is registered for ${requestData.sourceType.name}.',
      );
    }

    _validateProviderPayloadShape(
      sourceType: requestData.sourceType,
      payload: payload,
    );

    // For cached source payloads this is the time the provider was REALLY
    // queried, so the client's freshness check stays truthful.
    final fetchedAtUtc = fetchedAt ?? DateTime.now().toUtc();

    final jobs = adapter.parse(
      companyId: requestData.companyId,
      companyName: requestData.companyName,
      sourceUrl: requestData.sourceUrl,
      payload: payload,
      fetchedAt: fetchedAtUtc,
    );

    final snapshot = _buildSnapshot(
      companyId: requestData.companyId,
      companyName: requestData.companyName,
      sourceType: requestData.sourceType,
      sourceUrl: requestData.sourceUrl,
      jobs: jobs,
      generatedAt: fetchedAtUtc,
    );

    return <String, dynamic>{
      'success': true,
      'companyId': requestData.companyId,
      'companyName': requestData.companyName,
      'sourceType': requestData.sourceType.name,
      'sourceUrl': requestData.sourceUrl,
      'fetchedAt': fetchedAtUtc.toIso8601String(),

      // Raw source payload is consumed by Flutter's canonical adapter pipeline.
      'payload': payload,
      'jobCount': jobs.length,
      'jobs': jobs.map(_jobToJson).toList(growable: false),
      'snapshot': _snapshotToJson(snapshot),
    };
  }

  /// Reject malformed/wrong-shape provider data instead of treating it as a
  /// valid feed with zero jobs. A correctly shaped empty array is valid.
  static void _validateProviderPayloadShape({
    required CompanySourceType sourceType,
    required String payload,
  }) {
    final dynamic decoded;

    try {
      decoded = jsonDecode(payload);
    } on FormatException {
      throw const FormatException('Provider returned invalid JSON.');
    }

    bool hasListAt(dynamic value, String key) =>
        value is Map && value[key] is List;

    switch (sourceType) {
      case CompanySourceType.greenhouse:
      case CompanySourceType.ashby:
        if (!hasListAt(decoded, 'jobs')) {
          throw FormatException(
            'Provider response for ${sourceType.name} must contain a jobs array.',
          );
        }

        break;

      case CompanySourceType.lever:
        if (decoded is! List) {
          throw const FormatException(
            'Provider response for lever must be a JSON array.',
          );
        }

        break;

      case CompanySourceType.smartRecruiters:
        if (!hasListAt(decoded, 'content')) {
          throw const FormatException(
            'Provider response for smartRecruiters must contain a content array.',
          );
        }

        break;

      default:
        throw FormatException(
          'Source type ${sourceType.name} is not supported by the live provider adapters.',
        );
    }
  }

  static CompanyIntelligenceSnapshot _buildSnapshot({
    required String companyId,
    required String companyName,
    required CompanySourceType sourceType,
    required String sourceUrl,
    required List<NormalizedJobPosting> jobs,
    required DateTime generatedAt,
  }) {
    final skills = <String>{};

    final technologies = <String>{};

    final concepts = <String>{};

    final roles = <String>{};

    final compensation = <CompanyCompensation>[];

    for (final job in jobs) {
      roles.addAll(
        _roleSignals(job.title),
      );

      skills.addAll(
        _skillSignals('${job.title}\n${job.description}'),
      );

      technologies.addAll(
        _technologySignals('${job.title}\n${job.description}'),
      );

      concepts.addAll(
        _conceptSignals('${job.title}\n${job.description}'),
      );

      if (job.compensation != null) {
        compensation.add(job.compensation!);
      }
    }

    final oldest = _oldestJobEvidence(jobs);

    final newest = _newestJobEvidence(jobs);

    final status = jobs.isNotEmpty
        ? CompanyIntelligenceDataStatus.live
        : CompanyIntelligenceDataStatus.unavailable;

    final source = CompanySourceDefinition(
      sourceId: '${sourceType.name}:$companyId',
      type: sourceType,
      companyId: companyId,
      companyName: companyName,
      sourceUrl: sourceUrl,
      sourceLabel: _sourceLabel(sourceType),
      isOfficialCompanySource: true,
      supportsLiveJobs: true,
      supportsCompensation: compensation.isNotEmpty,
      lastFetchedAt: generatedAt,
    );

    return CompanyIntelligenceSnapshot(
      companyId: companyId,
      companyName: companyName,
      status: status,
      roles: roles.toList()..sort(),
      skills: skills.toList()..sort(),
      technologies: technologies.toList()..sort(),
      engineeringConcepts: concepts.toList()..sort(),
      compensation: compensation,
      liveJobs: jobs,
      sources: <CompanySourceDefinition>[source],
      generatedAt: generatedAt,
      oldestEvidenceAt: oldest,
      newestEvidenceAt: newest,
    );
  }

  static const int _maxUpstreamAttempts = 3;

  static Future<String> _fetchSource(String sourceUrl) async {
    Object? lastError;

    for (var attempt = 1; attempt <= _maxUpstreamAttempts; attempt++) {
      try {
        return await _fetchSourceAttempt(sourceUrl);
      } on _RetryableUpstreamException catch (error) {
        lastError = error;

        if (attempt == _maxUpstreamAttempts) break;

        await Future<void>.delayed(Duration(milliseconds: attempt * 350));
      } on TimeoutException catch (error) {
        lastError = error;

        if (attempt == _maxUpstreamAttempts) break;

        await Future<void>.delayed(Duration(milliseconds: attempt * 350));
      } on SocketException catch (error) {
        lastError = error;

        if (attempt == _maxUpstreamAttempts) break;

        await Future<void>.delayed(Duration(milliseconds: attempt * 350));
      }
    }

    // Do not leak provider details or the configured URL to API callers.

    throw TimeoutException(
      lastError is _RetryableUpstreamException
          ? 'Trusted source remained temporarily unavailable after bounded retries.'
          : 'Trusted source could not be reached after bounded retries.',
    );
  }

  static Future<String> _fetchSourceAttempt(String sourceUrl) async {
    final uri = Uri.parse(sourceUrl);

    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 4)
      ..idleTimeout = const Duration(seconds: 20);

    try {
      final request =
          await client.getUrl(uri).timeout(const Duration(seconds: 5));

      // Redirects are deliberately disabled: a trusted ATS URL cannot redirect
      // the server to an untrusted/private network destination.

      request.followRedirects = false;

      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      request.headers.set(
          HttpHeaders.userAgentHeader, 'CareerGuide-CompanyIntelligence/6E-4');

      final response =
          await request.close().timeout(const Duration(seconds: 20));

      if (response.statusCode == HttpStatus.tooManyRequests ||
          response.statusCode == HttpStatus.internalServerError ||
          response.statusCode == HttpStatus.badGateway ||
          response.statusCode == HttpStatus.serviceUnavailable ||
          response.statusCode == HttpStatus.gatewayTimeout) {
        throw _RetryableUpstreamException(response.statusCode);
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException('Trusted source returned a non-success status.',
            uri: uri);
      }

      if (response.contentLength > _maxUpstreamBytes) {
        throw const _UpstreamTooLargeException();
      }

      final bytes = BytesBuilder(copy: false);

      await for (final chunk in response.timeout(const Duration(seconds: 20))) {
        if (bytes.length + chunk.length > _maxUpstreamBytes) {
          throw const _UpstreamTooLargeException();
        }

        bytes.add(chunk);
      }

      return utf8.decode(bytes.takeBytes());
    } finally {
      client.close(force: true);
    }
  }

  static void _validateAgainstTrustedCatalog({
    required String companyId,
    required String companyName,
    required CompanySourceType sourceType,
    required String sourceUrl,
  }) {
    final config = _sourceCatalog.forCompanyName(companyName);

    if (config == null ||
        config.companyId != companyId ||
        config.companyName != companyName ||
        config.sourceType != sourceType ||
        config.sourceUrl != sourceUrl ||
        !config.isOfficialCompanySource ||
        !config.supportsLiveJobs) {
      throw const FormatException(
          'Requested company/source is not present in the trusted live-source allowlist.');
    }
  }

  static CompanySourceType _sourceTypeFromString(
    String value,
  ) {
    final normalized = value.trim().toLowerCase();

    for (final type in CompanySourceType.values) {
      if (type.name.toLowerCase() == normalized) {
        return type;
      }
    }

    throw FormatException(
      'Unsupported sourceType "$value".',
    );
  }

  static String _requiredString(
    Map<String, dynamic> body,
    String key,
  ) {
    final value = body[key]?.toString().trim();

    if (value == null || value.isEmpty) {
      throw FormatException(
        '$key is required.',
      );
    }

    return value;
  }

  static void _validateHttpsUrl(String value) {
    final uri = Uri.tryParse(value);

    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      throw FormatException(
        'sourceUrl must be a valid HTTPS URL.',
      );
    }
  }

  static String _sourceLabel(
    CompanySourceType type,
  ) {
    switch (type) {
      case CompanySourceType.officialCareers:
        return 'Official company careers source';

      case CompanySourceType.greenhouse:
        return 'Greenhouse job feed';

      case CompanySourceType.lever:
        return 'Lever job feed';

      case CompanySourceType.ashby:
        return 'Ashby public job feed';

      case CompanySourceType.smartRecruiters:
        return 'SmartRecruiters job feed';

      case CompanySourceType.backendFeed:
        return 'Backend ingestion feed';

      case CompanySourceType.manualVerified:
        return 'Manually verified source';
    }
  }

  static DateTime? _oldestJobEvidence(
    List<NormalizedJobPosting> jobs,
  ) {
    final dates =
        jobs.map((job) => job.publishedAt).whereType<DateTime>().toList();

    if (dates.isEmpty) return null;

    dates.sort();

    return dates.first;
  }

  static DateTime? _newestJobEvidence(
    List<NormalizedJobPosting> jobs,
  ) {
    final dates =
        jobs.map((job) => job.publishedAt).whereType<DateTime>().toList();

    if (dates.isEmpty) return null;

    dates.sort();

    return dates.last;
  }

  static Set<String> _roleSignals(String title) {
    final text = title.toLowerCase();

    final result = <String>{};

    const signals = <String, List<String>>{
      'Software Engineer': <String>[
        'software engineer',
        'software developer',
      ],
      'Machine Learning Engineer': <String>[
        'machine learning engineer',
        'ml engineer',
      ],
      'AI Engineer': <String>[
        'ai engineer',
        'artificial intelligence engineer',
        'applied ai',
      ],
      'Research Engineer': <String>[
        'research engineer',
      ],
      'Data Engineer': <String>[
        'data engineer',
      ],
      'Infrastructure Engineer': <String>[
        'infrastructure engineer',
        'platform engineer',
      ],
      'Backend Engineer': <String>[
        'backend engineer',
        'back-end engineer',
      ],
      'Frontend Engineer': <String>[
        'frontend engineer',
        'front-end engineer',
      ],
      'Security Engineer': <String>[
        'security engineer',
      ],
    };

    signals.forEach((label, matches) {
      if (matches.any(text.contains)) {
        result.add(label);
      }
    });

    if (result.isEmpty && title.trim().isNotEmpty) {
      result.add(title.trim());
    }

    return result;
  }

  static Set<String> _skillSignals(String value) {
    final text = value.toLowerCase();

    final result = <String>{};

    const signals = <String>[
      'python',
      'java',
      'javascript',
      'typescript',
      'c++',
      'c#',
      'go',
      'rust',
      'sql',
      'machine learning',
      'deep learning',
      'distributed systems',
      'system design',
      'data engineering',
      'software engineering',
      'statistics',
      'mathematics',
      'natural language processing',
      'computer vision',
      'reinforcement learning',
      'generative ai',
      'llm',
      'large language models',
      'prompt engineering',
      'model evaluation',
      'mlops',
      'cloud',
      'security',
    ];

    for (final signal in signals) {
      if (text.contains(signal)) {
        result.add(signal);
      }
    }

    return result;
  }

  static Set<String> _technologySignals(String value) {
    final text = value.toLowerCase();

    final result = <String>{};

    const signals = <String>[
      'pytorch',
      'tensorflow',
      'cuda',
      'kubernetes',
      'docker',
      'aws',
      'azure',
      'gcp',
      'google cloud',
      'spark',
      'kafka',
      'postgresql',
      'mysql',
      'snowflake',
      'openai',
      'transformers',
      'langchain',
      'llamaindex',
      'ray',
      'slurm',
      'opensearch',
      'terraform',
      'graphql',
      'rest api',
    ];

    for (final signal in signals) {
      if (text.contains(signal)) {
        result.add(signal);
      }
    }

    return result;
  }

  static Set<String> _conceptSignals(String value) {
    final text = value.toLowerCase();

    final result = <String>{};

    const signals = <String>[
      'scalability',
      'reliability',
      'observability',
      'distributed systems',
      'inference',
      'model training',
      'model deployment',
      'fine-tuning',
      'retrieval augmented generation',
      'rag',
      'agents',
      'ai safety',
      'privacy',
      'performance optimization',
      'cloud infrastructure',
      'data pipelines',
      'api design',
    ];

    for (final signal in signals) {
      if (text.contains(signal)) {
        result.add(signal);
      }
    }

    return result;
  }

  static Map<String, dynamic> _jobToJson(
    NormalizedJobPosting job,
  ) {
    return <String, dynamic>{
      'id': job.id,
      'companyId': job.companyId,
      'companyName': job.companyName,
      'title': job.title,
      'description': job.description.length <= 900
          ? job.description
          : job.description.substring(0, 900),
      'location': job.location,
      'department': job.department,
      'team': job.team,
      'employmentType': job.employmentType,
      'workplaceType': job.workplaceType,
      'applyUrl': job.applyUrl,
      'publishedAt': job.publishedAt?.toIso8601String(),
      'sourceType': job.sourceType.name,
      'sourceUrl': job.sourceUrl,
      'compensation': job.compensation == null
          ? null
          : _compensationToJson(job.compensation!),
      'rawMetadata': job.rawMetadata,
    };
  }

  static Map<String, dynamic> _compensationToJson(
    CompanyCompensation compensation,
  ) {
    return <String, dynamic>{
      'minimum': compensation.minimum,
      'maximum': compensation.maximum,
      'currency': compensation.currency,
      'period': compensation.period,
      'location': compensation.location,
      'sourceUrl': compensation.sourceUrl,
      'observedAt': compensation.observedAt.toIso8601String(),
    };
  }

  static Map<String, dynamic> _snapshotToJson(
    CompanyIntelligenceSnapshot snapshot,
  ) {
    return <String, dynamic>{
      'companyId': snapshot.companyId,
      'companyName': snapshot.companyName,
      'status': snapshot.status.name,
      'truthLabel': snapshot.truthLabel,
      'roles': snapshot.roles,
      'skills': snapshot.skills,
      'technologies': snapshot.technologies,
      'engineeringConcepts': snapshot.engineeringConcepts,
      'compensation': snapshot.compensation
          .map(_compensationToJson)
          .toList(growable: false),
      'liveJobs': snapshot.liveJobs.map(_jobToJson).toList(growable: false),
      'generatedAt': snapshot.generatedAt.toIso8601String(),
      'oldestEvidenceAt': snapshot.oldestEvidenceAt?.toIso8601String(),
      'newestEvidenceAt': snapshot.newestEvidenceAt?.toIso8601String(),
      'sources': snapshot.sources
          .map(
            (source) => <String, dynamic>{
              'sourceId': source.sourceId,
              'type': source.type.name,
              'companyId': source.companyId,
              'companyName': source.companyName,
              'sourceUrl': source.sourceUrl,
              'sourceLabel': source.sourceLabel,
              'isOfficialCompanySource': source.isOfficialCompanySource,
              'supportsLiveJobs': source.supportsLiveJobs,
              'supportsCompensation': source.supportsCompensation,
              'lastFetchedAt': source.lastFetchedAt?.toIso8601String(),
            },
          )
          .toList(growable: false),
    };
  }

  /// Staging/production need an explicit origin list; development allows
  /// http://localhost and http://127.0.0.1 browser origins. Native apps send
  /// no Origin header. X-Firebase-AppCheck is allowed for browser clients.
  static bool _applyCors(HttpRequest request) {
    final response = request.response;

    final origin = request.headers.value('origin');

    final configuredOrigins = _envStr('CAREER_GUIDE_ALLOWED_ORIGINS')
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toSet();

    var allowed = origin == null;

    if (origin != null) {
      if (_config?.isStrict == true) {
        allowed = configuredOrigins.contains(origin);
      } else {
        final uri = Uri.tryParse(origin);

        allowed = uri != null &&
            uri.scheme == 'http' &&
            const <String>{'localhost', '127.0.0.1'}
                .contains(uri.host.toLowerCase());
      }
    }

    response.headers
      ..set('Vary', 'Origin')
      ..set('X-Content-Type-Options', 'nosniff')
      ..set('Cache-Control', 'no-store')
      ..set('Access-Control-Allow-Headers',
          'Content-Type, Authorization, X-Firebase-AppCheck')
      ..set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
      ..contentType = ContentType.json;

    if (origin != null && allowed) {
      response.headers.set('Access-Control-Allow-Origin', origin);
    }

    return allowed;
  }

  static Future<void> _writeJson(
    HttpResponse response,
    int statusCode,
    Map<String, dynamic> data,
  ) async {
    var encoded = jsonEncode(data);

    if (utf8.encode(encoded).length > _maxResponseBytes) {
      statusCode = HttpStatus.badGateway;

      encoded = jsonEncode(<String, dynamic>{
        'success': false,
        'error': 'The ingestion response exceeded the allowed size.',
      });
    }

    response.statusCode = statusCode;

    response.headers.contentType = ContentType.json;

    response.headers.set(HttpHeaders.cacheControlHeader, 'no-store');

    if (_config?.isStrict == true) {
      response.headers.set('Strict-Transport-Security', 'max-age=31536000');
    }

    response.write(encoded);

    await response.close();
  }
}

class _RequestTooLargeException implements Exception {
  const _RequestTooLargeException();
}

class _UpstreamTooLargeException implements Exception {
  const _UpstreamTooLargeException();
}

class _RetryableUpstreamException implements Exception {
  final int statusCode;

  const _RetryableUpstreamException(this.statusCode);
}

class _BodyTimeout implements Exception {
  const _BodyTimeout();
}

/// Provider data that could not be used (wrong shape / unparsable). The
/// caller only ever sees a generic message.
class _UpstreamInvalid implements Exception {
  const _UpstreamInvalid();
}

/// A request refused by an in-flight limit.
class _Denied implements Exception {
  const _Denied(this.status, this.error, this.retryAfterSeconds);
  final int status;
  final String error;
  final int retryAfterSeconds;
}

class _CachedPayload {
  const _CachedPayload(this.payload, this.fetchedAt);

  /// The (compacted, shape-validated) provider payload.
  final String payload;

  /// When the provider was really queried.
  final DateTime fetchedAt;
}

class _IngestionRequest {
  final String companyId;

  final String companyName;

  final CompanySourceType sourceType;

  final String sourceUrl;

  final String? payload;

  const _IngestionRequest({
    required this.companyId,
    required this.companyName,
    required this.sourceType,
    required this.sourceUrl,
    required this.payload,
  });
}

/// Dart executable entry point.
Future<void> main() async {
  try {
    await CompanyIntelligenceIngestionServer.start();
  } on StateError catch (e) {
    // Fail closed with a clear, secret-free message.
    stderr.writeln('Company Intelligence ingestion cannot start: ${e.message}');
    exit(78);
  }
}