// ══════════════════════════════════════════════════════════════════════
// lib/screens/career_roadmap_hub.dart
//
// Career Roadmap Hub — category browser + career selector.
// Opened from a "Browse All Careers" button inside roadmap_screen.dart.
//
// Architecture:
//  • Purely in-memory (no Firebase reads)
//  • SharedPreferences progress keys: career_{careerId}_phase_{phaseId}
//    → NEVER collides with existing phase_v2_X keys
//  • Tapping a career → CareerRoadmapDetail (same _Phase / _PhaseCard UI)
//  • Zero changes to existing roadmap_screen.dart internals
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'career_roadmap_detail.dart';

// ── Public entry point ────────────────────────────────────────────────

class CareerRoadmapHub extends StatefulWidget {
  const CareerRoadmapHub({super.key});

  @override
  State<CareerRoadmapHub> createState() => _CareerRoadmapHubState();
}

class _CareerRoadmapHubState extends State<CareerRoadmapHub> {
  // ── Design tokens ────────────────────────────────────────────────────
  static const _bg       = Color(0xFF0F0F1A);
  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);

  final _searchCtrl  = TextEditingController();
  String _search     = '';
  String? _selectedCategoryId;

  // Progress cache: careerId → completed phases count
  final Map<String, int> _progressCache = {};

  @override
  void initState() {
    super.initState();
    _loadAllProgress();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, int> cache = {};
    for (final cat in kCareerCategories) {
      for (final career in cat.careers) {
        int done = 0;
        for (int i = 1; i <= career.phases.length; i++) {
          if (prefs.getBool('career_${career.id}_phase_$i') ?? false) done++;
        }
        cache[career.id] = done;
      }
    }
    setState(() => _progressCache.addAll(cache));
  }

  // Filtered categories/careers for search
  List<CareerCategory> get _filtered {
    if (_search.isEmpty && _selectedCategoryId == null) {
      return kCareerCategories;
    }
    final q = _search.toLowerCase();
    return kCareerCategories.map((cat) {
      final careers = cat.careers.where((c) {
        final matchSearch = q.isEmpty ||
            c.title.toLowerCase().contains(q) ||
            c.skills.any((s) => s.toLowerCase().contains(q));
        final matchCat = _selectedCategoryId == null ||
            cat.id == _selectedCategoryId;
        return matchSearch && matchCat;
      }).toList();
      return CareerCategory(
        id:      cat.id,
        title:   cat.title,
        emoji:   cat.emoji,
        color:   cat.color,
        careers: careers,
      );
    }).where((cat) => cat.careers.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Career Roadmaps',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose your career path and get a\nstep-by-step learning roadmap.',
                  style: TextStyle(
                      color: _muted, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 12),

                // Search bar
                TextField(
                  controller: _searchCtrl,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search careers, skills…',
                    hintStyle:
                        const TextStyle(color: _muted, fontSize: 13),
                    prefixIcon: const Icon(Icons.search,
                        color: _muted, size: 20),
                    suffixIcon: _search.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close,
                                color: _muted, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _search = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: _surface,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: _border)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: _border)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: _primary, width: 1.5)),
                  ),
                  onChanged: (v) => setState(() => _search = v),
                ),
              ],
            ),
          ),

          // ── Category chips ───────────────────────────────────────────
          SizedBox(
            height: 38,
            child: ListView.separated(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: kCareerCategories.length + 1,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: 8),
              itemBuilder: (_, i) {
                if (i == 0) {
                  // All chip
                  final sel = _selectedCategoryId == null;
                  return _chip('All', null, sel);
                }
                final cat = kCareerCategories[i - 1];
                final sel = _selectedCategoryId == cat.id;
                return _chip(
                    '${cat.emoji} ${cat.title}', cat.id, sel);
              },
            ),
          ),

          const SizedBox(height: 10),

          // ── Stats row ────────────────────────────────────────────────
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  '${filtered.fold(0, (s, c) => s + c.careers.length)} careers',
                  style:
                      const TextStyle(color: _muted, fontSize: 12),
                ),
                const SizedBox(width: 8),
                const Text('·',
                    style: TextStyle(color: _muted)),
                const SizedBox(width: 8),
                Text(
                  '${kCareerCategories.length} categories',
                  style:
                      const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── Career list ──────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              itemCount: filtered.length,
              itemBuilder: (ctx, catIdx) {
                final cat = filtered[catIdx];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category header
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: cat.color.withOpacity(0.15),
                              borderRadius:
                                  BorderRadius.circular(10),
                              border: Border.all(
                                  color: cat.color.withOpacity(0.3)),
                            ),
                            child: Center(
                              child: Text(cat.emoji,
                                  style: const TextStyle(
                                      fontSize: 16)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            cat.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: cat.color.withOpacity(0.12),
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${cat.careers.length}',
                              style: TextStyle(
                                  color: cat.color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Career cards
                    ...cat.careers.asMap().entries.map((entry) {
                      final i      = entry.key;
                      final career = entry.value;
                      final done   =
                          _progressCache[career.id] ?? 0;
                      final total  = career.phases.length;
                      final pct    = total == 0
                          ? 0.0
                          : done / total;

                      return _CareerCard(
                        career:    career,
                        catColor:  cat.color,
                        donePhases: done,
                        totalPhases: total,
                        progress:  pct,
                        onTap: () async {
                          await Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CareerRoadmapDetail(
                                career:   career,
                                catColor: cat.color,
                              ),
                            ),
                          );
                          // Refresh progress on return
                          await _loadAllProgress();
                        },
                      )
                          .animate()
                          .fadeIn(
                              delay: Duration(
                                  milliseconds:
                                      catIdx * 30 + i * 40))
                          .slideX(begin: 0.04, duration: 280.ms);
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, String? id, bool selected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedCategoryId = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? _primary.withOpacity(0.25)
              : _surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _primary : _border,
            width:  selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? _secondary : _muted,
            fontSize: 12,
            fontWeight: selected
                ? FontWeight.w600
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ── Career Card ───────────────────────────────────────────────────────

class _CareerCard extends StatelessWidget {
  final CareerData   career;
  final Color        catColor;
  final int          donePhases;
  final int          totalPhases;
  final double       progress;
  final VoidCallback onTap;

  const _CareerCard({
    required this.career,
    required this.catColor,
    required this.donePhases,
    required this.totalPhases,
    required this.progress,
    required this.onTap,
  });

  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _muted    = Color(0xFF888899);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);

  @override
  Widget build(BuildContext context) {
    final started  = donePhases > 0;
    final complete = donePhases == totalPhases && totalPhases > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: complete
                ? const Color(0xFF4ADE80).withOpacity(0.4)
                : started
                    ? catColor.withOpacity(0.35)
                    : _border,
            width: started ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: catColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: catColor.withOpacity(0.25)),
              ),
              child: Center(
                child: Text(
                  career.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 13),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          career.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (complete)
                        const Text('✅',
                            style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    career.tagline,
                    style: const TextStyle(
                        color: _muted, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Skills preview
                  Wrap(
                    spacing: 5,
                    runSpacing: 4,
                    children: career.skills.take(3).map((s) =>
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: _primary.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(s,
                            style: const TextStyle(
                                color: _secondary,
                                fontSize: 9)),
                      ),
                    ).toList(),
                  ),

                  // Progress bar (if started)
                  if (started) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 4,
                              backgroundColor: const Color(0xFF2A2A40),
                              valueColor:
                                  AlwaysStoppedAnimation(catColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$donePhases/$totalPhases',
                          style: TextStyle(
                              color: catColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Arrow + phase count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.arrow_forward_ios,
                    color: _muted, size: 14),
                const SizedBox(height: 6),
                Text(
                  '${career.phases.length} phases',
                  style: const TextStyle(
                      color: _muted, fontSize: 10),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: catColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    career.level,
                    style: TextStyle(
                        color: catColor, fontSize: 9),
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

// ══════════════════════════════════════════════════════════════════════
// DATA MODELS
// ══════════════════════════════════════════════════════════════════════

class CareerCategory {
  final String          id;
  final String          title;
  final String          emoji;
  final Color           color;
  final List<CareerData> careers;

  const CareerCategory({
    required this.id,
    required this.title,
    required this.emoji,
    required this.color,
    required this.careers,
  });
}

class CareerData {
  final String       id;
  final String       title;
  final String       emoji;
  final String       tagline;
  final String       level;    // Beginner | Intermediate | Advanced
  final List<String> skills;   // top 5 skills shown as chips
  final List<CareerPhase> phases;

  const CareerData({
    required this.id,
    required this.title,
    required this.emoji,
    required this.tagline,
    required this.level,
    required this.skills,
    required this.phases,
  });
}

class CareerPhase {
  final int          id;
  final String       title;
  final String       subtitle;
  final String       duration;
  final String       level;
  final String       levelColor; // hex
  final String       salaryUnlock;
  final List<String> topics;
  final List<String> tools;
  final String       project;
  final List<String> resources;

  const CareerPhase({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.level,
    required this.levelColor,
    required this.salaryUnlock,
    required this.topics,
    required this.tools,
    required this.project,
    required this.resources,
  });
}

// ══════════════════════════════════════════════════════════════════════
// CAREER DATA — 46 careers across 8 categories
// ══════════════════════════════════════════════════════════════════════

const List<CareerCategory> kCareerCategories = [
  _softwareDev,
  _aiData,
  _cloudDevops,
  _cyberSecurity,
  _designProduct,
  _emergingTech,
  _testingQa,
  _specialized,
];

// ──────────────────────────────────────────────────────────────────────
// 1. SOFTWARE DEVELOPMENT
// ──────────────────────────────────────────────────────────────────────
const _softwareDev = CareerCategory(
  id:    'software_dev',
  title: 'Software Development',
  emoji: '🚀',
  color: Color(0xFF60A5FA),
  careers: [
    CareerData(
      id:'software_engineer', title:'Software Engineer',
      emoji:'💻', tagline:'Build scalable software systems',
      level:'Beginner', skills:['Python','Java','DSA','System Design','Git'],
      phases: [
        CareerPhase(id:1,title:'Programming Fundamentals',subtitle:'Variables, loops, functions, OOP',duration:'4–6 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹3–5 LPA / \$40K',topics:['Python/Java basics','Data types','Control flow','Functions','OOP: classes, inheritance, polymorphism','Exception handling'],tools:['Python 3','IntelliJ IDEA','VS Code','Git'],project:'Build a console-based student grade calculator',resources:['📘 CS50x — Harvard (free)','📘 Python.org Tutorial','🏋️ HackerRank 30 Days of Code']),
        CareerPhase(id:2,title:'Data Structures',subtitle:'Arrays, linked lists, trees, graphs',duration:'6–8 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹4–7 LPA / \$50K',topics:['Arrays & strings','Linked lists','Stacks & queues','Hash maps','Binary trees','Graphs (BFS/DFS)','Heaps'],tools:['LeetCode','Python','Java','Visualgo'],project:'Implement a library management system using linked lists and hash maps',resources:['📘 Cracking the Coding Interview','📘 NeetCode 150 (free)','🎬 CS Dojo DSA (YouTube)']),
        CareerPhase(id:3,title:'Algorithms & Complexity',subtitle:'Sorting, searching, dynamic programming',duration:'6–8 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹5–9 LPA / \$60K',topics:['Sorting algorithms','Binary search','Recursion & backtracking','Dynamic programming','Greedy algorithms','Big-O analysis','Divide & conquer'],tools:['LeetCode','HackerRank','Codeforces'],project:'Solve 50 LeetCode Medium problems with documented solutions',resources:['📘 Introduction to Algorithms (CLRS)','📘 Blind 75 (free)','🎬 Abdul Bari Algorithms (YouTube)']),
        CareerPhase(id:4,title:'Version Control & Collaboration',subtitle:'Git, GitHub, team workflows',duration:'2–3 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹5–8 LPA / \$55K',topics:['Git init, add, commit, push','Branching & merging','Pull requests & code review','Git rebase & cherry-pick','GitHub Actions basics','Conventional commits'],tools:['Git','GitHub','GitLab'],project:'Contribute a meaningful PR to an open-source project on GitHub',resources:['📘 Pro Git (free)','📘 GitHub Skills (free)','🎬 Fireship Git in 100 seconds']),
        CareerPhase(id:5,title:'Operating Systems & Networking',subtitle:'Linux, processes, TCP/IP',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹6–10 LPA / \$65K',topics:['Linux CLI (file system, permissions, processes)','Memory management','Threads & concurrency','TCP/IP networking basics','HTTP/HTTPS','DNS, load balancers','Sockets'],tools:['Linux (Ubuntu)','Wireshark','Postman'],project:'Build a multi-threaded HTTP server from scratch in Python',resources:['📘 OSTEP — Operating Systems (free)','📘 Computer Networking: A Top Down Approach','🎬 Hussein Nasser Networking (YouTube)']),
        CareerPhase(id:6,title:'Databases',subtitle:'SQL, NoSQL, schema design',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–12 LPA / \$70K',topics:['SQL: joins, indexes, transactions','PostgreSQL / MySQL','NoSQL: MongoDB, Redis','Database design & normalisation','Query optimisation','ORMs (SQLAlchemy, Hibernate)','Connection pooling'],tools:['PostgreSQL','MongoDB','Redis','DBeaver'],project:'Design and build a full relational schema for an e-commerce system',resources:['📘 Use The Index, Luke (free)','📘 Designing Data-Intensive Applications','🎬 Hussain Nasser DB Engineering']),
        CareerPhase(id:7,title:'System Design',subtitle:'Scalability, distributed systems',duration:'6–8 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹12–22 LPA / \$100K',topics:['Horizontal vs vertical scaling','Load balancers & CDN','Caching strategies','Message queues (Kafka, RabbitMQ)','Microservices vs monolith','CAP theorem','Rate limiting & API gateway','Database sharding'],tools:['AWS/GCP','Kafka','Redis','Docker'],project:'Design a Twitter clone architecture handling 1M DAU',resources:['📘 System Design Interview — Alex Xu','📘 Grokking System Design (Educative)','🎬 Gaurav Sen System Design (YouTube)']),
        CareerPhase(id:8,title:'Testing & Quality',subtitle:'Unit, integration, TDD',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹8–14 LPA / \$75K',topics:['Unit testing (pytest, JUnit)','Integration testing','Test-driven development (TDD)','Mocking & fixtures','Code coverage','CI/CD basics','Linting & formatting'],tools:['pytest','Jest','JUnit','SonarQube'],project:'Build a REST API with 90%+ test coverage using TDD',resources:['📘 Test-Driven Development by Kent Beck','📘 Clean Code — Robert Martin']),
        CareerPhase(id:9,title:'Portfolio & Open Source',subtitle:'Projects, GitHub, blog',duration:'4–6 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹10–20 LPA / \$80K',topics:['Build 3 portfolio projects','Clean READMEs with demos','Contribute to open-source repos','Write technical blog posts','LinkedIn profile optimisation','GitHub contribution graph','Deploy all projects live'],tools:['GitHub','Vercel','Railway','Netlify'],project:'Deploy 3 real projects live with CI/CD and write case studies',resources:['📘 Eugene Yan Blog (free)','📘 GitHub Profile README guide']),
        CareerPhase(id:10,title:'Interview Mastery',subtitle:'DSA, system design, behavioural',duration:'4–6 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹15–40 LPA+ / \$100K+',topics:['LeetCode Medium/Hard — 100+ problems','System design interviews (1hr)','Behavioural: STAR method','Salary negotiation','Take-home assignments','Mock interviews','Offer evaluation'],tools:['LeetCode','Pramp','Interviewing.io'],project:'Complete 10 mock interviews and apply to 30+ companies',resources:['📘 Cracking the Coding Interview','📘 Chip Huyen ML Interviews (free)','🎬 NeetCode (YouTube)']),
      ],
    ),
    CareerData(
      id:'fullstack_dev', title:'Full Stack Developer',
      emoji:'🌐', tagline:'Build complete web apps end-to-end',
      level:'Beginner', skills:['React','Node.js','TypeScript','MongoDB','SQL'],
      phases: [
        CareerPhase(id:1,title:'Programming Fundamentals',subtitle:'HTML, CSS, JavaScript basics',duration:'4–5 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹2–4 LPA / \$35K',topics:['HTML5 semantic markup','CSS3: flexbox, grid, animations','JavaScript ES6+: let/const, arrow functions, promises, async/await','DOM manipulation','Event handling','Browser DevTools'],tools:['VS Code','Chrome DevTools','CodePen'],project:'Build a personal portfolio website with HTML/CSS/JS',resources:['📘 The Odin Project (free)','📘 freeCodeCamp (free)','📘 MDN Web Docs (free)']),
        CareerPhase(id:2,title:'Git & GitHub',subtitle:'Version control, collaboration',duration:'1–2 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹3–5 LPA / \$40K',topics:['Git init/add/commit/push','Branching strategies','Pull requests','GitHub pages','.gitignore & README'],tools:['Git','GitHub'],project:'Create a GitHub profile README with contribution graph',resources:['📘 Pro Git Book (free)','📘 GitHub Skills (free)']),
        CareerPhase(id:3,title:'React',subtitle:'Component-based UI development',duration:'6–8 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹5–9 LPA / \$55K',topics:['JSX & components','Props & state','Hooks: useState, useEffect, useContext, useReducer','React Router','Fetch API / Axios','Error boundaries','Performance: memo, useMemo, useCallback','Vite & CRA setup'],tools:['React','Vite','React Router','Axios'],project:'Build a weather app with React + public API',resources:['📘 React Docs (react.dev, free)','📘 Epic React — Kent C. Dodds','🎬 Traversy Media React (YouTube)']),
        CareerPhase(id:4,title:'TypeScript',subtitle:'Type-safe JavaScript at scale',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹6–10 LPA / \$60K',topics:['Types vs interfaces','Generics','Union & intersection types','Enums','TypeScript with React','tsconfig.json','Type inference','Utility types (Partial, Pick, Omit)'],tools:['TypeScript','ts-node','VS Code'],project:'Migrate a React project to TypeScript with strict mode enabled',resources:['📘 TypeScript Handbook (free)','📘 Total TypeScript — Matt Pocock']),
        CareerPhase(id:5,title:'Node.js & Express',subtitle:'Backend development with JavaScript',duration:'5–6 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–12 LPA / \$65K',topics:['Node.js runtime & event loop','npm & package management','Express.js routes, middleware','REST API design','Authentication (JWT, sessions)','File uploads (multer)','Environment variables & config','Error handling middleware'],tools:['Node.js','Express','Postman','JWT'],project:'Build a REST API for a todo app with user authentication',resources:['📘 Node.js Docs (free)','📘 Express.js Docs (free)','🎬 Fireship Node.js course']),
        CareerPhase(id:6,title:'MongoDB & SQL',subtitle:'Database design and querying',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹8–13 LPA / \$70K',topics:['MongoDB: documents, collections, aggregation','Mongoose ODM','SQL: PostgreSQL basics','Database schema design','Indexes for performance','CRUD operations','Migrations & seeds','Connection pooling'],tools:['MongoDB','Mongoose','PostgreSQL','pgAdmin'],project:'Build a blog API with MongoDB + authentication + comments',resources:['📘 MongoDB University (free)','📘 PostgreSQL Tutorial (free)']),
        CareerPhase(id:7,title:'APIs & Authentication',subtitle:'REST, GraphQL, OAuth',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹9–15 LPA / \$75K',topics:['RESTful API principles','GraphQL basics','OAuth 2.0 & OpenID Connect','JWT refresh token flow','Rate limiting','API documentation (Swagger)','Webhooks','Third-party API integration'],tools:['Postman','Swagger','Auth0','GraphQL'],project:'Integrate 3 third-party APIs (payment, email, maps) into an app',resources:['📘 API Design Patterns — JJ Geewax','📘 OAuth 2.0 simplified (free)']),
        CareerPhase(id:8,title:'Deployment & DevOps',subtitle:'CI/CD, Docker, cloud',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹10–18 LPA / \$80K',topics:['Linux & SSH basics','Nginx web server config','Docker & docker-compose','Environment-based configs','GitHub Actions CI/CD','Vercel / Railway / Render','SSL certificates','Environment secrets management'],tools:['Docker','Nginx','GitHub Actions','Vercel','Railway'],project:'Deploy a full-stack app with automated CI/CD pipeline',resources:['📘 Docker Docs (free)','📘 Full Stack Open (free)']),
        CareerPhase(id:9,title:'System Design for Web',subtitle:'Scalability, caching, queues',duration:'4–6 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹14–25 LPA / \$95K',topics:['Caching strategies (Redis)','Message queues (Bull, BullMQ)','Horizontal scaling','CDN & load balancing','WebSockets & real-time','Microservices basics','Database optimisation at scale','Monitoring (logs, errors)'],tools:['Redis','BullMQ','Socket.io','PM2'],project:'Build a real-time chat app with Redis pub/sub and Socket.io',resources:['📘 System Design Primer (GitHub, free)','📘 Designing Data-Intensive Applications']),
        CareerPhase(id:10,title:'Next.js & Advanced React',subtitle:'SSR, SSG, full-stack React',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹12–22 LPA / \$90K',topics:['Next.js App Router','Server components vs client components','SSR vs SSG vs ISR','API Routes','Server Actions','Image optimisation','SEO with metadata','Tailwind CSS integration','Deployment on Vercel'],tools:['Next.js','Tailwind CSS','Vercel','Prisma'],project:'Build a full-stack SaaS MVP with Next.js, auth, and payments',resources:['📘 Next.js Docs (free)','📘 Josh tried coding Next.js course (YouTube, free)']),
      ],
    ),
    CareerData(
      id:'frontend_dev', title:'Frontend Developer',
      emoji:'🎨', tagline:'Build beautiful, fast UIs',
      level:'Beginner', skills:['HTML','CSS','JavaScript','React','TypeScript'],
      phases: [
        CareerPhase(id:1,title:'HTML Fundamentals',subtitle:'Semantic markup, accessibility',duration:'2–3 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹2–4 LPA / \$30K',topics:['Semantic HTML5 elements','Forms and validation','Tables','Accessibility (ARIA)','SEO meta tags','HTML best practices'],tools:['VS Code','Chrome DevTools'],project:'Build a complete job listing page with semantic HTML',resources:['📘 MDN HTML (free)','📘 web.dev (Google, free)']),
        CareerPhase(id:2,title:'CSS Mastery',subtitle:'Flexbox, Grid, animations',duration:'4–5 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹3–5 LPA / \$35K',topics:['Box model','Flexbox','CSS Grid','Responsive design & media queries','CSS Variables','Animations & transitions','Pseudo-elements','CSS architecture (BEM)'],tools:['VS Code','Chrome DevTools','CSS Tricks'],project:'Build a fully responsive landing page matching a Figma design',resources:['📘 CSS Tricks (free)','📘 Kevin Powell CSS (YouTube, free)']),
        CareerPhase(id:3,title:'JavaScript Deep Dive',subtitle:'ES6+, async, DOM',duration:'6–8 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹4–7 LPA / \$45K',topics:['ES6+ features','Closures & scope','Prototypes & classes','Event loop & asynchrony','Promises & async/await','Fetch API','DOM manipulation','Local storage & cookies','Error handling'],tools:['Chrome DevTools','VS Code'],project:'Build a Kanban board app with drag-and-drop in vanilla JS',resources:['📘 JavaScript.info (free)','📘 Eloquent JavaScript (free)','🎬 Fireship JS series']),
        CareerPhase(id:4,title:'React Development',subtitle:'Components, hooks, state management',duration:'6–8 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹6–10 LPA / \$55K',topics:['React fundamentals','Hooks (useState, useEffect, useRef, useMemo)','Context API','React Router v6','State management (Zustand / Redux Toolkit)','React Query / SWR','Component patterns','Performance optimisation'],tools:['React','Vite','Zustand','React Query'],project:'Build a GitHub profile explorer with search and favourites',resources:['📘 React Docs (react.dev, free)','📘 ui.dev React course']),
        CareerPhase(id:5,title:'TypeScript',subtitle:'Type safety at scale',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–11 LPA / \$60K',topics:['TS types, interfaces, generics','TypeScript with React','Strict mode','Type utilities','Declaration files','tsconfig setup'],tools:['TypeScript','VS Code'],project:'Rebuild a React project with TypeScript strict mode',resources:['📘 TypeScript Handbook (free)','📘 Matt Pocock Total TypeScript']),
        CareerPhase(id:6,title:'UI Libraries & Design Systems',subtitle:'Tailwind, shadcn, design tokens',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–12 LPA / \$65K',topics:['Tailwind CSS utility-first design','shadcn/ui components','Radix UI primitives','Framer Motion animations','Storybook for component documentation','Design tokens','Dark mode implementation'],tools:['Tailwind CSS','shadcn/ui','Framer Motion','Storybook'],project:'Build and document a full design system in Storybook',resources:['📘 Tailwind Docs (free)','📘 shadcn docs (free)']),
        CareerPhase(id:7,title:'Performance Optimisation',subtitle:'Core Web Vitals, bundle size',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹9–15 LPA / \$70K',topics:['Core Web Vitals (LCP, FID, CLS)','Code splitting & lazy loading','Image optimisation','Bundle analysis','Service workers & caching','Lighthouse audits','Critical rendering path','Preloading & prefetching'],tools:['Lighthouse','Webpack Bundle Analyzer','Chrome DevTools'],project:'Optimise a slow web app to score 95+ on Lighthouse',resources:['📘 web.dev Performance (free)','📘 WebPageTest']),
        CareerPhase(id:8,title:'Testing for Frontend',subtitle:'Unit, E2E, visual regression',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹9–14 LPA / \$72K',topics:['Vitest / Jest for unit testing','React Testing Library','Cypress for E2E','Playwright','Visual regression testing','Mocking APIs in tests','Test coverage reports'],tools:['Vitest','React Testing Library','Cypress','Playwright'],project:'Write a full test suite (unit + E2E) for a React app',resources:['📘 Testing Library Docs (free)','📘 Cypress Docs (free)']),
        CareerPhase(id:9,title:'Portfolio Projects',subtitle:'3 showcase apps, case studies',duration:'4–6 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹10–20 LPA / \$75K',topics:['Build 3 production-quality UI projects','Write design decision case studies','Record demo videos','Deploy on Vercel','Open-source one project','LinkedIn profile UI section','GitHub profile README'],tools:['Vercel','GitHub','Figma'],project:'Build a portfolio with 3 live projects and animated case study pages',resources:['📘 Frontend Mentor (free)','📘 Stefan Judis blog']),
        CareerPhase(id:10,title:'Interview Mastery',subtitle:'DSA, UI challenges, system design',duration:'4–5 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹12–28 LPA+ / \$80K+',topics:['LeetCode Easy/Medium — 50 problems','CSS challenges (css-challenges.com)','JavaScript interview questions','React architecture questions','Accessibility in interviews','Salary negotiation','Take-home projects'],tools:['LeetCode','GreatFrontEnd','Pramp'],project:'Complete 5 mock interviews and 10 take-home UI challenges',resources:['📘 GreatFrontEnd (free + paid)','📘 Frontend Interview Handbook (free)']),
      ],
    ),
    CareerData(
      id:'backend_dev', title:'Backend Developer',
      emoji:'⚙️', tagline:'Build APIs, databases, and server logic',
      level:'Beginner', skills:['Python/Java/Node','REST APIs','SQL','Docker','Redis'],
      phases: [
        CareerPhase(id:1,title:'Programming Language Mastery',subtitle:'Python, Java, or Go in depth',duration:'5–6 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹3–5 LPA / \$40K',topics:['Choose: Python (FastAPI/Django), Java (Spring), Go, or Node.js (Express)','OOP and functional concepts','Error handling','File I/O','Standard library deep dive','Package management'],tools:['VS Code','PyCharm / IntelliJ'],project:'Build a CLI tool in your chosen language that solves a real problem',resources:['📘 Python Docs (free)','📘 Go Tour (free)','📘 Spring.io guides']),
        CareerPhase(id:2,title:'REST API Design',subtitle:'Endpoints, HTTP, JSON',duration:'4–5 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹4–7 LPA / \$50K',topics:['HTTP methods, status codes','REST principles','Request/response lifecycle','JSON serialisation','Validation & sanitisation','Versioning','HATEOAS','API documentation (OpenAPI/Swagger)'],tools:['Postman','Swagger UI','FastAPI / Express'],project:'Build a full CRUD REST API for a bookstore with Swagger docs',resources:['📘 REST API Tutorial (free)','📘 FastAPI Docs (free)']),
        CareerPhase(id:3,title:'Databases In Depth',subtitle:'SQL, NoSQL, caching',duration:'5–6 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹6–10 LPA / \$60K',topics:['Advanced SQL (CTEs, window functions, indexes)','PostgreSQL tuning','MongoDB aggregation pipelines','Redis caching patterns','Database transactions (ACID)','Connection pooling','ORMs vs raw SQL','Migrations'],tools:['PostgreSQL','MongoDB','Redis','SQLAlchemy / Prisma'],project:'Optimise a slow database query from 10s to under 100ms',resources:['📘 Use The Index Luke (free)','📘 MongoDB University (free)']),
        CareerPhase(id:4,title:'Authentication & Security',subtitle:'JWT, OAuth, hashing, OWASP',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–12 LPA / \$65K',topics:['JWT access & refresh tokens','OAuth 2.0 with Google/GitHub','Password hashing (bcrypt, argon2)','OWASP Top 10','SQL injection prevention','CORS & CSRF','Rate limiting','HTTPS & TLS basics','Secrets management (.env, Vault)'],tools:['JWT','OAuth providers','OWASP ZAP'],project:'Build a secure auth system with Google OAuth and role-based access',resources:['📘 OWASP Top 10 (free)','📘 Auth0 Docs (free)']),
        CareerPhase(id:5,title:'Message Queues & Event-Driven',subtitle:'Kafka, RabbitMQ, async patterns',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹8–14 LPA / \$70K',topics:['Event-driven architecture','Kafka: topics, partitions, consumers','RabbitMQ basics','Bull/BullMQ for Node.js','Async task processing','Dead letter queues','Idempotency','CQRS pattern'],tools:['Kafka','RabbitMQ','BullMQ','Redis Streams'],project:'Build an order processing system with async payment and email queues',resources:['📘 Kafka Documentation (free)','📘 RabbitMQ Tutorials (free)']),
        CareerPhase(id:6,title:'Microservices Architecture',subtitle:'Services, Docker, Kubernetes basics',duration:'5–6 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹10–18 LPA / \$80K',topics:['Microservices vs monolith','Service discovery','API gateway pattern','Inter-service communication (gRPC, REST)','Docker containerisation','Docker Compose for local dev','Kubernetes intro (pods, services)','Health checks & graceful shutdown'],tools:['Docker','Docker Compose','Kubernetes','gRPC'],project:'Split a monolith into 3 microservices with Docker Compose',resources:['📘 Microservices.io (free)','📘 Docker Docs (free)']),
        CareerPhase(id:7,title:'Testing & Reliability',subtitle:'Unit, integration, load testing',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹10–16 LPA / \$78K',topics:['Unit testing services','Integration testing with real DBs','Contract testing (Pact)','Load testing (k6, Locust)','Chaos engineering basics','Test fixtures & factories','CI/CD test pipelines','Error monitoring (Sentry)'],tools:['pytest','k6','Locust','Sentry'],project:'Load test an API to find bottlenecks and fix them',resources:['📘 k6 Docs (free)','📘 Testing Node.js Apps (free)']),
        CareerPhase(id:8,title:'Cloud & Deployment',subtitle:'AWS/GCP, CI/CD, monitoring',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹12–20 LPA / \$85K',topics:['AWS EC2, S3, RDS, Lambda basics','CI/CD with GitHub Actions','Terraform basics','Log aggregation (ELK)','Application monitoring (Datadog / Grafana)','Blue-green deployments','Auto-scaling groups','Cost optimisation'],tools:['AWS','Terraform','GitHub Actions','Grafana'],project:'Deploy a backend service to AWS with auto-scaling and monitoring',resources:['📘 AWS Free Tier tutorials','📘 Terraform Docs (free)']),
        CareerPhase(id:9,title:'Portfolio Projects',subtitle:'3 backend systems, documented',duration:'4–5 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹12–22 LPA / \$90K',topics:['3 backend projects with READMEs','API documentation published','Performance benchmarks in README','Architecture diagrams','Contributing to open-source','Technical blog posts'],tools:['GitHub','Postman','draw.io'],project:'Publish 3 backend projects with full API docs and architecture diagrams',resources:['📘 Backend developer roadmap.sh (free)']),
        CareerPhase(id:10,title:'Interview Mastery',subtitle:'System design, coding, behavioural',duration:'4–6 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹15–40 LPA+ / \$100K+',topics:['LeetCode Medium/Hard — 75 problems','Backend system design','Database design interviews','API design walkthroughs','Behavioural: STAR method','Salary negotiation techniques'],tools:['LeetCode','Pramp','Interviewing.io'],project:'10 mock interviews + apply to 25+ companies',resources:['📘 System Design Interview — Alex Xu','📘 Chip Huyen ML Interviews']),
      ],
    ),
    CareerData(
      id:'mobile_dev', title:'Mobile App Developer',
      emoji:'📱', tagline:'Build iOS and Android apps',
      level:'Beginner', skills:['Flutter/React Native','Dart/JS','Firebase','REST APIs','UI Design'],
      phases: [
        CareerPhase(id:1,title:'Programming Fundamentals',subtitle:'Dart or JavaScript basics',duration:'3–4 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹3–5 LPA / \$40K',topics:['Dart: variables, types, functions, OOP','OR JavaScript ES6+ for React Native','Async programming','Null safety','Collections: List, Map, Set'],tools:['Dart','VS Code'],project:'Build a command-line quiz app in Dart or JS',resources:['📘 Dart.dev Tour (free)','📘 JavaScript.info (free)']),
        CareerPhase(id:2,title:'Flutter / React Native Basics',subtitle:'Widgets, components, layout',duration:'5–6 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹4–7 LPA / \$45K',topics:['Flutter: MaterialApp, Scaffold, StatelessWidget, StatefulWidget','React Native: core components','Layout: Row, Column, Stack / Flexbox','Navigation: push/pop / React Navigation','State management basics','Hot reload'],tools:['Flutter SDK','Android Studio','iOS Simulator'],project:'Build a simple notes app with CRUD operations',resources:['📘 Flutter Docs (free)','📘 React Native Docs (free)','🎬 Flutter Official YouTube']),
        CareerPhase(id:3,title:'State Management',subtitle:'Provider, Riverpod, Redux',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹6–10 LPA / \$55K',topics:['Provider / InheritedWidget','Riverpod (Flutter) or Redux (RN)','BLoC pattern','setState pitfalls','Separation of concerns','Reactive programming'],tools:['Riverpod','BLoC','Redux'],project:'Build a shopping cart app with proper state management',resources:['📘 Riverpod Docs (free)','📘 Flutter BLoC Library Docs']),
        CareerPhase(id:4,title:'Firebase Integration',subtitle:'Auth, Firestore, Storage',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–11 LPA / \$60K',topics:['Firebase Auth (email, Google, Apple)','Cloud Firestore real-time queries','Firebase Storage for media','Firebase Remote Config','Push notifications (FCM)','Firebase Analytics','Security rules'],tools:['Firebase','FlutterFire','Cloud Firestore'],project:'Build a social app with Firebase auth, posts, and real-time comments',resources:['📘 Firebase Docs (free)','📘 FlutterFire Docs (free)']),
        CareerPhase(id:5,title:'REST APIs & Networking',subtitle:'HTTP, JSON, error handling',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–12 LPA / \$62K',topics:['HTTP client (Dio / Axios)','JSON parsing & serialisation','Loading, error, success states','Retry logic','Offline mode & caching','Authentication headers','API versioning'],tools:['Dio','Axios','Postman'],project:'Build a weather app consuming a public REST API with offline caching',resources:['📘 Dio Package Docs (free)','📘 Retrofit for Dart']),
        CareerPhase(id:6,title:'UI/UX for Mobile',subtitle:'Material, Cupertino, animations',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹8–13 LPA / \$65K',topics:['Material Design 3','Cupertino (iOS style)','Custom animations (AnimationController)','Flutter Animate','Responsive layouts','Dark mode support','Accessibility (screen readers)','Theming & typography'],tools:['Flutter Animate','Lottie','Adobe XD / Figma'],project:'Build a fintech app UI with animations and both light/dark themes',resources:['📘 Material Design Docs (free)','📘 Flutter Gallery source code']),
        CareerPhase(id:7,title:'Local Storage & Offline',subtitle:'Hive, SQLite, SharedPrefs',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹8–14 LPA / \$67K',topics:['SharedPreferences for settings','Hive for fast local NoSQL','SQLite / Drift for relational local data','Offline-first architecture','Data sync strategies','Encrypted storage for secrets'],tools:['Hive','Drift/Moor','SharedPreferences'],project:'Build an offline-capable task manager that syncs when online',resources:['📘 Hive Docs (free)','📘 Drift Docs (free)']),
        CareerPhase(id:8,title:'App Store Publishing',subtitle:'Play Store, App Store, signing',duration:'2–3 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹9–15 LPA / \$70K',topics:['Android signing & keystore','iOS provisioning profiles & certificates','App Store guidelines','Play Store listing optimisation','In-app purchases basics','App ratings & reviews strategy','CI/CD for mobile (Fastlane, Codemagic)'],tools:['Fastlane','Codemagic','Google Play Console','App Store Connect'],project:'Publish a real app to both Play Store and App Store',resources:['📘 Flutter Deployment Docs (free)','📘 Fastlane Docs (free)']),
        CareerPhase(id:9,title:'Testing Mobile Apps',subtitle:'Unit, widget, integration, E2E',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹9–16 LPA / \$72K',topics:['Flutter test package: unit tests','Widget testing','Integration tests','Patrol for E2E','Mocking HTTP calls','Golden tests (screenshot comparison)','Firebase Test Lab'],tools:['Flutter Test','Patrol','Mockito','Firebase Test Lab'],project:'Write a full test suite for a Flutter app with 80%+ coverage',resources:['📘 Flutter Testing Docs (free)','📘 Patrol Docs (free)']),
        CareerPhase(id:10,title:'Interview & Job Ready',subtitle:'Portfolio, mock interviews',duration:'3–5 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹12–28 LPA / \$80K+',topics:['3 published portfolio apps','Mobile-specific interview questions','Dart/Flutter/RN interview prep','System design for mobile','Salary negotiation','Take-home app challenges'],tools:['LeetCode','Pramp'],project:'3 published apps + 5 mock interviews',resources:['📘 Flutter Interview Questions (GitHub, free)']),
      ],
    ),
    CareerData(
      id:'flutter_dev', title:'Flutter Developer',
      emoji:'🦋', tagline:'Cross-platform apps with Flutter & Dart',
      level:'Beginner', skills:['Dart','Flutter','Firebase','Riverpod','REST APIs'],
      phases: [
        CareerPhase(id:1,title:'Dart Language',subtitle:'Null safety, OOP, async',duration:'3–4 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹3–5 LPA / \$40K',topics:['Variables, types, functions','Classes, inheritance, mixins','Null safety (?? and !)','Futures, async/await, Streams','List, Map, Set operations','Extension methods','Named/optional params'],tools:['DartPad','VS Code'],project:'Build a CLI expense tracker in Dart with file persistence',resources:['📘 Dart.dev Tour (free)','📘 Dart Apprentice book']),
        CareerPhase(id:2,title:'Flutter Fundamentals',subtitle:'Widgets, layout, navigation',duration:'5–6 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹4–7 LPA / \$45K',topics:['StatelessWidget & StatefulWidget','MaterialApp & Scaffold','Layout: Row, Column, Stack, Flexible, Expanded','ListView, GridView, SingleChildScrollView','Navigator 1.0 push/pop','AppBar, BottomNavigationBar','ThemeData & color schemes'],tools:['Flutter SDK','Android Studio','VS Code'],project:'Build a recipe app with multiple screens and navigation',resources:['📘 Flutter Docs (flutter.dev, free)','🎬 Flutter Official Channel (YouTube)']),
        CareerPhase(id:3,title:'State Management',subtitle:'Riverpod, Provider, BLoC',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹6–10 LPA / \$55K',topics:['setState limitations','Provider package','Riverpod (recommended): StateProvider, FutureProvider, StreamProvider','BLoC pattern with flutter_bloc','ChangeNotifier & ListenableBuilder','Reactive UI patterns'],tools:['Riverpod','flutter_bloc','Provider'],project:'Build a habit tracker with Riverpod state management',resources:['📘 Riverpod.dev Docs (free)','📘 BLoC Library Docs (free)']),
        CareerPhase(id:4,title:'Firebase & Backend',subtitle:'Auth, Firestore, Storage, FCM',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–11 LPA / \$60K',topics:['Firebase Auth (email, Google, Apple Sign-in)','Cloud Firestore real-time listeners','Firebase Storage (images/videos)','Cloud Functions basics','Firebase Remote Config & A/B Testing','Push Notifications (FCM)','Firestore Security Rules'],tools:['Firebase Console','FlutterFire','Cloud Functions'],project:'Build a real-time social feed app with Firebase',resources:['📘 FlutterFire Docs (free)','📘 Firebase Codelab (free)']),
        CareerPhase(id:5,title:'Advanced UI & Animations',subtitle:'Custom widgets, animations, theming',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹8–13 LPA / \$65K',topics:['AnimationController & Tween','Implicit animations (AnimatedContainer)','Hero animations','CustomPainter & Canvas API','flutter_animate package','Custom scrolling (Slivers)','Glassmorphism & neumorphism','Responsive design (LayoutBuilder, MediaQuery)','Dark/light theme switching'],tools:['flutter_animate','Lottie','Rive'],project:'Build a fintech dashboard with custom charts and premium animations',resources:['📘 Flutter Animations Docs (free)','📘 Flutter Rive integration guide']),
        CareerPhase(id:6,title:'Local Data & Offline',subtitle:'Hive, Drift, SharedPrefs',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹8–12 LPA / \$65K',topics:['SharedPreferences for user settings','Hive for fast local NoSQL storage','Drift (SQLite) for relational local DB','Offline-first architecture patterns','Data sync with Firestore','Secure storage (flutter_secure_storage)'],tools:['Hive','Drift','flutter_secure_storage'],project:'Build a journaling app that works fully offline with sync',resources:['📘 Hive Docs (free)','📘 Drift Docs (free)']),
        CareerPhase(id:7,title:'Platform Integrations',subtitle:'Camera, maps, sensors, platform channels',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹9–15 LPA / \$68K',topics:['Camera & image picker','Location & Google Maps','Biometric authentication','Platform channels (MethodChannel)','Background services','Deep linking','In-app purchases','URL launcher'],tools:['google_maps_flutter','geolocator','local_auth'],project:'Build a fitness tracking app with GPS, camera, and health data',resources:['📘 Flutter Package Docs on pub.dev']),
        CareerPhase(id:8,title:'Testing Flutter Apps',subtitle:'Unit, widget, integration',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹9–14 LPA / \$70K',topics:['flutter_test fundamentals','Widget tests with find, tap, expect','Mocking with Mockito','Integration tests with patrol','Golden tests (screenshot testing)','CI testing with GitHub Actions','Code coverage reports'],tools:['flutter_test','Mockito','Patrol','GitHub Actions'],project:'Achieve 80%+ coverage on a medium Flutter project',resources:['📘 Flutter Testing Docs (free)']),
        CareerPhase(id:9,title:'Publishing & CI/CD',subtitle:'Play Store, App Store, Fastlane',duration:'2–3 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹10–18 LPA / \$72K',topics:['Android signing: keystore, upload key','iOS: provisioning profiles, certificates','App store listing optimisation (ASO)','Fastlane automation','Codemagic CI/CD','Version management & changelogs','Crash reporting (Firebase Crashlytics)'],tools:['Fastlane','Codemagic','Google Play Console','App Store Connect'],project:'Set up automated deployment pipeline for a Flutter app',resources:['📘 Flutter Deployment Docs (free)','📘 Fastlane Docs (free)']),
        CareerPhase(id:10,title:'Interview & Job Ready',subtitle:'Portfolio, Flutter interviews',duration:'3–4 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹10–25 LPA / \$80K+',topics:['3 published Flutter apps in portfolio','Flutter-specific interview questions','Architecture discussions (clean arch, MVVM)','Performance optimisation questions','Open-source Flutter contributions','Coding challenge prep (Dart DSA)'],tools:['LeetCode (Dart)','GitHub'],project:'3 published apps + contribute to a Flutter open-source package',resources:['📘 Flutter Interview Questions (GitHub, free)']),
      ],
    ),
    CareerData(
      id:'game_dev', title:'Game Developer',
      emoji:'🎮', tagline:'Build 2D/3D games and interactive experiences',
      level:'Beginner', skills:['Unity/Unreal','C#/C++','Game Design','Physics','3D Maths'],
      phases: [
        CareerPhase(id:1,title:'Programming for Games',subtitle:'C# or C++ fundamentals',duration:'4–6 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹2–4 LPA / \$35K',topics:['C# (Unity) or C++ (Unreal)','OOP: classes, inheritance, polymorphism','Variables, loops, functions','Arrays, lists, dictionaries','File I/O','Basic algorithms'],tools:['Visual Studio','Unity / Unreal'],project:'Build a text-based adventure game in C# or C++',resources:['📘 C# Docs — Microsoft (free)','📘 Learn Unreal C++ (free)']),
        CareerPhase(id:2,title:'Game Engine Fundamentals',subtitle:'Unity or Unreal basics',duration:'6–8 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹3–6 LPA / \$40K',topics:['Scene hierarchy','GameObjects & components (Unity) / Actors (Unreal)','Transform: position, rotation, scale','Physics: Rigidbody, colliders','Scripting: MonoBehaviour lifecycle','Input system','Prefabs & asset organisation','Camera control'],tools:['Unity 2023 LTS','Unreal Engine 5'],project:'Build a 2D platformer with player movement, jump, and enemies',resources:['📘 Unity Learn (free)','📘 Unreal Online Learning (free)']),
        CareerPhase(id:3,title:'2D Game Development',subtitle:'Sprites, tilemaps, animations',duration:'6–8 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹4–8 LPA / \$45K',topics:['2D physics','Sprite atlas & animation controller','Tilemap & tileset','Particle systems','2D lighting','UI for games (Canvas)','Scene management','Save system'],tools:['Unity 2D','Aseprite','TextMeshPro'],project:'Build a complete 2D top-down RPG with combat and inventory',resources:['📘 Brackeys Unity 2D (YouTube, free)','📘 Unity 2D Docs']),
        CareerPhase(id:4,title:'3D Game Development',subtitle:'Models, shaders, lighting',duration:'8–10 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹5–10 LPA / \$55K',topics:['3D transforms & hierarchy','Mesh, material, shader basics','Lighting: directional, point, spot, baked','NavMesh & pathfinding','Animator & blend trees','Character Controller','LOD (Level of Detail)','Cinemachine cameras'],tools:['Unity 3D / Unreal 5','Blender','Shader Graph'],project:'Build a 3D third-person adventure game',resources:['📘 Unity Manual (free)','📘 Unreal Docs (free)','🎬 Code Monkey (YouTube)']),
        CareerPhase(id:5,title:'Game AI & Physics',subtitle:'Enemy AI, physics, pathfinding',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹6–12 LPA / \$60K',topics:['Finite state machines for enemy AI','NavMesh & A* pathfinding','Behaviour trees','Physics joints & constraints','Ragdoll physics','Procedural generation basics','Particle FX for gameplay','Audio system'],tools:['Unity AI','Unreal AI','A* Pathfinding Project'],project:'Build a tower defence game with smart enemy pathfinding and AI',resources:['📘 Game AI Pro (free chapters)','📘 Sebastian Lague Pathfinding (YouTube)']),
        CareerPhase(id:6,title:'Multiplayer & Networking',subtitle:'Online games, sync, latency',duration:'5–6 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹7–14 LPA / \$65K',topics:['Client-server vs peer-to-peer','Unity Netcode for GameObjects','Photon PUN / Mirror','State synchronisation','Lag compensation','Lobby & matchmaking','Cheating prevention','Server authoritative design'],tools:['Photon PUN','Unity Netcode','Mirror'],project:'Build an online multiplayer mini-game with 4 players',resources:['📘 Unity Multiplayer Docs (free)','📘 Photon Docs (free)']),
        CareerPhase(id:7,title:'Performance & Optimisation',subtitle:'Profiling, batching, memory',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹8–14 LPA / \$68K',topics:['Unity Profiler & Frame Debugger','Draw call batching & GPU instancing','Texture compression & atlasing','Object pooling','Memory management','LOD and occlusion culling','Mobile-specific optimisation','Target frame rates'],tools:['Unity Profiler','RenderDoc','Instruments (iOS)'],project:'Optimise a game from 20 FPS to 60 FPS on a mid-range phone',resources:['📘 Unity Performance Best Practices (free)']),
        CareerPhase(id:8,title:'Game Monetisation & Publishing',subtitle:'Ads, IAP, app stores',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹8–16 LPA / \$70K',topics:['In-app purchases (IAP)','Ad integration (AdMob, Unity Ads)','Play Store / App Store submission','PC (Steam) submission','Achievement systems','Analytics (Firebase / GameAnalytics)','User acquisition basics'],tools:['Google Play Console','Unity Ads','AdMob','Steam'],project:'Publish a mobile game to Play Store with ads and basic analytics',resources:['📘 Unity Monetisation Docs (free)']),
        CareerPhase(id:9,title:'Portfolio & Game Jam',subtitle:'3 games, Itch.io, Global Game Jam',duration:'4–6 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹8–18 LPA / \$75K',topics:['Participate in 2 game jams (Ludum Dare, Global Game Jam)','3 portfolio games on Itch.io','Game design documents','Trailers & screenshots','Open-source a project','Game dev blog or devlog on YouTube'],tools:['Itch.io','GitHub','OBS'],project:'Participate in Ludum Dare and ship a game in 48 hours',resources:['📘 Ludum Dare (free)','📘 Itch.io game jam list']),
        CareerPhase(id:10,title:'Interview & Job Ready',subtitle:'Portfolio review, studio prep',duration:'3–5 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹10–25 LPA / \$80K+',topics:['Game studio interview preparation','Technical art interviews','Gameplay programming questions','DSA in C# or C++','Portfolio critique sessions','Internship vs junior roles','Freelance game development'],tools:['LeetCode (C++)','Pramp'],project:'3 portfolio games + 5 mock interviews',resources:['📘 Gamer Multiplied Game Dev Interviews']),
      ],
    ),
  ],
);

// ──────────────────────────────────────────────────────────────────────
// 2. AI & DATA
// ──────────────────────────────────────────────────────────────────────
const _aiData = CareerCategory(
  id:    'ai_data',
  title: 'AI & Data',
  emoji: '🤖',
  color: Color(0xFFA78BFA),
  careers: [
    CareerData(
      id:'ai_engineer', title:'AI Engineer',
      emoji:'🤖', tagline:'Build and deploy AI-powered products',
      level:'Intermediate', skills:['Python','LLMs','LangChain','FastAPI','Docker'],
      phases: [
        CareerPhase(id:1,title:'Python & Programming Foundations',subtitle:'Python mastery for AI',duration:'3–4 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹3–5 LPA / \$40K',topics:['Python OOP, decorators, generators','NumPy, Pandas','Virtual environments & pip','Git & GitHub','Jupyter Notebooks','Type hints'],tools:['Python 3.11+','VS Code','Jupyter'],project:'Build a CLI data analyser on a Kaggle CSV dataset',resources:['📘 CS50P — Harvard (free)','📘 Python.org Docs (free)']),
        CareerPhase(id:2,title:'Mathematics for AI',subtitle:'Linear algebra, calculus, stats',duration:'4–5 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹4–6 LPA / \$45K',topics:['Linear algebra: vectors, matrices, eigenvalues','Calculus: derivatives, chain rule, gradient descent','Statistics: distributions, hypothesis testing','Probability: Bayes theorem','NumPy for maths','Matplotlib for visualisation'],tools:['NumPy','Matplotlib','Khan Academy'],project:'Implement PCA from scratch and visualise MNIST clusters',resources:['📘 Mathematics for ML (free PDF)','🎬 3Blue1Brown Linear Algebra (YouTube)']),
        CareerPhase(id:3,title:'Machine Learning Fundamentals',subtitle:'Supervised, unsupervised, evaluation',duration:'6–8 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹6–10 LPA / \$65K',topics:['Linear/logistic regression','Decision trees, random forests, XGBoost','K-means, DBSCAN','Cross-validation, bias-variance','Precision, recall, F1, ROC-AUC','Feature engineering','Hyperparameter tuning with Optuna'],tools:['Scikit-learn','XGBoost','Kaggle'],project:'Win a Kaggle Playground competition (top 20%)',resources:['📘 ML Specialization — Andrew Ng (Coursera)','📘 Hands-On ML — Géron']),
        CareerPhase(id:4,title:'Deep Learning',subtitle:'Neural networks, CNNs, PyTorch',duration:'6–8 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹10–16 LPA / \$90K',topics:['Feedforward networks (backprop from scratch)','CNNs: ResNet, EfficientNet','RNNs, LSTMs','PyTorch training loops','W&B experiment tracking','Transfer learning','Mixed precision (fp16/bf16)'],tools:['PyTorch','W&B','CUDA'],project:'Train ResNet-50 on custom dataset, deploy as REST API',resources:['📘 Deep Learning Specialization — DeepLearning.AI','📘 fast.ai (free)']),
        CareerPhase(id:5,title:'LLMs & Prompt Engineering',subtitle:'GPT, Claude, LangChain, RAG',duration:'6–8 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹14–22 LPA / \$120K',topics:['GPT/Claude/Gemini APIs','Prompt engineering: CoT, few-shot, ReAct','LangChain & LlamaIndex','RAG: embeddings, vector DBs (Pinecone, ChromaDB)','Fine-tuning with LoRA/QLoRA','Function calling & tool use','LLM evaluation (ROUGE, BERTScore)'],tools:['OpenAI API','Anthropic API','LangChain','Pinecone'],project:'Build a RAG-powered AI assistant on your own documents',resources:['📘 Full Stack LLM Bootcamp (free)','📘 LLM Course — Maxime Labonne (GitHub, free)']),
        CareerPhase(id:6,title:'AI Product Development',subtitle:'FastAPI, Streamlit, deployment',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹16–26 LPA / \$130K',topics:['FastAPI for ML APIs','Streamlit for rapid prototyping','Docker containerisation','Cloud deployment (AWS/GCP/Modal)','Async API handling','Rate limiting & auth for AI APIs','Error handling & fallbacks'],tools:['FastAPI','Streamlit','Docker','Modal'],project:'Deploy a full AI-powered web app with authentication',resources:['📘 FastAPI Docs (free)','📘 Modal Labs Docs (free)']),
        CareerPhase(id:7,title:'AI Agents & Automation',subtitle:'LangGraph, AutoGen, tools',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹18–30 LPA / \$150K',topics:['AI agent architecture','LangGraph for stateful agents','CrewAI multi-agent systems','Tool use & function calling','Memory: short-term, long-term, episodic','Agentic RAG','Evaluation of agents','Browser automation agents'],tools:['LangGraph','CrewAI','Playwright','E2B'],project:'Build an autonomous research agent that compiles reports',resources:['📘 DeepLearning.AI Agent Courses (free)','📘 LangChain Docs (free)']),
        CareerPhase(id:8,title:'MLOps & AI Infrastructure',subtitle:'Model serving, monitoring, CI/CD',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹18–32 LPA / \$155K',topics:['Model serving: FastAPI, vLLM, Triton','Docker + Kubernetes basics','MLflow & W&B model registry','Data drift monitoring (Evidently)','CI/CD for ML (GitHub Actions + DVC)','Distributed training basics','Cost optimisation for inference'],tools:['MLflow','W&B','Docker','Evidently'],project:'Deploy ML model with monitoring and auto-scaling on AWS',resources:['📘 MLOps Zoomcamp (free)','📘 Made With ML (free)']),
        CareerPhase(id:9,title:'Portfolio & Open Source',subtitle:'Projects, HuggingFace, GitHub',duration:'4–6 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹20–40 LPA / \$160K',topics:['3 deployed AI projects','HuggingFace Spaces deployment','Blog posts on Substack/Medium','Open-source contributions','Kaggle profile: Expert tier','LinkedIn AI profile optimisation','Build in public on X/LinkedIn'],tools:['HuggingFace Spaces','GitHub','Streamlit','Kaggle'],project:'Deploy 3 AI apps on HuggingFace Spaces with 100+ users',resources:['📘 Eugene Yan Applied ML Blog (free)']),
        CareerPhase(id:10,title:'Interview Mastery',subtitle:'ML coding, system design, research',duration:'4–5 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹25–60 LPA+ / \$180K+',topics:['LeetCode Medium/Hard — 50 problems','ML system design (feature stores, training, serving)','LLM architecture questions','ML fundamentals Q&A','Take-home ML assignment best practices','Salary negotiation for AI roles','STAR behavioural answers'],tools:['LeetCode','Pramp','Interviewing.io'],project:'5 mock interviews + apply to 20+ AI companies',resources:['📘 Chip Huyen ML Interviews (GitHub, free)','📘 Grokking ML Interview']),
      ],
    ),
    CareerData(
      id:'data_scientist', title:'Data Scientist',
      emoji:'📊', tagline:'Extract insights from data to drive decisions',
      level:'Beginner', skills:['Python','SQL','Statistics','ML','Tableau'],
      phases: [
        CareerPhase(id:1,title:'Python for Data Science',subtitle:'Pandas, NumPy, Matplotlib',duration:'4–5 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹4–7 LPA / \$50K',topics:['Python basics','NumPy arrays & broadcasting','Pandas: DataFrames, groupby, merge, pivot','Matplotlib & Seaborn visualisations','Data cleaning: missing values, outliers','Jupyter Notebook workflows'],tools:['Python','Pandas','Matplotlib','Seaborn','Jupyter'],project:'Analyse the Titanic dataset: clean, visualise, and extract 10 insights',resources:['📘 Kaggle Python & Pandas (free)','📘 Python Data Science Handbook (free)']),
        CareerPhase(id:2,title:'SQL for Data Analysis',subtitle:'Queries, aggregations, window functions',duration:'3–4 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹5–8 LPA / \$55K',topics:['SELECT, WHERE, GROUP BY, HAVING','JOINs: inner, left, right, full','Subqueries & CTEs','Window functions: ROW_NUMBER, RANK, LAG, LEAD','Index basics','Query optimisation'],tools:['PostgreSQL','BigQuery','Mode Analytics'],project:'Answer 20 business questions from a retail dataset using SQL',resources:['📘 Mode SQL Tutorial (free)','📘 SQLZoo (free)']),
        CareerPhase(id:3,title:'Statistics & Probability',subtitle:'Hypothesis testing, distributions',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹6–10 LPA / \$60K',topics:['Descriptive statistics','Probability distributions','Central Limit Theorem','Hypothesis testing (t-test, chi-square, ANOVA)','A/B testing design','Confidence intervals','Bayesian thinking','p-values and their limitations'],tools:['SciPy','StatsModels','Pingouin'],project:'Design and analyse an A/B test for a hypothetical product feature',resources:['📘 StatQuest — Josh Starmer (YouTube, free)','📘 Think Stats (free)']),
        CareerPhase(id:4,title:'Machine Learning for Data Science',subtitle:'Predictive models, feature engineering',duration:'6–8 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹8–14 LPA / \$70K',topics:['Linear/logistic regression','Tree models: decision trees, random forests, XGBoost','Unsupervised: k-means, hierarchical','Feature engineering & selection','Cross-validation & hyperparameter tuning','Imbalanced datasets (SMOTE)','Model explainability (SHAP)'],tools:['Scikit-learn','XGBoost','SHAP','Optuna'],project:'Build and deploy a churn prediction model for a telecom dataset',resources:['📘 Kaggle ML Courses (free)','📘 ML Specialization — Andrew Ng']),
        CareerPhase(id:5,title:'Data Visualisation & Storytelling',subtitle:'Dashboards, Tableau, Plotly',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹8–13 LPA / \$65K',topics:['Tableau Desktop & Public','Power BI basics','Plotly & Dash for interactive charts','Effective data storytelling principles','Dashboard design','Choosing the right chart type','Stakeholder communication'],tools:['Tableau','Power BI','Plotly Dash'],project:'Build an executive sales dashboard in Tableau with 5 KPIs',resources:['📘 Tableau Public Gallery (free)','📘 Storytelling with Data — Cole Nussbaumer']),
        CareerPhase(id:6,title:'Big Data & Cloud',subtitle:'Spark, BigQuery, cloud pipelines',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹10–18 LPA / \$80K',topics:['Apache Spark (PySpark)','Google BigQuery / AWS Athena','Distributed computing basics','Data lake vs data warehouse','ETL pipeline design','Cloud storage (S3, GCS)','Airflow basics'],tools:['PySpark','BigQuery','Airflow','dbt'],project:'Build a PySpark pipeline that processes 10GB+ of data',resources:['📘 Learning Spark — O\'Reilly','📘 BigQuery Docs (free)']),
        CareerPhase(id:7,title:'Deep Learning & NLP for DS',subtitle:'Time series, text, neural nets',duration:'5–6 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹12–20 LPA / \$90K',topics:['Time series forecasting (LSTM, Prophet, N-BEATS)','NLP: sentiment analysis, text classification','HuggingFace Transformers for NLP tasks','Computer vision basics for DS','Anomaly detection','Recommendation systems (collaborative filtering)'],tools:['PyTorch','HuggingFace','Prophet','Nixtla'],project:'Build a sales forecasting model for a retail dataset',resources:['📘 HuggingFace NLP Course (free)','📘 fast.ai (free)']),
        CareerPhase(id:8,title:'Experimentation & Causal Inference',subtitle:'A/B tests, causal ML',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹12–22 LPA / \$95K',topics:['Advanced A/B testing (sequential, Bayesian)','Causal inference (difference-in-differences, IV)','Uplift modelling','Multi-armed bandits','Synthetic control methods','Observational study methods'],tools:['DoWhy','EconML','pymc3'],project:'Analyse a quasi-experiment dataset using causal inference methods',resources:['📘 Causal Inference: The Mixtape (free)','📘 DoWhy Docs (free)']),
        CareerPhase(id:9,title:'Portfolio & Communication',subtitle:'Projects, blog, stakeholder skills',duration:'4–5 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹14–25 LPA / \$100K',topics:['3 end-to-end data science projects','Kaggle competitions: Expert tier','Technical blog posts (Towards Data Science)','Business communication for non-technical stakeholders','LinkedIn data science profile','GitHub portfolio README'],tools:['Kaggle','GitHub','Tableau Public','Medium'],project:'Publish a complete end-to-end project with business impact analysis',resources:['📘 Towards Data Science (Medium)','📘 Data Science Portfolio Guide (GitHub)']),
        CareerPhase(id:10,title:'Interview Mastery',subtitle:'Statistics, SQL, case studies, ML',duration:'4–5 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹15–35 LPA+ / \$100K+',topics:['Statistics interview questions','SQL hard problems (LeetCode)','ML fundamentals Q&A','Product analytics case studies','Data intuition questions','Behavioural: impact stories','Salary negotiation'],tools:['LeetCode','Stratascratch (SQL)','Pramp'],project:'5 mock interviews + 10 SQL hard problems on Stratascratch',resources:['📘 Ace the Data Science Interview book','📘 Stratascratch (free + paid)']),
      ],
    ),
    CareerData(
      id:'mlops_engineer', title:'MLOps Engineer',
      emoji:'⚙️', tagline:'Build ML infrastructure and deployment pipelines',
      level:'Intermediate', skills:['Python','Docker','Kubernetes','MLflow','AWS/GCP'],
      phases: [
        CareerPhase(id:1,title:'Python & ML Fundamentals',subtitle:'For MLOps context',duration:'4–5 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹5–8 LPA / \$55K',topics:['Python scripting','ML model training lifecycle','Scikit-learn model training','Model serialisation (pickle, joblib)','Basic REST API with FastAPI','Git & branching workflows'],tools:['Python','Scikit-learn','FastAPI','Git'],project:'Train and serialise an ML model, serve it via FastAPI',resources:['📘 Made With ML (free)','📘 FastAPI Docs (free)']),
        CareerPhase(id:2,title:'Docker & Containerisation',subtitle:'Container fundamentals',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–11 LPA / \$65K',topics:['Docker: images, containers, Dockerfile','docker-compose for local dev','Multi-stage builds for ML images','GPU containers (nvidia-docker)','Container registries (ECR, GCR)','Best practices: non-root, .dockerignore'],tools:['Docker','Docker Compose','NVIDIA Container Toolkit'],project:'Containerise an ML training + serving pipeline with docker-compose',resources:['📘 Docker Docs (free)','📘 Docker for Data Scientists (YouTube)']),
        CareerPhase(id:3,title:'CI/CD for Machine Learning',subtitle:'GitHub Actions, DVC, automated pipelines',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹9–14 LPA / \$75K',topics:['GitHub Actions for ML workflows','Data Version Control (DVC)','Automated model training triggers','Code quality: linting, formatting, type checking','Model testing in CI','Artifact management','Environment reproducibility'],tools:['GitHub Actions','DVC','pytest','MLflow'],project:'Build a CI pipeline that trains, tests, and registers a model automatically',resources:['📘 DVC Docs (free)','📘 Made With ML CI/CD chapter (free)']),
        CareerPhase(id:4,title:'Experiment Tracking & Model Registry',subtitle:'MLflow, W&B, model versioning',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹10–16 LPA / \$80K',topics:['MLflow: tracking, projects, models, registry','Weights & Biases: experiments, sweeps, artifacts','Hyperparameter optimisation tracking','Model comparison and selection','Model staging (Staging → Production)','Metadata and lineage tracking'],tools:['MLflow','W&B','Optuna'],project:'Build a complete experiment tracking system for 10+ model experiments',resources:['📘 MLflow Docs (free)','📘 W&B Docs (free)']),
        CareerPhase(id:5,title:'Model Serving & Inference',subtitle:'FastAPI, Triton, vLLM, BentoML',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹12–20 LPA / \$90K',topics:['REST serving with FastAPI','gRPC serving basics','NVIDIA Triton Inference Server','vLLM for LLM serving','BentoML for packaging','Model quantisation (INT8, FP16)','Batching strategies','Latency vs throughput trade-offs'],tools:['Triton','vLLM','BentoML','TorchServe'],project:'Serve a model with Triton achieving <100ms p99 latency',resources:['📘 Triton Docs (free)','📘 vLLM Docs (free)']),
        CareerPhase(id:6,title:'Kubernetes for ML',subtitle:'GPU scheduling, Helm, KFServing',duration:'5–6 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹14–22 LPA / \$100K',topics:['Kubernetes: pods, deployments, services, ingress','GPU scheduling (NVIDIA device plugin)','Helm charts for ML services','Horizontal pod autoscaling','KubeFlow Pipelines basics','Resource requests/limits for GPU workloads','Kubernetes operators'],tools:['Kubernetes','Helm','KubeFlow','kubectl'],project:'Deploy an ML service on Kubernetes with GPU support and HPA',resources:['📘 Kubernetes Docs (free)','📘 KubeFlow Docs (free)']),
        CareerPhase(id:7,title:'Cloud ML Platforms',subtitle:'SageMaker, Vertex AI, Azure ML',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹16–26 LPA / \$110K',topics:['AWS SageMaker: training jobs, endpoints, pipelines','Google Vertex AI: custom training, model registry','Azure Machine Learning','Managed feature stores (Feast, Tecton)','Cloud cost optimisation','Spot/preemptible instance strategies','Data pipelines: Dataflow, Glue'],tools:['SageMaker','Vertex AI','Feast'],project:'Build an end-to-end ML pipeline on SageMaker or Vertex AI',resources:['📘 AWS ML Learning Path (free)','📘 Vertex AI Docs (free)']),
        CareerPhase(id:8,title:'Monitoring & Observability',subtitle:'Data drift, model decay, alerting',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹15–24 LPA / \$105K',topics:['Data drift detection (Evidently, WhyLabs)','Model performance monitoring','Concept drift & retraining triggers','Logging (ELK stack basics)','Prometheus + Grafana for ML metrics','Alerting on model degradation','Shadow deployment testing'],tools:['Evidently','Grafana','Prometheus','WhyLabs'],project:'Set up model monitoring with automated alerting for a production model',resources:['📘 Evidently Docs (free)','📘 ML Observability in Practice']),
        CareerPhase(id:9,title:'Feature Engineering at Scale',subtitle:'Feature stores, pipelines, serving',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹16–28 LPA / \$115K',topics:['Feature store architecture','Feast setup and usage','Online vs offline feature serving','Feature transformation pipelines','Point-in-time correctness','Feature discovery and reuse'],tools:['Feast','Tecton','Redis','Apache Flink'],project:'Build a feature store for a recommendation system',resources:['📘 Feast Docs (free)','📘 Building ML Powered Applications (O\'Reilly)']),
        CareerPhase(id:10,title:'Interview & Job Ready',subtitle:'System design, coding, MLOps',duration:'3–5 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹18–40 LPA+ / \$130K+',topics:['ML system design interviews','MLOps-specific technical questions','LeetCode Medium — 40 problems','Distributed systems fundamentals','Infrastructure cost estimation','Behavioural: production incident stories'],tools:['LeetCode','Pramp'],project:'5 mock MLOps design interviews + apply to 20 companies',resources:['📘 Made With ML Interview Prep (free)','📘 Chip Huyen ML Interviews']),
      ],
    ),
  ],
);

// ──────────────────────────────────────────────────────────────────────
// 3. CLOUD & DEVOPS
// ──────────────────────────────────────────────────────────────────────
const _cloudDevops = CareerCategory(
  id:    'cloud_devops',
  title: 'Cloud & DevOps',
  emoji: '☁️',
  color: Color(0xFF4ADE80),
  careers: [
    CareerData(
      id:'devops_engineer', title:'DevOps Engineer',
      emoji:'🔄', tagline:'Automate, deploy, and monitor systems at scale',
      level:'Intermediate', skills:['Linux','Docker','Kubernetes','CI/CD','Terraform'],
      phases: [
        CareerPhase(id:1,title:'Linux & Scripting',subtitle:'Commands, bash, networking',duration:'4–5 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹4–7 LPA / \$50K',topics:['Linux file system & permissions','Bash scripting','Process management','Networking: TCP/IP, DNS, SSH','Cron jobs & automation','Log analysis','Package management (apt, yum)'],tools:['Ubuntu','Bash','SSH'],project:'Write a bash script that automates server health monitoring',resources:['📘 Linux Journey (free)','📘 The Linux Command Line (free)']),
        CareerPhase(id:2,title:'Git & CI/CD Fundamentals',subtitle:'Version control and pipelines',duration:'3–4 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹5–8 LPA / \$55K',topics:['Git branching strategies (GitFlow, trunk-based)','GitHub Actions: workflows, jobs, steps','Jenkins basics','Pipeline as code','Automated testing in CI','Artifact storage','Environment-based pipelines'],tools:['Git','GitHub Actions','Jenkins'],project:'Build a CI pipeline that tests and deploys a web app automatically',resources:['📘 GitHub Actions Docs (free)','📘 Jenkins Docs (free)']),
        CareerPhase(id:3,title:'Docker & Containerisation',subtitle:'Build, run, orchestrate containers',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–11 LPA / \$65K',topics:['Dockerfile best practices','Multi-stage builds','Docker Compose','Container networking','Volume management','Container security','Registry (ECR, GCR, Docker Hub)'],tools:['Docker','Docker Compose','Trivy (security scanning)'],project:'Containerise a microservices app with Docker Compose',resources:['📘 Docker Docs (free)','📘 Play with Docker (free)']),
        CareerPhase(id:4,title:'Kubernetes',subtitle:'Orchestration at production scale',duration:'6–8 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹10–16 LPA / \$80K',topics:['Pods, Deployments, Services, Ingress','ConfigMaps & Secrets','Persistent Volumes','HPA & VPA (auto-scaling)','Helm charts','RBAC & security','Namespaces','Monitoring with Prometheus'],tools:['Kubernetes','Helm','kubectl','Prometheus'],project:'Deploy a 3-tier app on Kubernetes with HPA and Helm chart',resources:['📘 Kubernetes Docs (free)','📘 Kubernetes The Hard Way (free)']),
        CareerPhase(id:5,title:'Infrastructure as Code',subtitle:'Terraform, Ansible',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹11–18 LPA / \$85K',topics:['Terraform: providers, resources, state, modules','Terraform Cloud & remote state','Ansible playbooks & roles','Configuration management','Immutable infrastructure','GitOps principles'],tools:['Terraform','Ansible','Terragrunt'],project:'Provision complete AWS infrastructure with Terraform (VPC, EC2, RDS)',resources:['📘 Terraform Docs (free)','📘 HashiCorp Learn (free)']),
        CareerPhase(id:6,title:'Cloud Platforms (AWS/GCP/Azure)',subtitle:'Core services, certifications',duration:'5–6 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹13–22 LPA / \$95K',topics:['AWS: EC2, VPC, S3, RDS, Lambda, EKS, IAM','Cloud networking & security groups','Auto Scaling Groups','CDN (CloudFront)','Serverless (Lambda, Cloud Run)','Cost optimisation','Cloud certifications (AWS SAA, GCP ACE)'],tools:['AWS','GCP','Azure','AWS CLI'],project:'Design and deploy a highly available 3-tier AWS architecture',resources:['📘 AWS Free Tier + Tutorials','📘 A Cloud Guru']),
        CareerPhase(id:7,title:'Monitoring & Observability',subtitle:'Metrics, logs, traces',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹14–24 LPA / \$100K',topics:['Prometheus metrics collection','Grafana dashboards','ELK stack (Elasticsearch, Logstash, Kibana)','Distributed tracing (Jaeger, OpenTelemetry)','Alerting (PagerDuty, OpsGenie)','SLO, SLI, SLA definitions','Incident response process'],tools:['Prometheus','Grafana','ELK','Jaeger'],project:'Set up full observability stack for a microservices app',resources:['📘 Prometheus Docs (free)','📘 Google SRE Book (free)']),
        CareerPhase(id:8,title:'Security (DevSecOps)',subtitle:'Security scanning, secrets, compliance',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹14–25 LPA / \$105K',topics:['SAST & DAST scanning in CI','Secrets management (Vault, AWS Secrets Manager)','Container security (Trivy, Falco)','Network policies in Kubernetes','OWASP DevSecOps','Compliance as Code (OPA)','Vulnerability management'],tools:['HashiCorp Vault','Trivy','Falco','OPA'],project:'Add security scanning to a CI pipeline: SAST, container scan, secret detection',resources:['📘 OWASP DevSecOps Guideline (free)','📘 Snyk Learn (free)']),
        CareerPhase(id:9,title:'Platform Engineering',subtitle:'Internal developer platforms, golden paths',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹16–28 LPA / \$115K',topics:['Internal developer platforms (Backstage)','Golden path templates','Service catalogue','ArgoCD & GitOps','Crossplane for cloud resources','Developer experience (DX) metrics','On-call engineering'],tools:['Backstage','ArgoCD','Crossplane','Argo Workflows'],project:'Build a developer platform with Backstage and ArgoCD for GitOps',resources:['📘 Backstage Docs (free)','📘 ArgoCD Docs (free)']),
        CareerPhase(id:10,title:'Interview & Job Ready',subtitle:'Technical + behavioural + system design',duration:'3–5 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹18–40 LPA+ / \$130K+',topics:['DevOps system design interviews','Kubernetes troubleshooting scenarios','Terraform interview questions','Incident post-mortem walkthroughs','SRE vs DevOps distinction','CKA exam prep','Salary negotiation'],tools:['LeetCode (bash)','KodeKloud','Linux Foundation'],project:'Pass CKA or AWS SAA exam + 5 mock DevOps interviews',resources:['📘 KodeKloud (paid)','📘 CKA Study Guide (GitHub, free)']),
      ],
    ),
    CareerData(
      id:'cloud_engineer', title:'Cloud Engineer',
      emoji:'☁️', tagline:'Design and manage cloud infrastructure',
      level:'Beginner', skills:['AWS/GCP/Azure','Terraform','Networking','Security','Python'],
      phases: [
        CareerPhase(id:1,title:'Cloud Fundamentals',subtitle:'Shared responsibility, core services',duration:'3–4 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹4–7 LPA / \$50K',topics:['Cloud computing models (IaaS, PaaS, SaaS)','Shared responsibility model','AWS/GCP/Azure core services overview','Cloud regions & availability zones','Billing & cost management','IAM fundamentals','Getting cloud certified (Practitioner level)'],tools:['AWS Free Tier','GCP Free Tier','Azure Free Tier'],project:'Deploy a static website on S3 with CloudFront CDN',resources:['📘 AWS Cloud Practitioner Essentials (free)','📘 A Cloud Guru']),
        CareerPhase(id:2,title:'Networking in the Cloud',subtitle:'VPC, subnets, security groups',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹6–10 LPA / \$60K',topics:['VPC design: subnets, route tables, gateways','Security groups vs NACLs','VPC Peering & Transit Gateway','VPN & Direct Connect','DNS with Route 53','Load balancers (ALB, NLB)','NAT Gateway'],tools:['AWS VPC','Route 53','CloudWatch'],project:'Design a 3-tier VPC with public, private, and DB subnets',resources:['📘 AWS Networking Fundamentals (free)','📘 Cloud Networking Docs']),
        CareerPhase(id:3,title:'Compute & Storage',subtitle:'EC2, Lambda, S3, EBS, EFS',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–12 LPA / \$65K',topics:['EC2: instance types, AMIs, auto-scaling','Lambda & serverless architecture','S3: storage classes, lifecycle policies, replication','EBS, EFS, FSx','RDS & Aurora managed databases','Elasticache','EC2 Spot instances for cost savings'],tools:['AWS EC2','Lambda','S3','RDS'],project:'Build a serverless image processing pipeline with Lambda and S3',resources:['📘 AWS Compute Learning Path (free)','📘 Serverless Land (free)']),
        CareerPhase(id:4,title:'Infrastructure as Code',subtitle:'Terraform, CloudFormation',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹9–14 LPA / \$75K',topics:['Terraform HCL fundamentals','State management & remote backends','Terraform modules','CloudFormation / ARM Templates','CDK (AWS Cloud Development Kit)','Drift detection','IaC testing with Terratest'],tools:['Terraform','CloudFormation','CDK'],project:'Provision a complete 3-tier architecture with Terraform modules',resources:['📘 Terraform Docs (free)','📘 HashiCorp Learn (free)']),
        CareerPhase(id:5,title:'Security & Compliance',subtitle:'IAM, encryption, compliance',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹11–18 LPA / \$85K',topics:['IAM: roles, policies, conditions','AWS Organizations & SCPs','KMS encryption key management','AWS Security Hub & GuardDuty','Config & Compliance rules','CloudTrail for audit logging','Secrets Manager & Parameter Store'],tools:['AWS IAM','KMS','GuardDuty','Security Hub'],project:'Implement a security baseline for an AWS account with automated compliance checks',resources:['📘 AWS Security Learning Path (free)','📘 NIST Cloud Security Guide']),
        CareerPhase(id:6,title:'Container Services',subtitle:'EKS, ECS, Fargate',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹12–20 LPA / \$90K',topics:['Amazon ECS: task definitions, services','Amazon EKS: managed Kubernetes','AWS Fargate (serverless containers)','ECR container registry','Service mesh (App Mesh, Istio)','Container security scanning','Multi-region container strategies'],tools:['EKS','ECS','Fargate','ECR'],project:'Deploy a microservices app on EKS with Helm and Auto Scaling',resources:['📘 AWS EKS Workshop (free)','📘 Kubernetes Docs (free)']),
        CareerPhase(id:7,title:'Monitoring & Cost Optimisation',subtitle:'CloudWatch, Cost Explorer, rightsizing',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹13–22 LPA / \$95K',topics:['CloudWatch metrics, alarms, dashboards','X-Ray distributed tracing','AWS Cost Explorer & Budgets','Rightsizing recommendations','Reserved Instances vs Savings Plans','Compute Optimizer','FinOps principles'],tools:['CloudWatch','Cost Explorer','AWS Compute Optimizer'],project:'Reduce a mock AWS bill by 40% through rightsizing and reservations',resources:['📘 AWS Cloud Financial Management (free)','📘 FinOps Foundation (free)']),
        CareerPhase(id:8,title:'Multi-Cloud & Migration',subtitle:'Hybrid cloud, migration strategies',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹14–25 LPA / \$100K',topics:['Cloud migration strategies (7 Rs)','AWS Migration Hub','Database migration service','VMware Cloud on AWS','Multi-cloud architecture patterns','Disaster recovery strategies','Business continuity planning'],tools:['AWS Migration Hub','Database Migration Service'],project:'Plan and execute a mock on-premises to AWS migration',resources:['📘 AWS Migration Whitepaper (free)','📘 Google Cloud Migration Guide (free)']),
        CareerPhase(id:9,title:'Certifications & Specialisation',subtitle:'AWS SAA, SAP, specialty certs',duration:'6–8 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹15–30 LPA / \$110K',topics:['AWS Solutions Architect Associate (SAA-C03)','AWS Solutions Architect Professional','AWS DevOps Engineer Professional','GCP Professional Cloud Architect','Azure Solutions Architect Expert','Exam strategies & practice tests'],tools:['Whizlabs','A Cloud Guru','TutorialsDojo'],project:'Pass at least 2 cloud certifications',resources:['📘 AWS Official Study Guide','📘 TutorialsDojo Practice Exams']),
        CareerPhase(id:10,title:'Interview & Job Ready',subtitle:'Technical, design, behavioural',duration:'3–4 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹18–40 LPA+ / \$130K+',topics:['Cloud architecture design interviews','Cost estimation questions','Security scenarios','Migration planning interviews','STAR behavioural stories','Salary negotiation for cloud roles'],tools:['Pramp','AWS Skill Builder'],project:'5 mock cloud architecture interviews + apply to 20 companies',resources:['📘 AWS Well-Architected Framework (free)']),
      ],
    ),
  ],
);

// ──────────────────────────────────────────────────────────────────────
// 4. CYBER SECURITY
// ──────────────────────────────────────────────────────────────────────
const _cyberSecurity = CareerCategory(
  id:    'cyber_security',
  title: 'Cyber Security',
  emoji: '🔒',
  color: Color(0xFFEF4444),
  careers: [
    CareerData(
      id:'ethical_hacker', title:'Ethical Hacker',
      emoji:'🎭', tagline:'Find and fix vulnerabilities before attackers do',
      level:'Intermediate', skills:['Linux','Python','Kali','Burp Suite','Networking'],
      phases: [
        CareerPhase(id:1,title:'Networking Fundamentals',subtitle:'TCP/IP, protocols, packet analysis',duration:'4–5 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹4–7 LPA / \$50K',topics:['OSI & TCP/IP model','IP addressing & subnetting','Common protocols: HTTP, DNS, SMTP, SSH','Wireshark packet capture','Port scanning with Nmap','Firewall concepts','VPN fundamentals'],tools:['Wireshark','Nmap','Cisco Packet Tracer'],project:'Capture and analyse network traffic to identify 5 security issues',resources:['📘 Professor Messer Network+ (free)','📘 TryHackMe Pre-Security path (free)']),
        CareerPhase(id:2,title:'Linux & Scripting',subtitle:'Kali Linux, Bash, Python for hacking',duration:'3–4 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹5–8 LPA / \$55K',topics:['Kali Linux setup & tools','Bash scripting for automation','Python for security scripting','File system & permissions','Process & user management','Log analysis','Netcat & socat'],tools:['Kali Linux','Python','Bash','Netcat'],project:'Write a Python port scanner and banner grabber from scratch',resources:['📘 The Linux Command Line (free)','📘 Black Hat Python book']),
        CareerPhase(id:3,title:'Web Application Security',subtitle:'OWASP Top 10, Burp Suite',duration:'5–6 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–12 LPA / \$65K',topics:['OWASP Top 10 vulnerabilities','SQL injection (manual + SQLMap)','XSS (reflected, stored, DOM)','CSRF & broken access control','Burp Suite intercept, repeater, scanner','Directory traversal','Insecure deserialisation','JWT attacks'],tools:['Burp Suite','SQLMap','OWASP ZAP'],project:'Complete PortSwigger Web Security Academy (50 labs)',resources:['📘 PortSwigger Web Security Academy (free)','📘 OWASP Top 10 (free)']),
        CareerPhase(id:4,title:'Penetration Testing Methodology',subtitle:'Reconnaissance to reporting',duration:'5–6 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹9–15 LPA / \$75K',topics:['Penetration testing phases: recon, scanning, exploitation, post-exploitation, reporting','PTES & OWASP Testing Guide','Active & passive reconnaissance (Shodan, theHarvester)','Metasploit Framework','Privilege escalation (Linux & Windows)','Pivoting & lateral movement','Report writing for clients'],tools:['Metasploit','theHarvester','Shodan','Bloodhound'],project:'Complete a full penetration test on a vulnerable VM (HackTheBox machine)',resources:['📘 PentesterLab (free)','📘 HackTheBox (free)']),
        CareerPhase(id:5,title:'Network Penetration Testing',subtitle:'Wireless, sniffing, Active Directory',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹10–18 LPA / \$85K',topics:['Wi-Fi attacks (WPA2 cracking, Evil Twin)','Man-in-the-middle (ARP poisoning)','Active Directory enumeration','Kerberoasting & pass-the-hash','SMB attacks (EternalBlue)','DNS poisoning','VPN & firewall evasion'],tools:['Aircrack-ng','Responder','Impacket','Bloodhound'],project:'Attack a full Active Directory lab environment (TryHackMe AD Path)',resources:['📘 TryHackMe Active Directory (free)','📘 Penetration Testing — Georgia Weidman']),
        CareerPhase(id:6,title:'CTF & Vulnerability Research',subtitle:'Capture the Flag, CVE research',duration:'4–6 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹12–22 LPA / \$90K',topics:['CTF challenge categories: web, pwn, crypto, forensics, reverse','Reverse engineering basics (Ghidra, IDA)','Binary exploitation (buffer overflow basics)','Cryptography fundamentals for hackers','Forensics: memory dump analysis','Steganography tools','CVE research & PoC development'],tools:['Ghidra','CTFd','PwnTools','Volatility'],project:'Win a top 50 finish in a beginner CTF competition',resources:['📘 CTFtime.org (free)','📘 pwn.college (free)']),
        CareerPhase(id:7,title:'Bug Bounty Hunting',subtitle:'Platforms, reports, hall of fame',duration:'5–6 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹10–50 LPA (bounty) / \$5K–\$100K+ bounties',topics:['HackerOne & Bugcrowd platforms','Scope definition & rules of engagement','Report writing for bug bounties','Critical bugs: SSRF, XXE, RCE, IDOR','Reconnaissance at scale (Amass, Subfinder)','Automation with nuclei','Chaining vulnerabilities for higher impact'],tools:['HackerOne','Bugcrowd','Amass','Nuclei'],project:'Find and responsibly disclose a real security vulnerability in a bug bounty program',resources:['📘 HackerOne Hacker101 (free)','📘 Bug Bounty Bootcamp book']),
        CareerPhase(id:8,title:'Certifications',subtitle:'CEH, OSCP, eJPT',duration:'6–8 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹12–30 LPA / \$90K+',topics:['eJPT — Entry level (TCM Security)','CEH — Certified Ethical Hacker (EC-Council)','OSCP — Offensive Security Certified Professional (gold standard)','CompTIA Security+ for compliance roles','Exam strategies','Lab practice hours (250+ for OSCP)'],tools:['HackTheBox','TryHackMe','PentesterLab'],project:'Pass eJPT + start OSCP preparation',resources:['📘 TCM Security Academy (paid)','📘 HackTheBox OSCP Prep path']),
        CareerPhase(id:9,title:'Portfolio & Community',subtitle:'Blog, CVEs, CTF writeups',duration:'3–4 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹14–35 LPA / \$100K',topics:['Write CTF walkthrough blog posts','Publish CVE research responsibly','Build a personal security lab','Contribute to open-source security tools','Attend security conferences (DEF CON, Black Hat, Null)','LinkedIn for security roles'],tools:['GitHub','TryHackMe','HackTheBox'],project:'Publish 5 CTF writeups + 1 original vulnerability research post',resources:['📘 0xdf.gitlab.io (HTB writeups)','📘 IppSec (YouTube, free)']),
        CareerPhase(id:10,title:'Interview & Job Ready',subtitle:'Technical, behavioural, red team',duration:'3–5 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹15–40 LPA+ / \$100K+',topics:['Penetration test methodology explanation','OWASP Top 10 deep dive Q&A','Scenario-based security interviews','Red team vs blue team distinctions','Security compliance knowledge (ISO 27001, SOC 2)','Salary negotiation for security roles'],tools:['Pramp'],project:'5 mock interviews + apply to 15 security companies',resources:['📘 Cybersecurity Interview Questions (GitHub, free)']),
      ],
    ),
    CareerData(
      id:'security_analyst', title:'Security Analyst',
      emoji:'🛡️', tagline:'Monitor, detect, and respond to security threats',
      level:'Beginner', skills:['SIEM','Networking','Log Analysis','Incident Response','Python'],
      phases: [
        CareerPhase(id:1,title:'Security Fundamentals',subtitle:'CIA triad, threats, controls',duration:'3–4 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹4–7 LPA / \$45K',topics:['CIA triad (Confidentiality, Integrity, Availability)','Types of threats and attacks','Security controls (preventive, detective, corrective)','Risk management basics','Security policies and frameworks (ISO 27001, NIST)','Compliance basics (GDPR, PCI-DSS)'],tools:['CompTIA Security+ materials'],project:'Write a security risk assessment for a hypothetical company',resources:['📘 CompTIA Security+ Study Guide','📘 NIST Cybersecurity Framework (free)']),
        CareerPhase(id:2,title:'Networking & Protocols',subtitle:'TCP/IP, firewalls, IDS/IPS',duration:'3–4 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹5–8 LPA / \$50K',topics:['OSI model deep dive','Network protocols: HTTP, HTTPS, DNS, SMTP','Firewalls: stateful, stateless, NGFW','IDS vs IPS','VPN and encryption','Network segmentation','Wireshark basics'],tools:['Wireshark','Cisco Packet Tracer','Nmap'],project:'Analyse a PCAP file and document all suspicious network activity',resources:['📘 TryHackMe Pre-Security path (free)','📘 Wireshark Tutorial (free)']),
        CareerPhase(id:3,title:'SIEM & Log Analysis',subtitle:'Splunk, ELK, threat hunting',duration:'5–6 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–11 LPA / \$60K',topics:['SIEM concepts and architecture','Splunk: searches, dashboards, alerts','ELK Stack (Elasticsearch, Logstash, Kibana)','Log sources: Windows Event Logs, Syslog, firewall logs','Correlation rules','KQL (Kibana Query Language)','Threat hunting basics'],tools:['Splunk Free Trial','ELK Stack','Microsoft Sentinel'],project:'Build Splunk dashboards that detect 5 attack scenarios from logs',resources:['📘 Splunk Fundamentals 1 (free)','📘 TryHackMe SOC Level 1 (free)']),
        CareerPhase(id:4,title:'Incident Response',subtitle:'Detection, containment, recovery',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹8–14 LPA / \$70K',topics:['IR lifecycle: Preparation, Detection, Containment, Eradication, Recovery, Lessons Learned','Digital forensics basics','Memory forensics (Volatility)','Malware analysis basics (sandbox)','Chain of custody','Incident documentation','Tabletop exercise facilitation'],tools:['Volatility','Any.run sandbox','Velociraptor','TheHive'],project:'Conduct a full incident response tabletop exercise and write a report',resources:['📘 SANS Incident Handler Handbook (free)','📘 TryHackMe IR path (free)']),
        CareerPhase(id:5,title:'Threat Intelligence',subtitle:'IOCs, threat feeds, MITRE ATT&CK',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹9–16 LPA / \$78K',topics:['MITRE ATT&CK framework','Indicators of Compromise (IOCs)','Threat intelligence platforms (MISP, OpenCTI)','OSINT for threat research','Malware families and TTPs','Threat actor profiling','Intelligence sharing (ISACs)'],tools:['MITRE ATT&CK Navigator','MISP','VirusTotal','Shodan'],project:'Map an APT campaign using MITRE ATT&CK and produce an intelligence report',resources:['📘 MITRE ATT&CK (free)','📘 Threat Intelligence with MISP (free)']),
        CareerPhase(id:6,title:'Cloud Security',subtitle:'AWS/Azure security, cloud threats',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹11–20 LPA / \$88K',topics:['Cloud shared responsibility model','AWS IAM security hardening','Cloud Security Posture Management (CSPM)','Kubernetes security','Container scanning','Cloud-native threats (credential theft, SSRF)','AWS CloudTrail & GuardDuty','Microsoft Defender for Cloud'],tools:['AWS Security Hub','Prowler','Trivy','Defender for Cloud'],project:'Audit an AWS account for security misconfigurations using Prowler',resources:['📘 AWS Security Learning Path (free)','📘 Cloud Security Alliance (free)']),
        CareerPhase(id:7,title:'Python for Security',subtitle:'Automation, scripts, threat detection',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹11–19 LPA / \$85K',topics:['Python for log parsing and automation','API integration for SIEM','Writing detection rules in Python','Threat intelligence feed automation','Automated IOC enrichment','Building security dashboards','Automating IR runbooks'],tools:['Python','Splunk Python SDK','OpenCTI API'],project:'Build a Python script that auto-enriches IOCs from VirusTotal',resources:['📘 Black Hat Python book','📘 Python for Security Pros (Udemy)']),
        CareerPhase(id:8,title:'Certifications',subtitle:'CompTIA, SANS, SC-200',duration:'6–8 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹12–25 LPA / \$90K',topics:['CompTIA Security+','CompTIA CySA+ (Analyst)','SC-200 (Microsoft Security Analyst)','GIAC Security Essentials (GSEC)','Exam preparation strategies'],tools:['CompTIA Certmaster','Microsoft Learn','TryHackMe'],project:'Pass CompTIA Security+ and start CySA+ prep',resources:['📘 Professor Messer Security+ (free)','📘 Microsoft SC-200 Study Guide (free)']),
        CareerPhase(id:9,title:'Portfolio & SOC Skills',subtitle:'Blueteam labs, CTFs, writeups',duration:'3–4 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹13–28 LPA / \$95K',topics:['BlueTeamLabs Online challenges','LetsDefend SOC simulation','Writing investigation reports','Security blog posts','LinkedIn for SOC/analyst roles','Building a home security lab (SIEM at home)'],tools:['BlueTeamLabs','LetsDefend','Splunk'],project:'Complete 20 BlueTeamLabs challenges and write 5 investigation reports',resources:['📘 BlueTeamLabs (free)','📘 LetsDefend (free)']),
        CareerPhase(id:10,title:'Interview & Job Ready',subtitle:'SOC scenarios, technical, behavioural',duration:'3–4 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹14–35 LPA+ / \$100K+',topics:['SOC analyst interview scenarios','Splunk technical questions','Incident response scenario questions','MITRE ATT&CK interview prep','Behavioural: incident stories','Salary negotiation for security'],tools:['Pramp','LinkedIn'],project:'5 mock interviews + apply to 20 security analyst roles',resources:['📘 SOC Analyst Interview Questions (GitHub, free)']),
      ],
    ),
  ],
);

// ──────────────────────────────────────────────────────────────────────
// 5. DESIGN & PRODUCT
// ──────────────────────────────────────────────────────────────────────
const _designProduct = CareerCategory(
  id:    'design_product',
  title: 'Design & Product',
  emoji: '🎨',
  color: Color(0xFFF59E0B),
  careers: [
    CareerData(
      id:'ux_designer', title:'UX Designer',
      emoji:'🎯', tagline:'Design experiences people love',
      level:'Beginner', skills:['Figma','User Research','Wireframing','Prototyping','Usability Testing'],
      phases: [
        CareerPhase(id:1,title:'UX Fundamentals',subtitle:'What is UX, design thinking',duration:'2–3 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹3–5 LPA / \$40K',topics:['What is UX vs UI','Design thinking: Empathise, Define, Ideate, Prototype, Test','Human-centred design','Mental models & affordances','UX laws (Fitts, Hick, Miller)','Gestalt principles'],tools:['Notion','Miro'],project:'Complete a design thinking challenge for a real-world problem',resources:['📘 Google UX Design Certificate (Coursera, audit free)','📘 Don\'t Make Me Think — Steve Krug']),
        CareerPhase(id:2,title:'User Research',subtitle:'Interviews, surveys, personas',duration:'3–4 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹4–6 LPA / \$45K',topics:['Research methods: interviews, surveys, observations','Writing effective interview scripts','User personas','User journey maps','Empathy maps','Competitive analysis','Qualitative vs quantitative research'],tools:['Dovetail','Maze','Google Forms'],project:'Conduct 5 user interviews and build a persona + journey map',resources:['📘 Just Enough Research — Erika Hall','📘 Nielsen Norman Group Articles (free)']),
        CareerPhase(id:3,title:'Figma Mastery',subtitle:'Wireframes, components, auto-layout',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹5–9 LPA / \$55K',topics:['Figma interface & shortcuts','Frames, components, variants','Auto-layout','Design tokens','Prototyping & interactions','Figma plugins','Collaboration features','Variables & conditional logic'],tools:['Figma'],project:'Build a complete mobile app design with reusable component library',resources:['📘 Figma Learn (free)','📘 DesignCode Figma course']),
        CareerPhase(id:4,title:'Information Architecture',subtitle:'Navigation, hierarchy, content structure',duration:'2–3 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹5–9 LPA / \$55K',topics:['Site maps','Card sorting','Tree testing','Navigation patterns','Content hierarchy','Search and filter design','IA for apps vs websites'],tools:['Optimal Workshop','Miro','Figma'],project:'Redesign the navigation of a real app with IA research backing',resources:['📘 How to Make Sense of Any Mess — Abby Covert','📘 IA Institute (free)']),
        CareerPhase(id:5,title:'Interaction Design',subtitle:'Micro-interactions, motion, feedback',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–12 LPA / \$65K',topics:['States: default, hover, active, error, empty, loading','Microinteractions: triggers, rules, feedback, loops','Motion principles (easing, timing)','Haptic feedback design','Transition animations','Skeleton screens','Toast notifications & alerts'],tools:['Figma Prototyping','ProtoPie','Principle'],project:'Design a 5-screen onboarding flow with polished microinteractions',resources:['📘 Microinteractions — Dan Saffer','📘 ProtoPie Learn (free)']),
        CareerPhase(id:6,title:'Usability Testing',subtitle:'Testing methods, analysis, iteration',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹8–14 LPA / \$70K',topics:['Moderated vs unmoderated testing','Think-aloud protocol','Heuristic evaluation (Nielsen\'s 10)','A/B testing for UX','Tree testing & first-click testing','Affinity mapping of findings','Iterating designs based on data'],tools:['Maze','UserZoom','Lookback','Optimal Workshop'],project:'Run a usability test with 8 participants and document findings with redesigns',resources:['📘 Rocket Surgery Made Easy — Steve Krug','📘 Maze Blog (free)']),
        CareerPhase(id:7,title:'Design Systems',subtitle:'Components, tokens, documentation',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹9–16 LPA / \$78K',topics:['What is a design system','Component library architecture','Design tokens (colours, spacing, typography)','Documentation with Storybook or Zeroheight','Accessibility in design systems','Versioning and governance','Contributing to shared systems'],tools:['Figma','Storybook','Zeroheight','Tokens Studio'],project:'Build a mini design system with 30+ components and documentation',resources:['📘 Design Systems Handbook (free)','📘 Figma Design System tutorials (YouTube)']),
        CareerPhase(id:8,title:'Accessibility & Inclusive Design',subtitle:'WCAG, screen readers, colour contrast',duration:'2–3 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹9–15 LPA / \$75K',topics:['WCAG 2.1 AA guidelines','Colour contrast ratios','Keyboard navigation design','Screen reader compatibility','Focus management','Accessible forms','Inclusive design for diverse users'],tools:['Figma A11y plugins','Contrast Checker','VoiceOver'],project:'Audit an existing app for accessibility and deliver a remediation report',resources:['📘 WebAIM (free)','📘 Inclusive Design Principles (free)']),
        CareerPhase(id:9,title:'Portfolio Building',subtitle:'3 case studies, Behance, interviews',duration:'4–6 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹10–22 LPA / \$85K',topics:['UX case study structure: Problem → Research → Design → Test → Outcome','Writing compelling case studies','Portfolio website (Webflow, Notion)','Behance and Dribbble profiles','Presentation skills for design critiques','LinkedIn UX profile'],tools:['Webflow','Notion','Behance'],project:'3 full case studies published on a personal portfolio website',resources:['📘 UX Portfolio Formula — Gloria Lo','📘 Bestfolios (free)']),
        CareerPhase(id:10,title:'Interview & Job Ready',subtitle:'Design critique, whiteboard, portfolio',duration:'3–4 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹12–28 LPA+ / \$90K+',topics:['UX interview formats (portfolio, whiteboard, design critique)','Product sense questions','Collaboration & stakeholder stories','Salary negotiation for UX roles','Whiteboard challenge practice','Freelancing vs full-time UX'],tools:['Pramp'],project:'5 mock UX interviews + apply to 20 design roles',resources:['📘 UX Interview Questions (GitHub, free)','📘 NNG UX Careers (free)']),
      ],
    ),
    CareerData(
      id:'product_manager', title:'Product Manager',
      emoji:'📋', tagline:'Define, prioritise, and ship products users love',
      level:'Intermediate', skills:['Product Strategy','SQL','User Research','Roadmapping','Stakeholder Management'],
      phases: [
        CareerPhase(id:1,title:'PM Fundamentals',subtitle:'What PMs do, frameworks, mindset',duration:'2–3 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹8–14 LPA / \$70K',topics:['PM role vs PO vs CPO','Product development lifecycle','Agile & Scrum for PMs','PRD (Product Requirements Document)','Stakeholder mapping','Customer obsession mindset','PM frameworks: CIRCLES, RICE, ICE'],tools:['Notion','Jira','Miro'],project:'Write a PRD for a product feature you wish existed',resources:['📘 Inspired — Marty Cagan','📘 Lenny\'s Newsletter (free)']),
        CareerPhase(id:2,title:'User Research & Discovery',subtitle:'Customer interviews, problem validation',duration:'3–4 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹9–15 LPA / \$75K',topics:['Jobs-to-be-done (JTBD) framework','Customer interview techniques','Problem vs solution discovery','Opportunity solution trees','Competitive analysis','Market sizing (TAM, SAM, SOM)','Survey design'],tools:['Dovetail','Typeform','Notion'],project:'Conduct 10 customer discovery interviews and extract key insights',resources:['📘 The Mom Test — Rob Fitzpatrick','📘 Continuous Discovery Habits — Teresa Torres']),
        CareerPhase(id:3,title:'Metrics & Analytics',subtitle:'North Star, funnels, A/B testing',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹10–16 LPA / \$80K',topics:['North Star Metric definition','AARRR funnel (Acquisition, Activation, Retention, Revenue, Referral)','Cohort analysis','A/B testing design for PMs','SQL for PMs: basic to intermediate','Product analytics tools (Mixpanel, Amplitude)','Defining success metrics for features'],tools:['SQL','Mixpanel','Amplitude','Metabase'],project:'Instrument a feature and define its success metrics with SQL queries',resources:['📘 Lean Analytics — Alistair Croll','📘 Reforge PM Metrics (free intro)']),
        CareerPhase(id:4,title:'Prioritisation & Roadmapping',subtitle:'RICE, ICE, product roadmaps',duration:'2–3 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹11–18 LPA / \$85K',topics:['RICE prioritisation framework','ICE scoring','MoSCoW method','Roadmap types (timeline, outcome, now-next-later)','Stakeholder alignment on roadmap','Managing scope creep','OKRs for product teams'],tools:['Linear','Aha!','Notion','Productboard'],project:'Build a 12-month product roadmap for a real product using RICE scoring',resources:['📘 Product Roadmaps Relaunched — C. Todd Lombardo','📘 Productboard Blog (free)']),
        CareerPhase(id:5,title:'Working with Engineering & Design',subtitle:'Collaboration, specs, unblocking',duration:'2–3 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹11–18 LPA / \$85K',topics:['Writing precise user stories','Acceptance criteria that engineers love','Design critique for PMs','Technical debt: when to tackle it','Sprint planning & backlog refinement','Unblocking engineering bottlenecks','Effective stakeholder updates'],tools:['Jira','Linear','Figma','Notion'],project:'Write 10 user stories with acceptance criteria for a feature sprint',resources:['📘 Agile Estimating and Planning — Mike Cohn','📘 Shape Up — Basecamp (free)']),
        CareerPhase(id:6,title:'Go-to-Market & Launch',subtitle:'Beta, launch, metrics, adoption',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹13–22 LPA / \$95K',topics:['Beta & rollout strategies','Feature flagging (LaunchDarkly)','GTM plan for PMs','Press releases & blog posts','Internal enablement (sales, CS)','Post-launch metrics review','Feature deprecation'],tools:['LaunchDarkly','Notion','HubSpot'],project:'Write a complete GTM plan for a new feature launch',resources:['📘 Obviously Awesome — April Dunford','📘 Reforge GTM (free)']),
        CareerPhase(id:7,title:'Monetisation & Business Strategy',subtitle:'Pricing, revenue models, strategy',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹14–24 LPA / \$100K',topics:['SaaS pricing models (freemium, seat-based, usage-based)','Unit economics (LTV, CAC, payback period)','Revenue growth vs retention trade-offs','Competitive positioning','Porter\'s 5 forces for product strategy','Build vs buy vs partner decisions'],tools:['Notion','Excel / Google Sheets'],project:'Build a pricing analysis for a SaaS product with 3 pricing tiers',resources:['📘 Monetizing Innovation — Madhavan Ramanujam','📘 Price Intelligently Blog (free)']),
        CareerPhase(id:8,title:'AI for Product Managers',subtitle:'LLMs, AI features, evaluation',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹15–28 LPA / \$110K',topics:['How LLMs work (for PMs, no coding)','AI product opportunities & risks','Evaluating AI features (hallucination, accuracy)','AI-first product design patterns','Prompt engineering for PMs','AI ethics & safety in product decisions','Competitor AI feature analysis'],tools:['ChatGPT','Claude','Perplexity'],project:'Write a comprehensive AI feature PRD for a product of your choice',resources:['📘 AI for Everyone — Andrew Ng (Coursera, free)','📘 Lenny\'s AI PM Guide (free)']),
        CareerPhase(id:9,title:'Portfolio & Network',subtitle:'Case studies, projects, PM community',duration:'3–4 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹15–30 LPA / \$115K',topics:['PM portfolio structure','3 product case studies','Side project as portfolio piece','LinkedIn PM profile optimisation','PM communities (Lenny\'s, Product School)','Informational interviews strategy','Transitioning to PM from other roles'],tools:['Notion','Webflow','LinkedIn'],project:'3 product case studies + 10 informational interviews with PMs',resources:['📘 PM Portfolio Guide (Product School, free)','📘 PMlesson.com (free)']),
        CareerPhase(id:10,title:'Interview & Job Ready',subtitle:'Product sense, execution, strategy',duration:'4–5 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹18–45 LPA+ / \$130K+',topics:['Product sense interviews: "Design X for Y"','Execution interviews: metrics, debugging, trade-offs','Strategy: market entry, growth, competitive','Estimation questions','Behavioural: STAR stories for product impact','Salary negotiation for PM roles','FAANG vs startup PM differences'],tools:['Exponent','Product Alliance','Pramp'],project:'30 mock interview questions answered + 5 full mock interviews',resources:['📘 Decode & Conquer — Lewis Lin','📘 Exponent PM Interview (free tier)']),
      ],
    ),
  ],
);

// ──────────────────────────────────────────────────────────────────────
// 6. EMERGING TECH
// ──────────────────────────────────────────────────────────────────────
const _emergingTech = CareerCategory(
  id:    'emerging_tech',
  title: 'Emerging Tech',
  emoji: '⛓️',
  color: Color(0xFF06B6D4),
  careers: [
    CareerData(
      id:'blockchain_dev', title:'Blockchain Developer',
      emoji:'⛓️', tagline:'Build decentralised apps and smart contracts',
      level:'Intermediate', skills:['Solidity','Ethereum','Web3.js','Smart Contracts','DeFi'],
      phases: [
        CareerPhase(id:1,title:'Blockchain Fundamentals',subtitle:'How blockchain works, consensus',duration:'3–4 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹6–10 LPA / \$60K',topics:['What is a blockchain','Consensus mechanisms: PoW, PoS, DPoS','Merkle trees & hashing','Public key cryptography','Bitcoin vs Ethereum','Layer 1 vs Layer 2','Wallets: hot, cold, hardware'],tools:['MetaMask','Etherscan'],project:'Set up a MetaMask wallet and send test ETH on a testnet',resources:['📘 Mastering Bitcoin — Andreas Antonopoulos (free)','📘 ethereum.org Learn (free)']),
        CareerPhase(id:2,title:'Solidity Smart Contracts',subtitle:'Write, deploy, test contracts',duration:'5–6 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹8–14 LPA / \$70K',topics:['Solidity syntax','Data types, mappings, arrays','Functions, modifiers, events','Inheritance & interfaces','ERC-20 token standard','ERC-721 NFT standard','Gas optimisation basics','Hardhat / Foundry development'],tools:['Solidity','Hardhat','Foundry','Remix IDE'],project:'Deploy your own ERC-20 token on Sepolia testnet',resources:['📘 CryptoZombies (free)','📘 Hardhat Docs (free)']),
        CareerPhase(id:3,title:'Web3 Frontend',subtitle:'ethers.js, wagmi, wallet connection',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹10–16 LPA / \$80K',topics:['ethers.js / web3.js','wagmi hooks for React','wallet connection (RainbowKit)','Reading on-chain data','Writing transactions from frontend','IPFS for decentralised storage','The Graph for blockchain data queries'],tools:['ethers.js','wagmi','RainbowKit','The Graph'],project:'Build a dApp frontend that interacts with your ERC-20 token',resources:['📘 Ethers.js Docs (free)','📘 wagmi Docs (free)']),
        CareerPhase(id:4,title:'DeFi Development',subtitle:'AMMs, lending, liquidity pools',duration:'5–6 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹12–22 LPA / \$95K',topics:['AMM mechanics (Uniswap V2/V3)','Lending protocols (Aave, Compound)','Flash loans','Yield farming & liquidity mining','Price oracles (Chainlink)','Slippage & impermanent loss','MEV (Maximal Extractable Value) basics'],tools:['Uniswap V3','Aave','Chainlink','Foundry'],project:'Fork Uniswap V2 and deploy it on a local testnet with custom tokens',resources:['📘 Uniswap V2 Whitepaper (free)','📘 Defi MOOC (Berkeley, free)']),
        CareerPhase(id:5,title:'Smart Contract Security',subtitle:'Auditing, attack vectors, formal verification',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹15–30 LPA / \$110K',topics:['Common vulnerabilities: reentrancy, overflow, front-running','Slither & Echidna security tools','Manual audit process','Attack vector analysis','Formal verification basics','Bug bounty for smart contracts (Immunefi)','Reading audit reports (OpenZeppelin, Trail of Bits)'],tools:['Slither','Echidna','Foundry fuzz testing','Immunefi'],project:'Audit 3 real smart contracts and produce security reports',resources:['📘 Smart Contract Programmer (YouTube, free)','📘 Consensys Diligence Blog (free)']),
        CareerPhase(id:6,title:'NFTs & GameFi',subtitle:'ERC-721, ERC-1155, gaming protocols',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹12–22 LPA / \$90K',topics:['ERC-721 vs ERC-1155','NFT metadata standards','IPFS & Arweave for metadata storage','Royalty standards (ERC-2981)','GameFi tokenomics','Play-to-earn mechanics','NFT marketplace development'],tools:['OpenSea API','IPFS','Foundry','OpenZeppelin'],project:'Build an NFT collection with on-chain metadata and marketplace integration',resources:['📘 OpenZeppelin Docs (free)','📘 buildspace NFT course (free)']),
        CareerPhase(id:7,title:'Layer 2 & Scaling',subtitle:'Rollups, bridges, L2 development',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹14–25 LPA / \$100K',topics:['Optimistic rollups (Optimism, Arbitrum)','ZK rollups (Polygon zkEVM, zkSync)','State channels','Cross-chain bridges','L2 deployment strategies','Gas differences L1 vs L2','L2 ecosystem overview'],tools:['Arbitrum Nitro','Optimism','zkSync Era'],project:'Deploy a dApp on Arbitrum and compare gas costs with Ethereum mainnet',resources:['📘 L2Beat (free)','📘 Arbitrum Docs (free)']),
        CareerPhase(id:8,title:'DAOs & Governance',subtitle:'DAO tooling, voting, treasury',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹12–22 LPA / \$90K',topics:['DAO structure and tooling','Governor contracts (OpenZeppelin Governor)','Snapshot governance','Multisig wallets (Gnosis Safe)','Treasury management','Tokenomics design','Participatory governance patterns'],tools:['OpenZeppelin Governor','Snapshot','Gnosis Safe','Tally'],project:'Deploy a DAO with on-chain voting and treasury using OpenZeppelin Governor',resources:['📘 DAO Research Collective (free)','📘 OpenZeppelin Governor Docs (free)']),
        CareerPhase(id:9,title:'Portfolio & Open Source',subtitle:'Projects, audits, GitHub, communities',duration:'3–5 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹15–35 LPA / \$110K',topics:['2 deployed dApps on mainnet or Polygon','1 smart contract audit writeup','Contribute to a DeFi protocol','Ethereum developer communities','ETHGlobal hackathons','Crypto Twitter & Farcaster networking'],tools:['GitHub','ETHGlobal','Immunefi'],project:'Win or place top 5 in an ETHGlobal hackathon',resources:['📘 ETHGlobal (free hackathons)','📘 buildspace projects (free)']),
        CareerPhase(id:10,title:'Interview & Job Ready',subtitle:'Technical, audit, protocol design',duration:'3–4 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹18–50 LPA+ / \$130K+',topics:['Smart contract technical interviews','Solidity coding challenges','DeFi protocol design questions','Security audit case studies','Web3 salary landscape','Comparing protocol jobs vs dApp jobs'],tools:['Pramp'],project:'5 mock blockchain interviews + apply to 15 web3 protocols',resources:['📘 Blockchain Developer Interview Questions (GitHub, free)']),
      ],
    ),
    CareerData(
      id:'robotics_engineer', title:'Robotics Engineer',
      emoji:'🤖', tagline:'Build intelligent machines that interact with the world',
      level:'Advanced', skills:['Python','C++','ROS 2','Control Theory','Computer Vision'],
      phases: [
        CareerPhase(id:1,title:'Mathematics for Robotics',subtitle:'Linear algebra, calculus, control theory',duration:'4–5 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹5–8 LPA / \$55K',topics:['3D linear algebra: rotation matrices, quaternions','Differential equations basics','Laplace transform & control theory','Forward & inverse kinematics','Rigid body dynamics','Graph theory for path planning','Probability & Bayesian methods'],tools:['MATLAB / Octave','Python NumPy','Wolfram Alpha'],project:'Implement forward kinematics for a 3-DOF robot arm in Python',resources:['📘 Modern Robotics — Northwestern (free)','📘 Robotics Academy (free)']),
        CareerPhase(id:2,title:'Programming for Robotics',subtitle:'C++, Python, real-time systems',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–11 LPA / \$65K',topics:['C++ for robotics (STL, templates, multithreading)','Python for rapid prototyping','Real-time programming concepts','Embedded systems basics','Serial communication (UART, I2C, SPI)','Linux for robotics','CMake build system'],tools:['C++17','Python','CMake','VS Code'],project:'Build a concurrent task scheduler in C++ for a sensor system',resources:['📘 A Tour of C++ — Bjarne Stroustrup','📘 Programming Robots with ROS']),
        CareerPhase(id:3,title:'ROS 2 Fundamentals',subtitle:'Nodes, topics, services, actions',duration:'5–6 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹9–14 LPA / \$75K',topics:['ROS 2 architecture','Nodes, topics, services, actions, parameters','DDS middleware','Launch files','TF2 coordinate transforms','Bags & rosbag2','ROS 2 lifecycle nodes','Colcon build system'],tools:['ROS 2 Humble','Gazebo','rviz2','colcon'],project:'Build a simulated mobile robot that navigates to goals using ROS 2',resources:['📘 ROS 2 Docs (free)','📘 The Construct ROS 2 courses']),
        CareerPhase(id:4,title:'Robot Perception',subtitle:'Computer vision, LiDAR, sensor fusion',duration:'5–6 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹10–18 LPA / \$85K',topics:['Camera calibration & projection','3D point clouds (Open3D, PCL)','YOLO for object detection in robotics','Depth estimation (stereo, structured light, ToF)','LiDAR data processing','Sensor fusion (camera + LiDAR)','SLAM overview: mapping + localisation'],tools:['OpenCV','Open3D','ROS 2 perception stack'],project:'Build an object detection and 3D localisation system using camera + LiDAR',resources:['📘 OpenCV Docs (free)','📘 Self-Driving Cars Specialization — U of Toronto (Coursera)']),
        CareerPhase(id:5,title:'Motion Planning & Control',subtitle:'Path planning, PID, MPC',duration:'5–6 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹12–22 LPA / \$95K',topics:['PID control (tuning, simulation)','Model Predictive Control (MPC)','A* and Dijkstra path planning','RRT & RRT* motion planning','Nav2 navigation stack in ROS 2','Trajectory optimisation','Dynamic obstacle avoidance'],tools:['Nav2','MoveIt2','OMPL','Gazebo'],project:'Implement Nav2 navigation for a differential drive robot in Gazebo',resources:['📘 Nav2 Docs (free)','📘 Modern Robotics coursera']),
        CareerPhase(id:6,title:'Robot Manipulation',subtitle:'Arms, grippers, grasping',duration:'5–6 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹14–25 LPA / \$105K',topics:['MoveIt2 for motion planning','Inverse kinematics solvers (KDL, TracIK)','Grasp planning (GQ-CNN, contact point methods)','Force/torque sensor integration','Visual servoing','Manipulation in simulation (IsaacGym, MuJoCo)','Sim-to-real transfer techniques'],tools:['MoveIt2','IsaacGym','MuJoCo','Gazebo'],project:'Program a 6-DOF robot arm to pick and place objects using MoveIt2',resources:['📘 MoveIt2 Docs (free)','📘 HuggingFace LeRobot (free)']),
        CareerPhase(id:7,title:'Machine Learning for Robotics',subtitle:'RL, imitation learning, perception models',duration:'5–6 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹15–28 LPA / \$115K',topics:['Reinforcement learning for robotics (PPO, SAC)','Sim-to-real domain randomisation','Imitation learning (behavior cloning, DAgger)','Foundation models for robotics (RT-2, Octo)','Offline RL (IQL, CQL)','Learning from demonstration','Safety constraints in robot RL'],tools:['Stable-Baselines3','IsaacGym','LeRobot'],project:'Train a robot arm to manipulate objects using PPO in IsaacGym',resources:['📘 Spinning Up in Deep RL (OpenAI, free)','📘 Berkeley DeepRL course (free)']),
        CareerPhase(id:8,title:'Hardware & Electronics',subtitle:'Microcontrollers, actuators, sensors',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹12–22 LPA / \$90K',topics:['Arduino & Raspberry Pi','Microcontroller programming (STM32)','Motor drivers & servo control','Sensor integration (IMU, lidar, ultrasonic)','PCB design basics','Power electronics for robots','ROS 2 hardware interface'],tools:['Arduino','STM32','ROS 2 ros2_control','KiCad'],project:'Build a physical line-following robot with ROS 2 hardware interface',resources:['📘 Arduino Docs (free)','📘 ros2_control Docs (free)']),
        CareerPhase(id:9,title:'Portfolio & Research',subtitle:'Projects, papers, competitions',duration:'4–6 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹15–35 LPA / \$120K',topics:['2 robotics portfolio projects (physical or simulation)','RoboCup or similar competition','Open-source robotics contributions','Write a technical paper or blog post','ICRA/IROS paper reading','LinkedIn for robotics roles','HuggingFace LeRobot contributions'],tools:['GitHub','ROS Community','HuggingFace LeRobot'],project:'Build and open-source a complete robotics system on GitHub',resources:['📘 LeRobot (free)','📘 ROS Discourse (free)']),
        CareerPhase(id:10,title:'Interview & Job Ready',subtitle:'System design, coding, algorithms',duration:'3–5 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹18–50 LPA+ / \$130K+',topics:['Robotics system design interviews','C++ technical questions','Robot kinematics interview problems','Computer vision Q&A','ROS 2 architecture design','Salary negotiation at Boston Dynamics / Figure / 1X level'],tools:['LeetCode (C++)','Pramp'],project:'5 mock robotics interviews + apply to 10 robotics companies',resources:['📘 Robotics Interview Questions (GitHub, free)']),
      ],
    ),
  ],
);

// ──────────────────────────────────────────────────────────────────────
// 7. TESTING & QA
// ──────────────────────────────────────────────────────────────────────
const _testingQa = CareerCategory(
  id:    'testing_qa',
  title: 'Testing & QA',
  emoji: '🧪',
  color: Color(0xFF6EE7B7),
  careers: [
    CareerData(
      id:'qa_engineer', title:'QA Engineer',
      emoji:'🧪', tagline:'Ensure quality through testing and standards',
      level:'Beginner', skills:['Manual Testing','Selenium','Postman','Jira','SQL'],
      phases: [
        CareerPhase(id:1,title:'Software Testing Fundamentals',subtitle:'QA concepts, SDLC, test types',duration:'3–4 weeks',level:'Beginner',levelColor:'6EE7B7',salaryUnlock:'₹3–5 LPA / \$40K',topics:['Software testing principles','SDLC & STLC','Testing types: functional, non-functional, regression','Black box vs white box testing','Test planning & test cases','Bug lifecycle & severity','Test documentation (test plan, strategy)'],tools:['Jira','TestRail','Excel'],project:'Write a complete test plan and 50 test cases for a banking app',resources:['📘 ISTQB Foundation Study Guide','📘 SoftwareTestingHelp.com (free)']),
        CareerPhase(id:2,title:'API Testing',subtitle:'Postman, REST, validation',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹5–8 LPA / \$52K',topics:['HTTP methods & status codes','Postman: collections, environments, tests','JSON schema validation','Auth testing (JWT, OAuth)','Negative testing APIs','Contract testing basics','Newman (CLI for Postman)'],tools:['Postman','Newman','REST Assured'],project:'Build a complete API test suite in Postman for a public API',resources:['📘 Postman Learning Center (free)','📘 API Testing with Postman — Udemy']),
        CareerPhase(id:3,title:'Test Automation with Selenium',subtitle:'Web UI automation',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹6–10 LPA / \$60K',topics:['Selenium WebDriver with Python/Java','Page Object Model (POM)','XPath & CSS selectors','TestNG / pytest frameworks','Assertions & reporting','Handling dynamic elements','Screenshot on failure','Cross-browser testing'],tools:['Selenium','TestNG','pytest','ChromeDriver'],project:'Build an automated test suite for an e-commerce site with Selenium POM',resources:['📘 Selenium Docs (free)','📘 Selenium WebDriver with Python — Udemy']),
        CareerPhase(id:4,title:'Playwright & Modern Automation',subtitle:'Fast, reliable, modern testing',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–12 LPA / \$65K',topics:['Playwright architecture vs Selenium','Auto-wait & reliability','Playwright test runner','Network interception','Visual comparison testing','API testing with Playwright','Parallel test execution','Trace viewer for debugging'],tools:['Playwright','TypeScript','VS Code'],project:'Migrate a Selenium test suite to Playwright and reduce flakiness by 80%',resources:['📘 Playwright Docs (free)','📘 Playwright Testing YouTube']),
        CareerPhase(id:5,title:'Mobile Testing',subtitle:'Appium, real devices, cloud testing',duration:'3–4 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹7–12 LPA / \$65K',topics:['Appium setup for Android/iOS','Mobile testing challenges','XCUITest & Espresso native testing','BrowserStack / Sauce Labs cloud testing','Performance testing on mobile','Accessibility testing on mobile','Beta testing (TestFlight, Firebase App Distribution)'],tools:['Appium','BrowserStack','Espresso','XCUITest'],project:'Build Appium test suite for a mobile app covering 30 test scenarios',resources:['📘 Appium Docs (free)','📘 Mobile Testing with Appium — Udemy']),
        CareerPhase(id:6,title:'Performance & Load Testing',subtitle:'k6, JMeter, bottleneck finding',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹8–14 LPA / \$70K',topics:['Performance testing types: load, stress, spike, soak','k6 scripting','Apache JMeter','Locust for Python-based load tests','Performance metrics: TPS, latency, error rate','Identifying bottlenecks','Reporting & analysis'],tools:['k6','JMeter','Locust','Grafana'],project:'Load test a REST API to 10K RPS, find bottlenecks and document findings',resources:['📘 k6 Docs (free)','📘 JMeter Beginner to Advanced — Udemy']),
        CareerPhase(id:7,title:'Security & Accessibility Testing',subtitle:'OWASP, WCAG, security scanning',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹9–15 LPA / \$72K',topics:['OWASP Top 10 for testers','OWASP ZAP security scanning','WCAG 2.1 accessibility testing','Axe for automated accessibility checks','SQL injection testing','XSS testing','Security test reporting'],tools:['OWASP ZAP','Axe','Burp Suite Community'],project:'Complete security & accessibility audit of a web app with full report',resources:['📘 OWASP Testing Guide (free)','📘 WebAIM (free)']),
        CareerPhase(id:8,title:'CI/CD for QA',subtitle:'Integrate tests into pipelines',duration:'2–3 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹9–15 LPA / \$72K',topics:['GitHub Actions for test automation','Test parallelisation','Allure report generation','Failed test notifications','Nightly regression runs','Test data management','Shift-left testing mindset'],tools:['GitHub Actions','Allure','Docker','pytest-xdist'],project:'Set up a full CI pipeline that runs 200 tests on every PR',resources:['📘 GitHub Actions Docs (free)','📘 Allure Docs (free)']),
        CareerPhase(id:9,title:'Portfolio & ISTQB Certification',subtitle:'Cert prep, portfolio, community',duration:'4–5 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹10–18 LPA / \$75K',topics:['ISTQB Foundation Level exam prep','Portfolio: automation framework on GitHub','QA blog posts on Medium','Test Automation University (TAU)','LinkedIn QA profile','Contribute to open-source QA tooling'],tools:['TestAutomationU','ISTQB Portal'],project:'Pass ISTQB Foundation + publish automation framework on GitHub',resources:['📘 ISTQB Study Guide (free PDF)','📘 Test Automation University (free)']),
        CareerPhase(id:10,title:'Interview & Job Ready',subtitle:'Technical + practical scenarios',duration:'3–4 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹11–25 LPA+ / \$80K+',topics:['QA technical interview preparation','Automation code walkthroughs','Test scenario creation live','API testing scenarios','Bug report quality assessment','Salary negotiation for QA roles'],tools:['LeetCode (basic)','Pramp'],project:'5 mock QA interviews + apply to 20 companies',resources:['📘 QA Interview Questions (GitHub, free)']),
      ],
    ),
  ],
);

// ──────────────────────────────────────────────────────────────────────
// 8. SPECIALIZED
// ──────────────────────────────────────────────────────────────────────
const _specialized = CareerCategory(
  id:    'specialized',
  title: 'Specialized',
  emoji: '📈',
  color: Color(0xFFF59E0B),
  careers: [
    CareerData(
      id:'solutions_architect', title:'Solutions Architect',
      emoji:'🏗️', tagline:'Design enterprise-scale technical solutions',
      level:'Advanced', skills:['AWS','System Design','Enterprise Architecture','Security','Cost Optimisation'],
      phases: [
        CareerPhase(id:1,title:'Enterprise Architecture Foundations',subtitle:'Patterns, frameworks, stakeholders',duration:'4–5 weeks',level:'Intermediate',levelColor:'60A5FA',salaryUnlock:'₹12–18 LPA / \$90K',topics:['Enterprise architecture frameworks (TOGAF, Zachman)','Solution vs enterprise vs technical architect differences','Architecture decision records (ADRs)','Non-functional requirements (NFRs)','Stakeholder management & communication','Architecture documentation','Trade-off analysis'],tools:['Lucidchart','draw.io','Confluence'],project:'Create a full architecture document for a fintech system',resources:['📘 TOGAF 9 Foundation (free overview)','📘 Software Architecture Patterns — Mark Richards (free)']),
        CareerPhase(id:2,title:'Cloud Architecture (AWS)',subtitle:'Well-Architected Framework, services',duration:'5–6 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹15–25 LPA / \$110K',topics:['AWS Well-Architected Framework (5 pillars)','AWS architecture patterns','Multi-tier architecture on AWS','Serverless architecture','Event-driven architecture (EventBridge, SQS, SNS)','Data architecture (S3, Redshift, RDS, DynamoDB)','Disaster recovery: RTO/RPO'],tools:['AWS','CloudFormation','Terraform'],project:'Design and document a 3-tier production AWS architecture for 1M users',resources:['📘 AWS Well-Architected (free)','📘 AWS Architecture Center (free)']),
        CareerPhase(id:3,title:'Security Architecture',subtitle:'Zero trust, IAM, compliance',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹16–28 LPA / \$120K',topics:['Zero trust architecture','Identity & access management (IAM, RBAC, ABAC)','Encryption at rest and in transit','Security standards: ISO 27001, SOC 2, HIPAA, PCI-DSS','Threat modelling (STRIDE)','Data classification','Security architecture review process'],tools:['AWS IAM','Azure AD','OWASP Threat Dragon'],project:'Produce a security architecture review for a healthcare SaaS system',resources:['📘 NIST Zero Trust Architecture (free)','📘 AWS Security Best Practices (free)']),
        CareerPhase(id:4,title:'Data Architecture',subtitle:'Data lakes, warehouses, streaming',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹16–28 LPA / \$120K',topics:['Data lake vs data warehouse vs lakehouse','Modern data stack (Snowflake, dbt, Fivetran)','Streaming architecture (Kafka, Kinesis)','Data mesh architecture','Master data management','Data governance frameworks','Cost-optimised storage tiering'],tools:['Snowflake','dbt','Kafka','Apache Iceberg'],project:'Design a complete data platform architecture for an e-commerce company',resources:['📘 Fundamentals of Data Engineering — Joe Reis','📘 dbt Docs (free)']),
        CareerPhase(id:5,title:'Microservices & API Architecture',subtitle:'Service mesh, API gateway, DDD',duration:'4–5 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹15–26 LPA / \$115K',topics:['Microservices design principles','Domain-driven design (DDD)','API gateway patterns','Service mesh (Istio, Linkerd)','Event-driven microservices','Saga pattern & distributed transactions','GraphQL federation','API versioning strategies'],tools:['Istio','Kong API Gateway','gRPC','AsyncAPI'],project:'Design microservices architecture for a ride-sharing platform with 10 services',resources:['📘 Microservices.io (free)','📘 Building Microservices — Sam Newman']),
        CareerPhase(id:6,title:'Cost Optimisation & FinOps',subtitle:'Cloud cost management',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹16–28 LPA / \$120K',topics:['Cloud FinOps principles','Reserved Instances vs Savings Plans vs Spot','Rightsizing strategies','Cost allocation and tagging','Showback vs chargeback','AWS Cost Explorer mastery','TCO analysis (Total Cost of Ownership)','Architecture reviews for cost'],tools:['AWS Cost Explorer','CloudHealth','Terraform'],project:'Reduce a simulated cloud bill by 35% with documented justifications',resources:['📘 FinOps Foundation (free)','📘 AWS Cost Optimisation Hub (free)']),
        CareerPhase(id:7,title:'Emerging Technology Assessment',subtitle:'AI, edge, quantum evaluation',duration:'3–4 weeks',level:'Advanced',levelColor:'EF4444',salaryUnlock:'₹18–32 LPA / \$130K',topics:['How to evaluate and adopt new technologies','AI/ML architecture patterns','Edge computing architecture','IoT at enterprise scale','Blockchain for enterprise (private chains)','Technology radar methodology','PoC to production decision framework'],tools:['ThoughtWorks Tech Radar','AWS AI services'],project:'Write a technology assessment and recommendation for adopting LLMs in an enterprise',resources:['📘 ThoughtWorks Technology Radar (free)','📘 Gartner Hype Cycle (free overview)']),
        CareerPhase(id:8,title:'Certifications',subtitle:'AWS SAP, SAA, GCP, Azure',duration:'6–8 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹18–35 LPA / \$130K',topics:['AWS Solutions Architect Professional (SAP-C02)','AWS Solutions Architect Associate (SAA-C03)','GCP Professional Cloud Architect','Azure Solutions Architect Expert (AZ-305)','TOGAF 9 Foundation certification','Exam preparation strategy'],tools:['TutorialsDojo','A Cloud Guru','Whizlabs'],project:'Pass AWS SAA-C03 and start AWS SAP-C02 prep',resources:['📘 TutorialsDojo Practice Exams','📘 AWS Official Exam Guide (free)']),
        CareerPhase(id:9,title:'Client Engagement & Presales',subtitle:'RFPs, workshops, presentations',duration:'3–4 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹20–40 LPA / \$140K',topics:['RFP response writing','Solution workshops facilitation','Executive presentation skills','Proof of concept (PoC) delivery','Customer success handoffs','Stakeholder management at C-level','Commercial awareness for architects'],tools:['PowerPoint','Miro','Confluence'],project:'Prepare and present a mock solution proposal for a Fortune 500 migration',resources:['📘 Presentation Zen — Garr Reynolds','📘 Winning Complex Sales (various)']),
        CareerPhase(id:10,title:'Interview & Job Ready',subtitle:'Architecture design, whiteboard, stakeholder',duration:'3–4 weeks',level:'Career Prep',levelColor:'EF4444',salaryUnlock:'₹22–55 LPA+ / \$150K+',topics:['Architecture design whiteboard interviews','Trade-off analysis live','STAR stories for architecture decisions','Salary negotiation for architect roles','FAANG vs SI vs consulting paths','Contract vs full-time architecture roles'],tools:['Pramp'],project:'5 mock architecture interviews + apply to 15 architecture roles',resources:['📘 AWS Architecture Blog (free)','📘 Architecture Interview Guide (GitHub, free)']),
      ],
    ),
  ],
);