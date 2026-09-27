import 'package:flutter/material.dart';

import '../models/home_market_models.dart';
import '../services/home_market_service.dart';
import '../services/career_company_relationship_service.dart';
import 'company_intelligence_screen.dart';
import 'roadmap_screen.dart';
import 'skill_profile_screen.dart';

class CareerIntelligenceScreen extends StatelessWidget {
  static const HomeMarketService _marketService = HomeMarketService();
  static const CareerCompanyRelationshipService _relationshipService =
      CareerCompanyRelationshipService();
  final HomeCareer career;
  final String? salaryLabel;
  final String? salarySourceLabel;

  const CareerIntelligenceScreen({
    super.key,
    required this.career,
    this.salaryLabel,
    this.salarySourceLabel,
  });

  static const bg = Color(0xFF080B14);
  static const surface = Color(0xFF111625);
  static const surface2 = Color(0xFF151B2D);
  static const border = Color(0xFF273047);
  static const violet = Color(0xFF8B5CF6);
  static const violetBright = Color(0xFFA78BFA);
  static const cyan = Color(0xFF22D3EE);
  static const mint = Color(0xFF34D399);
  static const amber = Color(0xFFF59E0B);
  static const pink = Color(0xFFF472B6);
  static const muted = Color(0xFF8D96AB);
  static const text = Color(0xFFF7F8FC);

  @override
  Widget build(BuildContext context) {
    final overview = (career.overview ?? career.shortDescription).trim();
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: text),
        ),
        title: const Text(
          'Career Intelligence',
          style: TextStyle(color: text, fontSize: 17, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _hero(overview),
                  const SizedBox(height: 18),
                  _section(
                    'REAL WORK',
                    'What does this career actually involve?',
                    cyan,
                    _card(Icons.work_outline_rounded, cyan,
                        overview.isEmpty ? 'Career overview is not available yet.' : overview),
                  ),
                  if (career.workAreas.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _section('WORK ECOSYSTEM', 'Where the work happens', violetBright,
                        _chips(career.workAreas, violetBright)),
                  ],
                  if (career.commonSkills.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _section('SKILL MAP', 'Core skills', mint,
                        _skillMap(career.commonSkills)),
                  ],
                  if (career.tools.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _section('TECH STACK', 'Tools & technologies', amber,
                        _chips(career.tools, amber)),
                  ],
                  if (career.industries.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _section('GLOBAL REACH', 'Industries', pink,
                        _chips(career.industries, pink)),
                  ],
                  const SizedBox(height: 18),
                  _salary(),
                  const SizedBox(height: 18),
                  _roleFamilies(),
                  const SizedBox(height: 18),
                  _companyLayer(context),
                  const SizedBox(height: 18),
                  _yourSkills(context),
                  const SizedBox(height: 18),
                  _roadmapHandoff(context),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hero(String overview) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [violet.withOpacity(.32), surface2, cyan.withOpacity(.08)],
      ),
      border: Border.all(color: violet.withOpacity(.28)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              color: violet.withOpacity(.16),
              border: Border.all(color: violet.withOpacity(.30)),
            ),
            child: const Icon(Icons.auto_graph_rounded, color: violetBright, size: 27),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('CAREER INTELLIGENCE',
                  style: TextStyle(color: violetBright, fontSize: 10,
                      fontWeight: FontWeight.w900, letterSpacing: 1.4)),
              const SizedBox(height: 5),
              Text(career.title,
                  style: const TextStyle(color: text, fontSize: 25,
                      height: 1.05, fontWeight: FontWeight.w900)),
            ],
          )),
        ]),
        const SizedBox(height: 18),
        if (overview.isNotEmpty)
          Text(overview, maxLines: 4, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: muted, fontSize: 13, height: 1.55)),
        const SizedBox(height: 16),
        const _Pill(icon: Icons.info_outline_rounded, label: 'REFERENCE', color: amber),
      ],
    ),
  );

  Widget _salary() {
    final hasSalary = salaryLabel != null && salaryLabel!.trim().isNotEmpty;
    return _section(
      'COMPENSATION',
      'Salary intelligence',
      amber,
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: surface2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
        ),
        child: hasSalary
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('AVAILABLE SALARY DATA',
                    style: TextStyle(color: muted, fontSize: 10,
                        fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                const SizedBox(height: 8),
                Text(salaryLabel!,
                    style: const TextStyle(color: text, fontSize: 22,
                        fontWeight: FontWeight.w900)),
                if (salarySourceLabel != null && salarySourceLabel!.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(salarySourceLabel!,
                        style: const TextStyle(color: muted, fontSize: 11, height: 1.4)),
                  ),
              ])
            : const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.payments_outlined, color: amber, size: 22),
                SizedBox(width: 12),
                Expanded(child: Text(
                  'Salary data is not connected for this career yet. '
                  'A salary value will appear here only after a verified source is connected.',
                  style: TextStyle(color: muted, fontSize: 12, height: 1.5),
                )),
              ]),
      ),
    );
  }

  Widget _roleFamilies() {
    final roles = _rolesForCareer(career.title);
    if (roles.isEmpty) return const SizedBox.shrink();

    return _section(
      'ROLE FAMILIES',
      'Common engineering roles around this career',
      violetBright,
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Role families are career-level guidance, not current vacancies.',
              style: TextStyle(color: muted, fontSize: 11, height: 1.45),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: roles.map((role) => _RoleChip(label: role)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _companyLayer(BuildContext context) {
    final companies = _connectedCompanies();

    return _section(
      'CAREER → COMPANY',
      'Companies connected to this career',
      mint,
      Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surface2,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.business_center_outlined, color: mint, size: 22),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Reference company relationships help show where this career can exist. They do not mean the company is hiring right now.',
                    style: TextStyle(color: muted, fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          if (companies.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...companies.map((company) => _companyCard(context, company)),
          ] else
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _emptyCard(
                Icons.business_outlined,
                'No company relationship is mapped for this career yet.',
                mint,
              ),
            ),
        ],
      ),
    );
  }

  List<HomeCompany> _connectedCompanies() {
    return _relationshipService.companiesForCareer(
      career,
      _marketService.getCompanies(),
    );
  }

  Widget _companyCard(BuildContext context, HomeCompany company) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: InkWell(
    borderRadius: BorderRadius.circular(17),
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CompanyIntelligenceScreen(company: company),
      ),
    ),
    child: Ink(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: mint.withOpacity(.08),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: mint.withOpacity(.18)),
            ),
            child: const Icon(Icons.business_rounded, color: mint, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(company.name, style: const TextStyle(color: text, fontSize: 13.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                const Text('Reference relationship • not a live hiring signal', style: TextStyle(color: muted, fontSize: 10.5)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: muted, size: 15),
        ],
      ),
    ),
  ),
  );

  List<String> _rolesForCareer(String title) {
    final t = title.toLowerCase();
    if (t.contains('ai') || t.contains('machine learning') || t.contains('ml')) {
      return const ['AI Engineer', 'ML Engineer', 'Applied Scientist', 'ML Platform Engineer'];
    }
    if (t.contains('llm') || t.contains('nlp')) {
      return const ['NLP Engineer', 'LLM Engineer', 'Applied Scientist', 'AI Research Engineer'];
    }
    if (t.contains('computer vision')) {
      return const ['Computer Vision Engineer', 'Perception Engineer', 'ML Engineer', 'Applied Scientist'];
    }
    if (t.contains('data scientist')) {
      return const ['Data Scientist', 'Applied Scientist', 'Decision Scientist', 'ML Scientist'];
    }
    if (t.contains('data engineer')) {
      return const ['Data Engineer', 'Analytics Engineer', 'Data Platform Engineer', 'ETL Engineer'];
    }
    if (t.contains('security')) {
      return const ['Security Engineer', 'Application Security Engineer', 'Cloud Security Engineer', 'Security Analyst'];
    }
    if (t.contains('software') || t.contains('web')) {
      return const ['Software Engineer', 'Backend Engineer', 'Frontend Engineer', 'Full-Stack Engineer'];
    }
    if (t.contains('robot')) {
      return const ['Robotics Engineer', 'Perception Engineer', 'Controls Engineer', 'Robotics Software Engineer'];
    }
    if (t.contains('product')) {
      return const ['AI Product Manager', 'Technical Product Manager', 'Product Analyst', 'Product Engineer'];
    }
    return const [];
  }

  Widget _emptyCard(IconData icon, String message, Color color) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: surface2, borderRadius: BorderRadius.circular(18), border: Border.all(color: border)),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 21),
      const SizedBox(width: 11),
      Expanded(child: Text(message, style: const TextStyle(color: muted, fontSize: 12, height: 1.5))),
    ]),
  );

  Widget _yourSkills(BuildContext context) => _section(
    'YOUR CONNECTION',
    'Compare this career with my skills',
    cyan,
    InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const SkillProfileScreen())),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: surface2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cyan.withOpacity(.22)),
        ),
        child: const Row(children: [
          Icon(Icons.person_search_rounded, color: cyan, size: 25),
          SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('See where you currently stand',
                style: TextStyle(color: text, fontSize: 14, fontWeight: FontWeight.w800)),
            SizedBox(height: 4),
            Text('Open your existing skill profile. No second skill-gap engine is created here.',
                style: TextStyle(color: muted, fontSize: 11, height: 1.4)),
          ])),
          Icon(Icons.arrow_forward_ios_rounded, color: muted, size: 15),
        ]),
      ),
    ),
  );

  Widget _roadmapHandoff(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      gradient: LinearGradient(colors: [violet.withOpacity(.20), cyan.withOpacity(.07)]),
      border: Border.all(color: violet.withOpacity(.25)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('READY FOR THE COMPLETE PATH?',
          style: TextStyle(color: violetBright, fontSize: 10,
              fontWeight: FontWeight.w900, letterSpacing: 1.2)),
      const SizedBox(height: 8),
      const Text(
        'Career Intelligence explains the destination. Your existing Roadmap explains the full path.',
        style: TextStyle(color: text, fontSize: 15, height: 1.45, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 15),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RoadmapScreen()),
            ),
          icon: const Icon(Icons.route_rounded, size: 18),
          label: const Text('Open Existing Roadmap'),
          style: OutlinedButton.styleFrom(
            foregroundColor: violetBright,
            side: BorderSide(color: violet.withOpacity(.45)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ),
    ]),
  );

  Widget _section(String eyebrow, String title, Color accent, Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [
        Container(width: 5, height: 28,
            decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(10))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(eyebrow, style: TextStyle(color: accent, fontSize: 9.5,
              fontWeight: FontWeight.w900, letterSpacing: 1.2)),
          const SizedBox(height: 3),
          Text(title, style: const TextStyle(color: text, fontSize: 17, fontWeight: FontWeight.w900)),
        ])),
      ]),
      const SizedBox(height: 11),
      child,
    ],
  );

  Widget _card(IconData icon, Color color, String value) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: surface2, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border)),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 22),
      const SizedBox(width: 12),
      Expanded(child: Text(value,
          style: const TextStyle(color: Color(0xFFB8C0D2), fontSize: 12.5, height: 1.55))),
    ]),
  );

  Widget _chips(List<String> items, Color color) => Wrap(
    spacing: 8, runSpacing: 8,
    children: items.map((item) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(.18))),
      child: Text(item, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
    )).toList(),
  );

  Widget _skillMap(List<String> items) {
    final a = (items.length / 3).ceil();
    final foundation = items.take(a).toList();
    final core = items.skip(a).take(a).toList();
    final advanced = items.skip(a * 2).toList();
    return Column(children: [
      if (foundation.isNotEmpty) _level('FOUNDATION', foundation, cyan),
      if (core.isNotEmpty) ...[const SizedBox(height: 10), _level('CORE', core, mint)],
      if (advanced.isNotEmpty) ...[const SizedBox(height: 10), _level('ADVANCED', advanced, pink)],
    ]);
  }

  Widget _level(String label, List<String> items, Color color) => Container(
    width: double.infinity, padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(17),
        border: Border.all(color: border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(color: color, fontSize: 9,
          fontWeight: FontWeight.w900, letterSpacing: 1.2)),
      const SizedBox(height: 9),
      Wrap(spacing: 10, runSpacing: 7,
        children: items.map((item) => Text('• $item',
          style: const TextStyle(color: text, fontSize: 11.5, fontWeight: FontWeight.w700))).toList()),
    ]),
  );
}

class _RoleChip extends StatelessWidget {
  final String label;
  const _RoleChip({required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
    decoration: BoxDecoration(
      color: CareerIntelligenceScreen.violetBright.withOpacity(.07),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: CareerIntelligenceScreen.violetBright.withOpacity(.18)),
    ),
    child: Text(label, style: const TextStyle(color: CareerIntelligenceScreen.violetBright, fontSize: 10.5, fontWeight: FontWeight.w700)),
  );
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Pill({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(.20))),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: color, size: 14),
      const SizedBox(width: 6),
      Text(label, style: TextStyle(color: color, fontSize: 9.5,
          fontWeight: FontWeight.w900, letterSpacing: .7)),
    ]),
  );
}
