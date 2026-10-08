import '../models/home_market_models.dart';
import 'verified_company_data.dart';

/// career_company_relationship_service.dart
/// Step 6D — Global Career ↔ Company reference relationship layer.
///
/// IMPORTANT:
/// - These are curated REFERENCE relationships, not live hiring signals.
/// - A company appearing here means the company is relevant to the career
///   family in the app's career-discovery model; it does NOT mean the company
///   is hiring right now.
/// - A relationship is NOT evidence for skills, salary or hiring. Live
///   openings, verified job-derived skills and salary data remain separate
///   data concerns and must be connected from verified sources.
///
/// The mapping intentionally uses the actual company names available in the
/// current HomeMarket company directory (for example, "Google DeepMind"
/// rather than a separate "Google" placeholder).
///
/// COMPANY IDENTITY (locked):
/// - Company identity is resolved through the authoritative verified registry
///   ([VerifiedCompanyData.canonicalIdentity]). This file keeps NO alias table
///   of its own.
/// - Only the approved canonicalizations of the registry's ALIAS POLICY apply
///   (for example Salesforce Einstein → Salesforce, Notion AI → Notion,
///   Meta AI → Meta, Tesla AI → Tesla). "Microsoft AI" is its own entity and
///   names such as "Google" are NOT merged with a parent/sibling company here.
///
/// CAREER KEYS:
/// - Map keys are the lower-cased career TITLES used by HomeMarketService
///   (for example "mlops / ai infrastructure engineer"). A key that does not
///   match a career title silently produces zero companies, so keys must be
///   kept in sync with `HomeMarketService.getCareers()` titles.
class CareerCompanyRelationshipService {
  const CareerCompanyRelationshipService();

  static const Map<String, List<String>> _careerToCompanyNames = {
    // ─────────────────────────────────────────────────────────────────────
    // SOFTWARE / WEB
    // ─────────────────────────────────────────────────────────────────────
    'software engineer': [
      'GitHub (Copilot)',
      'Cursor',
      'Replit',
      'Tabnine',
      'Codeium',
      'Cognition AI',
      'Microsoft AI',
      'Google DeepMind',
      'Adobe Firefly',
      'Canva AI',
      'Salesforce Einstein',
      'ServiceNow AI',
      'Notion AI',
      'Grammarly',
      'Meta AI',
      'OpenAI',
      'Anthropic',
      'Hugging Face',
      'LangChain',
      'LlamaIndex',
      'Perplexity AI',
      'You.com',
    ],
    // NOTE: no HomeCareer with the title "Web Developer" exists yet, so this
    // entry is currently unused. It is kept as curated data for when that
    // career is added.
    'web developer': [
      'GitHub (Copilot)',
      'Cursor',
      'Replit',
      'Codeium',
      'Cognition AI',
      'Canva AI',
      'Adobe Firefly',
      'Notion AI',
      'Grammarly',
      'Writer',
      'Jasper AI',
      'Tome',
      'Gamma',
      'Typeface',
      'Synthesia',
      'ElevenLabs',
      'Suno AI',
      'Udio',
      'Descript',
      'Perplexity AI',
      'You.com',
      'Hugging Face',
      'LangChain',
    ],

    // ─────────────────────────────────────────────────────────────────────
    // AI / ML / RESEARCH
    // ─────────────────────────────────────────────────────────────────────
    'ai engineer': [
      'OpenAI',
      'Anthropic',
      'Google DeepMind',
      'ElevenLabs',
      'Suno AI',
      'Udio',
      'Descript',
      'Meta AI',
      'Microsoft AI',
      'Mistral AI',
      'Cohere',
      'AI21 Labs',
      'Aleph Alpha',
      'xAI',
      'Hugging Face',
      'Scale AI',
      'Together AI',
      'Groq',
      'Cerebras Systems',
      'SambaNova Systems',
      'Perplexity AI',
      'DeepSeek',
      'Baidu AI',
      'Alibaba DAMO',
      'Zhipu AI',
      'Moonshot AI',
      'Sakana AI',
      'Sarvam AI',
      'Krutrim',
      'Cohere',
    ],
    'ml engineer': [
      'Google DeepMind',
      'Microsoft AI',
      'Meta AI',
      'OpenAI',
      'ElevenLabs',
      'Suno AI',
      'Udio',
      'Descript',
      'Anthropic',
      'Mistral AI',
      'Cohere',
      'xAI',
      'Hugging Face',
      'Weights & Biases',
      'DataRobot',
      'Scale AI',
      'Groq',
      'Cerebras Systems',
      'SambaNova Systems',
      'Together AI',
      'Modal',
      'Replicate',
      'DeepSeek',
      'Baidu AI',
      'Alibaba DAMO',
      'Zhipu AI',
      'Moonshot AI',
      'Sakana AI',
      'Tempus AI',
      'Recursion Pharmaceuticals',
      'Insilico Medicine',
      'Cleanlab',
    ],
    'data scientist': [
      'Google DeepMind',
      'Microsoft AI',
      'Meta AI',
      'Abridge',
      'Casetext',
      'Salesforce Einstein',
      'ServiceNow AI',
      'DataRobot',
      'Weights & Biases',
      'Scale AI',
      'Glean',
      'Kensho Technologies',
      'Alphasense',
      'Ayasdi',
      'Tempus AI',
      'Recursion Pharmaceuticals',
      'Insilico Medicine',
      'Cleanlab',
      'Gong.io',
      'Sprinklr AI',
      'Duolingo Max',
    ],
    'nlp engineer': [
      'OpenAI',
      'Anthropic',
      'Google DeepMind',
      'Meta AI',
      'Microsoft AI',
      'Mistral AI',
      'Cohere',
      'AI21 Labs',
      'Aleph Alpha',
      'Hugging Face',
      'LangChain',
      'LlamaIndex',
      'Perplexity AI',
      'You.com',
      'Glean',
      'Writer',
      'Jasper AI',
      'Grammarly',
      'Otter.ai',
      'Fireflies.ai',
      'Descript',
      'Abridge',
      'Casetext',
      'Neets AI',
      'Haptik',
      'Vernacular.ai',
      'Yellow.ai',
      'Observe.AI',
      'Sarvam AI',
      'Krutrim',
      'Baidu AI',
      'DeepSeek',
    ],
    'computer vision engineer': [
      'Google DeepMind',
      'Meta AI',
      'OpenAI',
      'Microsoft AI',
      'Tesla AI',
      'Waymo',
      'Figure AI',
      '1X Technologies',
      'Boston Dynamics',
      'Runway',
      'Pika Labs',
      'Luma AI',
      'Stability AI',
      'Midjourney',
      'Twelve Labs',
      'Synthesia',
      'Adobe Firefly',
      'Canva AI',
    ],
    'prompt engineer': [
      'OpenAI',
      'Anthropic',
      'Google DeepMind',
      'Microsoft AI',
      'Meta AI',
      'Cohere',
      'Mistral AI',
      'Perplexity AI',
      'You.com',
      'Writer',
      'Jasper AI',
      'Notion AI',
      'Grammarly',
      'Glean',
      'Harvey AI',
      'Khanmigo (Khan Academy)',
      'Duolingo Max',
      'Moveworks',
      'CrewAI',
      'Dust.tt',
      'Letta (MemGPT)',
    ],
    'ai researcher': [
      'OpenAI',
      'Anthropic',
      'Google DeepMind',
      'Meta AI',
      'Microsoft AI',
      'Mistral AI',
      'Cohere',
      'AI21 Labs',
      'Aleph Alpha',
      'xAI',
      'Stability AI',
      'ElevenLabs',
      'Suno AI',
      'Udio',
      'Hugging Face',
      'Scale AI',
      'Cerebras Systems',
      'SambaNova Systems',
      'DeepSeek',
      'Baidu AI',
      'Alibaba DAMO',
      'Zhipu AI',
      'Moonshot AI',
      'Sakana AI',
      'Imbue',
      'Inflection AI',
      'Adept AI',
      'Recursion Pharmaceuticals',
      'Insilico Medicine',
    ],
    'llm engineer': [
      'OpenAI',
      'Anthropic',
      'Google DeepMind',
      'Meta AI',
      'Microsoft AI',
      'Mistral AI',
      'Cohere',
      'AI21 Labs',
      'Aleph Alpha',
      'xAI',
      'Hugging Face',
      'LangChain',
      'LlamaIndex',
      'Pinecone',
      'Weaviate',
      'Chroma',
      'Together AI',
      'Groq',
      'Cerebras Systems',
      'SambaNova Systems',
      'Modal',
      'Replicate',
      'Perplexity AI',
      'DeepSeek',
      'Baidu AI',
      'Sarvam AI',
      'Krutrim',
    ],

    // ─────────────────────────────────────────────────────────────────────
    // PRODUCT / INFRA / DATA
    // ─────────────────────────────────────────────────────────────────────
    'ai product manager': [
      'OpenAI',
      'Anthropic',
      'Google DeepMind',
      'Microsoft AI',
      'Meta AI',
      'Adobe Firefly',
      'Canva AI',
      'Salesforce Einstein',
      'ServiceNow AI',
      'Glean',
      'Writer',
      'Notion AI',
      'Grammarly',
      'Perplexity AI',
      'Runway',
      'Synthesia',
      'Tempus AI',
      'Khanmigo (Khan Academy)',
      'Duolingo Max',
      'Moveworks',
      'Harvey AI',
    ],
    // Key fixed: must equal the lower-cased HomeCareer title
    // "MLOps / AI Infrastructure Engineer". The previous key
    // ("mlops / ai infrastructure") never matched, so this career had zero
    // companies.
    'mlops / ai infrastructure engineer': [
      'Microsoft AI',
      'Google DeepMind',
      'Meta AI',
      'OpenAI',
      'Anthropic',
      'Weights & Biases',
      'DataRobot',
      'Scale AI',
      'Groq',
      'Cerebras Systems',
      'SambaNova Systems',
      'Modal',
      'Replicate',
      'Together AI',
      'Pinecone',
      'Weaviate',
      'Chroma',
      'Coreweave',
      'Hugging Face',
    ],
    'data engineer': [
      'Google DeepMind',
      'Microsoft AI',
      'Meta AI',
      'OpenAI',
      'Anthropic',
      'DataRobot',
      'Scale AI',
      'Weights & Biases',
      'Pinecone',
      'Weaviate',
      'Chroma',
      'Salesforce Einstein',
      'ServiceNow AI',
      'Glean',
      'Kensho Technologies',
      'Alphasense',
      'Tempus AI',
      'Recursion Pharmaceuticals',
      'Coreweave',
    ],

    // ─────────────────────────────────────────────────────────────────────
    // ROBOTICS / SECURITY
    // ─────────────────────────────────────────────────────────────────────
    'robotics engineer': [
      'Google DeepMind',
      'Tesla AI',
      'Waymo',
      'Figure AI',
      '1X Technologies',
      'Boston Dynamics',
      'OpenAI',
      'Microsoft AI',
      'Meta AI',
      'Sakana AI',
    ],
    // Key fixed: must equal the lower-cased HomeCareer title
    // "AI Security Engineer". The previous key ("ai security") never matched,
    // so this career had zero companies.
    'ai security engineer': [
      'OpenAI',
      'Anthropic',
      'Google DeepMind',
      'Microsoft AI',
      'Meta AI',
      'Darktrace',
      'CrowdStrike',
      'SentinelOne',
      'Harvey AI',
      'Baidu AI',
      'DeepSeek',
      'Hugging Face',
      'Scale AI',
      'Cleanlab',
    ],
  };

  /// Canonical company keys per career key, computed once.
  ///
  /// Both sides of every comparison (relationship names and directory
  /// companies) go through [_canonicalCompanyKey], so matching stays
  /// consistent and cheap.
  static final Map<String, Set<String>> _careerToCompanyKeys =
      <String, Set<String>>{
    for (final entry in _careerToCompanyNames.entries)
      entry.key: entry.value.map(_canonicalCompanyKey).toSet(),
  };

  List<HomeCompany> companiesForCareer(
    HomeCareer career,
    List<HomeCompany> companies,
  ) {
    final wantedKeys = _careerToCompanyKeys[_key(career.title)];

    if (wantedKeys == null || wantedKeys.isEmpty) {
      return const <HomeCompany>[];
    }

    return _resolveCompanies(wantedKeys, companies);
  }

  List<HomeCareer> careersForCompany(
    HomeCompany company,
    List<HomeCareer> careers,
  ) {
    final companyKey = _canonicalCompanyKey(company.name);
    final result = <HomeCareer>[];

    for (final career in careers) {
      final keys = _careerToCompanyKeys[_key(career.title)];

      if (keys != null && keys.contains(companyKey)) {
        result.add(career);
      }
    }

    return result;
  }

  static List<HomeCompany> _resolveCompanies(
    Set<String> wantedKeys,
    List<HomeCompany> companies,
  ) {
    final seen = <String>{};
    final result = <HomeCompany>[];

    for (final company in companies) {
      final key = _canonicalCompanyKey(company.name);

      if (wantedKeys.contains(key) && seen.add(key)) {
        result.add(company);
      }
    }

    return result;
  }

  /// Canonical company key.
  ///
  /// Identity comes from the authoritative verified registry:
  /// - verified companies resolve to their canonical company ID;
  /// - approved canonicalizations resolve to the parent identity (see the
  ///   registry's ALIAS POLICY, for example Notion AI → notion,
  ///   Adobe Firefly → adobe);
  /// - every other name keeps its own normalized name. No other alias is
  ///   applied.
  static String _canonicalCompanyKey(String value) {
    final identity = VerifiedCompanyData.canonicalIdentity(value);

    if (identity != null) {
      return identity.companyId;
    }

    return _key(value);
  }

  static String _key(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
}
