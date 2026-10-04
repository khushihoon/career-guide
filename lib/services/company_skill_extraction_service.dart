import 'company_intelligence_models.dart';

/// Step 6E-4 — Deterministic evidence-based skill extraction.
///
/// A skill is emitted only when its taxonomy term is actually found in a
/// reviewed posting title/description/team/department. This is not a generic
/// AI guesser and does not claim that every company role needs every signal.
///
/// The extracted signals represent observed evidence from the supplied
/// postings. They are not a replacement for the verified reference skill
/// profiles.
class CompanySkillExtractionService {
  const CompanySkillExtractionService();

  static const Map<String, String> _skillTaxonomy = {
    'python': 'Python',
    'java': 'Java',
    'javascript': 'JavaScript',
    'typescript': 'TypeScript',
    'c++': 'C++',
    'c#': 'C#',
    'golang': 'Go',
    'go language': 'Go',
    'rust': 'Rust',
    'sql': 'SQL',
    'scala': 'Scala',
    'kotlin': 'Kotlin',
    'swift': 'Swift',
    'machine learning': 'Machine Learning',
    'deep learning': 'Deep Learning',
    'computer vision': 'Computer Vision',
    'natural language processing': 'NLP',
    'nlp': 'NLP',
    'reinforcement learning': 'Reinforcement Learning',
    'llm': 'LLMs',
    'large language model': 'LLMs',
    'generative ai': 'Generative AI',
    'artificial intelligence': 'Artificial Intelligence',
    'data science': 'Data Science',
    'statistics': 'Statistics',
    'data engineering': 'Data Engineering',
    'mlops': 'MLOps',
    'devops': 'DevOps',
    'cybersecurity': 'Cybersecurity',
    'cloud computing': 'Cloud',
  };

  static const Map<String, String> _technologyTaxonomy = {
    'pytorch': 'PyTorch',
    'tensorflow': 'TensorFlow',
    'jax': 'JAX',
    'transformers': 'Transformers',
    'hugging face': 'Hugging Face',
    'cuda': 'CUDA',
    'kubernetes': 'Kubernetes',
    'docker': 'Docker',
    'terraform': 'Terraform',
    'aws': 'AWS',
    'amazon web services': 'AWS',
    'azure': 'Azure',
    'google cloud': 'Google Cloud',
    'gcp': 'Google Cloud',
    'spark': 'Apache Spark',
    'kafka': 'Apache Kafka',
    'postgresql': 'PostgreSQL',
    'mysql': 'MySQL',
    'mongodb': 'MongoDB',
    'redis': 'Redis',
    'graphql': 'GraphQL',
    'rest api': 'REST APIs',
    'restful': 'REST APIs',
    'git': 'Git',
    'github': 'GitHub',
    'ci/cd': 'CI/CD',
    'rag': 'RAG',
    'retrieval augmented generation': 'RAG',
    'vector database': 'Vector Databases',
    'vector search': 'Vector Search',
    'ray': 'Ray',
    'slurm': 'Slurm',
    'langchain': 'LangChain',
    'llamaindex': 'LlamaIndex',
    'llama index': 'LlamaIndex',
    'openai api': 'OpenAI API',
    'onnx': 'ONNX',
  };

  static const Map<String, String> _conceptTaxonomy = {
    'distributed systems': 'Distributed Systems',
    'scalability': 'Scalability',
    'reliability': 'Reliability',
    'observability': 'Observability',
    'inference': 'Inference',
    'model serving': 'Model Serving',
    'model deployment': 'Model Deployment',
    'model evaluation': 'Model Evaluation',
    'fine-tuning': 'Fine-tuning',
    'fine tuning': 'Fine-tuning',
    'prompt engineering': 'Prompt Engineering',
    'ai agent': 'AI Agents',
    'ai agents': 'AI Agents',
    'microservices': 'Microservices',
    'data pipeline': 'Data Pipelines',
    'data pipelines': 'Data Pipelines',
    'security': 'Security',
    'privacy': 'Privacy',
    'high performance computing': 'High Performance Computing',
    'gpu': 'GPU Computing',
  };

  CompanySkillExtractionResult extract(
    Iterable<NormalizedJobPosting> postings, {
    DateTime? observedAt,
  }) {
    final postingList = postings.toList(growable: false);
    final now = observedAt ?? DateTime.now();

    final skills = <String, _EvidenceAccumulator>{};
    final technologies = <String, _EvidenceAccumulator>{};
    final concepts = <String, _EvidenceAccumulator>{};

    for (final posting in postingList) {
      final searchable = _normalize(
        '${posting.title}\n'
        '${posting.description}\n'
        '${posting.department ?? ''}\n'
        '${posting.team ?? ''}',
      );

      if (searchable.isEmpty) continue;

      _collect(
        _skillTaxonomy,
        searchable,
        posting,
        skills,
        'skill',
      );

      _collect(
        _technologyTaxonomy,
        searchable,
        posting,
        technologies,
        'technology',
      );

      _collect(
        _conceptTaxonomy,
        searchable,
        posting,
        concepts,
        'concept',
      );
    }

    return CompanySkillExtractionResult(
      skills: _signals(skills, now),
      technologies: _signals(technologies, now),
      engineeringConcepts: _signals(concepts, now),
      analyzedPostingCount: postingList.length,
      observedAt: now,
    );
  }

  void _collect(
    Map<String, String> taxonomy,
    String text,
    NormalizedJobPosting posting,
    Map<String, _EvidenceAccumulator> target,
    String category,
  ) {
    for (final entry in taxonomy.entries) {
      if (!_containsTerm(text, entry.key)) continue;

      final evidence = target.putIfAbsent(
        entry.value,
        () => _EvidenceAccumulator(category),
      );

      evidence.add(
        posting.id,
        posting.sourceUrl,
      );
    }
  }

  bool _containsTerm(
    String text,
    String term,
  ) {
    final normalizedTerm = _normalize(term);

    if (normalizedTerm.isEmpty) {
      return false;
    }

    // Short terms such as "go", "c++", or "c#" need boundary matching
    // to reduce accidental substring matches.
    if (normalizedTerm.length <= 2) {
      return RegExp(
        r'(?<![a-z0-9])' +
            RegExp.escape(normalizedTerm) +
            r'(?![a-z0-9])',
      ).hasMatch(text);
    }

    return text.contains(normalizedTerm);
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll(
          RegExp(r'[\u2010-\u2015]'),
          '-',
        )
        .replaceAll(
          RegExp(r'\s+'),
          ' ',
        )
        .trim();
  }

  List<ExtractedCompanySignal> _signals(
    Map<String, _EvidenceAccumulator> source,
    DateTime observedAt,
  ) {
    final result = source.entries.map((entry) {
      final evidence = entry.value;

      return ExtractedCompanySignal(
        normalizedName: entry.key,
        category: evidence.category,
        evidenceCount: evidence.postingIds.length,
        evidencePostingIds: evidence.postingIds.toList(
          growable: false,
        ),
        sourceUrls: evidence.sourceUrls.toList(
          growable: false,
        ),
        observedAt: observedAt,
      );
    }).toList();

    result.sort(
      (a, b) => b.evidenceCount.compareTo(a.evidenceCount),
    );

    return List.unmodifiable(result);
  }
}

class CompanySkillExtractionResult {
  final List<ExtractedCompanySignal> skills;
  final List<ExtractedCompanySignal> technologies;
  final List<ExtractedCompanySignal> engineeringConcepts;
  final int analyzedPostingCount;
  final DateTime observedAt;

  const CompanySkillExtractionResult({
    required this.skills,
    required this.technologies,
    required this.engineeringConcepts,
    required this.analyzedPostingCount,
    required this.observedAt,
  });
}

class _EvidenceAccumulator {
  final Set<String> postingIds = <String>{};
  final Set<String> sourceUrls = <String>{};
  final String category;

  _EvidenceAccumulator(this.category);

  void add(
    String postingId,
    String sourceUrl,
  ) {
    if (postingId.trim().isNotEmpty) {
      postingIds.add(postingId);
    }

    if (sourceUrl.trim().isNotEmpty) {
      sourceUrls.add(sourceUrl);
    }
  }
}