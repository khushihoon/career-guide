import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'company_intelligence_models.dart';

/// Step 6E-4 — Versioned local cache.

///

/// Cache is a performance layer, never proof of current hiring. Every live

/// job keeps its source URL and observation/publication metadata.

///

/// TRUTH RULES FOR THE CACHE:

/// - A snapshot read from the cache is NEVER "live". A stored `live` status is

///   returned as `observed`, because the evidence was gathered earlier and is

///   not a confirmation of current hiring.

/// - A snapshot older than [maxAge] is expired and removed. A cache without a

///   usable generation date is treated as missing, never as fresh.

/// - Only small data is persisted: job descriptions are shortened (skills were

///   already extracted from the full text) and raw metadata is slimmed, so the

///   local store does not grow with whole job descriptions.

/// - A cache read/write problem never breaks fresh data: reads fall back to

///   "no cache", and a failed write is ignored.

class CompanyIntelligenceCache {
  static const String _prefix = 'company_intelligence_v1_';

  /// Snapshots older than this are expired.

  static const Duration maxAge = Duration(days: 30);

  static const int _maxPersistedJobs = 500;

  static const int _maxPersistedDescriptionLength = 300;

  const CompanyIntelligenceCache();

  Future<void> write(CompanyIntelligenceSnapshot snapshot) async {
    try {
      final preferences = await SharedPreferences.getInstance();

      final payload = <String, dynamic>{
        'companyId': snapshot.companyId,
        'companyName': snapshot.companyName,
        'status': snapshot.status.name,
        'roles': snapshot.roles,
        'skills': snapshot.skills,
        'technologies': snapshot.technologies,
        'engineeringConcepts': snapshot.engineeringConcepts,
        'compensation': snapshot.compensation.map(_compensationToJson).toList(),
        'liveJobs':
            snapshot.liveJobs.take(_maxPersistedJobs).map(_jobToJson).toList(),
        'sources': snapshot.sources.map(_sourceToJson).toList(),
        'generatedAt': snapshot.generatedAt.toIso8601String(),
        'oldestEvidenceAt': snapshot.oldestEvidenceAt?.toIso8601String(),
        'newestEvidenceAt': snapshot.newestEvidenceAt?.toIso8601String(),
      };

      await preferences.setString(
        '$_prefix${snapshot.companyId}',
        jsonEncode(payload),
      );
    } catch (_) {
      // The cache is only a performance layer. Fresh data must not fail

      // because the local store could not be written.
    }
  }

  Future<CompanyIntelligenceSnapshot?> read(String companyId) async {
    try {
      final preferences = await SharedPreferences.getInstance();

      final key = '$_prefix$companyId';

      final raw = preferences.getString(key);

      if (raw == null || raw.trim().isEmpty) return null;

      final decoded = jsonDecode(raw);

      if (decoded is! Map) return null;

      final snapshot = _snapshotFromJson(Map<String, dynamic>.from(decoded));

      if (snapshot == null || snapshot.companyId != companyId) {
        // Cache key and embedded company identity must agree. Remove corrupt
        // or mis-keyed data here, where the preferences key is available.
        await preferences.remove(key);
        return null;
      }

      final age = DateTime.now().difference(snapshot.generatedAt);

      // A future-dated snapshot is not fresh evidence; discard it rather than
      // allowing a clock-skewed/corrupt timestamp to extend cache lifetime.
      if (age.isNegative || age > maxAge) {
        await preferences.remove(key);
        return null;
      }

      return snapshot;
    } catch (_) {
      return null;
    }
  }

  Future<void> clear(String companyId) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove('$_prefix$companyId');
  }

  Map<String, dynamic> _compensationToJson(CompanyCompensation item) {
    return <String, dynamic>{
      'minimum': item.minimum,
      'maximum': item.maximum,
      'currency': item.currency,
      'period': item.period,
      'location': item.location,
      'sourceUrl': item.sourceUrl,
      'observedAt': item.observedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _jobToJson(NormalizedJobPosting item) {
    return <String, dynamic>{
      'id': item.id,
      'companyId': item.companyId,
      'companyName': item.companyName,
      'title': item.title,
      'description': _shortDescription(item.description),
      'location': item.location,
      'department': item.department,
      'team': item.team,
      'employmentType': item.employmentType,
      'workplaceType': item.workplaceType,
      'applyUrl': item.applyUrl,
      'publishedAt': item.publishedAt?.toIso8601String(),
      'sourceType': item.sourceType.name,
      'sourceUrl': item.sourceUrl,
      'compensation': item.compensation == null
          ? null
          : _compensationToJson(item.compensation!),
      'rawMetadata': _slimMetadata(item.rawMetadata),
    };
  }

  /// Skills were already extracted from the full description, so only a short

  /// start of it is persisted.

  String _shortDescription(String value) {
    final trimmed = value.trim();

    if (trimmed.length <= _maxPersistedDescriptionLength) {
      return trimmed;
    }

    return trimmed.substring(0, _maxPersistedDescriptionLength);
  }

  /// Keeps only small scalar values (ids, flags, short labels, URLs).

  Map<String, dynamic> _slimMetadata(Map<String, dynamic> metadata) {
    final result = <String, dynamic>{};

    for (final entry in metadata.entries) {
      final value = entry.value;

      if (value == null || value is bool || value is num) {
        result[entry.key] = value;
      } else if (value is String && value.length <= 200) {
        result[entry.key] = value;
      }
    }

    return result;
  }

  Map<String, dynamic> _sourceToJson(CompanySourceDefinition item) {
    return <String, dynamic>{
      'sourceId': item.sourceId,
      'type': item.type.name,
      'companyId': item.companyId,
      'companyName': item.companyName,
      'sourceUrl': item.sourceUrl,
      'sourceLabel': item.sourceLabel,
      'isOfficialCompanySource': item.isOfficialCompanySource,
      'supportsLiveJobs': item.supportsLiveJobs,
      'supportsCompensation': item.supportsCompensation,
      'lastFetchedAt': item.lastFetchedAt?.toIso8601String(),
    };
  }

  CompanyIntelligenceSnapshot? _snapshotFromJson(Map<String, dynamic> json) {
    final companyId = json['companyId']?.toString() ?? '';

    final generatedAt = _date(json['generatedAt']);

    // A cache entry without an identity or a generation date cannot be dated,

    // so it is not trusted.

    if (companyId.trim().isEmpty ||
        companyId.trim() != json['companyId']?.toString().trim() ||
        generatedAt == null) {
      // Reject malformed identity/date metadata. The async read() method
      // removes the corresponding storage key after this parser returns null.
      return null;
    }

    final storedStatus = CompanyIntelligenceDataStatus.values.firstWhere(
      (value) => value.name == json['status'],
      orElse: () => CompanyIntelligenceDataStatus.reference,
    );

    // Cached evidence is never "live".

    final status = storedStatus == CompanyIntelligenceDataStatus.live
        ? CompanyIntelligenceDataStatus.observed
        : storedStatus;

    return CompanyIntelligenceSnapshot(
      companyId: companyId,
      companyName: json['companyName']?.toString() ?? '',
      status: status,
      roles: _strings(json['roles']),
      skills: _strings(json['skills']),
      technologies: _strings(json['technologies']),
      engineeringConcepts: _strings(json['engineeringConcepts']),
      compensation: _compensations(json['compensation']),
      liveJobs: _jobs(json['liveJobs']),
      sources: _sources(json['sources']),
      generatedAt: generatedAt,
      oldestEvidenceAt: _date(json['oldestEvidenceAt']),
      newestEvidenceAt: _date(json['newestEvidenceAt']),
    );
  }

  List<String> _strings(dynamic value) {
    if (value is! List) return const <String>[];

    return value
        .map((item) => item.toString())
        .where((item) => item.trim().isNotEmpty)
        .toList(growable: false);
  }

  List<CompanyCompensation> _compensations(dynamic value) {
    if (value is! List) return const <CompanyCompensation>[];

    return value
        .whereType<Map>()
        .map((item) => _compensationFromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  List<NormalizedJobPosting> _jobs(dynamic value) {
    if (value is! List) return const <NormalizedJobPosting>[];

    return value
        .whereType<Map>()
        .map((item) => _jobFromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  List<CompanySourceDefinition> _sources(dynamic value) {
    if (value is! List) return const <CompanySourceDefinition>[];

    return value
        .whereType<Map>()
        .map((item) => _sourceFromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  CompanyCompensation _compensationFromJson(Map<String, dynamic> json) {
    return CompanyCompensation(
      minimum: (json['minimum'] as num?)?.toDouble(),
      maximum: (json['maximum'] as num?)?.toDouble(),
      currency: json['currency']?.toString() ?? '',
      period: json['period']?.toString() ?? '',
      location: json['location']?.toString(),
      sourceUrl: json['sourceUrl']?.toString() ?? '',
      observedAt: _date(json['observedAt']) ?? DateTime.now(),
    );
  }

  NormalizedJobPosting _jobFromJson(Map<String, dynamic> json) {
    return NormalizedJobPosting(
      id: json['id']?.toString() ?? '',
      companyId: json['companyId']?.toString() ?? '',
      companyName: json['companyName']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      location: json['location']?.toString(),
      department: json['department']?.toString(),
      team: json['team']?.toString(),
      employmentType: json['employmentType']?.toString(),
      workplaceType: json['workplaceType']?.toString(),
      applyUrl: json['applyUrl']?.toString(),
      publishedAt: _date(json['publishedAt']),
      sourceType: CompanySourceType.values.firstWhere(
        (value) => value.name == json['sourceType'],
        orElse: () => CompanySourceType.backendFeed,
      ),
      sourceUrl: json['sourceUrl']?.toString() ?? '',
      compensation: json['compensation'] is Map
          ? _compensationFromJson(
              Map<String, dynamic>.from(json['compensation']),
            )
          : null,
      rawMetadata: json['rawMetadata'] is Map
          ? Map<String, dynamic>.from(json['rawMetadata'])
          : const <String, dynamic>{},
    );
  }

  CompanySourceDefinition _sourceFromJson(Map<String, dynamic> json) {
    return CompanySourceDefinition(
      sourceId: json['sourceId']?.toString() ?? '',
      type: CompanySourceType.values.firstWhere(
        (value) => value.name == json['type'],
        orElse: () => CompanySourceType.backendFeed,
      ),
      companyId: json['companyId']?.toString() ?? '',
      companyName: json['companyName']?.toString() ?? '',
      sourceUrl: json['sourceUrl']?.toString() ?? '',
      sourceLabel: json['sourceLabel']?.toString() ?? '',
      isOfficialCompanySource: json['isOfficialCompanySource'] == true,
      supportsLiveJobs: json['supportsLiveJobs'] == true,
      supportsCompensation: json['supportsCompensation'] == true,
      lastFetchedAt: _date(json['lastFetchedAt']),
    );
  }

  DateTime? _date(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }
}
