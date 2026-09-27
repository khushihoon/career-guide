enum HomeDataStatus { reference, live, unavailable }

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

  const HomeSourceInfo({
    required this.name,
    this.url,
    this.note,
  });
}

class HomeDataMeta {
  final HomeDataStatus status;
  final HomeDataType type;
  final HomeSourceInfo? source;
  final DateTime? observedAt;
  final String? note;

  const HomeDataMeta({
    required this.status,
    required this.type,
    this.source,
    this.observedAt,
    this.note,
  });

  bool get isLive => status == HomeDataStatus.live;
  bool get isReference => status == HomeDataStatus.reference;

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
  final String id;
  final String name;
  final String? country;
  final String? headquarters;
  final String? description;
  final String? logo;
  final List<String> focusAreas;
  final List<String> notableRoles;
  final List<String> relatedCareerIds;
  final List<String> products;
  final List<String> industries;
  final List<String> engineeringAreas;
  final String? website;
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
  final String careerId;
  final String? companyId;
  final String? currency;
  final String? period;
  final double? min;
  final double? max;
  final String? label;
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
    required this.meta,
  });

  String get salaryLabel {
    final value = label?.trim();
    return value == null || value.isEmpty ? 'Salary not disclosed' : value;
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
