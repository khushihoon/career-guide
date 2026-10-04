import 'company_intelligence_models.dart';
import 'company_skill_extraction_service.dart';
import 'verified_company_data.dart';

/// Step 6E-4 — Deterministic Company Intelligence engine.
///
/// The engine converts normalized source evidence into the single snapshot
/// consumed by the application.
///
/// IMPORTANT:
/// - No AI API is used.
/// - No salary, role, skill, or hiring signal is invented.
/// - Live/observed evidence remains separate from verified reference data.
/// - The canonical company registry is used only to normalize company identity.
/// - Existing public API and behavior are preserved.
class CompanyIntelligenceEngine {
  final CompanySkillExtractionService skillExtractor;

  const CompanyIntelligenceEngine({
    this.skillExtractor = const CompanySkillExtractionService(),
  });

  CompanyIntelligenceSnapshot buildSnapshot({
    required String companyId,
    required String companyName,
    required List<NormalizedJobPosting> postings,
    required List<CompanySourceDefinition> sources,
    DateTime? generatedAt,
  }) {
    final now = generatedAt ?? DateTime.now();

    final extraction = skillExtractor.extract(
      postings,
      observedAt: now,
    );

    final canonicalIdentity = _canonicalCompanyIdentity(
      companyId: companyId,
      companyName: companyName,
    );

    return CompanyIntelligenceSnapshot(
      companyId: canonicalIdentity.companyId,
      companyName: canonicalIdentity.companyName,
      status: postings.isNotEmpty
          ? CompanyIntelligenceDataStatus.live
          : CompanyIntelligenceDataStatus.unavailable,

      // These are observed from normalized live postings only.
      roles: _roleFamilies(postings),

      skills: extraction.skills
          .map((item) => item.normalizedName)
          .toList(growable: false),

      technologies: extraction.technologies
          .map((item) => item.normalizedName)
          .toList(growable: false),

      engineeringConcepts: extraction.engineeringConcepts
          .map((item) => item.normalizedName)
          .toList(growable: false),

      compensation: _compensation(postings),

      liveJobs: List.unmodifiable(postings),

      sources: List.unmodifiable(sources),

      generatedAt: now,

      oldestEvidenceAt: _oldest(postings),

      newestEvidenceAt: _newest(postings),
    );
  }

  // ---------------------------------------------------------------------------
  // CANONICAL COMPANY IDENTITY
  // ---------------------------------------------------------------------------
  //
  // The verified company registry is the canonical identity layer.
  //
  // Example:
  //   "Google DeepMind" -> google_deepmind / Google DeepMind
  //   "Microsoft AI"    -> microsoft / Microsoft
  //   "AWS"             -> amazon / Amazon
  //
  // Unknown companies are NOT invented or forced into the registry.
  // Their supplied identity is preserved.
  // ---------------------------------------------------------------------------

  _CanonicalCompanyIdentity _canonicalCompanyIdentity({
    required String companyId,
    required String companyName,
  }) {
    final byId = VerifiedCompanyData.find(companyId);

    if (byId != null) {
      return _CanonicalCompanyIdentity(
        companyId: byId.companyId,
        companyName: byId.companyName,
      );
    }

    final byName = VerifiedCompanyData.find(companyName);

    if (byName != null) {
      return _CanonicalCompanyIdentity(
        companyId: byName.companyId,
        companyName: byName.companyName,
      );
    }

    final safeId = companyId.trim();

    if (safeId.isNotEmpty) {
      return _CanonicalCompanyIdentity(
        companyId: safeId,
        companyName: companyName.trim(),
      );
    }

    return _CanonicalCompanyIdentity(
      companyId: _normalizeFallbackId(companyName),
      companyName: companyName.trim(),
    );
  }

  // ---------------------------------------------------------------------------
  // ROLE FAMILY DETECTION
  // ---------------------------------------------------------------------------
  //
  // Deterministic title-based detection only.
  //
  // The engine does NOT claim that a company hires for a role unless the
  // normalized live posting title actually contains a matching signal.
  // ---------------------------------------------------------------------------

  List<String> _roleFamilies(
    List<NormalizedJobPosting> postings,
  ) {
    final result = <String>{};

    for (final posting in postings) {
      final title = _normalizeText(posting.title);

      if (title.isEmpty) {
        continue;
      }

      // -----------------------------------------------------------------------
      // Software Engineering
      // -----------------------------------------------------------------------

      if (_containsAny(
        title,
        const [
          'software engineer',
          'software developer',
          'software development engineer',
          'application engineer',
          'backend engineer',
          'back end engineer',
          'frontend engineer',
          'front end engineer',
          'full stack engineer',
          'fullstack engineer',
          'mobile engineer',
          'platform engineer',
          'systems engineer',
        ],
      )) {
        result.add('Software Engineer');
      }

      // -----------------------------------------------------------------------
      // Machine Learning
      // -----------------------------------------------------------------------

      if (_containsAny(
        title,
        const [
          'machine learning engineer',
          'machine learning scientist',
          'machine learning developer',
          'ml engineer',
          'ml scientist',
          'ml developer',
        ],
      )) {
        result.add('ML Engineer');
      }

      // -----------------------------------------------------------------------
      // AI Engineering
      // -----------------------------------------------------------------------

      if (_containsAny(
        title,
        const [
          'ai engineer',
          'ai developer',
          'artificial intelligence engineer',
          'artificial intelligence developer',
          'applied ai engineer',
          'applied artificial intelligence',
        ],
      )) {
        result.add('AI Engineer');
      }

      // -----------------------------------------------------------------------
      // LLM / Generative AI
      // -----------------------------------------------------------------------

      if (_containsAny(
        title,
        const [
          'llm engineer',
          'llm developer',
          'large language model engineer',
          'large language models engineer',
          'generative ai engineer',
          'genai engineer',
          'generative ai developer',
          'foundation model engineer',
        ],
      )) {
        result.add('LLM Engineer');
      }

      // -----------------------------------------------------------------------
      // Data Science
      // -----------------------------------------------------------------------

      if (_containsAny(
        title,
        const [
          'data scientist',
          'data science',
          'applied scientist',
          'research data scientist',
        ],
      )) {
        result.add('Data Scientist');
      }

      // -----------------------------------------------------------------------
      // Data Engineering
      // -----------------------------------------------------------------------

      if (_containsAny(
        title,
        const [
          'data engineer',
          'data engineering',
          'analytics engineer',
          'big data engineer',
        ],
      )) {
        result.add('Data Engineer');
      }

      // -----------------------------------------------------------------------
      // Computer Vision
      // -----------------------------------------------------------------------

      if (_containsAny(
        title,
        const [
          'computer vision',
          'vision engineer',
          'visual perception engineer',
          'perception engineer',
        ],
      )) {
        result.add('Computer Vision Engineer');
      }

      // -----------------------------------------------------------------------
      // NLP / Language
      // -----------------------------------------------------------------------

      if (_containsAny(
        title,
        const [
          'nlp engineer',
          'nlp scientist',
          'natural language processing',
          'natural language engineer',
          'language ai engineer',
          'language model engineer',
        ],
      )) {
        result.add('NLP Engineer');
      }

      // -----------------------------------------------------------------------
      // AI Research
      // -----------------------------------------------------------------------

      if (_containsAny(
        title,
        const [
          'research engineer',
          'research scientist',
          'ai researcher',
          'ai research',
          'machine learning research',
          'machine learning researcher',
          'research scientist',
        ],
      )) {
        result.add('AI Researcher');
      }

      // -----------------------------------------------------------------------
      // MLOps / AI Infrastructure
      // -----------------------------------------------------------------------

      if (_containsAny(
        title,
        const [
          'mlops',
          'mlops engineer',
          'ml platform engineer',
          'machine learning platform',
          'machine learning infrastructure',
          'ai infrastructure',
          'ai platform engineer',
          'ml infrastructure engineer',
        ],
      )) {
        result.add('MLOps / AI Infrastructure');
      }

      // -----------------------------------------------------------------------
      // Robotics
      // -----------------------------------------------------------------------

      if (_containsAny(
        title,
        const [
          'robotics engineer',
          'robotics software engineer',
          'robotics scientist',
          'robotics developer',
          'autonomous systems engineer',
          'robotics perception engineer',
        ],
      )) {
        result.add('Robotics Engineer');
      }

      // -----------------------------------------------------------------------
      // AI Product Management
      // -----------------------------------------------------------------------

      if (_containsAny(
        title,
        const [
          'ai product manager',
          'ai product management',
          'artificial intelligence product manager',
          'machine learning product manager',
          'ml product manager',
          'generative ai product manager',
          'llm product manager',
        ])) {
        result.add('AI Product Manager');
      } else if (_containsAny(
        title,
        const [
          'product manager',
          'product management',
        ],
      ) &&
          _containsAny(
            title,
            const [
              'ai',
              'artificial intelligence',
              'machine learning',
              'ml',
              'llm',
              'generative',
            ],
          )) {
        result.add('AI Product Manager');
      }

      // -----------------------------------------------------------------------
      // AI Security
      // -----------------------------------------------------------------------

      if (_containsAny(
        title,
        const [
          'ai security',
          'artificial intelligence security',
          'machine learning security',
          'ml security',
          'model security',
          'ai safety security',
        ],
      )) {
        result.add('AI Security');
      }

      // -----------------------------------------------------------------------
      // Cyber Security / Security Engineering
      //
      // Kept separate from AI Security so an ordinary security posting does
      // not automatically become an AI-security signal.
      // -----------------------------------------------------------------------

      if (_containsAny(
        title,
        const [
          'security engineer',
          'cybersecurity engineer',
          'cyber security engineer',
          'application security engineer',
          'product security engineer',
          'cloud security engineer',
        ],
      )) {
        result.add('Security Engineer');
      }

      // -----------------------------------------------------------------------
      // Prompt / AI Interaction
      // -----------------------------------------------------------------------

      if (_containsAny(
        title,
        const [
          'prompt engineer',
          'prompt engineering',
          'ai interaction designer',
          'llm prompt',
        ],
      )) {
        result.add('Prompt Engineer');
      }

      // -----------------------------------------------------------------------
      // AI / ML Infrastructure
      //
      // Some infrastructure titles don't explicitly contain "ML" but still
      // describe AI infrastructure. Only explicit AI-related signals qualify.
      // -----------------------------------------------------------------------

      if (_containsAny(
        title,
        const [
          'ai infrastructure',
          'ai infra',
          'ml infrastructure',
          'ml infra',
          'ai platform',
          'ml platform',
        ],
      )) {
        result.add('MLOps / AI Infrastructure');
      }
    }

    return result.toList(growable: false);
  }

  // ---------------------------------------------------------------------------
  // COMPENSATION
  // ---------------------------------------------------------------------------

  List<CompanyCompensation> _compensation(
    List<NormalizedJobPosting> postings,
  ) {
    return List.unmodifiable(
      postings
          .map((posting) => posting.compensation)
          .whereType<CompanyCompensation>()
          .where((item) => item.hasNumericRange),
    );
  }

  // ---------------------------------------------------------------------------
  // EVIDENCE DATES
  // ---------------------------------------------------------------------------

  DateTime? _oldest(
    List<NormalizedJobPosting> postings,
  ) {
    final dates = postings
        .map((posting) => posting.publishedAt)
        .whereType<DateTime>()
        .toList();

    if (dates.isEmpty) {
      return null;
    }

    dates.sort();

    return dates.first;
  }

  DateTime? _newest(
    List<NormalizedJobPosting> postings,
  ) {
    final dates = postings
        .map((posting) => posting.publishedAt)
        .whereType<DateTime>()
        .toList();

    if (dates.isEmpty) {
      return null;
    }

    dates.sort();

    return dates.last;
  }

  // ---------------------------------------------------------------------------
  // TEXT HELPERS
  // ---------------------------------------------------------------------------

  bool _containsAny(
    String value,
    List<String> candidates,
  ) {
    for (final candidate in candidates) {
      if (value.contains(candidate)) {
        return true;
      }
    }

    return false;
  }

  String _normalizeText(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[\-_\/]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  String _normalizeFallbackId(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
}

/// Internal canonical company identity holder.
///
/// This is deliberately private so the existing public API of
/// CompanyIntelligenceEngine remains unchanged.
class _CanonicalCompanyIdentity {
  final String companyId;
  final String companyName;

  const _CanonicalCompanyIdentity({
    required this.companyId,
    required this.companyName,
  });
}