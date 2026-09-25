import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/models.dart';
import 'jobdetails_screen.dart';
import 'mentor_screen.dart';
import 'notifications_screen.dart';

// -----------------------------------------------------------------------------
// Career Guide — Home UI v2
//
// STEP 1 ONLY:
// - UI / visual design upgrade.
// - Existing search, Job model and navigation are preserved.
// - No new data source, Firebase logic, Copilot logic, Roadmap logic,
//   Courses logic, XP logic or live-market logic is introduced here.
//
// Design language intentionally follows the existing Skill Gap screen:
// #080B14 background, #111625 / #151B2D surfaces, #273047 borders,
// violet/cyan/mint/amber/pink semantic accents.
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
  String _search = '';

  List<Job> get _filteredJobs {
    final query = _search.trim().toLowerCase();

    if (query.isEmpty) {
      return kJobs;
    }

    return kJobs.where((job) {
      return job.title.toLowerCase().contains(query) ||
          job.company.toLowerCase().contains(query) ||
          job.location.toLowerCase().contains(query) ||
          job.type.toLowerCase().contains(query) ||
          job.skills.any(
            (skill) => skill.toLowerCase().contains(query),
          );
    }).toList();
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

  void _openJob(Job job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobDetailsScreen(job: job),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobs = _filteredJobs;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(),
                    const SizedBox(height: 16),
                    _buildHero(),
                    const SizedBox(height: 18),
                    _buildSearch(),
                    const SizedBox(height: 22),
                    _buildSectionHeader(
                      eyebrow: 'EXPLORE',
                      title: 'Discover Your Direction',
                      subtitle:
                          'Explore careers and find where your future could take you.',
                      accent: _violetBright,
                    ),
                    const SizedBox(height: 12),
                    _buildCareerExplorer(),
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      eyebrow: 'DISCOVER',
                      title: 'Explore Career Areas',
                      subtitle:
                          'Start with an area that matches your interests.',
                      accent: _cyan,
                    ),
                    const SizedBox(height: 12),
                    _buildCareerAreas(),
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      eyebrow: 'YOUR GUIDE',
                      title: 'Need a little direction?',
                      subtitle:
                          'Talk with your existing AI Career Mentor when you want help.',
                      accent: _mint,
                    ),
                    const SizedBox(height: 12),
                    _buildMentorCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      eyebrow: 'OPPORTUNITIES',
                      title: 'Explore Job Profiles',
                      subtitle:
                          'Browse the existing reference job profiles in your app.',
                      accent: _amber,
                      trailing: _search.isNotEmpty
                          ? '${jobs.length} result${jobs.length == 1 ? '' : 's'}'
                          : null,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            if (jobs.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
                  child: _buildEmptyState(),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final job = jobs[index];

                      return _JobCard(
                        job: job,
                        onTap: () => _openJob(job),
                      )
                          .animate()
                          .fadeIn(
                            delay: Duration(milliseconds: index * 35),
                            duration: 350.ms,
                          )
                          .slideY(begin: 0.025);
                    },
                    childCount: jobs.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 28),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: _cyan,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'CAREER GUIDE',
                    style: TextStyle(
                      color: _cyan,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              const Text(
                'Ready to Build Your Future?',
                style: TextStyle(
                  color: _text,
                  fontSize: 25,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _violet.withOpacity(0.32),
            _surface2,
            _cyan.withOpacity(0.075),
          ],
        ),
        border: Border.all(
          color: _violet.withOpacity(0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: _violet.withOpacity(0.09),
            blurRadius: 28,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -16,
            top: -18,
            child: Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _cyan.withOpacity(0.15),
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
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [_violet, _cyan],
                      ),
                    ),
                    child: const Icon(
                      Icons.explore_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.055),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                    child: const Text(
                      'DISCOVER',
                      style: TextStyle(
                        color: _violetBright,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Explore what could be next.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Discover careers, understand the world of work, '
                'and choose a direction worth exploring.',
                style: TextStyle(
                  color: _muted,
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _MiniPill(
                    icon: Icons.work_outline_rounded,
                    label: 'Careers',
                    color: _violetBright,
                  ),
                  const SizedBox(width: 7),
                  _MiniPill(
                    icon: Icons.trending_up_rounded,
                    label: 'Market',
                    color: _cyan,
                  ),
                  const SizedBox(width: 7),
                  _MiniPill(
                    icon: Icons.business_outlined,
                    label: 'Companies',
                    color: _mint,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 450.ms)
        .slideY(begin: 0.025);
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
          hintText: 'What do you want to become?',
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
    ).animate().fadeIn(duration: 450.ms, delay: 100.ms);
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

  Widget _buildCareerExplorer() {
    final featured = <_CareerPreview>[
      const _CareerPreview(
        icon: Icons.psychology_rounded,
        title: 'AI Engineer',
        subtitle: 'Build intelligent systems',
        accent: _violetBright,
      ),
      const _CareerPreview(
        icon: Icons.analytics_rounded,
        title: 'Data Scientist',
        subtitle: 'Turn data into decisions',
        accent: _cyan,
      ),
      const _CareerPreview(
        icon: Icons.memory_rounded,
        title: 'LLM Engineer',
        subtitle: 'Build with language models',
        accent: _pink,
      ),
    ];

    return SizedBox(
      height: 174,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: featured.length,
        separatorBuilder: (_, __) => const SizedBox(width: 11),
        itemBuilder: (context, index) {
          final career = featured[index];

          return _CareerPreviewCard(
            career: career,
            onTap: () {
              // UI-only step: keep this card visual for now.
              // Real career-detail routing/data is intentionally added
              // in the next step.
            },
          )
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: 120 + index * 70),
                duration: 350.ms,
              )
              .slideX(begin: 0.04);
        },
      ),
    );
  }

  Widget _buildCareerAreas() {
    const areas = <_CareerArea>[
      _CareerArea(
        icon: Icons.auto_awesome_rounded,
        title: 'AI & ML',
        accent: _violetBright,
      ),
      _CareerArea(
        icon: Icons.bar_chart_rounded,
        title: 'Data',
        accent: _cyan,
      ),
      _CareerArea(
        icon: Icons.code_rounded,
        title: 'Software',
        accent: _mint,
      ),
      _CareerArea(
        icon: Icons.shield_outlined,
        title: 'Security',
        accent: _amber,
      ),
      _CareerArea(
        icon: Icons.design_services_outlined,
        title: 'Creative',
        accent: _pink,
      ),
    ];

    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: areas.length,
        separatorBuilder: (_, __) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final area = areas[index];

          return _CareerAreaCard(area: area)
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: index * 45),
                duration: 300.ms,
              )
              .slideY(begin: 0.04);
        },
      ),
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
              color: _mint.withOpacity(0.16),
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
                      'Need help choosing a direction? Start a conversation.',
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

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _border,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            color: _muted,
            size: 42,
          ),
          SizedBox(height: 12),
          Text(
            'No matching profiles found',
            style: TextStyle(
              color: _text,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Try another career, company, location, or skill.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _muted,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

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

class _CareerPreview {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;

  const _CareerPreview({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
  });
}

class _CareerPreviewCard extends StatelessWidget {
  final _CareerPreview career;
  final VoidCallback onTap;

  const _CareerPreviewCard({
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
          width: 218,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: career.accent.withOpacity(0.18),
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
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        colors: [
                          career.accent.withOpacity(0.28),
                          _surface2,
                        ],
                      ),
                      border: Border.all(
                        color: career.accent.withOpacity(0.2),
                      ),
                    ),
                    child: Icon(
                      career.icon,
                      color: career.accent,
                      size: 21,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_outward_rounded,
                    color: career.accent.withOpacity(0.75),
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
                career.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Explore →',
                style: TextStyle(
                  color: career.accent,
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

class _CareerArea {
  final IconData icon;
  final String title;
  final Color accent;

  const _CareerArea({
    required this.icon,
    required this.title,
    required this.accent,
  });
}

class _CareerAreaCard extends StatelessWidget {
  final _CareerArea area;

  const _CareerAreaCard({
    required this.area,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108,
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: _border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            area.icon,
            color: area.accent,
            size: 20,
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
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  const _JobCard({
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _surface2,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: _border,
                  ),
                ),
                child: Center(
                  child: Text(
                    job.icon,
                    style: const TextStyle(fontSize: 23),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${job.company} · ${job.location}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 10.5,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      job.salary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _violetBright,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 5,
                      runSpacing: 4,
                      children: job.skills.take(3).map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _violet.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _violet.withOpacity(0.12),
                            ),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(
                              color: _violetBright,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _violet.withOpacity(0.10),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _violet.withOpacity(0.18),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: _violetBright,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
