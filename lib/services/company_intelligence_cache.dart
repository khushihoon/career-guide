import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'company_intelligence_models.dart';

/// Step 6E-4 — Versioned local cache.
///
/// Cache is a performance layer, never proof of current hiring. Every live
/// job keeps its source URL and observation/publication metadata.
class CompanyIntelligenceCache {
  static const String _prefix = 'company_intelligence_v1_';

  const CompanyIntelligenceCache();

  Future<void> write(CompanyIntelligenceSnapshot snapshot) async {
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
      'liveJobs': snapshot.liveJobs.map(_jobToJson).toList(),
      'sources': snapshot.sources.map(_sourceToJson).toList(),
      'generatedAt': snapshot.generatedAt.toIso8601String(),
      'oldestEvidenceAt': snapshot.oldestEvidenceAt?.toIso8601String(),
      'newestEvidenceAt': snapshot.newestEvidenceAt?.toIso8601String(),
    };

    await preferences.setString(
      '$_prefix${snapshot.companyId}',
      jsonEncode(payload),
    );
  }

  Future<CompanyIntelligenceSnapshot?> read(String companyId) async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString('$_prefix$companyId');
    if (raw == null || raw.trim().isEmpty) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return _snapshotFromJson(Map<String, dynamic>.from(decoded));
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
      'description': item.description,
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
      'rawMetadata': item.rawMetadata,
    };
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

  CompanyIntelligenceSnapshot _snapshotFromJson(Map<String, dynamic> json) {
    return CompanyIntelligenceSnapshot(
      companyId: json['companyId']?.toString() ?? '',
      companyName: json['companyName']?.toString() ?? '',
      status: CompanyIntelligenceDataStatus.values.firstWhere(
        (value) => value.name == json['status'],
        orElse: () => CompanyIntelligenceDataStatus.reference,
      ),
      roles: _strings(json['roles']),
      skills: _strings(json['skills']),
      technologies: _strings(json['technologies']),
      engineeringConcepts: _strings(json['engineeringConcepts']),
      compensation: _compensations(json['compensation']),
      liveJobs: _jobs(json['liveJobs']),
      sources: _sources(json['sources']),
      generatedAt: _date(json['generatedAt']) ?? DateTime.now(),
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