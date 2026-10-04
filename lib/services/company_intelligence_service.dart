import 'company_intelligence_models.dart';
import 'company_intelligence_repository.dart';

/// Step 6E-4 — Single application-facing service.
///
/// UI code depends on this service instead of knowing whether data came from
/// a verified reference profile, a provider adapter, a backend feed, or cache.
///
/// Company identity resolution, provider parsing, intelligence generation,
/// and cache persistence remain inside the repository and its dependencies.
class CompanyIntelligenceService {
  final CompanyIntelligenceRepository repository;

  const CompanyIntelligenceService({
    this.repository = const CompanyIntelligenceRepository(),
  });

  /// Returns cached company intelligence using a company name or alias.
  Future<CompanyIntelligenceSnapshot?> cachedCompany(
    String companyName,
  ) {
    return repository.getCachedByCompanyName(companyName);
  }

  /// Returns cached company intelligence using a stable company ID.
  Future<CompanyIntelligenceSnapshot?> cachedCompanyById(
    String companyId,
  ) {
    return repository.getCached(companyId);
  }

  /// Ingests a provider payload through the application-facing service.
  ///
  /// The service deliberately does not parse or transform provider data.
  /// That responsibility belongs to the repository → adapter → engine
  /// pipeline.
  Future<CompanyIntelligenceSnapshot> ingestProviderPayload({
    required String companyId,
    required String companyName,
    required CompanySourceType sourceType,
    required String sourceUrl,
    required String payload,
    DateTime? fetchedAt,
    String? sourceLabel,
    bool isOfficialCompanySource = false,
    bool supportsLiveJobs = true,
    bool supportsCompensation = false,
  }) {
    return repository.ingestProviderPayload(
      companyId: companyId,
      companyName: companyName,
      sourceType: sourceType,
      sourceUrl: sourceUrl,
      payload: payload,
      fetchedAt: fetchedAt,
      sourceLabel: sourceLabel,
      isOfficialCompanySource: isOfficialCompanySource,
      supportsLiveJobs: supportsLiveJobs,
      supportsCompensation: supportsCompensation,
    );
  }
}