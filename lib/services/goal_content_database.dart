// ══════════════════════════════════════════════════════════════════════
// lib/services/goal_content_database.dart
//
// PURPOSE: Pure Dart content library — zero API calls, zero internet.
//
// IMPORTANT NAMING:
//   • LocalGoalCategory  — internal enum used ONLY inside this file
//     and local_goal_generator_service.dart. Does NOT clash with
//     GoalCategory in copilot_models.dart.
//   • LocalGoalDifficulty — same: internal only.
//   • The generator maps LocalGoalCategory → GoalCategory before
//     constructing any DailyGoal.
//
// ══════════════════════════════════════════════════════════════════════
// UPGRADE NOTES
// ══════════════════════════════════════════════════════════════════════
// This is still a pure, static content library — no decision-making
// logic lives here. LocalGoalGeneratorService remains solely responsible
// for SELECTING which templates a user sees; this file only defines what
// professional-grade goals EXIST to choose from.
//
// Backward compatibility:
//   • LocalGoalDifficulty, LocalGoalCategory, and every existing
//     GoalTemplate field/value are unchanged.
//   • GoalTemplate gained five NEW, entirely OPTIONAL fields (skill,
//     prerequisites, stage, estimatedMinutes, professionalOutcome), each
//     defaulting to null/const [] — every existing `const GoalTemplate(...)`
//     literal (here or anywhere else) still compiles untouched.
//   • normaliseRole(), dailyForRole(), weeklyForRole(), monthlyForRole()
//     keep their exact signatures and return types.
//
// Content upgrade: every role's daily pool now spans realistic
// professional progression — Foundation → Core Skills → Practice → Real
// Projects — and the shared `_genericDaily` pool (appended to every
// role's list by dailyForRole) now also covers the universal engineering
// stages every professional needs regardless of specialisation: Git/
// GitHub, Debugging, Testing, APIs/Database, Architecture, Security,
// CI/CD, Docker/Cloud, Deployment, Production, Portfolio, Interview, and
// Job-Ready. Two previously-missing role pools (Flutter Developer,
// Computer Vision Engineer — both already reachable via normaliseRole,
// but with no template list behind them) have been added.
// ══════════════════════════════════════════════════════════════════════

// ── Internal difficulty enum (NOT exported to the rest of the app) ────
enum LocalGoalDifficulty { easy, medium, hard }

extension LocalGoalDifficultyX on LocalGoalDifficulty {
  int get baseXp {
    switch (this) {
      case LocalGoalDifficulty.easy:   return 15;
      case LocalGoalDifficulty.medium: return 30;
      case LocalGoalDifficulty.hard:   return 50;
    }
  }

  String get label {
    switch (this) {
      case LocalGoalDifficulty.easy:   return 'Easy';
      case LocalGoalDifficulty.medium: return 'Medium';
      case LocalGoalDifficulty.hard:   return 'Hard';
    }
  }
}

// ── Internal category enum (NOT exported to the rest of the app) ──────
// Named LocalGoalCategory to avoid any clash with GoalCategory in
// copilot_models.dart.
enum LocalGoalCategory {
  coding,
  learning,
  project,
  reading,
  practice,
  community,
  design,
  data,
  deployment,
  career,
  review,
}

extension LocalGoalCategoryX on LocalGoalCategory {
  String get icon {
    switch (this) {
      case LocalGoalCategory.coding:     return '💻';
      case LocalGoalCategory.learning:   return '📚';
      case LocalGoalCategory.project:    return '🛠️';
      case LocalGoalCategory.reading:    return '📖';
      case LocalGoalCategory.practice:   return '🎯';
      case LocalGoalCategory.community:  return '🌐';
      case LocalGoalCategory.design:     return '🎨';
      case LocalGoalCategory.data:       return '📊';
      case LocalGoalCategory.deployment: return '🚀';
      case LocalGoalCategory.career:     return '💼';
      case LocalGoalCategory.review:     return '🔍';
    }
  }
}

// ── NEW: Career-stage metadata (purely descriptive, optional) ─────────
// Represents where a goal sits in the realistic professional progression:
// Foundation → Core Skills → Practice → Real Projects → Testing →
// Git/GitHub → Debugging → APIs/Database → Architecture → Security →
// CI/CD → Docker/Cloud → Deployment → Production → Portfolio →
// Interview → Job Ready. Purely informational metadata — no selection
// logic reads this field in this file; LocalGoalGeneratorService decides
// what to do with it (or not) on its own.
enum GoalStage {
  foundation,
  coreSkills,
  practice,
  realProjects,
  testing,
  gitGithub,
  debugging,
  apisDatabase,
  architecture,
  security,
  ciCd,
  dockerCloud,
  deployment,
  production,
  portfolio,
  interview,
  jobReady,
}

extension GoalStageX on GoalStage {
  String get label {
    switch (this) {
      case GoalStage.foundation:    return 'Foundation';
      case GoalStage.coreSkills:    return 'Core Skills';
      case GoalStage.practice:      return 'Practice';
      case GoalStage.realProjects:  return 'Real Projects';
      case GoalStage.testing:       return 'Testing';
      case GoalStage.gitGithub:     return 'Git/GitHub';
      case GoalStage.debugging:     return 'Debugging';
      case GoalStage.apisDatabase:  return 'APIs/Database';
      case GoalStage.architecture:  return 'Architecture';
      case GoalStage.security:      return 'Security';
      case GoalStage.ciCd:          return 'CI/CD';
      case GoalStage.dockerCloud:   return 'Docker/Cloud';
      case GoalStage.deployment:    return 'Deployment';
      case GoalStage.production:    return 'Production';
      case GoalStage.portfolio:     return 'Portfolio';
      case GoalStage.interview:     return 'Interview';
      case GoalStage.jobReady:      return 'Job Ready';
    }
  }
}

/// Immutable goal template — source of truth before becoming a DailyGoal.
class GoalTemplate {
  final String id;
  final String title;
  final String description;
  final LocalGoalDifficulty difficulty;
  final LocalGoalCategory category;
  final List<String> tags;     // role tags for filtering
  final int minLevel;          // only shown at or above this user level
  final int minPhase;          // only shown at or above this roadmap phase

  // ── NEW — all optional, all backward-compatible ─────────────────────
  /// The specific, concrete skill this goal builds (e.g. "Docker",
  /// "RAG", "Widget Testing"). More precise than `tags`, which is a role
  /// filter, not a skill name.
  final String? skill;

  /// GoalTemplate ids that are logically expected before this one —
  /// descriptive only; nothing in this file enforces it.
  final List<String> prerequisites;

  /// Where this goal sits in the realistic professional progression.
  final GoalStage? stage;

  /// Rough time investment, in minutes, for planning/display purposes.
  final int? estimatedMinutes;

  /// The tangible, provable outcome completing this goal produces (what
  /// you'd point to in a portfolio or interview) — the "Prove" step of
  /// Learn → Practice → Build → Deploy → Prove.
  final String? professionalOutcome;

  const GoalTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.category,
    this.tags = const [],
    this.minLevel = 1,
    this.minPhase = 0,
    this.skill,
    this.prerequisites = const [],
    this.stage,
    this.estimatedMinutes,
    this.professionalOutcome,
  });

  int get xp => difficulty.baseXp;
}

// ════════════════════════════════════════════════════════════════════════
// CONTENT DATABASE
// ════════════════════════════════════════════════════════════════════════

class GoalContentDatabase {
  GoalContentDatabase._();

  // ── Role normaliser ────────────────────────────────────────────────
  static String normaliseRole(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('flutter'))                               return 'flutter_developer';
    if (lower.contains('ai engineer') || lower.contains('ai/ml')) return 'ai_engineer';
    if (lower.contains('data scien'))                            return 'data_scientist';
    if (lower.contains('nlp'))                                   return 'nlp_engineer';
    if (lower.contains('cv engineer') || lower.contains('computer vision')) return 'cv_engineer';
    if (lower.contains('prompt'))                                return 'prompt_engineer';
    if (lower.contains('researcher'))                            return 'ai_researcher';
    if (lower.contains('product manager'))                       return 'ai_product_manager';
    if (lower.contains('ml') || lower.contains('machine learn')) return 'ml_engineer';
    if (lower.contains('data scien'))                            return 'data_scientist';
    return 'generic';
  }

  // ════════════════════════════════════════════════════════════════════
  // AI ENGINEER GOALS
  // ════════════════════════════════════════════════════════════════════
  static const List<GoalTemplate> _aiEngineerDaily = [
    GoalTemplate(
      id: 'ai_e_01',
      title: 'Read one AI research paper abstract',
      description: 'Find a recent paper on arxiv.org and read the abstract and conclusion',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.reading,
      tags: ['ai_engineer'],
      skill: 'AI Research Literacy',
      stage: GoalStage.foundation,
      estimatedMinutes: 15,
    ),
    GoalTemplate(
      id: 'ai_e_02',
      title: 'Study a new LLM concept',
      description: 'Learn about one concept: RAG, fine-tuning, embeddings, or quantization',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.learning,
      tags: ['ai_engineer'],
      skill: 'LLM Fundamentals',
      stage: GoalStage.foundation,
      estimatedMinutes: 20,
    ),
    GoalTemplate(
      id: 'ai_e_03',
      title: 'Explore one HuggingFace model card',
      description: 'Study a model card on huggingface.co — architecture, training, use-cases',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.learning,
      tags: ['ai_engineer'],
      skill: 'Model Literacy',
      stage: GoalStage.foundation,
      estimatedMinutes: 15,
    ),
    GoalTemplate(
      id: 'ai_e_04',
      title: 'Write a Python script using an LLM library',
      description: 'Write a script using transformers, langchain, or llama-index',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: ['ai_engineer'],
      skill: 'LLM Integration',
      stage: GoalStage.coreSkills,
      estimatedMinutes: 35,
    ),
    GoalTemplate(
      id: 'ai_e_05',
      title: 'Implement a RAG pipeline',
      description: 'Build a simple retrieval-augmented generation pipeline with FAISS',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: ['ai_engineer'],
      minLevel: 4,
      skill: 'RAG',
      stage: GoalStage.realProjects,
      estimatedMinutes: 90,
      professionalOutcome: 'A working RAG demo you can show in an interview or portfolio.',
    ),
    GoalTemplate(
      id: 'ai_e_06',
      title: 'Fine-tune a small model on custom data',
      description: 'Use LoRA or full fine-tuning on a 7B parameter model',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: ['ai_engineer'],
      minLevel: 6,
      minPhase: 2,
      skill: 'Fine-tuning',
      stage: GoalStage.realProjects,
      estimatedMinutes: 120,
      professionalOutcome: 'A fine-tuned model checkpoint with before/after eval results.',
    ),
    GoalTemplate(
      id: 'ai_e_07',
      title: 'Benchmark two different LLM prompting strategies',
      description: 'Compare zero-shot vs few-shot on a task and record results',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['ai_engineer'],
      minLevel: 3,
      skill: 'Prompt Engineering',
      stage: GoalStage.practice,
      estimatedMinutes: 40,
    ),
    GoalTemplate(
      id: 'ai_e_08',
      title: 'Set up a local LLM with Ollama',
      description: 'Install Ollama and run llama3 or mistral locally',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['ai_engineer'],
      skill: 'Local Inference',
      stage: GoalStage.coreSkills,
      estimatedMinutes: 30,
    ),
    GoalTemplate(
      id: 'ai_e_09',
      title: 'Build a prompt template system',
      description: 'Create a reusable prompt template with variable substitution',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: ['ai_engineer'],
      minLevel: 2,
      skill: 'Prompt Engineering',
      stage: GoalStage.coreSkills,
      estimatedMinutes: 35,
    ),
    GoalTemplate(
      id: 'ai_e_10',
      title: 'Deploy an AI model to a REST API',
      description: 'Wrap a model with FastAPI or Flask and test it with Postman',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['ai_engineer'],
      minLevel: 4,
      minPhase: 1,
      skill: 'Model Deployment',
      stage: GoalStage.deployment,
      estimatedMinutes: 75,
      professionalOutcome: 'A live, callable API endpoint serving real predictions.',
    ),
    GoalTemplate(
      id: 'ai_e_11',
      title: 'Study transformer attention mechanism',
      description: 'Read and understand the "Attention is All You Need" paper concepts',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.learning,
      tags: ['ai_engineer'],
      skill: 'Transformers',
      stage: GoalStage.foundation,
      estimatedMinutes: 40,
    ),
    GoalTemplate(
      id: 'ai_e_12',
      title: 'Implement vector similarity search',
      description: 'Build a semantic search using sentence-transformers and cosine similarity',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.coding,
      tags: ['ai_engineer'],
      minLevel: 4,
      skill: 'Vector Search',
      stage: GoalStage.realProjects,
      estimatedMinutes: 70,
    ),
    GoalTemplate(
      id: 'ai_e_13',
      title: 'Write unit tests for an LLM wrapper function',
      description: 'Mock the LLM call and test retry logic, parsing, and edge cases',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['ai_engineer'],
      minLevel: 2,
      skill: 'Testing',
      stage: GoalStage.testing,
      estimatedMinutes: 30,
      prerequisites: ['ai_e_04'],
    ),
    GoalTemplate(
      id: 'ai_e_14',
      title: 'Add retry and error handling for a flaky LLM API call',
      description: 'Implement exponential backoff and graceful fallback on API failure',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: ['ai_engineer'],
      minLevel: 3,
      skill: 'Reliability Engineering',
      stage: GoalStage.debugging,
      estimatedMinutes: 30,
    ),
    GoalTemplate(
      id: 'ai_e_15',
      title: 'Design a system architecture diagram for a RAG application',
      description: 'Sketch ingestion, embedding, storage, retrieval, and generation components',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.design,
      tags: ['ai_engineer'],
      minLevel: 4,
      skill: 'System Design',
      stage: GoalStage.architecture,
      estimatedMinutes: 45,
      prerequisites: ['ai_e_05'],
    ),
    GoalTemplate(
      id: 'ai_e_16',
      title: 'Secure API keys with environment variables and a secrets manager',
      description: 'Move hard-coded keys out of code and into env vars / a vault',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.practice,
      tags: ['ai_engineer'],
      minLevel: 2,
      skill: 'Security',
      stage: GoalStage.security,
      estimatedMinutes: 20,
    ),
    GoalTemplate(
      id: 'ai_e_17',
      title: 'Containerize an LLM service with Docker',
      description: 'Write a Dockerfile for your FastAPI/LLM service and run it as a container',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['ai_engineer'],
      minLevel: 4,
      skill: 'Docker',
      stage: GoalStage.dockerCloud,
      estimatedMinutes: 60,
      prerequisites: ['ai_e_10'],
    ),
    GoalTemplate(
      id: 'ai_e_18',
      title: 'Set up CI to lint and test an AI service on every push',
      description: 'Add a GitHub Actions workflow running pytest + flake8/ruff on push',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['ai_engineer'],
      minLevel: 4,
      minPhase: 1,
      skill: 'CI/CD',
      stage: GoalStage.ciCd,
      estimatedMinutes: 50,
    ),
    GoalTemplate(
      id: 'ai_e_19',
      title: 'Add structured logging and monitoring to a deployed model endpoint',
      description: 'Log latency, errors and token usage; surface them in a simple dashboard',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['ai_engineer'],
      minLevel: 5,
      skill: 'Observability',
      stage: GoalStage.production,
      estimatedMinutes: 60,
    ),
    GoalTemplate(
      id: 'ai_e_20',
      title: 'Publish your RAG or LLM project on GitHub with a professional README',
      description: 'Include setup steps, architecture diagram, and example usage',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.career,
      tags: ['ai_engineer'],
      minLevel: 3,
      skill: 'Portfolio Building',
      stage: GoalStage.portfolio,
      estimatedMinutes: 40,
      professionalOutcome: 'A public, well-documented repo you can link on your resume.',
    ),
    GoalTemplate(
      id: 'ai_e_21',
      title: 'Prepare answers for 5 common AI engineer interview questions',
      description: 'Practice explaining RAG, fine-tuning vs prompting, and evaluation trade-offs',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.career,
      tags: ['ai_engineer'],
      minLevel: 3,
      skill: 'Interview Prep',
      stage: GoalStage.interview,
      estimatedMinutes: 35,
    ),
  ];

  // ════════════════════════════════════════════════════════════════════
  // ML ENGINEER GOALS
  // ════════════════════════════════════════════════════════════════════
  static const List<GoalTemplate> _mlEngineerDaily = [
    GoalTemplate(
      id: 'ml_e_01',
      title: 'Study a neural network architecture',
      description: 'Learn about ResNet, EfficientNet, or ViT in 20 minutes',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.learning,
      tags: ['ml_engineer'],
      skill: 'Neural Networks',
      stage: GoalStage.foundation,
      estimatedMinutes: 20,
    ),
    GoalTemplate(
      id: 'ml_e_02',
      title: 'Implement backpropagation from scratch',
      description: 'Write a simple neural network with manual gradient computation in NumPy',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['ml_engineer'],
      skill: 'Neural Networks',
      stage: GoalStage.coreSkills,
      estimatedMinutes: 45,
    ),
    GoalTemplate(
      id: 'ml_m_01',
      title: 'Train a CNN on CIFAR-10',
      description: 'Build and train a convolutional neural network in PyTorch or TensorFlow',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['ml_engineer'],
      skill: 'Deep Learning',
      stage: GoalStage.practice,
      estimatedMinutes: 60,
    ),
    GoalTemplate(
      id: 'ml_m_02',
      title: 'Implement model quantization',
      description: 'Apply INT8 quantization to a trained model and compare performance',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: ['ml_engineer'],
      minLevel: 4,
      skill: 'Model Optimisation',
      stage: GoalStage.practice,
      estimatedMinutes: 45,
    ),
    GoalTemplate(
      id: 'ml_h_01',
      title: 'Set up a model training pipeline with MLflow',
      description: 'Track experiments, parameters and metrics with MLflow',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: ['ml_engineer'],
      minLevel: 4,
      skill: 'MLOps',
      stage: GoalStage.realProjects,
      estimatedMinutes: 75,
    ),
    GoalTemplate(
      id: 'ml_h_02',
      title: 'Deploy a model to TensorFlow Serving',
      description: 'Serve a SavedModel with TensorFlow Serving via Docker',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['ml_engineer'],
      minLevel: 5,
      skill: 'Model Deployment',
      stage: GoalStage.deployment,
      estimatedMinutes: 75,
    ),
    GoalTemplate(
      id: 'ml_e_03',
      title: 'Write unit tests for a data preprocessing function',
      description: 'Cover empty input, malformed rows, and expected-shape assertions',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['ml_engineer'],
      minLevel: 2,
      skill: 'Testing',
      stage: GoalStage.testing,
      estimatedMinutes: 30,
    ),
    GoalTemplate(
      id: 'ml_e_04',
      title: 'Version a dataset and model with DVC',
      description: 'Set up Data Version Control so experiments are reproducible',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['ml_engineer'],
      minLevel: 3,
      skill: 'MLOps',
      stage: GoalStage.architecture,
      estimatedMinutes: 40,
    ),
    GoalTemplate(
      id: 'ml_e_05',
      title: 'Containerize a training job with Docker',
      description: 'Write a Dockerfile that reproducibly runs a training script',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['ml_engineer'],
      minLevel: 4,
      skill: 'Docker',
      stage: GoalStage.dockerCloud,
      estimatedMinutes: 55,
    ),
    GoalTemplate(
      id: 'ml_e_06',
      title: 'Set up CI that runs model tests on every commit',
      description: 'GitHub Actions workflow running your model/data unit tests automatically',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['ml_engineer'],
      minLevel: 4,
      skill: 'CI/CD',
      stage: GoalStage.ciCd,
      estimatedMinutes: 45,
      prerequisites: ['ml_e_03'],
    ),
    GoalTemplate(
      id: 'ml_e_07',
      title: 'Add input validation and error handling to a serving endpoint',
      description: 'Reject malformed inputs safely instead of crashing the service',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['ml_engineer'],
      minLevel: 3,
      skill: 'Reliability Engineering',
      stage: GoalStage.security,
      estimatedMinutes: 30,
    ),
    GoalTemplate(
      id: 'ml_e_08',
      title: 'Write a model card documenting performance and limitations',
      description: 'Document intended use, metrics, and known failure modes',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.career,
      tags: ['ml_engineer'],
      minLevel: 3,
      skill: 'Portfolio Building',
      stage: GoalStage.portfolio,
      estimatedMinutes: 35,
    ),
    GoalTemplate(
      id: 'ml_e_09',
      title: 'Prepare for an ML system design interview question',
      description: 'Practice designing a recommendation or fraud-detection system end-to-end',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.career,
      tags: ['ml_engineer'],
      minLevel: 5,
      skill: 'Interview Prep',
      stage: GoalStage.interview,
      estimatedMinutes: 50,
    ),
  ];

  // ════════════════════════════════════════════════════════════════════
  // DATA SCIENTIST GOALS
  // ════════════════════════════════════════════════════════════════════
  static const List<GoalTemplate> _dataScientistDaily = [
    GoalTemplate(
      id: 'ds_e_01',
      title: 'Explore a Kaggle dataset',
      description: 'Download a dataset from Kaggle and run basic EDA in a notebook',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.data,
      tags: ['data_scientist'],
      skill: 'Exploratory Data Analysis',
      stage: GoalStage.foundation,
      estimatedMinutes: 25,
    ),
    GoalTemplate(
      id: 'ds_e_02',
      title: 'Read about a new ML algorithm',
      description: 'Study how one algorithm works: XGBoost, LightGBM, or CatBoost',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.learning,
      tags: ['data_scientist'],
      skill: 'ML Algorithms',
      stage: GoalStage.foundation,
      estimatedMinutes: 20,
    ),
    GoalTemplate(
      id: 'ds_e_03',
      title: 'Create a data visualization',
      description: 'Build 3 meaningful plots from a dataset using matplotlib or seaborn',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.data,
      tags: ['data_scientist'],
      skill: 'Data Visualisation',
      stage: GoalStage.foundation,
      estimatedMinutes: 25,
    ),
    GoalTemplate(
      id: 'ds_e_04',
      title: 'Clean a messy dataset',
      description: 'Handle missing values, outliers and type issues in a CSV dataset',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.data,
      tags: ['data_scientist'],
      skill: 'Data Cleaning',
      stage: GoalStage.coreSkills,
      estimatedMinutes: 35,
    ),
    GoalTemplate(
      id: 'ds_m_01',
      title: 'Train and evaluate a classification model',
      description: 'Train a model with sklearn, compute accuracy, precision, recall, F1',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['data_scientist'],
      skill: 'Model Evaluation',
      stage: GoalStage.practice,
      estimatedMinutes: 40,
    ),
    GoalTemplate(
      id: 'ds_m_02',
      title: 'Perform feature engineering',
      description: 'Create 3 new derived features from an existing dataset',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.data,
      tags: ['data_scientist'],
      skill: 'Feature Engineering',
      stage: GoalStage.practice,
      estimatedMinutes: 35,
    ),
    GoalTemplate(
      id: 'ds_m_03',
      title: 'Run hyperparameter tuning',
      description: 'Use GridSearchCV or Optuna to find optimal model parameters',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['data_scientist'],
      minLevel: 3,
      skill: 'Model Tuning',
      stage: GoalStage.practice,
      estimatedMinutes: 45,
    ),
    GoalTemplate(
      id: 'ds_h_01',
      title: 'Build an end-to-end ML pipeline',
      description: 'Create a pipeline: ingest → clean → feature engineer → train → evaluate',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: ['data_scientist'],
      minLevel: 4,
      skill: 'ML Pipelines',
      stage: GoalStage.realProjects,
      estimatedMinutes: 90,
    ),
    GoalTemplate(
      id: 'ds_h_02',
      title: 'Submit a Kaggle competition entry',
      description: 'Join a Kaggle competition and make your first submission',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.community,
      tags: ['data_scientist'],
      minLevel: 3,
      minPhase: 1,
      skill: 'Competitive Data Science',
      stage: GoalStage.realProjects,
      estimatedMinutes: 90,
    ),
    GoalTemplate(
      id: 'ds_h_03',
      title: 'Deploy a model with Streamlit',
      description: 'Create a Streamlit web app that serves predictions from your model',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['data_scientist'],
      minLevel: 4,
      skill: 'Model Deployment',
      stage: GoalStage.deployment,
      estimatedMinutes: 75,
    ),
    GoalTemplate(
      id: 'ds_e_05',
      title: 'Write unit tests for a data-cleaning function',
      description: 'Assert correct handling of nulls, duplicates and type coercion',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['data_scientist'],
      minLevel: 2,
      skill: 'Testing',
      stage: GoalStage.testing,
      estimatedMinutes: 30,
      prerequisites: ['ds_e_04'],
    ),
    GoalTemplate(
      id: 'ds_e_06',
      title: 'Set up a reproducible analysis environment',
      description: 'Pin dependencies in a requirements.txt or conda environment file',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.practice,
      tags: ['data_scientist'],
      skill: 'Reproducibility',
      stage: GoalStage.foundation,
      estimatedMinutes: 20,
    ),
    GoalTemplate(
      id: 'ds_h_04',
      title: 'Build a data pipeline that runs on a schedule',
      description: 'Use Airflow, Prefect, or cron to automate a recurring ETL job',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.data,
      tags: ['data_scientist'],
      minLevel: 4,
      skill: 'Data Engineering',
      stage: GoalStage.architecture,
      estimatedMinutes: 80,
    ),
    GoalTemplate(
      id: 'ds_h_05',
      title: 'Containerize and deploy a Streamlit/Dash app',
      description: 'Write a Dockerfile and deploy your analytics app to a live URL',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['data_scientist'],
      minLevel: 4,
      skill: 'Docker',
      stage: GoalStage.dockerCloud,
      estimatedMinutes: 60,
      prerequisites: ['ds_h_03'],
    ),
    GoalTemplate(
      id: 'ds_h_06',
      title: 'Write a case study: business question → insight → recommendation',
      description: 'Document one analysis end-to-end as a portfolio-ready case study',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.career,
      tags: ['data_scientist'],
      minLevel: 3,
      skill: 'Portfolio Building',
      stage: GoalStage.portfolio,
      estimatedMinutes: 45,
    ),
    GoalTemplate(
      id: 'ds_e_07',
      title: 'Practice explaining a statistical concept simply',
      description: 'Explain p-values or confidence intervals to someone non-technical',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.career,
      tags: ['data_scientist'],
      skill: 'Interview Prep',
      stage: GoalStage.interview,
      estimatedMinutes: 20,
    ),
  ];

  // ════════════════════════════════════════════════════════════════════
  // NLP ENGINEER GOALS
  // ════════════════════════════════════════════════════════════════════
  static const List<GoalTemplate> _nlpEngineerDaily = [
    GoalTemplate(
      id: 'nlp_e_01',
      title: 'Study a text preprocessing technique',
      description: 'Learn about tokenization, stemming, lemmatization, or stop-word removal',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.learning,
      tags: ['nlp_engineer'],
      skill: 'Text Preprocessing',
      stage: GoalStage.foundation,
      estimatedMinutes: 20,
    ),
    GoalTemplate(
      id: 'nlp_e_02',
      title: 'Fine-tune a BERT model on a classification task',
      description: 'Use HuggingFace Trainer API to fine-tune bert-base on a dataset',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: ['nlp_engineer'],
      minLevel: 4,
      skill: 'Fine-tuning',
      stage: GoalStage.realProjects,
      estimatedMinutes: 90,
    ),
    GoalTemplate(
      id: 'nlp_m_01',
      title: 'Build a text summarizer',
      description: 'Use a pre-trained model to summarize a set of articles',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: ['nlp_engineer'],
      minLevel: 3,
      skill: 'NLP Applications',
      stage: GoalStage.coreSkills,
      estimatedMinutes: 45,
    ),
    GoalTemplate(
      id: 'nlp_e_03',
      title: 'Evaluate a text classifier with a confusion matrix',
      description: 'Compute precision/recall per class and analyse the biggest error types',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['nlp_engineer'],
      minLevel: 2,
      skill: 'Model Evaluation',
      stage: GoalStage.practice,
      estimatedMinutes: 35,
    ),
    GoalTemplate(
      id: 'nlp_m_02',
      title: 'Build a Named Entity Recognition pipeline',
      description: 'Use spaCy or HuggingFace to extract entities from real text',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: ['nlp_engineer'],
      minLevel: 3,
      skill: 'NER',
      stage: GoalStage.coreSkills,
      estimatedMinutes: 45,
    ),
    GoalTemplate(
      id: 'nlp_e_04',
      title: 'Write unit tests for a text-preprocessing pipeline',
      description: 'Cover edge cases: empty strings, unicode, mixed-case, punctuation-only input',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['nlp_engineer'],
      minLevel: 2,
      skill: 'Testing',
      stage: GoalStage.testing,
      estimatedMinutes: 30,
      prerequisites: ['nlp_e_01'],
    ),
    GoalTemplate(
      id: 'nlp_h_01',
      title: 'Deploy a fine-tuned NLP model behind a REST API',
      description: 'Serve your model with FastAPI and test it with real requests',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['nlp_engineer'],
      minLevel: 5,
      skill: 'Model Deployment',
      stage: GoalStage.deployment,
      estimatedMinutes: 75,
      prerequisites: ['nlp_e_02'],
    ),
  ];

  // ════════════════════════════════════════════════════════════════════
  // COMPUTER VISION ENGINEER GOALS (NEW)
  // ════════════════════════════════════════════════════════════════════
  static const List<GoalTemplate> _cvEngineerDaily = [
    GoalTemplate(
      id: 'cv_e_01',
      title: 'Study a CNN architecture',
      description: 'Learn how ResNet, EfficientNet, or Vision Transformers work',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.learning,
      tags: ['cv_engineer'],
      skill: 'CNN Architectures',
      stage: GoalStage.foundation,
      estimatedMinutes: 20,
    ),
    GoalTemplate(
      id: 'cv_e_02',
      title: 'Practice image augmentation techniques',
      description: 'Apply flips, crops, colour jitter with torchvision or albumentations',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.practice,
      tags: ['cv_engineer'],
      skill: 'Data Augmentation',
      stage: GoalStage.foundation,
      estimatedMinutes: 25,
    ),
    GoalTemplate(
      id: 'cv_e_03',
      title: 'Read a computer vision paper abstract',
      description: 'Find a recent paper (e.g. from CVPR/ICCV) and read the abstract',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.reading,
      tags: ['cv_engineer'],
      skill: 'CV Research Literacy',
      stage: GoalStage.foundation,
      estimatedMinutes: 15,
    ),
    GoalTemplate(
      id: 'cv_m_01',
      title: 'Train an image classifier on a small dataset',
      description: 'Build and train a classifier in PyTorch/TensorFlow on a labelled dataset',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['cv_engineer'],
      skill: 'Image Classification',
      stage: GoalStage.coreSkills,
      estimatedMinutes: 60,
    ),
    GoalTemplate(
      id: 'cv_m_02',
      title: 'Implement an object detection model',
      description: 'Run YOLO or a similar detector on a sample image dataset',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: ['cv_engineer'],
      minLevel: 3,
      skill: 'Object Detection',
      stage: GoalStage.practice,
      estimatedMinutes: 60,
    ),
    GoalTemplate(
      id: 'cv_e_04',
      title: 'Write unit tests for an image preprocessing function',
      description: 'Cover resizing, normalisation, and unexpected image formats/sizes',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['cv_engineer'],
      minLevel: 2,
      skill: 'Testing',
      stage: GoalStage.testing,
      estimatedMinutes: 30,
    ),
    GoalTemplate(
      id: 'cv_h_01',
      title: 'Build an annotation → training → evaluation pipeline',
      description: 'Take raw images through labelling, training and metric evaluation',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: ['cv_engineer'],
      minLevel: 4,
      skill: 'CV Pipelines',
      stage: GoalStage.realProjects,
      estimatedMinutes: 100,
    ),
    GoalTemplate(
      id: 'cv_h_02',
      title: 'Deploy a vision model behind a REST API',
      description: 'Accept image uploads and return predictions via FastAPI',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['cv_engineer'],
      minLevel: 5,
      skill: 'Model Deployment',
      stage: GoalStage.deployment,
      estimatedMinutes: 75,
      prerequisites: ['cv_h_01'],
    ),
  ];

  // ════════════════════════════════════════════════════════════════════
  // PROMPT ENGINEER GOALS
  // ════════════════════════════════════════════════════════════════════
  static const List<GoalTemplate> _promptEngineerDaily = [
    GoalTemplate(
      id: 'pe_e_01',
      title: 'Write 5 chain-of-thought prompts',
      description: 'Create prompts that guide a model through step-by-step reasoning',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.practice,
      tags: ['prompt_engineer'],
      skill: 'Prompt Engineering',
      stage: GoalStage.foundation,
      estimatedMinutes: 20,
    ),
    GoalTemplate(
      id: 'pe_e_02',
      title: 'Study few-shot vs zero-shot prompting',
      description: 'Read and compare examples of both prompting strategies',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.learning,
      tags: ['prompt_engineer'],
      skill: 'Prompt Engineering',
      stage: GoalStage.foundation,
      estimatedMinutes: 20,
    ),
    GoalTemplate(
      id: 'pe_m_01',
      title: 'Build a prompt library for a use-case',
      description: 'Create 10 tested, versioned prompts for one domain (e.g. customer support)',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.project,
      tags: ['prompt_engineer'],
      minLevel: 2,
      skill: 'Prompt Engineering',
      stage: GoalStage.coreSkills,
      estimatedMinutes: 45,
    ),
    GoalTemplate(
      id: 'pe_h_01',
      title: 'Create a prompt evaluation framework',
      description: 'Build a script that scores prompt outputs against ground truth answers',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: ['prompt_engineer'],
      minLevel: 4,
      skill: 'Prompt Evaluation',
      stage: GoalStage.realProjects,
      estimatedMinutes: 75,
    ),
    GoalTemplate(
      id: 'pe_e_03',
      title: 'Version and A/B test two prompt variants',
      description: 'Run the same task through two prompt versions and compare outputs',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.practice,
      tags: ['prompt_engineer'],
      skill: 'Prompt Engineering',
      stage: GoalStage.practice,
      estimatedMinutes: 25,
    ),
    GoalTemplate(
      id: 'pe_m_02',
      title: 'Write tests that check prompt outputs against an expected schema',
      description: 'Validate that structured-output prompts reliably return valid JSON',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['prompt_engineer'],
      minLevel: 2,
      skill: 'Testing',
      stage: GoalStage.testing,
      estimatedMinutes: 30,
    ),
    GoalTemplate(
      id: 'pe_h_02',
      title: 'Deploy a prompt-serving API with versioned templates',
      description: 'Serve prompts from a versioned store behind a simple API',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['prompt_engineer'],
      minLevel: 4,
      skill: 'Model Deployment',
      stage: GoalStage.deployment,
      estimatedMinutes: 60,
      prerequisites: ['pe_m_01'],
    ),
  ];

  // ════════════════════════════════════════════════════════════════════
  // AI RESEARCHER GOALS
  // ════════════════════════════════════════════════════════════════════
  static const List<GoalTemplate> _aiResearcherDaily = [
    GoalTemplate(
      id: 'ar_e_01',
      title: 'Read a full AI paper today',
      description: 'Choose a paper from arxiv and read it completely, taking notes',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.reading,
      tags: ['ai_researcher'],
      skill: 'Research Literacy',
      stage: GoalStage.foundation,
      estimatedMinutes: 40,
    ),
    GoalTemplate(
      id: 'ar_m_01',
      title: 'Reproduce a paper result',
      description: 'Implement the main experiment from an ML paper and compare results',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: ['ai_researcher'],
      minLevel: 5,
      skill: 'Research Engineering',
      stage: GoalStage.realProjects,
      estimatedMinutes: 120,
    ),
    GoalTemplate(
      id: 'ar_e_02',
      title: 'Write a paper summary in your own words',
      description: 'Summarize one paper\'s contribution in 200 words without looking at the abstract',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.learning,
      tags: ['ai_researcher'],
      skill: 'Technical Writing',
      stage: GoalStage.foundation,
      estimatedMinutes: 30,
    ),
    GoalTemplate(
      id: 'ar_e_03',
      title: 'Write unit tests for an experiment\'s data loading code',
      description: 'Ensure your dataset loader handles edge cases correctly before a long run',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['ai_researcher'],
      minLevel: 2,
      skill: 'Testing',
      stage: GoalStage.testing,
      estimatedMinutes: 30,
    ),
    GoalTemplate(
      id: 'ar_m_02',
      title: 'Present your reproduced paper result as a short write-up',
      description: 'Document method, results, and any differences from the original paper',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.career,
      tags: ['ai_researcher'],
      minLevel: 4,
      skill: 'Portfolio Building',
      stage: GoalStage.portfolio,
      estimatedMinutes: 40,
      prerequisites: ['ar_m_01'],
    ),
    GoalTemplate(
      id: 'ar_h_01',
      title: 'Write a technical blog post explaining a paper to a general audience',
      description: 'Translate a complex paper into an accessible 500-word explainer',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.community,
      tags: ['ai_researcher'],
      minLevel: 3,
      skill: 'Technical Writing',
      stage: GoalStage.portfolio,
      estimatedMinutes: 50,
    ),
  ];

  // ════════════════════════════════════════════════════════════════════
  // AI PRODUCT MANAGER GOALS
  // ════════════════════════════════════════════════════════════════════
  static const List<GoalTemplate> _aiProductManagerDaily = [
    GoalTemplate(
      id: 'pm_e_01',
      title: 'Analyse an AI product\'s UX',
      description: 'Pick any AI product and write 5 observations about how users interact with it',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.review,
      tags: ['ai_product_manager'],
      skill: 'Product Sense',
      stage: GoalStage.foundation,
      estimatedMinutes: 20,
    ),
    GoalTemplate(
      id: 'pm_e_02',
      title: 'Write a one-page AI feature spec',
      description: 'Define a small AI feature: problem, solution, metrics, and edge cases',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.project,
      tags: ['ai_product_manager'],
      skill: 'Product Specification',
      stage: GoalStage.coreSkills,
      estimatedMinutes: 40,
    ),
    GoalTemplate(
      id: 'pm_m_01',
      title: 'Map an AI product\'s data flywheel',
      description: 'Diagram how a product (e.g. Spotify, Netflix) uses data to improve its AI',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.learning,
      tags: ['ai_product_manager'],
      minLevel: 3,
      skill: 'Product Strategy',
      stage: GoalStage.practice,
      estimatedMinutes: 35,
    ),
    GoalTemplate(
      id: 'pm_e_03',
      title: 'Write 3 user stories with acceptance criteria',
      description: 'Practice writing crisp, testable stories for an AI feature',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.practice,
      tags: ['ai_product_manager'],
      skill: 'Product Specification',
      stage: GoalStage.practice,
      estimatedMinutes: 25,
    ),
    GoalTemplate(
      id: 'pm_m_02',
      title: 'Run a competitive analysis of 3 AI products',
      description: 'Compare positioning, pricing, and core AI capability across competitors',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.review,
      tags: ['ai_product_manager'],
      minLevel: 2,
      skill: 'Market Research',
      stage: GoalStage.practice,
      estimatedMinutes: 40,
    ),
    GoalTemplate(
      id: 'pm_h_01',
      title: 'Present an AI feature roadmap with prioritisation rationale',
      description: 'Use a framework like RICE or ICE to justify what ships first',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: ['ai_product_manager'],
      minLevel: 4,
      skill: 'Prioritisation',
      stage: GoalStage.portfolio,
      estimatedMinutes: 50,
    ),
  ];

  // ════════════════════════════════════════════════════════════════════
  // FLUTTER DEVELOPER GOALS (NEW)
  // ════════════════════════════════════════════════════════════════════
  static const List<GoalTemplate> _flutterDeveloperDaily = [
    GoalTemplate(
      id: 'fl_e_01',
      title: 'Build a stateless and a stateful widget from scratch',
      description: 'Practice the difference by rebuilding the same small UI both ways',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.coding,
      tags: ['flutter_developer'],
      skill: 'Flutter Widgets',
      stage: GoalStage.foundation,
      estimatedMinutes: 25,
    ),
    GoalTemplate(
      id: 'fl_e_02',
      title: 'Practice Flutter layout widgets',
      description: 'Build a sample screen using Row, Column, Stack and Expanded correctly',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.practice,
      tags: ['flutter_developer'],
      skill: 'Flutter Layout',
      stage: GoalStage.foundation,
      estimatedMinutes: 30,
    ),
    GoalTemplate(
      id: 'fl_e_03',
      title: 'Fix a layout overflow bug using Flutter DevTools',
      description: 'Use the widget inspector and layout explorer to diagnose and fix an overflow',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['flutter_developer'],
      minLevel: 2,
      skill: 'Debugging',
      stage: GoalStage.debugging,
      estimatedMinutes: 30,
    ),
    GoalTemplate(
      id: 'fl_m_01',
      title: 'Implement state management with Provider or Riverpod',
      description: 'Refactor a small app from setState to a proper state management solution',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: ['flutter_developer'],
      minLevel: 2,
      skill: 'State Management',
      stage: GoalStage.coreSkills,
      estimatedMinutes: 50,
    ),
    GoalTemplate(
      id: 'fl_m_02',
      title: 'Write widget tests for one screen',
      description: 'Cover the main interactions and expected states of a screen with tests',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['flutter_developer'],
      minLevel: 3,
      skill: 'Testing',
      stage: GoalStage.testing,
      estimatedMinutes: 40,
    ),
    GoalTemplate(
      id: 'fl_m_03',
      title: 'Connect a Flutter app to a REST API',
      description: 'Fetch real data with http/dio and handle loading, error and empty states',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: ['flutter_developer'],
      minLevel: 3,
      skill: 'APIs',
      stage: GoalStage.apisDatabase,
      estimatedMinutes: 45,
    ),
    GoalTemplate(
      id: 'fl_h_01',
      title: 'Set up CI to run Flutter tests and analyze on push',
      description: 'GitHub Actions workflow running `flutter test` and `flutter analyze`',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['flutter_developer'],
      minLevel: 4,
      skill: 'CI/CD',
      stage: GoalStage.ciCd,
      estimatedMinutes: 45,
      prerequisites: ['fl_m_02'],
    ),
    GoalTemplate(
      id: 'fl_h_02',
      title: 'Build and release a signed APK/AAB or iOS build',
      description: 'Configure signing and produce a release build ready for a store',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['flutter_developer'],
      minLevel: 5,
      skill: 'App Release',
      stage: GoalStage.deployment,
      estimatedMinutes: 60,
    ),
    GoalTemplate(
      id: 'fl_h_03',
      title: 'Publish an app update to a store test track',
      description: 'Upload a build to the Play Store internal test track or TestFlight',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['flutter_developer'],
      minLevel: 6,
      skill: 'App Release',
      stage: GoalStage.production,
      estimatedMinutes: 60,
      prerequisites: ['fl_h_02'],
    ),
  ];

  // ════════════════════════════════════════════════════════════════════
  // GENERIC / FALLBACK GOALS (apply to ALL roles)
  // ════════════════════════════════════════════════════════════════════
  static const List<GoalTemplate> _genericDaily = [
    GoalTemplate(
      id: 'gen_e_01',
      title: 'Read a tech article for 15 minutes',
      description: 'Read a post on dev.to, Medium, or a tech blog in your field',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.reading,
      tags: [],
      stage: GoalStage.foundation,
      estimatedMinutes: 15,
    ),
    GoalTemplate(
      id: 'gen_e_02',
      title: 'Review your roadmap progress',
      description: 'Open your learning roadmap and check off what you\'ve completed',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.review,
      tags: [],
      stage: GoalStage.foundation,
      estimatedMinutes: 10,
    ),
    GoalTemplate(
      id: 'gen_e_03',
      title: 'Watch a 10-min tutorial video',
      description: 'Find a short tutorial on YouTube about a skill in your roadmap',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.learning,
      tags: [],
      stage: GoalStage.foundation,
      estimatedMinutes: 10,
    ),
    GoalTemplate(
      id: 'gen_e_04',
      title: 'Connect with one professional',
      description: 'Send a thoughtful LinkedIn connection request to someone in your target role',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.career,
      tags: [],
      skill: 'Networking',
      stage: GoalStage.jobReady,
      estimatedMinutes: 10,
    ),
    GoalTemplate(
      id: 'gen_m_01',
      title: 'Build a small proof-of-concept',
      description: 'Spend 30 minutes experimenting with a technology from your roadmap',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: [],
      stage: GoalStage.practice,
      estimatedMinutes: 30,
    ),
    GoalTemplate(
      id: 'gen_m_02',
      title: 'Update your portfolio or GitHub',
      description: 'Add a README, push new code, or write about a project',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.career,
      tags: [],
      skill: 'Portfolio Building',
      stage: GoalStage.portfolio,
      estimatedMinutes: 30,
    ),
    GoalTemplate(
      id: 'gen_m_03',
      title: 'Teach what you learned',
      description: 'Write a Twitter/LinkedIn post or a short blog explaining one concept',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.community,
      tags: [],
      skill: 'Technical Writing',
      stage: GoalStage.portfolio,
      estimatedMinutes: 30,
    ),
    GoalTemplate(
      id: 'gen_m_04',
      title: 'Mock-interview yourself',
      description: 'Answer 3 common interview questions out loud and time yourself',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.career,
      tags: [],
      minLevel: 3,
      skill: 'Interview Prep',
      stage: GoalStage.interview,
      estimatedMinutes: 25,
    ),
    GoalTemplate(
      id: 'gen_h_01',
      title: 'Complete a side-project milestone',
      description: 'Finish one meaningful feature or section of your personal project',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: [],
      minLevel: 2,
      stage: GoalStage.realProjects,
      estimatedMinutes: 60,
    ),
    GoalTemplate(
      id: 'gen_h_02',
      title: 'Contribute to open source',
      description: 'Find an issue on GitHub and submit a PR or meaningful comment',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.community,
      tags: [],
      minLevel: 4,
      minPhase: 1,
      skill: 'Open Source',
      stage: GoalStage.gitGithub,
      estimatedMinutes: 60,
    ),

    // ── Foundation / Core Skills (universal) ──────────────────────────
    GoalTemplate(
      id: 'gen_found_01',
      title: 'Practice one data structures & algorithms problem',
      description: 'Solve one problem on LeetCode/HackerRank and note the time complexity',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: [],
      skill: 'Data Structures & Algorithms',
      stage: GoalStage.foundation,
      estimatedMinutes: 30,
    ),
    GoalTemplate(
      id: 'gen_found_02',
      title: 'Review the Big-O complexity of code you wrote recently',
      description: 'Pick a function you wrote and analyse its time/space complexity',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.review,
      tags: [],
      skill: 'Data Structures & Algorithms',
      stage: GoalStage.foundation,
      estimatedMinutes: 15,
    ),

    // ── Git/GitHub ──────────────────────────────────────────────────
    GoalTemplate(
      id: 'gen_git_01',
      title: 'Make a clean, atomic commit',
      description: 'Commit one logical change with a clear, conventional commit message',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.practice,
      tags: [],
      skill: 'Git',
      stage: GoalStage.gitGithub,
      estimatedMinutes: 10,
    ),
    GoalTemplate(
      id: 'gen_git_02',
      title: 'Open a pull request and request a code review',
      description: 'Write a clear PR description explaining what changed and why',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: [],
      minLevel: 2,
      skill: 'Git',
      stage: GoalStage.gitGithub,
      estimatedMinutes: 25,
    ),
    GoalTemplate(
      id: 'gen_git_03',
      title: 'Resolve a merge conflict',
      description: 'Practice resolving a merge conflict in a real or sandbox repository',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: [],
      minLevel: 3,
      skill: 'Git',
      stage: GoalStage.gitGithub,
      estimatedMinutes: 25,
    ),
    GoalTemplate(
      id: 'gen_git_04',
      title: 'Write or improve a CONTRIBUTING.md and branch strategy',
      description: 'Document how contributors should branch, commit, and open PRs',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: [],
      minLevel: 4,
      skill: 'Git',
      stage: GoalStage.gitGithub,
      estimatedMinutes: 30,
    ),

    // ── Debugging ──────────────────────────────────────────────────
    GoalTemplate(
      id: 'gen_debug_01',
      title: 'Use a debugger instead of print statements',
      description: 'Set breakpoints and step through code to find a real bug',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: [],
      skill: 'Debugging',
      stage: GoalStage.debugging,
      estimatedMinutes: 30,
    ),
    GoalTemplate(
      id: 'gen_debug_02',
      title: 'Profile a slow function and fix the bottleneck',
      description: 'Use a profiler to find and fix the real performance bottleneck',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: [],
      minLevel: 3,
      skill: 'Performance Optimisation',
      stage: GoalStage.debugging,
      estimatedMinutes: 40,
    ),

    // ── Testing ────────────────────────────────────────────────────
    GoalTemplate(
      id: 'gen_test_01',
      title: 'Write unit tests until you reach meaningful coverage',
      description: 'Pick an untested function and cover its main cases and edge cases',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: [],
      skill: 'Testing',
      stage: GoalStage.testing,
      estimatedMinutes: 35,
    ),
    GoalTemplate(
      id: 'gen_test_02',
      title: 'Write an end-to-end integration test',
      description: 'Test a real workflow across multiple functions/services, not just one unit',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: [],
      minLevel: 3,
      skill: 'Testing',
      stage: GoalStage.testing,
      estimatedMinutes: 40,
    ),
    GoalTemplate(
      id: 'gen_test_03',
      title: 'Generate a test coverage report',
      description: 'Run a coverage tool and identify your weakest-tested module',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.review,
      tags: [],
      minLevel: 4,
      skill: 'Testing',
      stage: GoalStage.testing,
      estimatedMinutes: 25,
    ),

    // ── APIs/Database ──────────────────────────────────────────────
    GoalTemplate(
      id: 'gen_api_01',
      title: 'Design and build a REST endpoint',
      description: 'Include proper status codes, request validation and error responses',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: [],
      skill: 'APIs',
      stage: GoalStage.apisDatabase,
      estimatedMinutes: 40,
    ),
    GoalTemplate(
      id: 'gen_api_02',
      title: 'Write a database schema with proper indexes',
      description: 'Design tables/collections for a real use case with sensible indexing',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: [],
      minLevel: 3,
      skill: 'Databases',
      stage: GoalStage.apisDatabase,
      estimatedMinutes: 35,
    ),
    GoalTemplate(
      id: 'gen_api_03',
      title: 'Add pagination, filtering and rate limiting to an API',
      description: 'Harden an existing endpoint you built for real-world traffic',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.coding,
      tags: [],
      minLevel: 4,
      skill: 'APIs',
      stage: GoalStage.apisDatabase,
      estimatedMinutes: 45,
      prerequisites: ['gen_api_01'],
    ),

    // ── Architecture ───────────────────────────────────────────────
    GoalTemplate(
      id: 'gen_arch_01',
      title: 'Write a one-page system design document',
      description: 'Document the design of a feature you\'re building before coding it',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.design,
      tags: [],
      minLevel: 4,
      skill: 'System Design',
      stage: GoalStage.architecture,
      estimatedMinutes: 35,
    ),
    GoalTemplate(
      id: 'gen_arch_02',
      title: 'Refactor tightly-coupled code into testable components',
      description: 'Break up one function/class that does too much into clean, focused pieces',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: [],
      minLevel: 3,
      skill: 'Software Architecture',
      stage: GoalStage.architecture,
      estimatedMinutes: 40,
    ),

    // ── Security ───────────────────────────────────────────────────
    GoalTemplate(
      id: 'gen_sec_01',
      title: 'Audit a project for hard-coded secrets',
      description: 'Find and move any hard-coded keys/passwords into environment variables',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.review,
      tags: [],
      skill: 'Security',
      stage: GoalStage.security,
      estimatedMinutes: 20,
    ),
    GoalTemplate(
      id: 'gen_sec_02',
      title: 'Apply one OWASP Top 10 mitigation',
      description: 'Add input validation or parameterised queries to prevent injection attacks',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: [],
      minLevel: 3,
      skill: 'Security',
      stage: GoalStage.security,
      estimatedMinutes: 30,
    ),

    // ── CI/CD ──────────────────────────────────────────────────────
    GoalTemplate(
      id: 'gen_cicd_01',
      title: 'Set up a CI pipeline that runs tests on every push',
      description: 'Add a GitHub Actions (or similar) workflow that runs your test suite',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: [],
      minLevel: 3,
      skill: 'CI/CD',
      stage: GoalStage.ciCd,
      estimatedMinutes: 45,
    ),
    GoalTemplate(
      id: 'gen_cicd_02',
      title: 'Add automatic linting/formatting checks to CI',
      description: 'Fail the pipeline if code style or lint rules are violated',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.deployment,
      tags: [],
      minLevel: 3,
      skill: 'CI/CD',
      stage: GoalStage.ciCd,
      estimatedMinutes: 30,
      prerequisites: ['gen_cicd_01'],
    ),

    // ── Docker/Cloud ───────────────────────────────────────────────
    GoalTemplate(
      id: 'gen_cloud_01',
      title: 'Containerize an app with Docker',
      description: 'Write a Dockerfile and run your app from the built image',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.deployment,
      tags: [],
      minLevel: 3,
      skill: 'Docker',
      stage: GoalStage.dockerCloud,
      estimatedMinutes: 40,
    ),
    GoalTemplate(
      id: 'gen_cloud_02',
      title: 'Deploy a small app to a free-tier cloud host',
      description: 'Ship something real to Render, Railway, Fly.io, or similar',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.deployment,
      tags: [],
      minLevel: 3,
      skill: 'Cloud Deployment',
      stage: GoalStage.dockerCloud,
      estimatedMinutes: 45,
    ),

    // ── Production ─────────────────────────────────────────────────
    GoalTemplate(
      id: 'gen_prod_01',
      title: 'Add basic monitoring or structured logs to a deployed app',
      description: 'Make it possible to tell what your app is doing without guessing',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.deployment,
      tags: [],
      minLevel: 4,
      skill: 'Observability',
      stage: GoalStage.production,
      estimatedMinutes: 35,
    ),
    GoalTemplate(
      id: 'gen_prod_02',
      title: 'Write a rollback plan for a deployment you own',
      description: 'Document exactly how you would revert if this deploy broke something',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.review,
      tags: [],
      minLevel: 5,
      skill: 'Production Readiness',
      stage: GoalStage.production,
      estimatedMinutes: 25,
    ),

    // ── Portfolio ──────────────────────────────────────────────────
    GoalTemplate(
      id: 'gen_port_01',
      title: 'Write a case-study write-up of your best project',
      description: 'Document the problem, your approach, and the measurable result',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.career,
      tags: [],
      skill: 'Portfolio Building',
      stage: GoalStage.portfolio,
      estimatedMinutes: 40,
    ),
    GoalTemplate(
      id: 'gen_port_02',
      title: 'Record a 2-minute demo video of a project',
      description: 'Walk through what it does and why it matters, on camera or screen-recorded',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.career,
      tags: [],
      minLevel: 2,
      skill: 'Portfolio Building',
      stage: GoalStage.portfolio,
      estimatedMinutes: 25,
    ),

    // ── Interview ──────────────────────────────────────────────────
    GoalTemplate(
      id: 'gen_int_01',
      title: 'Do a timed mock coding interview question',
      description: 'Solve one problem under a time limit, then review your approach',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.career,
      tags: [],
      minLevel: 3,
      skill: 'Interview Prep',
      stage: GoalStage.interview,
      estimatedMinutes: 35,
    ),
    GoalTemplate(
      id: 'gen_int_02',
      title: 'Practice explaining one of your projects in under 2 minutes',
      description: 'Rehearse a tight, confident project explanation out loud',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.career,
      tags: [],
      minLevel: 2,
      skill: 'Interview Prep',
      stage: GoalStage.interview,
      estimatedMinutes: 15,
    ),
    GoalTemplate(
      id: 'gen_int_03',
      title: 'Do a mock system design interview',
      description: 'Sketch a whiteboard-style answer to a system design prompt',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.career,
      tags: [],
      minLevel: 5,
      skill: 'System Design',
      stage: GoalStage.interview,
      estimatedMinutes: 45,
    ),

    // ── Job Ready ──────────────────────────────────────────────────
    GoalTemplate(
      id: 'gen_job_01',
      title: 'Tailor your resume to one specific job posting',
      description: 'Match your resume\'s language and highlights to a real job description',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.career,
      tags: [],
      minLevel: 3,
      skill: 'Resume Writing',
      stage: GoalStage.jobReady,
      estimatedMinutes: 30,
    ),
    GoalTemplate(
      id: 'gen_job_02',
      title: 'Apply to one role that matches your target career',
      description: 'Submit a real, tailored application — not a mass-apply',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.career,
      tags: [],
      minLevel: 4,
      minPhase: 1,
      skill: 'Job Applications',
      stage: GoalStage.jobReady,
      estimatedMinutes: 30,
      prerequisites: ['gen_job_01'],
    ),
    GoalTemplate(
      id: 'gen_job_03',
      title: 'Act on feedback from a rejected application or interview',
      description: 'Identify one concrete gap and turn it into a goal for this week',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.review,
      tags: [],
      minLevel: 4,
      skill: 'Career Growth',
      stage: GoalStage.jobReady,
      estimatedMinutes: 20,
    ),
  ];

  // ════════════════════════════════════════════════════════════════════
  // WEEKLY GOALS
  // ════════════════════════════════════════════════════════════════════
  static const List<GoalTemplate> _weeklyGeneric = [
    GoalTemplate(
      id: 'gen_w_01',
      title: 'Complete your weekly learning chapter',
      description: 'Finish the study material scheduled for this week in your roadmap',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.learning,
      tags: [],
      stage: GoalStage.coreSkills,
      estimatedMinutes: 180,
    ),
    GoalTemplate(
      id: 'gen_w_02',
      title: 'Add a project to your portfolio',
      description: 'Document and showcase one project from this week\'s work',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.career,
      tags: [],
      minLevel: 2,
      skill: 'Portfolio Building',
      stage: GoalStage.portfolio,
      estimatedMinutes: 90,
    ),
    GoalTemplate(
      id: 'gen_w_03',
      title: 'Build and evaluate an AI mini-project',
      description: 'Complete a small AI project: define problem, build, evaluate, document',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: [],
      stage: GoalStage.realProjects,
      estimatedMinutes: 180,
    ),
    GoalTemplate(
      id: 'gen_w_04',
      title: 'Write a technical blog post',
      description: 'Explain an AI/ML concept or project in a 500-word post',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.community,
      tags: [],
      minLevel: 3,
      skill: 'Technical Writing',
      stage: GoalStage.portfolio,
      estimatedMinutes: 90,
    ),
    GoalTemplate(
      id: 'gen_w_05',
      title: 'Complete a full EDA notebook',
      description: 'Exploratory data analysis with visualizations, stats and insights',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.data,
      tags: [],
      stage: GoalStage.practice,
      estimatedMinutes: 150,
    ),
    GoalTemplate(
      id: 'gen_w_06',
      title: 'Ship one fully tested feature end-to-end',
      description: 'Code, test, and merge a PR for one real feature this week',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.practice,
      tags: [],
      minLevel: 3,
      skill: 'Testing',
      stage: GoalStage.testing,
      estimatedMinutes: 180,
      professionalOutcome: 'A merged PR with passing tests — real shipped work.',
    ),
    GoalTemplate(
      id: 'gen_w_07',
      title: 'Set up or improve a CI pipeline for one of your projects',
      description: 'Ensure tests, lint, and build run automatically on every push',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: [],
      minLevel: 3,
      skill: 'CI/CD',
      stage: GoalStage.ciCd,
      estimatedMinutes: 90,
    ),
    GoalTemplate(
      id: 'gen_w_08',
      title: 'Containerize and deploy a project to a live URL',
      description: 'Take one project from local-only to publicly accessible',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: [],
      minLevel: 3,
      skill: 'Docker',
      stage: GoalStage.dockerCloud,
      estimatedMinutes: 150,
      professionalOutcome: 'A live URL you can put directly on your resume.',
    ),
    GoalTemplate(
      id: 'gen_w_09',
      title: 'Do 2 mock interviews and log feedback',
      description: 'One technical, one behavioural — write down what to improve',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.career,
      tags: [],
      minLevel: 3,
      skill: 'Interview Prep',
      stage: GoalStage.interview,
      estimatedMinutes: 90,
    ),
  ];

  // ════════════════════════════════════════════════════════════════════
  // MONTHLY GOALS
  // ════════════════════════════════════════════════════════════════════
  static const List<GoalTemplate> _monthlyGeneric = [
    GoalTemplate(
      id: 'gen_mo_01',
      title: 'Publish an AI project on GitHub',
      description: 'Complete, document and publish an AI project with a strong README',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: [],
      minLevel: 3,
      skill: 'Portfolio Building',
      stage: GoalStage.portfolio,
      estimatedMinutes: 600,
    ),
    GoalTemplate(
      id: 'gen_mo_02',
      title: 'Complete your current roadmap phase',
      description: 'Finish all learning objectives in your current roadmap phase this month',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.learning,
      tags: [],
      stage: GoalStage.coreSkills,
      estimatedMinutes: 720,
    ),
    GoalTemplate(
      id: 'gen_mo_03',
      title: 'Apply to 3 target roles',
      description: 'Research and apply to 3 relevant job postings',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.career,
      tags: [],
      minLevel: 5,
      minPhase: 2,
      skill: 'Job Applications',
      stage: GoalStage.jobReady,
      estimatedMinutes: 180,
    ),
    GoalTemplate(
      id: 'gen_mo_04',
      title: 'Complete a Udemy/Coursera course module',
      description: 'Finish a structured online course section relevant to your target role',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.learning,
      tags: [],
      stage: GoalStage.coreSkills,
      estimatedMinutes: 480,
    ),
    GoalTemplate(
      id: 'gen_mo_05',
      title: 'Ship a production-grade capstone project',
      description: 'Tested, CI/CD-backed, and deployed to a live URL — your strongest proof of skill',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: [],
      minLevel: 4,
      skill: 'Portfolio Building',
      stage: GoalStage.production,
      estimatedMinutes: 1200,
      professionalOutcome: 'A deployed, tested, documented capstone project for your resume.',
    ),
    GoalTemplate(
      id: 'gen_mo_06',
      title: 'Complete 4 mock interviews and iterate on weak areas',
      description: '2 technical, 2 behavioural — track and close your recurring gaps',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.career,
      tags: [],
      minLevel: 4,
      skill: 'Interview Prep',
      stage: GoalStage.interview,
      estimatedMinutes: 240,
    ),
    GoalTemplate(
      id: 'gen_mo_07',
      title: 'Get your resume/portfolio reviewed and apply the feedback',
      description: 'Ask a peer or mentor for honest feedback, then actually update both',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.career,
      tags: [],
      minLevel: 3,
      skill: 'Resume Writing',
      stage: GoalStage.jobReady,
      estimatedMinutes: 120,
    ),
  ];

  // ════════════════════════════════════════════════════════════════════
  // PUBLIC ACCESSORS
  // ════════════════════════════════════════════════════════════════════

  static List<GoalTemplate> dailyForRole(String rawRole) {
    final role = normaliseRole(rawRole);
    final roleSpecific = _dailyByRole[role] ?? [];
    return [...roleSpecific, ..._genericDaily];
  }

  static List<GoalTemplate> weeklyForRole(String rawRole) {
    return _weeklyGeneric;
  }

  static List<GoalTemplate> monthlyForRole(String rawRole) {
    return _monthlyGeneric;
  }

  static const Map<String, List<GoalTemplate>> _dailyByRole = {
    'ai_engineer':        _aiEngineerDaily,
    'ml_engineer':        _mlEngineerDaily,
    'data_scientist':     _dataScientistDaily,
    'nlp_engineer':       _nlpEngineerDaily,
    'cv_engineer':        _cvEngineerDaily,
    'prompt_engineer':    _promptEngineerDaily,
    'ai_researcher':      _aiResearcherDaily,
    'ai_product_manager': _aiProductManagerDaily,
    'flutter_developer':  _flutterDeveloperDaily,
    'generic':            _genericDaily,
  };
}