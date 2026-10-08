import 'dart:convert';

import 'company_intelligence_ids.dart';
import 'company_intelligence_models.dart';
import 'verified_company_data.dart';

/// Step 6E-4 — Provider adapters.
///
/// Adapters normalize provider-specific JSON into NormalizedJobPosting.
/// They do not scrape websites and they do not invent requirements.
/// Network fetching belongs in the backend/source-ingestion layer.
///
/// Provider identity is normalized through the canonical company registry
/// before normalized postings are created.
///
/// TRUTH RULES FOR THIS LAYER:
/// - Missing provider fields stay null. An empty string is never stored as if
///   it were a value (no blank location / team / apply URL).
/// - `publishedAt` is the provider's publication time. It is never filled with
///   a "last updated" time when a publication time exists.
/// - `applyUrl` is a human apply/job page. A provider API URL is never used as
///   an apply link.
/// - Postings the provider marks as not listed are skipped.
/// - A salary is kept only with its own numbers; nothing is estimated. The
///   period is normalized to year / month / week / day / hour, or left empty
///   when the provider does not say.
/// - Stored raw metadata is slimmed to small scalar fields so the local cache
///   does not duplicate whole job descriptions.
abstract interface class CompanySourceAdapter {
  CompanySourceType get sourceType;

  List<NormalizedJobPosting> parse({
    required String companyId,
    required String companyName,
    required String sourceUrl,
    required String payload,
    DateTime? fetchedAt,
  });
}

class CompanySourceAdapterRegistry {
  final List<CompanySourceAdapter> adapters;

  const CompanySourceAdapterRegistry({
    this.adapters = const <CompanySourceAdapter>[
      GreenhouseSourceAdapter(),
      LeverSourceAdapter(),
      AshbySourceAdapter(),
      SmartRecruitersSourceAdapter(),
    ],
  });

  CompanySourceAdapter? forType(CompanySourceType type) {
    for (final adapter in adapters) {
      if (adapter.sourceType == type) return adapter;
    }
    return null;
  }
}

class GreenhouseSourceAdapter implements CompanySourceAdapter {
  const GreenhouseSourceAdapter();

  @override
  CompanySourceType get sourceType => CompanySourceType.greenhouse;

  @override
  List<NormalizedJobPosting> parse({
    required String companyId,
    required String companyName,
    required String sourceUrl,
    required String payload,
    DateTime? fetchedAt,
  }) {
    final identity = _CompanyIdentity.resolve(
      companyId: companyId,
      companyName: companyName,
    );

    return _JsonJobParser.parseList(
      companyId: identity.companyId,
      companyName: identity.companyName,
      sourceUrl: sourceUrl,
      sourceType: sourceType,
      payload: payload,
      jobsKey: 'jobs',
      idKeys: const ['id'],
      titleKeys: const ['title'],
      descriptionKeys: const ['content', 'description'],
      locationKeys: const ['location.name', 'offices.0.name', 'location'],
      departmentKeys: const [
        'departments.0.name',
        'department.name',
        'department',
      ],
      teamKeys: const ['team.name', 'team'],
      applyUrlKeys: const ['absolute_url', 'applyUrl'],
      // `first_published` is the real publication time. `updated_at` is only
      // a fallback when the provider does not supply it.
      publishedAtKeys: const ['first_published', 'updated_at', 'created_at'],
      employmentTypeKeys: const ['employment_type', 'employmentType'],
      workplaceTypeKeys: const ['workplace_type', 'workplaceType'],
      compensationKeys: const ['compensation', 'salaryRange', 'salary'],
      fetchedAt: fetchedAt,
    );
  }
}

class LeverSourceAdapter implements CompanySourceAdapter {
  const LeverSourceAdapter();

  @override
  CompanySourceType get sourceType => CompanySourceType.lever;

  @override
  List<NormalizedJobPosting> parse({
    required String companyId,
    required String companyName,
    required String sourceUrl,
    required String payload,
    DateTime? fetchedAt,
  }) {
    final identity = _CompanyIdentity.resolve(
      companyId: companyId,
      companyName: companyName,
    );

    return _JsonJobParser.parseList(
      companyId: identity.companyId,
      companyName: identity.companyName,
      sourceUrl: sourceUrl,
      sourceType: sourceType,
      payload: payload,
      jobsKey: null,
      idKeys: const ['id'],
      titleKeys: const ['text', 'title'],
      descriptionKeys: const [
        'descriptionPlain',
        'description',
        'descriptionBody',
      ],
      locationKeys: const ['categories.location', 'location'],
      departmentKeys: const ['categories.department', 'department'],
      teamKeys: const ['categories.team', 'team'],
      applyUrlKeys: const ['hostedUrl', 'applyUrl'],
      publishedAtKeys: const ['createdAt', 'updatedAt'],
      employmentTypeKeys: const [
        'categories.commitment',
        'employmentType',
      ],
      workplaceTypeKeys: const ['workplaceType'],
      compensationKeys: const ['salaryRange', 'compensation'],
      fetchedAt: fetchedAt,
    );
  }
}

class AshbySourceAdapter implements CompanySourceAdapter {
  const AshbySourceAdapter();

  @override
  CompanySourceType get sourceType => CompanySourceType.ashby;

  @override
  List<NormalizedJobPosting> parse({
    required String companyId,
    required String companyName,
    required String sourceUrl,
    required String payload,
    DateTime? fetchedAt,
  }) {
    final identity = _CompanyIdentity.resolve(
      companyId: companyId,
      companyName: companyName,
    );

    final decoded = _JsonJobParser._decode(payload);

    if (decoded is! Map) {
      return const <NormalizedJobPosting>[];
    }

    final rawJobs = decoded['jobs'];

    if (rawJobs is! List) {
      return const <NormalizedJobPosting>[];
    }

    final compensationRoot = decoded['compensation'];
    final result = <NormalizedJobPosting>[];

    for (final raw in rawJobs) {
      if (raw is! Map) continue;

      final map = Map<String, dynamic>.from(raw);

      // Skip postings the provider marks as not listed.
      if (map['isListed'] == false) continue;

      final id = _JsonJobParser._stringAt(
        map,
        const ['id', 'jobUrl', 'jobId'],
      );

      final title = _JsonJobParser._stringAt(
        map,
        const ['title'],
      );

      if (id.isEmpty || title.isEmpty) continue;

      final location = _JsonJobParser._nullable(
        _JsonJobParser._stringAt(
          map,
          const ['location'],
        ),
      );

      final compensation = _ashbyCompensation(
        map['compensation'] is Map
            ? Map<String, dynamic>.from(map['compensation'])
            : compensationRoot is Map
                ? Map<String, dynamic>.from(compensationRoot)
                : null,
        sourceUrl: sourceUrl,
        location: location,
        observedAt: fetchedAt ?? DateTime.now(),
      );

      var workplaceType = _JsonJobParser._nullable(
        _JsonJobParser._stringAt(
          map,
          const ['workplaceType'],
        ),
      );

      // Only an explicit provider flag may turn into "Remote".
      if (workplaceType == null && map['isRemote'] == true) {
        workplaceType = 'Remote';
      }

      result.add(
        NormalizedJobPosting(
          id: 'ashby:$id',
          companyId: identity.companyId,
          companyName: identity.companyName,
          title: title,
          description: _JsonJobParser._stringAt(
            map,
            const [
              'descriptionPlain',
              'descriptionHtml',
              'description',
            ],
          ),
          location: location,
          department: _JsonJobParser._nullable(
            _JsonJobParser._stringAt(
              map,
              const ['department'],
            ),
          ),
          team: _JsonJobParser._nullable(
            _JsonJobParser._stringAt(
              map,
              const ['team'],
            ),
          ),
          employmentType: _JsonJobParser._nullable(
            _JsonJobParser._stringAt(
              map,
              const ['employmentType'],
            ),
          ),
          workplaceType: workplaceType,
          applyUrl: _JsonJobParser._nullable(
            _JsonJobParser._stringAt(
              map,
              const ['applyUrl', 'jobUrl'],
            ),
          ),
          publishedAt: _JsonJobParser._dateAt(
            map,
            const ['publishedAt'],
          ),
          sourceType: sourceType,
          sourceUrl: sourceUrl,
          compensation: compensation,
          rawMetadata: _JsonJobParser._slimMetadata(map),
        ),
      );
    }

    return result;
  }

  CompanyCompensation? _ashbyCompensation(
    Map<String, dynamic>? compensation, {
    required String sourceUrl,
    required String? location,
    required DateTime observedAt,
  }) {
    if (compensation == null) return null;

    final components = compensation['summaryComponents'];

    if (components is List) {
      for (final item in components) {
        if (item is! Map) continue;

        final map = Map<String, dynamic>.from(item);

        if (map['compensationType']
                ?.toString()
                .toLowerCase() !=
            'salary') {
          continue;
        }

        final min = (map['minValue'] as num?)?.toDouble();
        final max = (map['maxValue'] as num?)?.toDouble();

        if (min == null && max == null) continue;

        return CompanyCompensation(
          minimum: min,
          maximum: max,
          currency: map['currencyCode']?.toString() ?? '',
          period: _JsonJobParser._normalizePeriod(
            map['interval']?.toString() ?? '',
          ),
          location: location,
          sourceUrl: sourceUrl,
          observedAt: observedAt,
        );
      }
    }

    return null;
  }
}

class SmartRecruitersSourceAdapter implements CompanySourceAdapter {
  const SmartRecruitersSourceAdapter();

  @override
  CompanySourceType get sourceType => CompanySourceType.smartRecruiters;

  @override
  List<NormalizedJobPosting> parse({
    required String companyId,
    required String companyName,
    required String sourceUrl,
    required String payload,
    DateTime? fetchedAt,
  }) {
    final identity = _CompanyIdentity.resolve(
      companyId: companyId,
      companyName: companyName,
    );

    return _JsonJobParser.parseList(
      companyId: identity.companyId,
      companyName: identity.companyName,
      sourceUrl: sourceUrl,
      sourceType: sourceType,
      payload: payload,
      jobsKey: 'content',
      idKeys: const ['id', 'uuid'],
      titleKeys: const ['name', 'title'],
      descriptionKeys: const [
        'jobAd.sections.jobDescription.text',
        'description',
      ],
      locationKeys: const [
        'location.fullLocation',
        'location.city',
        'location',
      ],
      departmentKeys: const [
        'department.label',
        'department',
      ],
      teamKeys: const [
        'function.label',
        'function',
      ],
      // The list endpoint's `ref` is an API URL, not a page a person can open
      // to apply, so it is intentionally NOT used here.
      applyUrlKeys: const [
        'applyUrl',
      ],
      publishedAtKeys: const [
        'releasedDate',
        'createdOn',
      ],
      employmentTypeKeys: const [
        'typeOfEmployment.label',
        'typeOfEmployment',
      ],
      workplaceTypeKeys: const [
        'location.remote',
        'workplaceType',
      ],
      compensationKeys: const [
        'compensation',
        'salaryRange',
      ],
      fetchedAt: fetchedAt,
    );
  }
}

class _JsonJobParser {
  static List<NormalizedJobPosting> parseList({
    required String companyId,
    required String companyName,
    required String sourceUrl,
    required CompanySourceType sourceType,
    required String payload,
    required String? jobsKey,
    required List<String> idKeys,
    required List<String> titleKeys,
    required List<String> descriptionKeys,
    required List<String> locationKeys,
    required List<String> departmentKeys,
    required List<String> teamKeys,
    required List<String> applyUrlKeys,
    required List<String> publishedAtKeys,
    required List<String> employmentTypeKeys,
    required List<String> workplaceTypeKeys,
    required List<String> compensationKeys,
    DateTime? fetchedAt,
  }) {
    final decoded = _decode(payload);

    if (decoded == null) {
      return const <NormalizedJobPosting>[];
    }

    dynamic rawJobs = decoded;

    if (jobsKey != null && decoded is Map<String, dynamic>) {
      rawJobs = decoded[jobsKey];
    }

    if (rawJobs is! List) {
      return const <NormalizedJobPosting>[];
    }

    final result = <NormalizedJobPosting>[];

    for (final item in rawJobs) {
      if (item is! Map) continue;

      final map = Map<String, dynamic>.from(item);

      final id = _stringAt(map, idKeys);
      final title = _stringAt(map, titleKeys);

      if (id.isEmpty || title.isEmpty) continue;

      result.add(
        NormalizedJobPosting(
          id: '${sourceType.name}:$id',
          companyId: companyId,
          companyName: companyName,
          title: title,
          description: _stringAt(
            map,
            descriptionKeys,
          ),
          location: _nullable(
            _stringAt(map, locationKeys),
          ),
          department: _nullable(
            _stringAt(map, departmentKeys),
          ),
          team: _nullable(
            _stringAt(map, teamKeys),
          ),
          employmentType: _nullable(
            _stringAt(map, employmentTypeKeys),
          ),
          workplaceType: _nullable(
            _stringAt(map, workplaceTypeKeys),
          ),
          applyUrl: _nullable(
            _stringAt(map, applyUrlKeys),
          ),
          publishedAt: _dateAt(
            map,
            publishedAtKeys,
          ),
          sourceType: sourceType,
          sourceUrl: sourceUrl,
          compensation: _compensationAt(
            map,
            compensationKeys,
            sourceUrl: sourceUrl,
            location: _nullable(
              _stringAt(map, locationKeys),
            ),
            observedAt: fetchedAt ?? DateTime.now(),
          ),
          rawMetadata: _slimMetadata(map),
        ),
      );
    }

    return result;
  }

  static CompanyCompensation? _compensationAt(
    Map<String, dynamic> map,
    List<String> keys, {
    required String sourceUrl,
    required String? location,
    required DateTime observedAt,
  }) {
    // Greenhouse pay transparency: `pay_input_ranges` with amounts in cents.
    final ranges = map['pay_input_ranges'];

    if (ranges is List) {
      for (final item in ranges) {
        if (item is! Map) continue;

        final minCents = item['min_cents'];
        final maxCents = item['max_cents'];

        final min = minCents is num ? minCents / 100 : null;
        final max = maxCents is num ? maxCents / 100 : null;

        if (min == null && max == null) continue;

        return CompanyCompensation(
          minimum: min?.toDouble(),
          maximum: max?.toDouble(),
          currency: item['currency_type']?.toString() ?? '',
          // The provider does not state the period here, so none is assumed.
          period: '',
          location: location,
          sourceUrl: sourceUrl,
          observedAt: observedAt,
        );
      }
    }

    for (final key in keys) {
      final value = _valueAt(map, key);

      if (value is! Map) continue;

      final compensation = Map<String, dynamic>.from(value);

      final minValue = compensation['min'] ??
          compensation['minimum'] ??
          compensation['minValue'];

      final maxValue = compensation['max'] ??
          compensation['maximum'] ??
          compensation['maxValue'];

      final min = minValue is num ? minValue : null;
      final max = maxValue is num ? maxValue : null;

      if (min == null && max == null) continue;

      return CompanyCompensation(
        minimum: min?.toDouble(),
        maximum: max?.toDouble(),
        currency: compensation['currency']?.toString() ??
            compensation['currencyCode']?.toString() ??
            '',
        period: _normalizePeriod(
          compensation['interval']?.toString() ??
              compensation['period']?.toString() ??
              '',
        ),
        location: location,
        sourceUrl: sourceUrl,
        observedAt: observedAt,
      );
    }

    return null;
  }

  /// Normalizes provider period text ("1 YEAR", "per-hour", "Monthly") to one
  /// of year / month / week / day / hour. Unknown text is returned empty
  /// rather than guessed.
  static String _normalizePeriod(String raw) {
    final value = raw.trim().toLowerCase();

    if (value.isEmpty) return '';
    if (value.contains('year') || value.contains('annual')) return 'year';
    if (value.contains('month')) return 'month';
    if (value.contains('week')) return 'week';
    if (value.contains('day') || value.contains('daily')) return 'day';
    if (value.contains('hour')) return 'hour';

    return '';
  }

  /// Keeps only small scalar fields (ids, flags, short labels, URLs) so the
  /// cache does not store whole descriptions twice.
  static Map<String, dynamic> _slimMetadata(Map<String, dynamic> map) {
    final result = <String, dynamic>{};

    for (final entry in map.entries) {
      final value = entry.value;

      if (value == null || value is bool || value is num) {
        result[entry.key] = value;
      } else if (value is String && value.length <= 200) {
        result[entry.key] = value;
      }
    }

    return result;
  }

  static dynamic _decode(String payload) {
    try {
      return jsonDecode(payload);
    } catch (_) {
      return null;
    }
  }

  static String _stringAt(
    Map<String, dynamic> map,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = _valueAt(map, key);

      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }

      if (value is num) {
        return value.toString();
      }

      // A provider "remote" flag set to true means a remote posting.
      if (value is bool) {
        if (value && key.toLowerCase().endsWith('remote')) {
          return 'Remote';
        }
        continue;
      }

      if (value is Map) {
        final text = value.values
            .whereType<String>()
            .join(', ');

        if (text.trim().isNotEmpty) {
          return text.trim();
        }
      }
    }

    return '';
  }

  static DateTime? _dateAt(
    Map<String, dynamic> map,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = _valueAt(map, key);

      if (value is String) {
        final parsed = DateTime.tryParse(value);

        if (parsed != null) {
          return parsed;
        }
      }

      if (value is num) {
        final number = value.toInt();

        final millis = number > 100000000000
            ? number
            : number * 1000;

        return DateTime.fromMillisecondsSinceEpoch(
          millis,
          isUtc: true,
        );
      }
    }

    return null;
  }

  /// Reads a dotted path. A numeric segment indexes into a list
  /// (for example `departments.0.name`).
  static dynamic _valueAt(
    Map<String, dynamic> map,
    String path,
  ) {
    dynamic current = map;

    for (final segment in path.split('.')) {
      if (current is Map && current.containsKey(segment)) {
        current = current[segment];
      } else if (current is List) {
        final index = int.tryParse(segment);

        if (index == null || index < 0 || index >= current.length) {
          return null;
        }

        current = current[index];
      } else {
        return null;
      }
    }

    return current;
  }

  static String? _nullable(String value) {
    return value.trim().isEmpty
        ? null
        : value.trim();
  }
}

/// Canonical company identity used by every provider adapter.
///
/// Identity comes from the authoritative verified registry
/// ([VerifiedCompanyData.canonicalIdentity]): verified companies and the
/// approved product→company aliases. Unknown companies remain supported
/// through deterministic IDs ([CompanyIntelligenceIds]) and the supplied
/// company name, so every layer uses the same ID format.
class _CompanyIdentity {
  final String companyId;
  final String companyName;

  const _CompanyIdentity({
    required this.companyId,
    required this.companyName,
  });

  static _CompanyIdentity resolve({
    required String companyId,
    required String companyName,
  }) {
    final trimmedId = companyId.trim();
    final trimmedName = companyName.trim();

    final byId = VerifiedCompanyData.canonicalIdentity(trimmedId);

    if (byId != null) {
      return _CompanyIdentity(
        companyId: byId.companyId,
        companyName: byId.companyName,
      );
    }

    final byName = VerifiedCompanyData.canonicalIdentity(trimmedName);

    if (byName != null) {
      return _CompanyIdentity(
        companyId: byName.companyId,
        companyName: byName.companyName,
      );
    }

    final stableId = trimmedId.isNotEmpty
        ? CompanyIntelligenceIds.fromIdOrName(trimmedId)
        : CompanyIntelligenceIds.fromCompanyName(trimmedName);

    final fallbackName = trimmedName.isNotEmpty
        ? trimmedName
        : (stableId == CompanyIntelligenceIds.unknownCompanyId
            ? 'Unknown Company'
            : stableId);

    return _CompanyIdentity(
      companyId: stableId,
      companyName: fallbackName,
    );
  }
}