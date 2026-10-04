import 'package:flutter/material.dart';

import '../models/home_market_models.dart';
import '../services/company_intelligence_ids.dart';
import '../services/company_intelligence_models.dart';
import '../services/company_intelligence_service.dart';
import '../services/company_intelligence_live_ingestion_service.dart';
import '../services/verified_company_skills_step6e3.dart';

const _surface = Color(0xFF111625);
const _surface2 = Color(0xFF151B2D);
const _border = Color(0xFF273047);
const _cyan = Color(0xFF22D3EE);
const _mint = Color(0xFF34D399);
const _amber = Color(0xFFF59E0B);
const _pink = Color(0xFFF472B6);
const _violetBright = Color(0xFFA78BFA);
const _muted = Color(0xFF8D96AB);
const _text = Color(0xFFF7F8FC);

/// Step 6E-4 — Dynamic Company Intelligence UI.
///
/// Data layers are intentionally separated:
///
/// REFERENCE:
/// - Verified company-specific skill profile.
/// - Stable company identity.
/// - Historical/reference information.
///
/// LIVE:
/// - Current published opportunities.
/// - Observed role families.
/// - Observed skills/technologies.
/// - Source-provided compensation.
///
/// The panel never converts reference data into a claim about current hiring.
///
/// If dynamic evidence is unavailable, the verified-company skill profile
/// remains available as the reference fallback.
class CompanyIntelligenceDynamicPanel extends StatefulWidget {
  static const CompanyIntelligenceService _service =
      CompanyIntelligenceService();

  static const CompanyIntelligenceLiveIngestionService _liveService =
      CompanyIntelligenceLiveIngestionService();

  final HomeCompany company;
  final VerifiedCompanySkillProfile? verifiedFallback;

  const CompanyIntelligenceDynamicPanel({
    super.key,
    required this.company,
    this.verifiedFallback,
  });

  @override
  State<CompanyIntelligenceDynamicPanel> createState() =>
      _CompanyIntelligenceDynamicPanelState();
}

class _CompanyIntelligenceDynamicPanelState
    extends State<CompanyIntelligenceDynamicPanel> {
  CompanyIntelligenceSnapshot? _liveSnapshot;
  bool _isRefreshing = false;
  String? _refreshMessage;

  Future<CompanyIntelligenceSnapshot?> _refreshThenReadCache(
    String companyName,
  ) async {
    final stableId = CompanyIntelligenceIds.fromCompanyName(companyName);

    try {
      final refreshed = await CompanyIntelligenceDynamicPanel._liveService
          .refreshCompany(companyName);

      if (refreshed != null) {
        debugPrint(
          'Company Intelligence live refresh succeeded: '
          '$stableId | '
          '${refreshed.liveJobs.length} jobs, '
          '${refreshed.skills.length} skills.',
        );

        if (mounted) {
          _refreshMessage = refreshed.hasLiveJobs
              ? 'Live opportunity data updated from the connected source.'
              : 'Connected source returned no current published opportunities.';
        }

        return refreshed;
      }

      if (mounted) {
        _refreshMessage =
            'No live source is configured for this company yet.';
      }
    } catch (error) {
      debugPrint(
        'Company Intelligence live refresh failed for '
        '$companyName ($stableId): $error',
      );

      if (mounted) {
        _refreshMessage =
            'Live source is temporarily unavailable. Reference data remains available.';
      }

      // Keep the last known normalized snapshot if the live source is
      // temporarily unavailable. The UI still labels cached evidence by its
      // source timestamp and never treats reference data as live hiring.
    }

    final cached = await CompanyIntelligenceDynamicPanel._service
        .cachedCompany(companyName);

    if (cached != null && mounted) {
      _refreshMessage =
          'Showing the latest normalized snapshot available in cache.';
    }

    return cached;
  }

  @override
  void initState() {
    super.initState();
    _startBackgroundRefresh();
  }

  Future<void> _startBackgroundRefresh() async {
    if (!mounted) return;

    setState(() {
      _isRefreshing = true;
      _refreshMessage = null;
    });

    final snapshot = await _refreshThenReadCache(
      widget.company.name,
    );

    if (!mounted) return;

    setState(() {
      _liveSnapshot = snapshot;
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ReferenceWithLiveOpportunities(
      profile: widget.verifiedFallback,
      liveSnapshot: _liveSnapshot,
      isRefreshing: _isRefreshing,
      refreshMessage: _refreshMessage,
    );
  }
}

class _ReferenceWithLiveOpportunities extends StatelessWidget {
  final VerifiedCompanySkillProfile? profile;
  final CompanyIntelligenceSnapshot? liveSnapshot;
  final bool isRefreshing;
  final String? refreshMessage;

  const _ReferenceWithLiveOpportunities({
    required this.profile,
    required this.liveSnapshot,
    required this.isRefreshing,
    required this.refreshMessage,
  });

  @override
  Widget build(BuildContext context) {
    final hasLiveJobs = liveSnapshot?.hasLiveJobs == true;
    final hasLiveSnapshot = liveSnapshot != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DynamicSectionCard(
          icon: Icons.psychology_alt_outlined,
          iconColor: _pink,
          title: 'Skills & technologies',
          child: profile == null
              ? const _NotConnectedText(
                  'Verified company-specific skills are not connected for this company yet.',
                )
              : _ReferenceSkills(profile: profile!),
        ),
        const SizedBox(height: 12),
        _DynamicSectionCard(
          icon: Icons.payments_outlined,
          iconColor: _amber,
          title: 'Salary intelligence',
          child: hasLiveSnapshot && liveSnapshot!.hasCompensation
              ? _CompensationList(
                  items: liveSnapshot!.compensation,
                )
              : const _NotConnectedText(
                  'No verified company salary snapshot is available yet. No salary number is invented.',
                ),
        ),
        const SizedBox(height: 12),
        _DynamicSectionCard(
          icon: Icons.work_history_outlined,
          iconColor: _cyan,
          title: 'Current opportunities',
          child: hasLiveJobs
              ? _LiveJobList(
                  jobs: liveSnapshot!.liveJobs,
                )
              : _NotConnectedText(
                  isRefreshing
                      ? 'Current opportunities are being checked in the background. Reference company data remains available immediately.'
                      : refreshMessage ??
                          'No current published opportunities were returned by the connected source.',
                ),
        ),
        if (hasLiveSnapshot) ...[
          const SizedBox(height: 12),
          _EvidenceCard(
            title: 'Live opportunity source',
            message: liveSnapshot!.sources.isNotEmpty
                ? '${liveSnapshot!.truthLabel}. Last normalized update: '
                    '${liveSnapshot!.generatedAt.toIso8601String().split('T').first}.'
                : 'Current opportunity data was returned by the connected source.',
            color: _mint,
          ),
        ],
      ],
    );
  }
}

class _DynamicContent extends StatelessWidget {
  final CompanyIntelligenceSnapshot snapshot;

  const _DynamicContent({
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    final lastSync =
        snapshot.generatedAt.toIso8601String().split('T').first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DynamicSectionCard(
          icon: Icons.work_outline_rounded,
          iconColor: _amber,
          title: 'Observed role families',
          child: snapshot.roles.isEmpty
              ? const _NotConnectedText(
                  'No role-family signal was detected in the reviewed postings.',
                )
              : _ChipWrap(
                  snapshot.roles,
                  _amber,
                ),
        ),
        const SizedBox(height: 12),
        _DynamicSectionCard(
          icon: Icons.psychology_alt_outlined,
          iconColor: _pink,
          title: 'Observed skills & technologies',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (snapshot.skills.isNotEmpty) ...[
                const _GroupTitle(
                  icon: Icons.code_rounded,
                  title: 'Core skills',
                  color: _pink,
                ),
                const SizedBox(height: 8),
                _ChipWrap(
                  snapshot.skills,
                  _pink,
                ),
                const SizedBox(height: 14),
              ],
              if (snapshot.technologies.isNotEmpty) ...[
                const _GroupTitle(
                  icon: Icons.memory_rounded,
                  title: 'Technologies & tools',
                  color: _cyan,
                ),
                const SizedBox(height: 8),
                _ChipWrap(
                  snapshot.technologies,
                  _cyan,
                ),
                const SizedBox(height: 14),
              ],
              if (snapshot.engineeringConcepts.isNotEmpty) ...[
                const _GroupTitle(
                  icon: Icons.account_tree_rounded,
                  title: 'Engineering concepts',
                  color: _violetBright,
                ),
                const SizedBox(height: 8),
                _ChipWrap(
                  snapshot.engineeringConcepts,
                  _violetBright,
                ),
              ],
              if (!snapshot.hasObservedSkills) ...[
                const _NotConnectedText(
                  'No skill or technology signal was detected in the reviewed postings.',
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        _DynamicSectionCard(
          icon: Icons.payments_outlined,
          iconColor: _amber,
          title: 'Salary intelligence',
          child: snapshot.hasCompensation
              ? _CompensationList(
                  items: snapshot.compensation,
                )
              : const _NotConnectedText(
                  'No numeric salary range was supplied by the connected source for the reviewed postings.',
                ),
        ),
        const SizedBox(height: 12),
        _DynamicSectionCard(
          icon: Icons.work_history_outlined,
          iconColor: _cyan,
          title: 'Current opportunities',
          child: snapshot.hasLiveJobs
              ? _LiveJobList(
                  jobs: snapshot.liveJobs,
                )
              : const _NotConnectedText(
                  'No current published opportunities were returned by the connected source.',
                ),
        ),
        const SizedBox(height: 12),
        _EvidenceCard(
          title: 'Automatic intelligence source',
          message:
              '${snapshot.truthLabel}. Last normalized update: $lastSync.',
          color: _mint,
        ),
        if (snapshot.sources.isNotEmpty) ...[
          const SizedBox(height: 10),
          for (final source in snapshot.sources)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${source.sourceLabel}\n${source.sourceUrl}',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 9.5,
                  height: 1.45,
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _ReferenceFallback extends StatelessWidget {
  final VerifiedCompanySkillProfile? profile;

  const _ReferenceFallback({
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DynamicSectionCard(
          icon: Icons.psychology_alt_outlined,
          iconColor: _pink,
          title: 'Skills & technologies',
          child: profile == null
              ? const _NotConnectedText(
                  'Verified company-specific skills are not connected for this company yet. The automatic source pipeline is ready, but no normalized source snapshot has been ingested.',
                )
              : _ReferenceSkills(
                  profile: profile!,
                ),
        ),
        const SizedBox(height: 12),
        _DynamicSectionCard(
          icon: Icons.payments_outlined,
          iconColor: _amber,
          title: 'Salary intelligence',
          child: const _NotConnectedText(
            'No verified company salary snapshot is available yet. No salary number is invented.',
          ),
        ),
        const SizedBox(height: 12),
        _DynamicSectionCard(
          icon: Icons.work_history_outlined,
          iconColor: _cyan,
          title: 'Current opportunities',
          child: const _NotConnectedText(
            'Current hiring is not connected yet. Reference company information must never be interpreted as proof that the company is hiring now.',
          ),
        ),
        const SizedBox(height: 12),
        const _EvidenceCard(
          title: 'Automatic intelligence pipeline',
          message:
              'The app is ready to consume normalized company-source data. Current skills, salary and live opportunities appear only after a permitted source is ingested and verified.',
          color: _muted,
        ),
      ],
    );
  }
}

class _ReferenceSkills extends StatelessWidget {
  final VerifiedCompanySkillProfile profile;

  const _ReferenceSkills({
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final date =
        profile.lastVerified.toIso8601String().split('T').first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verified reference skill signals remain available while no newer normalized snapshot is cached.',
          style: TextStyle(
            color: _muted,
            fontSize: 10.5,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        if (profile.skills.isNotEmpty) ...[
          const _GroupTitle(
            icon: Icons.code_rounded,
            title: 'Core skills',
            color: _pink,
          ),
          const SizedBox(height: 8),
          _ChipWrap(
            profile.skills,
            _pink,
          ),
          const SizedBox(height: 14),
        ],
        if (profile.technologies.isNotEmpty) ...[
          const _GroupTitle(
            icon: Icons.memory_rounded,
            title: 'Technologies & tools',
            color: _cyan,
          ),
          const SizedBox(height: 8),
          _ChipWrap(
            profile.technologies,
            _cyan,
          ),
          const SizedBox(height: 14),
        ],
        if (profile.engineeringConcepts.isNotEmpty) ...[
          const _GroupTitle(
            icon: Icons.account_tree_rounded,
            title: 'Engineering concepts',
            color: _violetBright,
          ),
          const SizedBox(height: 8),
          _ChipWrap(
            profile.engineeringConcepts,
            _violetBright,
          ),
          const SizedBox(height: 14),
        ],
        _EvidenceCard(
          title: profile.sourceLabel,
          message: 'Reference batch last verified: $date.',
          color: _mint,
        ),
      ],
    );
  }
}

class _DynamicSectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const _DynamicSectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 21,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          child,
        ],
      ),
    );
  }
}

class _NotConnectedText extends StatelessWidget {
  final String message;

  const _NotConnectedText(this.message);

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(
        color: _muted,
        fontSize: 10.5,
        height: 1.5,
      ),
    );
  }
}

class _CompensationList extends StatelessWidget {
  final List<CompanyCompensation> items;

  const _CompensationList({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items.take(8))
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _range(item),
                    style: const TextStyle(
                      color: _text,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (item.location != null)
                  Flexible(
                    child: Text(
                      item.location!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 9.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  String _range(CompanyCompensation item) {
    final min = item.minimum;
    final max = item.maximum;
    final currency = item.currency.trim();
    final period = item.period.trim();

    if (min != null && max != null) {
      return '$currency ${min.toStringAsFixed(0)} – '
          '${max.toStringAsFixed(0)} / $period';
    }

    if (min != null) {
      return '$currency ${min.toStringAsFixed(0)}+ / $period';
    }

    return '$currency up to ${max!.toStringAsFixed(0)} / $period';
  }
}

class _LiveJobList extends StatelessWidget {
  final List<NormalizedJobPosting> jobs;

  const _LiveJobList({
    required this.jobs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final job in jobs.take(8))
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 9),
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: _surface2,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: _border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.title,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  [
                    if (job.location != null) job.location!,
                    if (job.workplaceType != null) job.workplaceType!,
                  ].join(' • '),
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 9.5,
                  ),
                ),
                if (job.department != null ||
                    job.team != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    [
                      if (job.department != null) job.department!,
                      if (job.team != null) job.team!,
                    ].join(' • '),
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 9,
                    ),
                  ),
                ],
                if (job.applyUrl != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Apply: ${job.applyUrl}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _cyan,
                      fontSize: 9,
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _GroupTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _GroupTitle({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ChipWrap extends StatelessWidget {
  final List<String> items;
  final Color color;

  const _ChipWrap(
    this.items,
    this.color,
  );

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(.07),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: color.withOpacity(.18),
              ),
            ),
            child: Text(
              item,
              style: TextStyle(
                color: color,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _EvidenceCard extends StatelessWidget {
  final String title;
  final String message;
  final Color color;

  const _EvidenceCard({
    required this.title,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_outlined,
            color: color,
            size: 17,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 9.5,
                    height: 1.45,
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

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Loading normalized company intelligence…',
              style: TextStyle(
                color: _muted,
                fontSize: 10.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}