import 'company_intelligence_ids.dart';
import 'company_intelligence_models.dart';
import 'verified_company_data.dart';

/// Step 6E-4 — Source catalog configuration.
///
/// This catalog describes supported source shapes. It does not scrape the web
/// and does not claim that a company uses a particular ATS until configured.
///
/// Provider definitions here are reusable templates. Actual company/source
/// configuration belongs in the live source catalog.
///
/// The public API URL of each provider is built in ONE place (the static
/// `...ApiUrl` helpers below) and shared with the live source catalog, so the
/// two never drift apart.
///
/// Greenhouse note: the job-board API returns job descriptions only with
/// `content=true`. Without descriptions no skills can be observed, so the URL
/// always asks for them. `pay_transparency=true` additionally returns the pay
/// ranges that a company chooses to publish.
class CompanyIntelligenceSourceCatalog {
  const CompanyIntelligenceSourceCatalog();

  static String greenhouseApiUrl(String boardToken) =>
      'https://boards-api.greenhouse.io/v1/boards/'
      '${Uri.encodeComponent(boardToken)}/jobs'
      '?content=true&pay_transparency=true';

  static String leverApiUrl(String companySlug) =>
      'https://api.lever.co/v0/postings/'
      '${Uri.encodeComponent(companySlug)}?mode=json';

  static String ashbyApiUrl(String jobBoardName) =>
      'https://api.ashbyhq.com/posting-api/job-board/'
      '${Uri.encodeComponent(jobBoardName)}?includeCompensation=true';

  static String smartRecruitersApiUrl(String companyIdentifier) =>
      'https://api.smartrecruiters.com/v1/companies/'
      '${Uri.encodeComponent(companyIdentifier)}/postings';

  CompanySourceDefinition greenhouse({
    required String companyId,
    required String companyName,
    required String boardToken,
  }) {
    final identity = _resolveIdentity(
      companyId: companyId,
      companyName: companyName,
    );

    return CompanySourceDefinition(
      sourceId: 'greenhouse:$boardToken',
      type: CompanySourceType.greenhouse,
      companyId: identity.companyId,
      companyName: identity.companyName,
      sourceUrl: greenhouseApiUrl(boardToken),
      sourceLabel: 'Greenhouse Job Board',
      isOfficialCompanySource: false,
      supportsLiveJobs: true,
      supportsCompensation: true,
    );
  }

  CompanySourceDefinition lever({
    required String companyId,
    required String companyName,
    required String companySlug,
  }) {
    final identity = _resolveIdentity(
      companyId: companyId,
      companyName: companyName,
    );

    return CompanySourceDefinition(
      sourceId: 'lever:$companySlug',
      type: CompanySourceType.lever,
      companyId: identity.companyId,
      companyName: identity.companyName,
      sourceUrl: leverApiUrl(companySlug),
      sourceLabel: 'Lever',
      isOfficialCompanySource: false,
      supportsLiveJobs: true,
      supportsCompensation: true,
    );
  }

  CompanySourceDefinition ashby({
    required String companyId,
    required String companyName,
    required String jobBoardName,
  }) {
    final identity = _resolveIdentity(
      companyId: companyId,
      companyName: companyName,
    );

    return CompanySourceDefinition(
      sourceId: 'ashby:$jobBoardName',
      type: CompanySourceType.ashby,
      companyId: identity.companyId,
      companyName: identity.companyName,
      sourceUrl: ashbyApiUrl(jobBoardName),
      sourceLabel: 'Ashby Job Postings',
      isOfficialCompanySource: false,
      supportsLiveJobs: true,
      supportsCompensation: true,
    );
  }

  CompanySourceDefinition smartRecruiters({
    required String companyId,
    required String companyName,
    required String companyIdentifier,
  }) {
    final identity = _resolveIdentity(
      companyId: companyId,
      companyName: companyName,
    );

    return CompanySourceDefinition(
      sourceId: 'smartrecruiters:$companyIdentifier',
      type: CompanySourceType.smartRecruiters,
      companyId: identity.companyId,
      companyName: identity.companyName,
      sourceUrl: smartRecruitersApiUrl(companyIdentifier),
      sourceLabel: 'SmartRecruiters Posting API',
      isOfficialCompanySource: false,
      supportsLiveJobs: true,
      supportsCompensation: true,
    );
  }

  /// Company identity comes from the authoritative verified registry
  /// ([VerifiedCompanyData.canonicalIdentity]): verified companies and the
  /// approved product→company aliases. Unknown companies keep a deterministic
  /// ID from [CompanyIntelligenceIds] and are never mapped to an unrelated
  /// company.
  _CompanyIdentity _resolveIdentity({
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

class _CompanyIdentity {
  final String companyId;
  final String companyName;

  const _CompanyIdentity({
    required this.companyId,
    required this.companyName,
  });
}
