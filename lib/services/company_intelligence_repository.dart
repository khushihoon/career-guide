import 'company_intelligence_cache.dart';
import 'company_intelligence_engine.dart';
import 'company_intelligence_ids.dart';
import 'company_intelligence_models.dart';
import 'company_source_adapters.dart';
import 'verified_company_data.dart';

/// Step 6E-4 — Repository boundary.
///
/// Production data flow:
/// source ingestion → provider adapter → normalized postings → engine → cache
/// → Company Intelligence UI.
///
/// The Flutter app does not scrape arbitrary company websites. A backend
/// ingestion service fetches permitted/public sources and calls this boundary
/// with the provider payload.
///
/// The repository keeps company identity canonical and delegates parsing,
/// intelligence generation, and persistence to their dedicated layers.
class CompanyIntelligenceRepository {
  final CompanySourceAdapterRegistry adapterRegistry;
  final CompanyIntelligenceEngine engine;
  final CompanyIntelligenceCache cache;

  const CompanyIntelligenceRepository({
    this.adapterRegistry = const CompanySourceAdapterRegistry(),
    this.engine = const CompanyIntelligenceEngine(),
    this.cache = const CompanyIntelligenceCache(),
  });

  /// Reads an already-generated intelligence snapshot from local cache.
  ///
  /// A cached snapshot is never live (see [CompanyIntelligenceCache]).
  Future<CompanyIntelligenceSnapshot?> getCached(String companyId) {
    final stableId = CompanyIntelligenceIds.fromIdOrName(companyId);
    return cache.read(stableId);
  }

  /// Reads a cached intelligence snapshot using a company name or alias.
  Future<CompanyIntelligenceSnapshot?> getCachedByCompanyName(
    String companyName,
  ) {
    final stableId = CompanyIntelligenceIds.fromCompanyName(companyName);
    return cache.read(stableId);
  }

  /// Ingests one provider payload into the normalized intelligence pipeline.
  ///
  /// Source capability flags are enforced before data reaches the engine:
  /// - When live jobs are unsupported, parsed postings are not treated as
  ///   live job evidence.
  /// - When compensation is unsupported, salary values are removed from the
  ///   normalized postings before snapshot generation.
  ///
  /// Note: this engine derives skills, roles, and compensation from job
  /// postings. Therefore, a source marked as not supporting live jobs cannot
  /// currently contribute independent compensation-only evidence through this
  /// API; that would require a separate compensation evidence contract.
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
  }) async {
    final adapter = adapterRegistry.forType(sourceType);

    if (adapter == null) {
      throw StateError(
        'No Company Intelligence adapter registered for $sourceType.',
      );
    }

    final identity = _resolveIdentity(
      companyId: companyId,
      companyName: companyName,
    );

    final stableId = identity.companyId;
    final canonicalCompanyName = identity.companyName;
    final fetchedAtValue = fetchedAt ?? DateTime.now();

    final parsedPostings = adapter.parse(
      companyId: stableId,
      companyName: canonicalCompanyName,
      sourceUrl: sourceUrl,
      payload: payload,
      fetchedAt: fetchedAtValue,
    );

    // Enforce source capabilities before the engine derives roles, skills,
    // compensation, status, and liveJobs from the normalized postings.
    final eligiblePostings = supportsLiveJobs
        ? _applyCompensationCapability(
            parsedPostings,
            supportsCompensation: supportsCompensation,
          )
        : const <NormalizedJobPosting>[];

    final source = CompanySourceDefinition(
      sourceId: '${sourceType.name}:$stableId',
      type: sourceType,
      companyId: stableId,
      companyName: canonicalCompanyName,
      sourceUrl: sourceUrl,
      sourceLabel: sourceLabel ?? sourceType.name,
      isOfficialCompanySource: isOfficialCompanySource,
      supportsLiveJobs: supportsLiveJobs,
      supportsCompensation: supportsCompensation,
      lastFetchedAt: fetchedAtValue,
    );

    final snapshot = engine.buildSnapshot(
      companyId: stableId,
      companyName: canonicalCompanyName,
      postings: eligiblePostings,
      sources: <CompanySourceDefinition>[source],
      generatedAt: fetchedAtValue,
    );

    // Keep the last snapshot that actually contained live postings. An empty
    // result must not erase the last good snapshot; return the fresh result so
    // callers can truthfully report that no current opportunities were found.
    if (snapshot.hasLiveJobs) {
      await cache.write(snapshot);
    }

    return snapshot;
  }

  /// Removes salary evidence from postings when the source does not declare
  /// compensation support. Other normalized posting fields are preserved.
  List<NormalizedJobPosting> _applyCompensationCapability(
    List<NormalizedJobPosting> postings, {
    required bool supportsCompensation,
  }) {
    if (supportsCompensation) {
      return postings;
    }

    return postings
        .map(
          (posting) => NormalizedJobPosting(
            id: posting.id,
            companyId: posting.companyId,
            companyName: posting.companyName,
            title: posting.title,
            description: posting.description,
            location: posting.location,
            department: posting.department,
            team: posting.team,
            employmentType: posting.employmentType,
            workplaceType: posting.workplaceType,
            applyUrl: posting.applyUrl,
            publishedAt: posting.publishedAt,
            sourceType: posting.sourceType,
            sourceUrl: posting.sourceUrl,
            compensation: null,
            rawMetadata: posting.rawMetadata,
          ),
        )
        .toList(growable: false);
  }

  /// Resolves identity from the authoritative verified registry
  /// ([VerifiedCompanyData.canonicalIdentity]).
  ///
  /// If both supplied values independently identify verified companies, they
  /// must resolve to the same canonical ID. A conflicting ID/name pair is
  /// rejected instead of silently attaching one company's postings to another.
  /// Unknown companies remain supported with deterministic IDs and are never
  /// silently mapped to an unrelated verified company.
  _CompanyIdentity _resolveIdentity({
    required String companyId,
    required String companyName,
  }) {
    final trimmedId = companyId.trim();
    final trimmedName = companyName.trim();

    final byId = trimmedId.isEmpty
        ? null
        : VerifiedCompanyData.canonicalIdentity(trimmedId);
    final byName = trimmedName.isEmpty
        ? null
        : VerifiedCompanyData.canonicalIdentity(trimmedName);

    if (byId != null && byName != null && byId.companyId != byName.companyId) {
      throw ArgumentError(
        'Company identity conflict: "$trimmedId" resolves to '
        '"${byId.companyId}" but "$trimmedName" resolves to '
        '"${byName.companyId}". Supply a matching company ID and name.',
      );
    }

    final verifiedIdentity = byId ?? byName;
    if (verifiedIdentity != null) {
      return _CompanyIdentity(
        companyId: verifiedIdentity.companyId,
        companyName: verifiedIdentity.companyName,
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
