// ══════════════════════════════════════════════════════════════════════
// lib/screens/roadmap_screen.dart
//
// International-grade AI Career Roadmap:
//  • 15 realistic learning phases (Beginner → World-class)
//  • Each phase: topics, tools, project, estimated duration, salary unlock
//  • Salary chart with global + India data
//  • 100 AI job roles browser (pulled from kJobs, grouped by category)
//  • Progress persisted via SharedPreferences
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'jobdetails_screen.dart';
import 'career_roadmap_hub.dart'; // multi-career hub
import '../widgets/resource_card.dart'; // ← interactive resource cards

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen>
    with SingleTickerProviderStateMixin {
  // ── Design tokens ───────────────────────────────────────────────────
  static const _bg = Color(0xFF0F0F1A);
  static const _surface = Color(0xFF1A1A2E);
  static const _border = Color(0xFF2A2A40);
  static const _primary = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted = Color(0xFF888899);

  late TabController _tabController;
  late List<_Phase> _phases;

  // Jobs tab search
  final _searchCtrl = TextEditingController();
  String _jobSearch = '';
  String _jobCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _phases = _buildPhases();
    _loadProgress();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Persistence ─────────────────────────────────────────────────────
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (final p in _phases) {
        p.isDone = prefs.getBool('phase_v2_${p.id}') ?? false;
      }
    });
  }

  Future<void> _togglePhase(_Phase phase) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => phase.isDone = !phase.isDone);
    await prefs.setBool('phase_v2_${phase.id}', phase.isDone);
  }

  int get _doneCount => _phases.where((p) => p.isDone).length;
  double get _progress => _doneCount / _phases.length;

  // ── Filtered jobs ────────────────────────────────────────────────────
  List<Job> get _filteredJobs {
    return kJobs.where((j) {
      final matchSearch = _jobSearch.isEmpty ||
          j.title.toLowerCase().contains(_jobSearch.toLowerCase()) ||
          j.company.toLowerCase().contains(_jobSearch.toLowerCase()) ||
          j.skills
              .any((s) => s.toLowerCase().contains(_jobSearch.toLowerCase()));
      final matchCat = _jobCategory == 'All' ||
          j.title.toLowerCase().contains(_jobCategory.toLowerCase()) ||
          j.skills
              .any((s) => s.toLowerCase().contains(_jobCategory.toLowerCase()));
      return matchSearch && matchCat;
    }).toList();
  }

  static const _jobCategories = [
    'All',
    'Engineer',
    'Scientist',
    'NLP',
    'Vision',
    'Research',
    'Manager',
    'MLOps',
    'LLM',
    'Robotics',
  ];

  // ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(child: _buildHeader()),
          ],
          body: Column(
            children: [
              // ── Tab bar ──
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _border),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: _primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: _muted,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: '🗺️ Roadmap'),
                    Tab(text: '💰 Salaries'),
                    Tab(text: '💼 100 Jobs'),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildRoadmapTab(),
                    _buildSalariesTab(),
                    _buildJobsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title row ──────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'AI Career Roadmap 🗺️',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$_doneCount / ${_phases.length} phases · ${(_progress * 100).toInt()}% complete',
            style: const TextStyle(color: _muted, fontSize: 13),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: _surface,
              valueColor: const AlwaysStoppedAnimation(_primary),
            ),
          ),

          // ── NEW: Browse All Careers Banner ─────────────────────────
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CareerRoadmapHub()),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF7C3AED).withOpacity(0.22),
                    const Color(0xFF06B6D4).withOpacity(0.12),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFF7C3AED).withOpacity(0.4),
                    width: 1.2),
              ),
              child: Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('🗺️', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Browse 46 Career Roadmaps',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Software · AI · Cloud · Security · Design & more',
                        style:
                            TextStyle(color: Color(0xFF888899), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Color(0xFFA78BFA), size: 14),
              ]),
            ),
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // TAB 1 — ROADMAP
  // ════════════════════════════════════════════════════════════════════
  Widget _buildRoadmapTab() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      itemCount: _phases.length,
      separatorBuilder: (_, i) => _buildConnector(_phases[i].isDone),
      itemBuilder: (_, i) {
        return _PhaseCard(
          phase: _phases[i],
          index: i,
          onToggle: () => _togglePhase(_phases[i]),
        ).animate().fadeIn(delay: Duration(milliseconds: i * 40));
      },
    );
  }

  Widget _buildConnector(bool done) {
    return Center(
      child: Container(
        width: 2,
        height: 20,
        color: done ? _primary.withOpacity(0.6) : _border,
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // TAB 2 — SALARIES
  // ════════════════════════════════════════════════════════════════════
  Widget _buildSalariesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _salaryCard(
            title: '🇮🇳 India — Average Annual Salary (LPA)',
            note: 'Source: LinkedIn, Glassdoor, AmbitionBox 2025',
            rows: const [
              _SalRow('Junior ML Engineer', '6–10 LPA', 0.22),
              _SalRow('Data Scientist', '8–15 LPA', 0.32),
              _SalRow('NLP Engineer', '12–20 LPA', 0.42),
              _SalRow('ML Engineer', '15–25 LPA', 0.52),
              _SalRow('Computer Vision Eng', '15–28 LPA', 0.55),
              _SalRow('AI/ML Engineer (5yr)', '25–40 LPA', 0.72),
              _SalRow('Senior AI Engineer', '35–55 LPA', 0.85),
              _SalRow('AI Research Scientist', '40–70 LPA', 0.92),
              _SalRow('Principal AI Scientist', '60–100 LPA', 1.0),
            ],
          ),
          const SizedBox(height: 20),
          _salaryCard(
            title: '🌍 Global — Average Annual Salary (USD)',
            note: 'Source: Levels.fyi, Glassdoor, Blind 2025',
            rows: const [
              _SalRow('Junior ML Engineer', '\$80–110K', 0.28),
              _SalRow('Data Scientist', '\$95–130K', 0.38),
              _SalRow('NLP Engineer', '\$110–150K', 0.50),
              _SalRow('ML Engineer (USA)', '\$130–180K', 0.62),
              _SalRow('CV Engineer', '\$130–175K', 0.60),
              _SalRow('AI Engineer (FAANG)', '\$160–220K', 0.76),
              _SalRow('Staff AI Engineer', '\$200–280K', 0.88),
              _SalRow('Principal Scientist', '\$220–320K', 0.94),
              _SalRow('AI Research Lead', '\$250–400K+', 1.0),
            ],
          ),
          const SizedBox(height: 20),
          _infoCard(
            '💡 Salary Factors',
            [
              'Company tier: FAANG pays 2–3× startups',
              'Location: SF/NYC pay 40% more than remote',
              'Specialisation: LLMs & RL pay a premium in 2025',
              'Kaggle rank / publications add 10–20% to offers',
              'Open source contributions (GitHub stars) matter',
              'Patents and research papers are valued at top labs',
            ],
          ),
          const SizedBox(height: 20),
          _infoCard(
            '📈 Fastest Growing AI Roles (2025)',
            [
              'LLM/Foundation Model Engineer — +65% YoY demand',
              'AI Safety Researcher — +120% YoY (Anthropic, DeepMind)',
              'MLOps / AI Platform Engineer — +80% YoY',
              'Multimodal AI Engineer — +55% YoY',
              'AI Product Manager — +45% YoY',
              'Prompt Engineer / AI Trainer — +200% YoY globally',
            ],
          ),
        ],
      ),
    );
  }

  Widget _salaryCard({
    required String title,
    required String note,
    required List<_SalRow> rows,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(note, style: const TextStyle(color: _muted, fontSize: 11)),
          const SizedBox(height: 14),
          ...rows.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: Text(r.role,
                          style: const TextStyle(color: _muted, fontSize: 11)),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: r.pct,
                          minHeight: 7,
                          backgroundColor: const Color(0xFF0F0F20),
                          valueColor: const AlwaysStoppedAnimation(_primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(r.salary,
                        style: const TextStyle(
                            color: _secondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _infoCard(String title, List<String> bullets) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(color: _secondary, fontSize: 13)),
                    Expanded(
                      child: Text(b,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.4)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // TAB 3 — 100 JOBS
  // ════════════════════════════════════════════════════════════════════
  Widget _buildJobsTab() {
    final jobs = _filteredJobs;

    return Column(
      children: [
        // search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: TextField(
            controller: _searchCtrl,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search jobs, skills, companies…',
              hintStyle: const TextStyle(color: _muted, fontSize: 13),
              prefixIcon: const Icon(Icons.search, color: _muted, size: 20),
              suffixIcon: _jobSearch.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, color: _muted, size: 18),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _jobSearch = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: _surface,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _primary, width: 1.5),
              ),
            ),
            onChanged: (v) => setState(() => _jobSearch = v),
          ),
        ),

        // category chips
        SizedBox(
          height: 36,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: _jobCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cat = _jobCategories[i];
              final sel = _jobCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _jobCategory = cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: sel ? _primary.withOpacity(0.25) : _surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: sel ? _primary : _border, width: sel ? 1.5 : 1),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: sel ? _secondary : _muted,
                      fontSize: 12,
                      fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text('${jobs.length} jobs',
                  style: const TextStyle(color: _muted, fontSize: 12)),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // job list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            itemCount: jobs.length,
            itemBuilder: (ctx, i) {
              return _JobListCard(
                job: jobs[i],
                onTap: () => Navigator.push(
                  ctx,
                  MaterialPageRoute(
                      builder: (_) => JobDetailsScreen(job: jobs[i])),
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: i * 30));
            },
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // PHASE DATA — 15 International-Grade Phases
  // ════════════════════════════════════════════════════════════════════
  List<_Phase> _buildPhases() => [
        _Phase(
          id: 1,
          title: 'Programming Foundations',
          subtitle: 'Python · Git · Terminal',
          duration: '3–4 weeks',
          level: 'Beginner',
          salaryUnlock: '₹3–5 LPA / \$40–60K',
          levelColor: const Color(0xFF6EE7B7),
          topics: [
            'Python syntax, data types, functions, OOP',
            'Virtual environments, pip, requirements.txt',
            'Git & GitHub — commits, branches, PRs',
            'Linux/Mac terminal basics',
            'VS Code + Jupyter Notebook setup',
            'NumPy arrays and vectorised operations',
            'Pandas DataFrames — read, filter, groupby',
          ],
          tools: [
            'Python 3.11+',
            'Git',
            'VS Code',
            'Jupyter',
            'NumPy',
            'Pandas'
          ],
          project: 'Build a Python CLI data analyser on a public CSV dataset',
          resources: [
            '📘 CS50P — Harvard Python (free)',
            '📘 Python.org Official Tutorial',
            '🏋️ LeetCode Easy — 30 problems',
          ],
          isDone: false,
        ),
        _Phase(
          id: 2,
          title: 'Mathematics for AI',
          subtitle: 'Linear Algebra · Calculus · Stats',
          duration: '4–5 weeks',
          level: 'Beginner',
          salaryUnlock: '₹3–6 LPA / \$45–65K',
          levelColor: const Color(0xFF6EE7B7),
          topics: [
            'Vectors, matrices, dot products, eigenvalues',
            'Matrix decompositions: SVD, PCA',
            'Derivatives, chain rule, partial derivatives',
            'Gradient descent — intuition & maths',
            'Probability: distributions, Bayes theorem',
            'Statistics: mean, variance, hypothesis testing',
            'Information theory: entropy, KL divergence',
          ],
          tools: ['Khan Academy', 'NumPy', '3Blue1Brown', 'Matplotlib'],
          project:
              'Implement PCA and visualise MNIST digit clusters from scratch',
          resources: [
            '📘 Mathematics for ML — Deisenroth (free PDF)',
            '🎬 3Blue1Brown Linear Algebra series (YouTube)',
            '📘 StatQuest with Josh Starmer (YouTube)',
          ],
          isDone: false,
        ),
        _Phase(
          id: 3,
          title: 'Machine Learning Fundamentals',
          subtitle: 'Supervised · Unsupervised · Evaluation',
          duration: '6–8 weeks',
          level: 'Beginner–Intermediate',
          salaryUnlock: '₹6–10 LPA / \$70–90K',
          levelColor: const Color(0xFF6EE7B7),
          topics: [
            'Linear & logistic regression (from scratch)',
            'Decision trees, random forests, boosting (XGBoost)',
            'SVMs, k-NN, Naive Bayes',
            'Unsupervised: k-means, DBSCAN, hierarchical clustering',
            'Cross-validation, bias-variance tradeoff',
            'Precision, recall, ROC-AUC, F1 score',
            'Feature engineering and selection',
            'Handling imbalanced datasets (SMOTE)',
            'Hyperparameter tuning: Grid search, Optuna',
          ],
          tools: [
            'Scikit-learn',
            'XGBoost',
            'LightGBM',
            'Matplotlib',
            'Seaborn',
            'Optuna'
          ],
          project: 'Win a Kaggle Playground competition (top 20%)',
          resources: [
            '📘 ML Specialization — Andrew Ng (Coursera)',
            '📘 Hands-On ML — Aurélien Géron (O\'Reilly)',
            '🏆 Kaggle Learn ML course (free)',
          ],
          isDone: false,
        ),
        _Phase(
          id: 4,
          title: 'Data Engineering & Pipelines',
          subtitle: 'SQL · ETL · Cloud Storage',
          duration: '3–4 weeks',
          level: 'Intermediate',
          salaryUnlock: '₹8–14 LPA / \$80–110K',
          levelColor: const Color(0xFF60A5FA),
          topics: [
            'SQL: joins, window functions, CTEs, indexes',
            'PostgreSQL and BigQuery',
            'ETL pipelines with Apache Airflow',
            'Data versioning with DVC',
            'Cloud storage: S3, GCS, Azure Blob',
            'Data validation with Great Expectations',
            'Parquet, Arrow, streaming data basics',
          ],
          tools: [
            'SQL',
            'PostgreSQL',
            'Airflow',
            'DVC',
            'AWS S3',
            'GCS',
            'BigQuery'
          ],
          project: 'Build an automated ML data pipeline with Airflow + S3',
          resources: [
            '📘 Mode SQL Tutorial (free)',
            '📘 Data Engineering Zoomcamp — DataTalks.Club (free)',
          ],
          isDone: false,
        ),
        _Phase(
          id: 5,
          title: 'Deep Learning',
          subtitle: 'Neural Networks · CNNs · RNNs',
          duration: '8–10 weeks',
          level: 'Intermediate',
          salaryUnlock: '₹12–20 LPA / \$100–140K',
          levelColor: const Color(0xFF60A5FA),
          topics: [
            'Feedforward networks — forward & backprop from scratch',
            'Activation functions: ReLU, GELU, Swish',
            'Batch normalisation, dropout, weight init',
            'Optimisers: SGD, Adam, AdamW, Lion',
            'CNNs: ResNet, EfficientNet, MobileNet',
            'RNNs, LSTMs, GRUs — sequence modelling',
            'Transfer learning and fine-tuning',
            'Mixed precision training (fp16/bf16)',
            'Experiment tracking with Weights & Biases',
          ],
          tools: ['PyTorch', 'TensorFlow/Keras', 'W&B', 'CUDA', 'torchvision'],
          project:
              'Train ResNet-50 on custom image dataset, deploy as REST API',
          resources: [
            '📘 Deep Learning Specialization — DeepLearning.AI (Coursera)',
            '📘 fast.ai Practical Deep Learning (free)',
            '📘 d2l.ai — Dive into Deep Learning (free)',
          ],
          isDone: false,
        ),
        _Phase(
          id: 6,
          title: 'Natural Language Processing',
          subtitle: 'Transformers · BERT · Tokenisation',
          duration: '6–8 weeks',
          level: 'Intermediate',
          salaryUnlock: '₹14–22 LPA / \$110–150K',
          levelColor: const Color(0xFF60A5FA),
          topics: [
            'Tokenisation: BPE, WordPiece, SentencePiece',
            'Word embeddings: Word2Vec, GloVe, FastText',
            'Attention mechanism — scaled dot product',
            'Transformer architecture (paper: "Attention Is All You Need")',
            'BERT, RoBERTa — pre-training & fine-tuning',
            'Sequence labelling: NER, POS tagging',
            'Text classification, sentiment analysis',
            'Machine translation, summarisation',
            'HuggingFace Transformers library',
          ],
          tools: [
            'HuggingFace Transformers',
            'spaCy',
            'NLTK',
            'SentenceTransformers'
          ],
          project:
              'Fine-tune BERT for a domain-specific classification task (>90% F1)',
          resources: [
            '📘 HuggingFace NLP Course (free)',
            '📘 Stanford CS224N (lecture videos free)',
            '📘 The Annotated Transformer (Harvard, free)',
          ],
          isDone: false,
        ),
        _Phase(
          id: 7,
          title: 'Computer Vision',
          subtitle: 'Detection · Segmentation · Multimodal',
          duration: '5–6 weeks',
          level: 'Intermediate',
          salaryUnlock: '₹15–25 LPA / \$115–155K',
          levelColor: const Color(0xFF60A5FA),
          topics: [
            'Object detection: YOLO v8/v10, Faster-RCNN',
            'Instance & semantic segmentation: SAM, Mask-RCNN',
            'Image generation: GANs, VAEs fundamentals',
            'Vision Transformers (ViT, DeiT, Swin)',
            'Optical flow and video understanding',
            'Multimodal models: CLIP, BLIP-2, Flamingo',
            'Data augmentation: Albumentations, torchvision',
            'Model deployment: ONNX, TensorRT optimisation',
          ],
          tools: [
            'PyTorch',
            'OpenCV',
            'Ultralytics YOLO',
            'SAM',
            'CLIP',
            'Albumentations'
          ],
          project: 'Build a real-time object detection app with YOLO + FastAPI',
          resources: [
            '📘 fast.ai Part 2 — Deep Learning from the Foundations',
            '📘 Ultralytics YOLO docs',
            '📘 Stanford CS231n (lecture slides/videos free)',
          ],
          isDone: false,
        ),
        _Phase(
          id: 8,
          title: 'Large Language Models',
          subtitle: 'GPT · Fine-tuning · RAG · Agents',
          duration: '8–10 weeks',
          level: 'Intermediate–Advanced',
          salaryUnlock: '₹20–35 LPA / \$140–190K',
          levelColor: const Color(0xFFF59E0B),
          topics: [
            'GPT architecture: decoder-only transformers',
            'Pre-training objectives: next-token prediction',
            'RLHF: reward modelling + PPO fine-tuning',
            'Parameter-efficient fine-tuning: LoRA, QLoRA, DoRA',
            'Quantisation: GPTQ, AWQ, GGUF (llama.cpp)',
            'RAG: embeddings, vector DBs, reranking',
            'LangChain, LlamaIndex — agent orchestration',
            'Function calling / tool use',
            'Evaluation: ROUGE, BERTScore, LLM-as-judge',
            'Prompt engineering patterns: CoT, ReAct, ToT',
          ],
          tools: [
            'OpenAI API',
            'HuggingFace',
            'LangChain',
            'LlamaIndex',
            'Pinecone',
            'ChromaDB',
            'Ollama'
          ],
          project:
              'Build a RAG-powered AI assistant on your own document corpus',
          resources: [
            '📘 Full Stack LLM Bootcamp — LangChain (free)',
            '📘 LLM Course — Maxime Labonne (GitHub, free)',
            '📘 Andrej Karpathy — "Let\'s build GPT" (YouTube)',
          ],
          isDone: false,
        ),
        _Phase(
          id: 9,
          title: 'Generative AI & Diffusion Models',
          subtitle: 'Stable Diffusion · DALL·E · Audio AI',
          duration: '4–5 weeks',
          level: 'Advanced',
          salaryUnlock: '₹22–38 LPA / \$150–200K',
          levelColor: const Color(0xFFF59E0B),
          topics: [
            'Diffusion models: DDPM, DDIM, Score matching',
            'Stable Diffusion architecture (UNet + VAE + CLIP)',
            'Fine-tuning: DreamBooth, LoRA, ControlNet',
            'Text-to-video: Sora, RunwayML concepts',
            'Text-to-audio: MusicGen, AudioCraft',
            'Multimodal generation: GPT-4V, Gemini Vision',
            'Evaluation metrics: FID, CLIP score, IS',
            'ComfyUI, Automatic1111 — practical workflows',
          ],
          tools: [
            'Diffusers (HuggingFace)',
            'ComfyUI',
            'ControlNet',
            'Replicate API'
          ],
          project:
              'Build a fine-tuned image generation pipeline with LoRA + ComfyUI',
          resources: [
            '📘 fast.ai Stable Diffusion from Scratch',
            '📘 HuggingFace Diffusers docs',
            '🎬 Andrej Karpathy — Generative Models talk',
          ],
          isDone: false,
        ),
        _Phase(
          id: 10,
          title: 'Reinforcement Learning',
          subtitle: 'Q-Learning · PPO · RLHF',
          duration: '5–6 weeks',
          level: 'Advanced',
          salaryUnlock: '₹25–45 LPA / \$160–220K',
          levelColor: const Color(0xFFF59E0B),
          topics: [
            'Markov decision processes (MDPs)',
            'Q-learning, Deep Q-Networks (DQN)',
            'Policy gradients: REINFORCE, A2C, A3C',
            'Proximal Policy Optimisation (PPO)',
            'Model-based RL: world models, Dreamer',
            'Multi-agent RL (MARL) concepts',
            'RL from Human Feedback (RLHF) in LLMs',
            'OpenAI Gym / Gymnasium environments',
            'Real-world RL: robotics, recommendation systems',
          ],
          tools: [
            'Stable-Baselines3',
            'RLlib',
            'Gymnasium',
            'TensorBoard',
            'trlX'
          ],
          project:
              'Train a PPO agent to solve a continuous control task (MuJoCo/Brax)',
          resources: [
            '📘 Spinning Up in Deep RL — OpenAI (free)',
            '📘 Deep RL Course — HuggingFace (free)',
            '📘 David Silver RL lectures — UCL (YouTube)',
          ],
          isDone: false,
        ),
        _Phase(
          id: 11,
          title: 'MLOps & AI Infrastructure',
          subtitle: 'Deployment · Monitoring · CI/CD',
          duration: '5–6 weeks',
          level: 'Advanced',
          salaryUnlock: '₹22–40 LPA / \$145–200K',
          levelColor: const Color(0xFFF59E0B),
          topics: [
            'Model serving: FastAPI, TorchServe, Triton',
            'Containerisation: Docker, docker-compose',
            'Kubernetes: pods, deployments, Helm charts',
            'CI/CD for ML: GitHub Actions, DVC pipelines',
            'Feature stores: Feast, Tecton',
            'Model registry: MLflow, W&B Model Registry',
            'Monitoring: data drift, concept drift (Evidently)',
            'Distributed training: PyTorch DDP, FSDP',
            'GPU optimisation: memory profiling, Flash Attention',
            'Cloud: AWS SageMaker, Vertex AI, Azure ML',
          ],
          tools: [
            'Docker',
            'Kubernetes',
            'MLflow',
            'W&B',
            'FastAPI',
            'Triton',
            'Evidently'
          ],
          project:
              'Deploy a real ML model on Kubernetes with monitoring and auto-scaling',
          resources: [
            '📘 MLOps Zoomcamp — DataTalks.Club (free)',
            '📘 Made With ML — Goku Mohandas (free)',
            '📘 Effective MLOps — W&B course (free)',
          ],
          isDone: false,
        ),
        _Phase(
          id: 12,
          title: 'AI Research Skills',
          subtitle: 'Papers · Experiments · Ablations',
          duration: '4–6 weeks',
          level: 'Advanced',
          salaryUnlock: '₹35–60 LPA / \$180–260K',
          levelColor: const Color(0xFFEF4444),
          topics: [
            'How to read a research paper (3-pass method)',
            'Literature review: Arxiv, Semantic Scholar',
            'Experiment design: ablations, baselines, significance',
            'Writing a reproducible paper (LaTeX, Overleaf)',
            'Evaluation best practices: statistical significance',
            'Paper implementation from scratch',
            'Submitting to conferences: NeurIPS, ICML, ICLR, ACL',
            'Reviewing papers (open review process)',
            'Academic collaboration and author culture',
          ],
          tools: ['LaTeX', 'Overleaf', 'Arxiv', 'Papers With Code', 'Notion'],
          project:
              'Reproduce a top NeurIPS/ICML paper and write an analysis report',
          resources: [
            '📘 How to Read a Paper — Keshav (free PDF)',
            '📘 Papers With Code (paperswithcode.com)',
            '🎬 Yannic Kilcher paper walkthroughs (YouTube)',
          ],
          isDone: false,
        ),
        _Phase(
          id: 13,
          title: 'Specialisation Track',
          subtitle: 'Robotics · Finance · Healthcare · Autonomous',
          duration: '6–8 weeks',
          level: 'Advanced',
          salaryUnlock: '₹30–55 LPA / \$170–250K',
          levelColor: const Color(0xFFEF4444),
          topics: [
            '🤖 Robotics: ROS 2, sim-to-real, manipulation',
            '💊 Healthcare AI: FDA compliance, DICOM, radiology models',
            '📈 Finance AI: quant trading, risk models, time-series',
            '🚗 Autonomous: sensor fusion, LiDAR, HD maps',
            '🎮 Gaming AI: procedural generation, NPC behaviour',
            '🔒 AI Security: adversarial attacks, red teaming LLMs',
            '🌍 AI for Science: AlphaFold, weather models',
            'Pick ONE vertical and go deep for 6 weeks',
          ],
          tools: ['Domain-specific: ROS2 / or MONAI / or QuantLib / or CARLA'],
          project:
              'End-to-end domain project published on GitHub with write-up',
          resources: [
            '📘 Choose domain-specific courses on Coursera/Udemy',
            '📘 Domain papers on Arxiv',
          ],
          isDone: false,
        ),
        _Phase(
          id: 14,
          title: 'Portfolio & Open Source',
          subtitle: '3 Projects · GitHub · Writing',
          duration: '4–6 weeks',
          level: 'Career Prep',
          salaryUnlock: '₹25–50 LPA / \$140–220K',
          levelColor: const Color(0xFFEF4444),
          topics: [
            'Build 3 portfolio projects (not tutorials — real problems)',
            'GitHub: clean READMEs, demos, live links',
            'Write 3 technical blog posts (Substack / Medium / Dev.to)',
            'Contribute to 1 major open-source ML repo',
            'Create a Kaggle profile — aim for Expert tier',
            'LinkedIn optimisation for AI roles',
            'Build in public on Twitter/X — document your journey',
            'Record a 2-min demo video for each project',
          ],
          tools: ['GitHub', 'Streamlit', 'HuggingFace Spaces', 'Kaggle'],
          project:
              'Deploy 1 project on HuggingFace Spaces with >100 unique users',
          resources: [
            '📘 Sourabh Bajaj — ML Career Guide (GitHub)',
            '📘 Eugene Yan — Applied ML blog (free)',
          ],
          isDone: false,
        ),
        _Phase(
          id: 15,
          title: 'Interview Mastery',
          subtitle: 'Coding · ML Design · Behavioural',
          duration: '4–6 weeks',
          level: 'Career Prep',
          salaryUnlock: '₹15–100 LPA+ / \$120–400K+',
          levelColor: const Color(0xFFEF4444),
          topics: [
            'Coding: LeetCode Medium/Hard (50+ problems)',
            'ML fundamentals questions (bias-variance, regularisation)',
            'ML System Design: feature stores, training pipelines, serving',
            'Deep learning theory: backprop, optimisers, normalisations',
            'Take-home assignments: clean, reproducible code',
            'Behavioural: STAR method, leadership, failure stories',
            'Negotiation: competing offers, equity, signing bonuses',
            'Mock interviews: Pramp, Interviewing.io, peer mocks',
          ],
          tools: [
            'LeetCode',
            'Pramp',
            'Interviewing.io',
            'Grokking ML Interview'
          ],
          project: 'Complete 5 mock interviews + apply to 20+ companies',
          resources: [
            '📘 Chip Huyen — Machine Learning Interviews (GitHub free)',
            '📘 Grokking the ML Interview — Educative',
            '🏋️ LeetCode NeetCode 150',
          ],
          isDone: false,
        ),
      ];
}

// ════════════════════════════════════════════════════════════════════
// DATA MODEL
// ════════════════════════════════════════════════════════════════════

class _Phase {
  final int id;
  final String title;
  final String subtitle;
  final String duration;
  final String level;
  final String salaryUnlock;
  final Color levelColor;
  final List<String> topics;
  final List<String> tools;
  final String project;
  final List<String> resources;
  bool isDone;

  _Phase({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.level,
    required this.salaryUnlock,
    required this.levelColor,
    required this.topics,
    required this.tools,
    required this.project,
    required this.resources,
    this.isDone = false,
  });
}

class _SalRow {
  final String role;
  final String salary;
  final double pct;
  const _SalRow(this.role, this.salary, this.pct);
}

// ════════════════════════════════════════════════════════════════════
// PHASE CARD WIDGET
// ════════════════════════════════════════════════════════════════════

class _PhaseCard extends StatefulWidget {
  final _Phase phase;
  final int index;
  final VoidCallback onToggle;

  const _PhaseCard({
    required this.phase,
    required this.index,
    required this.onToggle,
  });

  @override
  State<_PhaseCard> createState() => _PhaseCardState();
}

class _PhaseCardState extends State<_PhaseCard> {
  bool _expanded = false;

  static const _bg = Color(0xFF0F0F1A);
  static const _surface = Color(0xFF1A1A2E);
  static const _border = Color(0xFF2A2A40);
  static const _primary = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted = Color(0xFF888899);

  @override
  Widget build(BuildContext context) {
    final p = widget.phase;

    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: p.isDone ? _primary.withOpacity(0.5) : _border,
          width: p.isDone ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          // ── Header row ──────────────────────────────────────────
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Phase number / check
                  GestureDetector(
                    onTap: widget.onToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: p.isDone ? _primary : const Color(0xFF0F0F20),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: p.isDone ? _primary : _border,
                        ),
                      ),
                      child: Center(
                        child: p.isDone
                            ? const Icon(Icons.check,
                                size: 20, color: Colors.white)
                            : Text(
                                '${widget.index + 1}',
                                style: const TextStyle(
                                  color: _muted,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title block
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.title,
                          style: TextStyle(
                            color: p.isDone ? _secondary : Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(p.subtitle,
                            style:
                                const TextStyle(color: _muted, fontSize: 12)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _chip(p.duration, const Color(0xFF60A5FA)),
                            const SizedBox(width: 6),
                            _chip(p.level, p.levelColor),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Expand arrow
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: _muted,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded body ────────────────────────────────────────
          if (_expanded) ...[
            const Divider(color: Color(0xFF2A2A40), height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Salary unlock
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: _primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Text('💰 ', style: TextStyle(fontSize: 14)),
                        const Text('Salary after this phase: ',
                            style: TextStyle(color: _muted, fontSize: 12)),
                        Text(p.salaryUnlock,
                            style: const TextStyle(
                                color: _secondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Topics
                  _sectionLabel('📋 Topics'),
                  const SizedBox(height: 8),
                  ...p.topics.map((t) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('  • ',
                                style:
                                    TextStyle(color: _secondary, fontSize: 13)),
                            Expanded(
                              child: Text(t,
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      height: 1.4)),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: 14),

                  // Tools
                  _sectionLabel('🛠️ Tools & Libraries'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: p.tools
                        .map((t) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F0F20),
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: const Color(0xFF333345)),
                              ),
                              child: Text(t,
                                  style: const TextStyle(
                                      color: _secondary, fontSize: 11)),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 14),

                  // Project
                  _sectionLabel('🚀 Milestone Project'),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1A0F),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF1A3A1A)),
                    ),
                    child: Text(p.project,
                        style: const TextStyle(
                            color: Color(0xFF6EE7B7),
                            fontSize: 13,
                            height: 1.4)),
                  ),

                  const SizedBox(height: 14),

                  // Resources
                  _sectionLabel('📚 Resources'),
                  const SizedBox(height: 8),
                  ResourceCardList(resources: p.resources),

                  const SizedBox(height: 12),

                  // Mark done button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: widget.onToggle,
                      icon: Icon(
                        p.isDone ? Icons.refresh : Icons.check_circle_outline,
                        size: 16,
                      ),
                      label: Text(p.isDone
                          ? 'And then click on learn'
                          : 'If you want to learn here, Click On Course Section ✓'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            p.isDone ? _muted : const Color(0xFF4ADE80),
                        side: BorderSide(
                          color: p.isDone ? _border : const Color(0xFF4ADE80),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(label, style: TextStyle(color: color, fontSize: 10)),
      );

  Widget _sectionLabel(String t) => Text(t,
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13));
}

// ════════════════════════════════════════════════════════════════════
// JOB LIST CARD (in Jobs tab)
// ════════════════════════════════════════════════════════════════════

class _JobListCard extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;
  const _JobListCard({required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A2A40)),
        ),
        child: Row(
          children: [
            // icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF0F0F20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2A2A40)),
              ),
              child: Center(
                child: Text(job.icon, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 12),

            // info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(
                    '${job.company} · ${job.location}',
                    style:
                        const TextStyle(color: Color(0xFF888899), fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 5,
                    runSpacing: 4,
                    children: job.skills
                        .take(3)
                        .map((s) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFF7C3AED).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(s,
                                  style: const TextStyle(
                                      color: Color(0xFFA78BFA), fontSize: 10)),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // salary + type
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(job.salary,
                    style: const TextStyle(
                        color: Color(0xFFA78BFA),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: job.type == 'Full-time'
                        ? const Color(0xFF4ADE80).withOpacity(0.12)
                        : const Color(0xFFF59E0B).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    job.type,
                    style: TextStyle(
                      color: job.type == 'Full-time'
                          ? const Color(0xFF4ADE80)
                          : const Color(0xFFF59E0B),
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
