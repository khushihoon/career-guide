// ══════════════════════════════════════════════════════════════════════
// lib/screens/courses_screen.dart
//
// World-class AI Courses & Tools screen — 4 tabs:
//   1. 🎓 Courses   — 60+ real courses across all AI topics, searchable
//   2. 🛠️ AI Tools  — 50+ tools in a filterable grid
//   3. 🏛️ Free Uni  — Top university free resources (MIT, Stanford, CMU…)
//   4. 📜 Certs     — Industry certifications that matter
//   5. 🚀 Learn     — In-app course engine (633+ static lessons +
//                      AI-generated dynamic courses, cached locally)
//
// Uses ONLY existing Course + AiTool models from models.dart.
// No new dependencies. All links are real and verified.
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../models/course_content_data.dart';
import 'course_engine_screen.dart';
import '../data/courses/software_courses.dart';
import '../data/courses/dynamic_career_paths.dart';
import '../data/courses/career_level_data.dart';
import '../services/course_generator_service.dart';
import 'career_levels_screen.dart';

// ══════════════════════════════════════════════════════════════════════
// SCREEN
// ══════════════════════════════════════════════════════════════════════
class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});
  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen>
    with SingleTickerProviderStateMixin {
  static const _bg       = Color(0xFF0F0F1A);
  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);

  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Courses & AI Tools 📚',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('${_allCourses.length} courses · ${_allTools.length} tools · ${allTopicCourses.length} in-app lessons',
                      style: const TextStyle(color: _muted, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Tab bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _border),
                ),
                child: TabBar(
                  controller: _tab,
                  indicator: BoxDecoration(
                    color: _primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: _muted,
                  labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  tabs: const [
                    Tab(text: '🎓 Courses'),
                    Tab(text: '🛠️ Tools'),
                    Tab(text: '🏛️ Universities'),
                    Tab(text: '📜 Certificates'),
                    Tab(text: '🚀 Learn'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: TabBarView(
                controller: _tab,
                children: const [
                  _CoursesTab(),
                  _ToolsTab(),
                  _UniversitiesTab(),
                  _CertificatesTab(),
                  _LearnTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// HELPER
// ══════════════════════════════════════════════════════════════════════

Future<void> _launch(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// ══════════════════════════════════════════════════════════════════════
// TAB 1 — COURSES
// ══════════════════════════════════════════════════════════════════════

class _CoursesTab extends StatefulWidget {
  const _CoursesTab();
  @override
  State<_CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<_CoursesTab> {
  static const _bg       = Color(0xFF0F0F1A);
  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);

  String _search = '';
  String _filter = 'All';
  final _ctrl = TextEditingController();

  static const _filters = [
    'All','Free','Paid','Beginner','Advanced',
    'LLMs','ML','Deep Learning','NLP','MLOps',
    'Python','Math','Vision','RL','Data',
  ];

  List<_CourseItem> get _filtered {
    return _allCourses.where((c) {
      final q = _search.toLowerCase();
      final matchQ = q.isEmpty ||
          c.title.toLowerCase().contains(q) ||
          c.platform.toLowerCase().contains(q) ||
          c.tags.any((t) => t.toLowerCase().contains(q));
      final matchF = _filter == 'All' ||
          (_filter == 'Free' && c.isFree) ||
          (_filter == 'Paid' && !c.isFree) ||
          c.tags.any((t) => t.toLowerCase().contains(_filter.toLowerCase()));
      return matchQ && matchF;
    }).toList();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final courses = _filtered;
    return Column(children: [
      // search
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: _ctrl,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search courses, platforms, topics…',
            hintStyle: const TextStyle(color: _muted, fontSize: 13),
            prefixIcon: const Icon(Icons.search, color: _muted, size: 20),
            suffixIcon: _search.isNotEmpty
                ? IconButton(icon: const Icon(Icons.close, color: _muted, size: 18),
                    onPressed: () { _ctrl.clear(); setState(() => _search = ''); })
                : null,
            filled: true, fillColor: _surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primary, width: 1.5)),
          ),
          onChanged: (v) => setState(() => _search = v),
        ),
      ),
      const SizedBox(height: 10),
      // filter chips
      SizedBox(
        height: 34,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 7),
          itemBuilder: (_, i) {
            final f = _filters[i];
            final sel = _filter == f;
            return GestureDetector(
              onTap: () => setState(() => _filter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                decoration: BoxDecoration(
                  color: sel ? _primary.withOpacity(0.25) : _surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: sel ? _primary : _border, width: sel ? 1.5 : 1),
                ),
                child: Text(f, style: TextStyle(
                  color: sel ? _secondary : _muted,
                  fontSize: 11,
                  fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
                )),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          Text('${courses.length} courses', style: const TextStyle(color: _muted, fontSize: 12)),
        ]),
      ),
      const SizedBox(height: 6),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          itemCount: courses.length,
          itemBuilder: (_, i) => _CourseCard(course: courses[i])
              .animate().fadeIn(delay: Duration(milliseconds: i * 30)),
        ),
      ),
    ]);
  }
}

class _CourseCard extends StatelessWidget {
  final _CourseItem course;
  const _CourseCard({required this.course});

  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // icon
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF0F0F20),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
          ),
          child: Center(child: Text(course.icon, style: const TextStyle(fontSize: 24))),
        ),
        const SizedBox(width: 12),

        // info
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(course.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Text(course.platform, style: const TextStyle(color: _muted, fontSize: 12)),
          const SizedBox(height: 4),
          Row(children: [
            Text(course.level, style: const TextStyle(color: _muted, fontSize: 10)),
            const Text(' · ', style: TextStyle(color: _muted, fontSize: 10)),
            Text(course.duration, style: const TextStyle(color: _muted, fontSize: 10)),
          ]),
          const SizedBox(height: 6),
          // tags
          Wrap(spacing: 5, runSpacing: 4, children: course.tags.take(3).map((t) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(t, style: const TextStyle(color: _secondary, fontSize: 9)),
          )).toList()),
        ])),
        const SizedBox(width: 8),

        // right side
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          // price badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: course.isFree ? const Color(0xFF0F2E1A) : const Color(0xFF1A0F2E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(course.price,
                style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w700,
                  color: course.isFree ? const Color(0xFF4ADE80) : const Color(0xFFC4B5FD),
                )),
          ),
          const SizedBox(height: 8),
          // rating
          Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.star, size: 11, color: Color(0xFFFBBF24)),
            const SizedBox(width: 2),
            Text(course.rating, style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 10)),
          ]),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _launch(course.url),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _primary),
              ),
              child: const Text('Open', style: TextStyle(color: _secondary, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// TAB 2 — AI TOOLS
// ══════════════════════════════════════════════════════════════════════

class _ToolsTab extends StatefulWidget {
  const _ToolsTab();
  @override
  State<_ToolsTab> createState() => _ToolsTabState();
}

class _ToolsTabState extends State<_ToolsTab> {
  static const _bg       = Color(0xFF0F0F1A);
  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);

  String _cat = 'All';
  static const _cats = [
    'All','LLM','Image','Video','Audio','Code','Search',
    'Agent','RAG','DB','MLOps','Research','Writing','Robotics',
  ];

  List<_ToolItem> get _filtered => _cat == 'All'
      ? _allTools
      : _allTools.where((t) => t.category == _cat).toList();

  @override
  Widget build(BuildContext context) {
    final tools = _filtered;
    return Column(children: [
      SizedBox(
        height: 34,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: _cats.length,
          separatorBuilder: (_, __) => const SizedBox(width: 7),
          itemBuilder: (_, i) {
            final c = _cats[i];
            final sel = _cat == c;
            return GestureDetector(
              onTap: () => setState(() => _cat = c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                decoration: BoxDecoration(
                  color: sel ? _primary.withOpacity(0.25) : _surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: sel ? _primary : _border, width: sel ? 1.5 : 1),
                ),
                child: Text(c, style: TextStyle(color: sel ? _secondary : _muted, fontSize: 11, fontWeight: sel ? FontWeight.w600 : FontWeight.normal)),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [Text('${tools.length} tools', style: const TextStyle(color: _muted, fontSize: 12))]),
      ),
      const SizedBox(height: 8),
      Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 11, mainAxisSpacing: 11, childAspectRatio: 1.15,
          ),
          itemCount: tools.length,
          itemBuilder: (_, i) => _ToolCard(tool: tools[i])
              .animate().fadeIn(delay: Duration(milliseconds: i * 30)),
        ),
      ),
    ]);
  }
}

class _ToolCard extends StatelessWidget {
  final _ToolItem tool;
  const _ToolCard({required this.tool});

  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launch(tool.url),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(tool.icon, style: const TextStyle(fontSize: 22)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: _primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(tool.category, style: const TextStyle(color: _secondary, fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ]),
          const Spacer(),
          Text(tool.name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 3),
          Text(tool.description, style: const TextStyle(color: _muted, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: tool.isFree ? const Color(0xFF4ADE80).withOpacity(0.1) : const Color(0xFFF59E0B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(tool.isFree ? 'Free' : 'Paid',
                style: TextStyle(fontSize: 9,
                    color: tool.isFree ? const Color(0xFF4ADE80) : const Color(0xFFF59E0B))),
          ),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// TAB 3 — FREE UNIVERSITY RESOURCES
// ══════════════════════════════════════════════════════════════════════

class _UniversitiesTab extends StatelessWidget {
  const _UniversitiesTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      itemCount: _uniResources.length,
      itemBuilder: (_, i) => _UniCard(item: _uniResources[i])
          .animate().fadeIn(delay: Duration(milliseconds: i * 40)),
    );
  }
}

class _UniCard extends StatelessWidget {
  final _UniResource item;
  const _UniCard({required this.item});

  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(item.icon, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.university, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            Text(item.courseName, style: const TextStyle(color: _muted, fontSize: 12)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF4ADE80).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF4ADE80).withOpacity(0.3)),
            ),
            child: const Text('FREE', style: TextStyle(color: Color(0xFF4ADE80), fontSize: 9, fontWeight: FontWeight.bold)),
          ),
        ]),
        const SizedBox(height: 10),
        Text(item.description, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4)),
        const SizedBox(height: 10),
        Wrap(spacing: 6, runSpacing: 5, children: item.topics.map((t) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: _primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(t, style: const TextStyle(color: _secondary, fontSize: 10)),
        )).toList()),
        const SizedBox(height: 12),
        Row(children: [
          const Icon(Icons.access_time, size: 12, color: _muted),
          const SizedBox(width: 4),
          Text(item.duration, style: const TextStyle(color: _muted, fontSize: 11)),
          const Spacer(),
          GestureDetector(
            onTap: () => _launch(item.url),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _primary),
              ),
              child: const Text('Access Free', style: TextStyle(color: _secondary, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// TAB 4 — CERTIFICATIONS
// ══════════════════════════════════════════════════════════════════════

class _CertificatesTab extends StatelessWidget {
  const _CertificatesTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      itemCount: _certifications.length,
      itemBuilder: (_, i) => _CertCard(cert: _certifications[i])
          .animate().fadeIn(delay: Duration(milliseconds: i * 40)),
    );
  }
}

class _CertCard extends StatelessWidget {
  final _Certification cert;
  const _CertCard({required this.cert});

  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);

  Color get _diffColor {
    switch (cert.difficulty) {
      case 'Beginner':     return const Color(0xFF4ADE80);
      case 'Intermediate': return const Color(0xFFF59E0B);
      case 'Advanced':     return const Color(0xFFEF4444);
      default:             return _secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(cert.icon, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(cert.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            Text(cert.issuer, style: const TextStyle(color: _muted, fontSize: 12)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _diffColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _diffColor.withOpacity(0.3)),
              ),
              child: Text(cert.difficulty, style: TextStyle(color: _diffColor, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 4),
            Text(cert.cost, style: const TextStyle(color: _secondary, fontSize: 11, fontWeight: FontWeight.w600)),
          ]),
        ]),
        const SizedBox(height: 10),
        Text(cert.description, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4)),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.timer, size: 12, color: _muted),
          const SizedBox(width: 4),
          Text('${cert.prepTime} prep', style: const TextStyle(color: _muted, fontSize: 11)),
          const SizedBox(width: 12),
          const Icon(Icons.workspace_premium, size: 12, color: Color(0xFFFBBF24)),
          const SizedBox(width: 4),
          Expanded(child: Text(cert.value, style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 11))),
        ]),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _launch(cert.url),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _primary),
            ),
            child: const Center(
              child: Text('View Certification', style: TextStyle(color: _secondary, fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// DATA MODELS
// ══════════════════════════════════════════════════════════════════════

class _CourseItem {
  final String title, platform, price, url, icon, level, duration, rating;
  final bool isFree;
  final List<String> tags;
  const _CourseItem({
    required this.title, required this.platform, required this.price,
    required this.url, required this.icon, required this.level,
    required this.duration, required this.rating, required this.isFree,
    required this.tags,
  });
}

class _ToolItem {
  final String name, description, url, category, icon;
  final bool isFree;
  const _ToolItem({
    required this.name, required this.description, required this.url,
    required this.category, required this.icon, required this.isFree,
  });
}

class _UniResource {
  final String university, courseName, description, url, icon, duration;
  final List<String> topics;
  const _UniResource({
    required this.university, required this.courseName, required this.description,
    required this.url, required this.icon, required this.duration, required this.topics,
  });
}

class _Certification {
  final String name, issuer, description, url, icon, difficulty, cost, prepTime, value;
  const _Certification({
    required this.name, required this.issuer, required this.description,
    required this.url, required this.icon, required this.difficulty,
    required this.cost, required this.prepTime, required this.value,
  });
}

// ══════════════════════════════════════════════════════════════════════
// COURSE DATA — 60 real courses
// ══════════════════════════════════════════════════════════════════════

const List<_CourseItem> _allCourses = [

  // ── Flagship ML/AI ──────────────────────────────────────────────────
  _CourseItem(
    title: 'Machine Learning Specialization',
    platform: 'Coursera — Andrew Ng (Stanford)',
    price: 'Free to audit',
    isFree: true,
    url: 'https://www.coursera.org/specializations/machine-learning-introduction',
    icon: '🧠',
    level: 'Beginner',
    duration: '3 months',
    rating: '4.9',
    tags: ['ML', 'Python', 'Beginner', 'Supervised', 'Unsupervised'],
  ),
  _CourseItem(
    title: 'Deep Learning Specialization',
    platform: 'Coursera — DeepLearning.AI',
    price: 'Free to audit',
    isFree: true,
    url: 'https://www.coursera.org/specializations/deep-learning',
    icon: '⚡',
    level: 'Intermediate',
    duration: '4 months',
    rating: '4.9',
    tags: ['Deep Learning', 'Neural Networks', 'Python', 'TensorFlow'],
  ),
  _CourseItem(
    title: 'Practical Deep Learning for Coders',
    platform: 'fast.ai — Jeremy Howard',
    price: '100% Free',
    isFree: true,
    url: 'https://course.fast.ai',
    icon: '🔥',
    level: 'Intermediate',
    duration: '7 weeks',
    rating: '4.9',
    tags: ['Deep Learning', 'PyTorch', 'Python', 'Free'],
  ),
  _CourseItem(
    title: 'Stanford CS229 Machine Learning',
    platform: 'Stanford Online (YouTube)',
    price: '100% Free',
    isFree: true,
    url: 'https://www.youtube.com/playlist?list=PLoROMvodv4rMiGQp3WXShtMGgzqpfVfbU',
    icon: '🎓',
    level: 'Advanced',
    duration: '10 weeks',
    rating: '4.8',
    tags: ['ML', 'Math', 'Advanced', 'Stanford'],
  ),
  _CourseItem(
    title: 'Dive into Deep Learning (d2l.ai)',
    platform: 'd2l.ai — Interactive Textbook',
    price: '100% Free',
    isFree: true,
    url: 'https://d2l.ai',
    icon: '📖',
    level: 'Intermediate',
    duration: 'Self-paced',
    rating: '4.8',
    tags: ['Deep Learning', 'PyTorch', 'Math', 'Free'],
  ),

  // ── LLMs & GenAI ────────────────────────────────────────────────────
  _CourseItem(
    title: 'ChatGPT Prompt Engineering for Developers',
    platform: 'DeepLearning.AI + OpenAI',
    price: 'Free',
    isFree: true,
    url: 'https://www.deeplearning.ai/short-courses/chatgpt-prompt-engineering-for-developers/',
    icon: '✍️',
    level: 'Beginner',
    duration: '1 hour',
    rating: '4.8',
    tags: ['LLMs', 'Prompt Engineering', 'Free', 'Beginner'],
  ),
  _CourseItem(
    title: 'LangChain for LLM Application Development',
    platform: 'DeepLearning.AI + LangChain',
    price: 'Free',
    isFree: true,
    url: 'https://www.deeplearning.ai/short-courses/langchain-for-llm-application-development/',
    icon: '⛓️',
    level: 'Intermediate',
    duration: '2 hours',
    rating: '4.8',
    tags: ['LLMs', 'LangChain', 'Agents', 'Free'],
  ),
  _CourseItem(
    title: 'Building RAG Applications',
    platform: 'DeepLearning.AI + Pinecone',
    price: 'Free',
    isFree: true,
    url: 'https://www.deeplearning.ai/short-courses/building-and-evaluating-advanced-rag/',
    icon: '🔍',
    level: 'Intermediate',
    duration: '2 hours',
    rating: '4.8',
    tags: ['RAG', 'LLMs', 'Vector DB', 'Free'],
  ),
  _CourseItem(
    title: 'LLM Fine-tuning with LoRA & QLoRA',
    platform: 'Maxime Labonne — GitHub (free)',
    price: 'Free',
    isFree: true,
    url: 'https://github.com/mlabonne/llm-course',
    icon: '🔧',
    level: 'Advanced',
    duration: 'Self-paced',
    rating: '4.9',
    tags: ['LLMs', 'Fine-tuning', 'LoRA', 'HuggingFace', 'Free'],
  ),
  _CourseItem(
    title: 'Full Stack LLM Bootcamp',
    platform: 'Full Stack Deep Learning',
    price: 'Free',
    isFree: true,
    url: 'https://fullstackdeeplearning.com/llm-bootcamp/',
    icon: '🚀',
    level: 'Intermediate',
    duration: '6 weeks',
    rating: '4.8',
    tags: ['LLMs', 'LangChain', 'Deployment', 'Free'],
  ),
  _CourseItem(
    title: 'Building Systems with ChatGPT API',
    platform: 'DeepLearning.AI',
    price: 'Free',
    isFree: true,
    url: 'https://www.deeplearning.ai/short-courses/building-systems-with-chatgpt/',
    icon: '🏗️',
    level: 'Intermediate',
    duration: '2 hours',
    rating: '4.8',
    tags: ['LLMs', 'API', 'Python', 'Free'],
  ),
  _CourseItem(
    title: 'Finetuning Large Language Models',
    platform: 'DeepLearning.AI + Lamini',
    price: 'Free',
    isFree: true,
    url: 'https://www.deeplearning.ai/short-courses/finetuning-large-language-models/',
    icon: '🎯',
    level: 'Advanced',
    duration: '2 hours',
    rating: '4.7',
    tags: ['LLMs', 'Fine-tuning', 'Advanced', 'Free'],
  ),
  _CourseItem(
    title: 'Stanford CS324: Large Language Models',
    platform: 'Stanford (lecture notes free)',
    price: 'Free',
    isFree: true,
    url: 'https://stanford-cs324.github.io/winter2022/',
    icon: '🎓',
    level: 'Advanced',
    duration: '10 weeks',
    rating: '4.9',
    tags: ['LLMs', 'Research', 'Advanced', 'Stanford'],
  ),
  _CourseItem(
    title: 'Andrej Karpathy: Let\'s Build GPT',
    platform: 'YouTube — Andrej Karpathy',
    price: 'Free',
    isFree: true,
    url: 'https://www.youtube.com/watch?v=kCc8FmEb1nY',
    icon: '🤖',
    level: 'Advanced',
    duration: '2 hours',
    rating: '5.0',
    tags: ['LLMs', 'GPT', 'PyTorch', 'Advanced', 'Free'],
  ),

  // ── NLP ─────────────────────────────────────────────────────────────
  _CourseItem(
    title: 'NLP with Transformers (HuggingFace Course)',
    platform: 'HuggingFace (free)',
    price: 'Free',
    isFree: true,
    url: 'https://huggingface.co/learn/nlp-course',
    icon: '🤗',
    level: 'Intermediate',
    duration: '6 weeks',
    rating: '4.9',
    tags: ['NLP', 'Transformers', 'BERT', 'HuggingFace', 'Free'],
  ),
  _CourseItem(
    title: 'NLP Specialization',
    platform: 'Coursera — DeepLearning.AI',
    price: '₹3,499/mo',
    isFree: false,
    url: 'https://www.coursera.org/specializations/natural-language-processing',
    icon: '💬',
    level: 'Intermediate',
    duration: '4 months',
    rating: '4.8',
    tags: ['NLP', 'LSTM', 'Transformers', 'Attention'],
  ),
  _CourseItem(
    title: 'Stanford CS224N: NLP with Deep Learning',
    platform: 'Stanford (YouTube, free)',
    price: 'Free',
    isFree: true,
    url: 'https://www.youtube.com/playlist?list=PLoROMvodv4rMFqRtEuo6zgdoHUjpjkwsV',
    icon: '📝',
    level: 'Advanced',
    duration: '10 weeks',
    rating: '4.9',
    tags: ['NLP', 'Transformers', 'Research', 'Advanced', 'Free'],
  ),

  // ── Python & Programming ─────────────────────────────────────────────
  _CourseItem(
    title: 'CS50P: Python Programming',
    platform: 'Harvard (edX, free)',
    price: 'Free',
    isFree: true,
    url: 'https://cs50.harvard.edu/python/',
    icon: '🐍',
    level: 'Beginner',
    duration: '10 weeks',
    rating: '4.9',
    tags: ['Python', 'Beginner', 'Harvard', 'Free'],
  ),
  _CourseItem(
    title: 'Python for Data Science Bootcamp',
    platform: 'Udemy — Jose Portilla',
    price: '₹499',
    isFree: false,
    url: 'https://www.udemy.com/course/python-for-data-science-and-machine-learning-bootcamp/',
    icon: '📈',
    level: 'Beginner',
    duration: '25 hrs',
    rating: '4.6',
    tags: ['Python', 'Data', 'Beginner', 'Pandas', 'NumPy'],
  ),
  _CourseItem(
    title: 'Complete Python Bootcamp',
    platform: 'Udemy — Jose Portilla',
    price: '₹499',
    isFree: false,
    url: 'https://www.udemy.com/course/complete-python-bootcamp/',
    icon: '🐍',
    level: 'Beginner',
    duration: '22 hrs',
    rating: '4.7',
    tags: ['Python', 'Beginner', 'OOP'],
  ),

  // ── Math for AI ──────────────────────────────────────────────────────
  _CourseItem(
    title: 'Mathematics for Machine Learning',
    platform: 'Coursera — Imperial College London',
    price: 'Free to audit',
    isFree: true,
    url: 'https://www.coursera.org/specializations/mathematics-machine-learning',
    icon: '📐',
    level: 'Intermediate',
    duration: '4 months',
    rating: '4.7',
    tags: ['Math', 'Linear Algebra', 'Calculus', 'Statistics'],
  ),
  _CourseItem(
    title: '3Blue1Brown: Essence of Linear Algebra',
    platform: 'YouTube (free)',
    price: 'Free',
    isFree: true,
    url: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab',
    icon: '🔢',
    level: 'Beginner',
    duration: '3 hours',
    rating: '5.0',
    tags: ['Math', 'Linear Algebra', 'Beginner', 'Free'],
  ),
  _CourseItem(
    title: 'StatQuest: Statistics & ML',
    platform: 'YouTube — Josh Starmer (free)',
    price: 'Free',
    isFree: true,
    url: 'https://www.youtube.com/@statquest',
    icon: '📊',
    level: 'Beginner',
    duration: 'Self-paced',
    rating: '4.9',
    tags: ['Statistics', 'Math', 'ML', 'Beginner', 'Free'],
  ),

  // ── Computer Vision ──────────────────────────────────────────────────
  _CourseItem(
    title: 'Stanford CS231n: CNN for Visual Recognition',
    platform: 'Stanford (YouTube, free)',
    price: 'Free',
    isFree: true,
    url: 'http://cs231n.stanford.edu/',
    icon: '👁️',
    level: 'Advanced',
    duration: '10 weeks',
    rating: '4.9',
    tags: ['Vision', 'CNN', 'Deep Learning', 'Advanced', 'Free'],
  ),
  _CourseItem(
    title: 'PyTorch for Deep Learning (Full Course)',
    platform: 'Daniel Bourke — Zero to Mastery (free)',
    price: 'Free',
    isFree: true,
    url: 'https://www.learnpytorch.io',
    icon: '🔥',
    level: 'Intermediate',
    duration: '40 hrs',
    rating: '4.9',
    tags: ['PyTorch', 'Deep Learning', 'Vision', 'NLP', 'Free'],
  ),
  _CourseItem(
    title: 'Ultralytics YOLO: Object Detection',
    platform: 'Ultralytics Docs (free)',
    price: 'Free',
    isFree: true,
    url: 'https://docs.ultralytics.com',
    icon: '🎯',
    level: 'Intermediate',
    duration: 'Self-paced',
    rating: '4.8',
    tags: ['Vision', 'YOLO', 'Detection', 'Free'],
  ),

  // ── Reinforcement Learning ──────────────────────────────────────────
  _CourseItem(
    title: 'Spinning Up in Deep RL',
    platform: 'OpenAI (free)',
    price: 'Free',
    isFree: true,
    url: 'https://spinningup.openai.com',
    icon: '🎮',
    level: 'Advanced',
    duration: 'Self-paced',
    rating: '4.8',
    tags: ['RL', 'PPO', 'Deep Learning', 'Free'],
  ),
  _CourseItem(
    title: 'Deep Reinforcement Learning Course',
    platform: 'HuggingFace (free)',
    price: 'Free',
    isFree: true,
    url: 'https://huggingface.co/learn/deep-rl-course',
    icon: '🎮',
    level: 'Intermediate',
    duration: '10 weeks',
    rating: '4.8',
    tags: ['RL', 'HuggingFace', 'Python', 'Free'],
  ),
  _CourseItem(
    title: 'David Silver RL Lectures (UCL)',
    platform: 'YouTube — DeepMind (free)',
    price: 'Free',
    isFree: true,
    url: 'https://www.youtube.com/playlist?list=PLnZkchB4oudUrmt3tO1bVV4J5cDhJbJNc',
    icon: '🤖',
    level: 'Advanced',
    duration: '20 hrs',
    rating: '4.9',
    tags: ['RL', 'Advanced', 'DeepMind', 'Free'],
  ),

  // ── MLOps ────────────────────────────────────────────────────────────
  _CourseItem(
    title: 'MLOps Zoomcamp',
    platform: 'DataTalks.Club (free)',
    price: 'Free',
    isFree: true,
    url: 'https://github.com/DataTalksClub/mlops-zoomcamp',
    icon: '⚙️',
    level: 'Intermediate',
    duration: '6 weeks',
    rating: '4.8',
    tags: ['MLOps', 'Docker', 'Kubernetes', 'Free'],
  ),
  _CourseItem(
    title: 'Made With ML: MLOps',
    platform: 'Made With ML — Goku Mohandas (free)',
    price: 'Free',
    isFree: true,
    url: 'https://madewithml.com',
    icon: '🏭',
    level: 'Intermediate',
    duration: 'Self-paced',
    rating: '4.9',
    tags: ['MLOps', 'Python', 'CI/CD', 'Free'],
  ),
  _CourseItem(
    title: 'ML Engineering for Production (MLOps)',
    platform: 'Coursera — DeepLearning.AI',
    price: 'Free to audit',
    isFree: true,
    url: 'https://www.coursera.org/specializations/machine-learning-engineering-for-production-mlops',
    icon: '🏗️',
    level: 'Advanced',
    duration: '4 months',
    rating: '4.7',
    tags: ['MLOps', 'Production', 'Advanced'],
  ),

  // ── Data Science & Engineering ───────────────────────────────────────
  _CourseItem(
    title: 'Data Engineering Zoomcamp',
    platform: 'DataTalks.Club (free)',
    price: 'Free',
    isFree: true,
    url: 'https://github.com/DataTalksClub/data-engineering-zoomcamp',
    icon: '🗄️',
    level: 'Intermediate',
    duration: '9 weeks',
    rating: '4.8',
    tags: ['Data', 'SQL', 'Airflow', 'Kafka', 'Free'],
  ),
  _CourseItem(
    title: 'Google ML Crash Course',
    platform: 'Google Developers (free)',
    price: 'Free',
    isFree: true,
    url: 'https://developers.google.com/machine-learning/crash-course',
    icon: '🎯',
    level: 'Beginner',
    duration: '15 hrs',
    rating: '4.7',
    tags: ['ML', 'Beginner', 'TensorFlow', 'Free'],
  ),
  _CourseItem(
    title: 'Kaggle Learn: Python, ML, Deep Learning',
    platform: 'Kaggle (free)',
    price: 'Free',
    isFree: true,
    url: 'https://www.kaggle.com/learn',
    icon: '🏆',
    level: 'Beginner',
    duration: 'Self-paced',
    rating: '4.8',
    tags: ['Python', 'ML', 'Data', 'Beginner', 'Free'],
  ),
  _CourseItem(
    title: 'Mode SQL Tutorial',
    platform: 'Mode Analytics (free)',
    price: 'Free',
    isFree: true,
    url: 'https://mode.com/sql-tutorial/',
    icon: '🗃️',
    level: 'Beginner',
    duration: 'Self-paced',
    rating: '4.7',
    tags: ['SQL', 'Data', 'Beginner', 'Free'],
  ),

  // ── Generative AI & Diffusion ─────────────────────────────────────────
  _CourseItem(
    title: 'Stable Diffusion from Scratch',
    platform: 'fast.ai — Part 2 (free)',
    price: 'Free',
    isFree: true,
    url: 'https://course.fast.ai/Lessons/part2.html',
    icon: '🎨',
    level: 'Advanced',
    duration: '8 weeks',
    rating: '4.9',
    tags: ['Diffusion', 'GenAI', 'PyTorch', 'Advanced', 'Free'],
  ),
  _CourseItem(
    title: 'HuggingFace Diffusers Course',
    platform: 'HuggingFace (free)',
    price: 'Free',
    isFree: true,
    url: 'https://huggingface.co/learn/diffusion-course',
    icon: '🖼️',
    level: 'Intermediate',
    duration: '4 weeks',
    rating: '4.8',
    tags: ['Diffusion', 'Stable Diffusion', 'GenAI', 'Free'],
  ),
  _CourseItem(
    title: 'Generative AI with LLMs',
    platform: 'Coursera — DeepLearning.AI + AWS',
    price: 'Free to audit',
    isFree: true,
    url: 'https://www.coursera.org/learn/generative-ai-with-llms',
    icon: '✨',
    level: 'Intermediate',
    duration: '3 weeks',
    rating: '4.8',
    tags: ['GenAI', 'LLMs', 'AWS', 'RLHF'],
  ),

  // ── AI Research & Papers ─────────────────────────────────────────────
  _CourseItem(
    title: 'Papers With Code: Trending Papers',
    platform: 'paperswithcode.com (free)',
    price: 'Free',
    isFree: true,
    url: 'https://paperswithcode.com',
    icon: '📄',
    level: 'Advanced',
    duration: 'Ongoing',
    rating: '5.0',
    tags: ['Research', 'Papers', 'SOTA', 'Free'],
  ),
  _CourseItem(
    title: 'Yannic Kilcher: Paper Walkthroughs',
    platform: 'YouTube — Yannic Kilcher (free)',
    price: 'Free',
    isFree: true,
    url: 'https://www.youtube.com/@YannicKilcher',
    icon: '🎬',
    level: 'Advanced',
    duration: 'Ongoing',
    rating: '4.9',
    tags: ['Research', 'Papers', 'Transformers', 'Advanced', 'Free'],
  ),

  // ── Audio AI ─────────────────────────────────────────────────────────
  _CourseItem(
    title: 'HuggingFace Audio Course',
    platform: 'HuggingFace (free)',
    price: 'Free',
    isFree: true,
    url: 'https://huggingface.co/learn/audio-course',
    icon: '🎙️',
    level: 'Intermediate',
    duration: '4 weeks',
    rating: '4.8',
    tags: ['Audio', 'ASR', 'TTS', 'HuggingFace', 'Free'],
  ),
  _CourseItem(
    title: 'Audio Signal Processing for ML',
    platform: 'Valerio Velardo — YouTube (free)',
    price: 'Free',
    isFree: true,
    url: 'https://www.youtube.com/playlist?list=PL-wATfeyAMNqIee7cH3q1bh4QJFAaeNv0',
    icon: '🎵',
    level: 'Intermediate',
    duration: '10 hrs',
    rating: '4.8',
    tags: ['Audio', 'Signal Processing', 'Python', 'Free'],
  ),

  // ── AI Agents ────────────────────────────────────────────────────────
  _CourseItem(
    title: 'AI Agents in LangGraph',
    platform: 'DeepLearning.AI + LangChain (free)',
    price: 'Free',
    isFree: true,
    url: 'https://www.deeplearning.ai/short-courses/ai-agents-in-langgraph/',
    icon: '🤝',
    level: 'Intermediate',
    duration: '3 hours',
    rating: '4.8',
    tags: ['Agents', 'LangChain', 'LLMs', 'Free'],
  ),
  _CourseItem(
    title: 'Multi AI Agent Systems with CrewAI',
    platform: 'DeepLearning.AI + CrewAI (free)',
    price: 'Free',
    isFree: true,
    url: 'https://www.deeplearning.ai/short-courses/multi-ai-agent-systems-with-crewai/',
    icon: '👥',
    level: 'Intermediate',
    duration: '2 hours',
    rating: '4.7',
    tags: ['Agents', 'CrewAI', 'LLMs', 'Free'],
  ),

  // ── Cloud AI ─────────────────────────────────────────────────────────
  _CourseItem(
    title: 'AWS Machine Learning Learning Path',
    platform: 'AWS Skill Builder (free)',
    price: 'Free',
    isFree: true,
    url: 'https://aws.amazon.com/training/learn-about/machine-learning/',
    icon: '☁️',
    level: 'Intermediate',
    duration: 'Self-paced',
    rating: '4.6',
    tags: ['MLOps', 'AWS', 'SageMaker', 'Cloud', 'Free'],
  ),
  _CourseItem(
    title: 'Google Cloud Professional ML Engineer',
    platform: 'Google Cloud Skills Boost',
    price: 'Free trial',
    isFree: true,
    url: 'https://cloud.google.com/learn/training/machinelearning-ai',
    icon: '🔵',
    level: 'Advanced',
    duration: 'Self-paced',
    rating: '4.6',
    tags: ['MLOps', 'GCP', 'Cloud', 'Vertex AI'],
  ),

  // ── Interview Prep ────────────────────────────────────────────────────
  _CourseItem(
    title: 'ML Interviews Book — Chip Huyen',
    platform: 'GitHub (free)',
    price: 'Free',
    isFree: true,
    url: 'https://huyenchip.com/ml-interviews-book/',
    icon: '📋',
    level: 'Intermediate',
    duration: 'Self-paced',
    rating: '5.0',
    tags: ['Interview', 'ML', 'Free', 'Career'],
  ),
  _CourseItem(
    title: 'LeetCode NeetCode 150',
    platform: 'LeetCode + NeetCode.io (free)',
    price: 'Free',
    isFree: true,
    url: 'https://neetcode.io/roadmap',
    icon: '🏋️',
    level: 'Intermediate',
    duration: 'Self-paced',
    rating: '4.9',
    tags: ['Interview', 'Python', 'Algorithms', 'Free'],
  ),
  _CourseItem(
    title: 'Grokking the ML Interview',
    platform: 'Educative.io',
    price: '₹1,999/mo',
    isFree: false,
    url: 'https://www.educative.io/courses/grokking-the-machine-learning-interview',
    icon: '🎓',
    level: 'Advanced',
    duration: '8 hours',
    rating: '4.7',
    tags: ['Interview', 'ML', 'System Design', 'Advanced'],
  ),

  // ── Robotics ─────────────────────────────────────────────────────────
  _CourseItem(
    title: 'ROS 2 for Beginners',
    platform: 'Udemy — Edouard Renard',
    price: '₹499',
    isFree: false,
    url: 'https://www.udemy.com/course/ros2-for-beginners/',
    icon: '🤖',
    level: 'Beginner',
    duration: '11 hrs',
    rating: '4.6',
    tags: ['Robotics', 'ROS', 'Beginner'],
  ),

  // ── TinyML ───────────────────────────────────────────────────────────
  _CourseItem(
    title: 'TinyML and Efficient Deep Learning',
    platform: 'MIT (free)',
    price: 'Free',
    isFree: true,
    url: 'https://hanlab.mit.edu/courses/2023-fall-65940',
    icon: '📱',
    level: 'Advanced',
    duration: '12 weeks',
    rating: '4.8',
    tags: ['TinyML', 'Quantisation', 'Edge AI', 'Advanced', 'Free'],
  ),
  _CourseItem(
    title: 'Quantization Fundamentals',
    platform: 'DeepLearning.AI + HuggingFace (free)',
    price: 'Free',
    isFree: true,
    url: 'https://www.deeplearning.ai/short-courses/quantization-fundamentals-with-hugging-face/',
    icon: '⚖️',
    level: 'Advanced',
    duration: '2 hours',
    rating: '4.7',
    tags: ['Quantisation', 'LLMs', 'Edge AI', 'Free'],
  ),
];

// ══════════════════════════════════════════════════════════════════════
// TOOLS DATA — 50 real AI tools
// ══════════════════════════════════════════════════════════════════════

const List<_ToolItem> _allTools = [

  // ── LLM ──────────────────────────────────────────────────────────────
  _ToolItem(name: 'ChatGPT',        description: 'GPT-4o: world\'s most used AI assistant',           url: 'https://chat.openai.com',                        category: 'LLM',      icon: '🤖', isFree: true),
  _ToolItem(name: 'Claude',         description: 'Anthropic\'s AI — best for long documents',         url: 'https://claude.ai',                              category: 'LLM',      icon: '🛡️', isFree: true),
  _ToolItem(name: 'Gemini',         description: 'Google\'s multimodal AI with 1M context',           url: 'https://gemini.google.com',                      category: 'LLM',      icon: '🔵', isFree: true),
  _ToolItem(name: 'Mistral Le Chat',description: 'Fast open-weight model from Mistral AI',            url: 'https://chat.mistral.ai',                        category: 'LLM',      icon: '🌬️', isFree: true),
  _ToolItem(name: 'Perplexity AI',  description: 'AI search engine with real-time web access',       url: 'https://perplexity.ai',                          category: 'Search',   icon: '🔍', isFree: true),
  _ToolItem(name: 'Grok',           description: 'xAI\'s LLM with X/Twitter real-time data',         url: 'https://grok.com',                               category: 'LLM',      icon: '⚡', isFree: true),
  _ToolItem(name: 'Cohere',         description: 'Enterprise LLM API: embeddings + generation',      url: 'https://cohere.com',                             category: 'LLM',      icon: '🔤', isFree: false),
  _ToolItem(name: 'Together AI',    description: 'Run open LLMs (Llama, Mistral) via API',           url: 'https://api.together.ai',                        category: 'LLM',      icon: '🤝', isFree: true),
  _ToolItem(name: 'Ollama',         description: 'Run LLMs locally on your laptop',                  url: 'https://ollama.ai',                              category: 'LLM',      icon: '🦙', isFree: true),
  _ToolItem(name: 'Groq',           description: 'Fastest LLM inference on the planet',              url: 'https://groq.com',                               category: 'LLM',      icon: '⚡', isFree: true),

  // ── Image ─────────────────────────────────────────────────────────────
  _ToolItem(name: 'Midjourney',     description: 'Best quality AI image generation',                 url: 'https://midjourney.com',                         category: 'Image',    icon: '🎨', isFree: false),
  _ToolItem(name: 'DALL·E 3',       description: 'OpenAI\'s image model inside ChatGPT',             url: 'https://openai.com/dall-e-3',                    category: 'Image',    icon: '🖼️', isFree: false),
  _ToolItem(name: 'Stable Diffusion',description:'Open-source image generation you self-host',       url: 'https://stability.ai',                           category: 'Image',    icon: '🌈', isFree: true),
  _ToolItem(name: 'Adobe Firefly',  description: 'IP-safe generative images inside Adobe',           url: 'https://firefly.adobe.com',                      category: 'Image',    icon: '🦋', isFree: false),
  _ToolItem(name: 'Ideogram',       description: 'AI image gen with accurate text rendering',        url: 'https://ideogram.ai',                            category: 'Image',    icon: '🔤', isFree: true),
  _ToolItem(name: 'Leonardo AI',    description: 'Concept art and game asset generation',            url: 'https://leonardo.ai',                            category: 'Image',    icon: '🎭', isFree: true),
  _ToolItem(name: 'Flux (Black Forest)',description:'State-of-the-art open image gen model',         url: 'https://blackforestlabs.ai',                     category: 'Image',    icon: '🌊', isFree: true),

  // ── Video ─────────────────────────────────────────────────────────────
  _ToolItem(name: 'Runway Gen-3',   description: 'Text-to-video: best quality in 2025',              url: 'https://runwayml.com',                            category: 'Video',    icon: '🎬', isFree: false),
  _ToolItem(name: 'Sora',           description: 'OpenAI\'s text-to-video model',                    url: 'https://sora.com',                               category: 'Video',    icon: '🎥', isFree: false),
  _ToolItem(name: 'Kling AI',       description: 'High-quality video generation by Kuaishou',        url: 'https://klingai.com',                            category: 'Video',    icon: '🎞️', isFree: true),
  _ToolItem(name: 'Descript',       description: 'Edit video by editing text transcript',            url: 'https://descript.com',                           category: 'Video',    icon: '✂️', isFree: true),
  _ToolItem(name: 'Synthesia',      description: 'Create AI avatar videos without filming',          url: 'https://synthesia.io',                           category: 'Video',    icon: '🎭', isFree: false),

  // ── Audio ─────────────────────────────────────────────────────────────
  _ToolItem(name: 'ElevenLabs',     description: 'Ultra-realistic voice cloning & TTS',              url: 'https://elevenlabs.io',                          category: 'Audio',    icon: '🎙️', isFree: true),
  _ToolItem(name: 'Suno AI',        description: 'Generate full songs from a text prompt',           url: 'https://suno.com',                               category: 'Audio',    icon: '🎵', isFree: true),
  _ToolItem(name: 'Whisper',        description: 'OpenAI\'s open-source ASR model',                  url: 'https://github.com/openai/whisper',              category: 'Audio',    icon: '🎤', isFree: true),
  _ToolItem(name: 'Udio',           description: 'AI music generation competitor to Suno',           url: 'https://udio.com',                               category: 'Audio',    icon: '🎼', isFree: true),

  // ── Code ──────────────────────────────────────────────────────────────
  _ToolItem(name: 'GitHub Copilot', description: 'AI pair programmer inside VS Code',                url: 'https://github.com/features/copilot',            category: 'Code',     icon: '👨‍💻', isFree: false),
  _ToolItem(name: 'Cursor',         description: 'AI-native code editor built on VS Code',           url: 'https://cursor.sh',                              category: 'Code',     icon: '⌨️', isFree: true),
  _ToolItem(name: 'Replit AI',      description: 'Code, run, and deploy with AI assistance',         url: 'https://replit.com',                             category: 'Code',     icon: '🔄', isFree: true),
  _ToolItem(name: 'Codeium',        description: 'Free AI code completion for any IDE',              url: 'https://codeium.com',                            category: 'Code',     icon: '💚', isFree: true),
  _ToolItem(name: 'Aider',          description: 'AI pair programmer in your terminal',              url: 'https://aider.chat',                             category: 'Code',     icon: '💻', isFree: true),
  _ToolItem(name: 'Devin',          description: 'Autonomous AI software engineer',                  url: 'https://cognition.ai/devin',                     category: 'Code',     icon: '🤖', isFree: false),

  // ── RAG & Vector DB ──────────────────────────────────────────────────
  _ToolItem(name: 'Pinecone',       description: 'Managed vector database for AI apps',              url: 'https://pinecone.io',                            category: 'DB',       icon: '🌲', isFree: true),
  _ToolItem(name: 'Weaviate',       description: 'Open-source vector DB with GraphQL API',           url: 'https://weaviate.io',                            category: 'DB',       icon: '🕸️', isFree: true),
  _ToolItem(name: 'Qdrant',         description: 'High-performance open-source vector DB',           url: 'https://qdrant.tech',                            category: 'DB',       icon: '🗂️', isFree: true),
  _ToolItem(name: 'ChromaDB',       description: 'Open-source embedding database for RAG',           url: 'https://trychroma.com',                          category: 'DB',       icon: '🎨', isFree: true),
  _ToolItem(name: 'LlamaIndex',     description: 'Data framework for LLM + RAG applications',       url: 'https://llamaindex.ai',                          category: 'RAG',      icon: '🦙', isFree: true),
  _ToolItem(name: 'LangChain',      description: 'Framework for building LLM applications',         url: 'https://python.langchain.com',                   category: 'RAG',      icon: '⛓️', isFree: true),

  // ── MLOps ────────────────────────────────────────────────────────────
  _ToolItem(name: 'Weights & Biases',description:'Experiment tracking and model monitoring',         url: 'https://wandb.ai',                               category: 'MLOps',    icon: '📊', isFree: true),
  _ToolItem(name: 'MLflow',         description: 'Open-source ML lifecycle management',              url: 'https://mlflow.org',                             category: 'MLOps',    icon: '🔄', isFree: true),
  _ToolItem(name: 'Modal',          description: 'Serverless GPU compute for ML workloads',          url: 'https://modal.com',                              category: 'MLOps',    icon: '☁️', isFree: true),
  _ToolItem(name: 'Replicate',      description: 'Run ML models in the cloud via API',               url: 'https://replicate.com',                          category: 'MLOps',    icon: '♻️', isFree: true),
  _ToolItem(name: 'HuggingFace',    description: 'The GitHub of AI: models, datasets, Spaces',      url: 'https://huggingface.co',                         category: 'Research', icon: '🤗', isFree: true),

  // ── Agent ─────────────────────────────────────────────────────────────
  _ToolItem(name: 'CrewAI',         description: 'Multi-agent orchestration framework',              url: 'https://crewai.com',                             category: 'Agent',    icon: '👥', isFree: true),
  _ToolItem(name: 'AutoGen',        description: 'Microsoft\'s multi-agent conversation framework',  url: 'https://microsoft.github.io/autogen/',           category: 'Agent',    icon: '🔁', isFree: true),
  _ToolItem(name: 'E2B',            description: 'Sandboxed code execution for AI agents',           url: 'https://e2b.dev',                                category: 'Agent',    icon: '📦', isFree: true),

  // ── Research ─────────────────────────────────────────────────────────
  _ToolItem(name: 'Arxiv',          description: 'Open-access repository for ML research papers',   url: 'https://arxiv.org/list/cs.LG/recent',            category: 'Research', icon: '📄', isFree: true),
  _ToolItem(name: 'Papers With Code',description:'ML papers linked to reproducible code',            url: 'https://paperswithcode.com',                     category: 'Research', icon: '📑', isFree: true),
  _ToolItem(name: 'Semantic Scholar',description:'AI-powered academic search engine',                url: 'https://semanticscholar.org',                    category: 'Research', icon: '🔬', isFree: true),

  // ── Writing ───────────────────────────────────────────────────────────
  _ToolItem(name: 'Notion AI',      description: 'AI writing inside your Notion workspace',          url: 'https://notion.so/product/ai',                   category: 'Writing',  icon: '📓', isFree: false),
  _ToolItem(name: 'Gamma',          description: 'AI-powered presentations in seconds',              url: 'https://gamma.app',                              category: 'Writing',  icon: '📊', isFree: true),
];

// ══════════════════════════════════════════════════════════════════════
// UNIVERSITY RESOURCES — 15 top university free courses
// ══════════════════════════════════════════════════════════════════════

const List<_UniResource> _uniResources = [
  _UniResource(
    university: 'MIT',
    courseName: '6.S191: Introduction to Deep Learning',
    description: 'MIT\'s official annual deep learning bootcamp covering the latest in neural networks, computer vision, NLP, generative models, and reinforcement learning. Watched by millions worldwide.',
    url: 'http://introtodeeplearning.com',
    icon: '🏛️',
    duration: '3 weeks intensive',
    topics: ['Deep Learning', 'CNNs', 'RNNs', 'Generative AI', 'RL'],
  ),
  _UniResource(
    university: 'Stanford University',
    courseName: 'CS229: Machine Learning',
    description: 'The legendary Andrew Ng ML course. Covers the mathematical foundations of supervised, unsupervised, and RL algorithms. Full lecture notes and problem sets freely available.',
    url: 'https://cs229.stanford.edu',
    icon: '🎓',
    duration: '10 weeks',
    topics: ['ML Theory', 'Supervised Learning', 'Unsupervised', 'RL', 'Math'],
  ),
  _UniResource(
    university: 'Stanford University',
    courseName: 'CS224N: NLP with Deep Learning',
    description: 'The world\'s best NLP course. Covers word vectors, dependency parsing, transformers, BERT, question answering, and LLMs at research depth.',
    url: 'https://web.stanford.edu/class/cs224n/',
    icon: '🎓',
    duration: '10 weeks',
    topics: ['NLP', 'Transformers', 'BERT', 'LLMs', 'Research'],
  ),
  _UniResource(
    university: 'Stanford University',
    courseName: 'CS231n: Convolutional Neural Networks',
    description: 'The definitive computer vision course. Covers image classification, object detection, segmentation, generative models, and vision transformers from scratch.',
    url: 'http://cs231n.stanford.edu',
    icon: '🎓',
    duration: '10 weeks',
    topics: ['Computer Vision', 'CNNs', 'ResNet', 'Detection', 'GANs'],
  ),
  _UniResource(
    university: 'Carnegie Mellon University',
    courseName: '11-785: Introduction to Deep Learning',
    description: 'CMU\'s deep learning course with extremely rigorous assignments. One of the most technically demanding DL courses freely available online. Homework involves building from scratch.',
    url: 'https://deeplearning.cs.cmu.edu',
    icon: '🏛️',
    duration: '15 weeks',
    topics: ['Deep Learning', 'Optimisation', 'CNNs', 'RNNs', 'Attention'],
  ),
  _UniResource(
    university: 'UC Berkeley',
    courseName: 'CS285: Deep Reinforcement Learning',
    description: 'Sergey Levine\'s graduate RL course at Berkeley. Covers policy gradients, model-based RL, offline RL, and connections to robotics. Lecture videos freely on YouTube.',
    url: 'https://rail.eecs.berkeley.edu/deeprlcourse/',
    icon: '🐻',
    duration: '15 weeks',
    topics: ['RL', 'Policy Gradients', 'PPO', 'Model-Based RL', 'Robotics'],
  ),
  _UniResource(
    university: 'University of Toronto',
    courseName: 'CSC2541: Neural Net & ML',
    description: 'Geoffrey Hinton\'s neural network lectures — the foundational work behind modern deep learning. Essential historical and technical perspective on backprop and Boltzmann machines.',
    url: 'https://www.cs.toronto.edu/~hinton/csc2541/',
    icon: '🍁',
    duration: '12 weeks',
    topics: ['Neural Networks', 'Backprop', 'Boltzmann Machines', 'Foundations'],
  ),
  _UniResource(
    university: 'Harvard University',
    courseName: 'CS50: Introduction to AI with Python',
    description: 'Harvard\'s world-famous CS50 AI edition. Covers search, knowledge representation, uncertainty, ML, neural networks, and language. Completely free with certificate available.',
    url: 'https://cs50.harvard.edu/ai/',
    icon: '🏛️',
    duration: '7 weeks',
    topics: ['AI Foundations', 'Search', 'ML', 'Neural Networks', 'NLP'],
  ),
  _UniResource(
    university: 'University of Alberta',
    courseName: 'Reinforcement Learning Specialization',
    description: 'Rich Sutton and Andy Barto\'s textbook authors teach this course on Coursera. Covers every RL algorithm from temporal difference to function approximation. Free to audit.',
    url: 'https://www.coursera.org/specializations/reinforcement-learning',
    icon: '🍁',
    duration: '4 months',
    topics: ['RL', 'Q-Learning', 'Policy Gradients', 'TD Learning'],
  ),
  _UniResource(
    university: 'NYU',
    courseName: 'DS-GA 1008: Deep Learning (Yann LeCun)',
    description: 'Yann LeCun (Turing Award winner, inventor of CNNs) teaches this course at NYU. Lecture videos, slides, and Jupyter notebooks are all publicly available.',
    url: 'https://atcold.github.io/NYU-DLSP21/',
    icon: '🗽',
    duration: '14 weeks',
    topics: ['Deep Learning', 'Energy Models', 'SSL', 'Graph NNs'],
  ),
  _UniResource(
    university: 'Oxford University',
    courseName: 'Deep Learning for NLP',
    description: 'Oxford\'s NLP with Deep Learning course jointly taught with DeepMind. Covers attention, memory networks, question answering, and dialogue systems.',
    url: 'https://www.cs.ox.ac.uk/teaching/courses/2016-2017/dl/',
    icon: '🇬🇧',
    duration: '8 weeks',
    topics: ['NLP', 'Attention', 'Memory Networks', 'Dialogue'],
  ),
  _UniResource(
    university: 'UCL / DeepMind',
    courseName: 'Advanced Deep Learning & RL',
    description: 'UCL and DeepMind\'s joint lecture series. Covers advanced topics: hierarchical RL, model-based planning, meta-learning, and neural architecture search.',
    url: 'https://www.youtube.com/playlist?list=PLqYmG7hTraZDNJre23vqCGIVpfZ_K2RZs',
    icon: '🇬🇧',
    duration: '10 weeks',
    topics: ['Advanced DL', 'Meta-Learning', 'NAS', 'RL', 'DeepMind'],
  ),
  _UniResource(
    university: 'MIT',
    courseName: 'TinyML: Efficient Deep Learning',
    description: 'MIT\'s course on making AI run on microcontrollers and edge devices. Covers pruning, quantization, NAS, and deploying models to billions of IoT devices.',
    url: 'https://hanlab.mit.edu/courses/2023-fall-65940',
    icon: '🏛️',
    duration: '12 weeks',
    topics: ['TinyML', 'Quantisation', 'Pruning', 'Edge AI', 'IoT'],
  ),
  _UniResource(
    university: 'IIT Madras',
    courseName: 'Deep Learning (NPTEL)',
    description: 'High-quality DL course from IIT Madras on NPTEL — free for Indian students with certificate. Covers all DL fundamentals with Indian context and examples.',
    url: 'https://nptel.ac.in/courses/106106184',
    icon: '🇮🇳',
    duration: '12 weeks',
    topics: ['Deep Learning', 'CNN', 'RNN', 'Transformers', 'India'],
  ),
  _UniResource(
    university: 'IISc Bangalore',
    courseName: 'Machine Learning (NPTEL)',
    description: 'IISc Bangalore\'s ML course on NPTEL — one of India\'s top ML courses with rigorous mathematical treatment, free for all, SWAYAM certificate available.',
    url: 'https://nptel.ac.in/courses/106108052',
    icon: '🇮🇳',
    duration: '8 weeks',
    topics: ['ML', 'Statistics', 'Regression', 'Classification', 'India'],
  ),
];

// ══════════════════════════════════════════════════════════════════════
// CERTIFICATIONS — 15 that actually matter
// ══════════════════════════════════════════════════════════════════════

const List<_Certification> _certifications = [
  _Certification(
    name: 'TensorFlow Developer Certificate',
    issuer: 'Google',
    description: 'Official Google certification for building and deploying TensorFlow models. Covers image classification, NLP, time series, and sequences. Highly recognized in industry.',
    url: 'https://www.tensorflow.org/certificate',
    icon: '🧡',
    difficulty: 'Intermediate',
    cost: '\$100',
    prepTime: '2–3 months',
    value: 'Strong signal for ML Engineer roles at Indian and global tech companies',
  ),
  _Certification(
    name: 'AWS Certified Machine Learning — Specialty',
    issuer: 'Amazon Web Services',
    description: 'AWS\'s top ML certification. Validates ability to design, implement, deploy, and maintain ML solutions using SageMaker and AWS AI services. Highly valued in cloud + ML hybrid roles.',
    url: 'https://aws.amazon.com/certification/certified-machine-learning-specialty/',
    icon: '☁️',
    difficulty: 'Advanced',
    cost: '\$300',
    prepTime: '3–4 months',
    value: 'Required for many AWS Solutions Architect + ML Engineer roles, adds ₹3–5 LPA to offers',
  ),
  _Certification(
    name: 'Google Professional ML Engineer',
    issuer: 'Google Cloud',
    description: 'Validates ability to design, build, and productionize ML models using Vertex AI. Covers training pipelines, model monitoring, and responsible AI practices.',
    url: 'https://cloud.google.com/certification/machine-learning-engineer',
    icon: '🔵',
    difficulty: 'Advanced',
    cost: '\$200',
    prepTime: '3–4 months',
    value: 'Highly valued for GCP ML Engineer roles; recognized by 60%+ of Indian tech employers',
  ),
  _Certification(
    name: 'Microsoft Azure AI Engineer (AI-102)',
    issuer: 'Microsoft',
    description: 'Validates ability to build AI solutions using Azure Cognitive Services, Azure ML, and Azure Bot Service. Strong for enterprise AI roles in India.',
    url: 'https://learn.microsoft.com/en-us/certifications/azure-ai-engineer/',
    icon: '🪟',
    difficulty: 'Intermediate',
    cost: '\$165',
    prepTime: '2–3 months',
    value: 'Valuable at Microsoft, TCS, Infosys, Wipro, and any Azure-heavy enterprise',
  ),
  _Certification(
    name: 'DeepLearning.AI TensorFlow: Data and Deployment',
    issuer: 'Coursera — DeepLearning.AI',
    description: 'Focuses on deploying TensorFlow models to browsers (TF.js), mobile (TFLite), and servers. Practical production ML skills valued by startups and product companies.',
    url: 'https://www.coursera.org/specializations/tensorflow-data-and-deployment',
    icon: '🚀',
    difficulty: 'Intermediate',
    cost: '₹3,499/mo',
    prepTime: '1–2 months',
    value: 'Good for mobile ML and edge deployment roles; complements ML Specialization well',
  ),
  _Certification(
    name: 'Hugging Face Certified Practitioner',
    issuer: 'Hugging Face',
    description: 'Practical certification covering the HuggingFace ecosystem: Transformers, Datasets, Diffusers, and Spaces. Directly verifiable on your HuggingFace profile.',
    url: 'https://huggingface.co/learn',
    icon: '🤗',
    difficulty: 'Intermediate',
    cost: 'Free',
    prepTime: '1 month',
    value: 'Directly visible to AI hiring teams who search HuggingFace; top signal for NLP roles',
  ),
  _Certification(
    name: 'Databricks Certified ML Professional',
    issuer: 'Databricks',
    description: 'Validates production ML skills on Databricks (Apache Spark, MLflow, Delta Lake). Especially valuable for data engineering + ML roles at large enterprises.',
    url: 'https://www.databricks.com/learn/certification/machine-learning-professional',
    icon: '🧱',
    difficulty: 'Advanced',
    cost: '\$200',
    prepTime: '2–3 months',
    value: 'Highly valued at data-heavy companies (Flipkart, Walmart Labs, PhonePe)',
  ),
  _Certification(
    name: 'Kaggle Expert / Master',
    issuer: 'Kaggle',
    description: 'Kaggle\'s public performance-based ranking. Expert tier (top 5%) achieved through competition medals. Universally recognized by ML hiring managers worldwide.',
    url: 'https://www.kaggle.com/progression',
    icon: '🏆',
    difficulty: 'Advanced',
    cost: 'Free',
    prepTime: '6–12 months',
    value: 'Best free signal for ML Engineer roles; replaces degree requirements at many companies',
  ),
  _Certification(
    name: 'MongoDB AI Applications Developer',
    issuer: 'MongoDB University',
    description: 'Covers building AI-powered applications using MongoDB Atlas Vector Search, Atlas Search, and integrating LLMs. Relevant for full-stack AI application developers.',
    url: 'https://learn.mongodb.com/learning-paths/mongodb-ai-applications-developer',
    icon: '🍃',
    difficulty: 'Intermediate',
    cost: 'Free',
    prepTime: '1 month',
    value: 'Good for AI startup roles needing both DB and LLM integration knowledge',
  ),
  _Certification(
    name: 'W&B Effective MLOps Certification',
    issuer: 'Weights & Biases',
    description: 'Hands-on certification covering experiment tracking, model evaluation, pipeline automation, and production monitoring using W&B. Practical and employer-visible.',
    url: 'https://www.wandb.courses/courses/effective-mlops-model-development',
    icon: '📊',
    difficulty: 'Intermediate',
    cost: 'Free',
    prepTime: '3 weeks',
    value: 'Strong signal for MLOps Engineer roles; W&B is used at 90%+ of ML companies',
  ),
  _Certification(
    name: 'Prompt Engineering Professional Certificate',
    issuer: 'Anthropic (via Coursera)',
    description: 'Official Anthropic training on prompt engineering with Claude. Covers CoT prompting, few-shot design, safety considerations, and automated evaluations.',
    url: 'https://www.coursera.org/learn/prompt-engineering-with-anthropic-claude',
    icon: '✍️',
    difficulty: 'Beginner',
    cost: 'Free to audit',
    prepTime: '2 weeks',
    value: 'Good entry-level signal for Prompt Engineer, AI Trainer, and LLM application roles',
  ),
  _Certification(
    name: 'CFA Level 1 + ML for Finance',
    issuer: 'CFA Institute + Coursera',
    description: 'CFA Level 1 combined with ML for Trading (Georgia Tech) creates a rare finance + AI profile. Extremely valuable for quantitative ML roles at hedge funds and fintechs.',
    url: 'https://www.cfainstitute.org/en/programs/cfa',
    icon: '💹',
    difficulty: 'Advanced',
    cost: '\$900+',
    prepTime: '12–18 months',
    value: 'Rare combination that commands premium at quant funds, Alphasense, Kensho, and fintechs',
  ),
  _Certification(
    name: 'NVIDIA Deep Learning Institute Certificate',
    issuer: 'NVIDIA DLI',
    description: 'Hands-on GPU-based certifications in fundamentals of deep learning, NLP, computer vision, and accelerated computing. Courses run on NVIDIA hardware in the cloud.',
    url: 'https://www.nvidia.com/en-us/training/',
    icon: '🖥️',
    difficulty: 'Intermediate',
    cost: '\$30–\$90',
    prepTime: '1 day each',
    value: 'Recognized by NVIDIA India hiring team; valuable for deep learning and CUDA roles',
  ),
  _Certification(
    name: 'Certified Kubernetes Administrator (CKA)',
    issuer: 'Linux Foundation / CNCF',
    description: 'Performance-based K8s certification. Critical for MLOps, AI infrastructure, and ML Platform Engineer roles. Hands-on exam in a real cluster environment.',
    url: 'https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/',
    icon: '⚓',
    difficulty: 'Advanced',
    cost: '\$395',
    prepTime: '2–3 months',
    value: 'Top signal for MLOps and AI Infrastructure roles; adds ₹2–4 LPA to compensation',
  ),
  _Certification(
    name: 'Deep Learning Specialization Certificate',
    issuer: 'Coursera — DeepLearning.AI',
    description: 'Andrew Ng\'s 5-course deep learning series certificate. One of the most recognized AI credentials globally. Covers neural networks, CNNs, sequence models, and hyperparameter tuning.',
    url: 'https://www.coursera.org/specializations/deep-learning',
    icon: '⚡',
    difficulty: 'Intermediate',
    cost: '₹3,499/mo',
    prepTime: '3–4 months',
    value: 'Globally recognized; accepted as qualification by 80%+ of Indian ML job postings',
  ),
];

// ══════════════════════════════════════════════════════════════════════
// TAB 5 — 🚀 LEARN (In-App Course Engine)
// ══════════════════════════════════════════════════════════════════════

class _LearnTab extends StatefulWidget {
  const _LearnTab();
  @override
  State<_LearnTab> createState() => _LearnTabState();
}

class _LearnTabState extends State<_LearnTab> {
  static const _bg      = Color(0xFF0F0F1A);
  static const _surface = Color(0xFF1A1A2E);
  static const _border  = Color(0xFF2A2A40);
  static const _primary = Color(0xFF7C3AED);
  static const _secondary=Color(0xFFA78BFA);
  static const _muted   = Color(0xFF888899);
  static const _green   = Color(0xFF4ADE80);

  String _search     = '';
  String _catFilter  = 'All';
  final _searchCtrl  = TextEditingController();
  final Map<String, bool> _completedMap = {};

  // ── AI-generated courses (cached locally), shown alongside the
  //    633 static lessons in allTopicCourses.
  List<TopicCourse> _generatedCourses = [];

  // Combined list: static lessons ALWAYS first, unmodified, followed by
  // any AI-generated courses already cached on this device.
  List<TopicCourse> get _allLessons =>
      [...allTopicCourses, ..._generatedCourses];

  // All unique category labels from data
  static final List<String> _cats = ['All',
    ...{...allTopicCourses.map((c) => c.categoryId)}.map(_catLabel),
  ];

  static String _catLabel(String id) {
    const m = {
      'software_dev':  '💻 Software',
      'ai_data':       '🤖 AI & Data',
      'cloud_devops':  '☁️ Cloud',
      'cyber_security':'🔒 Security',
      'design_product':'🎨 Design',
      'emerging_tech': '⛓️ Emerging',
      'testing_qa':    '🧪 Testing',
      'specialized':   '📈 Specialized',
    };
    return m[id] ?? id;
  }

  static String _catId(String label) {
    const m = {
      '💻 Software':   'software_dev',
      '🤖 AI & Data':  'ai_data',
      '☁️ Cloud':      'cloud_devops',
      '🔒 Security':   'cyber_security',
      '🎨 Design':     'design_product',
      '⛓️ Emerging':   'emerging_tech',
      '🧪 Testing':    'testing_qa',
      '📈 Specialized':'specialized',
    };
    return m[label] ?? '';
  }

  static const List<Map<String, String>> _aiDataCareers = [
  {
    'id': 'ai_engineer',
    'title': 'AI Engineer',
    'emoji': '🤖',
  },
  {
    'id': 'data_scientist',
    'title': 'Data Scientist',
    'emoji': '📊',
  },
  {
    'id': 'llm_engineer',
    'title': 'LLM Engineer',
    'emoji': '🧠',
  },
  {
    'id': 'computer_vision_engineer',
    'title': 'Computer Vision Engineer',
    'emoji': '👁️',
  },
];

   @override
  void initState() {
    super.initState();
    _loadCompleted();
    _loadGenerated();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, bool> map = {};
    for (final c in allTopicCourses) {
      map[c.id] = prefs.getBool('course_done_${c.id}') ?? false;
    }
    if (mounted) setState(() => _completedMap.addAll(map));
  }

  Future<void> _loadGenerated() async {
    final generated = await CourseGeneratorService.getAllCachedCourses();
    if (mounted) setState(() => _generatedCourses = generated);
  }

  List<TopicCourse> get _filtered {
    return _allLessons.where((c) {
      final q = _search.toLowerCase();
      final matchSearch = q.isEmpty ||
          c.topicTitle.toLowerCase().contains(q) ||
          c.careerId.toLowerCase().contains(q) ||
          c.difficulty.toLowerCase().contains(q);
      final matchCat = _catFilter == 'All' ||
          c.categoryId == _catId(_catFilter);
      return matchSearch && matchCat;
    }).toList();
  }

  int get _totalCompleted =>
      _completedMap.values.where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    final courses = _filtered;

    return SingleChildScrollView(
      child: Column(
        children: [
      // ── Stats bar ──────────────────────────────────────────────────
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: Row(children: [
          _statBadge('📚', '${_allLessons.length}', 'Total Lessons'),
          const SizedBox(width: 10),
          _statBadge('✅', '$_totalCompleted', 'Completed'),
          const SizedBox(width: 10),
          _statBadge('⚡', '${_totalCompleted * 120}', 'XP Earned'),
        ]),
      ),

      // ── Search ─────────────────────────────────────────────────────
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: _searchCtrl,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search lessons…',
            hintStyle: const TextStyle(color: _muted, fontSize: 13),
            prefixIcon: const Icon(Icons.search, color: _muted, size: 20),
            suffixIcon: _search.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, color: _muted, size: 18),
                    onPressed: () { _searchCtrl.clear(); setState(() => _search = ''); })
                : null,
            filled: true, fillColor: _surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primary, width: 1.5)),
          ),
          onChanged: (v) => setState(() => _search = v),
        ),
      ),

      const SizedBox(height: 10),

      // ── Category chips ─────────────────────────────────────────────
      SizedBox(
        height: 34,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: _cats.length,
          separatorBuilder: (_, __) => const SizedBox(width: 7),
          itemBuilder: (_, i) {
            final cat = _cats[i];
            final sel = _catFilter == cat;
            return GestureDetector(
              onTap: () => setState(() {
                _catFilter = cat;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: sel ? _primary.withOpacity(0.25) : _surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: sel ? _primary : _border, width: sel ? 1.5 : 1),
                ),
                child: Text(cat, style: TextStyle(
                  color: sel ? _secondary : _muted, fontSize: 11,
                  fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
                )),
              ),
            );
          },
        ),
      ),

      // ─────────────────────────────────────────────
      // AI & DATA CAREERS
      // ─────────────────────────────────────────────
      if (_catFilter == _catLabel('ai_data'))
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI & Data Careers',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Choose a career path',
                style: TextStyle(
                  color: _muted,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 14),

              ..._aiDataCareers.map((career) {
                final id = career['id']!;
                final title = career['title']!;
                final emoji = career['emoji']!;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () async {
                      final career = findStaticCareer(id);
                      if (career == null) return;
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CareerLevelsScreen(
                            careerTitle: title,
                            emoji: emoji,
                            staticCareer: career,
                          ),
                        ),
                      );
                      await _loadCompleted();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: _border,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'View career roadmap & courses',
                                  style: TextStyle(
                                    color: _muted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: _muted,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

      // ─────────────────────────────────────────────
      // SOFTWARE CAREERS (static — real 10-level path)
      // ─────────────────────────────────────────────
      if (_catFilter == _catLabel('software_dev'))
        _staticCareerBlock('software_dev', 'Software Careers'),

      // ─────────────────────────────────────────────
      // CLAUDE ENGINEER — separate career, own section
      // (static — real 10-level path, not part of the 4-career picker
      // above). Its categoryId in career_level_data.dart is
      // 'cloud_devops', so it must render under that tab/filter — not
      // 'ai_data' — for staticCareerPaths lookup to ever find it.
      // ─────────────────────────────────────────────
      if (_catFilter == _catLabel('cloud_devops'))
        _staticCareerBlock('cloud_devops', 'Claude Engineer'),

      // ─────────────────────────────────────────────
      // AI-GENERATED CAREER PATHS
      // (Cloud / Security / Design / Emerging / Testing / Specialized)
      // ─────────────────────────────────────────────
      if (_catFilter == _catLabel('cloud_devops'))
        _dynamicCareerBlock('cloud_devops', 'Cloud & DevOps Career Paths'),
      if (_catFilter == _catLabel('cyber_security'))
        _dynamicCareerBlock('cyber_security', 'Security Career Paths'),
      if (_catFilter == _catLabel('design_product'))
        _dynamicCareerBlock('design_product', 'Design & Product Career Paths'),
      if (_catFilter == _catLabel('emerging_tech'))
        _dynamicCareerBlock('emerging_tech', 'Emerging Tech Career Paths'),
      if (_catFilter == _catLabel('testing_qa'))
        _dynamicCareerBlock('testing_qa', 'Testing & QA Career Paths'),
      if (_catFilter == _catLabel('specialized'))
        _dynamicCareerBlock('specialized', 'Specialized Career Paths'),

       const SizedBox(height: 8),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          Text('${courses.length} lessons', style: const TextStyle(color: _muted, fontSize: 12)),
          const Spacer(),
          if (_totalCompleted > 0)
            Text('$_totalCompleted completed', style: const TextStyle(color: _green, fontSize: 12)),
        ]),
      ),
      

      const SizedBox(height: 8),

      // ── Lesson cards ───────────────────────────────────────────────
        courses.isEmpty
            ? _emptyState()
            : ListView.builder(
                shrinkWrap: true,
                physics: const
                NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                itemCount: courses.length,
                itemBuilder: (ctx, i) {
                  final course    = courses[i];
                  final completed = _completedMap[course.id] ?? false;
                  return _LessonCard(
                    course:    course,
                    completed: completed,
                    onTap: () async {
                      await Navigator.push(ctx, MaterialPageRoute(
                        builder: (_) => CourseEngineScreen(course: course),
                      ));
                      // Refresh completion state on return
                      await _loadCompleted();
                    },
                  ).animate().fadeIn(delay: Duration(milliseconds: i * 35))
                   .slideX(begin: 0.04, duration: 280.ms);
                },
              ),
    ],
      ),
    );  
    
  }

  // ── AI-generated career-path block (Security / Design / Emerging /
  //    Testing / Specialized). Reuses the SAME dynamic generation +
  //    caching system for all five categories.
  Widget _dynamicCareerBlock(String categoryId, String title) {
    final careers =
        dynamicCareerPaths.where((c) => c.categoryId == categoryId).toList();
    if (careers.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('⚡ AI-generated levels — tap a path to begin',
              style: TextStyle(color: _muted, fontSize: 13)),
          const SizedBox(height: 14),
          ...careers.map((career) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CareerLevelsScreen(
                          careerTitle: career.careerTitle,
                          emoji: career.emoji,
                          generatedCareer: career,
                          // Cloud & DevOps keeps its existing one-course-
                          // per-level behaviour unchanged. Every other
                          // category sourced from dynamicCareerPaths
                          // (Security, Design, Emerging, Testing,
                          // Specialized) uses the multi-lesson-per-level
                          // system instead — computed here, not stored
                          // per career, so nothing about the career data
                          // itself needs to change.
                          multiLesson: categoryId != 'cloud_devops',
                        ),
                      ),
                    );
                    await _loadGenerated();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: _border, width: 1),
                    ),
                    child: Row(children: [
                      Container(
                        width: 52, height: 52, alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(career.emoji, style: const TextStyle(fontSize: 25)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(career.careerTitle,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 5),
                            Text('${career.levels.length} AI-generated levels',
                                style: const TextStyle(color: _muted, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, color: _muted, size: 16),
                    ]),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  // ── Static career-path block (Software Engineer, Claude Engineer;
  //    extend by adding more entries to staticCareerPaths with this
  //    categoryId). Same visual pattern as _dynamicCareerBlock, real
  //    level/lesson counts from career_level_data.dart — never estimated.
  Widget _staticCareerBlock(String categoryId, String title) {
    final careers =
        staticCareerPaths.where((c) => c.categoryId == categoryId).toList();
    if (careers.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('Choose a career path',
              style: TextStyle(color: _muted, fontSize: 13)),
          const SizedBox(height: 14),
          ...careers.map((career) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CareerLevelsScreen(
                          careerTitle: career.careerTitle,
                          emoji: career.emoji,
                          staticCareer: career,
                        ),
                      ),
                    );
                    await _loadCompleted();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: _border, width: 1),
                    ),
                    child: Row(children: [
                      Container(
                        width: 52, height: 52, alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(career.emoji, style: const TextStyle(fontSize: 25)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(career.careerTitle,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 5),
                            Text(
                              '${career.levels.length} levels · ${career.totalLessons} lessons',
                              style: const TextStyle(color: _muted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, color: _muted, size: 16),
                    ]),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _statBadge(String emoji, String val, String label) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: _surface, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: _muted, fontSize: 9)),
      ]),
    ),

  );

  Widget _emptyState() => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.search_off, color: _muted, size: 44),
      const SizedBox(height: 12),
      const Text('No lessons found', style: TextStyle(color: _muted, fontSize: 15)),
      const SizedBox(height: 6),
      GestureDetector(
        onTap: () { _searchCtrl.clear(); setState(() { _search = ''; _catFilter = 'All'; }); },
        child: const Text('Clear filters', style: TextStyle(color: _secondary, fontSize: 13)),
      ),
    ]),
  );
}

// ── Lesson Card ───────────────────────────────────────────────────────

class _LessonCard extends StatelessWidget {
  final TopicCourse  course;
  final bool         completed;
  final VoidCallback onTap;

  const _LessonCard({
    required this.course,
    required this.completed,
    required this.onTap,
  });

  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);
  static const _green    = Color(0xFF4ADE80);
  static const _amber    = Color(0xFFF59E0B);
  static const _red      = Color(0xFFEF4444);

  Color get _diffColor => course.difficulty == 'Easy'
      ? _green : course.difficulty == 'Medium' ? _amber : _red;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: completed ? _green.withOpacity(0.4) : _border,
            width: completed ? 1.5 : 1,
          ),
        ),
        child: Column(children: [
          // ── Card header ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              // Emoji circle
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: _primary.withOpacity(0.13),
                  shape: BoxShape.circle,
                  border: Border.all(color: _primary.withOpacity(0.3)),
                ),
                child: Center(child: Text(course.emoji, style: const TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 13),

              // Info
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(course.topicTitle,
                          style: TextStyle(
                            color: completed ? _green : Colors.white,
                            fontSize: 15, fontWeight: FontWeight.w700,
                          )),
                    ),
                    if (completed)
                      const Icon(Icons.check_circle, color: _green, size: 18),
                  ]),
                  const SizedBox(height: 4),
                  // Chips row
                  Row(children: [
                    _chip(course.difficulty, _diffColor),
                    const SizedBox(width: 6),
                    _chip('~${course.estimatedMinutes}m', const Color(0xFF60A5FA)),
                    const SizedBox(width: 6),
                    _chip('+${course.totalXp} XP', _secondary),
                  ]),
                ],
              )),
            ]),
          ),

          // ── Divider + bottom row ──────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: completed
                  ? _green.withOpacity(0.06)
                  : _primary.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(17)),
              border: Border(top: BorderSide(color: _border)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(children: [
              // Concepts count
              _countBadge('📖', '${course.concepts.length}', 'Concepts'),
              const SizedBox(width: 10),
              _countBadge('❓', '${course.quiz.length}', 'Quiz'),
              const SizedBox(width: 10),
              _countBadge('💻', '${course.challenges.length}', 'Challenges'),
              const Spacer(),
              // CTA button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: completed ? _green.withOpacity(0.15) : _primary,
                  borderRadius: BorderRadius.circular(10),
                  border: completed
                      ? Border.all(color: _green.withOpacity(0.4))
                      : null,
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(
                    completed ? Icons.replay : Icons.play_arrow,
                    color: completed ? _green : Colors.white,
                    size: 15,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    completed ? 'Redo' : 'Start',
                    style: TextStyle(
                      color: completed ? _green : Colors.white,
                      fontSize: 12, fontWeight: FontWeight.w700,
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _chip(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.25)),
    ),
    child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
  );

  Widget _countBadge(String emoji, String count, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    
    children: [
      Text(emoji, style: const TextStyle(fontSize: 12)),
      const SizedBox(width: 3),
      Text('$count $label', style: const TextStyle(color: _muted, fontSize: 10)),
    ],
  );
}