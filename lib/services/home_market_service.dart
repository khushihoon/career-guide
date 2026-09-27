import '../models/home_market_models.dart';
import '../models/models.dart';

class HomeMarketService {
  const HomeMarketService();

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

  List<HomeCareer> getCareers() {
    const meta = HomeDataMeta(
      status: HomeDataStatus.reference,
      type: HomeDataType.career,
      note: 'Curated career reference data. Not a live hiring feed.',
    );

    return const [
      HomeCareer(
        id: 'software_engineer',
        title: 'Software Engineer',
        shortDescription: 'Builds software products, platforms and systems.',
        overview: 'Designs, builds, tests and maintains software used by people and organizations.',
        icon: '💻',
        workAreas: ['Backend', 'Frontend', 'Mobile', 'Platform', 'Systems'],
        commonSkills: ['Programming', 'Data Structures', 'Algorithms', 'System Design'],
        tools: ['Git', 'Cloud', 'Databases', 'APIs'],
        industries: ['Technology', 'FinTech', 'Healthcare', 'E-commerce'],
        relatedCompanyIds: ['google', 'microsoft', 'amazon', 'apple', 'meta', 'nvidia', 'openai', 'anthropic'],
        meta: meta,
      ),
      HomeCareer(
        id: 'ai_engineer',
        title: 'AI Engineer',
        shortDescription: 'Builds AI-powered products and intelligent systems.',
        overview: 'Applies machine learning, software engineering and AI technologies to practical intelligent products.',
        icon: '🤖',
        workAreas: ['Applied AI', 'AI Products', 'ML Systems', 'Generative AI'],
        commonSkills: ['Python', 'Machine Learning', 'APIs', 'Problem Solving'],
        tools: ['PyTorch', 'TensorFlow', 'Cloud', 'LLM APIs'],
        industries: ['Technology', 'Healthcare', 'Finance', 'Robotics'],
        relatedCompanyIds: ['openai', 'anthropic', 'google', 'microsoft', 'meta', 'nvidia', 'amazon'],
        meta: meta,
      ),
      HomeCareer(
        id: 'ml_engineer',
        title: 'ML Engineer',
        shortDescription: 'Turns machine-learning models into useful systems.',
        overview: 'Develops, deploys and maintains machine-learning systems and production pipelines.',
        icon: '🧠',
        workAreas: ['Model Development', 'ML Platforms', 'MLOps', 'Inference'],
        commonSkills: ['Python', 'Machine Learning', 'Statistics', 'Software Engineering'],
        tools: ['PyTorch', 'TensorFlow', 'Kubernetes', 'Cloud'],
        industries: ['Technology', 'Finance', 'Healthcare', 'Autonomous Systems'],
        relatedCompanyIds: ['google', 'nvidia', 'microsoft', 'amazon', 'meta', 'openai', 'anthropic'],
        meta: meta,
      ),
      HomeCareer(
        id: 'data_scientist',
        title: 'Data Scientist',
        shortDescription: 'Uses data, statistics and models to solve problems.',
        overview: 'Analyzes data, builds models and communicates findings that support products and decisions.',
        icon: '📊',
        workAreas: ['Analytics', 'Experimentation', 'Predictive Modeling', 'Decision Science'],
        commonSkills: ['Python', 'Statistics', 'SQL', 'Data Analysis'],
        tools: ['SQL', 'Python', 'Pandas', 'Jupyter'],
        industries: ['Technology', 'Finance', 'Healthcare', 'Retail'],
        relatedCompanyIds: ['google', 'microsoft', 'amazon', 'meta', 'nvidia'],
        meta: meta,
      ),
      HomeCareer(
        id: 'nlp_engineer',
        title: 'NLP Engineer',
        shortDescription: 'Builds systems that work with human language.',
        overview: 'Develops language-processing systems such as search, classification, translation and language-model applications.',
        icon: '🗣️',
        workAreas: ['Language AI', 'Search', 'Text Processing', 'Conversational AI'],
        commonSkills: ['Python', 'NLP', 'Machine Learning', 'Transformers'],
        tools: ['PyTorch', 'Hugging Face', 'Python', 'LLMs'],
        industries: ['Technology', 'Search', 'Enterprise Software'],
        relatedCompanyIds: ['openai', 'anthropic', 'google', 'microsoft', 'meta'],
        meta: meta,
      ),
      HomeCareer(
        id: 'computer_vision_engineer',
        title: 'Computer Vision Engineer',
        shortDescription: 'Builds systems that understand images and video.',
        overview: 'Develops perception and visual intelligence systems for images, video and physical-world applications.',
        icon: '👁️',
        workAreas: ['Vision AI', 'Perception', 'Image Processing', 'Robotics'],
        commonSkills: ['Python', 'Computer Vision', 'Deep Learning', 'Linear Algebra'],
        tools: ['PyTorch', 'OpenCV', 'TensorFlow', 'CUDA'],
        industries: ['Robotics', 'Automotive', 'Healthcare', 'Technology'],
        relatedCompanyIds: ['nvidia', 'google', 'meta', 'amazon', 'microsoft'],
        meta: meta,
      ),
      HomeCareer(
        id: 'prompt_engineer',
        title: 'Prompt Engineer',
        shortDescription: 'Designs and evaluates instructions for AI systems.',
        overview: 'Designs, tests and improves instructions and workflows for generative AI systems.',
        icon: '✍️',
        workAreas: ['Prompt Design', 'Evaluation', 'AI Workflows', 'Agent Systems'],
        commonSkills: ['Prompt Design', 'Evaluation', 'LLMs', 'Communication'],
        tools: ['LLM Platforms', 'Python', 'Evaluation Tools'],
        industries: ['Technology', 'Enterprise Software', 'AI Products'],
        relatedCompanyIds: ['openai', 'anthropic', 'google', 'microsoft', 'meta'],
        meta: meta,
      ),
      HomeCareer(
        id: 'ai_researcher',
        title: 'AI Researcher',
        shortDescription: 'Researches new methods, models and AI capabilities.',
        overview: 'Investigates new algorithms, model architectures, learning methods and AI capabilities.',
        icon: '🔬',
        workAreas: ['Research', 'Deep Learning', 'Model Architecture', 'Evaluation'],
        commonSkills: ['Mathematics', 'Machine Learning', 'Research', 'Programming'],
        tools: ['Python', 'PyTorch', 'JAX', 'Research Papers'],
        industries: ['AI Research', 'Technology', 'Robotics', 'Academia'],
        relatedCompanyIds: ['openai', 'anthropic', 'google', 'microsoft', 'meta', 'nvidia'],
        meta: meta,
      ),
      HomeCareer(
        id: 'ai_product_manager',
        title: 'AI Product Manager',
        shortDescription: 'Guides AI products from user problem to product delivery.',
        overview: 'Connects user needs, product strategy, engineering and AI capabilities.',
        icon: '📦',
        workAreas: ['Product Strategy', 'AI Products', 'Experimentation', 'Delivery'],
        commonSkills: ['Product Thinking', 'Communication', 'AI Literacy', 'Analytics'],
        tools: ['Product Analytics', 'Experimentation', 'AI Platforms'],
        industries: ['Technology', 'Enterprise', 'Consumer Products'],
        relatedCompanyIds: ['google', 'microsoft', 'amazon', 'meta', 'openai', 'anthropic'],
        meta: meta,
      ),
      HomeCareer(
        id: 'llm_engineer',
        title: 'LLM Engineer',
        shortDescription: 'Builds applications and systems around large language models.',
        overview: 'Works on model integration, evaluation, retrieval, agents and production language-model systems.',
        icon: '🧬',
        workAreas: ['LLM Applications', 'RAG', 'Agents', 'Evaluation'],
        commonSkills: ['Python', 'LLMs', 'Transformers', 'APIs'],
        tools: ['PyTorch', 'Hugging Face', 'Vector Databases', 'Cloud'],
        industries: ['AI', 'Technology', 'Enterprise Software'],
        relatedCompanyIds: ['openai', 'anthropic', 'google', 'microsoft', 'meta', 'nvidia'],
        meta: meta,
      ),
      HomeCareer(
        id: 'robotics_engineer',
        title: 'Robotics Engineer',
        shortDescription: 'Builds intelligent machines and robotic systems.',
        overview: 'Combines software, perception, controls and hardware to build robotic systems.',
        icon: '🦾',
        workAreas: ['Robotics', 'Perception', 'Controls', 'Autonomy'],
        commonSkills: ['Programming', 'Robotics', 'Computer Vision', 'Systems'],
        tools: ['C++', 'Python', 'ROS', 'Simulation'],
        industries: ['Robotics', 'Automotive', 'Manufacturing', 'Technology'],
        relatedCompanyIds: ['nvidia', 'amazon', 'google', 'microsoft'],
        meta: meta,
      ),
      HomeCareer(
        id: 'mlops_engineer',
        title: 'MLOps / AI Infrastructure Engineer',
        shortDescription: 'Builds reliable infrastructure for AI and ML systems.',
        overview: 'Helps teams train, deploy, monitor and operate machine-learning systems at scale.',
        icon: '☁️',
        workAreas: ['MLOps', 'Infrastructure', 'Deployment', 'Monitoring'],
        commonSkills: ['Cloud', 'Python', 'Containers', 'CI/CD'],
        tools: ['Kubernetes', 'Docker', 'AWS', 'GCP', 'Azure'],
        industries: ['Technology', 'Cloud', 'Enterprise Software'],
        relatedCompanyIds: ['google', 'microsoft', 'amazon', 'nvidia', 'meta'],
        meta: meta,
      ),
      HomeCareer(
        id: 'ai_security_engineer',
        title: 'AI Security Engineer',
        shortDescription: 'Works on security for AI systems and AI-enabled products.',
        overview: 'Works on securing AI systems, infrastructure, data and AI-enabled applications.',
        icon: '🔐',
        workAreas: ['AI Security', 'Application Security', 'Threat Modeling'],
        commonSkills: ['Security', 'Programming', 'Cloud', 'Threat Modeling'],
        tools: ['Cloud Security', 'Linux', 'Security Testing'],
        industries: ['Technology', 'Cybersecurity', 'Enterprise'],
        relatedCompanyIds: ['microsoft', 'google', 'amazon', 'nvidia'],
        meta: meta,
      ),
      HomeCareer(
        id: 'data_engineer',
        title: 'Data Engineer',
        shortDescription: 'Builds systems that collect, transform and serve data.',
        overview: 'Builds reliable data pipelines, platforms and storage systems used by analytics and AI teams.',
        icon: '🗄️',
        workAreas: ['Data Platforms', 'Pipelines', 'Warehousing', 'Streaming'],
        commonSkills: ['SQL', 'Python', 'Data Modeling', 'Distributed Systems'],
        tools: ['Spark', 'Kafka', 'Airflow', 'Cloud'],
        industries: ['Technology', 'Finance', 'Healthcare', 'Retail'],
        relatedCompanyIds: ['google', 'microsoft', 'amazon', 'meta', 'nvidia'],
        meta: meta,
      ),
    ];
  }

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
        description: 'Artificial intelligence, machine learning and intelligent systems.',
        careerIds: ['ai_engineer', 'ml_engineer', 'nlp_engineer', 'computer_vision_engineer', 'prompt_engineer', 'ai_researcher', 'llm_engineer'],
        meta: meta,
      ),
      HomeCareerArea(
        id: 'data',
        title: 'Data',
        description: 'Data science, analytics and data engineering.',
        careerIds: ['data_scientist', 'data_engineer'],
        meta: meta,
      ),
      HomeCareerArea(
        id: 'software',
        title: 'Software',
        description: 'Software engineering, platforms and systems.',
        careerIds: ['software_engineer', 'mlops_engineer'],
        meta: meta,
      ),
      HomeCareerArea(
        id: 'security',
        title: 'Security',
        description: 'Security engineering and protection of digital systems.',
        careerIds: ['ai_security_engineer'],
        meta: meta,
      ),
      HomeCareerArea(
        id: 'robotics',
        title: 'Robotics',
        description: 'Robotics, perception, autonomy and intelligent machines.',
        careerIds: ['robotics_engineer', 'computer_vision_engineer'],
        meta: meta,
      ),
      HomeCareerArea(
        id: 'product',
        title: 'AI Product',
        description: 'Product roles that work closely with AI technologies.',
        careerIds: ['ai_product_manager'],
        meta: meta,
      ),
    ];
  }

  List<HomeCompany> getCompanies() {
    const meta = HomeDataMeta(
      status: HomeDataStatus.reference,
      type: HomeDataType.company,
      note: 'Company directory/reference information. It does not mean the company is hiring now.',
    );

    return kAiCompanies.map((company) {
      final careers = _careerIdsForCompany(company.name);

      return HomeCompany(
        id: _companyId(company.name),
        name: company.name,
        country: company.country,
        description: company.description,
        logo: company.icon,
        focusAreas: _split(company.focus),
        notableRoles: careers.map(_careerTitle).toList(growable: false),
        relatedCareerIds: careers,
        products: company.products,
        industries: _split(company.focus),
        engineeringAreas: careers.map(_careerTitle).toList(growable: false),
        website: company.website,
        careersUrl: company.website,
        meta: meta,
      );
    }).toList(growable: false);
  }

  List<HomeCareer> searchCareers(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return getCareers();

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
    if (q.isEmpty) return getCompanies();

    return getCompanies().where((company) {
      return [
        company.name,
        company.country ?? '',
        company.description ?? '',
        ...company.focusAreas,
        ...company.notableRoles,
        ...company.products,
      ].join(' ').toLowerCase().contains(q);
    }).toList(growable: false);
  }

  HomeCareer? getCareerById(String id) {
    for (final career in getCareers()) {
      if (career.id == id) return career;
    }
    return null;
  }

  HomeCompany? getCompanyById(String id) {
    for (final company in getCompanies()) {
      if (company.id == id) return company;
    }
    return null;
  }

  List<HomeCompany> getCompaniesForCareer(String careerId) {
    return getCompanies()
        .where((company) => company.relatedCareerIds.contains(careerId))
        .toList(growable: false);
  }

  List<HomeCareer> getCareersForCompany(String companyId) {
    final company = getCompanyById(companyId);
    if (company == null) return const [];

    return company.relatedCareerIds
        .map(getCareerById)
        .whereType<HomeCareer>()
        .toList(growable: false);
  }

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
        relatedCareerIds: ['software_engineer', 'ai_engineer', 'ml_engineer'],
        meta: meta,
      ),
      HomeSkillSignal(
        id: 'python',
        name: 'Python',
        summary: 'Commonly used across AI, ML, data and automation work.',
        relatedCareerIds: ['ai_engineer', 'ml_engineer', 'data_scientist', 'nlp_engineer', 'llm_engineer'],
        meta: meta,
      ),
      HomeSkillSignal(
        id: 'sql',
        name: 'SQL',
        summary: 'Important for working with structured data and data systems.',
        relatedCareerIds: ['data_scientist', 'data_engineer', 'software_engineer'],
        meta: meta,
      ),
      HomeSkillSignal(
        id: 'machine_learning',
        name: 'Machine Learning',
        summary: 'A core technical area for many AI and ML roles.',
        relatedCareerIds: ['ai_engineer', 'ml_engineer', 'data_scientist', 'ai_researcher'],
        meta: meta,
      ),
      HomeSkillSignal(
        id: 'llms',
        name: 'LLMs',
        summary: 'Relevant to language-model applications and generative AI work.',
        relatedCareerIds: ['llm_engineer', 'nlp_engineer', 'ai_engineer', 'prompt_engineer'],
        meta: meta,
      ),
    ];
  }

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
        summary: 'A technology company may hire across software, AI, ML, data, infrastructure and research roles.',
        relatedCareerIds: ['software_engineer', 'ai_engineer', 'ml_engineer', 'data_scientist'],
        meta: meta,
      ),
      HomeCareerInsight(
        id: 'skills_transfer',
        title: 'Skills can transfer across careers',
        summary: 'Programming, problem solving and data skills can support multiple technical career paths.',
        relatedCareerIds: ['software_engineer', 'ai_engineer', 'ml_engineer', 'data_scientist'],
        meta: meta,
      ),
      HomeCareerInsight(
        id: 'company_directory',
        title: 'A company can matter even when it is not hiring',
        summary: 'Company discovery is separate from live job availability, so the directory can remain useful over time.',
        relatedCareerIds: [],
        meta: meta,
      ),
    ];
  }

  List<HomeJobOpportunity> getJobs() => const [];
  List<HomeHiringSnapshot> getHiringSnapshots() => const [];
  List<HomeSalaryInfo> getSalaries() => const [];

  String _companyId(String name) => name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');

  List<String> _careerIdsForCompany(String name) {
    final n = name.toLowerCase();

    if (n.contains('openai') || n.contains('anthropic')) {
      return ['ai_engineer', 'ml_engineer', 'llm_engineer', 'ai_researcher', 'software_engineer', 'prompt_engineer'];
    }
    if (n.contains('google') || n.contains('deepmind')) {
      return ['software_engineer', 'ai_engineer', 'ml_engineer', 'data_scientist', 'nlp_engineer', 'computer_vision_engineer', 'ai_researcher', 'llm_engineer', 'ai_product_manager'];
    }
    if (n.contains('microsoft')) {
      return ['software_engineer', 'ai_engineer', 'ml_engineer', 'data_scientist', 'llm_engineer', 'ai_product_manager', 'ai_security_engineer'];
    }
    if (n.contains('nvidia')) {
      return ['software_engineer', 'ai_engineer', 'ml_engineer', 'computer_vision_engineer', 'ai_researcher', 'llm_engineer', 'robotics_engineer', 'mlops_engineer'];
    }
    if (n.contains('meta')) {
      return ['software_engineer', 'ai_engineer', 'ml_engineer', 'data_scientist', 'nlp_engineer', 'computer_vision_engineer', 'ai_researcher', 'llm_engineer'];
    }
    if (n.contains('amazon')) {
      return ['software_engineer', 'ai_engineer', 'ml_engineer', 'data_scientist', 'robotics_engineer', 'ai_product_manager'];
    }
    if (n.contains('apple')) {
      return ['software_engineer', 'ai_engineer', 'ml_engineer', 'computer_vision_engineer', 'ai_product_manager'];
    }

    return ['software_engineer'];
  }

  String _careerTitle(String id) => getCareerById(id)?.title ?? id;

  List<String> _split(String value) => value
      .split(RegExp(r'[,/|]'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .take(8)
      .toList(growable: false);
}