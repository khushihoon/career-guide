import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../lib/services/company_intelligence_models.dart';
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
  static const int port = 8091;

  static const CompanySourceAdapterRegistry _adapterRegistry =
      CompanySourceAdapterRegistry();

  static Future<void> start() async {
    final server = await HttpServer.bind(
      InternetAddress.anyIPv4,
      port,
      shared: true,
    );

    stdout.writeln(
      'Company Intelligence ingestion backend running on port $port',
    );
    stdout.writeln(
      'Health: http://localhost:$port/health',
    );
    stdout.writeln(
      'Mode: local development ingestion',
    );

    await for (final request in server) {
      await _handleRequest(request);
    }
  }

  static Future<void> _handleRequest(HttpRequest request) async {
    _applyCors(request.response);

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.noContent;
      await request.response.close();
      return;
    }

    try {
      if (request.method == 'GET' && request.uri.path == '/health') {
        await _writeJson(
          request.response,
          HttpStatus.ok,
          <String, dynamic>{
            'success': true,
            'service': 'company_intelligence_ingestion',
            'port': port,
            'status': 'running',
            'mode': 'local_development',
            'timestamp': DateTime.now().toUtc().toIso8601String(),
          },
        );
        return;
      }

      if (request.method == 'POST' && request.uri.path == '/ingest') {
        await _handleIngest(request);
        return;
      }

      if (request.method == 'POST' &&
          request.uri.path == '/ingest/source') {
        await _handleSourceIngest(request);
        return;
      }

      await _writeJson(
        request.response,
        HttpStatus.notFound,
        <String, dynamic>{
          'success': false,
          'error': 'Unknown ingestion endpoint.',
          'availableEndpoints': <String>[
            'GET /health',
            'POST /ingest',
            'POST /ingest/source',
          ],
        },
      );
    } catch (error, stackTrace) {
      stderr.writeln('Company Intelligence ingestion error: $error');
      stderr.writeln(stackTrace);

      if (request.response.headers.contentType != null ||
          request.response.headers.contentLength != null) {
        return;
      }

      await _writeJson(
        request.response,
        HttpStatus.internalServerError,
        <String, dynamic>{
          'success': false,
          'error': 'Company Intelligence ingestion failed.',
          'details': error.toString(),
        },
      );
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

  static Future<Map<String, dynamic>> _readJsonObject(
    HttpRequest request,
  ) async {
    final body = await utf8.decoder.bind(request).join();

    if (body.trim().isEmpty) {
      throw const FormatException('Request body is empty.');
    }

    final decoded = jsonDecode(body);

    if (decoded is! Map) {
      throw const FormatException(
        'Request body must be a JSON object.',
      );
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
      'jobCount': jobs.length,
      'jobs': jobs.map(_jobToJson).toList(growable: false),
      'snapshot': _snapshotToJson(snapshot),
    };
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

  static Future<String> _fetchSource(String sourceUrl) async {
    final uri = Uri.parse(sourceUrl);

    final client = HttpClient();

    try {
      final request = await client.getUrl(uri);

      request.headers.set(
        HttpHeaders.acceptHeader,
        'application/json',
      );

      request.headers.set(
        HttpHeaders.userAgentHeader,
        'CareerGuide-CompanyIntelligence/6E-4',
      );

      final response = await request.close();

      final payload = await utf8.decoder.bind(response).join();

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw HttpException(
          'Source returned HTTP ${response.statusCode}.',
          uri: uri,
        );
      }

      return payload;
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

  static void _applyCors(HttpResponse response) {
    response.headers
      ..set('Access-Control-Allow-Origin', '*')
      ..set(
        'Access-Control-Allow-Headers',
        'Content-Type',
      )
      ..set(
        'Access-Control-Allow-Methods',
        'GET, POST, OPTIONS',
      )
      ..contentType = ContentType.json;
  }

  static Future<void> _writeJson(
    HttpResponse response,
    int statusCode,
    Map<String, dynamic> data,
  ) async {
    response.statusCode = statusCode;
    response.headers.contentType = ContentType.json;
    response.write(jsonEncode(data));
    await response.close();
  }
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
