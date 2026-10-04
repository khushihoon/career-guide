enum HomeDataStatus {
  reference,
  live,
  unavailable,
}

enum HomeDataType {
  career,
  company,
  industry,
  skill,
  hiring,
  job,
  salary,
  insight,
}

class HomeSourceInfo {
  final String name;
  final String? url;
  final String? note;

  /// Whether this source is an official/verified source for the data.
  final bool isOfficial;

  const HomeSourceInfo({
    required this.name,
    this.url,
    this.note,
    this.isOfficial = false,
  });
}

class HomeDataMeta {
  final HomeDataStatus status;
  final HomeDataType type;
  final HomeSourceInfo? source;

  /// When live/observed information was collected.
  final DateTime? observedAt;

  /// When reference information was last verified.
  final DateTime? lastVerifiedAt;

  final String? note;

  const HomeDataMeta({
    required this.status,
    required this.type,
    this.source,
    this.observedAt,
    this.lastVerifiedAt,
    this.note,
  });

  bool get isLive => status == HomeDataStatus.live;

  bool get isReference => status == HomeDataStatus.reference;

  bool get isUnavailable => status == HomeDataStatus.unavailable;

  String get statusLabel {
    switch (status) {
      case HomeDataStatus.live:
        return 'LIVE';

      case HomeDataStatus.reference:
        return 'REFERENCE';

      case HomeDataStatus.unavailable:
        return 'UNAVAILABLE';
    }
  }
}

class HomeCareer {
  final String id;
  final String title;
  final String shortDescription;
  final String? overview;
  final String? icon;

  final List<String> workAreas;
  final List<String> commonSkills;
  final List<String> tools;
  final List<String> industries;

  /// Canonical company IDs related to this career.
  final List<String> relatedCompanyIds;

  final HomeDataMeta meta;

  const HomeCareer({
    required this.id,
    required this.title,
    required this.shortDescription,
    this.overview,
    this.icon,
    this.workAreas = const [],
    this.commonSkills = const [],
    this.tools = const [],
    this.industries = const [],
    this.relatedCompanyIds = const [],
    required this.meta,
  });
}

class HomeCareerArea {
  final String id;
  final String title;
  final String description;
  final List<String> careerIds;
  final HomeDataMeta meta;

  const HomeCareerArea({
    required this.id,
    required this.title,
    required this.description,
    required this.careerIds,
    required this.meta,
  });
}

class HomeCompany {
  /// Canonical company ID.
  final String id;

  final String name;
  final String? country;
  final String? headquarters;
  final String? description;
  final String? logo;

  final List<String> focusAreas;
  final List<String> notableRoles;

  /// Canonical career IDs related to this company.
  final List<String> relatedCareerIds;

  final List<String> products;
  final List<String> industries;
  final List<String> engineeringAreas;

  final String? website;

  /// Official company careers URL.
  final String? careersUrl;

  final HomeDataMeta meta;

  const HomeCompany({
    required this.id,
    required this.name,
    this.country,
    this.headquarters,
    this.description,
    this.logo,
    this.focusAreas = const [],
    this.notableRoles = const [],
    this.relatedCareerIds = const [],
    this.products = const [],
    this.industries = const [],
    this.engineeringAreas = const [],
    this.website,
    this.careersUrl,
    required this.meta,
  });
}

class HomeHiringSnapshot {
  final String id;
  final String companyId;
  final String title;
  final String summary;

  /// Only meaningful as a current opening count when meta.status == live.
  final int? openingCount;

  final HomeDataMeta meta;

  const HomeHiringSnapshot({
    required this.id,
    required this.companyId,
    required this.title,
    required this.summary,
    this.openingCount,
    required this.meta,
  });
}

class HomeJobOpportunity {
  final String id;
  final String title;
  final String companyId;
  final String companyName;
  final String location;

  final String? workplaceType;
  final String? employmentType;
  final String? salary;

  final List<String> skills;

  final String? description;
  final String? applyUrl;

  /// Publication time supplied by the live source when available.
  final DateTime? publishedAt;

  /// Original source URL/evidence URL.
  final String? sourceUrl;

  final HomeDataMeta meta;

  const HomeJobOpportunity({
    required this.id,
    required this.title,
    required this.companyId,
    required this.companyName,
    required this.location,
    this.workplaceType,
    this.employmentType,
    this.salary,
    this.skills = const [],
    this.description,
    this.applyUrl,
    this.publishedAt,
    this.sourceUrl,
    required this.meta,
  });
}

class HomeSkillSignal {
  final String id;
  final String name;
  final String summary;

  final List<String> relatedCareerIds;
  final List<String> relatedCompanyIds;

  final HomeDataMeta meta;

  const HomeSkillSignal({
    required this.id,
    required this.name,
    required this.summary,
    this.relatedCareerIds = const [],
    this.relatedCompanyIds = const [],
    required this.meta,
  });
}

class HomeCareerInsight {
  final String id;
  final String title;
  final String summary;

  final List<String> relatedCareerIds;

  final HomeDataMeta meta;

  const HomeCareerInsight({
    required this.id,
    required this.title,
    required this.summary,
    this.relatedCareerIds = const [],
    required this.meta,
  });
}

class HomeSalaryInfo {
  final String id;

  /// Canonical career ID.
  final String careerId;

  /// Optional canonical company ID.
  final String? companyId;

  final String? currency;
  final String? period;

  final double? min;
  final double? max;

  final String? label;

  /// Country/region associated with this salary information.
  final String? country;

  /// More specific salary geography when available.
  final String? location;

  /// Experience context, for example:
  /// entry, junior, mid, senior, staff.
  final String? experienceLevel;

  final HomeDataMeta meta;

  const HomeSalaryInfo({
    required this.id,
    required this.careerId,
    this.companyId,
    this.currency,
    this.period,
    this.min,
    this.max,
    this.label,
    this.country,
    this.location,
    this.experienceLevel,
    required this.meta,
  });

  String get salaryLabel {
    final value = label?.trim();

    return value == null || value.isEmpty
        ? 'Salary not disclosed'
        : value;
  }
}

class HomeMarketSnapshot {
  final List<HomeCareer> careers;
  final List<HomeCareerArea> areas;
  final List<HomeCompany> companies;
  final List<HomeSkillSignal> skillSignals;
  final List<HomeCareerInsight> insights;
  final List<HomeHiringSnapshot> hiring;
  final List<HomeJobOpportunity> jobs;
  final List<HomeSalaryInfo> salaries;

  const HomeMarketSnapshot({
    this.careers = const [],
    this.areas = const [],
    this.companies = const [],
    this.skillSignals = const [],
    this.insights = const [],
    this.hiring = const [],
    this.jobs = const [],
    this.salaries = const [],
  });
}