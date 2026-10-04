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
class CompanyIntelligenceSourceCatalog {
  const CompanyIntelligenceSourceCatalog();

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
      sourceUrl:
          'https://boards-api.greenhouse.io/v1/boards/$boardToken/jobs',
      sourceLabel: 'Greenhouse Job Board',
      isOfficialCompanySource: false,
      supportsLiveJobs: true,
      supportsCompensation: false,
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
      sourceUrl: 'https://api.lever.co/v0/postings/$companySlug',
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
      sourceUrl:
          'https://api.ashbyhq.com/posting-api/job-board/$jobBoardName?includeCompensation=true',
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
      sourceUrl:
          'https://api.smartrecruiters.com/v1/companies/$companyIdentifier/postings',
      sourceLabel: 'SmartRecruiters Posting API',
      isOfficialCompanySource: false,
      supportsLiveJobs: true,
      supportsCompensation: true,
    );
  }

  _CompanyIdentity _resolveIdentity({
    required String companyId,
    required String companyName,
  }) {
    final trimmedId = companyId.trim();
    final trimmedName = companyName.trim();

    // Prefer an explicitly supplied ID when it resolves to a verified
    // canonical company.
    final verifiedFromId = VerifiedCompanyData.find(trimmedId);

    if (verifiedFromId != null) {
      return _CompanyIdentity(
        companyId: verifiedFromId.companyId,
        companyName: verifiedFromId.companyName,
      );
    }

    // Otherwise resolve the company name through the canonical registry.
    final verifiedFromName = VerifiedCompanyData.find(trimmedName);

    if (verifiedFromName != null) {
      return _CompanyIdentity(
        companyId: verifiedFromName.companyId,
        companyName: verifiedFromName.companyName,
      );
    }

    // Unknown companies remain supported and receive a deterministic ID.
    final stableId = trimmedId.isNotEmpty
        ? CompanyIntelligenceIds.fromIdOrName(trimmedId)
        : CompanyIntelligenceIds.fromCompanyName(trimmedName);

    final fallbackName = trimmedName.isNotEmpty
        ? trimmedName
        : (stableId == 'unknown-company' ? 'Unknown Company' : stableId);

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