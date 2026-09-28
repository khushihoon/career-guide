/// Step 6E — Verified Company Intelligence data layer.
///
/// IMPORTANT:
/// - This file contains VERIFIED REFERENCE information only.
/// - It does NOT mean the company is hiring right now.
/// - Current openings belong to the future live-opportunities layer.
/// - Skills are not claimed here unless supported by the verified role evidence.
/// - `lastVerified` is the date this reference record was checked.
///
/// Source policy:
/// Official company careers / jobs pages only.
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
    required this.lastVerified,
  });
}

class VerifiedCompanyDataService {
  const VerifiedCompanyDataService();

  static final DateTime _verifiedDate = DateTime(2026, 9, 27);

  /// First Step 6E verified batch.
  ///
  /// These are reference relationships backed by the companies' official
  /// careers/jobs pages checked on 2026-09-27.
  static final List<VerifiedCompanyProfile> _profiles = [
    VerifiedCompanyProfile(
      companyId: 'openai',
      companyName: 'OpenAI',
      officialWebsite: 'https://openai.com',
      careersWebsite: 'https://openai.com/careers',
      headquarters: 'San Francisco, USA',
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
      lastVerified: _verifiedDate,
    ),
    VerifiedCompanyProfile(
      companyId: 'google_deepmind',
      companyName: 'Google DeepMind',
      officialWebsite: 'https://deepmind.google',
      careersWebsite: 'https://deepmind.google/careers',
      headquarters: 'Global',
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
      lastVerified: _verifiedDate,
    ),
    VerifiedCompanyProfile(
      companyId: 'microsoft',
      companyName: 'Microsoft',
      officialWebsite: 'https://www.microsoft.com',
      careersWebsite: 'https://careers.microsoft.com',
      headquarters: 'Redmond, USA',
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
      lastVerified: _verifiedDate,
    ),
    VerifiedCompanyProfile(
      companyId: 'nvidia',
      companyName: 'NVIDIA',
      officialWebsite: 'https://www.nvidia.com',
      careersWebsite: 'https://jobs.nvidia.com',
      headquarters: 'Santa Clara, USA',
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
        'Senior NVIDIA Offensive Security Researcher',
      ],
      sourceLabel: 'NVIDIA Careers',
      lastVerified: _verifiedDate,
    ),
    VerifiedCompanyProfile(
      companyId: 'anthropic',
      companyName: 'Anthropic',
      officialWebsite: 'https://www.anthropic.com',
      careersWebsite: 'https://www.anthropic.com/careers',
      headquarters: 'San Francisco, USA',
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
      lastVerified: _verifiedDate,
    ),
    VerifiedCompanyProfile(
      companyId: 'amazon',
      companyName: 'Amazon',
      officialWebsite: 'https://www.amazon.com',
      careersWebsite: 'https://www.amazon.jobs',
      headquarters: 'Seattle, USA',
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
        'Software Development Engineer - II',
        'Software Dev Engineer (ML)',
        'Software Development Engineer II (ML)',
      ],
      sourceLabel: 'Amazon Jobs',
      lastVerified: _verifiedDate,
    ),
    VerifiedCompanyProfile(
      companyId: 'apple',
      companyName: 'Apple',
      officialWebsite: 'https://www.apple.com',
      careersWebsite: 'https://jobs.apple.com',
      headquarters: 'Cupertino, USA',
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
      lastVerified: _verifiedDate,
    ),
  ];

  List<VerifiedCompanyProfile> get all => List.unmodifiable(_profiles);

  VerifiedCompanyProfile? byCompanyId(String companyId) {
    final key = _normalize(companyId);
    for (final profile in _profiles) {
      if (_normalize(profile.companyId) == key) {
        return profile;
      }
    }
    return null;
  }

  VerifiedCompanyProfile? byCompanyName(String companyName) {
    final key = _normalize(companyName);
    for (final profile in _profiles) {
      if (_normalize(profile.companyName) == key) {
        return profile;
      }
    }
    return null;
  }

  static String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
}
