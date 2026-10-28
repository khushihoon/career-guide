/// Career Guide — Verified Company Reference Data

///

/// Evidence-safe registry:

/// - Only companies with an official source checked in the current verification

///   pass are included in `_profiles`.

/// - Skills/roles are only populated when the official career/source material

///   supports them.

/// - Current openings remain LIVE data and are not implied by this registry.

/// - Do not treat an empty field as a missing guess to be filled automatically.

///

/// AUTHORITY (locked):

/// - This file is the AUTHORITATIVE registry for canonical company identity and

///   verified reference intelligence.

/// - `company_verification_queue.dart` is workflow data only and never

///   overrides this file.

/// - `sourceChecked` in `company_reference_registry.dart` is evidence metadata,

///   not an independent authority. On conflict, this registry wins.

///

/// ALIAS POLICY (locked; updated 2026-10-08 by explicit owner approval):

/// - Approved product→company canonicalizations (the product name resolves to

///   the parent company identity):

///     Salesforce Einstein   → Salesforce      (profile alias)

///     ServiceNow AI         → ServiceNow      (profile alias)

///     Notion AI             → Notion          (profile alias)

///     Meta AI               → Meta            (profile alias)

///     Suno AI               → Suno            (profile alias)

///     Adobe Firefly         → Adobe           (profile-less)

///     GitHub (Copilot)      → GitHub          (profile-less)

///     Canva AI              → Canva           (profile-less)

///     Duolingo Max          → Duolingo        (profile-less)

///     Khanmigo (Khan Academy) → Khan Academy  (profile-less)

///     Tesla AI              → Tesla           (profile-less)

///   Profile-less entries live in `_approvedProfileLessCanonicalizations`.

///   They give identity only; the parent shows reference data only after the

///   parent has a verified profile.

/// - NOT an alias: Microsoft AI. It is its own entity (own official site and

///   job postings) and is never merged into Microsoft.

/// - Never add an alias only because of a similar name or URL.

///

/// AUDIT NOTE (verification batch 2026-10-05):

/// - Approved product→company canonicalizations this batch:

///     Salesforce Einstein → salesforce

///     ServiceNow AI       → servicenow

/// - Adobe Firefly → Adobe is APPROVED as a relationship canonicalization,

///   but Adobe is NOT registered here because no official Adobe-owned evidence

///   was verified in this batch. Do not create an empty Adobe profile.

///   The identity (not a profile) is exposed through

///   [VerifiedCompanyDataService.canonicalIdentity].

/// - (Superseded on 2026-10-08: Notion AI → Notion and Meta AI → Meta are now

///   approved, see ALIAS POLICY.)

/// - The relationship-layer scope (~98 companies) is broader than this

///   verified registry. Companies not present here remain PENDING_VERIFICATION

///   and must not be fabricated.

/// - Companies added with sources that were not actually reviewed have been

///   removed and returned to the verification queue rather than being

///   represented as verified.

///

/// NOTE ON APPROVED ALIASES:

/// - "Notion AI", "Meta AI" and "Suno AI" now resolve to the "Notion", "Meta"

///   and "Suno" profiles. The "Meta" profile cites the Meta AI careers page

///   (ai.meta.com), which fits the Meta AI alias.

/// - "GitHub (Copilot)", "Canva AI", "Duolingo Max", "Khanmigo (Khan Academy)",

///   "Tesla AI" and "Adobe Firefly" resolve to their parent identity, but the

///   parent has no verified profile yet, so they stay in the verification queue.

/// - "Microsoft AI" has its OWN profile and is not an alias of "Microsoft".

///

/// EVIDENCE BATCH 2026-10-07 (profiles added, each opened and read by hand on

/// official company pages): Microsoft AI, Luma AI, Letta (MemGPT), Harvey AI,

/// Pinecone. Fields not confirmed on an official page were left empty.

///

/// REGISTRY CONSISTENCY:

/// - This file lists ONLY companies whose verification claim is supported.

/// - Any company listed here must NOT appear in

///   company_verification_queue.dart.

/// - Any company NOT listed here should appear in the verification queue.

class VerifiedCompanyProfile {
  final String companyId;

  final String companyName;

  final String officialWebsite;

  final String careersWebsite;

  final String headquarters;

  final String description;

  final List<String> engineeringAreas;

  final List<String> roleFamilies;

  final String sourceLabel;

  final List<String> sourceUrls;

  final List<String> aliases;

  final DateTime lastVerified;

  const VerifiedCompanyProfile({
    required this.companyId,
    required this.companyName,
    required this.officialWebsite,
    required this.careersWebsite,
    required this.headquarters,
    required this.description,
    required this.engineeringAreas,
    required this.roleFamilies,
    required this.sourceLabel,
    required this.sourceUrls,
    required this.aliases,
    required this.lastVerified,
  });
}

/// Canonical identity of a company as defined by this registry.

///

/// This is identity only. It carries no skills, roles, salary or hiring

/// information and never implies that a verified profile exists

/// ([hasVerifiedProfile] says so explicitly).

class CompanyCanonicalIdentity {
  final String companyId;

  final String companyName;

  /// True when a verified reference profile exists for this identity.

  final bool hasVerifiedProfile;

  const CompanyCanonicalIdentity({
    required this.companyId,
    required this.companyName,
    required this.hasVerifiedProfile,
  });
}

class VerifiedCompanyDataService {
  const VerifiedCompanyDataService();

  static final DateTime _verifiedDate = DateTime(2026, 10, 1);

  static final DateTime _verifiedOct7 = DateTime(2026, 10, 7);

  static final DateTime _verifiedOct8 = DateTime(2026, 10, 8);

  static final DateTime _verifiedOct9 = DateTime(2026, 10, 9);

  /// Approved product→company canonicalizations whose parent company has NO

  /// verified profile yet (keys are normalized with [_normalize]). See the

  /// ALIAS POLICY in the file header for the full approved list.

  ///

  /// Only explicitly approved entries belong here. Do NOT add an entry only

  /// because of a similar name or URL, and do NOT create an empty profile to

  /// represent these companies.

  static const Map<String, CompanyCanonicalIdentity>
      _approvedProfileLessCanonicalizations =
      <String, CompanyCanonicalIdentity>{
    'adobe_firefly': CompanyCanonicalIdentity(
      companyId: 'adobe',
      companyName: 'Adobe',
      hasVerifiedProfile: false,
    ),
    'adobe': CompanyCanonicalIdentity(
      companyId: 'adobe',
      companyName: 'Adobe',
      hasVerifiedProfile: false,
    ),
    'github_copilot': CompanyCanonicalIdentity(
      companyId: 'github',
      companyName: 'GitHub',
      hasVerifiedProfile: false,
    ),
    'github': CompanyCanonicalIdentity(
      companyId: 'github',
      companyName: 'GitHub',
      hasVerifiedProfile: false,
    ),
    'canva_ai': CompanyCanonicalIdentity(
      companyId: 'canva',
      companyName: 'Canva',
      hasVerifiedProfile: false,
    ),
    'canva': CompanyCanonicalIdentity(
      companyId: 'canva',
      companyName: 'Canva',
      hasVerifiedProfile: false,
    ),
    'duolingo_max': CompanyCanonicalIdentity(
      companyId: 'duolingo',
      companyName: 'Duolingo',
      hasVerifiedProfile: false,
    ),
    'duolingo': CompanyCanonicalIdentity(
      companyId: 'duolingo',
      companyName: 'Duolingo',
      hasVerifiedProfile: false,
    ),
    'khanmigo_khan_academy': CompanyCanonicalIdentity(
      companyId: 'khan_academy',
      companyName: 'Khan Academy',
      hasVerifiedProfile: false,
    ),
    'khanmigo': CompanyCanonicalIdentity(
      companyId: 'khan_academy',
      companyName: 'Khan Academy',
      hasVerifiedProfile: false,
    ),
    'khan_academy': CompanyCanonicalIdentity(
      companyId: 'khan_academy',
      companyName: 'Khan Academy',
      hasVerifiedProfile: false,
    ),
    'tesla_ai': CompanyCanonicalIdentity(
      companyId: 'tesla',
      companyName: 'Tesla',
      hasVerifiedProfile: false,
    ),
    'tesla': CompanyCanonicalIdentity(
      companyId: 'tesla',
      companyName: 'Tesla',
      hasVerifiedProfile: false,
    ),
  };

  static final List<VerifiedCompanyProfile> _profiles = [
    VerifiedCompanyProfile(
      companyId: 'openai',
      companyName: 'OpenAI',
      officialWebsite: 'https://openai.com',
      careersWebsite: 'https://openai.com/careers',
      headquarters: '',
      description:
          'AI research and product company building and deploying AI systems and products.',
      engineeringAreas: [
        'Applied AI',
        'Software Engineering',
        'Machine Learning',
        'Infrastructure',
        'Robotics',
        'Research Engineering',
      ],
      roleFamilies: [
        'Applied AI Software Engineer',
        'Backend Software Engineer',
        'Camera Software Engineer',
        'Capacity Systems Software Engineer',
        'Control Systems Software Engineer',
        'Forward Deployed Software Engineer',
      ],
      sourceLabel: 'OpenAI Careers',
      sourceUrls: [
        'https://openai.com/careers',
      ],
      aliases: [
        'OpenAI',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'google_deepmind',
      companyName: 'Google DeepMind',
      officialWebsite: 'https://deepmind.google',
      careersWebsite: 'https://deepmind.google/careers',
      headquarters: '',
      description:
          'AI research and engineering organization working across advanced AI systems and applications.',
      engineeringAreas: [
        'AI Research',
        'Machine Learning',
        'Software Engineering',
        'Distributed Computing',
        'Robotics',
        'AI Infrastructure',
      ],
      roleFamilies: [
        'Research Engineer',
        'Software Engineer',
      ],
      sourceLabel: 'Google DeepMind Careers',
      sourceUrls: [
        'https://deepmind.google/careers',
      ],
      aliases: [
        'Google DeepMind',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'microsoft',
      companyName: 'Microsoft',
      officialWebsite: 'https://www.microsoft.com',
      careersWebsite: 'https://careers.microsoft.com',
      headquarters: '',
      description:
          'Technology company spanning software, cloud, AI, developer platforms, devices, and enterprise products.',
      engineeringAreas: [
        'Software Engineering',
        'AI',
        'Cloud',
        'Developer Platforms',
        'Security',
        'Data',
      ],
      roleFamilies: [
        'Senior Software Engineer',
      ],
      sourceLabel: 'Microsoft Careers',
      sourceUrls: [
        'https://careers.microsoft.com',
      ],
      aliases: [
        'Microsoft',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'nvidia',
      companyName: 'NVIDIA',
      officialWebsite: 'https://www.nvidia.com',
      careersWebsite: 'https://www.nvidia.com/en-in/about-nvidia/careers/',
      headquarters: '',
      description:
          'Computing company focused on accelerated computing, graphics, AI, and related hardware and software platforms.',
      engineeringAreas: [
        'AI Computing',
        'GPU Software',
        'Systems Software',
        'Networking',
        'Robotics',
        'Deep Learning',
      ],
      roleFamilies: [
        'Senior Software Engineer',
        'Senior Systems Software Engineer - Machine Learning',
        'Deep Learning Engineer',
        'Security Researcher',
      ],
      sourceLabel: 'NVIDIA Careers',
      sourceUrls: [
        'https://www.nvidia.com/en-in/about-nvidia/careers/',
      ],
      aliases: [
        'NVIDIA',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'anthropic',
      companyName: 'Anthropic',
      officialWebsite: 'https://www.anthropic.com',
      careersWebsite: 'https://www.anthropic.com/careers',
      headquarters: '',
      description:
          'AI company focused on developing AI systems and the infrastructure, research, and safety work around them.',
      engineeringAreas: [
        'AI Research',
        'Machine Learning',
        'Inference',
        'Infrastructure',
        'AI Safety',
        'Distributed Systems',
      ],
      roleFamilies: [
        'Research Engineer / Research Scientist',
        'Machine Learning Infrastructure Engineer',
        'Software Engineer',
        'Infrastructure Engineer',
        'Performance Engineer',
      ],
      sourceLabel: 'Anthropic Careers',
      sourceUrls: [
        'https://www.anthropic.com/careers',
      ],
      aliases: [
        'Anthropic',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'amazon',
      companyName: 'Amazon',
      officialWebsite: 'https://www.amazon.com',
      careersWebsite: 'https://www.amazon.jobs',
      headquarters: '',
      description:
          'Technology and commerce company operating large-scale software, cloud, logistics, devices, and AI systems.',
      engineeringAreas: [
        'Software Development',
        'Machine Learning',
        'Cloud',
        'Distributed Systems',
        'Search',
        'Data',
      ],
      roleFamilies: [
        'Software Development Engineer',
        'Software Development Engineer - II',
        'Software Development Engineer - Machine Learning',
      ],
      sourceLabel: 'Amazon Jobs',
      sourceUrls: [
        'https://www.amazon.jobs',
      ],
      aliases: [
        'Amazon',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'apple',
      companyName: 'Apple',
      officialWebsite: 'https://www.apple.com',
      careersWebsite: 'https://jobs.apple.com',
      headquarters: '',
      description:
          'Technology company building consumer devices, operating systems, software, services, and AI-powered experiences.',
      engineeringAreas: [
        'Software Engineering',
        'Machine Learning',
        'AI Infrastructure',
        'Systems',
        'Hardware',
        'Developer Technologies',
      ],
      roleFamilies: [
        'Machine Learning Engineer',
        'Machine Learning Research Engineer',
        'ML Infrastructure Engineer',
        'Senior Systems Engineer',
        'Senior Software Engineer',
      ],
      sourceLabel: 'Apple Jobs',
      sourceUrls: [
        'https://jobs.apple.com',
      ],
      aliases: [
        'Apple',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'cursor',
      companyName: 'Cursor',
      officialWebsite: 'https://cursor.com',
      careersWebsite: 'https://cursor.com/careers',
      headquarters: '',
      description: 'AI-assisted software development company.',
      engineeringAreas: [
        'Software Engineering',
        'Machine Learning',
        'Infrastructure',
        'Security',
        'Research',
      ],
      roleFamilies: [
        'Software Engineer',
        'ML Engineer',
        'Research Scientist',
        'Security Engineer',
        'Forward Deployed Engineer',
      ],
      sourceLabel: 'Cursor Careers',
      sourceUrls: [
        'https://cursor.com/careers',
      ],
      aliases: [
        'Cursor',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'replit',
      companyName: 'Replit',
      officialWebsite: 'https://replit.com',
      careersWebsite: 'https://replit.com/careers',
      headquarters: '',
      description:
          'Software creation platform building an agentic creation platform.',
      engineeringAreas: [
        'Software Engineering',
        'Agentic AI',
        'Developer Tools',
      ],
      roleFamilies: [
        'Software Engineer',
      ],
      sourceLabel: 'Replit Careers',
      sourceUrls: [
        'https://replit.com/careers',
      ],
      aliases: [
        'Replit',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'cognition_ai',
      companyName: 'Cognition AI',
      officialWebsite: 'https://cognition.com',
      careersWebsite: 'https://cognition.com/careers',
      headquarters: '',
      description: 'AI company building software agents.',
      engineeringAreas: [
        'Applied AI',
        'Software Engineering',
      ],
      roleFamilies: [
        'AI/Software Engineering',
      ],
      sourceLabel: 'Cognition Careers',
      sourceUrls: [
        'https://cognition.com/careers',
      ],
      aliases: [
        'Cognition AI',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'notion',
      companyName: 'Notion',
      officialWebsite: 'https://www.notion.com',
      careersWebsite: 'https://www.notion.com/careers',
      headquarters: '',
      description:
          'Productivity and collaboration software company with AI-enabled products.',
      engineeringAreas: [
        'Software Engineering',
        'Data Science',
        'AI',
        'Product',
      ],
      roleFamilies: [
        'Software Engineer',
        'Data Scientist',
        'Engineering Manager',
      ],
      sourceLabel: 'Notion Careers',
      sourceUrls: [
        'https://www.notion.com/careers',
      ],
      aliases: [
        'Notion',
        'Notion AI',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'salesforce',
      companyName: 'Salesforce',
      officialWebsite: 'https://www.salesforce.com',
      careersWebsite: 'https://careers.salesforce.com/',
      headquarters: '',
      description:
          'Enterprise software company focused on CRM and AI-enabled business applications.',
      engineeringAreas: [
        'AI',
        'Software Engineering',
        'CRM',
        'Data',
      ],
      roleFamilies: [
        'AI/Software roles',
        'Product roles',
        'Customer Success',
      ],
      sourceLabel: 'Salesforce Careers',
      sourceUrls: [
        'https://careers.salesforce.com/',
      ],
      aliases: [
        'Salesforce',
        'Salesforce Einstein',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'servicenow',
      companyName: 'ServiceNow',
      officialWebsite: 'https://www.servicenow.com',
      careersWebsite: 'https://careers.servicenow.com/',
      headquarters: '',
      description:
          'Enterprise software company developing an AI platform for business workflows.',
      engineeringAreas: [
        'AI',
        'Engineering',
        'Product',
        'Enterprise Software',
      ],
      roleFamilies: [
        'AI/Engineering roles',
        'Forward Deployed Engineering',
      ],
      sourceLabel: 'ServiceNow Careers',
      sourceUrls: [
        'https://careers.servicenow.com/',
      ],
      aliases: [
        'ServiceNow',
        'ServiceNow AI',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'meta',
      companyName: 'Meta',
      officialWebsite: 'https://www.meta.com',
      careersWebsite: 'https://ai.meta.com/join-us/',
      headquarters: '',
      description:
          'Technology company researching and developing AI systems and products.',
      engineeringAreas: [
        'AI Research',
        'Machine Learning',
        'Software Engineering',
      ],
      roleFamilies: [
        'Research Scientist',
      ],
      sourceLabel: 'Meta AI Careers',
      sourceUrls: [
        'https://ai.meta.com/join-us/',
      ],
      aliases: [
        'Meta',
        'Meta AI',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'langchain',
      companyName: 'LangChain',
      officialWebsite: 'https://www.langchain.com',
      careersWebsite: 'https://www.langchain.com/careers',
      headquarters: '',
      description:
          'Company building agent engineering and application-development infrastructure.',
      engineeringAreas: [
        'AI Agents',
        'Developer Tools',
        'Infrastructure',
      ],
      roleFamilies: [
        'Engineering',
      ],
      sourceLabel: 'LangChain Careers',
      sourceUrls: [
        'https://www.langchain.com/careers',
      ],
      aliases: [
        'LangChain',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'gamma',
      companyName: 'Gamma',
      officialWebsite: 'https://gamma.app',
      careersWebsite: 'https://careers.gamma.app/',
      headquarters: '',
      description:
          'AI-powered communication and presentation software company.',
      engineeringAreas: [
        'AI',
        'Software Engineering',
        'Data',
        'Security',
      ],
      roleFamilies: [
        'AI Engineer',
        'AI Data Scientist',
        'Research Engineer',
        'Security Engineer',
        'Backend Software Engineer',
        'Data Systems Engineer',
        'Platform Engineer',
      ],
      sourceLabel: 'Gamma Careers',
      sourceUrls: [
        'https://careers.gamma.app/',
      ],
      aliases: [
        'Gamma',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'typeface',
      companyName: 'Typeface',
      officialWebsite: 'https://www.typeface.ai',
      careersWebsite: 'https://www.typeface.ai/careers',
      headquarters: '',
      description:
          'Enterprise AI company focused on personalized content and marketing workflows.',
      engineeringAreas: [
        'Enterprise AI',
        'Engineering',
        'Product Design',
      ],
      roleFamilies: [
        'Engineering & AI',
      ],
      sourceLabel: 'Typeface Careers',
      sourceUrls: [
        'https://www.typeface.ai/careers',
      ],
      aliases: [
        'Typeface',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'synthesia',
      companyName: 'Synthesia',
      officialWebsite: 'https://www.synthesia.io',
      careersWebsite: 'https://www.synthesia.io/careers',
      headquarters: '',
      description:
          'AI video company building tools for business communication and training.',
      engineeringAreas: [
        'AI Video',
        'Software Engineering',
        'Product',
      ],
      roleFamilies: [
        'Engineering roles',
        'Technical Support',
      ],
      sourceLabel: 'Synthesia Careers',
      sourceUrls: [
        'https://www.synthesia.io/careers',
      ],
      aliases: [
        'Synthesia',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'suno',
      companyName: 'Suno',
      officialWebsite: 'https://suno.com',
      careersWebsite: 'https://about.suno.com/careers',
      headquarters: '',
      description: 'AI music company building tools for music creation.',
      engineeringAreas: [
        'AI',
        'Audio Engineering',
        'Software Engineering',
        'Music Technology',
      ],
      roleFamilies: [
        'Software Engineer',
        'AI Engineering',
        'Security Engineer',
        'Detection & Response Engineer',
      ],
      sourceLabel: 'Suno Careers',
      sourceUrls: [
        'https://about.suno.com/careers',
      ],
      aliases: [
        'Suno',
        'Suno AI',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'together_ai',
      companyName: 'Together AI',
      officialWebsite: 'https://www.together.ai',
      careersWebsite: 'https://www.together.ai/careers',
      headquarters: '',
      description:
          'AI infrastructure company focused on software, hardware, algorithms, and models.',
      engineeringAreas: [
        'AI Infrastructure',
        'Inference',
        'Cloud',
        'Software Engineering',
      ],
      roleFamilies: [
        'Software Engineer',
        'AI Infrastructure Engineer',
        'Inference Engineer',
        'Solutions Architect',
      ],
      sourceLabel: 'Together AI Careers',
      sourceUrls: [
        'https://www.together.ai/careers',
      ],
      aliases: [
        'Together AI',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'cerebras_systems',
      companyName: 'Cerebras Systems',
      officialWebsite: 'https://www.cerebras.ai',
      careersWebsite: 'https://www.cerebras.ai/join-us',
      headquarters: '',
      description:
          'AI compute company building specialized systems for AI workloads.',
      engineeringAreas: [
        'AI Compute',
        'Machine Learning',
        'Software',
        'Hardware',
        'Infrastructure',
        'Security',
      ],
      roleFamilies: [
        'ML Engineer',
        'Inference Engineer',
        'Kernel Engineer',
        'Software Engineer',
        'AI Security Engineer',
        'Network Security Engineer',
      ],
      sourceLabel: 'Cerebras Careers',
      sourceUrls: [
        'https://www.cerebras.ai/join-us',
      ],
      aliases: [
        'Cerebras Systems',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'sambanova_systems',
      companyName: 'SambaNova Systems',
      officialWebsite: 'https://sambanova.ai',
      careersWebsite: 'https://sambanova.ai/company/careers',
      headquarters: '',
      description:
          'AI computing company focused on enterprise AI and inference.',
      engineeringAreas: [
        'AI Computing',
        'Inference',
        'Machine Learning',
      ],
      roleFamilies: [
        'AI/ML roles',
        'Inference roles',
      ],
      sourceLabel: 'SambaNova Careers',
      sourceUrls: [
        'https://sambanova.ai/company/careers',
      ],
      aliases: [
        'SambaNova Systems',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'ai21_labs',
      companyName: 'AI21 Labs',
      officialWebsite: 'https://www.ai21.com',
      careersWebsite: 'https://www.ai21.com/careers/',
      headquarters: '',
      description: 'AI company developing language-model technology.',
      engineeringAreas: [
        'Natural Language AI',
        'Machine Learning',
        'Research',
      ],
      roleFamilies: [],
      sourceLabel: 'AI21 Careers',
      sourceUrls: [
        'https://www.ai21.com/careers/',
      ],
      aliases: [
        'AI21 Labs',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'groq',
      companyName: 'Groq',
      officialWebsite: 'https://groq.com',
      careersWebsite: 'https://groq.com/careers-at-groq',
      headquarters: '',
      description: 'AI inference computing company.',
      engineeringAreas: [
        'AI Inference',
        'High-Performance Computing',
      ],
      roleFamilies: [
        'Engineering roles',
      ],
      sourceLabel: 'Groq Careers',
      sourceUrls: [
        'https://groq.com/careers-at-groq',
      ],
      aliases: [
        'Groq',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'replicate',
      companyName: 'Replicate',
      officialWebsite: 'https://replicate.com',
      careersWebsite: 'https://replicate.com/about/jobs',
      headquarters: '',
      description:
          'AI developer infrastructure company providing tools and APIs for running models.',
      engineeringAreas: [
        'AI Infrastructure',
        'APIs',
        'Developer Tools',
      ],
      roleFamilies: [
        'Machine Learning Engineer',
        'Engineering Manager - Models',
      ],
      sourceLabel: 'Replicate Careers',
      sourceUrls: [
        'https://replicate.com/about/jobs',
      ],
      aliases: [
        'Replicate',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'tempus_ai',
      companyName: 'Tempus AI',
      officialWebsite: 'https://www.tempus.com',
      careersWebsite: 'https://www.tempus.com/careers/',
      headquarters: '',
      description:
          'Technology company applying data and AI to precision medicine.',
      engineeringAreas: [
        'AI',
        'Data',
        'Precision Medicine',
      ],
      roleFamilies: [],
      sourceLabel: 'Tempus Careers',
      sourceUrls: [
        'https://www.tempus.com/careers/',
      ],
      aliases: [
        'Tempus AI',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'recursion_pharmaceuticals',
      companyName: 'Recursion Pharmaceuticals',
      officialWebsite: 'https://www.recursion.com',
      careersWebsite: 'https://recursion.com/careers',
      headquarters: '',
      description:
          'Clinical-stage TechBio company using technology and machine learning to industrialize drug discovery.',
      engineeringAreas: [
        'Machine Learning',
        'Data Science',
        'Drug Discovery',
        'TechBio',
      ],
      roleFamilies: [
        'Machine Learning Engineer',
      ],
      sourceLabel: 'Recursion Careers',
      sourceUrls: [
        'https://recursion.com/careers',
      ],
      aliases: [
        'Recursion Pharmaceuticals',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'insilico_medicine',
      companyName: 'Insilico Medicine',
      officialWebsite: 'https://insilico.com',
      careersWebsite: 'https://insilico.com/careers',
      headquarters: '',
      description: 'AI-driven drug discovery company.',
      engineeringAreas: [
        'Machine Learning',
        'AI',
        'Drug Discovery',
        'MLOps',
        'Computational Biology',
      ],
      roleFamilies: [
        'Machine Learning Engineer',
        'ML Researcher',
      ],
      sourceLabel: 'Insilico Medicine Careers',
      sourceUrls: [
        'https://insilico.com/careers',
      ],
      aliases: [
        'Insilico Medicine',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'cleanlab',
      companyName: 'Cleanlab',
      officialWebsite: 'https://cleanlab.ai',
      careersWebsite: 'https://cleanlab.ai/careers',
      headquarters: '',
      description:
          'AI reliability company focused on data and model reliability.',
      engineeringAreas: [
        'AI Reliability',
        'Machine Learning',
        'Data Quality',
      ],
      roleFamilies: [],
      sourceLabel: 'Cleanlab',
      sourceUrls: [
        'https://cleanlab.ai/about/',
      ],
      aliases: [
        'Cleanlab',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'sarvam_ai',
      companyName: 'Sarvam AI',
      officialWebsite: 'https://www.sarvam.ai',
      careersWebsite: 'https://www.sarvam.ai/careers',
      headquarters: '',
      description:
          'AI company building foundational models and enterprise-grade AI systems for India.',
      engineeringAreas: [
        'Foundational Models',
        'AI Infrastructure',
        'Inference',
        'Vision',
        'Security',
      ],
      roleFamilies: [
        'Backend Engineer',
        'Data Scientist',
        'ML Ops Engineer',
        'Researcher',
        'Data Engineer',
        'Security Engineer',
        'AI Infrastructure Engineer',
        'ML Engineer',
      ],
      sourceLabel: 'Sarvam AI Careers',
      sourceUrls: [
        'https://www.sarvam.ai/careers',
      ],
      aliases: [
        'Sarvam AI',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'sakana_ai',
      companyName: 'Sakana AI',
      officialWebsite: 'https://sakana.ai',
      careersWebsite: 'https://sakana.ai/careers/',
      headquarters: '',
      description: 'AI research and product company based in Tokyo.',
      engineeringAreas: [
        'AI Research',
        'LLM',
        'AI Agents',
        'Software Engineering',
        'Data Infrastructure',
      ],
      roleFamilies: [
        'Applied Research Engineer',
        'Software Engineer',
        'Research Software Engineer',
        'LLM Researcher',
        'Data Engineer',
        'Infrastructure/Platform Reliability Engineer',
      ],
      sourceLabel: 'Sakana AI Careers',
      sourceUrls: [
        'https://sakana.ai/careers/',
      ],
      aliases: [
        'Sakana AI',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'datarobot',
      companyName: 'DataRobot',
      officialWebsite: 'https://www.datarobot.com',
      careersWebsite: 'https://www.datarobot.com/careers/',
      headquarters: '',
      description:
          'Enterprise AI company focused on deploying AI and agentic AI into real-world workflows.',
      engineeringAreas: [
        'AI',
        'Enterprise AI',
        'Machine Learning',
      ],
      roleFamilies: [],
      sourceLabel: 'DataRobot Careers',
      sourceUrls: [
        'https://www.datarobot.com/careers/',
      ],
      aliases: [
        'DataRobot',
      ],
      lastVerified: _verifiedDate,
    ),

    VerifiedCompanyProfile(
      companyId: 'microsoft_ai',
      companyName: 'Microsoft AI',
      officialWebsite: 'https://microsoft.ai',
      careersWebsite: 'https://microsoft.ai/careers/',
      headquarters: '',
      description:
          'Microsoft\'s AI organization, building the Copilot personal AI and the platform, inference and data systems behind it.',
      engineeringAreas: [
        'Software Engineering',
        'Data Engineering',
        'AI Platform',
        'Search',
        'Browser (Edge)',
        'Data, Security & Privacy',
        'Copilot',
      ],
      roleFamilies: [
        'Member of Technical Staff, AI Platform Engineer',
        'Member of Technical Staff - Data Engineer',
        'Member of Technical Staff - Principal Data Infrastructure Engineer',
        'Member of Technical Staff - Software Engineer & Machine Learning',
        'Senior Software Engineer (Bing GenAI)',
        'Senior Backend Engineer (Edge)',
        'Senior Product Manager, Copilot AI',
      ],
      sourceLabel: 'Microsoft AI Careers',
      sourceUrls: [
        'https://microsoft.ai/job/page/45',
      ],
      aliases: [
        'Microsoft AI',
      ],
      lastVerified: _verifiedOct7,
    ),

    VerifiedCompanyProfile(
      companyId: 'luma_ai',
      companyName: 'Luma AI',
      officialWebsite: 'https://lumalabs.ai',
      careersWebsite: 'https://lumalabs.ai/careers',
      headquarters: 'Redwood City, CA',
      description:
          'Builds multimodal AI that can generate, understand and operate in the physical world.',
      engineeringAreas: [
        'Research & AI',
        'Frontier Research',
        'Compute',
        'Engineering',
        'Product',
      ],
      roleFamilies: [
        'Research Scientist / Engineer - Reinforcement Learning',
        'Research Scientist - World Model',
        'Research Scientist / Engineer - Performance Optimization',
        'Research Scientist / Engineer - Training Infrastructure',
        'Software Engineer, Inference',
        'Software Engineer - Data Infrastructure',
        'Robotics Engineer',
        'Staff Security Software Engineer',
      ],
      sourceLabel: 'Luma Careers',
      sourceUrls: [
        'https://lumalabs.ai/careers',
      ],
      aliases: [
        'Luma AI',
      ],
      lastVerified: _verifiedOct7,
    ),

    VerifiedCompanyProfile(
      companyId: 'letta_memgpt',
      companyName: 'Letta (MemGPT)',
      officialWebsite: 'https://www.letta.com',
      careersWebsite: 'https://www.letta.com/join-us/',
      headquarters: 'San Francisco, CA',
      description:
          'Builds experiential AI agents that form memories, forge identity and keep learning.',
      engineeringAreas: [
        'Research',
        'Engineering',
        'Agent Memory',
        'Continual Learning',
      ],
      roleFamilies: [
        'Research Engineer / Scientist, Memory',
        'Research Engineer / Scientist, Post-Training',
        'Research Engineer / Scientist, Self-Improvement',
        'Software Engineer, Agent Harness',
      ],
      sourceLabel: 'Letta Careers',
      sourceUrls: [
        'https://www.letta.com/join-us/',
      ],
      aliases: [
        'Letta (MemGPT)',
      ],
      lastVerified: _verifiedOct7,
    ),

    VerifiedCompanyProfile(
      companyId: 'harvey_ai',
      companyName: 'Harvey AI',
      officialWebsite: 'https://www.harvey.ai',
      careersWebsite: 'https://www.harvey.ai/careers',
      headquarters: '',
      description:
          'AI platform for law firms, in-house legal teams and professional services.',
      engineeringAreas: [],
      roleFamilies: [],
      sourceLabel: 'Harvey Careers',
      sourceUrls: [
        'https://www.harvey.ai/careers',
      ],
      aliases: [
        'Harvey AI',
      ],
      lastVerified: _verifiedOct7,
    ),

    VerifiedCompanyProfile(
      companyId: 'pinecone',
      companyName: 'Pinecone',
      officialWebsite: 'https://www.pinecone.io',
      careersWebsite: 'https://www.pinecone.io/careers/',
      headquarters: 'New York, NY',
      description:
          'Knowledge infrastructure for AI: a vector database and knowledge engine for AI applications.',
      engineeringAreas: [
        'Databases',
        'Cloud Infrastructure',
        'Search',
        'Information Retrieval',
        'AI',
      ],
      roleFamilies: [
        'Senior/Staff Software Engineer, Database Team',
        'Senior/Staff Software Engineer, Search & Retrieval Infrastructure',
        'Senior/Staff Software Engineer, Experience Platform',
        'Staff/Principal Product Manager, Database',
      ],
      sourceLabel: 'Pinecone Careers',
      sourceUrls: [
        'https://www.pinecone.io/careers/',
      ],
      aliases: [
        'Pinecone',
      ],
      lastVerified: _verifiedOct7,
    ),

// ========================================================================
// EVIDENCE BATCH 2026-10-08 — REMAINING COMPANIES / BATCH R1-A
// ========================================================================
    VerifiedCompanyProfile(
      companyId: 'grammarly',
      companyName: 'Grammarly',
      officialWebsite: 'https://www.grammarly.com',
      careersWebsite: 'https://www.grammarly.com/careers',
      headquarters: '',
      description:
          'AI communication assistance company building human-centered AI for people and teams.',
      engineeringAreas: [
        'Artificial Intelligence',
        'Software Engineering',
        'Data Science',
      ],
      roleFamilies: [
        'Data Scientist',
      ],
      sourceLabel:
          'Official Grammarly / Superhuman careers and Grammarly AI product evidence',
      sourceUrls: [
        'https://www.grammarly.com/careers',
        'https://www.grammarly.com/about',
        'https://www.grammarly.com/business/events-resources/webinar/introducing-grammarly-go',
      ],
      aliases: [
        'Grammarly',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'hugging_face',
      companyName: 'Hugging Face',
      officialWebsite: 'https://huggingface.co',
      careersWebsite: 'https://huggingface.co/careers',
      headquarters: '',
      description:
          'Open-source AI and machine-learning platform and community focused on democratizing machine learning.',
      engineeringAreas: [
        'Machine Learning',
        'AI Infrastructure',
        'Model Training',
        'Inference',
        'Developer Tools',
      ],
      roleFamilies: [
        'Machine Learning Engineer',
        'Software Engineer',
      ],
      sourceLabel: 'Official Hugging Face organization and Jobs evidence',
      sourceUrls: [
        'https://huggingface.co/huggingface',
        'https://huggingface.co/docs/hub/en/jobs',
      ],
      aliases: [
        'Hugging Face',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'llamaindex',
      companyName: 'LlamaIndex',
      officialWebsite: 'https://www.llamaindex.ai',
      careersWebsite: 'https://www.llamaindex.ai/careers',
      headquarters: 'San Francisco, CA',
      description:
          'AI platform company building agentic document processing, knowledge systems, and production AI workflows.',
      engineeringAreas: [
        'AI Infrastructure',
        'Backend Engineering',
        'Document AI',
        'AI Agents',
        'Applied Research',
      ],
      roleFamilies: [
        'Member of Technical Staff, Infrastructure',
        'Member of Technical Staff, Backend',
        'AI Content Engineer',
        'Member of Technical Staff, Applied Research',
      ],
      sourceLabel: 'Official LlamaIndex careers and engineering role evidence',
      sourceUrls: [
        'https://www.llamaindex.ai/careers',
        'https://www.llamaindex.ai/careers/member-of-technical-staff-infrastructure',
        'https://www.llamaindex.ai/careers/member-of-technical-staff-backend',
      ],
      aliases: [
        'LlamaIndex',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'perplexity_ai',
      companyName: 'Perplexity AI',
      officialWebsite: 'https://www.perplexity.ai',
      careersWebsite: 'https://www.perplexity.ai/hub/careers',
      headquarters: 'San Francisco, CA',
      description:
          'AI company building answer, search, research, and agent products for people who expect accurate and useful information.',
      engineeringAreas: [
        'Artificial Intelligence',
        'Search',
        'Information Retrieval',
        'AI Agents',
        'Research Engineering',
      ],
      roleFamilies: [],
      sourceLabel: 'Official Perplexity Careers and Research evidence',
      sourceUrls: [
        'https://www.perplexity.ai/hub/careers',
        'https://www.perplexity.ai/en-GB/hub/blog',
      ],
      aliases: [
        'Perplexity AI',
        'Perplexity',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'you_com',
      companyName: 'You.com',
      officialWebsite: 'https://you.com',
      careersWebsite: 'https://you.com/careers',
      headquarters: '',
      description:
          'AI company building real-time web intelligence, search infrastructure, APIs, and agent capabilities.',
      engineeringAreas: [
        'Artificial Intelligence',
        'Search Infrastructure',
        'AI Agents',
        'APIs',
        'Research Automation',
      ],
      roleFamilies: [],
      sourceLabel: 'Official You.com Careers and platform evidence',
      sourceUrls: [
        'https://you.com/careers',
        'https://about.you.com/',
        'https://you.com/docs/agents',
      ],
      aliases: [
        'You.com',
        'You',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'writer',
      companyName: 'WRITER',
      officialWebsite: 'https://writer.com',
      careersWebsite: 'https://writer.com/company/careers/',
      headquarters: 'San Francisco, CA',
      description:
          'Enterprise AI company building AI agents, large language models, and AI-powered work orchestration for enterprises.',
      engineeringAreas: [
        'Enterprise AI',
        'AI Agents',
        'Large Language Models',
        'AI Knowledge Management',
        'Software Engineering',
      ],
      roleFamilies: [],
      sourceLabel: 'Official WRITER careers and company engineering evidence',
      sourceUrls: [
        'https://writer.com/company/careers/',
        'https://writer.com/company/about/',
        'https://writer.com/engineering/',
      ],
      aliases: [
        'WRITER',
        'Writer',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'jasper_ai',
      companyName: 'Jasper AI',
      officialWebsite: 'https://www.jasper.ai',
      careersWebsite: 'https://www.jasper.ai/careers',
      headquarters: '',
      description:
          'AI company building enterprise marketing AI products, agents, content workflows, and governed marketing systems.',
      engineeringAreas: [
        'Artificial Intelligence',
        'AI Agents',
        'Marketing AI',
        'Software Engineering',
        'Developer Experience',
      ],
      roleFamilies: [
        'Platform Engineering',
        'Engineering',
      ],
      sourceLabel: 'Official Jasper Careers and engineering evidence',
      sourceUrls: [
        'https://www.jasper.ai/careers',
        'https://www.jasper.ai/blog/devx-renaissance-the-death-of-devops',
      ],
      aliases: [
        'Jasper AI',
        'Jasper',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'descript',
      companyName: 'Descript',
      officialWebsite: 'https://www.descript.com',
      careersWebsite: 'https://www.descript.com/careers',
      headquarters: 'San Francisco, CA',
      description:
          'Software company building collaborative video and audio creation tools with AI-assisted editing workflows.',
      engineeringAreas: [
        'Software Engineering',
        'AI',
        'Video and Audio Technology',
        'Content Creation',
      ],
      roleFamilies: [
        'Software Engineer, Editor Workflows',
        'Software Engineer, Platform',
        'Engineering Manager, Platform',
      ],
      sourceLabel: 'Official Descript Careers and company evidence',
      sourceUrls: [
        'https://www.descript.com/careers',
        'https://www.descript.com/about',
      ],
      aliases: [
        'Descript',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'cohere',
      companyName: 'Cohere',
      officialWebsite: 'https://cohere.com',
      careersWebsite: 'https://cohere.com/careers',
      headquarters: '',
      description:
          'AI company developing foundation models and secure AI solutions for enterprise use.',
      engineeringAreas: [
        'Foundation Models',
        'Machine Learning',
        'Enterprise AI',
        'Natural Language AI',
        'AI Research',
      ],
      roleFamilies: [
        'Research',
        'Engineering',
      ],
      sourceLabel: 'Official Cohere Careers and developer/research evidence',
      sourceUrls: [
        'https://cohere.com/careers',
        'https://cohere.com/developers',
        'https://cohere.com/blog/introducing-cohere-for-ai',
      ],
      aliases: [
        'Cohere',
      ],
      lastVerified: _verifiedOct9,
    ),

// ========================================================================
// EVIDENCE BATCH 2026-10-09 — REMAINING COMPANIES / BATCH R1-B
// ========================================================================
    VerifiedCompanyProfile(
      companyId: 'udio',
      companyName: 'Udio',
      officialWebsite: 'https://www.udio.com',
      careersWebsite: 'https://job-boards.greenhouse.io/udio',
      headquarters: '',
      description:
          'AI music-generation company developing AI experiences for musical artists and listeners.',
      engineeringAreas: [
        'Artificial Intelligence',
        'Music Generation',
        'Software Engineering',
        'Data Infrastructure',
      ],
      roleFamilies: [
        'Software Engineer',
        'Quantitative Researcher',
      ],
      sourceLabel: 'Official Udio careers and company description',
      sourceUrls: [
        'https://job-boards.greenhouse.io/udio',
        'https://help.udio.com/en/articles/10756027-careers-with-udio',
      ],
      aliases: [
        'Udio',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'aleph_alpha',
      companyName: 'Aleph Alpha',
      officialWebsite: 'https://aleph-alpha.com',
      careersWebsite: 'https://aleph-alpha.com/en/careers/',
      headquarters: '',
      description:
          'Provider of specialized sovereign large language models, agentic AI applications and AI platforms for mission-critical environments.',
      engineeringAreas: [
        'Artificial Intelligence',
        'Large Language Models',
        'Sovereign AI',
        'Enterprise AI',
      ],
      roleFamilies: [],
      sourceLabel: 'Official Aleph Alpha website and careers/source evidence',
      sourceUrls: [
        'https://aleph-alpha.com/en/',
        'https://aleph-alpha.com/en/news/organization-aligned-with-strategic-priorities/',
      ],
      aliases: [
        'Aleph Alpha',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'deepseek',
      companyName: 'DeepSeek',
      officialWebsite: 'https://www.deepseek.com',
      careersWebsite: 'https://www.deepseek.com/en/',
      headquarters: '',
      description:
          'AI research team focused on foundational model technology, large language models, reasoning, coding and agent capabilities.',
      engineeringAreas: [
        'AI Research',
        'Large Language Models',
        'Model Training',
        'Inference',
        'Reasoning',
        'Agent Systems',
      ],
      roleFamilies: [
        'AI Researcher',
        'Machine Learning Engineer',
        'Software Engineer',
      ],
      sourceLabel:
          'Official DeepSeek research, model transparency and careers pages',
      sourceUrls: [
        'https://www.deepseek.com/en/transparency/',
        'https://www.deepseek.com/en/news/',
        'https://www.deepseek.com/en/',
      ],
      aliases: [
        'DeepSeek',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'baidu_ai',
      companyName: 'Baidu AI',
      officialWebsite: 'https://ai.baidu.com',
      careersWebsite: 'https://talent.baidu.com/',
      headquarters: '',
      description:
          'Baidu AI platform and model ecosystem including ERNIE models, AI development services and machine-learning tooling.',
      engineeringAreas: [
        'Artificial Intelligence',
        'Natural Language Processing',
        'Machine Learning',
        'Model Training',
        'Inference',
        'Computer Vision',
      ],
      roleFamilies: [
        'Machine Learning Engineer',
        'AI Researcher',
        'Software Engineer',
      ],
      sourceLabel: 'Official Baidu AI and ERNIE developer documentation',
      sourceUrls: [
        'https://ai.baidu.com/',
        'https://ai.baidu.com/ai-doc/index/ERNIE',
        'https://research.baidu.com/Blog/index-view?id=157',
      ],
      aliases: [
        'Baidu AI',
        'Baidu ERNIE',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'alibaba_damo',
      companyName: 'Alibaba DAMO',
      officialWebsite: 'https://damo.alibaba.com',
      careersWebsite: 'https://talent.alibaba.com/',
      headquarters: '',
      description:
          'Alibaba DAMO Academy is a research organization established to conduct advanced technology research, including machine learning, network security, visual computing and natural language processing.',
      engineeringAreas: [
        'AI Research',
        'Machine Learning',
        'Natural Language Processing',
        'Visual Computing',
        'Network Security',
        'Data Intelligence',
      ],
      roleFamilies: [
        'AI Researcher',
        'Machine Learning Engineer',
      ],
      sourceLabel:
          'Official Alibaba Group DAMO Academy announcement and research description',
      sourceUrls: [
        'https://www.alibabagroup.com/en-US/about-alibaba-memorabilia-1494029069296074752',
      ],
      aliases: [
        'Alibaba DAMO',
        'DAMO Academy',
        'Alibaba DAMO Academy',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'zhipu_ai',
      companyName: 'Zhipu AI',
      officialWebsite: 'https://www.zhipuai.cn/en',
      careersWebsite: 'https://zhipu-ai.jobs.feishu.cn/',
      headquarters: '',
      description:
          'AI research and model company developing the GLM family of large language models, agent systems and multimodal AI models.',
      engineeringAreas: [
        'Large Language Models',
        'AI Research',
        'Model Training',
        'Reasoning',
        'Coding Models',
        'Multimodal AI',
        'AI Agents',
      ],
      roleFamilies: [
        'Machine Learning Engineer',
        'AI Researcher',
        'Software Engineer',
      ],
      sourceLabel:
          'Official Zhipu AI / Z.ai company, research and recruitment pages',
      sourceUrls: [
        'https://www.zhipuai.cn/en/about',
        'https://www.zhipuai.cn/en/research',
        'https://zhipu-ai.jobs.feishu.cn/',
      ],
      aliases: [
        'Zhipu AI',
        'ZhipuAI',
        'Z.ai',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'moonshot_ai',
      companyName: 'Moonshot AI',
      officialWebsite: 'https://www.kimi.com',
      careersWebsite: 'https://careers.kimi.com/',
      headquarters: '',
      description:
          'AI company behind Kimi, developing large language model products and AI systems.',
      engineeringAreas: [
        'Artificial Intelligence',
        'Large Language Models',
        'AI Research',
        'Software Engineering',
      ],
      roleFamilies: [
        'AI Researcher',
        'Software Engineer',
      ],
      sourceLabel: 'Official Moonshot/Kimi recruitment and global hiring pages',
      sourceUrls: [
        'https://careers.kimi.com/',
        'https://www.kimi.ai/news/kimi-global-hiring',
      ],
      aliases: [
        'Moonshot AI',
        'Moonshot.AI',
        'Kimi',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'krutrim',
      companyName: 'Krutrim',
      officialWebsite: 'https://krutrim.com',
      careersWebsite: 'https://ai-labs.olakrutrim.com/',
      headquarters: '',
      description:
          'Indian AI company developing Indic-language AI models, speech models, translation systems and AI infrastructure.',
      engineeringAreas: [
        'Artificial Intelligence',
        'Large Language Models',
        'Speech AI',
        'Machine Translation',
        'Indic Languages',
        'AI Infrastructure',
      ],
      roleFamilies: [
        'Machine Learning Engineer',
        'AI Researcher',
        'Software Engineer',
      ],
      sourceLabel:
          'Official Krutrim AI Labs model catalogue and careers section',
      sourceUrls: [
        'https://ai-labs.olakrutrim.com/',
      ],
      aliases: [
        'Krutrim',
        'Krutrim AI',
        'Krutrim AI Labs',
      ],
      lastVerified: _verifiedOct9,
    ),

// ========================================================================
// EVIDENCE BATCH 2026-10-09 — REMAINING COMPANIES / BATCH R1-C
// ========================================================================
    VerifiedCompanyProfile(
      companyId: 'figure_ai',
      companyName: 'Figure AI',
      officialWebsite: 'https://www.figure.ai',
      careersWebsite: 'https://www.figure.ai/careers',
      headquarters: '',
      description:
          'Company developing humanoid robots and embodied AI systems.',
      engineeringAreas: [
        'Humanoid Robotics',
        'Artificial Intelligence',
        'Robot Learning',
        'Perception',
        'Data Infrastructure',
        'Mechanical Engineering',
      ],
      roleFamilies: [
        'AI Engineer',
        'Robotics Engineer',
        'Machine Learning Engineer',
      ],
      sourceLabel: 'Official Figure careers and job-board evidence',
      sourceUrls: [
        'https://www.figure.ai/careers',
        'https://job-boards.greenhouse.io/figureai',
      ],
      aliases: [
        'Figure',
        'Figure AI',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'one_x_technologies',
      companyName: '1X Technologies',
      officialWebsite: 'https://www.1x.tech',
      careersWebsite: 'https://www.1x.tech/careers',
      headquarters: '',
      description:
          'Robotics company building home robots and developing AI systems for physical-world tasks.',
      engineeringAreas: [
        'Robotics',
        'Artificial Intelligence',
        'Robot Learning',
        'Perception',
        'Robotic Controls',
        'Simulation',
        'Hardware Engineering',
      ],
      roleFamilies: [
        'AI Researcher',
        'Robotics Engineer',
        'Software Engineer',
      ],
      sourceLabel: 'Official 1X careers and company pages',
      sourceUrls: [
        'https://www.1x.tech/careers',
        'https://www.1x.tech/',
      ],
      aliases: [
        '1X',
        '1X Technologies',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'boston_dynamics',
      companyName: 'Boston Dynamics',
      officialWebsite: 'https://bostondynamics.com',
      careersWebsite: 'https://bostondynamics.com/careers/',
      headquarters: '',
      description:
          'Robotics company focused on mobile robots and commercial robotics systems.',
      engineeringAreas: [
        'Robotics',
        'Controls Engineering',
        'Machine Learning',
        'Simulation',
        'Software Engineering',
        'Mechanical Engineering',
      ],
      roleFamilies: [
        'Robotics Engineer',
        'Software Engineer',
        'Machine Learning Engineer',
      ],
      sourceLabel: 'Official Boston Dynamics careers page and role listings',
      sourceUrls: [
        'https://bostondynamics.com/careers/',
      ],
      aliases: [
        'Boston Dynamics',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'runway',
      companyName: 'Runway',
      officialWebsite: 'https://runway.com',
      careersWebsite: 'https://runway.com/careers',
      headquarters: '',
      description:
          'AI company building systems to simulate the world through generative media, research and engineering.',
      engineeringAreas: [
        'Generative AI',
        'Foundation Models',
        'Machine Learning',
        'API Engineering',
        'ML Platform',
        'Infrastructure Security',
        'Robotics Research',
      ],
      roleFamilies: [
        'Research Engineer',
        'Applied Research Scientist',
        'Backend Engineer',
        'Machine Learning Engineer',
      ],
      sourceLabel: 'Official Runway careers page and role listings',
      sourceUrls: [
        'https://runway.com/careers',
      ],
      aliases: [
        'Runway',
        'Runway AI',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'twelve_labs',
      companyName: 'Twelve Labs',
      officialWebsite: 'https://www.twelvelabs.io',
      careersWebsite: 'https://www.twelvelabs.io/careers',
      headquarters: '',
      description:
          'AI company building video understanding models and systems for semantic search, analysis and multimodal video intelligence.',
      engineeringAreas: [
        'Multimodal AI',
        'Video Understanding',
        'Foundation Models',
        'Distributed Systems',
        'Semantic Search',
        'Machine Learning',
      ],
      roleFamilies: [
        'Research Engineer',
        'Machine Learning Engineer',
        'Software Engineer',
      ],
      sourceLabel: 'Official TwelveLabs careers and engineering descriptions',
      sourceUrls: [
        'https://www.twelvelabs.io/careers',
        'https://www.twelvelabs.io/blog/why-i-joined-twelvelabs',
        'https://www.twelvelabs.io/product/product-overview',
      ],
      aliases: [
        'Twelve Labs',
        'TwelveLabs',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'crewai',
      companyName: 'CrewAI',
      officialWebsite: 'https://crewai.com',
      careersWebsite: 'https://crewai.com/meet-with-us',
      headquarters: '',
      description:
          'AI agent platform and framework for building, orchestrating and operating collaborative agent workflows.',
      engineeringAreas: [
        'AI Agents',
        'Workflow Orchestration',
        'Python',
        'Software Engineering',
        'Enterprise AI',
      ],
      roleFamilies: [
        'Software Engineer',
        'AI Engineer',
      ],
      sourceLabel: 'Official CrewAI documentation and platform pages',
      sourceUrls: [
        'https://docs.crewai.com/core-concepts/Agents',
        'https://crewai.com/',
        'https://docs.crewai.com/enterprise/introduction',
      ],
      aliases: [
        'CrewAI',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'weaviate',
      companyName: 'Weaviate',
      officialWebsite: 'https://weaviate.io',
      careersWebsite: 'https://weaviate.io/company/careers',
      headquarters: '',
      description:
          'Open-source AI-native vector database using machine learning to organize and search unstructured data.',
      engineeringAreas: [
        'Vector Databases',
        'Machine Learning',
        'Information Retrieval',
        'Search',
        'Distributed Systems',
        'Software Engineering',
      ],
      roleFamilies: [
        'Software Engineer',
        'Database Engineer',
      ],
      sourceLabel: 'Official Weaviate careers and company pages',
      sourceUrls: [
        'https://weaviate.io/company/careers',
      ],
      aliases: [
        'Weaviate',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'chroma',
      companyName: 'Chroma',
      officialWebsite: 'https://www.trychroma.com',
      careersWebsite: 'https://www.trychroma.com/careers',
      headquarters: '',
      description:
          'Company building data and search infrastructure that provides AI agents with relevant context.',
      engineeringAreas: [
        'Data Infrastructure',
        'Search Infrastructure',
        'Database Systems',
        'Distributed Systems',
        'Software Engineering',
        'AI Agents',
      ],
      roleFamilies: [
        'Database Engineer',
        'Software Engineer',
        'Platform Engineer',
      ],
      sourceLabel: 'Official Chroma careers page and role listings',
      sourceUrls: [
        'https://www.trychroma.com/careers',
      ],
      aliases: [
        'Chroma',
        'Chroma DB',
      ],
      lastVerified: _verifiedOct9,
    ),

// ========================================================================
// EVIDENCE BATCH 2026-10-09 — REMAINING COMPANIES / BATCH R1-D
// ========================================================================
    VerifiedCompanyProfile(
      companyId: 'weights_biases',
      companyName: 'Weights & Biases',
      officialWebsite: 'https://wandb.ai',
      careersWebsite: 'https://wandb.ai/site/careers/',
      headquarters: '',
      description:
          'AI developer platform for experiment tracking, model and dataset management, evaluations, and AI application observability.',
      engineeringAreas: [
        'Machine Learning',
        'MLOps',
        'Experiment Tracking',
        'Model Evaluation',
        'AI Developer Tools',
        'Data and Model Lineage',
      ],
      roleFamilies: [
        'Machine Learning Engineer',
        'Software Engineer',
      ],
      sourceLabel: 'Official Weights & Biases careers and platform pages',
      sourceUrls: [
        'https://wandb.ai/site/careers/',
        'https://wandb.ai/site/blocks/',
      ],
      aliases: [
        'Weights & Biases',
        'W&B',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'modal',
      companyName: 'Modal',
      officialWebsite: 'https://modal.com',
      careersWebsite: 'https://modal.com/company',
      headquarters: '',
      description:
          'Cloud development and compute infrastructure for data, AI and machine-learning applications, including inference and fine-tuning.',
      engineeringAreas: [
        'Cloud Infrastructure',
        'AI Infrastructure',
        'Machine Learning',
        'Inference',
        'Distributed Systems',
        'Developer Tools',
      ],
      roleFamilies: [
        'Software Engineer',
        'Infrastructure Engineer',
        'Machine Learning Engineer',
      ],
      sourceLabel: 'Official Modal company and careers page',
      sourceUrls: [
        'https://modal.com/company',
      ],
      aliases: [
        'Modal',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'coreweave',
      companyName: 'CoreWeave',
      officialWebsite: 'https://www.coreweave.com',
      careersWebsite: 'https://coreweave.com/careers',
      headquarters: '',
      description:
          'Cloud computing platform purpose-built for AI workloads and accelerated compute.',
      engineeringAreas: [
        'Cloud Computing',
        'AI Infrastructure',
        'GPU Computing',
        'Distributed Systems',
        'Platform Engineering',
      ],
      roleFamilies: [
        'Software Engineer',
        'Infrastructure Engineer',
        'Machine Learning Infrastructure Engineer',
      ],
      sourceLabel: 'Official CoreWeave careers and company-culture pages',
      sourceUrls: [
        'https://coreweave.com/careers',
        'https://www.coreweave.com/coreweave-company-culture',
      ],
      aliases: [
        'CoreWeave',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'glean',
      companyName: 'Glean',
      officialWebsite: 'https://www.glean.com',
      careersWebsite: 'https://www.glean.com/careers',
      headquarters: '',
      description:
          'Enterprise AI platform combining workplace search, company knowledge, assistants and agents.',
      engineeringAreas: [
        'Enterprise AI',
        'Information Retrieval',
        'Search',
        'Machine Learning',
        'Data Engineering',
        'AI Agents',
      ],
      roleFamilies: [
        'Machine Learning Engineer',
        'Data Engineer',
        'Software Engineer',
      ],
      sourceLabel: 'Official Glean careers, company and job-board pages',
      sourceUrls: [
        'https://www.glean.com/careers',
        'https://www.glean.com/about',
        'https://job-boards.greenhouse.io/gleanwork',
      ],
      aliases: [
        'Glean',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'otter_ai',
      companyName: 'Otter.ai',
      officialWebsite: 'https://otter.ai',
      careersWebsite: 'https://otter.ai/careers',
      headquarters: '',
      description:
          'AI meeting assistant focused on transcription, speech understanding, meeting summaries and AI-agent workflows.',
      engineeringAreas: [
        'Speech AI',
        'Natural Language Processing',
        'Machine Learning',
        'Search and Recommendations',
        'Backend Infrastructure',
        'Data Infrastructure',
      ],
      roleFamilies: [
        'Applied Scientist',
        'Machine Learning Engineer',
        'Software Engineer',
      ],
      sourceLabel: 'Official Otter.ai careers page and role listings',
      sourceUrls: [
        'https://otter.ai/careers?gh_jid=6531765003',
      ],
      aliases: [
        'Otter.ai',
        'Otter',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'gong',
      companyName: 'Gong',
      officialWebsite: 'https://www.gong.io',
      careersWebsite: 'https://www.gong.io/careers',
      headquarters: '',
      description:
          'Revenue intelligence platform using AI and data to help revenue teams understand customer interactions and improve performance.',
      engineeringAreas: [
        'Artificial Intelligence',
        'Data Science',
        'Software Engineering',
        'Infrastructure',
        'Revenue Intelligence',
      ],
      roleFamilies: [
        'Software Engineer',
        'AI Engineer',
        'Data Scientist',
      ],
      sourceLabel:
          'Official Gong careers page describing R&D, AI, infrastructure and platform reliability teams',
      sourceUrls: [
        'https://www.gong.io/careers',
      ],
      aliases: [
        'Gong',
        'Gong.io',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'sprinklr',
      companyName: 'Sprinklr',
      officialWebsite: 'https://www.sprinklr.com',
      careersWebsite: 'https://www.sprinklr.com/careers/',
      headquarters: '',
      description:
          'AI-native unified customer experience management platform across customer service, social media, marketing and contact-center workflows.',
      engineeringAreas: [
        'Artificial Intelligence',
        'Customer Experience Platforms',
        'Data Analytics',
        'Software Engineering',
        'Omnichannel Systems',
      ],
      roleFamilies: [
        'Software Engineer',
        'Data Engineer',
        'AI and Automation Analyst',
      ],
      sourceLabel: 'Official Sprinklr careers and platform description',
      sourceUrls: [
        'https://www.sprinklr.com/careers/',
        'https://www.sprinklr.com/careers/find-your-team/',
      ],
      aliases: [
        'Sprinklr',
        'Sprinklr AI',
      ],
      lastVerified: _verifiedOct9,
    ),

// ========================================================================
// EVIDENCE BATCH 2026-10-09 — REMAINING COMPANIES / BATCH R1-E
// ========================================================================
    VerifiedCompanyProfile(
      companyId: 'haptik',
      companyName: 'Haptik',
      officialWebsite: 'https://www.haptik.ai',
      careersWebsite: 'https://www.haptik.ai/careers',
      headquarters: '',
      description:
          'Conversational and generative AI company building customer-service and enterprise conversational AI experiences.',
      engineeringAreas: [
        'Conversational AI',
        'Generative AI',
        'Natural Language Processing',
        'Backend Engineering',
        'Voice AI',
      ],
      roleFamilies: [
        'Backend Software Engineer',
        'Voice AI Engineer',
      ],
      sourceLabel: 'Official Haptik careers and open-positions pages',
      sourceUrls: [
        'https://www.haptik.ai/careers',
        'https://haptik.freshteam.com/jobs',
      ],
      aliases: [
        'Haptik',
        'Jio Haptik',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'yellow_ai',
      companyName: 'Yellow.ai',
      officialWebsite: 'https://yellow.ai',
      careersWebsite: 'https://yellow.ai/career/',
      headquarters: '',
      description:
          'Enterprise conversational AI platform focused on automated customer and employee conversations.',
      engineeringAreas: [
        'Conversational AI',
        'Generative AI',
        'Natural Language Processing',
        'Software Engineering',
        'Customer Experience Automation',
      ],
      roleFamilies: [
        'Software Engineer',
      ],
      sourceLabel: 'Official Yellow.ai careers page',
      sourceUrls: [
        'https://yellow.ai/career/',
      ],
      aliases: [
        'Yellow.ai',
        'Yellow AI',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'observe_ai',
      companyName: 'Observe.AI',
      officialWebsite: 'https://www.observe.ai',
      careersWebsite: 'https://www.observe.ai/careers',
      headquarters: '',
      description:
          'AI-powered contact-center platform using AI agents and copilots to assist conversations and improve customer experiences.',
      engineeringAreas: [
        'Conversational AI',
        'Speech AI',
        'AI Agents',
        'Contact Center Systems',
        'Data Analytics',
      ],
      roleFamilies: [
        'AI Engineer',
        'Software Engineer',
      ],
      sourceLabel: 'Official Observe.AI careers and platform descriptions',
      sourceUrls: [
        'https://www.observe.ai/careers',
      ],
      aliases: [
        'Observe.AI',
        'Observe AI',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'moveworks',
      companyName: 'Moveworks',
      officialWebsite: 'https://www.moveworks.com',
      careersWebsite: 'https://www.moveworks.com/us/en/company/careers',
      headquarters: '',
      description:
          'Enterprise AI platform combining contextual search, assistants, agentic AI and task automation for workplace experiences.',
      engineeringAreas: [
        'Enterprise AI',
        'Information Retrieval',
        'Machine Learning',
        'AI Agents',
        'Search Infrastructure',
        'Software Engineering',
      ],
      roleFamilies: [
        'Machine Learning Engineer',
        'Software Engineer',
        'Infrastructure Engineer',
      ],
      sourceLabel: 'Official Moveworks careers page and open-role listings',
      sourceUrls: [
        'https://www.moveworks.com/us/en/company/careers',
      ],
      aliases: [
        'Moveworks',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'darktrace',
      companyName: 'Darktrace',
      officialWebsite: 'https://www.darktrace.com',
      careersWebsite: 'https://www.darktrace.com/careers',
      headquarters: '',
      description:
          'Cybersecurity company using AI to detect, investigate and respond to cyber threats.',
      engineeringAreas: [
        'Cybersecurity',
        'Artificial Intelligence',
        'Software Engineering',
        'Research',
        'Cloud Architecture',
        'Data Visualization',
      ],
      roleFamilies: [
        'Software Engineer',
        'Research Engineer',
        'Cybersecurity Analyst',
      ],
      sourceLabel:
          'Official Darktrace careers page and engineering/research team descriptions',
      sourceUrls: [
        'https://www.darktrace.com/careers',
      ],
      aliases: [
        'Darktrace',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'crowdstrike',
      companyName: 'CrowdStrike',
      officialWebsite: 'https://www.crowdstrike.com',
      careersWebsite: 'https://www.crowdstrike.com/en-us/careers/',
      headquarters: '',
      description:
          'Cybersecurity company delivering AI-enabled security products and distributed systems for breach prevention and response.',
      engineeringAreas: [
        'Cybersecurity',
        'Artificial Intelligence',
        'Distributed Systems',
        'Data Engineering',
        'Cloud Security',
        'Software Engineering',
      ],
      roleFamilies: [
        'Software Engineer',
        'Security Researcher',
        'Infrastructure Engineer',
      ],
      sourceLabel:
          'Official CrowdStrike careers page and engineering description',
      sourceUrls: [
        'https://www.crowdstrike.com/en-us/careers/',
      ],
      aliases: [
        'CrowdStrike',
      ],
      lastVerified: _verifiedOct9,
    ),

    VerifiedCompanyProfile(
      companyId: 'sentinelone',
      companyName: 'SentinelOne',
      officialWebsite: 'https://www.sentinelone.com',
      careersWebsite: 'https://www.sentinelone.com/careers/',
      headquarters: '',
      description:
          'Cybersecurity company developing AI-powered security and autonomous threat detection and response technology.',
      engineeringAreas: [
        'Cybersecurity',
        'Artificial Intelligence',
        'Machine Learning',
        'Cloud Security',
        'Distributed Systems',
        'Software Engineering',
      ],
      roleFamilies: [
        'Software Engineer',
        'Machine Learning Engineer',
        'Security Researcher',
      ],
      sourceLabel: 'Official SentinelOne careers and open-positions pages',
      sourceUrls: [
        'https://www.sentinelone.com/careers/',
        'https://www.sentinelone.com/jobs/',
      ],
      aliases: [
        'SentinelOne',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'github',
      companyName: 'GitHub',
      officialWebsite: 'https://github.com',
      careersWebsite: 'https://www.github.careers/careers-home',
      headquarters: '',
      description:
          'Developer platform for hosting, reviewing, and collaborating on software, including GitHub Copilot AI coding assistance.',
      engineeringAreas: <String>[
        'Developer Tools',
        'Software Engineering',
        'AI Coding Assistance',
        'Cloud Infrastructure',
      ],
      roleFamilies: <String>[
        'Software Engineer',
        'Machine Learning Engineer',
        'Security Engineer',
      ],
      sourceLabel: 'Official GitHub careers and GitHub Copilot product pages',
      sourceUrls: <String>[
        'https://www.github.careers/careers-home',
        'https://github.com/features/copilot',
      ],
      aliases: <String>[
        'GitHub',
        'GitHub Copilot',
        'GitHub (Copilot)',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'adobe',
      companyName: 'Adobe',
      officialWebsite: 'https://www.adobe.com',
      careersWebsite: 'https://www.adobe.com/careers.html',
      headquarters: '',
      description:
          'Creative and digital-experience software company developing creative tools and generative AI capabilities including Adobe Firefly.',
      engineeringAreas: <String>[
        'Creative Software',
        'Generative AI',
        'Digital Experience',
        'Cloud Software',
      ],
      roleFamilies: <String>[
        'Software Engineer',
        'Machine Learning Engineer',
        'Research Scientist',
      ],
      sourceLabel: 'Official Adobe careers and Firefly product pages',
      sourceUrls: <String>[
        'https://www.adobe.com/careers.html',
        'https://www.adobe.com/products/firefly.html',
      ],
      aliases: <String>[
        'Adobe',
        'Adobe Firefly',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'canva',
      companyName: 'Canva',
      officialWebsite: 'https://www.canva.com',
      careersWebsite: 'https://www.canva.com/careers/',
      headquarters: '',
      description:
          'Visual communication and design platform with AI-powered design and content-creation capabilities.',
      engineeringAreas: <String>[
        'Design Software',
        'Generative AI',
        'Web Applications',
        'Developer Platform',
      ],
      roleFamilies: <String>[
        'Software Engineer',
        'Machine Learning Engineer',
        'Product Designer',
      ],
      sourceLabel: 'Official Canva careers and AI product pages',
      sourceUrls: <String>[
        'https://www.canva.com/careers/',
        'https://www.canva.com/ai/',
      ],
      aliases: <String>[
        'Canva',
        'Canva AI',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'tome',
      companyName: 'Tome',
      officialWebsite: 'https://tome.app',
      careersWebsite: '',
      headquarters: '',
      description:
          'AI-assisted storytelling and presentation product documented in Tome’s official help resources; no current official careers evidence was confirmed in this pass.',
      engineeringAreas: <String>[
        'AI-assisted Content Creation',
        'Presentation Software',
      ],
      roleFamilies: <String>[],
      sourceLabel:
          'Official Tome help-center product documentation; current hiring evidence not confirmed',
      sourceUrls: <String>[
        'https://tome.app/help/en/collections/5841803-using-ai-in-tome',
        'https://tome.app/help/en/articles/8381205-how-to-use-tome-a-step-by-step-guide',
      ],
      aliases: <String>[
        'Tome',
        'Tome AI',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'casetext',
      companyName: 'Casetext',
      officialWebsite: 'https://casetext.com',
      careersWebsite: 'https://www.thomsonreuters.com/en/careers',
      headquarters: '',
      description:
          'Legal technology product associated with AI-assisted legal research and CoCounsel, within Thomson Reuters.',
      engineeringAreas: <String>[
        'Legal Technology',
        'Applied AI',
        'Information Retrieval',
      ],
      roleFamilies: <String>[
        'Software Engineer',
        'AI/ML Engineer',
        'Product Manager',
      ],
      sourceLabel:
          'Official Thomson Reuters careers and legal AI product pages; Casetext is represented as its legal-tech product lineage',
      sourceUrls: <String>[
        'https://www.thomsonreuters.com/en/careers',
        'https://www.thomsonreuters.com/en/products-services/legal.html',
      ],
      aliases: <String>[
        'Casetext',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'symphonyai',
      companyName: 'SymphonyAI',
      officialWebsite: 'https://www.symphonyai.com',
      careersWebsite: 'https://www.symphonyai.com/careers/',
      headquarters: '',
      description:
          'Enterprise AI company; Ayasdi is treated as a legacy/related identity and not as a separate current company profile.',
      engineeringAreas: <String>[
        'Enterprise AI',
        'Machine Learning',
        'Data Analytics',
      ],
      roleFamilies: <String>[
        'Software Engineer',
        'Machine Learning Engineer',
        'Data Scientist',
      ],
      sourceLabel:
          'Official SymphonyAI corporate and careers pages; Ayasdi mapped to successor identity',
      sourceUrls: <String>[
        'https://www.symphonyai.com/careers/',
        'https://www.symphonyai.com/',
      ],
      aliases: <String>[
        'SymphonyAI',
        'Ayasdi',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'fireflies_ai',
      companyName: 'Fireflies.ai',
      officialWebsite: 'https://fireflies.ai',
      careersWebsite: 'https://fireflies.ai/careers',
      headquarters: '',
      description:
          'AI meeting assistant that records, transcribes, summarizes, and helps search conversations.',
      engineeringAreas: <String>[
        'Speech AI',
        'Natural Language Processing',
        'SaaS',
        'Search',
      ],
      roleFamilies: <String>[
        'Software Engineer',
        'Machine Learning Engineer',
      ],
      sourceLabel: 'Official Fireflies.ai careers and product pages',
      sourceUrls: <String>[
        'https://fireflies.ai/careers',
        'https://fireflies.ai',
      ],
      aliases: <String>[
        'Fireflies.ai',
        'Fireflies AI',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'neets_ai',
      companyName: 'Neets AI',
      officialWebsite: 'https://neets.ai',
      careersWebsite: 'https://neets.ai',
      headquarters: '',
      description:
          'Voice-generation API/product identity; this profile is limited to the official product surface and does not assert unobserved hiring roles.',
      engineeringAreas: <String>[
        'Speech AI',
        'Audio Generation',
        'API Services',
      ],
      roleFamilies: <String>[],
      sourceLabel:
          'Official Neets AI product website; career-role evidence not confirmed',
      sourceUrls: <String>[
        'https://neets.ai',
      ],
      aliases: <String>[
        'Neets AI',
        'Neets.ai',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'dust',
      companyName: 'Dust',
      officialWebsite: 'https://dust.tt',
      careersWebsite: 'https://dust.tt/careers',
      headquarters: '',
      description:
          'Enterprise platform for building AI assistants and agent workflows connected to company knowledge and tools.',
      engineeringAreas: <String>[
        'AI Agents',
        'Enterprise Search',
        'Backend Engineering',
        'Developer Tools',
      ],
      roleFamilies: <String>[
        'Software Engineer',
        'Product Engineer',
      ],
      sourceLabel: 'Official Dust careers and product pages',
      sourceUrls: <String>[
        'https://dust.tt/careers',
        'https://dust.tt',
      ],
      aliases: <String>[
        'Dust',
        'Dust.tt',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'imbue',
      companyName: 'Imbue',
      officialWebsite: 'https://imbue.com',
      careersWebsite: 'https://imbue.com/careers/',
      headquarters: '',
      description:
          'AI research and software company focused on tools that support user agency and software building.',
      engineeringAreas: <String>[
        'AI Research',
        'Software Engineering',
        'AI Agents',
      ],
      roleFamilies: <String>[
        'Product Engineer',
      ],
      sourceLabel: 'Official Imbue careers and about pages',
      sourceUrls: <String>[
        'https://imbue.com/careers/',
        'https://imbue.com/about',
      ],
      aliases: <String>[
        'Imbue',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'inflection_ai',
      companyName: 'Inflection AI',
      officialWebsite: 'https://inflection.ai',
      careersWebsite: 'https://inflection.ai/careers',
      headquarters: '',
      description:
          'AI company associated with the Inflection AI/Pi assistant lineage; fields are limited to its official company identity and published information.',
      engineeringAreas: <String>[
        'Applied AI',
        'Conversational AI',
      ],
      roleFamilies: <String>[],
      sourceLabel:
          'Official Inflection AI company site; current careers page not independently confirmed',
      sourceUrls: <String>[
        'https://inflection.ai',
      ],
      aliases: <String>[
        'Inflection AI',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'adept_ai',
      companyName: 'Adept AI',
      officialWebsite: 'https://www.adept.ai',
      careersWebsite: '',
      headquarters: '',
      description:
          'AI company known for developing models and systems that perform tasks through software interfaces; current independent hiring evidence was not confirmed.',
      engineeringAreas: <String>[
        'AI Agents',
        'Applied Research',
        'Software Automation',
      ],
      roleFamilies: <String>[],
      sourceLabel:
          'Official Adept company site; current careers evidence not confirmed',
      sourceUrls: <String>[
        'https://www.adept.ai',
      ],
      aliases: <String>[
        'Adept AI',
        'Adept',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'khan_academy',
      companyName: 'Khan Academy',
      officialWebsite: 'https://www.khanacademy.org',
      careersWebsite: 'https://www.khanacademy.org/about/careers',
      headquarters: '',
      description:
          'Nonprofit educational platform offering learning resources and Khanmigo AI learning and teaching assistance.',
      engineeringAreas: <String>[
        'Education Technology',
        'AI Tutoring',
        'Web Applications',
        'Learning Science',
      ],
      roleFamilies: <String>[
        'Software Engineer',
        'Product Designer',
      ],
      sourceLabel: 'Official Khan Academy careers and Khan Labs pages',
      sourceUrls: <String>[
        'https://www.khanacademy.org/about/careers',
        'https://www.khanacademy.org/khan-labs',
      ],
      aliases: <String>[
        'Khan Academy',
        'Khanmigo',
        'Khanmigo (Khan Academy)',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'duolingo',
      companyName: 'Duolingo',
      officialWebsite: 'https://www.duolingo.com',
      careersWebsite: 'https://careers.duolingo.com',
      headquarters: '',
      description:
          'Language-learning platform that uses AI and adaptive learning experiences across its education products.',
      engineeringAreas: <String>[
        'Education Technology',
        'AI/ML',
        'Mobile Applications',
        'Personalization',
      ],
      roleFamilies: <String>[
        'AI Research Engineer',
        'Software Engineer',
        'Product Designer',
      ],
      sourceLabel:
          'Official Duolingo careers and Duolingo Max product information',
      sourceUrls: <String>[
        'https://careers.duolingo.com',
        'https://blog.duolingo.com/duolingo-max/',
      ],
      aliases: <String>[
        'Duolingo',
        'Duolingo Max',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'kensho',
      companyName: 'Kensho',
      officialWebsite: 'https://kensho.com',
      careersWebsite: 'https://kensho.com/careers',
      headquarters: '',
      description:
          'S&P Global’s AI and machine-learning technology company building systems for financial data, language, and enterprise information retrieval.',
      engineeringAreas: <String>[
        'Applied AI',
        'Machine Learning',
        'Natural Language Processing',
        'Data Platforms',
      ],
      roleFamilies: <String>[
        'Machine Learning Engineer',
        'MLOps Engineer',
        'Backend Software Engineer',
        'Research Scientist',
      ],
      sourceLabel: 'Official Kensho careers page and role listings',
      sourceUrls: <String>[
        'https://kensho.com/careers',
      ],
      aliases: <String>[
        'Kensho',
        'Kensho Technologies',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'alphasense',
      companyName: 'AlphaSense',
      officialWebsite: 'https://www.alpha-sense.com',
      careersWebsite: 'https://www.alpha-sense.com/careers/',
      headquarters: '',
      description:
          'AI-powered market and business intelligence platform for research and decision-making using enterprise content.',
      engineeringAreas: <String>[
        'Applied AI',
        'Information Retrieval',
        'Search',
        'Enterprise Software',
      ],
      roleFamilies: <String>[
        'Software Engineer',
        'AI/ML Engineer',
        'Data Engineer',
        'Product Manager',
      ],
      sourceLabel: 'Official AlphaSense careers and product pages',
      sourceUrls: <String>[
        'https://www.alpha-sense.com/careers/',
        'https://www.alpha-sense.com/',
      ],
      aliases: <String>[
        'AlphaSense',
        'Alphasense',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'tesla',
      companyName: 'Tesla',
      officialWebsite: 'https://www.tesla.com',
      careersWebsite: 'https://www.tesla.com/careers',
      headquarters: '',
      description:
          'Electric vehicle, energy, robotics, and AI company developing autonomous driving and humanoid robotics systems.',
      engineeringAreas: <String>[
        'AI Engineering',
        'Computer Vision',
        'Robotics',
        'Autonomous Systems',
        'Inference Infrastructure',
      ],
      roleFamilies: <String>[
        'AI Engineer',
        'Reinforcement Learning Engineer',
        'Robotics Engineer',
        'Software Engineer',
      ],
      sourceLabel: 'Official Tesla careers and Tesla AI role listings',
      sourceUrls: <String>[
        'https://www.tesla.com/careers',
        'https://www.tesla.com/careers/search?query=AI%20engineer',
      ],
      aliases: <String>[
        'Tesla',
        'Tesla AI',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'waymo',
      companyName: 'Waymo',
      officialWebsite: 'https://waymo.com',
      careersWebsite: 'https://careers.withwaymo.com',
      headquarters: '',
      description:
          'Autonomous-driving technology company developing a driver system and mobility services.',
      engineeringAreas: <String>[
        'Autonomous Systems',
        'Machine Learning',
        'Robotics',
        'Computer Vision',
        'Simulation',
      ],
      roleFamilies: <String>[
        'Software Engineer',
        'Machine Learning Engineer',
        'Research Scientist',
        'Robotics Engineer',
      ],
      sourceLabel: 'Official Waymo careers and company pages',
      sourceUrls: <String>[
        'https://careers.withwaymo.com/',
        'https://waymo.com/',
      ],
      aliases: <String>[
        'Waymo',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'midjourney',
      companyName: 'Midjourney',
      officialWebsite: 'https://www.midjourney.com',
      careersWebsite: 'https://www.midjourney.com/careers',
      headquarters: '',
      description:
          'Community-backed research group building generative image and video technologies and related creative products.',
      engineeringAreas: <String>[
        'Generative AI',
        'Computer Vision',
        'Inference Infrastructure',
        'Product Engineering',
      ],
      roleFamilies: <String>[
        'Software Engineer',
        'Machine Learning Engineer',
        'Product Designer',
      ],
      sourceLabel:
          'Official Midjourney careers page and team/role descriptions',
      sourceUrls: <String>[
        'https://www.midjourney.com/careers',
      ],
      aliases: <String>[
        'Midjourney',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'stability_ai',
      companyName: 'Stability AI',
      officialWebsite: 'https://stability.ai',
      careersWebsite: 'https://stability.ai/careers',
      headquarters: '',
      description:
          'Generative AI company known for open models and tools for image, video, audio, and other media generation.',
      engineeringAreas: <String>[
        'Generative AI',
        'Model Research',
        'Machine Learning',
        'Inference',
      ],
      roleFamilies: <String>[
        'Research Scientist',
        'Machine Learning Engineer',
        'Software Engineer',
      ],
      sourceLabel: 'Official Stability AI company and careers pages',
      sourceUrls: <String>[
        'https://stability.ai/careers',
        'https://stability.ai/',
      ],
      aliases: <String>[
        'Stability AI',
        'StabilityAI',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'pika',
      companyName: 'Pika',
      officialWebsite: 'https://pika.art',
      careersWebsite: 'https://pika.art/careers',
      headquarters: '',
      description:
          'AI-native creative platform for generating and editing video and other visual content.',
      engineeringAreas: <String>[
        'Generative AI',
        'Video Generation',
        'Computer Vision',
        'Product Engineering',
      ],
      roleFamilies: <String>[
        'Research Engineer',
        'Software Engineer',
      ],
      sourceLabel: 'Official Pika careers page and team descriptions',
      sourceUrls: <String>[
        'https://pika.art/careers',
      ],
      aliases: <String>[
        'Pika',
        'Pika Labs',
        'Pika Labs AI',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'abridge',
      companyName: 'Abridge',
      officialWebsite: 'https://www.abridge.com',
      careersWebsite: 'https://www.abridge.com/careers',
      headquarters: '',
      description:
          'Healthcare AI company developing clinical conversation and documentation technology for clinicians and health systems.',
      engineeringAreas: <String>[
        'Healthcare AI',
        'Speech AI',
        'Natural Language Processing',
        'Clinical Software',
      ],
      roleFamilies: <String>[
        'Software Engineer',
        'Machine Learning Engineer',
        'Clinical AI Engineer',
      ],
      sourceLabel: 'Official Abridge careers and product pages',
      sourceUrls: <String>[
        'https://www.abridge.com/careers',
        'https://www.abridge.com/',
      ],
      aliases: <String>[
        'Abridge',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'gnani_ai',
      companyName: 'Gnani.ai',
      officialWebsite: 'https://www.gnani.ai',
      careersWebsite: 'https://www.gnani.ai/careers',
      headquarters: '',
      description:
          'Conversational AI company associated with the Vernacular.ai name, focused on voice and language automation for enterprises.',
      engineeringAreas: <String>[
        'Conversational AI',
        'Speech AI',
        'Natural Language Processing',
        'Enterprise Automation',
      ],
      roleFamilies: <String>[
        'Software Engineer',
        'Machine Learning Engineer',
      ],
      sourceLabel:
          'Official Gnani.ai corporate and careers pages; Vernacular.ai mapped to successor brand',
      sourceUrls: <String>[
        'https://www.gnani.ai/',
        'https://www.gnani.ai/careers',
      ],
      aliases: <String>[
        'Gnani.ai',
        'Vernacular.ai',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'scale_ai',
      companyName: 'Scale AI',
      officialWebsite: 'https://scale.com',
      careersWebsite: 'https://scale.com/careers',
      headquarters: '',
      description:
          'AI data and infrastructure company supporting model training, evaluation, annotation, and enterprise AI deployment.',
      engineeringAreas: <String>[
        'AI Infrastructure',
        'Data Engineering',
        'Machine Learning',
        'Model Evaluation',
        'Computer Vision',
      ],
      roleFamilies: <String>[
        'Machine Learning Engineer',
        'Software Engineer',
        'Data Engineer',
        'Research Engineer',
      ],
      sourceLabel: 'Official Scale AI careers and product pages',
      sourceUrls: <String>[
        'https://scale.com/careers',
        'https://scale.com/',
      ],
      aliases: <String>[
        'Scale AI',
        'Scale',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'tabnine',
      companyName: 'Tabnine',
      officialWebsite: 'https://www.tabnine.com',
      careersWebsite: 'https://www.tabnine.com/careers',
      headquarters: '',
      description:
          'AI coding assistant platform designed to assist developers with code completion and software development workflows.',
      engineeringAreas: <String>[
        'Developer Tools',
        'Generative AI',
        'Software Engineering',
        'Code Intelligence',
      ],
      roleFamilies: <String>[
        'Software Engineer',
        'Machine Learning Engineer',
      ],
      sourceLabel: 'Official Tabnine careers and product pages',
      sourceUrls: <String>[
        'https://www.tabnine.com/careers',
        'https://www.tabnine.com/',
      ],
      aliases: <String>[
        'Tabnine',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'windsurf',
      companyName: 'Windsurf',
      officialWebsite: 'https://windsurf.com',
      careersWebsite: 'https://windsurf.com/careers',
      headquarters: '',
      description:
          'AI-powered software development environment and coding assistant, formerly associated with the Codeium product name.',
      engineeringAreas: <String>[
        'Developer Tools',
        'AI Coding',
        'Software Engineering',
        'Agentic Workflows',
      ],
      roleFamilies: <String>[
        'Software Engineer',
        'Machine Learning Engineer',
      ],
      sourceLabel:
          'Official Windsurf company/product pages; Codeium mapped to current product identity',
      sourceUrls: <String>[
        'https://windsurf.com/',
        'https://windsurf.com/careers',
      ],
      aliases: <String>[
        'Windsurf',
        'Codeium',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'elevenlabs',
      companyName: 'ElevenLabs',
      officialWebsite: 'https://elevenlabs.io',
      careersWebsite: 'https://elevenlabs.io/careers',
      headquarters: '',
      description:
          'AI audio company developing voice generation, speech, dubbing, and conversational audio technologies.',
      engineeringAreas: <String>[
        'Speech AI',
        'Audio Generation',
        'Natural Language Processing',
        'AI Agents',
      ],
      roleFamilies: <String>[
        'Software Engineer',
        'Machine Learning Engineer',
        'Research Engineer',
        'Data Scientist',
      ],
      sourceLabel: 'Official ElevenLabs careers and open-position pages',
      sourceUrls: <String>[
        'https://elevenlabs.io/careers',
        'https://elevenlabs.io/careers/positions',
      ],
      aliases: <String>[
        'ElevenLabs',
        'Eleven Labs',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'mistral_ai',
      companyName: 'Mistral AI',
      officialWebsite: 'https://mistral.ai',
      careersWebsite: 'https://mistral.ai/careers',
      headquarters: '',
      description:
          'AI company developing foundation models, assistant products, and AI deployment infrastructure.',
      engineeringAreas: <String>[
        'Foundation Models',
        'Applied Research',
        'Inference Infrastructure',
        'AI Products',
      ],
      roleFamilies: <String>[
        'Research Scientist',
        'Machine Learning Engineer',
        'Software Engineer',
        'Infrastructure Engineer',
      ],
      sourceLabel: 'Official Mistral AI careers and company pages',
      sourceUrls: <String>[
        'https://mistral.ai/careers',
        'https://mistral.ai/',
      ],
      aliases: <String>[
        'Mistral AI',
        'Mistral',
      ],
      lastVerified: _verifiedOct9,
    ),
    VerifiedCompanyProfile(
      companyId: 'xai',
      companyName: 'xAI',
      officialWebsite: 'https://x.ai',
      careersWebsite: 'https://x.ai/careers/open-roles',
      headquarters: '',
      description:
          'AI company developing Grok and frontier AI models, supported by research, software, model, infrastructure, and safety teams.',
      engineeringAreas: <String>[
        'Foundation Models',
        'AI Research',
        'Infrastructure',
        'Computer Vision',
        'AI Safety',
      ],
      roleFamilies: <String>[
        'Research Scientist',
        'Machine Learning Engineer',
        'Software Engineer',
        'Infrastructure Engineer',
      ],
      sourceLabel: 'Official xAI open roles and company pages',
      sourceUrls: <String>[
        'https://x.ai/careers/open-roles',
        'https://x.ai/',
      ],
      aliases: <String>[
        'xAI',
        'xAI (Grok)',
      ],
      lastVerified: _verifiedOct9,
    ),
  ];

  List<VerifiedCompanyProfile> get all => List.unmodifiable(_profiles);

  List<String> get verifiedCompanyIds =>
      _profiles.map((p) => p.companyId).toList(growable: false);

  List<String> get verifiedCompanyNames =>
      _profiles.map((p) => p.companyName).toList(growable: false);

  VerifiedCompanyProfile? byCompanyId(String companyId) {
    final key = _normalize(companyId);

    if (key.isEmpty) return null;

    for (final profile in _profiles) {
      if (_normalize(profile.companyId) == key) return profile;
    }

    return null;
  }

  VerifiedCompanyProfile? byCompanyName(String companyName) {
    final key = _normalize(companyName);

    if (key.isEmpty) return null;

    for (final profile in _profiles) {
      if (_normalize(profile.companyName) == key) return profile;
    }

    return null;
  }

  VerifiedCompanyProfile? find(String value) {
    final key = _normalize(value);

    if (key.isEmpty) return null;

    final byIdResult = byCompanyId(key);

    if (byIdResult != null) return byIdResult;

    final byNameResult = byCompanyName(key);

    if (byNameResult != null) return byNameResult;

    for (final profile in _profiles) {
      for (final alias in profile.aliases) {
        if (_normalize(alias) == key) return profile;
      }
    }

    return null;
  }

  bool isVerified(String value) => find(value) != null;

  /// Returns the canonical identity of a company, or null when the value is

  /// neither a verified company (by ID, name or approved alias) nor an

  /// approved profile-less canonicalization (for example Adobe Firefly →

  /// Adobe).

  ///

  /// This is the single place other layers (relationship layer, company

  /// intelligence IDs, cache keys) should ask for canonical identity, instead

  /// of keeping their own alias tables. It returns identity only; it never

  /// implies skills, roles, salary or hiring evidence.

  CompanyCanonicalIdentity? canonicalIdentity(String value) {
    final key = _normalize(value);

    if (key.isEmpty) return null;

    final profile = find(key);

    if (profile != null) {
      return CompanyCanonicalIdentity(
        companyId: profile.companyId,
        companyName: profile.companyName,
        hasVerifiedProfile: true,
      );
    }

    return _approvedProfileLessCanonicalizations[key];
  }

  DateTime? lastVerified(String value) => find(value)?.lastVerified;

  List<String> sourceUrlsFor(String value) {
    final profile = find(value);

    return profile == null ? const [] : List.unmodifiable(profile.sourceUrls);
  }

  static String _normalize(String value) => value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
}

class VerifiedCompanyData {
  VerifiedCompanyData._();

  static const VerifiedCompanyDataService _service =
      VerifiedCompanyDataService();

  static List<VerifiedCompanyProfile> get all => _service.all;

  static List<String> get verifiedCompanyIds => _service.verifiedCompanyIds;

  static List<String> get verifiedCompanyNames => _service.verifiedCompanyNames;

  static VerifiedCompanyProfile? byCompanyId(String companyId) =>
      _service.byCompanyId(companyId);

  static VerifiedCompanyProfile? byCompanyName(String companyName) =>
      _service.byCompanyName(companyName);

  static VerifiedCompanyProfile? find(String value) => _service.find(value);

  static bool isVerified(String value) => _service.isVerified(value);

  /// Canonical identity (verified company or approved profile-less

  /// canonicalization such as Adobe Firefly → Adobe). Identity only.

  static CompanyCanonicalIdentity? canonicalIdentity(String value) =>
      _service.canonicalIdentity(value);

  static DateTime? lastVerified(String value) => _service.lastVerified(value);

  static List<String> sourceUrlsFor(String value) =>
      _service.sourceUrlsFor(value);
}
