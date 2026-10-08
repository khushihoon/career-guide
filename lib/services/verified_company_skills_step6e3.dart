import 'verified_company_data.dart';

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
///
/// AUDIT NOTE (verification batch 2026-10-05):
///
/// STRONG (specific official job postings):
///   - OpenAI (specific job postings)
///   - NVIDIA (specific job postings)
///   - Amazon (specific job postings)
///   - Apple (specific job postings)
///
/// BROAD (official source reviewed, specific terms not independently
/// re-confirmed in the current session):
///   - Microsoft (careers location page)
///   - Google DeepMind (careers landing page)
///   - Anthropic (careers landing page)
///
/// EVIDENCE BATCH 2026-10-07 (read by hand on official company job pages):
///   - Microsoft AI (several official microsoft.ai postings across teams)
///   - Pinecone (official pinecone.io posting text; only terms literally
///     present were recorded)
/// Terms are ordered by how often they appear across the reviewed postings
/// (most important first).
///
/// EVIDENCE BATCH 2026-10-08 (each page opened and read by hand):
///   - Cursor (1 official posting: Software Engineer, ML Infrastructure)
///   - Gamma  (1 official posting: Research Engineer, including the
///     "Engineering at Gamma" tech-stack section of the page)
/// These two profiles rest on ONE posting each, so their terms follow the
/// order of the posting and are NOT frequency-ranked. A term that a third
/// party claimed but that is not on the page was NOT recorded (for example
/// "Python" for Gamma).
///
/// No profile is added for a company whose claimed source was not actually
/// reviewed in the verification pass.
///
/// ALIAS POLICY (locked; updated 2026-10-08):
/// - Skill profiles are resolved by canonical company ID/name, spelling /
///   legal-name variants of the SAME entity (see [_canonicalCompanyKey]), and
///   the approved product→company aliases owned by the canonical company
///   registry (verified_company_data.dart, see its ALIAS POLICY). This file
///   keeps no product alias of its own.
/// - "Microsoft AI" is its own entity and is NOT an alias of Microsoft.
/// - Do NOT add an alias based only on a similar name or URL.
///
/// DO NOT fill empty fields with guesses.
/// DO NOT add new companies without official evidence.
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
  static final DateTime _verifiedOct7 = DateTime(2026, 10, 7);
  static final DateTime _verifiedOct8 = DateTime(2026, 10, 8);

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
      sourceLabel:
          'Official OpenAI career posting URLs (specific terms reviewed '
          'in an earlier verification pass)',
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
      sourceLabel:
          'Official Google DeepMind careers landing page — broad evidence',
      sourceUrls: <String>[
        'https://deepmind.google/careers/',
      ],
      lastVerified: _verifiedDate,
    ),

    // ========================================================================
    // 3. MICROSOFT
    // ========================================================================
    //
    // EVIDENCE STATUS: The Microsoft skills below were reviewed against the
    // official Microsoft careers location page
    // (careers.microsoft.com/v2/global/en/locations/hyderabad.html) in an
    // earlier verification pass.
    //
    // That source is broad (a careers location page) and does not
    // independently re-confirm every specific technology term below in the
    // current session. A future verification pass should replace this source
    // with specific Microsoft job posting URLs, at which point the profile
    // should be re-audited.
    //
    // Unsupported specific terms (LlamaIndex, Haystack, DSPy, AIOps, AWS,
    // GCP) were removed in the previous pass and must not be restored
    // without official Microsoft evidence.
    //
    // NOTE: "Microsoft AI" (the Microsoft AI division listed in the company
    // directory) is NOT an approved alias of "Microsoft". This profile is
    // therefore reachable only as "Microsoft" / "Microsoft Corporation" /
    // "MSFT", never as "Microsoft AI".

    VerifiedCompanySkillProfile(
      companyId: 'microsoft',
      companyName: 'Microsoft',
      skills: <String>[
        'Python',
        'C#',
        'C++',
        'Java',
        'JavaScript',
        'Machine learning',
        'Deep learning',
      ],
      technologies: <String>[
        'Azure',
        'LangChain',
        'Semantic Kernel',
        'AutoGen',
        'MCP',
        'REST APIs',
        'CI/CD',
        'Azure Data Explorer (KQL)',
        'Synapse',
        'Grafana',
      ],
      engineeringConcepts: <String>[
        'LLMs',
        'Generative AI',
        'Agent orchestration',
        'Agentic AI',
        'Retrieval-augmented generation',
        'Retrieval/ranking/personalization',
        'Model training',
        'Model evaluation',
        'Model deployment',
        'Monitoring',
        'Cloud deployment',
        'Distributed systems',
      ],
      sourceLabel:
          'Official Microsoft careers location page — broad evidence, '
          'specific technology terms pending confirmation via job postings',
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
      sourceLabel:
          'Official NVIDIA Careers posting URLs (specific terms reviewed '
          'in an earlier verification pass)',
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
      sourceLabel:
          'Official Anthropic careers landing page — broad evidence',
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
      sourceLabel:
          'Official Amazon Jobs posting URLs (specific terms reviewed '
          'in an earlier verification pass)',
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
      sourceLabel:
          'Official Apple Careers posting URLs (specific terms reviewed '
          'in an earlier verification pass)',
      sourceUrls: <String>[
        'https://jobs.apple.com/en-us/details/200682189/applied-machine-learning-engineer-apple-intelligence',
        'https://jobs.apple.com/en-us/details/200669144-0836/machine-learning-engineer-search',
        'https://jobs.apple.com/en-in/details/200665562-0836/machine-learning-engineer-apple-store-online',
      ],
      lastVerified: _verifiedDate,
    ),

    // ========================================================================
    // 8. MICROSOFT AI (own entity; NOT an alias of Microsoft)
    // ========================================================================
    //
    // EVIDENCE: official microsoft.ai job postings (Software Engineering, Data
    // Engineering, Edge/Browser, Copilot product roles). Only terms literally
    // written in those postings are listed.

    VerifiedCompanySkillProfile(
      companyId: 'microsoft_ai',
      companyName: 'Microsoft AI',
      skills: <String>[
        'Python',
        'C#',
        'C++',
        'Java',
        'JavaScript',
        'C',
        'SQL',
        'Rust',
        'TypeScript',
        'Machine learning',
      ],
      technologies: <String>[
        'Azure',
        'Kubernetes',
        'Apache Spark',
        'Kafka',
        'Databricks',
        'Terraform',
        '.NET',
        'AWS',
        'GCP',
        'Azure DevOps',
        'Git',
        'Helm',
        'Hadoop',
        'Node.js',
      ],
      engineeringConcepts: <String>[
        'Distributed systems',
        'LLMs',
        'Generative AI',
        'Prompt engineering',
        'Data pipelines',
        'Observability',
        'AI agents',
        'Inference',
        'Microservices',
        'Model evaluation',
        'CI/CD',
        'Anomaly detection',
        'Responsible AI',
        'Data governance',
      ],
      sourceLabel:
          'Official Microsoft AI job postings (several teams reviewed)',
      sourceUrls: <String>[
        'https://microsoft.ai/job/page/45',
        'https://microsoft.ai/job/mts-ai-platform-engineer-2',
      ],
      lastVerified: _verifiedOct7,
    ),

    // ========================================================================
    // 9. PINECONE
    // ========================================================================
    //
    // EVIDENCE: official pinecone.io job postings. Only terms literally present
    // on those pages are listed. Other languages seen on third-party job
    // aggregators were NOT recorded.

    VerifiedCompanySkillProfile(
      companyId: 'pinecone',
      companyName: 'Pinecone',
      skills: <String>[
        'Rust',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Distributed systems',
        'Database internals',
        'Search and retrieval infrastructure',
        'Performance optimization',
        'Reliability',
        'Scalability',
        'Cloud infrastructure',
      ],
      sourceLabel: 'Official Pinecone job postings (reviewed)',
      sourceUrls: <String>[
        'https://www.pinecone.io/careers/4ef4269b-94c4-4c7c-93ee-15a882caa767/',
        'https://pinecone.io/careers/90ab0c3f-0693-456e-9360-321b0cb31f69',
      ],
      lastVerified: _verifiedOct7,
    ),

    // ========================================================================
    // 10. CURSOR
    // ========================================================================
    //
    // EVIDENCE: ONE official posting (Software Engineer, ML Infrastructure).
    // Only terms literally written in that posting are listed, in the order of
    // the posting.

    VerifiedCompanySkillProfile(
      companyId: 'cursor',
      companyName: 'Cursor',
      skills: <String>[
        'Python',
        'TypeScript',
        'Rust',
        'Go',
      ],
      technologies: <String>[
        'Kubernetes',
        'Linux',
        'Ray',
        'Slurm',
        'NVIDIA GPUs',
        'InfiniBand',
        'RoCE',
      ],
      engineeringConcepts: <String>[
        'GPU infrastructure',
        'Distributed storage',
        'Networking infrastructure',
        'Infrastructure as code',
        'Workload scheduling',
        'Reinforcement learning',
        'Training reliability and throughput',
        'Scalability',
      ],
      sourceLabel: 'Official Cursor job posting (1 posting reviewed)',
      sourceUrls: <String>[
        'https://cursor.com/careers/software-engineer-ml-infrastructure',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 11. GAMMA
    // ========================================================================
    //
    // EVIDENCE: ONE official posting (Research Engineer) including the page's
    // "Engineering at Gamma" tech-stack section. Only terms literally on the
    // page are listed, in the order of the page.

    VerifiedCompanySkillProfile(
      companyId: 'gamma',
      companyName: 'Gamma',
      skills: <String>[
        'TypeScript',
        'React',
      ],
      technologies: <String>[
        'Next.js',
        'Vercel',
        'Chakra UI',
        'ProseMirror',
        'Prisma',
        'PostgreSQL',
        'ClickHouse',
        'Kafka',
        'Terraform',
        'ECS Fargate',
        'AIJSX',
        'Vercel AI SDK',
        'Datadog',
        'Braintrust',
      ],
      engineeringConcepts: <String>[
        'LLMs',
        'Vision-language models',
        'Multimodal modeling',
        'Fine-tuning',
        'Post-training',
        'Reinforcement learning',
        'Model evaluation',
        'Observability',
      ],
      sourceLabel: 'Official Gamma job posting (1 posting reviewed)',
      sourceUrls: <String>[
        'https://careers.gamma.app/research-engineer',
      ],
      lastVerified: _verifiedOct8,
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
  /// 2. Canonical company name (including same-entity spelling / legal-name
  ///    variants only; see [_canonicalCompanyKey])
  /// 3. Approved product→company alias, resolved by the canonical company
  ///    registry (for example "Notion AI" → Notion)
  VerifiedCompanySkillProfile? find(String value) {
    final byId = byCompanyId(value);

    if (byId != null) {
      return byId;
    }

    final byName = byCompanyName(value);

    if (byName != null) {
      return byName;
    }

    final identity = VerifiedCompanyData.canonicalIdentity(value);

    if (identity != null) {
      return byCompanyId(identity.companyId);
    }

    return null;
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

  /// Canonicalizes SAME-ENTITY spelling / legal-name variants only.
  ///
  /// This prevents duplicate company identities between:
  /// - Home
  /// - Career
  /// - Company Intelligence
  /// - live ingestion
  /// - legacy data
  ///
  /// POLICY: this table must NOT merge distinct products, divisions or
  /// "<Company> AI" names into a parent company. Such mappings need explicit
  /// approval and belong to the canonical company registry
  /// (verified_company_data.dart). Removed from this table because they are
  /// not approved: 'microsoft-ai', 'openai-ai', 'nvidia-ai', 'anthropic-ai',
  /// 'apple-ai', 'google-ai-deepmind', 'amazon-web-services', 'aws'.
  static String _canonicalCompanyKey(String value) {
    var key = _normalizeCompanyKey(value);

    const aliases = <String, String>{
      // ----------------------------------------------------------------------
      // OpenAI (spelling variant)
      // ----------------------------------------------------------------------
      'open-ai': 'openai',

      // ----------------------------------------------------------------------
      // Google DeepMind (DeepMind is the same entity)
      // ----------------------------------------------------------------------
      'google-deepmind': 'google-deepmind',
      'deepmind': 'google-deepmind',

      // ----------------------------------------------------------------------
      // Microsoft (legal name / ticker of the same entity)
      // ----------------------------------------------------------------------
      'microsoft-corporation': 'microsoft',
      'msft': 'microsoft',

      // ----------------------------------------------------------------------
      // NVIDIA (legal name)
      // ----------------------------------------------------------------------
      'nvidia-corporation': 'nvidia',

      // ----------------------------------------------------------------------
      // Amazon (legal / domain name)
      // ----------------------------------------------------------------------
      'amazon-com': 'amazon',

      // ----------------------------------------------------------------------
      // Apple (legal name)
      // ----------------------------------------------------------------------
      'apple-inc': 'apple',
      'apple-incorporated': 'apple',
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