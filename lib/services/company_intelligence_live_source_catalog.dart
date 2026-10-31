import 'company_intelligence_ids.dart';
import 'company_intelligence_models.dart';
import 'company_intelligence_source_catalog.dart';
import 'verified_company_data.dart';

/// Step 6E-4 — Explicit live-source catalog.
///
/// This catalog contains only deliberately configured live sources. It does
/// not discover arbitrary websites or imply that a company is hiring now.
///
/// Adding a company is a DATA change only: append one [CompanyLiveSourceConfig]
/// to `_sources`. A board may be added only when its board token was read from
/// an official company page or from an official job-board link of that
/// company. A configured source says WHERE live data can be fetched; it never
/// says the company is hiring (live data only counts after a successful
/// refresh, see CompanyIntelligenceLiveIngestionService).
class CompanyIntelligenceLiveSourceCatalog {
  const CompanyIntelligenceLiveSourceCatalog();

  static const String openAiAshbyJobBoardName = 'openai';

  static const String openAiSourceUrl =
      'https://api.ashbyhq.com/posting-api/job-board/openai?includeCompensation=true';

  static final List<CompanyLiveSourceConfig> _sources =
      <CompanyLiveSourceConfig>[
    const CompanyLiveSourceConfig(
      companyId: 'openai',
      companyName: 'OpenAI',
      sourceType: CompanySourceType.ashby,
      sourceUrl: openAiSourceUrl,
      sourceLabel: 'OpenAI official Ashby job board',
      isOfficialCompanySource: true,
      supportsLiveJobs: true,
      supportsCompensation: true,
    ),

    // Board tokens below were read from links on the companies' own official
    // pages (Ashby apply links / Greenhouse job pages).
    CompanyLiveSourceConfig(
      companyId: 'gamma',
      companyName: 'Gamma',
      sourceType: CompanySourceType.ashby,
      sourceUrl: CompanyIntelligenceSourceCatalog.ashbyApiUrl('gamma'),
      sourceLabel: 'Gamma official Ashby job board',
      isOfficialCompanySource: true,
      supportsLiveJobs: true,
      supportsCompensation: true,
    ),
    CompanyLiveSourceConfig(
      companyId: 'luma_ai',
      companyName: 'Luma AI',
      sourceType: CompanySourceType.ashby,
      sourceUrl: CompanyIntelligenceSourceCatalog.ashbyApiUrl('lumaai'),
      sourceLabel: 'Luma official Ashby job board',
      isOfficialCompanySource: true,
      supportsLiveJobs: true,
      supportsCompensation: true,
    ),
    CompanyLiveSourceConfig(
      companyId: 'letta_memgpt',
      companyName: 'Letta (MemGPT)',
      sourceType: CompanySourceType.ashby,
      sourceUrl: CompanyIntelligenceSourceCatalog.ashbyApiUrl('letta'),
      sourceLabel: 'Letta official Ashby job board',
      isOfficialCompanySource: true,
      supportsLiveJobs: true,
      supportsCompensation: true,
    ),
    CompanyLiveSourceConfig(
      companyId: 'together_ai',
      companyName: 'Together AI',
      sourceType: CompanySourceType.greenhouse,
      sourceUrl:
          CompanyIntelligenceSourceCatalog.greenhouseApiUrl('togetherai'),
      sourceLabel: 'Together AI official Greenhouse job board',
      isOfficialCompanySource: true,
      supportsLiveJobs: true,
      supportsCompensation: true,
    ),

    // Added after confirming the official Anthropic Greenhouse board.
    CompanyLiveSourceConfig(
      companyId: 'anthropic',
      companyName: 'Anthropic',
      sourceType: CompanySourceType.greenhouse,
      sourceUrl: CompanyIntelligenceSourceCatalog.greenhouseApiUrl('anthropic'),
      sourceLabel: 'Anthropic official Greenhouse job board',
      isOfficialCompanySource: true,
      supportsLiveJobs: true,
      supportsCompensation: true,
    ),

    // Added after the public Ashby endpoint returned listed Cognition roles.
    CompanyLiveSourceConfig(
      companyId: 'cognition_ai',
      companyName: 'Cognition AI',
      sourceType: CompanySourceType.ashby,
      sourceUrl: CompanyIntelligenceSourceCatalog.ashbyApiUrl('cognition'),
      sourceLabel: 'Cognition official Ashby job board',
      isOfficialCompanySource: true,
      supportsLiveJobs: true,
      supportsCompensation: true,
    ),

    // Confirmed by reading the public Ashby JSON response: listed job records
    // include human-facing jobUrl/applyUrl fields and role descriptions.
    CompanyLiveSourceConfig(
      companyId: 'langchain',
      companyName: 'LangChain',
      sourceType: CompanySourceType.ashby,
      sourceUrl: CompanyIntelligenceSourceCatalog.ashbyApiUrl('langchain'),
      sourceLabel: 'LangChain Ashby public postings API',
      isOfficialCompanySource: true,
      supportsLiveJobs: true,
      supportsCompensation: true,
    ),

    // Confirmed by reading the public Ashby JSON response. Salary is still
    // counted only per posting when that posting actually publishes it.
    CompanyLiveSourceConfig(
      companyId: 'modal',
      companyName: 'Modal',
      sourceType: CompanySourceType.ashby,
      sourceUrl: CompanyIntelligenceSourceCatalog.ashbyApiUrl('modal'),
      sourceLabel: 'Modal Ashby public postings API',
      isOfficialCompanySource: true,
      supportsLiveJobs: true,
      supportsCompensation: true,
    ),

    // The company's public Greenhouse board is visible at
    // job-boards.greenhouse.io/scaleai. The API endpoint is the corresponding
    // public Greenhouse JSON board; salary remains per-posting only.
    CompanyLiveSourceConfig(
      companyId: 'scale_ai',
      companyName: 'Scale AI',
      sourceType: CompanySourceType.greenhouse,
      sourceUrl: CompanyIntelligenceSourceCatalog.greenhouseApiUrl('scaleai'),
      sourceLabel: 'Scale AI public Greenhouse job board',
      isOfficialCompanySource: true,
      supportsLiveJobs: true,
      supportsCompensation: true,
    ),
  ];

  List<CompanyLiveSourceConfig> get all =>
      List<CompanyLiveSourceConfig>.unmodifiable(_sources);

  CompanyLiveSourceConfig? forCompanyName(String companyName) {
    final identity = _resolveIdentity(companyName);
    return forCompanyId(identity.companyId);
  }

  CompanyLiveSourceConfig? forCompanyId(String companyId) {
    final normalized = CompanyIntelligenceIds.fromIdOrName(companyId);

    for (final source in _sources) {
      if (CompanyIntelligenceIds.fromIdOrName(source.companyId) == normalized) {
        return source;
      }
    }

    return null;
  }

  static _CompanyIdentity _resolveIdentity(String value) {
    final identity = VerifiedCompanyData.canonicalIdentity(value.trim());

    if (identity != null) {
      return _CompanyIdentity(
        companyId: identity.companyId,
        companyName: identity.companyName,
      );
    }

    final id = CompanyIntelligenceIds.fromIdOrName(value);
    return _CompanyIdentity(
      companyId: id,
      companyName: value.trim().isEmpty ? id : value.trim(),
    );
  }
}

class CompanyLiveSourceConfig {
  final String companyId;
  final String companyName;
  final CompanySourceType sourceType;
  final String sourceUrl;
  final String sourceLabel;
  final bool isOfficialCompanySource;
  final bool supportsLiveJobs;
  final bool supportsCompensation;

  const CompanyLiveSourceConfig({
    required this.companyId,
    required this.companyName,
    required this.sourceType,
    required this.sourceUrl,
    required this.sourceLabel,
    required this.isOfficialCompanySource,
    required this.supportsLiveJobs,
    required this.supportsCompensation,
  });
}

class _CompanyIdentity {
  final String companyId;
  final String companyName;

  const _CompanyIdentity({
    required this.companyId,
    required this.companyName,
  });
}