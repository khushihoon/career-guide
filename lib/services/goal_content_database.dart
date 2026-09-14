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

  const GoalTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.category,
    this.tags = const [],
    this.minLevel = 1,
    this.minPhase = 0,
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
    ),
    GoalTemplate(
      id: 'ai_e_02',
      title: 'Study a new LLM concept',
      description: 'Learn about one concept: RAG, fine-tuning, embeddings, or quantization',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.learning,
      tags: ['ai_engineer'],
    ),
    GoalTemplate(
      id: 'ai_e_03',
      title: 'Explore one HuggingFace model card',
      description: 'Study a model card on huggingface.co — architecture, training, use-cases',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.learning,
      tags: ['ai_engineer'],
    ),
    GoalTemplate(
      id: 'ai_e_04',
      title: 'Write a Python script using an LLM library',
      description: 'Write a script using transformers, langchain, or llama-index',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: ['ai_engineer'],
    ),
    GoalTemplate(
      id: 'ai_e_05',
      title: 'Implement a RAG pipeline',
      description: 'Build a simple retrieval-augmented generation pipeline with FAISS',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: ['ai_engineer'],
      minLevel: 4,
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
    ),
    GoalTemplate(
      id: 'ai_e_07',
      title: 'Benchmark two different LLM prompting strategies',
      description: 'Compare zero-shot vs few-shot on a task and record results',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['ai_engineer'],
      minLevel: 3,
    ),
    GoalTemplate(
      id: 'ai_e_08',
      title: 'Set up a local LLM with Ollama',
      description: 'Install Ollama and run llama3 or mistral locally',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['ai_engineer'],
    ),
    GoalTemplate(
      id: 'ai_e_09',
      title: 'Build a prompt template system',
      description: 'Create a reusable prompt template with variable substitution',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: ['ai_engineer'],
      minLevel: 2,
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
    ),
    GoalTemplate(
      id: 'ai_e_11',
      title: 'Study transformer attention mechanism',
      description: 'Read and understand the "Attention is All You Need" paper concepts',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.learning,
      tags: ['ai_engineer'],
    ),
    GoalTemplate(
      id: 'ai_e_12',
      title: 'Implement vector similarity search',
      description: 'Build a semantic search using sentence-transformers and cosine similarity',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.coding,
      tags: ['ai_engineer'],
      minLevel: 4,
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
    ),
    GoalTemplate(
      id: 'ml_e_02',
      title: 'Implement backpropagation from scratch',
      description: 'Write a simple neural network with manual gradient computation in NumPy',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['ml_engineer'],
    ),
    GoalTemplate(
      id: 'ml_m_01',
      title: 'Train a CNN on CIFAR-10',
      description: 'Build and train a convolutional neural network in PyTorch or TensorFlow',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['ml_engineer'],
    ),
    GoalTemplate(
      id: 'ml_m_02',
      title: 'Implement model quantization',
      description: 'Apply INT8 quantization to a trained model and compare performance',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: ['ml_engineer'],
      minLevel: 4,
    ),
    GoalTemplate(
      id: 'ml_h_01',
      title: 'Set up a model training pipeline with MLflow',
      description: 'Track experiments, parameters and metrics with MLflow',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: ['ml_engineer'],
      minLevel: 4,
    ),
    GoalTemplate(
      id: 'ml_h_02',
      title: 'Deploy a model to TensorFlow Serving',
      description: 'Serve a SavedModel with TensorFlow Serving via Docker',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['ml_engineer'],
      minLevel: 5,
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
    ),
    GoalTemplate(
      id: 'ds_e_02',
      title: 'Read about a new ML algorithm',
      description: 'Study how one algorithm works: XGBoost, LightGBM, or CatBoost',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.learning,
      tags: ['data_scientist'],
    ),
    GoalTemplate(
      id: 'ds_e_03',
      title: 'Create a data visualization',
      description: 'Build 3 meaningful plots from a dataset using matplotlib or seaborn',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.data,
      tags: ['data_scientist'],
    ),
    GoalTemplate(
      id: 'ds_e_04',
      title: 'Clean a messy dataset',
      description: 'Handle missing values, outliers and type issues in a CSV dataset',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.data,
      tags: ['data_scientist'],
    ),
    GoalTemplate(
      id: 'ds_m_01',
      title: 'Train and evaluate a classification model',
      description: 'Train a model with sklearn, compute accuracy, precision, recall, F1',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['data_scientist'],
    ),
    GoalTemplate(
      id: 'ds_m_02',
      title: 'Perform feature engineering',
      description: 'Create 3 new derived features from an existing dataset',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.data,
      tags: ['data_scientist'],
    ),
    GoalTemplate(
      id: 'ds_m_03',
      title: 'Run hyperparameter tuning',
      description: 'Use GridSearchCV or Optuna to find optimal model parameters',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: ['data_scientist'],
      minLevel: 3,
    ),
    GoalTemplate(
      id: 'ds_h_01',
      title: 'Build an end-to-end ML pipeline',
      description: 'Create a pipeline: ingest → clean → feature engineer → train → evaluate',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: ['data_scientist'],
      minLevel: 4,
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
    ),
    GoalTemplate(
      id: 'ds_h_03',
      title: 'Deploy a model with Streamlit',
      description: 'Create a Streamlit web app that serves predictions from your model',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.deployment,
      tags: ['data_scientist'],
      minLevel: 4,
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
    ),
    GoalTemplate(
      id: 'nlp_e_02',
      title: 'Fine-tune a BERT model on a classification task',
      description: 'Use HuggingFace Trainer API to fine-tune bert-base on a dataset',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: ['nlp_engineer'],
      minLevel: 4,
    ),
    GoalTemplate(
      id: 'nlp_m_01',
      title: 'Build a text summarizer',
      description: 'Use a pre-trained model to summarize a set of articles',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.coding,
      tags: ['nlp_engineer'],
      minLevel: 3,
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
    ),
    GoalTemplate(
      id: 'pe_e_02',
      title: 'Study few-shot vs zero-shot prompting',
      description: 'Read and compare examples of both prompting strategies',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.learning,
      tags: ['prompt_engineer'],
    ),
    GoalTemplate(
      id: 'pe_m_01',
      title: 'Build a prompt library for a use-case',
      description: 'Create 10 tested, versioned prompts for one domain (e.g. customer support)',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.project,
      tags: ['prompt_engineer'],
      minLevel: 2,
    ),
    GoalTemplate(
      id: 'pe_h_01',
      title: 'Create a prompt evaluation framework',
      description: 'Build a script that scores prompt outputs against ground truth answers',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: ['prompt_engineer'],
      minLevel: 4,
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
    ),
    GoalTemplate(
      id: 'ar_m_01',
      title: 'Reproduce a paper result',
      description: 'Implement the main experiment from an ML paper and compare results',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: ['ai_researcher'],
      minLevel: 5,
    ),
    GoalTemplate(
      id: 'ar_e_02',
      title: 'Write a paper summary in your own words',
      description: 'Summarize one paper\'s contribution in 200 words without looking at the abstract',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.learning,
      tags: ['ai_researcher'],
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
    ),
    GoalTemplate(
      id: 'pm_e_02',
      title: 'Write a one-page AI feature spec',
      description: 'Define a small AI feature: problem, solution, metrics, and edge cases',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.project,
      tags: ['ai_product_manager'],
    ),
    GoalTemplate(
      id: 'pm_m_01',
      title: 'Map an AI product\'s data flywheel',
      description: 'Diagram how a product (e.g. Spotify, Netflix) uses data to improve its AI',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.learning,
      tags: ['ai_product_manager'],
      minLevel: 3,
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
    ),
    GoalTemplate(
      id: 'gen_e_02',
      title: 'Review your roadmap progress',
      description: 'Open your learning roadmap and check off what you\'ve completed',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.review,
      tags: [],
    ),
    GoalTemplate(
      id: 'gen_e_03',
      title: 'Watch a 10-min tutorial video',
      description: 'Find a short tutorial on YouTube about a skill in your roadmap',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.learning,
      tags: [],
    ),
    GoalTemplate(
      id: 'gen_e_04',
      title: 'Connect with one professional',
      description: 'Send a thoughtful LinkedIn connection request to someone in your target role',
      difficulty: LocalGoalDifficulty.easy,
      category: LocalGoalCategory.career,
      tags: [],
    ),
    GoalTemplate(
      id: 'gen_m_01',
      title: 'Build a small proof-of-concept',
      description: 'Spend 30 minutes experimenting with a technology from your roadmap',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.practice,
      tags: [],
    ),
    GoalTemplate(
      id: 'gen_m_02',
      title: 'Update your portfolio or GitHub',
      description: 'Add a README, push new code, or write about a project',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.career,
      tags: [],
    ),
    GoalTemplate(
      id: 'gen_m_03',
      title: 'Teach what you learned',
      description: 'Write a Twitter/LinkedIn post or a short blog explaining one concept',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.community,
      tags: [],
    ),
    GoalTemplate(
      id: 'gen_m_04',
      title: 'Mock-interview yourself',
      description: 'Answer 3 common interview questions out loud and time yourself',
      difficulty: LocalGoalDifficulty.medium,
      category: LocalGoalCategory.career,
      tags: [],
      minLevel: 3,
    ),
    GoalTemplate(
      id: 'gen_h_01',
      title: 'Complete a side-project milestone',
      description: 'Finish one meaningful feature or section of your personal project',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: [],
      minLevel: 2,
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
    ),
    GoalTemplate(
      id: 'gen_w_02',
      title: 'Add a project to your portfolio',
      description: 'Document and showcase one project from this week\'s work',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.career,
      tags: [],
      minLevel: 2,
    ),
    GoalTemplate(
      id: 'gen_w_03',
      title: 'Build and evaluate an AI mini-project',
      description: 'Complete a small AI project: define problem, build, evaluate, document',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.project,
      tags: [],
    ),
    GoalTemplate(
      id: 'gen_w_04',
      title: 'Write a technical blog post',
      description: 'Explain an AI/ML concept or project in a 500-word post',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.community,
      tags: [],
      minLevel: 3,
    ),
    GoalTemplate(
      id: 'gen_w_05',
      title: 'Complete a full EDA notebook',
      description: 'Exploratory data analysis with visualizations, stats and insights',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.data,
      tags: [],
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
    ),
    GoalTemplate(
      id: 'gen_mo_02',
      title: 'Complete your current roadmap phase',
      description: 'Finish all learning objectives in your current roadmap phase this month',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.learning,
      tags: [],
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
    ),
    GoalTemplate(
      id: 'gen_mo_04',
      title: 'Complete a Udemy/Coursera course module',
      description: 'Finish a structured online course section relevant to your target role',
      difficulty: LocalGoalDifficulty.hard,
      category: LocalGoalCategory.learning,
      tags: [],
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
    'prompt_engineer':    _promptEngineerDaily,
    'ai_researcher':      _aiResearcherDaily,
    'ai_product_manager': _aiProductManagerDaily,
    'generic':            _genericDaily,
  };
}