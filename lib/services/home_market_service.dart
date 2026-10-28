import '../models/home_market_models.dart';
import '../models/models.dart';
import 'verified_company_data.dart';
import 'company_reference_registry.dart';
import 'career_company_relationship_service.dart';
import 'verified_company_skills_step6e3.dart';
import 'home_live_jobs_service.dart';

class HomeMarketService {
  const HomeMarketService();

  // The live job feed is intentionally separate from the synchronous
  // reference snapshot. Keep one client-backed service instance rather than
  // creating a new HTTP client for every Home refresh.
  static final HomeLiveJobsService _liveJobsService = HomeLiveJobsService();

  /// Fetches currently listed jobs from the explicitly configured public ATS
  /// boards. This is asynchronous and must be called by a UI/controller that
  /// can represent loading, empty and failure states.
  ///
  /// This does not turn reference data into live data, and it does not infer
  /// salaries or hiring status for companies without a configured live board.
  Future<LiveJobsResult> fetchLiveJobs({
    int maxJobsPerCompany = 50,
  }) {
    return _liveJobsService.fetchLiveJobs(
      maxJobsPerCompany: maxJobsPerCompany,
    );
  }

  static const CareerCompanyRelationshipService _relationshipService =
      CareerCompanyRelationshipService();

  static const VerifiedCompanySkillsService _companySkillsService =
      VerifiedCompanySkillsService();

  HomeMarketSnapshot getSnapshot() {
    return HomeMarketSnapshot(
      careers: getCareers(),
      areas: getCareerAreas(),
      companies: getCompanies(),
      skillSignals: getSkillSignals(),
      insights: getInsights(),
      hiring: getHiringSnapshots(),
      jobs: getJobs(),
      salaries: getSalaries(),
    );
  }

  // ---------------------------------------------------------------------------
  // CAREERS
  // ---------------------------------------------------------------------------

  List<HomeCareer> getCareers() {
    const meta = HomeDataMeta(
      status: HomeDataStatus.reference,
      type: HomeDataType.career,
      note: 'Curated career reference data. It is not a live hiring feed.',
    );

    return const [
      HomeCareer(
        id: 'software_engineer',
        title: 'Software Engineer',
        shortDescription: 'Builds software products, platforms and systems.',
        overview:
            'Designs, builds, tests and maintains software used by people and organizations.',
        icon: '💻',
        workAreas: [
          'Backend',
          'Frontend',
          'Mobile',
          'Platform',
          'Systems',
        ],
        commonSkills: [
          'Programming',
          'Data Structures',
          'Algorithms',
          'System Design',
        ],
        tools: [
          'Git',
          'Cloud',
          'Databases',
          'APIs',
        ],
        industries: [
          'Technology',
          'FinTech',
          'Healthcare',
          'E-commerce',
        ],
        relatedCompanyIds: [
          'google',
          'microsoft',
          'amazon',
          'apple',
          'meta',
          'nvidia',
          'openai',
          'anthropic',
        ],
        meta: meta,
      ),
      HomeCareer(
        id: 'ai_engineer',
        title: 'AI Engineer',
        shortDescription: 'Builds AI-powered products and intelligent systems.',
        overview:
            'Applies machine learning, software engineering and AI technologies to practical intelligent products.',
        icon: '🤖',
        workAreas: [
          'Applied AI',
          'AI Products',
          'ML Systems',
          'Generative AI',
        ],
        commonSkills: [
          'Python',
          'Machine Learning',
          'APIs',
          'Problem Solving',
        ],
        tools: [
          'PyTorch',
          'TensorFlow',
          'Cloud',
          'LLM APIs',
        ],
        industries: [
          'Technology',
          'Healthcare',
          'Finance',
          'Robotics',
        ],
        relatedCompanyIds: [
          'openai',
          'anthropic',
          'google',
          'microsoft',
          'meta',
          'nvidia',
          'amazon',
        ],
        meta: meta,
      ),
      HomeCareer(
        id: 'ml_engineer',
        title: 'ML Engineer',
        shortDescription: 'Turns machine-learning models into useful systems.',
        overview:
            'Develops, deploys and maintains machine-learning systems and production pipelines.',
        icon: '🧠',
        workAreas: [
          'Model Development',
          'ML Platforms',
          'MLOps',
          'Inference',
        ],
        commonSkills: [
          'Python',
          'Machine Learning',
          'Statistics',
          'Software Engineering',
        ],
        tools: [
          'PyTorch',
          'TensorFlow',
          'Kubernetes',
          'Cloud',
        ],
        industries: [
          'Technology',
          'Finance',
          'Healthcare',
          'Autonomous Systems',
        ],
        relatedCompanyIds: [
          'google',
          'nvidia',
          'microsoft',
          'amazon',
          'meta',
          'openai',
          'anthropic',
        ],
        meta: meta,
      ),
      HomeCareer(
        id: 'data_scientist',
        title: 'Data Scientist',
        shortDescription: 'Uses data, statistics and models to solve problems.',
        overview:
            'Analyzes data, builds models and communicates findings that support products and decisions.',
        icon: '📊',
        workAreas: [
          'Analytics',
          'Experimentation',
          'Predictive Modeling',
          'Decision Science',
        ],
        commonSkills: [
          'Python',
          'Statistics',
          'SQL',
          'Data Analysis',
        ],
        tools: [
          'SQL',
          'Python',
          'Pandas',
          'Jupyter',
        ],
        industries: [
          'Technology',
          'Finance',
          'Healthcare',
          'Retail',
        ],
        relatedCompanyIds: [
          'google',
          'microsoft',
          'amazon',
          'meta',
          'nvidia',
        ],
        meta: meta,
      ),
      HomeCareer(
        id: 'nlp_engineer',
        title: 'NLP Engineer',
        shortDescription: 'Builds systems that work with human language.',
        overview:
            'Develops language-processing systems such as search, classification, translation and language-model applications.',
        icon: '🗣️',
        workAreas: [
          'Language AI',
          'Search',
          'Text Processing',
          'Conversational AI',
        ],
        commonSkills: [
          'Python',
          'NLP',
          'Machine Learning',
          'Transformers',
        ],
        tools: [
          'PyTorch',
          'Hugging Face',
          'Python',
          'LLMs',
        ],
        industries: [
          'Technology',
          'Search',
          'Enterprise Software',
        ],
        relatedCompanyIds: [
          'openai',
          'anthropic',
          'google',
          'microsoft',
          'meta',
        ],
        meta: meta,
      ),
      HomeCareer(
        id: 'computer_vision_engineer',
        title: 'Computer Vision Engineer',
        shortDescription: 'Builds systems that understand images and video.',
        overview:
            'Develops perception and visual intelligence systems for images, video and physical-world applications.',
        icon: '👁️',
        workAreas: [
          'Vision AI',
          'Perception',
          'Image Processing',
          'Robotics',
        ],
        commonSkills: [
          'Python',
          'Computer Vision',
          'Deep Learning',
          'Linear Algebra',
        ],
        tools: [
          'PyTorch',
          'OpenCV',
          'TensorFlow',
          'CUDA',
        ],
        industries: [
          'Robotics',
          'Automotive',
          'Healthcare',
          'Technology',
        ],
        relatedCompanyIds: [
          'nvidia',
          'google',
          'meta',
          'amazon',
          'microsoft',
        ],
        meta: meta,
      ),
      HomeCareer(
        id: 'prompt_engineer',
        title: 'Prompt Engineer',
        shortDescription: 'Designs and evaluates instructions for AI systems.',
        overview:
            'Designs, tests and improves instructions and workflows for generative AI systems.',
        icon: '✍️',
        workAreas: [
          'Prompt Design',
          'Evaluation',
          'AI Workflows',
          'Agent Systems',
        ],
        commonSkills: [
          'Prompt Design',
          'Evaluation',
          'LLMs',
          'Communication',
        ],
        tools: [
          'LLM Platforms',
          'Python',
          'Evaluation Tools',
        ],
        industries: [
          'Technology',
          'Enterprise Software',
          'AI Products',
        ],
        relatedCompanyIds: [
          'openai',
          'anthropic',
          'google',
          'microsoft',
          'meta',
        ],
        meta: meta,
      ),
      HomeCareer(
        id: 'ai_researcher',
        title: 'AI Researcher',
        shortDescription: 'Researches new methods, models and AI capabilities.',
        overview:
            'Investigates new algorithms, model architectures, learning methods and AI capabilities.',
        icon: '🔬',
        workAreas: [
          'Research',
          'Deep Learning',
          'Model Architecture',
          'Evaluation',
        ],
        commonSkills: [
          'Mathematics',
          'Machine Learning',
          'Research',
          'Programming',
        ],
        tools: [
          'Python',
          'PyTorch',
          'JAX',
          'Research Papers',
        ],
        industries: [
          'AI Research',
          'Technology',
          'Robotics',
          'Academia',
        ],
        relatedCompanyIds: [
          'openai',
          'anthropic',
          'google',
          'microsoft',
          'meta',
          'nvidia',
        ],
        meta: meta,
      ),
      HomeCareer(
        id: 'ai_product_manager',
        title: 'AI Product Manager',
        shortDescription:
            'Guides AI products from user problem to product delivery.',
        overview:
            'Connects user needs, product strategy, engineering and AI capabilities.',
        icon: '📦',
        workAreas: [
          'Product Strategy',
          'AI Products',
          'Experimentation',
          'Delivery',
        ],
        commonSkills: [
          'Product Thinking',
          'Communication',
          'AI Literacy',
          'Analytics',
        ],
        tools: [
          'Product Analytics',
          'Experimentation',
          'AI Platforms',
        ],
        industries: [
          'Technology',
          'Enterprise',
          'Consumer Products',
        ],
        relatedCompanyIds: [
          'google',
          'microsoft',
          'amazon',
          'meta',
          'openai',
          'anthropic',
        ],
        meta: meta,
      ),
      HomeCareer(
        id: 'llm_engineer',
        title: 'LLM Engineer',
        shortDescription:
            'Builds applications and systems around large language models.',
        overview:
            'Works on model integration, evaluation, retrieval, agents and production language-model systems.',
        icon: '🧬',
        workAreas: [
          'LLM Applications',
          'RAG',
          'Agents',
          'Evaluation',
        ],
        commonSkills: [
          'Python',
          'LLMs',
          'Transformers',
          'APIs',
        ],
        tools: [
          'PyTorch',
          'Hugging Face',
          'Vector Databases',
          'Cloud',
        ],
        industries: [
          'AI',
          'Technology',
          'Enterprise Software',
        ],
        relatedCompanyIds: [
          'openai',
          'anthropic',
          'google',
          'microsoft',
          'meta',
          'nvidia',
        ],
        meta: meta,
      ),
      HomeCareer(
        id: 'robotics_engineer',
        title: 'Robotics Engineer',
        shortDescription: 'Builds intelligent machines and robotic systems.',
        overview:
            'Combines software, perception, controls and hardware to build robotic systems.',
        icon: '🦾',
        workAreas: [
          'Robotics',
          'Perception',
          'Controls',
          'Autonomy',
        ],
        commonSkills: [
          'Programming',
          'Robotics',
          'Computer Vision',
          'Systems',
        ],
        tools: [
          'C++',
          'Python',
          'ROS',
          'Simulation',
        ],
        industries: [
          'Robotics',
          'Automotive',
          'Manufacturing',
          'Technology',
        ],
        relatedCompanyIds: [
          'nvidia',
          'amazon',
          'google',
          'microsoft',
        ],
        meta: meta,
      ),
      HomeCareer(
        id: 'mlops_engineer',
        title: 'MLOps / AI Infrastructure Engineer',
        shortDescription:
            'Builds reliable infrastructure for AI and ML systems.',
        overview:
            'Helps teams train, deploy, monitor and operate machine-learning systems at scale.',
        icon: '☁️',
        workAreas: [
          'MLOps',
          'Infrastructure',
          'Deployment',
          'Monitoring',
        ],
        commonSkills: [
          'Cloud',
          'Python',
          'Containers',
          'CI/CD',
        ],
        tools: [
          'Kubernetes',
          'Docker',
          'AWS',
          'GCP',
          'Azure',
        ],
        industries: [
          'Technology',
          'Cloud',
          'Enterprise Software',
        ],
        relatedCompanyIds: [
          'google',
          'microsoft',
          'amazon',
          'nvidia',
          'meta',
        ],
        meta: meta,
      ),
      HomeCareer(
        id: 'ai_security_engineer',
        title: 'AI Security Engineer',
        shortDescription:
            'Works on security for AI systems and AI-enabled products.',
        overview:
            'Works on securing AI systems, infrastructure, data and AI-enabled applications.',
        icon: '🔐',
        workAreas: [
          'AI Security',
          'Application Security',
          'Threat Modeling',
        ],
        commonSkills: [
          'Security',
          'Programming',
          'Cloud',
          'Threat Modeling',
        ],
        tools: [
          'Cloud Security',
          'Linux',
          'Security Testing',
        ],
        industries: [
          'Technology',
          'Cybersecurity',
          'Enterprise',
        ],
        relatedCompanyIds: [
          'microsoft',
          'google',
          'amazon',
          'nvidia',
        ],
        meta: meta,
      ),
      HomeCareer(
        id: 'data_engineer',
        title: 'Data Engineer',
        shortDescription:
            'Builds systems that collect, transform and serve data.',
        overview:
            'Builds reliable data pipelines, platforms and storage systems used by analytics and AI teams.',
        icon: '🗄️',
        workAreas: [
          'Data Platforms',
          'Pipelines',
          'Warehousing',
          'Streaming',
        ],
        commonSkills: [
          'SQL',
          'Python',
          'Data Modeling',
          'Distributed Systems',
        ],
        tools: [
          'Spark',
          'Kafka',
          'Airflow',
          'Cloud',
        ],
        industries: [
          'Technology',
          'Finance',
          'Healthcare',
          'Retail',
        ],
        relatedCompanyIds: [
          'google',
          'microsoft',
          'amazon',
          'meta',
          'nvidia',
        ],
        meta: meta,
      ),
    ];
  }

  // ---------------------------------------------------------------------------
  // CAREER AREAS
  // ---------------------------------------------------------------------------

  List<HomeCareerArea> getCareerAreas() {
    const meta = HomeDataMeta(
      status: HomeDataStatus.reference,
      type: HomeDataType.industry,
      note: 'Curated career-area reference data.',
    );

    return const [
      HomeCareerArea(
        id: 'ai_ml',
        title: 'AI & ML',
        description:
            'Artificial intelligence, machine learning and intelligent systems.',
        careerIds: [
          'ai_engineer',
          'ml_engineer',
          'nlp_engineer',
          'computer_vision_engineer',
          'prompt_engineer',
          'ai_researcher',
          'llm_engineer',
        ],
        meta: meta,
      ),
      HomeCareerArea(
        id: 'data',
        title: 'Data',
        description: 'Data science, analytics and data engineering.',
        careerIds: [
          'data_scientist',
          'data_engineer',
        ],
        meta: meta,
      ),
      HomeCareerArea(
        id: 'software',
        title: 'Software',
        description: 'Software engineering, platforms and systems.',
        careerIds: [
          'software_engineer',
          'mlops_engineer',
        ],
        meta: meta,
      ),
      HomeCareerArea(
        id: 'security',
        title: 'Security',
        description: 'Security engineering and protection of digital systems.',
        careerIds: [
          'ai_security_engineer',
        ],
        meta: meta,
      ),
      HomeCareerArea(
        id: 'robotics',
        title: 'Robotics',
        description: 'Robotics, perception, autonomy and intelligent machines.',
        careerIds: [
          'robotics_engineer',
          'computer_vision_engineer',
        ],
        meta: meta,
      ),
      HomeCareerArea(
        id: 'product',
        title: 'AI Product',
        description: 'Product roles that work closely with AI technologies.',
        careerIds: [
          'ai_product_manager',
        ],
        meta: meta,
      ),
    ];
  }

  // ---------------------------------------------------------------------------
  // COMPANIES
  // ---------------------------------------------------------------------------

  List<HomeCompany> getCompanies() {
    // The career ↔ company relationship file is the complete reference
    // universe. The evidence registry supplies source-backed details when
    // available. Pending companies are still visible as reference entries,
    // but are explicitly marked as not source-verified yet.
    final companies = companyReferenceEvidence
        .map(_toHomeCompanyFromReference)
        .toList(growable: false);

    return companies.map(_withCanonicalRelationships).toList(growable: false);
  }

  HomeCompany _toHomeCompanyFromReference(
    CompanyReferenceEvidence company,
  ) {
    final sourceUrl = company.careersWebsite.isNotEmpty
        ? company.careersWebsite
        : company.officialWebsite;

    final source = HomeSourceInfo(
      name: company.sourceChecked
          ? 'Official company / careers source'
          : 'Career-company relationship reference',
      url: sourceUrl,
      note: company.sourceChecked
          ? 'Source-backed company reference information. This is not live hiring data.'
          : 'Company is present in the career relationship map. Official source verification is pending.',
      isOfficial: company.sourceChecked,
    );

    final meta = HomeDataMeta(
      status: HomeDataStatus.reference,
      type: HomeDataType.company,
      source: source,
      note: company.sourceChecked
          ? 'Source-backed reference information. It does not mean the company is hiring now.'
          : 'Relationship reference only. Official company details are still being verified.',
    );

    final companyId = _companyId(company.canonicalName);
    final preliminaryCareers = _relationshipService
        .careersForCompany(
          _referenceHomeCompany(
            id: companyId,
            name: company.canonicalName,
            meta: meta,
          ),
          getCareers(),
        )
        .map((career) => career.id)
        .toList(growable: false);

    return HomeCompany(
      id: companyId,
      name: company.canonicalName,
      country: null,
      headquarters: null,
      description: company.description.isNotEmpty
          ? company.description
          : 'Company relationship reference. Detailed official profile is pending verification.',
      logo: null,
      focusAreas: List<String>.unmodifiable(company.evidenceAreas),
      notableRoles:
          preliminaryCareers.map(_careerTitle).toList(growable: false),
      relatedCareerIds: preliminaryCareers,
      products: const [],
      industries: const [],
      engineeringAreas: List<String>.unmodifiable(company.evidenceAreas),
      website: company.officialWebsite,
      careersUrl: company.careersWebsite,
      meta: meta,
    );
  }

  HomeCompany _referenceHomeCompany({
    required String id,
    required String name,
    required HomeDataMeta meta,
  }) {
    return HomeCompany(
      id: id,
      name: name,
      country: null,
      headquarters: null,
      description: '',
      logo: null,
      focusAreas: const [],
      notableRoles: const [],
      relatedCareerIds: const [],
      products: const [],
      industries: const [],
      engineeringAreas: const [],
      website: '',
      careersUrl: '',
      meta: meta,
    );
  }

  // Legacy converter retained for source compatibility with older callers.
  // It is intentionally NOT used by getCompanies().
  HomeCompany _toHomeCompany(AiCompany company) {
    final verified = VerifiedCompanyData.find(company.name);

    final companyId = verified?.companyId ?? _companyId(company.name);

    final careers = _legacyCareerIdsForCompany(companyId, company.name);

    final sourceUrl = verified != null && verified.sourceUrls.isNotEmpty
        ? verified.sourceUrls.first
        : company.website;

    final source = HomeSourceInfo(
      name: verified?.sourceLabel ?? 'Company reference directory',
      url: sourceUrl,
      note: verified != null
          ? 'Verified company reference source.'
          : 'Company reference information. Verify against the company source before treating it as current.',
      isOfficial: verified != null,
    );

    final meta = HomeDataMeta(
      status: HomeDataStatus.reference,
      type: HomeDataType.company,
      source: source,
      note:
          'Company directory/reference information. It does not mean the company is hiring now.',
    );

    final focusAreas = _split(company.focus);

    return HomeCompany(
      id: companyId,
      name: verified?.companyName ?? company.name,
      country: company.country,
      headquarters: verified?.headquarters,
      description: verified?.description ?? company.description,
      logo: company.icon,
      focusAreas: verified?.engineeringAreas.isNotEmpty == true
          ? List<String>.unmodifiable(verified!.engineeringAreas)
          : focusAreas,
      notableRoles: careers.map(_careerTitle).toList(growable: false),
      relatedCareerIds: careers,
      products: List<String>.unmodifiable(company.products),
      industries: _inferIndustries(company),
      engineeringAreas: verified?.engineeringAreas.isNotEmpty == true
          ? List<String>.unmodifiable(verified!.engineeringAreas)
          : const [],
      website: verified?.officialWebsite ?? company.website,
      careersUrl: verified?.careersWebsite ?? company.website,
      meta: meta,
    );
  }

  /// Applies the canonical Career ↔ Company reference relationship layer
  /// after the complete HomeCompany directory has been built.
  ///
  /// This keeps relationship ownership in CareerCompanyRelationshipService
  /// instead of maintaining a second final relationship database here.
  HomeCompany _withCanonicalRelationships(HomeCompany company) {
    final careers = _relationshipService
        .careersForCompany(company, getCareers())
        .map((career) => career.id)
        .toList(growable: false);

    // Keep legacy compatibility only when the canonical relationship layer
    // has no relationship yet.
    final resolvedCareerIds =
        careers.isNotEmpty ? careers : company.relatedCareerIds;

    return HomeCompany(
      id: company.id,
      name: company.name,
      country: company.country,
      headquarters: company.headquarters,
      description: company.description,
      logo: company.logo,
      focusAreas: company.focusAreas,
      notableRoles: resolvedCareerIds.map(_careerTitle).toList(growable: false),
      relatedCareerIds: resolvedCareerIds,
      products: company.products,
      industries: company.industries,
      engineeringAreas: company.engineeringAreas,
      website: company.website,
      careersUrl: company.careersUrl,
      meta: company.meta,
    );
  }

  // ---------------------------------------------------------------------------
  // SEARCH
  // ---------------------------------------------------------------------------

  List<HomeCareer> searchCareers(String query) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      return getCareers();
    }

    return getCareers().where((career) {
      return [
        career.title,
        career.shortDescription,
        career.overview ?? '',
        ...career.workAreas,
        ...career.commonSkills,
        ...career.tools,
        ...career.industries,
      ].join(' ').toLowerCase().contains(q);
    }).toList(growable: false);
  }

  List<HomeCompany> searchCompanies(String query) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      return getCompanies();
    }

    return getCompanies().where((company) {
      return [
        company.name,
        company.country ?? '',
        company.headquarters ?? '',
        company.description ?? '',
        ...company.focusAreas,
        ...company.notableRoles,
        ...company.relatedCareerIds,
        ...company.products,
        ...company.industries,
        ...company.engineeringAreas,
        ..._companySkillsService.allSignalsFor(company.id),
        ..._companySkillsService.allSignalsFor(company.name),
      ].join(' ').toLowerCase().contains(q);
    }).toList(growable: false);
  }

  // ---------------------------------------------------------------------------
  // LOOKUPS
  // ---------------------------------------------------------------------------

  HomeCareer? getCareerById(String id) {
    final normalized = _normalizeId(id);

    for (final career in getCareers()) {
      if (_normalizeId(career.id) == normalized) {
        return career;
      }
    }

    return null;
  }

  HomeCompany? getCompanyById(String id) {
    final normalized = _normalizeId(id);

    for (final company in getCompanies()) {
      if (_normalizeId(company.id) == normalized) {
        return company;
      }
    }

    return null;
  }

  List<HomeCompany> getCompaniesForCareer(String careerId) {
    final normalizedCareerId = careerId.trim().toLowerCase();

    return getCompanies()
        .where(
          (company) => company.relatedCareerIds.any(
            (id) => id.toLowerCase() == normalizedCareerId,
          ),
        )
        .toList(growable: false);
  }

  List<HomeCareer> getCareersForCompany(String companyId) {
    final company = getCompanyById(companyId);

    if (company == null) {
      return const [];
    }

    return company.relatedCareerIds
        .map(getCareerById)
        .whereType<HomeCareer>()
        .toList(growable: false);
  }

  // ---------------------------------------------------------------------------
  // SKILL SIGNALS
  // ---------------------------------------------------------------------------

  List<HomeSkillSignal> getSkillSignals() {
    const meta = HomeDataMeta(
      status: HomeDataStatus.reference,
      type: HomeDataType.skill,
      note: 'General reference skill signals; not a live demand ranking.',
    );

    return const [
      HomeSkillSignal(
        id: 'programming',
        name: 'Programming',
        summary: 'A foundation across software and many AI engineering paths.',
        relatedCareerIds: [
          'software_engineer',
          'ai_engineer',
          'ml_engineer',
        ],
        meta: meta,
      ),
      HomeSkillSignal(
        id: 'python',
        name: 'Python',
        summary: 'Commonly used across AI, ML, data and automation work.',
        relatedCareerIds: [
          'ai_engineer',
          'ml_engineer',
          'data_scientist',
          'nlp_engineer',
          'llm_engineer',
        ],
        meta: meta,
      ),
      HomeSkillSignal(
        id: 'sql',
        name: 'SQL',
        summary: 'Important for working with structured data and data systems.',
        relatedCareerIds: [
          'data_scientist',
          'data_engineer',
          'software_engineer',
        ],
        meta: meta,
      ),
      HomeSkillSignal(
        id: 'machine_learning',
        name: 'Machine Learning',
        summary: 'A core technical area for many AI and ML roles.',
        relatedCareerIds: [
          'ai_engineer',
          'ml_engineer',
          'data_scientist',
          'ai_researcher',
        ],
        meta: meta,
      ),
      HomeSkillSignal(
        id: 'llms',
        name: 'LLMs',
        summary:
            'Relevant to language-model applications and generative AI work.',
        relatedCareerIds: [
          'llm_engineer',
          'nlp_engineer',
          'ai_engineer',
          'prompt_engineer',
        ],
        meta: meta,
      ),
    ];
  }

  // ---------------------------------------------------------------------------
  // INSIGHTS
  // ---------------------------------------------------------------------------

  List<HomeCareerInsight> getInsights() {
    const meta = HomeDataMeta(
      status: HomeDataStatus.reference,
      type: HomeDataType.insight,
      note: 'General career reference context, not a live market forecast.',
    );

    return const [
      HomeCareerInsight(
        id: 'many_paths',
        title: 'One company can have many engineering paths',
        summary:
            'A technology company may hire across software, AI, ML, data, infrastructure and research roles.',
        relatedCareerIds: [
          'software_engineer',
          'ai_engineer',
          'ml_engineer',
          'data_scientist',
        ],
        meta: meta,
      ),
      HomeCareerInsight(
        id: 'skills_transfer',
        title: 'Skills can transfer across careers',
        summary:
            'Programming, problem solving and data skills can support multiple technical career paths.',
        relatedCareerIds: [
          'software_engineer',
          'ai_engineer',
          'ml_engineer',
          'data_scientist',
        ],
        meta: meta,
      ),
      HomeCareerInsight(
        id: 'company_directory',
        title: 'A company can matter even when it is not hiring',
        summary:
            'Company discovery is separate from live job availability, so the directory can remain useful over time.',
        relatedCareerIds: [],
        meta: meta,
      ),
    ];
  }

  // ---------------------------------------------------------------------------
  // VERIFIED COMPANY SKILLS
  // ---------------------------------------------------------------------------

  /// Returns verified reference skills/technologies/concepts for a company.
  ///
  /// This is NOT live hiring demand.
  List<String> getVerifiedCompanySignals(String companyOrId) {
    return _companySkillsService.allSignalsFor(companyOrId);
  }

  /// Returns verified source URLs for a company's reference skill evidence.
  List<String> getVerifiedCompanySkillSources(String companyOrId) {
    return _companySkillsService.sourceUrlsFor(companyOrId);
  }

  /// Returns the last verification date for a company's skill reference data.
  DateTime? getVerifiedCompanySkillsLastVerified(String companyOrId) {
    return _companySkillsService.lastVerified(companyOrId);
  }

  // ---------------------------------------------------------------------------
  // LIVE DATA PLACEHOLDERS
  //
  // IMPORTANT:
  // These remain empty until the verified live intelligence pipeline is
  // connected. Never replace these with fake/sample current jobs or salaries.
  // ---------------------------------------------------------------------------

  List<HomeJobOpportunity> getJobs() => const [];

  List<HomeHiringSnapshot> getHiringSnapshots() => const [];

  List<HomeSalaryInfo> getSalaries() => const [];

  // ---------------------------------------------------------------------------
  // COMPANY RELATIONSHIP COMPATIBILITY
  // ---------------------------------------------------------------------------
  //
  // Canonical Career ↔ Company relationships now live in:
  // career_company_relationship_service_global.dart
  //
  // This compatibility helper remains for companies that have not yet been
  // fully represented by the canonical relationship layer.
  // ---------------------------------------------------------------------------

  List<String> _legacyCareerIdsForCompany(
    String companyId,
    String companyName,
  ) {
    final normalizedId = companyId.trim().toLowerCase();

    const legacyFallbacks = <String, List<String>>{
      'meta': [
        'software_engineer',
        'ai_engineer',
        'ml_engineer',
        'data_scientist',
        'nlp_engineer',
        'computer_vision_engineer',
        'ai_researcher',
        'llm_engineer',
      ],
      'meta_ai': [
        'software_engineer',
        'ai_engineer',
        'ml_engineer',
        'data_scientist',
        'nlp_engineer',
        'computer_vision_engineer',
        'ai_researcher',
        'llm_engineer',
      ],
    };

    final mapped = legacyFallbacks[normalizedId];
    if (mapped != null) {
      return List<String>.unmodifiable(mapped);
    }

    final normalizedName = companyName.trim().toLowerCase();

    if (normalizedName.contains('meta')) {
      return List<String>.unmodifiable(
        legacyFallbacks['meta']!,
      );
    }

    // Do not invent a relationship for unknown companies.
    //
    // The old implementation used software_engineer as a universal fallback.
    // That was semantically too broad for a worldwide reference system.
    return const [];
  }

  // ---------------------------------------------------------------------------
  // COMPANY ID
  // ---------------------------------------------------------------------------

  String _companyId(String name) {
    final verified = VerifiedCompanyData.find(name);

    if (verified != null) {
      return verified.companyId;
    }

    return name
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  // ---------------------------------------------------------------------------
  // COMPANY INDUSTRIES
  //
  // Do not use engineering roles as industries.
  // This is only a compatibility fallback until the canonical company
  // reference registry provides explicit industry data.
  // ---------------------------------------------------------------------------

  List<String> _inferIndustries(AiCompany company) {
    final value = company.focus.trim();

    if (value.isEmpty) {
      return const [];
    }

    return _split(value);
  }

  // ---------------------------------------------------------------------------
  // CAREER TITLE
  // ---------------------------------------------------------------------------

  String _careerTitle(String id) {
    final career = getCareerById(id);

    return career?.title ?? id;
  }

  static String _normalizeId(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  // ---------------------------------------------------------------------------
  // STRING SPLITTER
  //
  // IMPORTANT:
  // No artificial .take(8) truncation here.
  // UI can limit visible items; the data layer should preserve source data.
  // ---------------------------------------------------------------------------

  List<String> _split(String value) {
    return value
        .split(RegExp(r'[,/|]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }
}
