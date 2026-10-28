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

  static final DateTime _verifiedOct9 = DateTime(2026, 10, 9);

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
      sourceLabel: 'Official Microsoft careers location page — broad evidence, '
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
      sourceLabel: 'Official Anthropic careers landing page — broad evidence',
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
      sourceLabel: 'Official Amazon Jobs posting URLs (specific terms reviewed '
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

    // EVIDENCE: official Pinecone career/job postings reviewed. Only terms
    // explicitly supported by the reviewed official sources are recorded.

    VerifiedCompanySkillProfile(
      companyId: 'pinecone',
      companyName: 'Pinecone',
      skills: <String>[
        'Rust',
        'Go',
        'C++',
        'Python',
        'Java',
        'Backend system architecture',
        'Data engineering',
        'API design',
      ],
      technologies: <String>[
        'Kubernetes',
        'Terraform',
        'Pulumi',
        'AWS',
        'GCP',
        'Azure',
        'Datadog',
      ],
      engineeringConcepts: <String>[
        'Distributed systems',
        'Database internals',
        'Search and retrieval infrastructure',
        'Semantic search',
        'Hybrid retrieval',
        'Retrieval-Augmented Generation (RAG)',
        'Query planning',
        'Retrieval orchestration',
        'Knowledge graph construction',
        'Indexing pipelines',
        'Performance optimization',
        'Reliability',
        'Scalability',
        'Cloud infrastructure',
        'Observability',
        'Agentic reasoning loops',
      ],
      sourceLabel:
          'Official Pinecone career/job postings reviewed, including Search & Retrieval Infrastructure and Database Team postings',
      sourceUrls: <String>[
        'https://www.pinecone.io/careers/4ef4269b-94c4-4c7c-93ee-15a882caa767/',
        'https://pinecone.io/careers/90ab0c3f-0693-456e-9360-321b0cb31f69',
        'https://www.pinecone.io/careers/7ef089cb-a721-4ad8-a6d0-c390e64991d2/',
      ],
      lastVerified: _verifiedOct8,
    ),

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

    // ========================================================================
    // 12. REPLIT
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'replit',
      companyName: 'Replit',
      skills: <String>[
        'Software engineering',
        'Agentic AI',
        'Developer tooling',
        'Cloud development',
        'Full-stack development',
        'Deployment engineering',
        'Collaboration',
      ],
      technologies: <String>[
        'Python',
        'TypeScript',
        'JavaScript',
        'Node.js',
        'React',
        'C++',
        'Golang',
        'Replit Object Storage',
      ],
      engineeringConcepts: <String>[
        'Agentic software creation',
        'Cloud development environments',
        'Application deployment',
        'Collaborative development',
        'Developer infrastructure',
        'AI-assisted coding',
        'Containerized development',
      ],
      sourceLabel:
          'Official Replit careers and product/developer framework pages reviewed',
      sourceUrls: <String>[
        'https://replit.com/careers',
        'https://replit.com/',
        'https://replit.com/template/node-stripe-checkout',
        'https://replit.com/blog/object-storage',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 13. COGNITION AI
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'cognition_ai',
      companyName: 'Cognition AI',
      skills: <String>[
        'Applied AI',
        'Software engineering',
        'Machine learning',
        'Data engineering',
        'ML infrastructure',
        'Post-training',
        'Mid-training',
        'Security engineering',
        'Site reliability engineering',
        'Customer engineering',
      ],
      technologies: <String>[
        'Devin',
        'Devin CLI',
        'AI coding agents',
        'Production software infrastructure',
      ],
      engineeringConcepts: <String>[
        'Autonomous software engineering',
        'Code generation',
        'Model training',
        'Mid-training',
        'Post-training',
        'ML infrastructure',
        'AI agent deployment',
        'Software reliability',
        'Security',
        'Frontier model development',
      ],
      sourceLabel: 'Official Cognition careers and research pages reviewed',
      sourceUrls: <String>[
        'https://cognition.com/careers',
        'https://cognition.com/research',
        'https://cognition.com/',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 14. NOTION
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'notion',
      companyName: 'Notion',
      skills: <String>[
        'Software engineering',
        'AI engineering',
        'Data science',
        'Search engineering',
        'Infrastructure engineering',
        'Security engineering',
        'Developer experience',
        'Platform engineering',
      ],
      technologies: <String>[
        'React',
        'TypeScript',
        'Go',
        'Next.js',
        'Cloud infrastructure',
        'Data platform',
        'Search and context platform',
      ],
      engineeringConcepts: <String>[
        'AI workflows',
        'AI platform engineering',
        'Search and context',
        'Web infrastructure',
        'Developer platforms',
        'Product infrastructure',
        'Data platforms',
        'Infrastructure security',
      ],
      sourceLabel:
          'Official Notion careers and engineering documentation reviewed',
      sourceUrls: <String>[
        'https://www.notion.com/careers',
        'https://www.notion.com/blog/migrating-notion-marketing-to-next-js',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 15. SALESFORCE
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'salesforce',
      companyName: 'Salesforce',
      skills: <String>[
        'Software engineering',
        'AI research',
        'Infrastructure engineering',
        'Distributed systems',
        'Cloud engineering',
        'Data engineering',
        'Security engineering',
        'Forward deployed engineering',
        'Product engineering',
      ],
      technologies: <String>[
        'Java',
        'Python',
        'Go',
        'AWS',
        'Spark',
        'Kafka',
        'Kubernetes',
        'Docker',
        'Terraform',
        'PostgreSQL',
        'Jenkins',
        'React',
        'Spring Boot',
        'Hadoop',
      ],
      engineeringConcepts: <String>[
        'CRM + AI + Data',
        'Distributed systems',
        'Cloud platforms',
        'Agentic AI',
        'Infrastructure at scale',
        'Security by design',
        'Telemetry and observability',
        'AI research to production',
        'High-performance data platforms',
      ],
      sourceLabel:
          'Official Salesforce careers and technology job postings reviewed',
      sourceUrls: <String>[
        'https://careers.salesforce.com/en/our-teams/technology-product/',
        'https://careers.salesforce.com/en/jobs/',
        'https://careers.salesforce.com/en/jobs/jr299724/software-engineering-mts/',
        'https://careers.salesforce.com/en/jobs/jr302312/kafka-lead-software-engineer/',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 16. SERVICENOW
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'servicenow',
      companyName: 'ServiceNow',
      skills: <String>[
        'Software engineering',
        'AI engineering',
        'Machine learning',
        'Platform engineering',
        'Cloud engineering',
        'Distributed systems',
        'Data engineering',
        'SRE',
        'Forward deployed engineering',
        'Full-stack engineering',
      ],
      technologies: <String>[
        'Java',
        'Python',
        'Go',
        'Kubernetes',
        'Docker',
        'Kafka',
        'Apache Iceberg',
        'Apache Flink',
        'Apache Spark',
        'ClickHouse',
        'React',
        'TypeScript',
        'Prometheus',
        'Grafana',
      ],
      engineeringConcepts: <String>[
        'AI platform engineering',
        'AI agents',
        'Distributed systems',
        'High-throughput data pipelines',
        'Cloud-native systems',
        'Scalability',
        'Reliability',
        'Observability',
        'Workflow automation',
        'Retrieval and LLM integration',
      ],
      sourceLabel:
          'Official ServiceNow AI, engineering and job postings reviewed',
      sourceUrls: <String>[
        'https://careers.servicenow.com/teams/ai-engineering-product/',
        'https://careers.servicenow.com/jobs/744000149918201/sr-software-engineer-kubernetes/',
        'https://careers.servicenow.com/jobs/744000150942129/senior-staff-data-platform-software-engineer-java-distributed-systems-kafka/',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 17. META
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'meta',
      companyName: 'Meta',
      skills: <String>[
        'AI research',
        'Machine learning',
        'Software engineering',
        'Computer vision',
        'Natural language processing',
        'Conversational AI',
        'Ranking and recommendations',
        'Speech and audio',
        'Systems research',
        'AI infrastructure',
      ],
      technologies: <String>[
        'PyTorch',
        'TorchScript',
        'DynaBench',
        'MMF',
        'Hydra',
        'Meta AI infrastructure',
      ],
      engineeringConcepts: <String>[
        'Large-scale model training',
        'Model deployment',
        'Computer vision',
        'NLP',
        'Conversational AI',
        'Ranking and recommendation systems',
        'AI systems research',
        'Signal processing',
        'Multimodal AI',
        'AI safety and integrity',
      ],
      sourceLabel:
          'Official Meta AI careers, infrastructure and framework pages reviewed',
      sourceUrls: <String>[
        'https://ai.meta.com/join-us/',
        'https://ai.meta.com/join-us/raise/',
        'https://ai.meta.com/infrastructure/',
        'https://ai.meta.com/resources/frameworks-and-tools/',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 18. LANGCHAIN
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'langchain',
      companyName: 'LangChain',
      skills: <String>[
        'AI agent engineering',
        'LLM application development',
        'Agent evaluation',
        'Observability',
        'Deployment engineering',
        'Developer tooling',
        'Python development',
        'TypeScript development',
      ],
      technologies: <String>[
        'LangChain',
        'LangSmith',
        'Python',
        'TypeScript',
        'Go',
        'Java',
        'OpenTelemetry',
        'Pytest',
        'Vitest',
      ],
      engineeringConcepts: <String>[
        'Agent tracing',
        'Agent evaluation',
        'Agent deployment',
        'Agent observability',
        'Long-horizon agents',
        'Tool use',
        'Multi-agent systems',
        'Memory',
        'Agent improvement loops',
        'Production LLMOps',
      ],
      sourceLabel:
          'Official LangChain careers, LangSmith and engineering pages reviewed',
      sourceUrls: <String>[
        'https://www.langchain.com/careers',
        'https://info.langchain.com/Llm-ops',
        'https://www.langchain.com/langsmith/observability',
        'https://www.langchain.com/blog/langsmith-agent-builder',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 19. TYPEFACE
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'typeface',
      companyName: 'Typeface',
      skills: <String>[
        'Enterprise AI',
        'AI engineering',
        'Software engineering',
        'Product design',
        'Marketing technology',
        'Agentic AI',
        'Personalized content systems',
      ],
      technologies: <String>[
        'Typeface Orchestration Engine',
        'Arc Graph',
        'Arc Fabric',
        'Arc Agents',
        'Arc Loop',
      ],
      engineeringConcepts: <String>[
        'Enterprise AI',
        'Agentic AI',
        'Content orchestration',
        'Personalized content generation',
        'Marketing workflows',
        'AI agents',
        'Enterprise-scale AI applications',
      ],
      sourceLabel: 'Official Typeface careers and product pages reviewed',
      sourceUrls: <String>[
        'https://www.typeface.ai/careers',
        'https://www.typeface.ai/careers/open-roles',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 20. SYNTHESIA
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'synthesia',
      companyName: 'Synthesia',
      skills: <String>[
        'AI engineering',
        'Machine learning',
        'Software engineering',
        'Backend engineering',
        'Agents platform engineering',
        'Security engineering',
        'Frontend engineering',
        'AI video engineering',
      ],
      technologies: <String>[
        'AI tooling',
        'ML systems',
        'Agents platform',
        'AI video systems',
        'Security engineering tooling',
      ],
      engineeringConcepts: <String>[
        'Generative AI video',
        'Machine learning',
        'AI agents',
        'AI tooling',
        'Production software systems',
        'Application security',
        'Fast product iteration',
        'Scalable AI applications',
      ],
      sourceLabel:
          'Official Synthesia careers page and engineering openings reviewed',
      sourceUrls: <String>[
        'https://www.synthesia.io/careers',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 21. SUNO
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'suno',
      companyName: 'Suno',
      skills: <String>[
        'AI engineering',
        'Machine learning',
        'Software engineering',
        'Audio engineering',
        'Data science',
        'Full-stack engineering',
        'Security engineering',
        'Platform engineering',
        'Recommendation systems',
      ],
      technologies: <String>[
        'TypeScript',
        'React',
        'Python',
        'Django',
        'Kafka',
        'Elasticsearch',
        'PostgreSQL',
        'Redis',
        'Next.js',
        'React Native',
        'iOS',
        'Android',
        'Juce',
      ],
      engineeringConcepts: <String>[
        'Generative audio',
        'Music generation',
        'AI model inference',
        'Recommendation systems',
        'Content discovery',
        'Scalable consumer systems',
        'Agentic engineering workflows',
        'Trust and safety systems',
        'Real-time systems',
        'Data pipelines',
      ],
      sourceLabel:
          'Official Suno careers and engineering job postings reviewed',
      sourceUrls: <String>[
        'https://about.suno.com/careers',
        'https://about.suno.com/careers/f8fd9d3e-4ef7-471a-9205-9f7ca5c36c81',
        'https://about.suno.com/careers/adb5c5ef-5897-4acb-8014-0a7f162742d8',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 22. TOGETHER AI
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'together_ai',
      companyName: 'Together AI',
      skills: <String>[
        'AI infrastructure',
        'Inference engineering',
        'GPU systems',
        'Model training',
        'Fine-tuning',
        'Model evaluation',
        'AI agent engineering',
        'Research engineering',
        'Kernel optimization',
      ],
      technologies: <String>[
        'GPU clusters',
        'Inference engines',
        'Together Kernel Collection',
        'FlashAttention',
        'FP4 quantization',
        'Serverless Inference',
        'Dedicated Container Inference',
        'Sandbox',
        'Managed Storage',
      ],
      engineeringConcepts: <String>[
        'Production inference',
        'Inference scheduling',
        'Batching',
        'Hardware-software co-design',
        'GPU kernel optimization',
        'Memory optimization',
        'Fine-tuning',
        'Distillation',
        'Quantization',
        'Long-horizon agents',
        'Tool use',
      ],
      sourceLabel:
          'Official Together AI careers, research and platform pages reviewed',
      sourceUrls: <String>[
        'https://www.together.ai/careers',
        'https://www.together.ai/research',
        'https://www.together.ai/products',
        'https://www.together.ai/',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 23. CEREBRAS SYSTEMS
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'cerebras_systems',
      companyName: 'Cerebras Systems',
      skills: <String>[
        'AI compute',
        'Computer architecture',
        'Software engineering',
        'Machine learning',
        'Inference engineering',
        'Training systems',
        'Systems engineering',
        'Hardware engineering',
        'Performance optimization',
      ],
      technologies: <String>[
        'Cerebras AI systems',
        'Inference runtime',
        'GPU/accelerator systems',
        'Grafana',
        'AI infrastructure testing',
      ],
      engineeringConcepts: <String>[
        'AI acceleration',
        'Inference optimization',
        'Training optimization',
        'Computer architecture',
        'Runtime systems',
        'Hardware-software co-design',
        'AI infrastructure',
        'Performance engineering',
        'Model deployment',
      ],
      sourceLabel:
          'Official Cerebras careers and engineering/internship pages reviewed',
      sourceUrls: <String>[
        'https://www.cerebras.ai/join-us',
        'https://www.cerebras.ai/interns',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 24. SAMBANOVA SYSTEMS
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'sambanova_systems',
      companyName: 'SambaNova Systems',
      skills: <String>[
        'AI computing',
        'Machine learning',
        'Inference engineering',
        'Software engineering',
        'Systems engineering',
        'Enterprise AI',
        'Performance engineering',
      ],
      technologies: <String>[
        'SambaNova AI systems',
        'AI inference platform',
        'AI compute infrastructure',
      ],
      engineeringConcepts: <String>[
        'AI inference',
        'Agentic AI',
        'Accelerated computing',
        'Enterprise AI infrastructure',
        'Performance optimization',
        'AI systems engineering',
        'Production inference',
      ],
      sourceLabel: 'Official SambaNova careers and job openings pages reviewed',
      sourceUrls: <String>[
        'https://sambanova.ai/company/careers',
        'https://sambanova.ai/company/careers/job-openings',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 25. AI21 LABS
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'ai21_labs',
      companyName: 'AI21 Labs',
      skills: <String>[
        'Natural language AI',
        'Machine learning',
        'Research',
        'LLM application development',
        'AI platform development',
      ],
      technologies: <String>[
        'AI21 Python SDK',
        'Python',
        'LangChain',
        'LlamaIndex',
        'AI21 models',
      ],
      engineeringConcepts: <String>[
        'Language models',
        'Generative AI',
        'LLM integration',
        'Enterprise AI',
        'AI model customization',
        'LLM orchestration',
      ],
      sourceLabel:
          'Official AI21 careers, company and developer pages reviewed',
      sourceUrls: <String>[
        'https://www.ai21.com/careers/',
        'https://www.ai21.com/about/',
        'https://www.ai21.com/blog/introducing-ai21s-python-sdk-2-0/',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 26. GROQ
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'groq',
      companyName: 'Groq',
      skills: <String>[
        'AI inference',
        'High-performance computing',
        'Systems engineering',
        'Software engineering',
        'Performance engineering',
        'AI infrastructure',
      ],
      technologies: <String>[
        'Groq inference systems',
        'Groq hardware',
        'AI compute infrastructure',
      ],
      engineeringConcepts: <String>[
        'Low-latency inference',
        'High-performance computing',
        'AI acceleration',
        'Inference optimization',
        'Systems performance',
        'Production AI infrastructure',
      ],
      sourceLabel: 'Official Groq careers page reviewed',
      sourceUrls: <String>[
        'https://groq.com/careers',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 27. REPLICATE
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'replicate',
      companyName: 'Replicate',
      skills: <String>[
        'Machine learning engineering',
        'AI infrastructure',
        'Developer tooling',
        'Model deployment',
        'API engineering',
        'Software engineering',
        'Production ML systems',
      ],
      technologies: <String>[
        'Cog',
        'Python',
        'Go',
        'Docker',
        'HTTP API',
        'GitHub Actions',
        'Replicate API',
      ],
      engineeringConcepts: <String>[
        'Model packaging',
        'Model deployment',
        'GPU orchestration',
        'Autoscaling',
        'Zero-downtime deployment',
        'Production inference',
        'Developer infrastructure',
        'Model versioning',
      ],
      sourceLabel:
          'Official Replicate about, documentation and open-source pages reviewed',
      sourceUrls: <String>[
        'https://replicate.com/about/',
        'https://replicate.com/docs/get-started/deploy-a-custom-model',
        'https://replicate.com/docs/reference/open-source/',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 28. TEMPUS AI
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'tempus_ai',
      companyName: 'Tempus AI',
      skills: <String>[
        'Machine learning',
        'Data science',
        'AI applications',
        'Precision medicine',
        'Multimodal data analysis',
        'Clinical AI',
        'Computational analysis',
      ],
      technologies: <String>[
        'Python',
        'R',
        'Tempus Lens',
        'Foundation models',
        'Large language models',
      ],
      engineeringConcepts: <String>[
        'Multimodal data',
        'Foundation models',
        'Clinical decision support',
        'Algorithmic diagnostics',
        'Machine learning',
        'Precision medicine',
        'AI model deployment',
        'Biomedical data analytics',
      ],
      sourceLabel:
          'Official Tempus AI product/research and careers evidence reviewed',
      sourceUrls: <String>[
        'https://www.tempus.com/careers/',
        'https://investors.tempus.com/news-releases/news-release-details/tempus-introduces-workspaces-its-lens-data-analytics-platform',
        'https://www.tempus.com/events/webinar/unlocking-foundation-models-at-tempus/',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 29. RECURSION PHARMACEUTICALS
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'recursion_pharmaceuticals',
      companyName: 'Recursion Pharmaceuticals',
      skills: <String>[
        'Machine learning',
        'Data science',
        'Drug discovery',
        'TechBio',
        'Software engineering',
        'Computational biology',
        'Research engineering',
      ],
      technologies: <String>[
        'Machine learning platforms',
        'Recursion research infrastructure',
        'Valence Labs ML research infrastructure',
      ],
      engineeringConcepts: <String>[
        'Industrialized drug discovery',
        'Machine learning research',
        'Biological data analysis',
        'Computational biology',
        'AI-driven drug discovery',
        'Research infrastructure',
        'TechBio',
      ],
      sourceLabel: 'Official Recursion careers and company pages reviewed',
      sourceUrls: <String>[
        'https://recursion.com/careers',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 30. INSILICO MEDICINE
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'insilico_medicine',
      companyName: 'Insilico Medicine',
      skills: <String>[
        'Machine learning',
        'Generative modeling',
        'Deep learning',
        'Computational biology',
        'Drug discovery',
        'Scientific computing',
        'AI research',
      ],
      technologies: <String>[
        'PyTorch',
        'Python',
        '3D molecular representations',
        'Generative models',
        'Machine learning workflows',
      ],
      engineeringConcepts: <String>[
        'Structure-aware machine learning',
        'Three-dimensional molecular modeling',
        'Generative modeling',
        'Molecular interaction prediction',
        'Physicochemical property prediction',
        'Computational drug discovery',
        'AI for chemistry',
      ],
      sourceLabel: 'Official Insilico Medicine careers page reviewed',
      sourceUrls: <String>[
        'https://insilico.com/careers',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 31. CLEANLAB
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'cleanlab',
      companyName: 'Cleanlab',
      skills: <String>[
        'Machine learning',
        'Data quality',
        'AI reliability',
        'ML engineering',
        'Data science',
        'Software engineering',
        'NLP',
        'Computer vision',
      ],
      technologies: <String>[
        'Python',
        'cleanlab',
        'scikit-learn',
        'PyTorch',
        'TensorFlow',
        'Keras',
        'skorch',
      ],
      engineeringConcepts: <String>[
        'Data-centric AI',
        'Label error detection',
        'Data quality scoring',
        'Model reliability',
        'AI reliability',
        'Guardrails',
        'Root-cause analysis',
        'Robust ML',
        'AI safety',
      ],
      sourceLabel:
          'Official Cleanlab company, team and technical documentation reviewed',
      sourceUrls: <String>[
        'https://cleanlab.ai/about/',
        'https://cleanlab.ai/team/',
        'https://docs.cleanlab.ai/stable/',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 32. SARVAM AI
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'sarvam_ai',
      companyName: 'Sarvam AI',
      skills: <String>[
        'Machine learning',
        'AI infrastructure',
        'Inference engineering',
        'MLOps',
        'Backend engineering',
        'Data engineering',
        'AI agent engineering',
        'Speech and language AI',
        'Systems engineering',
      ],
      technologies: <String>[
        'Python',
        'Go',
        'Rust',
        'FastAPI',
        'PostgreSQL',
        'Redis',
        'Kubernetes',
        'Docker',
        'Helm',
        'Terraform',
        'Prometheus',
        'Grafana',
        'vLLM',
        'Triton Inference Server',
        'ONNX Runtime',
        'FFmpeg',
      ],
      engineeringConcepts: <String>[
        'Foundational models',
        'AI infrastructure',
        'Inference serving',
        'GPU scheduling',
        'Multi-tenancy',
        'Model evaluation',
        'MLOps',
        'Agentic systems',
        'Speech AI',
        'TTS',
        'ASR',
        'Vision pipelines',
        'Air-gapped deployment',
        'Sovereign AI infrastructure',
      ],
      sourceLabel:
          'Official Sarvam AI careers and engineering postings reviewed',
      sourceUrls: <String>[
        'https://www.sarvam.ai/careers',
        'https://www.sarvam.ai/careers/jobs/fcb15601-6440-41f7-aa79-b9992057a4b2',
        'https://www.sarvam.ai/careers/jobs/86ae80f8-b7eb-43a4-afde-fef58e77e23e',
        'https://www.sarvam.ai/careers/jobs/e7f783e8-6378-4158-97d5-48a397a91698',
        'https://www.sarvam.ai/careers/jobs/48b2c236-a7e7-475d-b98b-4eb942e85dc7',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 33. SAKANA AI
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'sakana_ai',
      companyName: 'Sakana AI',
      skills: <String>[
        'AI research',
        'LLM development',
        'Applied research',
        'Software engineering',
        'Data engineering',
        'Infrastructure engineering',
        'Platform reliability',
        'AI product engineering',
        'Agent engineering',
      ],
      technologies: <String>[
        'React',
        'Next.js',
        'LLM serving infrastructure',
        'GPU infrastructure',
        'Cloud infrastructure',
        'Data pipelines',
        'Benchmarking systems',
      ],
      engineeringConcepts: <String>[
        'Autonomous agents',
        'Multi-agent LLM systems',
        'LLM pre-training',
        'Mid-training',
        'Post-training',
        'Model evaluation',
        'AI research to production',
        'Inference platforms',
        'SLA management',
        'Observability',
        'Cost optimization',
        'Data infrastructure',
      ],
      sourceLabel: 'Official Sakana AI careers and role pages reviewed',
      sourceUrls: <String>[
        'https://sakana.ai/careers/',
        'https://sakana.ai/careers/applied-research-engineer/',
        'https://sakana.ai/careers/software-engineer-product/',
        'https://sakana.ai/careers/infrastructure-platform-reliability-engineer/',
        'https://sakana.ai/careers/software-engineer-research-and-development/',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 34. DATAROBOT
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'datarobot',
      companyName: 'DataRobot',
      skills: <String>[
        'AI engineering',
        'Machine learning',
        'Agentic AI',
        'MLOps',
        'Software engineering',
        'AI governance',
        'Infrastructure engineering',
        'AI security',
        'Professional services engineering',
      ],
      technologies: <String>[
        'Kubernetes',
        'AWS',
        'Azure',
        'GCP',
        'DataRobot AI Platform',
        'GPU accelerators',
        'REST APIs',
        'AI orchestration',
      ],
      engineeringConcepts: <String>[
        'Agentic AI',
        'Generative AI',
        'Predictive AI',
        'AI governance',
        'MLOps',
        'Model deployment',
        'Control planes',
        'Multi-tenancy',
        'GPU scheduling',
        'Distributed systems',
        'Air-gapped deployment',
        'AI observability',
      ],
      sourceLabel:
          'Official DataRobot careers, open positions and AI platform pages reviewed',
      sourceUrls: <String>[
        'https://www.datarobot.com/careers/',
        'https://www.datarobot.com/careers/open-positions/',
        'https://www.datarobot.com/careers/open-positions/job/102602/',
        'https://www.datarobot.com/careers/open-positions/job/102745/',
        'https://www.datarobot.com/product/ai-platform/',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 35. LUMA AI
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'luma_ai',
      companyName: 'Luma AI',
      skills: <String>[
        'AI research',
        'Reinforcement learning',
        'Machine learning',
        'Computer vision',
        'Robotics',
        'Inference engineering',
        'Data infrastructure',
        'Security engineering',
        'Performance optimization',
      ],
      technologies: <String>[
        'Foundation models',
        'World models',
        'GPU infrastructure',
        'Inference systems',
        'Training infrastructure',
        'Data infrastructure',
        'Simulation systems',
      ],
      engineeringConcepts: <String>[
        'Multimodal AI',
        'World models',
        'Reinforcement learning',
        'Foundation models',
        'AI agents',
        'Training infrastructure',
        'Inference optimization',
        'Physical-world reasoning',
        'Simulation',
        'Robotics',
      ],
      sourceLabel:
          'Official Luma careers page and research/engineering role listings reviewed',
      sourceUrls: <String>[
        'https://lumalabs.ai/careers',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 36. LETTA (MEMGPT)
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'letta_memgpt',
      companyName: 'Letta (MemGPT)',
      skills: <String>[
        'AI agent engineering',
        'Machine learning research',
        'Continual learning',
        'LLM post-training',
        'Software engineering',
        'Agent systems',
        'Research engineering',
      ],
      technologies: <String>[
        'MemGPT',
        'Letta',
        'LLMs',
        'Agent harnesses',
        'Persistent context systems',
      ],
      engineeringConcepts: <String>[
        'Agent memory',
        'Persistent context',
        'Continual learning',
        'Self-improvement',
        'Post-training',
        'Agent harnesses',
        'Sleep-time compute',
        'Context learning',
        'Experiential AI agents',
      ],
      sourceLabel: 'Official Letta join-us page reviewed',
      sourceUrls: <String>[
        'https://www.letta.com/join-us/',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // 37. HARVEY AI
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'harvey_ai',
      companyName: 'Harvey AI',
      skills: <String>[
        'AI engineering',
        'Legal technology',
        'Software engineering',
        'Legal engineering',
        'Enterprise AI',
        'AI product development',
        'Professional services technology',
      ],
      technologies: <String>[
        'Harvey AI platform',
        'AI workflows',
        'Legal AI systems',
        'Enterprise AI tooling',
      ],
      engineeringConcepts: <String>[
        'Legal AI',
        'AI-assisted professional services',
        'Enterprise AI workflows',
        'AI product engineering',
        'Production AI systems',
        'Customer-driven AI development',
      ],
      sourceLabel: 'Official Harvey careers page and company evidence reviewed',
      sourceUrls: <String>[
        'https://www.harvey.ai/careers',
      ],
      lastVerified: _verifiedOct8,
    ),
    // ========================================================================
    // EVIDENCE BATCH 2026-10-08 — REMAINING COMPANIES / BATCH R1-A
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'grammarly',
      companyName: 'Grammarly',
      skills: <String>[
        'Artificial intelligence',
        'Data science',
        'Software engineering',
      ],
      technologies: <String>[
        'GrammarlyGO',
      ],
      engineeringConcepts: <String>[
        'Human-centered AI',
        'Generative AI',
        'Context-aware assistance',
        'Enterprise AI security and privacy',
      ],
      sourceLabel: '{label}',
      sourceUrls: <String>[
        'https://www.grammarly.com/careers',
        'https://www.grammarly.com/about',
        'https://www.grammarly.com/business/events-resources/webinar/introducing-grammarly-go',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'hugging_face',
      companyName: 'Hugging Face',
      skills: <String>[
        'Machine learning',
        'Python',
        'Model training',
        'Inference',
        'Data processing',
      ],
      technologies: <String>[
        'Hugging Face Hub',
        'Hugging Face Jobs',
        'Docker',
        'CPUs',
        'GPUs',
        'TPUs',
      ],
      engineeringConcepts: <String>[
        'Open-source AI',
        'Open-source machine learning',
        'Fine-tuning',
        'Model inference',
        'AI compute workflows',
      ],
      sourceLabel: '{label}',
      sourceUrls: <String>[
        'https://huggingface.co/huggingface',
        'https://huggingface.co/docs/hub/en/jobs',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'llamaindex',
      companyName: 'LlamaIndex',
      skills: <String>[
        'Python',
        'Node.js',
        'Kubernetes',
        'Terraform',
        'Postgres',
        'Temporal',
        'Next.js',
        'React',
        'PyTorch',
        'LLM application development',
      ],
      technologies: <String>[
        'Kubernetes',
        'Helm',
        'Terraform',
        'Postgres',
        'Temporal',
        'Prometheus',
        'Grafana',
        'New Relic',
        'ArgoCD',
        'Flux',
        'Next.js',
        'React',
        'vLLM',
        'Pydantic',
      ],
      engineeringConcepts: <String>[
        'AI agents',
        'Document understanding',
        'Production LLM applications',
        'Inference workloads',
        'Evaluation pipelines',
        'Observability',
        'RAG frameworks',
        'Vision-language models',
        'Fine-tuning',
        'Post-training',
        'Synthetic data generation',
      ],
      sourceLabel: '{label}',
      sourceUrls: <String>[
        'https://www.llamaindex.ai/careers',
        'https://www.llamaindex.ai/careers/member-of-technical-staff-infrastructure',
        'https://www.llamaindex.ai/careers/member-of-technical-staff-backend',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'perplexity_ai',
      companyName: 'Perplexity AI',
      skills: <String>[
        'AI engineering',
        'Information retrieval',
        'Research engineering',
        'Agent engineering',
      ],
      technologies: <String>[
        'Perplexity Sonar',
        'Sonar Deep Research',
        'Agent API',
      ],
      engineeringConcepts: <String>[
        'AI search',
        'Retrieval and ranking',
        'Multimodal embeddings',
        'RAG',
        'AI agents',
        'Agent safety',
        'Post-training',
      ],
      sourceLabel: '{label}',
      sourceUrls: <String>[
        'https://www.perplexity.ai/hub/careers',
        'https://www.perplexity.ai/en-GB/hub/blog',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'you_com',
      companyName: 'You.com',
      skills: <String>[
        'AI engineering',
        'Search engineering',
        'API development',
        'Agent engineering',
      ],
      technologies: <String>[
        'Web Search API',
        'Contents API',
        'Answer API',
        'Research API',
        'Finance Research API',
        'MCP',
        'Python SDK',
      ],
      engineeringConcepts: <String>[
        'Real-time web intelligence',
        'AI agents',
        'Search infrastructure',
        'Citation-backed answers',
        'Research automation',
        'Agent tooling',
      ],
      sourceLabel: '{label}',
      sourceUrls: <String>[
        'https://you.com/careers',
        'https://about.you.com/',
        'https://you.com/docs/agents',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'writer',
      companyName: 'WRITER',
      skills: <String>[
        'Enterprise AI engineering',
        'AI agent engineering',
        'Large language model development',
        'Software engineering',
      ],
      technologies: <String>[
        'Palmyra',
        'WRITER Agent',
        'MCP gateway',
        'LLMs',
      ],
      engineeringConcepts: <String>[
        'Agentic AI',
        'Agent memory',
        'Institutional knowledge',
        'Enterprise AI governance',
        'Grounded AI',
        'AI workflow orchestration',
      ],
      sourceLabel: '{label}',
      sourceUrls: <String>[
        'https://writer.com/company/careers/',
        'https://writer.com/company/about/',
        'https://writer.com/engineering/',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'jasper_ai',
      companyName: 'Jasper AI',
      skills: <String>[
        'AI engineering',
        'Platform engineering',
        'DevOps',
        'Kubernetes operations',
        'Security engineering',
      ],
      technologies: <String>[
        'Kubernetes',
        'Database access controls',
        'Audit logs',
        'Jasper APIs',
        'Jasper MCP',
      ],
      engineeringConcepts: <String>[
        'AI-first product development',
        'Developer experience',
        'Cloud infrastructure',
        'Access control',
        'Auditability',
        'AI marketing workflows',
      ],
      sourceLabel: '{label}',
      sourceUrls: <String>[
        'https://www.jasper.ai/careers',
        'https://www.jasper.ai/blog/devx-renaissance-the-death-of-devops',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'descript',
      companyName: 'Descript',
      skills: <String>[
        'Software engineering',
        'AI-assisted editing',
        'Audio and video technology',
        'Content creation software',
      ],
      technologies: <String>[
        'Descript',
        'Underlord',
        'Text-based editing',
        'Prompt-based editing',
      ],
      engineeringConcepts: <String>[
        'Collaborative media editing',
        'AI co-editing',
        'AI-assisted content creation',
        'Media workflows',
      ],
      sourceLabel: '{label}',
      sourceUrls: <String>[
        'https://www.descript.com/careers',
        'https://www.descript.com/about',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'cohere',
      companyName: 'Cohere',
      skills: <String>[
        'Machine learning',
        'Natural language AI',
        'AI research',
        'Enterprise AI engineering',
      ],
      technologies: <String>[
        'Command',
        'Embed v3',
        'Rerank v3.5',
        'Cohere APIs',
        'Amazon SageMaker',
        'Amazon Bedrock',
        'Python SDK',
      ],
      engineeringConcepts: <String>[
        'Foundation models',
        'Generative AI',
        'Embeddings',
        'Reranking',
        'Fine-tuning',
        'Secure enterprise AI',
        'Machine learning research',
      ],
      sourceLabel: '{label}',
      sourceUrls: <String>[
        'https://cohere.com/careers',
        'https://cohere.com/developers',
        'https://cohere.com/blog/introducing-cohere-for-ai',
        'https://docs.cohere.com/docs/cohere-on-aws',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // EVIDENCE BATCH 2026-10-09 — REMAINING COMPANIES / BATCH R1-B
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'udio',
      companyName: 'Udio',
      skills: <String>[
        'Software engineering',
        'Backend engineering',
        'Quantitative research',
        'Data modeling',
      ],
      technologies: <String>[
        'Data modeling and ingestion platform',
      ],
      engineeringConcepts: <String>[
        'Music-generation AI',
        'Backend and infrastructure systems',
      ],
      sourceLabel:
          'Official Udio job board: quantitative research, backend data modeling/ingestion, product infrastructure roles',
      sourceUrls: <String>[
        'https://job-boards.greenhouse.io/udio',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'aleph_alpha',
      companyName: 'Aleph Alpha',
      skills: <String>[
        'Artificial intelligence',
        'Large language models',
        'Software engineering',
      ],
      technologies: <String>[
        'Large language models',
        'AI platform',
      ],
      engineeringConcepts: <String>[
        'Sovereign AI',
        'Enterprise AI deployment',
        'Agentic AI',
      ],
      sourceLabel:
          'Official Aleph Alpha product and company pages describe sovereign LLMs, AI platform and agentic applications',
      sourceUrls: <String>[
        'https://aleph-alpha.com/en/',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'deepseek',
      companyName: 'DeepSeek',
      skills: <String>[
        'Machine learning',
        'AI research',
        'Software engineering',
      ],
      technologies: <String>[
        'Large language models',
      ],
      engineeringConcepts: <String>[
        'Model training',
        'Inference',
        'Reasoning',
        'Agentic coding',
      ],
      sourceLabel:
          'Official DeepSeek research/model pages describe LLM research, training methodology, inference and agent capabilities',
      sourceUrls: <String>[
        'https://www.deepseek.com/en/transparency/',
        'https://www.deepseek.com/en/news/',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'baidu_ai',
      companyName: 'Baidu AI',
      skills: <String>[
        'Machine learning',
        'Natural language processing',
        'Model training',
        'Inference',
      ],
      technologies: <String>[
        'ERNIE',
        'PaddlePaddle',
      ],
      engineeringConcepts: <String>[
        'Pre-training',
        'Fine-tuning',
        'Model evaluation',
        'Text generation',
        'Information extraction',
      ],
      sourceLabel:
          'Official Baidu AI/ERNIE documentation covers model training, evaluation, inference and NLP tasks',
      sourceUrls: <String>[
        'https://ai.baidu.com/ai-doc/index/ERNIE',
        'https://research.baidu.com/Blog/index-view?id=157',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'alibaba_damo',
      companyName: 'Alibaba DAMO',
      skills: <String>[
        'Machine learning',
        'Natural language processing',
        'Visual computing',
        'Research',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Data intelligence',
        'Network security',
        'Machine learning research',
      ],
      sourceLabel:
          'Official Alibaba Group announcement lists DAMO Academy research areas',
      sourceUrls: <String>[
        'https://www.alibabagroup.com/en-US/about-alibaba-memorabilia-1494029069296074752',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'zhipu_ai',
      companyName: 'Zhipu AI',
      skills: <String>[
        'Machine learning',
        'AI research',
        'Software engineering',
      ],
      technologies: <String>[
        'GLM',
        'AutoGLM',
      ],
      engineeringConcepts: <String>[
        'Large language model pre-training',
        'Reasoning',
        'Tool use',
        'Multimodal AI',
        'Agent systems',
      ],
      sourceLabel:
          'Official Zhipu AI research and recruitment pages describe GLM models, agentic systems and multimodal research',
      sourceUrls: <String>[
        'https://www.zhipuai.cn/en/about',
        'https://www.zhipuai.cn/en/research',
        'https://zhipu-ai.jobs.feishu.cn/',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'moonshot_ai',
      companyName: 'Moonshot AI',
      skills: <String>[
        'Artificial intelligence',
        'Software engineering',
        'AI research',
      ],
      technologies: <String>[
        'Kimi',
      ],
      engineeringConcepts: <String>[
        'Large language models',
        'AI product development',
      ],
      sourceLabel:
          'Official Moonshot/Kimi recruitment pages establish the AI company and hiring context; detailed skill fields kept broad',
      sourceUrls: <String>[
        'https://careers.kimi.com/',
        'https://www.kimi.ai/news/kimi-global-hiring',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'krutrim',
      companyName: 'Krutrim',
      skills: <String>[
        'Machine learning',
        'AI research',
        'Software engineering',
      ],
      technologies: <String>[
        'Krutrim AI Labs',
      ],
      engineeringConcepts: <String>[
        'Indic-language AI',
        'Speech language models',
        'Machine translation',
        'AI infrastructure',
      ],
      sourceLabel:
          'Official Krutrim AI Labs lists Indic embeddings, speech LLM, translation and AI infrastructure',
      sourceUrls: <String>[
        'https://ai-labs.olakrutrim.com/',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // EVIDENCE BATCH 2026-10-09 — REMAINING COMPANIES / BATCH R1-C
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'figure_ai',
      companyName: 'Figure AI',
      skills: <String>[
        'Machine learning',
        'Robotics',
        'AI engineering',
        'Data infrastructure',
      ],
      technologies: <String>[
        'Humanoid robotics',
        'Helix AI',
      ],
      engineeringConcepts: <String>[
        'Robot learning',
        'Perception',
        'Pretraining',
        'Reinforcement learning',
        'Training infrastructure',
      ],
      sourceLabel:
          'Official Figure AI career listings include Helix AI roles across pretraining, perception, robot learning, RL and data infrastructure',
      sourceUrls: <String>[
        'https://job-boards.greenhouse.io/figureai',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'one_x_technologies',
      companyName: '1X Technologies',
      skills: <String>[
        'Artificial intelligence',
        'Robotics',
        'Software engineering',
        'Simulation',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Robot learning',
        'Perception',
        'Reinforcement learning',
        'Physics modeling',
        'Robotic controls',
      ],
      sourceLabel:
          'Official 1X careers listings include AI research, robot learning, perception, simulation and robotic controls roles',
      sourceUrls: <String>[
        'https://www.1x.tech/careers',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'boston_dynamics',
      companyName: 'Boston Dynamics',
      skills: <String>[
        'Robotics',
        'Software engineering',
        'Machine learning',
        'Controls engineering',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Robotics simulation',
        'MLOps',
        'Robot controls',
        'Hardware/software testing',
      ],
      sourceLabel:
          'Official Boston Dynamics careers lists robotics simulation, ML Ops, roboticist and software engineering roles',
      sourceUrls: <String>[
        'https://bostondynamics.com/careers/',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'runway',
      companyName: 'Runway',
      skills: <String>[
        'Machine learning',
        'Research engineering',
        'Backend engineering',
        'Infrastructure security',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Foundation models',
        'ML platform',
        'API engineering',
        'Robotics research',
      ],
      sourceLabel:
          'Official Runway careers lists foundation model research, ML platform, backend/API and robotics research roles',
      sourceUrls: <String>[
        'https://runway.com/careers',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'twelve_labs',
      companyName: 'Twelve Labs',
      skills: <String>[
        'Machine learning',
        'AI research',
        'Distributed systems',
        'Software engineering',
      ],
      technologies: <String>[
        'Marengo',
        'Pegasus',
        'Jockey',
      ],
      engineeringConcepts: <String>[
        'Video understanding',
        'Temporal reasoning',
        'Multimodal AI',
        'Semantic search',
        'Video embeddings',
      ],
      sourceLabel:
          'Official TwelveLabs careers and engineering descriptions discuss video understanding models, multimodal research and distributed systems',
      sourceUrls: <String>[
        'https://www.twelvelabs.io/careers',
        'https://www.twelvelabs.io/blog/why-i-joined-twelvelabs',
        'https://www.twelvelabs.io/product/product-overview',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'crewai',
      companyName: 'CrewAI',
      skills: <String>[
        'Python',
        'Software engineering',
        'AI engineering',
      ],
      technologies: <String>[
        'CrewAI Crews',
        'CrewAI Flows',
        'CrewAI AMP',
      ],
      engineeringConcepts: <String>[
        'Agent orchestration',
        'Event-driven workflows',
        'Task management',
        'Tool integration',
        'Observability',
      ],
      sourceLabel:
          'Official CrewAI documentation describes Python agent framework, crews, flows, tool integration and production deployment',
      sourceUrls: <String>[
        'https://docs.crewai.com/core-concepts/Agents',
        'https://docs.crewai.com/enterprise/introduction',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'weaviate',
      companyName: 'Weaviate',
      skills: <String>[
        'Software engineering',
        'Machine learning',
        'Search engineering',
      ],
      technologies: <String>[
        'Weaviate vector database',
      ],
      engineeringConcepts: <String>[
        'Vector search',
        'Information retrieval',
        'Unstructured data indexing',
      ],
      sourceLabel:
          'Official Weaviate careers page describes its AI-native vector database and machine-learning-powered search',
      sourceUrls: <String>[
        'https://weaviate.io/company/careers',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'chroma',
      companyName: 'Chroma',
      skills: <String>[
        'Software engineering',
        'Database engineering',
        'Platform engineering',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Database storage',
        'Distributed systems',
        'Search infrastructure',
        'AI agent context retrieval',
      ],
      sourceLabel:
          'Official Chroma careers page lists database storage, distributed systems, platform and product engineering roles',
      sourceUrls: <String>[
        'https://www.trychroma.com/careers',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // EVIDENCE BATCH 2026-10-09 — REMAINING COMPANIES / BATCH R1-D
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'weights_biases',
      companyName: 'Weights & Biases',
      skills: <String>[
        'Python',
        'Machine learning',
        'Software engineering',
        'Data analysis',
      ],
      technologies: <String>[
        'Weights & Biases SDK',
        'Weave',
      ],
      engineeringConcepts: <String>[
        'Experiment tracking',
        'Model evaluation',
        'Dataset and model versioning',
        'LLM tracing and evaluation',
      ],
      sourceLabel:
          'Official W&B careers and platform pages describe ML tooling, experiments, evaluation, artifacts and AI observability',
      sourceUrls: <String>[
        'https://wandb.ai/site/careers/',
        'https://wandb.ai/site/blocks/',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'modal',
      companyName: 'Modal',
      skills: <String>[
        'Python',
        'Cloud engineering',
        'Machine learning',
        'Infrastructure engineering',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Container runtime',
        'Scheduling',
        'Inference',
        'LLM fine-tuning',
        'GPU/CPU scaling',
      ],
      sourceLabel:
          'Official Modal company page describes custom file systems, container runtime, scheduler, inference and fine-tuning workloads',
      sourceUrls: <String>[
        'https://modal.com/company',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'coreweave',
      companyName: 'CoreWeave',
      skills: <String>[
        'Cloud engineering',
        'Software engineering',
        'Infrastructure engineering',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'GPU computing',
        'AI hyperscaler infrastructure',
        'Cloud platform engineering',
      ],
      sourceLabel:
          'Official CoreWeave careers and culture pages describe cloud infrastructure purpose-built for GenAI',
      sourceUrls: <String>[
        'https://coreweave.com/careers',
        'https://www.coreweave.com/coreweave-company-culture',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'glean',
      companyName: 'Glean',
      skills: <String>[
        'Machine learning',
        'Data engineering',
        'Software engineering',
        'Search engineering',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Enterprise search',
        'Knowledge retrieval',
        'Grounded enterprise AI',
        'AI agents',
      ],
      sourceLabel:
          'Official Glean company and job-board pages describe enterprise search, knowledge management, assistant and agent systems',
      sourceUrls: <String>[
        'https://www.glean.com/about',
        'https://job-boards.greenhouse.io/gleanwork',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'otter_ai',
      companyName: 'Otter.ai',
      skills: <String>[
        'Machine learning',
        'Speech AI',
        'Backend engineering',
        'Data engineering',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Speech processing',
        'AI agents and LLMs',
        'Search and recommendations',
        'Infrastructure engineering',
      ],
      sourceLabel:
          'Official Otter.ai careers listings include applied speech science, ML, AI-agent/LLM, backend, data infrastructure and search roles',
      sourceUrls: <String>[
        'https://otter.ai/careers?gh_jid=6531765003',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'gong',
      companyName: 'Gong',
      skills: <String>[
        'Software engineering',
        'AI engineering',
        'Data science',
        'Infrastructure engineering',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Revenue intelligence',
        'AI-enabled revenue workflows',
        'Platform reliability',
      ],
      sourceLabel:
          'Official Gong careers page describes R&D teams working across AI, infrastructure and platform reliability',
      sourceUrls: <String>[
        'https://www.gong.io/careers',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'sprinklr',
      companyName: 'Sprinklr',
      skills: <String>[
        'Software engineering',
        'Data analytics',
        'AI and automation',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Unified customer experience management',
        'Omnichannel customer workflows',
        'Real-time customer insights',
      ],
      sourceLabel:
          'Official Sprinklr careers page describes its AI-native Unified-CXM platform and customer-facing product teams',
      sourceUrls: <String>[
        'https://www.sprinklr.com/careers/',
        'https://www.sprinklr.com/careers/find-your-team/',
      ],
      lastVerified: _verifiedOct8,
    ),

    // ========================================================================
    // EVIDENCE BATCH 2026-10-09 — REMAINING COMPANIES / BATCH R1-E
    // ========================================================================
    VerifiedCompanySkillProfile(
      companyId: 'haptik',
      companyName: 'Haptik',
      skills: <String>[
        'Backend engineering',
        'Python',
        'Conversational AI',
        'Voice AI',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Natural language understanding',
        'Generative AI for customer service',
      ],
      sourceLabel:
          'Official Haptik careers listings include backend Python and Voice AI engineering roles',
      sourceUrls: <String>[
        'https://haptik.freshteam.com/jobs',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'yellow_ai',
      companyName: 'Yellow.ai',
      skills: <String>[
        'Software engineering',
        'Conversational AI',
        'Natural language processing',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Conversational automation',
        'Customer and employee experience AI',
      ],
      sourceLabel:
          'Official Yellow.ai careers page describes AI solutions for customer conversations',
      sourceUrls: <String>[
        'https://yellow.ai/career/',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'observe_ai',
      companyName: 'Observe.AI',
      skills: <String>[
        'AI engineering',
        'Software engineering',
        'Speech AI',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'AI agents',
        'AI copilots',
        'Conversation intelligence',
        'Real-time agent assistance',
      ],
      sourceLabel:
          'Official Observe.AI careers page describes AI agents, copilots and conversation intelligence for contact centers',
      sourceUrls: <String>[
        'https://www.observe.ai/careers',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'moveworks',
      companyName: 'Moveworks',
      skills: <String>[
        'Machine learning',
        'Software engineering',
        'Infrastructure engineering',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Agentic search',
        'Enterprise knowledge retrieval',
        'Task automation',
        'Agent evaluation',
      ],
      sourceLabel:
          'Official Moveworks careers listings include ML search, agentic systems and core infrastructure roles',
      sourceUrls: <String>[
        'https://www.moveworks.com/us/en/company/careers',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'darktrace',
      companyName: 'Darktrace',
      skills: <String>[
        'Software engineering',
        'Cybersecurity analysis',
        'Research',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Cyber threat detection',
        'Cyber data visualization',
        'Cloud architectures',
        'AI cyber defense',
      ],
      sourceLabel:
          'Official Darktrace careers page describes software engineering, research, cyber data visualization and cloud architecture',
      sourceUrls: <String>[
        'https://www.darktrace.com/careers',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'crowdstrike',
      companyName: 'CrowdStrike',
      skills: <String>[
        'Software engineering',
        'Cybersecurity',
        'Data engineering',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Distributed systems',
        'AI-enabled security',
        'Threat detection and response',
      ],
      sourceLabel:
          'Official CrowdStrike careers page describes engineering teams working on distributed systems and AI-enabled security',
      sourceUrls: <String>[
        'https://www.crowdstrike.com/en-us/careers/',
      ],
      lastVerified: _verifiedOct8,
    ),

    VerifiedCompanySkillProfile(
      companyId: 'sentinelone',
      companyName: 'SentinelOne',
      skills: <String>[
        'Software engineering',
        'Cybersecurity',
        'Machine learning',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'AI platform engineering',
        'Threat detection',
        'Cloud security',
        'Security automation',
      ],
      sourceLabel:
          'Official SentinelOne careers and job listings include AI platform, infrastructure, detection and response roles',
      sourceUrls: <String>[
        'https://www.sentinelone.com/careers/',
        'https://www.sentinelone.com/jobs/',
      ],
      lastVerified: _verifiedOct8,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'github',
      companyName: 'GitHub',
      skills: <String>[
        'Software engineering',
        'Machine learning',
        'Developer tooling',
      ],
      technologies: <String>[
        'GitHub Copilot',
      ],
      engineeringConcepts: <String>[
        'AI-assisted software development',
        'Code collaboration',
        'Developer productivity',
      ],
      sourceLabel: 'Official GitHub careers and GitHub Copilot product pages',
      sourceUrls: <String>[
        'https://www.github.careers/careers-home',
        'https://github.com/features/copilot',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'adobe',
      companyName: 'Adobe',
      skills: <String>[
        'Software engineering',
        'Machine learning',
        'Applied research',
      ],
      technologies: <String>[
        'Adobe Firefly',
      ],
      engineeringConcepts: <String>[
        'Generative AI',
        'Creative workflows',
        'Digital media systems',
      ],
      sourceLabel: 'Official Adobe careers and Firefly product pages',
      sourceUrls: <String>[
        'https://www.adobe.com/careers.html',
        'https://www.adobe.com/products/firefly.html',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'canva',
      companyName: 'Canva',
      skills: <String>[
        'Software engineering',
        'Product design',
        'Machine learning',
      ],
      technologies: <String>[
        'Canva AI',
      ],
      engineeringConcepts: <String>[
        'AI-assisted design',
        'Visual content generation',
        'Collaborative web applications',
      ],
      sourceLabel: 'Official Canva careers and AI product pages',
      sourceUrls: <String>[
        'https://www.canva.com/careers/',
        'https://www.canva.com/ai/',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'tome',
      companyName: 'Tome',
      skills: <String>[],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'AI-assisted presentation generation',
        'AI text editing',
        'Source-assisted research',
      ],
      sourceLabel:
          'Official Tome help-center product documentation; current hiring evidence not confirmed',
      sourceUrls: <String>[
        'https://tome.app/help/en/collections/5841803-using-ai-in-tome',
        'https://tome.app/help/en/articles/8381205-how-to-use-tome-a-step-by-step-guide',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'casetext',
      companyName: 'Casetext',
      skills: <String>[
        'Software engineering',
        'AI/ML engineering',
        'Legal technology',
      ],
      technologies: <String>[
        'CoCounsel',
      ],
      engineeringConcepts: <String>[
        'Legal research',
        'Document analysis',
        'Retrieval-augmented workflows',
      ],
      sourceLabel:
          'Official Thomson Reuters careers and legal AI product pages; Casetext is represented as its legal-tech product lineage',
      sourceUrls: <String>[
        'https://www.thomsonreuters.com/en/careers',
        'https://www.thomsonreuters.com/en/products-services/legal.html',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'symphonyai',
      companyName: 'SymphonyAI',
      skills: <String>[
        'Software engineering',
        'Machine learning',
        'Data science',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Enterprise AI',
        'Predictive analytics',
        'Data-driven decision systems',
      ],
      sourceLabel:
          'Official SymphonyAI corporate and careers pages; Ayasdi mapped to successor identity',
      sourceUrls: <String>[
        'https://www.symphonyai.com/careers/',
        'https://www.symphonyai.com/',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'fireflies_ai',
      companyName: 'Fireflies.ai',
      skills: <String>[
        'Software engineering',
        'Machine learning',
        'Speech and language processing',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Speech transcription',
        'Meeting summarization',
        'Conversation search',
      ],
      sourceLabel: 'Official Fireflies.ai careers and product pages',
      sourceUrls: <String>[
        'https://fireflies.ai/careers',
        'https://fireflies.ai',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'neets_ai',
      companyName: 'Neets AI',
      skills: <String>[],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Text-to-speech',
        'Voice generation',
        'Audio APIs',
      ],
      sourceLabel:
          'Official Neets AI product website; career-role evidence not confirmed',
      sourceUrls: <String>[
        'https://neets.ai',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'dust',
      companyName: 'Dust',
      skills: <String>[
        'Software engineering',
        'Backend engineering',
        'AI application development',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'AI agents',
        'Enterprise knowledge retrieval',
        'Tool-connected workflows',
      ],
      sourceLabel: 'Official Dust careers and product pages',
      sourceUrls: <String>[
        'https://dust.tt/careers',
        'https://dust.tt',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'imbue',
      companyName: 'Imbue',
      skills: <String>[
        'Software engineering',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'AI agents',
        'First-principles engineering',
        'User-controlled software',
      ],
      sourceLabel: 'Official Imbue careers and about pages',
      sourceUrls: <String>[
        'https://imbue.com/careers/',
        'https://imbue.com/about',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'inflection_ai',
      companyName: 'Inflection AI',
      skills: <String>[],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Conversational AI',
        'AI assistants',
      ],
      sourceLabel:
          'Official Inflection AI company site; current careers page not independently confirmed',
      sourceUrls: <String>[
        'https://inflection.ai',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'adept_ai',
      companyName: 'Adept AI',
      skills: <String>[],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'AI agents',
        'Software task automation',
      ],
      sourceLabel:
          'Official Adept company site; current careers evidence not confirmed',
      sourceUrls: <String>[
        'https://www.adept.ai',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'khan_academy',
      companyName: 'Khan Academy',
      skills: <String>[
        'Software engineering',
        'Product development',
      ],
      technologies: <String>[
        'Khanmigo',
      ],
      engineeringConcepts: <String>[
        'AI tutoring',
        'Learning support',
        'Educational content systems',
      ],
      sourceLabel: 'Official Khan Academy careers and Khan Labs pages',
      sourceUrls: <String>[
        'https://www.khanacademy.org/about/careers',
        'https://www.khanacademy.org/khan-labs',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'duolingo',
      companyName: 'Duolingo',
      skills: <String>[
        'Machine learning',
        'Software engineering',
        'Product development',
      ],
      technologies: <String>[
        'Duolingo Max',
      ],
      engineeringConcepts: <String>[
        'Personalized learning',
        'Adaptive learning',
        'AI-assisted language practice',
      ],
      sourceLabel:
          'Official Duolingo careers and Duolingo Max product information',
      sourceUrls: <String>[
        'https://careers.duolingo.com',
        'https://blog.duolingo.com/duolingo-max/',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'kensho',
      companyName: 'Kensho',
      skills: <String>[
        'Machine learning',
        'Software engineering',
        'MLOps',
        'Research',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Financial information retrieval',
        'Applied AI',
        'Data platforms',
      ],
      sourceLabel: 'Official Kensho careers page and role listings',
      sourceUrls: <String>[
        'https://kensho.com/careers',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'alphasense',
      companyName: 'AlphaSense',
      skills: <String>[
        'Software engineering',
        'AI/ML engineering',
        'Data engineering',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Enterprise search',
        'Document intelligence',
        'Market intelligence',
      ],
      sourceLabel: 'Official AlphaSense careers and product pages',
      sourceUrls: <String>[
        'https://www.alpha-sense.com/careers/',
        'https://www.alpha-sense.com/',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'tesla',
      companyName: 'Tesla',
      skills: <String>[
        'Machine learning',
        'Computer vision',
        'Robotics engineering',
        'Software engineering',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Autonomous driving',
        'Reinforcement learning',
        'AI inference',
        'Robotics',
      ],
      sourceLabel: 'Official Tesla careers and Tesla AI role listings',
      sourceUrls: <String>[
        'https://www.tesla.com/careers',
        'https://www.tesla.com/careers/search?query=AI%20engineer',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'waymo',
      companyName: 'Waymo',
      skills: <String>[
        'Software engineering',
        'Machine learning',
        'Robotics',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Autonomous driving',
        'Perception',
        'Planning and simulation',
      ],
      sourceLabel: 'Official Waymo careers and company pages',
      sourceUrls: <String>[
        'https://careers.withwaymo.com/',
        'https://waymo.com/',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'midjourney',
      companyName: 'Midjourney',
      skills: <String>[
        'Software engineering',
        'Machine learning',
        'Product design',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Image generation',
        'Video generation',
        'Inference optimization',
        'Cloud infrastructure',
      ],
      sourceLabel:
          'Official Midjourney careers page and team/role descriptions',
      sourceUrls: <String>[
        'https://www.midjourney.com/careers',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'stability_ai',
      companyName: 'Stability AI',
      skills: <String>[
        'Machine learning',
        'Research',
        'Software engineering',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Generative models',
        'Model training',
        'Inference systems',
      ],
      sourceLabel: 'Official Stability AI company and careers pages',
      sourceUrls: <String>[
        'https://stability.ai/careers',
        'https://stability.ai/',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'pika',
      companyName: 'Pika',
      skills: <String>[
        'AI research',
        'Software engineering',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Video generation',
        'Generative models',
        'Creative tooling',
      ],
      sourceLabel: 'Official Pika careers page and team descriptions',
      sourceUrls: <String>[
        'https://pika.art/careers',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'abridge',
      companyName: 'Abridge',
      skills: <String>[
        'Software engineering',
        'Machine learning',
        'Speech and language processing',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Clinical documentation',
        'Medical conversation intelligence',
        'Healthcare workflows',
      ],
      sourceLabel: 'Official Abridge careers and product pages',
      sourceUrls: <String>[
        'https://www.abridge.com/careers',
        'https://www.abridge.com/',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'gnani_ai',
      companyName: 'Gnani.ai',
      skills: <String>[
        'Software engineering',
        'Machine learning',
        'Speech and language processing',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Voice automation',
        'Conversational AI',
        'Multilingual speech systems',
      ],
      sourceLabel:
          'Official Gnani.ai corporate and careers pages; Vernacular.ai mapped to successor brand',
      sourceUrls: <String>[
        'https://www.gnani.ai/',
        'https://www.gnani.ai/careers',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'scale_ai',
      companyName: 'Scale AI',
      skills: <String>[
        'Machine learning',
        'Software engineering',
        'Data engineering',
        'Model evaluation',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'RLHF',
        'Data annotation',
        'Model evaluation',
        'AI data infrastructure',
      ],
      sourceLabel: 'Official Scale AI careers and product pages',
      sourceUrls: <String>[
        'https://scale.com/careers',
        'https://scale.com/',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'tabnine',
      companyName: 'Tabnine',
      skills: <String>[
        'Software engineering',
        'Machine learning',
        'Developer tooling',
      ],
      technologies: <String>[
        'Tabnine',
      ],
      engineeringConcepts: <String>[
        'AI code completion',
        'Code generation',
        'Developer productivity',
      ],
      sourceLabel: 'Official Tabnine careers and product pages',
      sourceUrls: <String>[
        'https://www.tabnine.com/careers',
        'https://www.tabnine.com/',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'windsurf',
      companyName: 'Windsurf',
      skills: <String>[
        'Software engineering',
        'Machine learning',
        'Developer tooling',
      ],
      technologies: <String>[
        'Windsurf',
      ],
      engineeringConcepts: <String>[
        'AI-assisted coding',
        'Codebase context',
        'Agentic development workflows',
      ],
      sourceLabel:
          'Official Windsurf company/product pages; Codeium mapped to current product identity',
      sourceUrls: <String>[
        'https://windsurf.com/',
        'https://windsurf.com/careers',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'elevenlabs',
      companyName: 'ElevenLabs',
      skills: <String>[
        'Software engineering',
        'Machine learning',
        'Speech and audio processing',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Text-to-speech',
        'Voice generation',
        'Speech recognition',
        'Conversational audio',
      ],
      sourceLabel: 'Official ElevenLabs careers and open-position pages',
      sourceUrls: <String>[
        'https://elevenlabs.io/careers',
        'https://elevenlabs.io/careers/positions',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'mistral_ai',
      companyName: 'Mistral AI',
      skills: <String>[
        'Machine learning',
        'Research',
        'Software engineering',
        'Infrastructure engineering',
      ],
      technologies: <String>[],
      engineeringConcepts: <String>[
        'Foundation models',
        'Model training',
        'Inference optimization',
        'AI deployment',
      ],
      sourceLabel: 'Official Mistral AI careers and company pages',
      sourceUrls: <String>[
        'https://mistral.ai/careers',
        'https://mistral.ai/',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'xai',
      companyName: 'xAI',
      skills: <String>[
        'Machine learning',
        'Research',
        'Software engineering',
        'Infrastructure engineering',
      ],
      technologies: <String>[
        'Grok',
      ],
      engineeringConcepts: <String>[
        'Foundation models',
        'Post-training',
        'Model infrastructure',
        'AI safety',
      ],
      sourceLabel: 'Official xAI open roles and company pages',
      sourceUrls: <String>[
        'https://x.ai/careers/open-roles',
        'https://x.ai/',
      ],
      lastVerified: _verifiedOct9,
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
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
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

  static List<String> get verifiedCompanyIds => _service.verifiedCompanyIds;

  static List<String> get verifiedCompanyNames => _service.verifiedCompanyNames;

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
