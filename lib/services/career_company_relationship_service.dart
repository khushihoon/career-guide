import '../models/home_market_models.dart';

/// Step 6D — Global Career ↔ Company reference relationship layer.
///
/// IMPORTANT:
/// - These are curated REFERENCE relationships, not live hiring signals.
/// - A company appearing here means the company is relevant to the career
///   family in the app's career-discovery model; it does NOT mean the company
///   is hiring right now.
/// - Live openings, verified job-derived skills and salary data remain
///   separate data concerns and must be connected from verified sources.
///
/// The mapping intentionally uses the actual company names available in the
/// current HomeMarket company directory (for example, "Google DeepMind"
/// rather than a separate "Google" placeholder). This prevents exact-name
/// mismatches that previously caused only OpenAI to appear.
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
    'mlops / ai infrastructure': [
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
    'ai security': [
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

  List<HomeCompany> companiesForCareer(
    HomeCareer career,
    List<HomeCompany> companies,
  ) {
    final wanted = _careerToCompanyNames[_key(career.title)] ?? const <String>[];
    return _resolveCompanies(wanted, companies);
  }

  List<HomeCareer> careersForCompany(
    HomeCompany company,
    List<HomeCareer> careers,
  ) {
    final companyKey = _canonicalCompanyKey(company.name);
    final result = <HomeCareer>[];

    for (final career in careers) {
      final names = _careerToCompanyNames[_key(career.title)] ?? const <String>[];
      if (names.any((name) => _canonicalCompanyKey(name) == companyKey)) {
        result.add(career);
      }
    }

    return result;
  }

  static List<HomeCompany> _resolveCompanies(
    List<String> wanted,
    List<HomeCompany> companies,
  ) {
    final wantedKeys = wanted.map(_canonicalCompanyKey).toSet();
    final result = <HomeCompany>[];

    for (final company in companies) {
      if (wantedKeys.contains(_canonicalCompanyKey(company.name)) &&
          !result.any(
            (item) =>
                _canonicalCompanyKey(item.name) == _canonicalCompanyKey(company.name),
          )) {
        result.add(company);
      }
    }

    return result;
  }

  /// Normalizes company aliases so future directory naming changes do not
  /// silently break the relationship layer.
  static String _canonicalCompanyKey(String value) {
    var key = _key(value);

    const aliases = <String, String>{
      'google': 'google deepmind',
      'google ai': 'google deepmind',
      'deepmind': 'google deepmind',
      'microsoft': 'microsoft ai',
      'microsoft ai': 'microsoft ai',
      'amazon': 'amazon',
      'aws': 'amazon',
      'adobe': 'adobe firefly',
      'nvidia': 'nvidia',
      'tesla': 'tesla ai',
      'meta': 'meta ai',
      'meta ai': 'meta ai',
      'coreweave': 'coreweave',
      'coreweave inc': 'coreweave',
      'salesforce': 'salesforce einstein',
      'servicenow': 'servicenow ai',
    };

    key = aliases[key] ?? key;
    return key;
  }

  static String _key(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
}
