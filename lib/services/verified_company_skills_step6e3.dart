import 'package:flutter/foundation.dart';

/// Step 6E-3
///
/// Company-specific skills are derived only from official company career/job
/// sources reviewed for this data batch.
///
/// IMPORTANT:
/// - These are observed skills/technologies in selected official job postings.
/// - They are NOT universal requirements for every role at the company.
/// - They do NOT mean the company is hiring for every listed skill right now.
/// - Do not use this data as live hiring or salary data.
class VerifiedCompanySkillProfile {
  final String companyId;
  final String companyName;
  final List<String> skills;
  final List<String> technologies;
  final List<String> engineeringConcepts;
  final String sourceLabel;
  final List<String> sourceUrls;
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

  static final List<VerifiedCompanySkillProfile> _profiles = [
    VerifiedCompanySkillProfile(
      companyId: 'openai',
      companyName: 'OpenAI',
      skills: ['Python', 'Go', 'Rust', 'TypeScript', 'JavaScript', 'C++', 'SQL', 'PyTorch', 'Docker', 'Kubernetes'],
      technologies: ['PostgreSQL', 'CI/CD', 'Git', 'Linux', 'REST APIs'],
      engineeringConcepts: ['Distributed systems', 'Cloud infrastructure', 'Reliability', 'Scalability', 'Observability', 'Security', 'Inference systems', 'Developer tooling', 'Multimodal systems'],
      sourceLabel: 'Official OpenAI career postings',
      sourceUrls: [
        'https://openai.com/careers/software-engineer-cloud-agents-san-francisco/',
        'https://openai.com/careers/software-engineer-api-multimodal-san-francisco/',
        'https://openai.com/careers/software-engineer-research-developer-productivity-san-francisco/',
      ],
      lastVerified: _verifiedDate,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'google-deepmind',
      companyName: 'Google DeepMind',
      skills: ['Software engineering', 'Machine learning', 'Deep learning', 'Mathematics', 'Research engineering'],
      technologies: ['Distributed computing', 'AI model infrastructure'],
      engineeringConcepts: ['Frontier model development', 'Distributed systems', 'Robotics', 'Scalable software', 'Model implementation', 'Model optimization', 'Research experimentation'],
      sourceLabel: 'Official Google DeepMind careers',
      sourceUrls: ['https://deepmind.google/careers/'],
      lastVerified: _verifiedDate,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'microsoft',
      companyName: 'Microsoft',
      skills: ['Python', 'C#', 'PyTorch', 'Machine learning', 'Deep learning', 'MLOps', 'AIOps'],
      technologies: ['Azure', 'AWS', 'GCP', 'LangChain', 'LlamaIndex', 'Haystack', 'Transformers', 'AutoGen', 'DSPy'],
      engineeringConcepts: ['LLMs', 'Generative AI', 'Agent orchestration', 'Prompt engineering', 'Retrieval-augmented generation', 'Fine-tuning', 'Model evaluation', 'Monitoring', 'CI/CD', 'Cloud deployment'],
      sourceLabel: 'Official Microsoft Careers posting',
      sourceUrls: ['https://careers.microsoft.com/v2/global/en/locations/hyderabad.html'],
      lastVerified: _verifiedDate,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'nvidia',
      companyName: 'NVIDIA',
      skills: ['Python', 'C++', 'CUDA', 'Machine learning', 'Deep learning', 'LLMs'],
      technologies: ['PyTorch', 'Kubernetes', 'Ray', 'Slurm', 'RAG'],
      engineeringConcepts: ['Distributed infrastructure', 'GPU computing', 'Model deployment', 'Model optimization', 'AI agents', 'Vector search', 'High-performance computing', 'Inference systems', 'Data processing'],
      sourceLabel: 'Official NVIDIA Careers postings',
      sourceUrls: [
        'https://jobs.nvidia.com/careers/job/893397346924',
        'https://jobs.nvidia.com/careers/job/893397617990',
        'https://jobs.nvidia.com/careers/job/893397618102',
      ],
      lastVerified: _verifiedDate,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'anthropic',
      companyName: 'Anthropic',
      skills: ['Machine learning', 'Reinforcement learning', 'Software engineering', 'Research engineering', 'Distributed systems'],
      technologies: ['GPU systems', 'ML infrastructure', 'Data platforms', 'Inference systems'],
      engineeringConcepts: ['Pre-training', 'Post-training', 'Model evaluation', 'RL engineering', 'AI safety', 'Interpretability', 'Inference performance', 'Research infrastructure', 'Search', 'Cybersecurity'],
      sourceLabel: 'Official Anthropic Careers postings',
      sourceUrls: ['https://www.anthropic.com/careers/jobs'],
      lastVerified: _verifiedDate,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'amazon',
      companyName: 'Amazon',
      skills: ['Python', 'Java', 'C++', 'Rust', 'Go', 'Machine learning', 'LLM fundamentals'],
      technologies: ['AWS', 'Kubernetes', 'OpenSearch', 'Apache Spark', 'CloudFormation', 'Terraform', 'CDK'],
      engineeringConcepts: ['Distributed systems', 'Cloud computing', 'Scalability', 'Reliability', 'Data pipelines', 'Search', 'Observability', 'Security', 'AI/ML infrastructure', 'Serverless computing'],
      sourceLabel: 'Official Amazon Jobs postings',
      sourceUrls: [
        'https://www.amazon.jobs/en/jobs/10386342/software-development-engineer',
        'https://amazon.jobs/en/jobs/10502946/software-development-engineer-aws-opensearch',
        'https://amazon.jobs/en/jobs/10525633/software-development-engineer-lambda-experience',
      ],
      lastVerified: _verifiedDate,
    ),
    VerifiedCompanySkillProfile(
      companyId: 'apple',
      companyName: 'Apple',
      skills: ['Python', 'Java', 'C++', 'Machine learning', 'Generative AI', 'Natural language processing'],
      technologies: ['Spark', 'SQL', 'Snowflake', 'Hadoop', 'LLM systems'],
      engineeringConcepts: ['Distributed systems', 'Data processing pipelines', 'Large-scale ML', 'Model training', 'Model deployment', 'Semantic retrieval', 'Ranking models', 'On-device optimization', 'Privacy-aware AI'],
      sourceLabel: 'Official Apple Careers postings',
      sourceUrls: [
        'https://jobs.apple.com/en-us/details/200682189/applied-machine-learning-engineer-apple-intelligence',
        'https://jobs.apple.com/en-us/details/200669144-0836/machine-learning-engineer-search',
        'https://jobs.apple.com/en-in/details/200665562-0836/machine-learning-engineer-apple-store-online',
      ],
      lastVerified: _verifiedDate,
    ),
  ];

  List<VerifiedCompanySkillProfile> get all => List.unmodifiable(_profiles);

  VerifiedCompanySkillProfile? byCompanyId(String companyId) {
    final normalized = _normalize(companyId);
    for (final profile in _profiles) {
      if (_normalize(profile.companyId) == normalized) return profile;
    }
    return null;
  }

  VerifiedCompanySkillProfile? byCompanyName(String companyName) {
    final normalized = _normalize(companyName);
    for (final profile in _profiles) {
      if (_normalize(profile.companyName) == normalized) return profile;
    }
    return null;
  }

  static String _normalize(String value) {
    return value.trim().toLowerCase().replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }
}
