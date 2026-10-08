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
      description: 'AI research and product company building and deploying AI systems and products.',
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
      description: 'AI research and engineering organization working across advanced AI systems and applications.',
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
      description: 'Technology company spanning software, cloud, AI, developer platforms, devices, and enterprise products.',
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
      description: 'Computing company focused on accelerated computing, graphics, AI, and related hardware and software platforms.',
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
      description: 'AI company focused on developing AI systems and the infrastructure, research, and safety work around them.',
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
      description: 'Technology and commerce company operating large-scale software, cloud, logistics, devices, and AI systems.',
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
      description: 'Technology company building consumer devices, operating systems, software, services, and AI-powered experiences.',
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
      description: 'Software creation platform building an agentic creation platform.',
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
      description: 'Productivity and collaboration software company with AI-enabled products.',
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
      description: 'Enterprise software company focused on CRM and AI-enabled business applications.',
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
      description: 'Enterprise software company developing an AI platform for business workflows.',
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
      description: 'Technology company researching and developing AI systems and products.',
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
      description: 'Company building agent engineering and application-development infrastructure.',
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
      description: 'AI-powered communication and presentation software company.',
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
      description: 'Enterprise AI company focused on personalized content and marketing workflows.',
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
      description: 'AI video company building tools for business communication and training.',
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
      description: 'AI infrastructure company focused on software, hardware, algorithms, and models.',
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
      description: 'AI compute company building specialized systems for AI workloads.',
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
      description: 'AI computing company focused on enterprise AI and inference.',
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
      description: 'AI developer infrastructure company providing tools and APIs for running models.',
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
      description: 'Technology company applying data and AI to precision medicine.',
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
      description: 'Clinical-stage TechBio company using technology and machine learning to industrialize drug discovery.',
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
      description: 'AI reliability company focused on data and model reliability.',
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
      description: 'AI company building foundational models and enterprise-grade AI systems for India.',
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
      description: 'Enterprise AI company focused on deploying AI and agentic AI into real-world workflows.',
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
      description: 'Microsoft\'s AI organization, building the Copilot personal AI and the platform, inference and data systems behind it.',
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
      description: 'Builds multimodal AI that can generate, understand and operate in the physical world.',
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
      description: 'Builds experiential AI agents that form memories, forge identity and keep learning.',
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
      description: 'AI platform for law firms, in-house legal teams and professional services.',
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
      description: 'Knowledge infrastructure for AI: a vector database and knowledge engine for AI applications.',
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

  static const VerifiedCompanyDataService _service = VerifiedCompanyDataService();

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
