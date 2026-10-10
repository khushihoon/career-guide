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
/// ingestion service will fetch permitted/public sources and call this boundary
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
  /// Flow:
  /// provider payload
  ///     ↓
  /// provider adapter
  ///     ↓
  /// normalized postings
  ///     ↓
  /// intelligence engine
  ///     ↓
  /// local cache (only when the result contains postings)
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

    final postings = adapter.parse(
      companyId: stableId,
      companyName: canonicalCompanyName,
      sourceUrl: sourceUrl,
      payload: payload,
      fetchedAt: fetchedAtValue,
    );

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
      postings: postings,
      sources: <CompanySourceDefinition>[source],
      generatedAt: fetchedAtValue,
    );

    // The cache keeps the last snapshot that actually contained postings. An
    // empty result (no openings, or a source whose format changed) must not
    // erase the last good snapshot; the fresh result is still returned to the
    // caller, so the UI shows "no current opportunities" truthfully.
    if (snapshot.hasLiveJobs) {
      await cache.write(snapshot);
    }

    return snapshot;
  }

  /// Company identity comes from the authoritative verified registry
  /// ([VerifiedCompanyData.canonicalIdentity]): verified companies and the
  /// approved product→company aliases. Unknown companies stay supported with a
  /// deterministic ID ([CompanyIntelligenceIds]) and are never silently mapped
  /// to an unrelated company.
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