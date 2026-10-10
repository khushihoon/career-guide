import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../lib/services/company_intelligence_models.dart';
import '../lib/services/company_intelligence_live_source_catalog.dart';
import '../lib/services/company_source_adapters.dart';
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
///   dart run backend/company_intelligence_ingestion_server.dart
///
/// Default:
///   http://localhost:8091
///
/// Endpoints:
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
/// IMPORTANT:
/// - This development server only consumes URLs explicitly supplied by the
///   caller.
/// - It does not scrape HTML pages.
/// - It does not invent skills, roles, salary, or hiring information.
/// - Skills/roles/technology fields are derived only from normalized job
///   evidence using the deterministic keyword extraction below.
/// - A company with zero live jobs is not presented as currently hiring.
class CompanyIntelligenceIngestionServer {
  static int get port => int.tryParse(Platform.environment['PORT'] ?? '') ?? 8091;
  static const int _maxRequestBytes = 64 * 1024;
  static const int _maxUpstreamBytes = 2 * 1024 * 1024;
  static const int _maxResponseBytes = 6 * 1024 * 1024;
  static const int _maxRequestsPerMinute = 30;
  static const CompanySourceAdapterRegistry _adapterRegistry = CompanySourceAdapterRegistry();
  static const CompanyIntelligenceLiveSourceCatalog _sourceCatalog = CompanyIntelligenceLiveSourceCatalog();
  static final Map<String, List<DateTime>> _requestTimes = <String, List<DateTime>>{};

  static bool get _productionMode =>
      (Platform.environment['CAREER_GUIDE_ENV'] ?? '').toLowerCase() == 'production';
  static bool get _authRequired => _productionMode ||
      (Platform.environment['CAREER_GUIDE_REQUIRE_AUTH'] ?? '').toLowerCase() == 'true';

  static Future<void> start() async {
    final bindAddress = (Platform.environment['CAREER_GUIDE_BIND_ADDRESS'] ?? '127.0.0.1').trim();
    if (_authRequired && (Platform.environment['FIREBASE_WEB_API_KEY'] ?? '').trim().isEmpty) {
      throw StateError('FIREBASE_WEB_API_KEY is required when backend authentication is enabled.');
    }
    final server = await HttpServer.bind(InternetAddress(bindAddress), port, shared: true);
    stdout.writeln('Company Intelligence ingestion backend running on ${server.address.address}:$port');
    stdout.writeln('Health: http://localhost:$port/health');
    stdout.writeln('Mode: ${_productionMode ? 'production' : 'local development ingestion'}');
    stdout.writeln('Firebase ID-token verification: ${_authRequired ? 'required' : 'disabled (local development only)'}');
    await for (final request in server) {
      // Do not let one slow provider request block health checks or other users.
      unawaited(_handleRequest(request));
    }
  }

  static Future<void> _handleRequest(HttpRequest request) async {
    final originAllowed = _applyCors(request);
    if (!originAllowed) {
      await _writeJson(request.response, HttpStatus.forbidden,
          <String, dynamic>{'success': false, 'error': 'Origin is not allowed.'});
      return;
    }
    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.noContent;
      await request.response.close();
      return;
    }
    try {
      if (!_checkRateLimit(request)) {
        request.response.headers.set('Retry-After', '60');
        await _writeJson(request.response, HttpStatus.tooManyRequests,
            <String, dynamic>{'success': false, 'error': 'Too many requests. Please try again shortly.'});
        return;
      }
      if (request.method == 'POST' && _authRequired &&
          !await _isFirebaseUserAuthenticated(request)) {
        await _writeJson(request.response, HttpStatus.unauthorized,
            <String, dynamic>{'success': false, 'error': 'A valid Firebase sign-in is required.'});
        return;
      }
      if (request.method == 'GET' && request.uri.path == '/health') {
        await _writeJson(request.response, HttpStatus.ok, <String, dynamic>{
          'success': true,
          'service': 'company_intelligence_ingestion',
          'port': port,
          'status': 'running',
          'mode': _productionMode ? 'production' : 'local_development',
        });
        return;
      }
      if (request.method == 'POST' && request.uri.path == '/ingest') {
        await _handleIngest(request);
        return;
      }
      if (request.method == 'POST' && request.uri.path == '/ingest/source') {
        await _handleSourceIngest(request);
        return;
      }
      await _writeJson(request.response, HttpStatus.notFound, <String, dynamic>{
        'success': false,
        'error': 'Unknown ingestion endpoint.',
        'availableEndpoints': <String>['GET /health', 'POST /ingest', 'POST /ingest/source'],
      });
    } on _RequestTooLargeException {
      await _writeJson(request.response, 413,
          <String, dynamic>{'success': false, 'error': 'Request body exceeds the allowed size.'});
    } on _UpstreamTooLargeException {
      await _writeJson(request.response, HttpStatus.badGateway,
          <String, dynamic>{'success': false, 'error': 'The trusted source response exceeded the allowed size.'});
    } on FormatException catch (error) {
      await _writeJson(request.response, HttpStatus.badRequest,
          <String, dynamic>{'success': false, 'error': error.message});
    } on TimeoutException {
      await _writeJson(request.response, HttpStatus.gatewayTimeout,
          <String, dynamic>{'success': false, 'error': 'The source request timed out.'});
    } catch (error, stackTrace) {
      // Avoid logging payloads, tokens, provider response bodies, or raw URLs.
      stderr.writeln('Company Intelligence ingestion failure (${error.runtimeType}).');
      if (!_productionMode) stderr.writeln(stackTrace);
      await _writeJson(request.response, HttpStatus.badGateway,
          <String, dynamic>{'success': false, 'error': 'Company Intelligence ingestion failed safely.'});
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
  static Future<void> _handleSourceIngest(HttpRequest request) async {
    final body = await _readJsonObject(request);
    final requestData = _parseIngestionRequest(
      body,
      requirePayload: false,
    );
    final payload = await _fetchSource(
      requestData.sourceUrl,
    );
    final result = _parsePayload(
      requestData: requestData,
      payload: payload,
    );
    await _writeJson(
      request.response,
      HttpStatus.ok,
      result,
    );
  }
  static Future<Map<String, dynamic>> _readJsonObject(HttpRequest request) async {
    if (request.contentLength > _maxRequestBytes) throw const _RequestTooLargeException();
    final bytes = BytesBuilder(copy: false);
    await for (final chunk in request) {
      if (bytes.length + chunk.length > _maxRequestBytes) throw const _RequestTooLargeException();
      bytes.add(chunk);
    }
    final body = utf8.decode(bytes.takeBytes());
    if (body.trim().isEmpty) throw const FormatException('Request body is empty.');
    final decoded = jsonDecode(body);
    if (decoded is! Map) throw const FormatException('Request body must be a JSON object.');
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
    _validateAgainstTrustedCatalog(companyId: companyId, companyName: companyName, sourceType: sourceType, sourceUrl: sourceUrl);
    final payload = body['payload']?.toString();
    if (requirePayload &&
        (payload == null || payload.trim().isEmpty)) {
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
    final fetchedAt = DateTime.now().toUtc();
    final jobs = adapter.parse(
      companyId: requestData.companyId,
      companyName: requestData.companyName,
      sourceUrl: requestData.sourceUrl,
      payload: payload,
      fetchedAt: fetchedAt,
    );
    final snapshot = _buildSnapshot(
      companyId: requestData.companyId,
      companyName: requestData.companyName,
      sourceType: requestData.sourceType,
      sourceUrl: requestData.sourceUrl,
      jobs: jobs,
      generatedAt: fetchedAt,
    );
    return <String, dynamic>{
      'success': true,
      'companyId': requestData.companyId,
      'companyName': requestData.companyName,
      'sourceType': requestData.sourceType.name,
      'sourceUrl': requestData.sourceUrl,
      'fetchedAt': fetchedAt.toIso8601String(),
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
      ..idleTimeout = const Duration(seconds: 5);
    try {
      final request = await client.getUrl(uri).timeout(const Duration(seconds: 5));
      // Redirects are deliberately disabled: a trusted ATS URL cannot redirect
      // the server to an untrusted/private network destination.
      request.followRedirects = false;
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.userAgentHeader, 'CareerGuide-CompanyIntelligence/6E-4');
      final response = await request.close().timeout(const Duration(seconds: 5));
      if (response.statusCode == HttpStatus.tooManyRequests ||
          response.statusCode == HttpStatus.internalServerError ||
          response.statusCode == HttpStatus.badGateway ||
          response.statusCode == HttpStatus.serviceUnavailable ||
          response.statusCode == HttpStatus.gatewayTimeout) {
        throw _RetryableUpstreamException(response.statusCode);
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException('Trusted source returned a non-success status.', uri: uri);
      }
      if (response.contentLength > _maxUpstreamBytes) {
        throw const _UpstreamTooLargeException();
      }
      final bytes = BytesBuilder(copy: false);
      await for (final chunk in response.timeout(const Duration(seconds: 5))) {
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
    if (config == null || config.companyId != companyId ||
        config.companyName != companyName || config.sourceType != sourceType ||
        config.sourceUrl != sourceUrl || !config.isOfficialCompanySource ||
        !config.supportsLiveJobs) {
      throw const FormatException('Requested company/source is not present in the trusted live-source allowlist.');
    }
  }

  static bool _checkRateLimit(HttpRequest request) {
    final key = request.connectionInfo?.remoteAddress.address ?? 'unknown';
    final now = DateTime.now().toUtc();
    final cutoff = now.subtract(const Duration(minutes: 1));
    final recent = (_requestTimes[key] ?? <DateTime>[]).where((time) => time.isAfter(cutoff)).toList();
    if (recent.length >= _maxRequestsPerMinute) {
      _requestTimes[key] = recent;
      return false;
    }
    recent.add(now);
    _requestTimes[key] = recent;
    return true;
  }

  static Future<bool> _isFirebaseUserAuthenticated(HttpRequest request) async {
    final authorization = request.headers.value(HttpHeaders.authorizationHeader);
    if (authorization == null || !authorization.startsWith('Bearer ')) return false;
    final idToken = authorization.substring('Bearer '.length).trim();
    if (idToken.isEmpty || idToken.length > 8192) return false;
    final apiKey = (Platform.environment['FIREBASE_WEB_API_KEY'] ?? '').trim();
    if (apiKey.isEmpty) return false;
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 4);
    try {
      final uri = Uri.https('identitytoolkit.googleapis.com', '/v1/accounts:lookup', <String, String>{'key': apiKey});
      final outgoing = await client.postUrl(uri).timeout(const Duration(seconds: 5));
      outgoing.headers.contentType = ContentType.json;
      outgoing.write(jsonEncode(<String, String>{'idToken': idToken}));
      final response = await outgoing.close().timeout(const Duration(seconds: 5));
      if (response.statusCode != HttpStatus.ok) return false;
      final bytes = BytesBuilder(copy: false);
      await for (final chunk in response.timeout(const Duration(seconds: 5))) {
        if (bytes.length + chunk.length > 32 * 1024) return false;
        bytes.add(chunk);
      }
      final decoded = jsonDecode(utf8.decode(bytes.takeBytes()));
      return decoded is Map && decoded['users'] is List && (decoded['users'] as List).isNotEmpty;
    } catch (_) {
      return false;
    } finally {
      client.close(force: true);
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
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty) {
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
    final dates = jobs
        .map((job) => job.publishedAt)
        .whereType<DateTime>()
        .toList();
    if (dates.isEmpty) return null;
    dates.sort();
    return dates.first;
  }
  static DateTime? _newestJobEvidence(
    List<NormalizedJobPosting> jobs,
  ) {
    final dates = jobs
        .map((job) => job.publishedAt)
        .whereType<DateTime>()
        .toList();
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
      'description': job.description,
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
      'liveJobs': snapshot.liveJobs
          .map(_jobToJson)
          .toList(growable: false),
      'generatedAt': snapshot.generatedAt.toIso8601String(),
      'oldestEvidenceAt':
          snapshot.oldestEvidenceAt?.toIso8601String(),
      'newestEvidenceAt':
          snapshot.newestEvidenceAt?.toIso8601String(),
      'sources': snapshot.sources
          .map(
            (source) => <String, dynamic>{
              'sourceId': source.sourceId,
              'type': source.type.name,
              'companyId': source.companyId,
              'companyName': source.companyName,
              'sourceUrl': source.sourceUrl,
              'sourceLabel': source.sourceLabel,
              'isOfficialCompanySource':
                  source.isOfficialCompanySource,
              'supportsLiveJobs': source.supportsLiveJobs,
              'supportsCompensation':
                  source.supportsCompensation,
              'lastFetchedAt':
                  source.lastFetchedAt?.toIso8601String(),
            },
          )
          .toList(growable: false),
    };
  }
  static bool _applyCors(HttpRequest request) {
    final response = request.response;
    final origin = request.headers.value('origin');
    final configuredOrigins = (Platform.environment['CAREER_GUIDE_ALLOWED_ORIGINS'] ?? '')
        .split(',').map((value) => value.trim()).where((value) => value.isNotEmpty).toSet();
    var allowed = origin == null;
    if (origin != null) {
      if (_productionMode) {
        allowed = configuredOrigins.contains(origin);
      } else {
        final uri = Uri.tryParse(origin);
        allowed = uri != null && uri.scheme == 'http' &&
            const <String>{'localhost', '127.0.0.1'}.contains(uri.host.toLowerCase());
      }
    }
    response.headers
      ..set('Vary', 'Origin')
      ..set('X-Content-Type-Options', 'nosniff')
      ..set('Cache-Control', 'no-store')
      ..set('Access-Control-Allow-Headers', 'Content-Type, Authorization')
      ..set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
      ..contentType = ContentType.json;
    if (origin != null && allowed) response.headers.set('Access-Control-Allow-Origin', origin);
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
  await CompanyIntelligenceIngestionServer.start();
}
