/// Step 6E-4 — Universal Company Intelligence data contracts.
///
/// These models deliberately separate reference information, observed job
/// evidence, current published opportunities, and compensation evidence.
/// A company relationship must never be interpreted as live hiring.
enum CompanyIntelligenceDataStatus {
  reference,
  observed,
  live,
  unavailable,
}

enum CompanySourceType {
  officialCareers,
  greenhouse,
  lever,
  ashby,
  smartRecruiters,
  backendFeed,
  manualVerified,
}

class CompanySourceDefinition {
  final String sourceId;
  final CompanySourceType type;
  final String companyId;
  final String companyName;
  final String sourceUrl;
  final String sourceLabel;
  final bool isOfficialCompanySource;
  final bool supportsLiveJobs;
  final bool supportsCompensation;
  final DateTime? lastFetchedAt;

  const CompanySourceDefinition({
    required this.sourceId,
    required this.type,
    required this.companyId,
    required this.companyName,
    required this.sourceUrl,
    required this.sourceLabel,
    required this.isOfficialCompanySource,
    required this.supportsLiveJobs,
    required this.supportsCompensation,
    this.lastFetchedAt,
  });
}

class CompanyCompensation {
  final double? minimum;
  final double? maximum;
  final String currency;
  final String period;
  final String? location;
  final String sourceUrl;
  final DateTime observedAt;

  const CompanyCompensation({
    this.minimum,
    this.maximum,
    required this.currency,
    required this.period,
    this.location,
    required this.sourceUrl,
    required this.observedAt,
  });

  bool get hasNumericRange => minimum != null || maximum != null;
}

class ExtractedCompanySignal {
  final String normalizedName;
  final String category;
  final int evidenceCount;
  final List<String> evidencePostingIds;
  final List<String> sourceUrls;
  final DateTime observedAt;

  const ExtractedCompanySignal({
    required this.normalizedName,
    required this.category,
    required this.evidenceCount,
    required this.evidencePostingIds,
    required this.sourceUrls,
    required this.observedAt,
  });
}

class NormalizedJobPosting {
  final String id;
  final String companyId;
  final String companyName;
  final String title;
  final String description;
  final String? location;
  final String? department;
  final String? team;
  final String? employmentType;
  final String? workplaceType;
  final String? applyUrl;
  final DateTime? publishedAt;
  final CompanySourceType sourceType;
  final String sourceUrl;
  final CompanyCompensation? compensation;
  final Map<String, dynamic> rawMetadata;

  const NormalizedJobPosting({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.title,
    required this.description,
    this.location,
    this.department,
    this.team,
    this.employmentType,
    this.workplaceType,
    this.applyUrl,
    this.publishedAt,
    required this.sourceType,
    required this.sourceUrl,
    this.compensation,
    this.rawMetadata = const <String, dynamic>{},
  });
}

class CompanyIntelligenceSnapshot {
  final String companyId;
  final String companyName;
  final CompanyIntelligenceDataStatus status;
  final List<String> roles;
  final List<String> skills;
  final List<String> technologies;
  final List<String> engineeringConcepts;
  final List<CompanyCompensation> compensation;
  final List<NormalizedJobPosting> liveJobs;
  final List<CompanySourceDefinition> sources;
  final DateTime generatedAt;
  final DateTime? oldestEvidenceAt;
  final DateTime? newestEvidenceAt;

  const CompanyIntelligenceSnapshot({
    required this.companyId,
    required this.companyName,
    required this.status,
    required this.roles,
    required this.skills,
    required this.technologies,
    required this.engineeringConcepts,
    required this.compensation,
    required this.liveJobs,
    required this.sources,
    required this.generatedAt,
    this.oldestEvidenceAt,
    this.newestEvidenceAt,
  });

  bool get hasObservedSkills => skills.isNotEmpty || technologies.isNotEmpty;

  bool get hasLiveJobs => liveJobs.isNotEmpty;

  bool get hasCompensation => compensation.any(
        (item) => item.hasNumericRange,
      );

  String get truthLabel {
    if (hasLiveJobs) return 'Live verified opportunities';
    if (hasObservedSkills) return 'Observed from reviewed job evidence';
    return 'Reference company information';
  }
}