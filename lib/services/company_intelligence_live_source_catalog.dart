import 'company_intelligence_ids.dart';
import 'company_intelligence_models.dart';
import 'verified_company_data.dart';

/// Step 6E-4 — Explicit live-source catalog.
///
/// This catalog contains only deliberately configured live sources. It does
/// not discover arbitrary websites or imply that a company is hiring now.
class CompanyIntelligenceLiveSourceCatalog {
  const CompanyIntelligenceLiveSourceCatalog();

  static const String openAiAshbyJobBoardName = 'openai';

  static const String openAiSourceUrl =
      'https://api.ashbyhq.com/posting-api/job-board/openai?includeCompensation=true';

  static const CompanyLiveSourceConfig _openAi = CompanyLiveSourceConfig(
    companyId: 'openai',
    companyName: 'OpenAI',
    sourceType: CompanySourceType.ashby,
    sourceUrl: openAiSourceUrl,
    sourceLabel: 'OpenAI official Ashby job board',
    isOfficialCompanySource: true,
    supportsLiveJobs: true,
    supportsCompensation: true,
  );

  List<CompanyLiveSourceConfig> get all => const <CompanyLiveSourceConfig>[
        _openAi,
      ];

  CompanyLiveSourceConfig? forCompanyName(String companyName) {
    final identity = _resolveIdentity(companyName);
    return forCompanyId(identity.companyId);
  }

  CompanyLiveSourceConfig? forCompanyId(String companyId) {
    final normalized = CompanyIntelligenceIds.fromIdOrName(companyId);
    if (normalized == _openAi.companyId) return _openAi;
    return null;
  }

  static _CompanyIdentity _resolveIdentity(String value) {
    final verified = VerifiedCompanyData.find(value.trim());
    if (verified != null) {
      return _CompanyIdentity(
        companyId: verified.companyId,
        companyName: verified.companyName,
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
