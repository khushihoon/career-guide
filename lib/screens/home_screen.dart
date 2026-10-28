import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/home_market_models.dart';
import '../services/home_market_service.dart';
import '../services/verified_company_skills_step6e3.dart';
import 'mentor_screen.dart';
import 'notifications_screen.dart';
import 'skill_profile_screen.dart';
import 'career_intelligence_screen.dart';
import 'company_intelligence_screen.dart';

// -----------------------------------------------------------------------------
// Career Guide — Home
//
// HOME ROLE:
// Career discovery + career world + company awareness + factual insights.
//
// NOT HOME:
// - Roadmap learning path
// - Copilot daily guidance
// - Course catalogue
// - AI Mentor conversation
// - Application management
//
// DATA:
// HomeMarketService
//
// IMPORTANT:
// Reference information is never presented as live hiring information.
// Live jobs / hiring / salary will only appear when a verified source is
// connected later.
//
// COMPANY ORDER:
// Companies are shown best-covered first (verified reference + skills evidence,
// then verified, then companies with recorded details, then the rest), so the
// first cards a person sees carry real information. The order is only a
// presentation order; it never changes any company's data.
// -----------------------------------------------------------------------------

const _bg = Color(0xFF080B14);
const _surface = Color(0xFF111625);
const _surface2 = Color(0xFF151B2D);
const _border = Color(0xFF273047);

const _violet = Color(0xFF8B5CF6);
const _violetBright = Color(0xFFA78BFA);
const _cyan = Color(0xFF22D3EE);
const _mint = Color(0xFF34D399);
const _amber = Color(0xFFF59E0B);
const _pink = Color(0xFFF472B6);

const _muted = Color(0xFF8D96AB);
const _text = Color(0xFFF7F8FC);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const HomeMarketService _marketService = HomeMarketService();

  static const VerifiedCompanySkillsService _skillsService =
      VerifiedCompanySkillsService();

  /// Companies shown when nothing is searched or filtered.
  static const int _defaultCompanyCount = 12;

  late HomeMarketSnapshot _snapshot;
  late List<HomeCompany> _rankedCompanies;

  final TextEditingController _searchController = TextEditingController();

  String _search = '';

  /// Career area chosen by the person (filters by the area's career IDs).
  HomeCareerArea? _selectedArea;

  String get _userName {
    final name = FirebaseAuth.instance.currentUser?.displayName?.trim();
    if (name != null && name.isNotEmpty) {
      return name.split(' ').first;
    }
    return 'THERE';
  }

  @override
  void initState() {
    super.initState();
    _snapshot = _marketService.getSnapshot();
    _rankedCompanies = _rank(_snapshot.companies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // COMPANY ORDER (presentation only)
  // ---------------------------------------------------------------------------

  int _coverageScore(HomeCompany company) {
    var score = 0;

    if (company.meta.source?.isOfficial == true) {
      score += 100;
    } else if ((company.description ?? '').trim().isNotEmpty) {
      score += 40;
    }

    if (_skillsService.find(company.name) != null) {
      score += 50;
    }

    if (company.focusAreas.isNotEmpty) {
      score += 5;
    }

    score += company.relatedCareerIds.length;

    return score;
  }

  /// Highest coverage first. Equal scores keep their original order.
  List<HomeCompany> _rank(List<HomeCompany> companies) {
    final indexed = companies.asMap().entries.toList();

    indexed.sort((a, b) {
      final byScore =
          _coverageScore(b.value).compareTo(_coverageScore(a.value));

      return byScore != 0 ? byScore : a.key.compareTo(b.key);
    });

    return indexed.map((entry) => entry.value).toList(growable: false);
  }

  // ---------------------------------------------------------------------------
  // FILTERS
  // ---------------------------------------------------------------------------

  List<HomeCareer> get _filteredCareers {
    final query = _search.trim().toLowerCase();

    var careers =
        query.isEmpty ? _snapshot.careers : _marketService.searchCareers(query);

    final area = _selectedArea;

    if (area != null) {
      careers = careers
          .where((career) => area.careerIds.contains(career.id))
          .toList(growable: false);
    }

    return careers;
  }

  List<HomeCompany> get _filteredCompanies {
    final query = _search.trim().toLowerCase();

    var companies = query.isEmpty
        ? _rankedCompanies
        : _rank(_marketService.searchCompanies(query));

    final area = _selectedArea;

    if (area != null) {
      companies = companies
          .where(
            (company) => company.relatedCareerIds.any(
              (careerId) => area.careerIds.contains(careerId),
            ),
          )
          .toList(growable: false);
    }

    if (query.isEmpty && area == null) {
      return companies.take(_defaultCompanyCount).toList(growable: false);
    }

    return companies;
  }

  void _toggleArea(HomeCareerArea area) {
    setState(() {
      _selectedArea = _selectedArea?.id == area.id ? null : area;
    });
  }

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NotificationsScreen(),
      ),
    );
  }

  void _openMentor() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MentorScreen(),
      ),
    );
  }

  void _openCareerProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SkillProfileScreen(),
      ),
    );
  }

  void _showCareer(HomeCareer career) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CareerIntelligenceScreen(
          career: career,
        ),
      ),
    );
  }

  void _showCompany(HomeCompany company) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CompanyIntelligenceScreen(
          company: company,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final careers = _filteredCareers;
    final companies = _filteredCompanies;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  14,
                  18,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(),
                    const SizedBox(height: 16),
                    _buildHero(),
                    const SizedBox(height: 18),
                    _buildSearch(),
                    const SizedBox(height: 18),
                    _buildCareerWorldSignal(),
                    const SizedBox(height: 26),
                    _buildSectionHeader(
                      eyebrow: '01  •  DISCOVER',
                      title: 'Explore Career Paths',
                      subtitle:
                          'Understand what different careers actually involve.',
                      accent: _violetBright,
                      trailing: '${careers.length}',
                    ),
                    const SizedBox(height: 12),
                    _buildCareerExplorer(careers),
                    const SizedBox(height: 26),
                    _buildSectionHeader(
                      eyebrow: '02  •  EXPLORE',
                      title: 'Career Areas',
                      subtitle:
                          'Start broad, then discover roles inside each area.',
                      accent: _cyan,
                    ),
                    const SizedBox(height: 12),
                    _buildCareerAreas(),
                    const SizedBox(height: 26),
                    _buildSectionHeader(
                      eyebrow: '03  •  REAL WORLD',
                      title: 'Companies to Know',
                      subtitle:
                          'Explore organizations connected to technology and AI.',
                      accent: _mint,
                      trailing:
                          '${companies.length} of ${_snapshot.companies.length}',
                    ),
                    const SizedBox(height: 12),
                    _buildCompanies(companies),
                    const SizedBox(height: 26),
                    _buildSectionHeader(
                      eyebrow: '04  •  INTELLIGENCE',
                      title: 'Things Worth Knowing',
                      subtitle:
                          'Useful context before you choose your direction.',
                      accent: _amber,
                    ),
                    const SizedBox(height: 12),
                    _buildInsights(),
                    const SizedBox(height: 26),
                    _buildSectionHeader(
                      eyebrow: '05  •  YOUR GUIDE',
                      title: 'AI Career Mentor',
                      subtitle:
                          'Use the existing AI Career Mentor when you want a conversation.',
                      accent: _pink,
                    ),
                    const SizedBox(height: 12),
                    _buildMentorCard(),
                    const SizedBox(height: 26),
                    _buildOpportunityStatus(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _surface2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _border),
                ),
                child: const _CareerGuideLogo(
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'CAREER GUIDE',
                style: TextStyle(
                  color: _text,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.35,
                ),
              ),
            ],
          ),
        ),
        _IconButton(
          icon: Icons.notifications_none_rounded,
          onTap: _openNotifications,
          tooltip: 'Notifications',
        ),
      ],
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _violet.withOpacity(0.30),
            _surface2,
            _cyan.withOpacity(0.08),
          ],
        ),
        border: Border.all(color: _violet.withOpacity(0.26)),
        boxShadow: [
          BoxShadow(
            color: _violet.withOpacity(0.08),
            blurRadius: 30,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -28,
            top: -35,
            child: Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _cyan.withOpacity(0.13),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _violet.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _violetBright.withOpacity(0.18),
                      ),
                    ),
                    child: const Text(
                      'YOUR CAREER SPACE',
                      style: TextStyle(
                        color: _violetBright,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.9,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const _CareerGuideLogo(
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'HEY ${_userName.toUpperCase()}! 👋',
                style: const TextStyle(
                  color: _cyan,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                "I'm right here\n"
                "to guide you.",
                style: TextStyle(
                  color: _text,
                  fontSize: 29,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 11),
              const Text(
                "Explore careers, discover companies and\n"
                "understand the world behind your future.",
                style: TextStyle(
                  color: _muted,
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 17),
              Row(
                children: const [
                  _MiniPill(
                    icon: Icons.work_outline_rounded,
                    label: 'Careers',
                    color: _violetBright,
                  ),
                  SizedBox(width: 7),
                  _MiniPill(
                    icon: Icons.business_outlined,
                    label: 'Companies',
                    color: _mint,
                  ),
                  SizedBox(width: 7),
                  _MiniPill(
                    icon: Icons.insights_rounded,
                    label: 'Insights',
                    color: _cyan,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.025);
  }

  Widget _buildSearch() {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _search = value;
          });
        },
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          color: _text,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search a career, company, skill or technology',
          hintStyle: const TextStyle(
            color: _muted,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: _violetBright,
          ),
          suffixIcon: _search.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _search = '';
                    });
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: _muted,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 17,
            horizontal: 4,
          ),
        ),
      ),
    ).animate().fadeIn(
          duration: 450.ms,
          delay: 100.ms,
        );
  }

  Widget _buildCareerWorldSignal() {
    final insight =
        _snapshot.insights.isNotEmpty ? _snapshot.insights.first : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: _cyan.withOpacity(0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _cyan.withOpacity(0.09),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: _cyan.withOpacity(0.18)),
            ),
            child: const Icon(
              Icons.public_rounded,
              color: _cyan,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'CAREER WORLD',
                      style: TextStyle(
                        color: _cyan,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.15,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _amber.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Text(
                        'REFERENCE',
                        style: TextStyle(
                          color: _amber,
                          fontSize: 7,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'Which company will be next?',
                  style: TextStyle(
                    color: _text,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  insight?.summary ??
                      'Explore career areas, companies and the skills connected to different roles.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 10.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms);
  }

  Widget _buildSectionHeader({
    required String eyebrow,
    required String title,
    required String subtitle,
    required Color accent,
    String? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 4,
          height: 34,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: TextStyle(
                  color: accent,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: const TextStyle(
                  color: _text,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 10.5,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          Text(
            trailing,
            style: TextStyle(
              color: accent,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCareerExplorer(
    List<HomeCareer> careers,
  ) {
    if (careers.isEmpty) {
      return _EmptyCard(
        icon: Icons.search_off_rounded,
        title: 'No careers found',
        subtitle: 'Try another career or company search.',
      );
    }

    return SizedBox(
      height: 184,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: careers.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 11);
        },
        itemBuilder: (context, index) {
          final career = careers[index];

          return _CareerCard(
            career: career,
            onTap: () => _showCareer(career),
          )
              .animate()
              .fadeIn(
                delay: Duration(
                  milliseconds: 80 + index * 55,
                ),
                duration: 320.ms,
              )
              .slideX(begin: 0.035);
        },
      ),
    );
  }

  Widget _buildCareerAreas() {
    final areas = _snapshot.areas;
    final selected = _selectedArea;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 98,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: areas.length,
            separatorBuilder: (_, __) {
              return const SizedBox(width: 9);
            },
            itemBuilder: (context, index) {
              final area = areas[index];

              return _CareerAreaCard(
                area: area,
                selected: selected?.id == area.id,
                onTap: () => _toggleArea(area),
              )
                  .animate()
                  .fadeIn(
                    delay: Duration(
                      milliseconds: index * 45,
                    ),
                    duration: 300.ms,
                  )
                  .slideY(begin: 0.04);
            },
          ),
        ),
        if (selected != null) ...[
          const SizedBox(height: 9),
          Text(
            'Showing ${selected.title} careers and their companies. '
            'Tap the area again to show everything.',
            style: const TextStyle(
              color: _muted,
              fontSize: 10,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCompanies(
    List<HomeCompany> companies,
  ) {
    if (companies.isEmpty) {
      return const _EmptyCard(
        icon: Icons.business_outlined,
        title: 'No companies found',
        subtitle: 'Try another company name.',
      );
    }

    return SizedBox(
      height: 154,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: companies.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (context, index) {
          final company = companies[index];

          return _CompanyCard(
            company: company,
            onTap: () => _showCompany(company),
          )
              .animate()
              .fadeIn(
                delay: Duration(
                  milliseconds: (index < 12 ? index : 12) * 45,
                ),
                duration: 300.ms,
              )
              .slideX(begin: 0.03);
        },
      ),
    );
  }

  Widget _buildInsights() {
    final insights = _snapshot.insights;

    return Column(
      children: [
        for (var i = 0; i < insights.length; i++) ...[
          _InsightCard(
            insight: insights[i],
          )
              .animate()
              .fadeIn(
                delay: Duration(
                  milliseconds: i * 70,
                ),
                duration: 320.ms,
              )
              .slideY(begin: 0.03),
          if (i != insights.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildMentorCard() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _openMentor,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(21),
            border: Border.all(
              color: _pink.withOpacity(0.16),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      _mint.withOpacity(0.9),
                      _cyan.withOpacity(0.8),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.smart_toy_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Career Mentor',
                      style: TextStyle(
                        color: _text,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Want a conversation about your career direction?',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _muted,
                        fontSize: 10.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _mint.withOpacity(0.09),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _mint.withOpacity(0.18),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: _mint,
                  size: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpportunityStatus() {
    final jobs = _snapshot.jobs;
    final hiring = _snapshot.hiring;
    final salaries = _snapshot.salaries;

    final bool hasLiveJobs = jobs.any(
      (job) => job.meta.isLive,
    );

    final bool hasLiveHiring = hiring.any(
      (item) => item.meta.isLive,
    );

    final bool hasSalary = salaries.any(
      (salary) => salary.meta.isLive,
    );

    final bool hasLiveMarketData = hasLiveJobs || hasLiveHiring || hasSalary;

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: hasLiveMarketData ? _mint.withOpacity(0.22) : _border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: hasLiveMarketData
                  ? _mint.withOpacity(0.10)
                  : _amber.withOpacity(0.09),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              hasLiveMarketData
                  ? Icons.public_rounded
                  : Icons.info_outline_rounded,
              color: hasLiveMarketData ? _mint : _amber,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasLiveMarketData
                      ? 'Live opportunity data available'
                      : 'Live job data is not connected yet',
                  style: const TextStyle(
                    color: _text,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasLiveMarketData
                      ? 'Current opportunity information is shown only '
                          'when a verified source provides it.'
                      : 'The information above is career and company '
                          'reference data. Current openings and salary '
                          'appear on a company page only when a verified '
                          'live source is connected for that company.',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 10.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SMALL UI COMPONENTS
// -----------------------------------------------------------------------------

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const _IconButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _border,
              ),
            ),
            child: Icon(
              icon,
              color: _violetBright,
              size: 21,
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MiniPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.045),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 13,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CareerCard extends StatelessWidget {
  final HomeCareer career;
  final VoidCallback onTap;

  const _CareerCard({
    required this.career,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 225,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: _violetBright.withOpacity(0.17),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _CareerIcon(
                    icon: career.icon,
                    color: _violetBright,
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_outward_rounded,
                    color: _violetBright,
                    size: 17,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                career.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _text,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                career.shortDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 10,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Explore →',
                style: const TextStyle(
                  color: _violetBright,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CareerIcon extends StatelessWidget {
  final String? icon;
  final Color color;
  final double size;

  const _CareerIcon({
    required this.icon,
    required this.color,
    this.size = 42,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withOpacity(0.10),
        border: Border.all(
          color: color.withOpacity(0.18),
        ),
      ),
      child: Center(
        child: Text(
          icon ?? '💼',
          style: TextStyle(
            fontSize: size * 0.43,
          ),
        ),
      ),
    );
  }
}

class _CareerAreaCard extends StatelessWidget {
  final HomeCareerArea area;
  final bool selected;
  final VoidCallback onTap;

  const _CareerAreaCard({
    required this.area,
    required this.onTap,
    this.selected = false,
  });

  IconData _iconForArea() {
    switch (area.id) {
      case 'ai_ml':
        return Icons.auto_awesome_rounded;
      case 'data':
        return Icons.bar_chart_rounded;
      case 'software':
        return Icons.code_rounded;
      case 'security':
        return Icons.shield_outlined;
      case 'creative':
        return Icons.design_services_outlined;
      default:
        return Icons.explore_rounded;
    }
  }

  Color _colorForArea() {
    switch (area.id) {
      case 'ai_ml':
        return _violetBright;
      case 'data':
        return _cyan;
      case 'software':
        return _mint;
      case 'security':
        return _amber;
      case 'creative':
        return _pink;
      default:
        return _violetBright;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForArea();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          width: 116,
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.10) : _surface,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected ? color.withOpacity(0.55) : _border,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _iconForArea(),
                color: color,
                size: 21,
              ),
              const Spacer(),
              Text(
                area.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _text,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${area.careerIds.length} careers',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 8.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final HomeCompany company;
  final VoidCallback onTap;

  const _CompanyCard({
    required this.company,
    required this.onTap,
  });

  /// One line of real information: the company's focus areas when known,
  /// otherwise how many careers it is connected to.
  String _subtitle() {
    if (company.focusAreas.isNotEmpty) {
      return company.focusAreas.take(2).join(' • ');
    }

    final careers = company.relatedCareerIds.length;

    if (careers > 0) {
      return careers == 1 ? '1 connected career' : '$careers connected careers';
    }

    return 'Company information';
  }

  @override
  Widget build(BuildContext context) {
    final verified = company.meta.source?.isOfficial == true;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 190,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: verified ? _mint.withOpacity(0.22) : _border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _CompanyIcon(
                    company: company,
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: _mint,
                    size: 17,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                company.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _text,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _subtitle(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                verified ? 'Verified reference' : 'Reference information',
                style: TextStyle(
                  color: verified ? _mint : _cyan,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompanyIcon extends StatelessWidget {
  final HomeCompany company;
  final double size;

  const _CompanyIcon({
    required this.company,
    this.size = 43,
  });

  @override
  Widget build(BuildContext context) {
    final value = company.logo?.trim();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _border,
        ),
      ),
      child: Center(
        child: value == null || value.isEmpty
            ? Text(
                company.name.isEmpty
                    ? '?'
                    : company.name.characters.first.toUpperCase(),
                style: const TextStyle(
                  color: _text,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              )
            : Text(
                value,
                style: const TextStyle(
                  fontSize: 19,
                ),
              ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final HomeCareerInsight insight;

  const _InsightCard({
    required this.insight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: _border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _amber.withOpacity(0.09),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: _amber,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  insight.summary,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 10.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                _ReferenceBadge(
                  meta: insight.meta,
                  compact: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLabel extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _InfoLabel({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              color: _muted,
              fontSize: 11,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color color;

  const _ChipSection({
    required this.title,
    required this.items,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 8,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: items.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.07),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: color.withOpacity(0.13),
                ),
              ),
              child: Text(
                item,
                style: TextStyle(
                  color: color,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ReferenceBadge extends StatelessWidget {
  final HomeDataMeta meta;
  final bool compact;

  const _ReferenceBadge({
    required this.meta,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color color;

    switch (meta.status) {
      case HomeDataStatus.live:
        color = _mint;
        break;
      case HomeDataStatus.reference:
        color = _cyan;
        break;
      case HomeDataStatus.unavailable:
        color = _amber;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 9,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.13),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            meta.status == HomeDataStatus.live
                ? Icons.public_rounded
                : meta.status == HomeDataStatus.reference
                    ? Icons.menu_book_rounded
                    : Icons.info_outline_rounded,
            color: color,
            size: compact ? 11 : 13,
          ),
          const SizedBox(width: 5),
          Text(
            meta.statusLabel,
            style: TextStyle(
              color: color,
              fontSize: compact ? 8 : 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallFact extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SmallFact({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _surface2,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 17,
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 7,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _muted,
              fontSize: 9.5,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _border,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: _muted,
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: _text,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _muted,
              fontSize: 10.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _CareerGuideLogo extends StatelessWidget {
  final double size;

  const _CareerGuideLogo({
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CareerGuideLogoPainter(),
      ),
    );
  }
}

class _CareerGuideLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 * 0.92;

    Offset hexPoint(double angleDeg) {
      final a = angleDeg * math.pi / 180;
      return Offset(
        cx + r * math.cos(a),
        cy + r * math.sin(a),
      );
    }

    final hexPath = Path()
      ..moveTo(hexPoint(-90).dx, hexPoint(-90).dy)
      ..lineTo(hexPoint(-30).dx, hexPoint(-30).dy)
      ..lineTo(hexPoint(30).dx, hexPoint(30).dy)
      ..lineTo(hexPoint(90).dx, hexPoint(90).dy)
      ..lineTo(hexPoint(150).dx, hexPoint(150).dy)
      ..lineTo(hexPoint(210).dx, hexPoint(210).dy)
      ..close();

    canvas.drawPath(
      hexPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF241454),
            Color(0xFF150E33),
            Color(0xFF0B0B16),
          ],
        ).createShader(
          Rect.fromCircle(
            center: Offset(cx, cy),
            radius: r,
          ),
        ),
    );

    canvas.drawPath(
      hexPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.045
        ..color = const Color(0xFF8B5CF6).withOpacity(0.55),
    );

    final baseY = cy + r * 0.42;

    final bars = [
      (
        x: cx - r * 0.34,
        width: r * 0.19,
        height: r * 0.32,
        opacity: 0.55,
      ),
      (
        x: cx - r * 0.06,
        width: r * 0.19,
        height: r * 0.62,
        opacity: 0.78,
      ),
      (
        x: cx + r * 0.22,
        width: r * 0.19,
        height: r * 0.98,
        opacity: 1.0,
      ),
    ];

    for (final bar in bars) {
      final rect = Rect.fromLTWH(
        bar.x,
        baseY - bar.height,
        bar.width,
        bar.height,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect,
          Radius.circular(bar.width * 0.18),
        ),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              const Color(0xFF7C3AED).withOpacity(bar.opacity),
              const Color(0xFF22D3EE).withOpacity(bar.opacity),
            ],
          ).createShader(rect),
      );
    }

    final last = bars.last;
    final spark = Offset(
      last.x + last.width / 2,
      baseY - last.height - r * 0.06,
    );
    final sparkRadius = r * 0.10;

    canvas.drawCircle(
      spark,
      sparkRadius * 2.4,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF67E8F9).withOpacity(0.45),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(
            center: spark,
            radius: sparkRadius * 2.4,
          ),
        ),
    );

    canvas.drawCircle(
      spark,
      sparkRadius,
      Paint()..color = const Color(0xFFA5F3FC),
    );

    canvas.drawCircle(
      Offset(
        spark.dx - sparkRadius * 0.3,
        spark.dy - sparkRadius * 0.3,
      ),
      sparkRadius * 0.3,
      Paint()..color = Colors.white.withOpacity(0.9),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
