// ============================================================================
// lib/services/home_live_jobs_service.dart
//
// CAREER GUIDE — STEP 5A
// REAL LIVE JOB DATA ENGINE
//
// PURPOSE
// -------
// Fetch CURRENT publicly published jobs from supported public ATS/job-board
// endpoints without requiring an API key.
//
// CURRENT SOURCES
// ---------------
// • Greenhouse public Job Board endpoint
// • Lever public Postings endpoint
// • Ashby public Job Board endpoint
//
// IMPORTANT PRODUCT RULES
// -----------------------
// • Never invent a job.
// • Never invent salary.
// • Never invent requirements.
// • Never display null/empty values.
// • Only show currently published/listed jobs.
// • Only show jobs relevant to engineering / AI / ML / data / software.
// • Preserve official apply URL.
// • Preserve source information.
// • Deduplicate jobs.
// • Drop malformed records.
// • Do not touch Copilot.
// • Do not touch Roadmap learning-path logic.
// • Do not use kJobs.
// • Do not use Firebase.
// • Do not use paid AI/API.
//
// FUTURE READY
// ------------
// Additional providers can be added as adapters without changing Home UI.
//
// ============================================================================

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

// ============================================================================
// PUBLIC NORMALIZED MODEL
// ============================================================================

class LiveJobOpportunity {
  final String id;
  final String title;
  final String company;
  final String location;

  final String? workplaceType;
  final String? employmentType;

  final String? salary;
  final List<String> skills;
  final String? description;

  final String applyUrl;
  final String source;

  final DateTime? publishedAt;
  final DateTime? updatedAt;
  final DateTime fetchedAt;

  const LiveJobOpportunity({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    this.workplaceType,
    this.employmentType,
    this.salary,
    this.skills = const [],
    this.description,
    required this.applyUrl,
    required this.source,
    this.publishedAt,
    this.updatedAt,
    required this.fetchedAt,
  });

  bool get hasSalary =>
      salary != null && salary!.trim().isNotEmpty;

  bool get hasSkills => skills.isNotEmpty;

  bool get hasDescription =>
      description != null && description!.trim().isNotEmpty;

  bool get hasWorkplaceType =>
      workplaceType != null && workplaceType!.trim().isNotEmpty;

  LiveJobOpportunity copyWith({
    String? id,
    String? title,
    String? company,
    String? location,
    String? workplaceType,
    String? employmentType,
    String? salary,
    List<String>? skills,
    String? description,
    String? applyUrl,
    String? source,
    DateTime? publishedAt,
    DateTime? updatedAt,
    DateTime? fetchedAt,
  }) {
    return LiveJobOpportunity(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      workplaceType: workplaceType ?? this.workplaceType,
      employmentType: employmentType ?? this.employmentType,
      salary: salary ?? this.salary,
      skills: skills ?? this.skills,
      description: description ?? this.description,
      applyUrl: applyUrl ?? this.applyUrl,
      source: source ?? this.source,
      publishedAt: publishedAt ?? this.publishedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }
}

// ============================================================================
// SOURCE CONFIG
// ============================================================================

enum LiveJobSourceType {
  greenhouse,
  lever,
  ashby,
}

class LiveJobBoardConfig {
  final String company;
  final String boardSlug;
  final LiveJobSourceType source;

  const LiveJobBoardConfig({
    required this.company,
    required this.boardSlug,
    required this.source,
  });
}

// ============================================================================
// SERVICE RESULT
// ============================================================================

class LiveJobsResult {
  final List<LiveJobOpportunity> jobs;
  final DateTime fetchedAt;

  /// Number of jobs received before relevance filtering.
  final int rawCount;

  /// Number of jobs dropped because they were invalid/irrelevant/duplicate.
  final int droppedCount;

  /// Sources that successfully returned data.
  final List<String> successfulSources;

  /// Sources that failed.
  final List<String> failedSources;

  const LiveJobsResult({
    required this.jobs,
    required this.fetchedAt,
    required this.rawCount,
    required this.droppedCount,
    required this.successfulSources,
    required this.failedSources,
  });

  bool get hasJobs => jobs.isNotEmpty;
}

// ============================================================================
// SERVICE
// ============================================================================

class HomeLiveJobsService {
  HomeLiveJobsService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;

  static const Duration _requestTimeout =
      Duration(seconds: 12);

  // --------------------------------------------------------------------------
  // SOURCE REGISTRY
  //
  // IMPORTANT:
  // These are ONLY verified board configurations.
  //
  // Do NOT add a company here merely because it is famous.
  //
  // The board slug must be verified against that company's actual public
  // careers/ATS board before being added.
  // --------------------------------------------------------------------------

  static const List<LiveJobBoardConfig> _boards = [
    // Example structure:
    //
    // LiveJobBoardConfig(
    //   company: 'Company Name',
    //   boardSlug: 'verified-board-slug',
    //   source: LiveJobSourceType.greenhouse,
    // ),
    //
    // LiveJobBoardConfig(
    //   company: 'Company Name',
    //   boardSlug: 'verified-board-slug',
    //   source: LiveJobSourceType.ashby,
    // ),
    //
    // LiveJobBoardConfig(
    //   company: 'Company Name',
    //   boardSlug: 'verified-board-slug',
    //   source: LiveJobSourceType.lever,
    // ),
  ];

  // --------------------------------------------------------------------------
  // PUBLIC API
  // --------------------------------------------------------------------------

  Future<LiveJobsResult> fetchLiveJobs({
    int maxJobsPerCompany = 50,
  }) async {
    final fetchedAt = DateTime.now().toUtc();

    if (_boards.isEmpty) {
      return LiveJobsResult(
        jobs: const [],
        fetchedAt: fetchedAt,
        rawCount: 0,
        droppedCount: 0,
        successfulSources: const [],
        failedSources: const [],
      );
    }

    final results = await Future.wait(
      _boards.map(
        (board) => _fetchBoard(
          board,
          maxJobs: maxJobsPerCompany,
        ),
      ),
    );

    final allJobs = <LiveJobOpportunity>[];

    final successfulSources = <String>[];
    final failedSources = <String>[];

    for (final result in results) {
      if (result.success) {
        successfulSources.add(result.sourceName);
        allJobs.addAll(result.jobs);
      } else {
        failedSources.add(result.sourceName);
      }
    }

    final rawCount = allJobs.length;

    final filtered = _filterAndNormalize(allJobs);

    final deduped = _deduplicate(filtered);

    return LiveJobsResult(
      jobs: deduped,
      fetchedAt: fetchedAt,
      rawCount: rawCount,
      droppedCount: rawCount - deduped.length,
      successfulSources: successfulSources,
      failedSources: failedSources,
    );
  }

  // --------------------------------------------------------------------------
  // BOARD FETCH
  // --------------------------------------------------------------------------

  Future<_BoardFetchResult> _fetchBoard(
    LiveJobBoardConfig board, {
    required int maxJobs,
  }) async {
    try {
      switch (board.source) {
        case LiveJobSourceType.greenhouse:
          return await _fetchGreenhouse(
            board,
            maxJobs: maxJobs,
          );

        case LiveJobSourceType.lever:
          return await _fetchLever(
            board,
            maxJobs: maxJobs,
          );

        case LiveJobSourceType.ashby:
          return await _fetchAshby(
            board,
            maxJobs: maxJobs,
          );
      }
    } catch (_) {
      return _BoardFetchResult.failure(
        sourceName: _sourceLabel(board.source),
      );
    }
  }

  // ==========================================================================
  // GREENHOUSE
  // ==========================================================================

  Future<_BoardFetchResult> _fetchGreenhouse(
    LiveJobBoardConfig board, {
    required int maxJobs,
  }) async {
    final uri = Uri.parse(
      'https://boards-api.greenhouse.io/v1/boards/'
      '${Uri.encodeComponent(board.boardSlug)}/jobs'
      '?content=true',
    );

    final response = await _get(uri);

    if (response.statusCode != 200) {
      return _BoardFetchResult.failure(
        sourceName: 'Greenhouse',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      return _BoardFetchResult.failure(
        sourceName: 'Greenhouse',
      );
    }

    final jobs = decoded['jobs'];

    if (jobs is! List) {
      return _BoardFetchResult.success(
        sourceName: 'Greenhouse',
        jobs: const [],
      );
    }

    final output = <LiveJobOpportunity>[];

    for (final raw in jobs.take(maxJobs)) {
      if (raw is! Map) continue;

      final job = _parseGreenhouseJob(
        raw,
        company: board.company,
      );

      if (job != null) {
        output.add(job);
      }
    }

    return _BoardFetchResult.success(
      sourceName: 'Greenhouse',
      jobs: output,
    );
  }

  LiveJobOpportunity? _parseGreenhouseJob(
    Map raw, {
    required String company,
  }) {
    final id = _string(raw['id']);
    final title = _string(raw['title']);
    final absoluteUrl = _string(raw['absolute_url']);

    if (id == null ||
        title == null ||
        absoluteUrl == null ||
        !_isHttpUrl(absoluteUrl)) {
      return null;
    }

    final locationObject = raw['location'];

    String location = '';

    if (locationObject is Map) {
      location =
          _string(locationObject['name']) ?? '';
    }

    final content = _stripHtml(
      _string(raw['content']),
    );

    final skills = _extractSkills(
      '$title $content',
    );

    final publishedAt = _parseDate(
      raw['first_published'],
    );

    final updatedAt = _parseDate(
      raw['updated_at'],
    );

    return LiveJobOpportunity(
      id: 'greenhouse:$company:$id',
      title: title,
      company: company,
      location: location,
      employmentType: null,
      workplaceType: null,
      salary: null,
      skills: skills,
      description: _cleanNullable(content),
      applyUrl: absoluteUrl,
      source: 'Greenhouse',
      publishedAt: publishedAt,
      updatedAt: updatedAt,
      fetchedAt: DateTime.now().toUtc(),
    );
  }

  // ==========================================================================
  // LEVER
  // ==========================================================================

  Future<_BoardFetchResult> _fetchLever(
    LiveJobBoardConfig board, {
    required int maxJobs,
  }) async {
    final uri = Uri.parse(
      'https://api.lever.co/v0/postings/'
      '${Uri.encodeComponent(board.boardSlug)}'
      '?mode=json',
    );

    final response = await _get(uri);

    if (response.statusCode != 200) {
      return _BoardFetchResult.failure(
        sourceName: 'Lever',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      return _BoardFetchResult.success(
        sourceName: 'Lever',
        jobs: const [],
      );
    }

    final output = <LiveJobOpportunity>[];

    for (final raw in decoded.take(maxJobs)) {
      if (raw is! Map) continue;

      final job = _parseLeverJob(
        raw,
        company: board.company,
      );

      if (job != null) {
        output.add(job);
      }
    }

    return _BoardFetchResult.success(
      sourceName: 'Lever',
      jobs: output,
    );
  }

  LiveJobOpportunity? _parseLeverJob(
    Map raw, {
    required String company,
  }) {
    final id = _string(raw['id']);
    final title = _string(raw['text']);
    final applyUrl = _string(raw['hostedUrl']);

    if (id == null ||
        title == null ||
        applyUrl == null ||
        !_isHttpUrl(applyUrl)) {
      return null;
    }

    final categories = raw['categories'];

    String location = '';

    if (categories is Map) {
      location =
          _string(categories['location']) ?? '';
    }

    final description = _stripHtml(
      _string(raw['descriptionPlain']) ??
          _string(raw['description']),
    );

    final commitment = categories is Map
        ? _string(categories['commitment'])
        : null;

    final workplaceType = categories is Map
        ? _string(categories['workplaceType'])
        : null;

    final salary = _extractLeverSalary(raw);

    final skills = _extractSkills(
      '$title ${description ?? ''}',
    );

    return LiveJobOpportunity(
      id: 'lever:$company:$id',
      title: title,
      company: company,
      location: location,
      employmentType: _cleanNullable(commitment),
      workplaceType: _cleanNullable(workplaceType),
      salary: salary,
      skills: skills,
      description: _cleanNullable(description),
      applyUrl: applyUrl,
      source: 'Lever',
      publishedAt: _parseDate(raw['createdAt']),
      updatedAt: _parseDate(raw['updatedAt']),
      fetchedAt: DateTime.now().toUtc(),
    );
  }

  String? _extractLeverSalary(Map raw) {
    final salary = raw['salary'];

    if (salary is! Map) {
      return null;
    }

    final min = salary['min'];
    final max = salary['max'];
    final currency = _string(salary['currency']);
    final interval = _string(salary['interval']);

    if (min == null && max == null) {
      return null;
    }

    final values = <String>[];

    if (min != null) {
      values.add(min.toString());
    }

    if (max != null) {
      values.add(max.toString());
    }

    if (values.isEmpty) {
      return null;
    }

    final range = values.join('–');

    return [
      if (currency != null && currency.isNotEmpty) currency,
      range,
      if (interval != null && interval.isNotEmpty) '/ $interval',
    ].join(' ').trim();
  }

  // ==========================================================================
  // ASHBY
  // ==========================================================================

  Future<_BoardFetchResult> _fetchAshby(
    LiveJobBoardConfig board, {
    required int maxJobs,
  }) async {
    final uri = Uri.parse(
      'https://api.ashbyhq.com/posting-api/job-board/'
      '${Uri.encodeComponent(board.boardSlug)}'
      '?includeCompensation=true',
    );

    final response = await _get(uri);

    if (response.statusCode != 200) {
      return _BoardFetchResult.failure(
        sourceName: 'Ashby',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      return _BoardFetchResult.failure(
        sourceName: 'Ashby',
      );
    }

    final jobs = decoded['jobs'];

    if (jobs is! List) {
      return _BoardFetchResult.success(
        sourceName: 'Ashby',
        jobs: const [],
      );
    }

    final output = <LiveJobOpportunity>[];

    for (final raw in jobs.take(maxJobs)) {
      if (raw is! Map) continue;

      final job = _parseAshbyJob(
        raw,
        company: board.company,
      );

      if (job != null) {
        output.add(job);
      }
    }

    return _BoardFetchResult.success(
      sourceName: 'Ashby',
      jobs: output,
    );
  }

  LiveJobOpportunity? _parseAshbyJob(
    Map raw, {
    required String company,
  }) {
    final id = _string(raw['jobUrl']) ??
        _string(raw['applyUrl']);

    final title = _string(raw['title']);

    final applyUrl = _string(raw['applyUrl']) ??
        _string(raw['jobUrl']);

    if (id == null ||
        title == null ||
        applyUrl == null ||
        !_isHttpUrl(applyUrl)) {
      return null;
    }

    final location =
        _string(raw['location']) ?? '';

    final description =
        _cleanNullable(
          _string(raw['descriptionPlain']) ??
              _stripHtml(
                _string(raw['descriptionHtml']),
              ),
        );

    final workplaceType =
        _string(raw['workplaceType']);

    final employmentType =
        _string(raw['employmentType']);

    final compensation =
        _string(raw['compensationTierSummary']);

    final skills = _extractSkills(
      '$title ${description ?? ''}',
    );

    return LiveJobOpportunity(
      id: 'ashby:$company:$id',
      title: title,
      company: company,
      location: location,
      workplaceType: _cleanNullable(workplaceType),
      employmentType: _cleanNullable(employmentType),
      salary: _cleanNullable(compensation),
      skills: skills,
      description: description,
      applyUrl: applyUrl,
      source: 'Ashby',
      publishedAt: _parseDate(raw['publishedAt']),
      updatedAt: _parseDate(raw['updatedAt']),
      fetchedAt: DateTime.now().toUtc(),
    );
  }

  // ==========================================================================
  // HTTP
  // ==========================================================================

  Future<http.Response> _get(Uri uri) async {
    return _client
        .get(
          uri,
          headers: const {
            'Accept': 'application/json',
            'User-Agent': 'CareerGuide/1.0',
          },
        )
        .timeout(_requestTimeout);
  }

  // ==========================================================================
  // VALIDATION + RELEVANCE
  // ==========================================================================

  List<LiveJobOpportunity> _filterAndNormalize(
    List<LiveJobOpportunity> jobs,
  ) {
    final output = <LiveJobOpportunity>[];

    for (final job in jobs) {
      if (!_isValidJob(job)) {
        continue;
      }

      if (!_isRelevantJob(job)) {
        continue;
      }

      output.add(
        _normalizeJob(job),
      );
    }

    return output;
  }

  bool _isValidJob(LiveJobOpportunity job) {
    if (job.title.trim().isEmpty) return false;
    if (job.company.trim().isEmpty) return false;
    if (job.applyUrl.trim().isEmpty) return false;
    if (!_isHttpUrl(job.applyUrl)) return false;

    // A job with no location can still be legitimate when remote.
    if (job.location.trim().isEmpty &&
        !(job.workplaceType?.toLowerCase().contains('remote') ??
            false)) {
      // We don't immediately reject it because some public boards don't
      // expose location consistently. The job may still be useful.
    }

    return true;
  }

  bool _isRelevantJob(LiveJobOpportunity job) {
    final searchable = [
      job.title,
      job.company,
      job.location,
      job.description ?? '',
      job.skills.join(' '),
    ].join(' ').toLowerCase();

    // Core engineering / technical career vocabulary.
    const positiveTerms = [
      'software engineer',
      'software developer',
      'backend engineer',
      'backend developer',
      'frontend engineer',
      'frontend developer',
      'full stack',
      'full-stack',
      'mobile engineer',
      'android engineer',
      'ios engineer',
      'machine learning',
      'ml engineer',
      'ai engineer',
      'artificial intelligence',
      'deep learning',
      'data scientist',
      'data engineer',
      'data analyst',
      'llm',
      'large language model',
      'generative ai',
      'research engineer',
      'research scientist',
      'computer vision',
      'nlp',
      'natural language processing',
      'robotics engineer',
      'platform engineer',
      'cloud engineer',
      'devops engineer',
      'site reliability',
      'sre',
      'security engineer',
      'cybersecurity',
      'infrastructure engineer',
      'systems engineer',
      'embedded engineer',
      'firmware engineer',
      'hardware engineer',
      'semiconductor',
    ];

    // Avoid unrelated business roles even if their description contains
    // generic technical words.
    const negativeTitleTerms = [
      'recruiter',
      'recruiting coordinator',
      'sales',
      'account executive',
      'marketing',
      'designer',
      'graphic designer',
      'legal',
      'finance',
      'accountant',
      'hr ',
      'human resources',
      'operations manager',
      'customer success',
      'business development',
    ];

    final title = job.title.toLowerCase();

    final hasNegativeTitle = negativeTitleTerms.any(
      title.contains,
    );

    if (hasNegativeTitle) {
      return false;
    }

    return positiveTerms.any(
      searchable.contains,
    );
  }

  LiveJobOpportunity _normalizeJob(
    LiveJobOpportunity job,
  ) {
    return job.copyWith(
      title: _cleanRequired(job.title),
      company: _cleanRequired(job.company),
      location: _cleanRequired(job.location),
      workplaceType: _cleanNullable(job.workplaceType),
      employmentType: _cleanNullable(job.employmentType),
      salary: _cleanNullable(job.salary),
      description: _cleanNullable(job.description),
      skills: _normalizeSkills(job.skills),
    );
  }

  // ==========================================================================
  // DEDUPLICATION
  // ==========================================================================

  List<LiveJobOpportunity> _deduplicate(
    List<LiveJobOpportunity> jobs,
  ) {
    final seen = <String>{};
    final output = <LiveJobOpportunity>[];

    for (final job in jobs) {
      final key = _dedupeKey(job);

      if (seen.contains(key)) {
        continue;
      }

      seen.add(key);
      output.add(job);
    }

    return output;
  }

  String _dedupeKey(LiveJobOpportunity job) {
    final title = job.title
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ');

    final company = job.company
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ');

    final location = job.location
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ');

    return '$company|$title|$location';
  }

  // ==========================================================================
  // SKILL EXTRACTION
  //
  // This is intentionally conservative.
  //
  // It extracts only recognizable technology/engineering terms that actually
  // occur in the source title/description.
  //
  // It does NOT invent a skill list.
  // ==========================================================================

  List<String> _extractSkills(String text) {
    final lower = text.toLowerCase();

    const knownSkills = [
      'python',
      'java',
      'javascript',
      'typescript',
      'c++',
      'c#',
      'go',
      'golang',
      'rust',
      'swift',
      'kotlin',
      'dart',
      'flutter',
      'react',
      'next.js',
      'node.js',
      'nodejs',
      'sql',
      'postgresql',
      'mysql',
      'mongodb',
      'redis',
      'kafka',
      'docker',
      'kubernetes',
      'aws',
      'azure',
      'gcp',
      'google cloud',
      'terraform',
      'linux',
      'git',
      'github',
      'machine learning',
      'deep learning',
      'pytorch',
      'tensorflow',
      'scikit-learn',
      'llm',
      'generative ai',
      'nlp',
      'natural language processing',
      'computer vision',
      'transformers',
      'hugging face',
      'spark',
      'databricks',
      'airflow',
      'snowflake',
      'rest api',
      'graphql',
      'microservices',
      'system design',
      'distributed systems',
      'data structures',
      'algorithms',
      'ci/cd',
      'jenkins',
      'github actions',
    ];

    final found = <String>[];

    for (final skill in knownSkills) {
      if (lower.contains(skill.toLowerCase())) {
        found.add(skill);
      }
    }

    return _normalizeSkills(found);
  }

  List<String> _normalizeSkills(
    List<String> skills,
  ) {
    final result = <String>[];
    final seen = <String>{};

    for (final raw in skills) {
      final value = raw.trim();

      if (value.isEmpty) continue;

      final key = value.toLowerCase();

      if (seen.add(key)) {
        result.add(value);
      }
    }

    result.sort(
      (a, b) => a.toLowerCase().compareTo(
        b.toLowerCase(),
      ),
    );

    return List.unmodifiable(result);
  }

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  String? _string(dynamic value) {
    if (value == null) return null;

    final result = value.toString().trim();

    if (result.isEmpty) return null;

    return result;
  }

  String _cleanRequired(String value) {
    return value
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String? _cleanNullable(String? value) {
    if (value == null) return null;

    final cleaned = value
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return cleaned.isEmpty ? null : cleaned;
  }

  String? _stripHtml(String? value) {
    if (value == null) return null;

    final withoutTags = value
        .replaceAll(
          RegExp(r'<[^>]*>', multiLine: true),
          ' ',
        )
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");

    return _cleanNullable(withoutTags);
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      // Some ATS APIs expose epoch milliseconds.
      try {
        return DateTime.fromMillisecondsSinceEpoch(
          value,
          isUtc: true,
        );
      } catch (_) {
        return null;
      }
    }

    final string = value.toString().trim();

    if (string.isEmpty) return null;

    return DateTime.tryParse(string)?.toUtc();
  }

  bool _isHttpUrl(String value) {
    final uri = Uri.tryParse(value);

    if (uri == null) return false;

    return uri.scheme == 'http' ||
        uri.scheme == 'https';
  }

  String _sourceLabel(
    LiveJobSourceType source,
  ) {
    switch (source) {
      case LiveJobSourceType.greenhouse:
        return 'Greenhouse';
      case LiveJobSourceType.lever:
        return 'Lever';
      case LiveJobSourceType.ashby:
        return 'Ashby';
    }
  }
}

// ============================================================================
// INTERNAL BOARD RESULT
// ============================================================================

class _BoardFetchResult {
  final bool success;
  final String sourceName;
  final List<LiveJobOpportunity> jobs;

  const _BoardFetchResult({
    required this.success,
    required this.sourceName,
    required this.jobs,
  });

  factory _BoardFetchResult.success({
    required String sourceName,
    required List<LiveJobOpportunity> jobs,
  }) {
    return _BoardFetchResult(
      success: true,
      sourceName: sourceName,
      jobs: jobs,
    );
  }

  factory _BoardFetchResult.failure({
    required String sourceName,
  }) {
    return _BoardFetchResult(
      success: false,
      sourceName: sourceName,
      jobs: const [],
    );
  }
}