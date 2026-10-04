/// Step 6E-3
///
/// Verified company-specific skills / technologies reference layer.
///
/// IMPORTANT:
/// - This is REFERENCE data, not live hiring data.
/// - Skills are observed from selected official company career/job sources
///   reviewed for the current verification batch.
/// - A listed skill is NOT a universal requirement for every role.
/// - A listed skill does NOT mean the company is hiring for that skill now.
/// - Current openings must come from the separate LIVE opportunities layer.
/// - Salary data must remain separate from this reference layer.
/// - Company identity is aligned with the canonical verified company registry.
///
/// Architecture:
///
///   Canonical Company Registry
///              ↓
///   Verified Company Skill Evidence
///              ↓
///   Career / Company / Home reference UI
///
/// This file intentionally does not contain:
/// - live jobs
/// - live hiring status
/// - salary data
/// - paid AI/API calls
///
/// SCALABILITY:
/// One reusable profile model is used for all companies.
/// Do NOT create one Dart file per company.

class VerifiedCompanySkillProfile {
  final String companyId;
  final String companyName;

  /// Broad practical skills observed in official company career/job evidence.
  final List<String> skills;

  /// Concrete technologies, platforms, frameworks, systems or tooling
  /// observed in official company career/job evidence.
  final List<String> technologies;

  /// Engineering / research concepts observed in official evidence.
  final List<String> engineeringConcepts;

  /// Human-readable evidence description.
  final String sourceLabel;

  /// Official source pages reviewed for this profile.
  final List<String> sourceUrls;

  /// Date on which this reference batch was verified.
  final DateTime lastVerified;

  const VerifiedCompanySkillProfile({
    required this.companyId,
    required this.companyName,
    required this.skills,
    required this.technologies,
    required this.engineeringConcepts,
    required this.sourceLabel,
    required this.sourceUrls,
    required this.lastVerified,
  });
}

class VerifiedCompanySkillsService {
  const VerifiedCompanySkillsService();

  static final DateTime _verifiedDate = DateTime(2026, 9, 28);

  /// =========================================================================
  /// VERIFIED SKILL PROFILES
  /// =========================================================================
  ///
  /// Only companies for which the current reference batch contains reviewed
  /// evidence are placed here.
  ///
  /// Do not add a company merely because it is connected to a career.
  /// Career relationship ≠ verified skill evidence.
  ///
  static final List<VerifiedCompanySkillProfile> _profiles =
      <VerifiedCompanySkillProfile>[
    // ========================================================================
    // 1. OPENAI
    // ========================================================================

    VerifiedCompanySkillProfile(
      companyId: 'openai',
      companyName: 'OpenAI',
      skills: <String>[
        'Python',
        'Go',
        'Rust',
        'TypeScript',
        'JavaScript',
        'C++',
        'SQL',
        'PyTorch',
        'Docker',
        'Kubernetes',
      ],
      technologies: <String>[
        'PostgreSQL',
        'CI/CD',
        'Git',
        'Linux',
        'REST APIs',
      ],
      engineeringConcepts: <String>[
        'Distributed systems',
        'Cloud infrastructure',
        'Reliability',
        'Scalability',
        'Observability',
        'Security',
        'Inference systems',
        'Developer tooling',
        'Multimodal systems',
      ],
      sourceLabel: 'Official OpenAI career postings',
      sourceUrls: <String>[
        'https://openai.com/careers/software-engineer-cloud-agents-san-francisco/',
        'https://openai.com/careers/software-engineer-api-multimodal-san-francisco/',
        'https://openai.com/careers/software-engineer-research-developer-productivity-san-francisco/',
      ],
      lastVerified: _verifiedDate,
    ),

    // ========================================================================
    // 2. GOOGLE DEEPMIND
    // ========================================================================

    VerifiedCompanySkillProfile(
      companyId: 'google_deepmind',
      companyName: 'Google DeepMind',
      skills: <String>[
        'Software engineering',
        'Machine learning',
        'Deep learning',
        'Mathematics',
        'Research engineering',
      ],
      technologies: <String>[
        'Distributed computing',
        'AI model infrastructure',
      ],
      engineeringConcepts: <String>[
        'Frontier model development',
        'Distributed systems',
        'Robotics',
        'Scalable software',
        'Model implementation',
        'Model optimization',
        'Research experimentation',
      ],
      sourceLabel: 'Official Google DeepMind careers',
      sourceUrls: <String>[
        'https://deepmind.google/careers/',
      ],
      lastVerified: _verifiedDate,
    ),

    // ========================================================================
    // 3. MICROSOFT
    // ========================================================================

    VerifiedCompanySkillProfile(
      companyId: 'microsoft',
      companyName: 'Microsoft',
      skills: <String>[
        'Python',
        'C#',
        'PyTorch',
        'Machine learning',
        'Deep learning',
        'MLOps',
        'AIOps',
      ],
      technologies: <String>[
        'Azure',
        'AWS',
        'GCP',
        'LangChain',
        'LlamaIndex',
        'Haystack',
        'Transformers',
        'AutoGen',
        'DSPy',
      ],
      engineeringConcepts: <String>[
        'LLMs',
        'Generative AI',
        'Agent orchestration',
        'Prompt engineering',
        'Retrieval-augmented generation',
        'Fine-tuning',
        'Model evaluation',
        'Monitoring',
        'CI/CD',
        'Cloud deployment',
      ],
      sourceLabel: 'Official Microsoft Careers posting',
      sourceUrls: <String>[
        'https://careers.microsoft.com/v2/global/en/locations/hyderabad.html',
      ],
      lastVerified: _verifiedDate,
    ),

    // ========================================================================
    // 4. NVIDIA
    // ========================================================================

    VerifiedCompanySkillProfile(
      companyId: 'nvidia',
      companyName: 'NVIDIA',
      skills: <String>[
        'Python',
        'C++',
        'CUDA',
        'Machine learning',
        'Deep learning',
        'LLMs',
      ],
      technologies: <String>[
        'PyTorch',
        'Kubernetes',
        'Ray',
        'Slurm',
        'RAG',
      ],
      engineeringConcepts: <String>[
        'Distributed infrastructure',
        'GPU computing',
        'Model deployment',
        'Model optimization',
        'AI agents',
        'Vector search',
        'High-performance computing',
        'Inference systems',
        'Data processing',
      ],
      sourceLabel: 'Official NVIDIA Careers postings',
      sourceUrls: <String>[
        'https://jobs.nvidia.com/careers/job/893397346924',
        'https://jobs.nvidia.com/careers/job/893397617990',
        'https://jobs.nvidia.com/careers/job/893397618102',
      ],
      lastVerified: _verifiedDate,
    ),

    // ========================================================================
    // 5. ANTHROPIC
    // ========================================================================

    VerifiedCompanySkillProfile(
      companyId: 'anthropic',
      companyName: 'Anthropic',
      skills: <String>[
        'Machine learning',
        'Reinforcement learning',
        'Software engineering',
        'Research engineering',
        'Distributed systems',
      ],
      technologies: <String>[
        'GPU systems',
        'ML infrastructure',
        'Data platforms',
        'Inference systems',
      ],
      engineeringConcepts: <String>[
        'Pre-training',
        'Post-training',
        'Model evaluation',
        'RL engineering',
        'AI safety',
        'Interpretability',
        'Inference performance',
        'Research infrastructure',
        'Search',
        'Cybersecurity',
      ],
      sourceLabel: 'Official Anthropic Careers postings',
      sourceUrls: <String>[
        'https://www.anthropic.com/careers/jobs',
      ],
      lastVerified: _verifiedDate,
    ),

    // ========================================================================
    // 6. AMAZON
    // ========================================================================

    VerifiedCompanySkillProfile(
      companyId: 'amazon',
      companyName: 'Amazon',
      skills: <String>[
        'Python',
        'Java',
        'C++',
        'Rust',
        'Go',
        'Machine learning',
        'LLM fundamentals',
      ],
      technologies: <String>[
        'AWS',
        'Kubernetes',
        'OpenSearch',
        'Apache Spark',
        'CloudFormation',
        'Terraform',
        'CDK',
      ],
      engineeringConcepts: <String>[
        'Distributed systems',
        'Cloud computing',
        'Scalability',
        'Reliability',
        'Data pipelines',
        'Search',
        'Observability',
        'Security',
        'AI/ML infrastructure',
        'Serverless computing',
      ],
      sourceLabel: 'Official Amazon Jobs postings',
      sourceUrls: <String>[
        'https://www.amazon.jobs/en/jobs/10386342/software-development-engineer',
        'https://amazon.jobs/en/jobs/10502946/software-development-engineer-aws-opensearch',
        'https://amazon.jobs/en/jobs/10525633/software-development-engineer-lambda-experience',
      ],
      lastVerified: _verifiedDate,
    ),

    // ========================================================================
    // 7. APPLE
    // ========================================================================

    VerifiedCompanySkillProfile(
      companyId: 'apple',
      companyName: 'Apple',
      skills: <String>[
        'Python',
        'Java',
        'C++',
        'Machine learning',
        'Generative AI',
        'Natural language processing',
      ],
      technologies: <String>[
        'Spark',
        'SQL',
        'Snowflake',
        'Hadoop',
        'LLM systems',
      ],
      engineeringConcepts: <String>[
        'Distributed systems',
        'Data processing pipelines',
        'Large-scale ML',
        'Model training',
        'Model deployment',
        'Semantic retrieval',
        'Ranking models',
        'On-device optimization',
        'Privacy-aware AI',
      ],
      sourceLabel: 'Official Apple Careers postings',
      sourceUrls: <String>[
        'https://jobs.apple.com/en-us/details/200682189/applied-machine-learning-engineer-apple-intelligence',
        'https://jobs.apple.com/en-us/details/200669144-0836/machine-learning-engineer-search',
        'https://jobs.apple.com/en-in/details/200665562-0836/machine-learning-engineer-apple-store-online',
      ],
      lastVerified: _verifiedDate,
    ),
  ];

  // ===========================================================================
  // PUBLIC READ ACCESS
  // ===========================================================================

  /// All currently verified company skill profiles.
  List<VerifiedCompanySkillProfile> get all {
    return List.unmodifiable(_profiles);
  }

  /// Canonical company IDs currently represented in this skill registry.
  List<String> get verifiedCompanyIds {
    return List.unmodifiable(
      _profiles.map((profile) => profile.companyId),
    );
  }

  /// Canonical company names currently represented in this skill registry.
  List<String> get verifiedCompanyNames {
    return List.unmodifiable(
      _profiles.map((profile) => profile.companyName),
    );
  }

  // ===========================================================================
  // LOOKUP BY CANONICAL ID
  // ===========================================================================

  VerifiedCompanySkillProfile? byCompanyId(String companyId) {
    final normalized = _normalizeCompanyKey(companyId);

    if (normalized.isEmpty) {
      return null;
    }

    for (final profile in _profiles) {
      if (_normalizeCompanyKey(profile.companyId) == normalized) {
        return profile;
      }
    }

    return null;
  }

  // ===========================================================================
  // LOOKUP BY COMPANY NAME / ALIAS
  // ===========================================================================

  VerifiedCompanySkillProfile? byCompanyName(String companyName) {
    final key = _canonicalCompanyKey(companyName);

    if (key.isEmpty) {
      return null;
    }

    for (final profile in _profiles) {
      if (_canonicalCompanyKey(profile.companyName) == key) {
        return profile;
      }
    }

    return null;
  }

  // ===========================================================================
  // UNIVERSAL LOOKUP
  // ===========================================================================

  /// Lookup priority:
  ///
  /// 1. Canonical company ID
  /// 2. Canonical company name
  /// 3. Supported alias
  VerifiedCompanySkillProfile? find(String value) {
    final byId = byCompanyId(value);

    if (byId != null) {
      return byId;
    }

    return byCompanyName(value);
  }

  /// Returns true when verified skill reference data exists.
  bool isVerified(String companyOrId) {
    return find(companyOrId) != null;
  }

  // ===========================================================================
  // SIGNAL ACCESSORS
  // ===========================================================================

  List<String> skillsFor(String companyOrId) {
    final profile = find(companyOrId);

    if (profile == null) {
      return const <String>[];
    }

    return List.unmodifiable(profile.skills);
  }

  List<String> technologiesFor(String companyOrId) {
    final profile = find(companyOrId);

    if (profile == null) {
      return const <String>[];
    }

    return List.unmodifiable(profile.technologies);
  }

  List<String> engineeringConceptsFor(String companyOrId) {
    final profile = find(companyOrId);

    if (profile == null) {
      return const <String>[];
    }

    return List.unmodifiable(profile.engineeringConcepts);
  }

  /// Returns skills + technologies + engineering concepts
  /// without duplicate normalized values.
  List<String> allSignalsFor(String companyOrId) {
    final profile = find(companyOrId);

    if (profile == null) {
      return const <String>[];
    }

    final result = <String>[];
    final seen = <String>{};

    void addAll(List<String> values) {
      for (final value in values) {
        final cleaned = value.trim();

        if (cleaned.isEmpty) {
          continue;
        }

        final key = _normalizeValue(cleaned);

        if (seen.add(key)) {
          result.add(cleaned);
        }
      }
    }

    addAll(profile.skills);
    addAll(profile.technologies);
    addAll(profile.engineeringConcepts);

    return List.unmodifiable(result);
  }

  // ===========================================================================
  // SOURCE / FRESHNESS HELPERS
  // ===========================================================================

  List<String> sourceUrlsFor(String companyOrId) {
    final profile = find(companyOrId);

    if (profile == null) {
      return const <String>[];
    }

    return List.unmodifiable(profile.sourceUrls);
  }

  DateTime? lastVerified(String companyOrId) {
    return find(companyOrId)?.lastVerified;
  }

  String? sourceLabelFor(String companyOrId) {
    return find(companyOrId)?.sourceLabel;
  }

  // ===========================================================================
  // NORMALIZATION
  // ===========================================================================

  static String _normalizeCompanyKey(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  /// Canonicalizes known company aliases.
  ///
  /// This prevents duplicate company identities between:
  /// - Home
  /// - Career
  /// - Company Intelligence
  /// - live ingestion
  /// - legacy data
  static String _canonicalCompanyKey(String value) {
    var key = _normalizeCompanyKey(value);

    const aliases = <String, String>{
      // ----------------------------------------------------------------------
      // OpenAI
      // ----------------------------------------------------------------------
      'open-ai': 'openai',
      'openai-ai': 'openai',

      // ----------------------------------------------------------------------
      // Google DeepMind
      // ----------------------------------------------------------------------
      'google-deepmind': 'google-deepmind',
      'deepmind': 'google-deepmind',
      'google-ai-deepmind': 'google-deepmind',

      // ----------------------------------------------------------------------
      // Microsoft
      // ----------------------------------------------------------------------
      'microsoft-ai': 'microsoft',
      'microsoft-corporation': 'microsoft',
      'msft': 'microsoft',

      // ----------------------------------------------------------------------
      // NVIDIA
      // ----------------------------------------------------------------------
      'nvidia-corporation': 'nvidia',
      'nvidia-ai': 'nvidia',

      // ----------------------------------------------------------------------
      // Anthropic
      // ----------------------------------------------------------------------
      'anthropic-ai': 'anthropic',

      // ----------------------------------------------------------------------
      // Amazon
      // ----------------------------------------------------------------------
      'amazon-com': 'amazon',
      'amazon-web-services': 'amazon',
      'aws': 'amazon',

      // ----------------------------------------------------------------------
      // Apple
      // ----------------------------------------------------------------------
      'apple-inc': 'apple',
      'apple-incorporated': 'apple',
      'apple-ai': 'apple',
    };

    key = aliases[key] ?? key;

    return key;
  }

  static String _normalizeValue(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}

/// ===========================================================================
/// COMPATIBILITY FACADE
/// ===========================================================================
///
/// Existing callers can continue using:
///
///   VerifiedCompanySkills.find(...)
///
/// No existing caller needs to instantiate the service manually.

class VerifiedCompanySkills {
  VerifiedCompanySkills._();

  static const VerifiedCompanySkillsService _service =
      VerifiedCompanySkillsService();

  static List<VerifiedCompanySkillProfile> get all => _service.all;

  static List<String> get verifiedCompanyIds =>
      _service.verifiedCompanyIds;

  static List<String> get verifiedCompanyNames =>
      _service.verifiedCompanyNames;

  static VerifiedCompanySkillProfile? byCompanyId(String companyId) {
    return _service.byCompanyId(companyId);
  }

  static VerifiedCompanySkillProfile? byCompanyName(String companyName) {
    return _service.byCompanyName(companyName);
  }

  static VerifiedCompanySkillProfile? find(String companyOrId) {
    return _service.find(companyOrId);
  }

  static bool isVerified(String companyOrId) {
    return _service.isVerified(companyOrId);
  }

  static List<String> skillsFor(String companyOrId) {
    return _service.skillsFor(companyOrId);
  }

  static List<String> technologiesFor(String companyOrId) {
    return _service.technologiesFor(companyOrId);
  }

  static List<String> engineeringConceptsFor(String companyOrId) {
    return _service.engineeringConceptsFor(companyOrId);
  }

  static List<String> allSignalsFor(String companyOrId) {
    return _service.allSignalsFor(companyOrId);
  }

  static List<String> sourceUrlsFor(String companyOrId) {
    return _service.sourceUrlsFor(companyOrId);
  }

  static DateTime? lastVerified(String companyOrId) {
    return _service.lastVerified(companyOrId);
  }

  static String? sourceLabelFor(String companyOrId) {
    return _service.sourceLabelFor(companyOrId);
  }
}