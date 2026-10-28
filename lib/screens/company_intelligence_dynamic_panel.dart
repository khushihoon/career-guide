import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/home_market_models.dart';
import '../services/company_intelligence_ids.dart';
import '../services/company_intelligence_models.dart';
import '../services/company_intelligence_service.dart';
import '../services/company_intelligence_live_ingestion_service.dart';
import '../services/verified_company_data.dart';
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

/// Opens only a valid HTTPS job/source URL in the external browser.
/// Invalid or unavailable links are reported without breaking the panel.
Future<void> _openOfficialJobUrl(
  BuildContext context,
  String? rawUrl,
) async {
  final value = rawUrl?.trim();
  final uri = value == null ? null : Uri.tryParse(value);
  if (uri == null ||
      uri.scheme.toLowerCase() != 'https' ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This official source link is unavailable.'),
        ),
      );
    }
    return;
  }
  try {
    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open this source link. Please try again.'),
        ),
      );
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open this source link. Please try again.'),
        ),
      );
    }
  }
}

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
/// LIVE TRUTH RULE:
/// Jobs and compensation are rendered as "current" ONLY when the live source
/// was successfully refreshed during this session ([_liveConfirmed]).
/// A snapshot that was merely read from the local cache is a saved snapshot,
/// not proof of current hiring, so it is never listed as a current
/// opportunity and its compensation is never shown.
///
/// Internal verification metadata (for example \\`lastVerified\\`) is intentionally
/// NOT rendered anywhere in this panel.
///
/// SECTION ORDER rendered by this panel (every section is always present;
/// a section without evidence shows an explicit "unavailable" state):
///   1. Skills & technologies      (reference)
///   2. Engineering concepts       (reference)
///   3. Reviewed sources           (reference evidence)
///   4. Salary intelligence        (live only)
///   5. Current opportunities      (live only)
///   6. Data status: reference vs live
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

  /// True only when [_liveSnapshot] was produced by a successful live refresh
  /// in this session. False for cache-only snapshots.
  bool _liveConfirmed = false;
  bool _isRefreshing = false;
  String? _refreshMessage;
  Future<CompanyIntelligenceSnapshot?> _refreshThenReadCache(
    String companyName,
  ) async {
    final stableId = CompanyIntelligenceIds.fromCompanyName(companyName);
    _liveConfirmed = false;
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
        _liveConfirmed = true;
        _refreshMessage = refreshed.hasLiveJobs
            ? 'Live opportunity data updated from the connected source.'
            : 'Connected source returned no current published opportunities.';
        return refreshed;
      }
      _refreshMessage = 'No live source is configured for this company yet.';
    } catch (error) {
      debugPrint(
        'Company Intelligence live refresh failed for '
        '$companyName ($stableId): $error',
      );
      _refreshMessage =
          'Live source is temporarily unavailable. Reference data remains available.';
    }
    // The live source could not be confirmed. A cached snapshot may still
    // exist, but it is only a saved snapshot and is never presented as
    // current hiring.
    final cached = await CompanyIntelligenceDynamicPanel._service
        .cachedCompany(companyName);
    if (cached != null) {
      final savedOn = cached.generatedAt.toIso8601String().split('T').first;
      _refreshMessage =
          '${_refreshMessage ?? 'Live source could not be confirmed right now.'} '
          'A saved snapshot from $savedOn exists, but it is not shown as '
          'current hiring.';
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
      companyProfile: VerifiedCompanyData.find(widget.company.name) ??
          VerifiedCompanyData.find(widget.company.id),
      liveSnapshot: _liveSnapshot,
      liveConfirmed: _liveConfirmed,
      isRefreshing: _isRefreshing,
      refreshMessage: _refreshMessage,
    );
  }
}

class _ReferenceWithLiveOpportunities extends StatelessWidget {
  final VerifiedCompanySkillProfile? profile;
  final VerifiedCompanyProfile? companyProfile;
  final CompanyIntelligenceSnapshot? liveSnapshot;
  final bool liveConfirmed;
  final bool isRefreshing;
  final String? refreshMessage;
  const _ReferenceWithLiveOpportunities({
    required this.profile,
    required this.companyProfile,
    required this.liveSnapshot,
    required this.liveConfirmed,
    required this.isRefreshing,
    required this.refreshMessage,
  });
  @override
  Widget build(BuildContext context) {
    // Only a snapshot confirmed by a successful live refresh may drive
    // "current" content. Cache-only snapshots are treated as saved snapshots.
    final live = liveConfirmed ? liveSnapshot : null;
    final saved = liveConfirmed ? null : liveSnapshot;
    final hasLiveJobs = live?.hasLiveJobs == true;
    // A number without a currency is ambiguous, so such entries are not shown.
    final compensationJobs = live == null
        ? const <NormalizedJobPosting>[]
        : live.liveJobs.where((job) {
            final item = job.compensation;
            if (item == null || !item.hasNumericRange) return false;
            final min = item.minimum;
            final max = item.maximum;
            if ((min != null && (!min.isFinite || min <= 0)) ||
                (max != null && (!max.isFinite || max <= 0))) {
              return false;
            }
            if (min != null && max != null && min > max) return false;
            return item.currency.trim().isNotEmpty;
          }).toList(growable: false);
    final skillProfile = profile;
    final hasSkills = skillProfile != null &&
        (skillProfile.skills.isNotEmpty ||
            skillProfile.technologies.isNotEmpty);
    final hasConcepts =
        skillProfile != null && skillProfile.engineeringConcepts.isNotEmpty;
    final sources = _reviewedSources(companyProfile, skillProfile);
    final hasSources = sources.isNotEmpty;
    final String opportunitiesStatus;
    final Color opportunitiesColor;
    if (hasLiveJobs) {
      opportunitiesStatus = 'LIVE';
      opportunitiesColor = _mint;
    } else if (isRefreshing) {
      opportunitiesStatus = 'CHECKING';
      opportunitiesColor = _muted;
    } else if (saved != null) {
      opportunitiesStatus = 'SAVED, NOT LIVE';
      opportunitiesColor = _amber;
    } else {
      opportunitiesStatus = 'UNAVAILABLE';
      opportunitiesColor = _amber;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DynamicSectionCard(
          icon: Icons.psychology_alt_outlined,
          iconColor: _pink,
          title: 'Skills & technologies',
          child: hasSkills
              ? _ReferenceSkills(profile: skillProfile!)
              : const _NotConnectedText(
                  'Verified company-specific skills and technologies are not available for this company yet. Nothing is guessed.',
                ),
        ),
        const SizedBox(height: 12),
        _DynamicSectionCard(
          icon: Icons.account_tree_rounded,
          iconColor: _violetBright,
          title: 'Engineering concepts',
          child: hasConcepts
              ? _ChipWrap(
                  skillProfile!.engineeringConcepts,
                  _violetBright,
                )
              : const _NotConnectedText(
                  'Verified engineering concepts are not available for this company yet. Nothing is guessed.',
                ),
        ),
        const SizedBox(height: 12),
        _DynamicSectionCard(
          icon: Icons.source_outlined,
          iconColor: _mint,
          title: 'Reviewed sources',
          child: hasSources
              ? _SourceList(items: sources)
              : const _NotConnectedText(
                  'No reviewed official source is recorded for this company yet.',
                ),
        ),
        const SizedBox(height: 12),
        _DynamicSectionCard(
          icon: Icons.payments_outlined,
          iconColor: _amber,
          title: 'Salary intelligence',
          child: compensationJobs.isNotEmpty
              ? _JobCompensationList(jobs: compensationJobs)
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
                  jobs: live!.liveJobs,
                )
              : _NotConnectedText(
                  isRefreshing
                      ? 'Current opportunities are being checked in the background. Reference company data remains available immediately.'
                      : refreshMessage ??
                          'No current published opportunities were returned by the connected source.',
                ),
        ),
        if (live != null) ...[
          const SizedBox(height: 12),
          _EvidenceCard(
            title: 'Live opportunity source',
            message: live.sources.isNotEmpty
                ? '${live.truthLabel}. Last normalized update: '
                    '${live.generatedAt.toIso8601String().split('T').first}.'
                : 'Current opportunity data was returned by the connected source.',
            color: _mint,
          ),
        ] else if (saved != null) ...[
          const SizedBox(height: 12),
          _EvidenceCard(
            title: 'Saved snapshot (not live)',
            message: 'A previously saved snapshot from '
                '${saved.generatedAt.toIso8601String().split('T').first} '
                'exists. It is not shown as current hiring because the live '
                'source could not be confirmed.',
            color: _amber,
          ),
        ],
        const SizedBox(height: 12),
        _DataStatusCard(
          rows: [
            _StatusRow(
              'Skills & technologies',
              hasSkills ? 'REFERENCE' : 'UNAVAILABLE',
              hasSkills ? _cyan : _amber,
            ),
            _StatusRow(
              'Engineering concepts',
              hasConcepts ? 'REFERENCE' : 'UNAVAILABLE',
              hasConcepts ? _cyan : _amber,
            ),
            _StatusRow(
              'Reviewed sources',
              hasSources ? 'REFERENCE' : 'UNAVAILABLE',
              hasSources ? _cyan : _amber,
            ),
            _StatusRow(
              'Salary intelligence',
              compensationJobs.isNotEmpty ? 'LIVE' : 'UNAVAILABLE',
              compensationJobs.isNotEmpty ? _mint : _amber,
            ),
            _StatusRow(
              'Current opportunities',
              opportunitiesStatus,
              opportunitiesColor,
            ),
          ],
        ),
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
    final lastSync = snapshot.generatedAt.toIso8601String().split('T').first;
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
          child: snapshot.liveJobs.any((job) {
            final item = job.compensation;
            return item != null &&
                item.hasNumericRange &&
                item.currency.trim().isNotEmpty &&
                (item.minimum == null ||
                    (item.minimum!.isFinite && item.minimum! > 0)) &&
                (item.maximum == null ||
                    (item.maximum!.isFinite && item.maximum! > 0)) &&
                (item.minimum == null ||
                    item.maximum == null ||
                    item.minimum! <= item.maximum!);
          })
              ? _JobCompensationList(
                  jobs: snapshot.liveJobs.where((job) {
                    final item = job.compensation;
                    return item != null &&
                        item.hasNumericRange &&
                        item.currency.trim().isNotEmpty &&
                        (item.minimum == null ||
                            (item.minimum!.isFinite && item.minimum! > 0)) &&
                        (item.maximum == null ||
                            (item.maximum!.isFinite && item.maximum! > 0)) &&
                        (item.minimum == null ||
                            item.maximum == null ||
                            item.minimum! <= item.maximum!);
                  }).toList(growable: false),
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
          message: '${snapshot.truthLabel}. Last normalized update: $lastSync.',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Skill signals observed in reviewed official company sources. '
          'They are reference information, not a list of current requirements.',
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
          if (profile.technologies.isNotEmpty) const SizedBox(height: 14),
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
        ],
      ],
    );
  }
}

/// One reviewed source line (label + URL).
class _SourceLine {
  final String label;
  final String url;
  const _SourceLine(this.label, this.url);
}

/// Collects the reviewed source URLs available for a company, without
/// duplicates. Nothing is added when no evidence exists.
List<_SourceLine> _reviewedSources(
  VerifiedCompanyProfile? company,
  VerifiedCompanySkillProfile? skills,
) {
  final seen = <String>{};
  final result = <_SourceLine>[];
  void add(String label, String? url) {
    final cleaned = _clean(url);
    if (cleaned == null) return;
    final key = cleaned.toLowerCase().replaceAll(RegExp(r'/+$'), '');
    if (seen.add(key)) {
      result.add(_SourceLine(label, cleaned));
    }
  }

  if (company != null) {
    add('Official website', company.officialWebsite);
    add('Official careers page', company.careersWebsite);
    for (final url in company.sourceUrls) {
      add('Company reference source', url);
    }
  }
  if (skills != null) {
    for (final url in skills.sourceUrls) {
      add('Skills evidence', url);
    }
  }
  return result;
}

class _SourceList extends StatelessWidget {
  final List<_SourceLine> items;
  const _SourceList({
    required this.items,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Text(
            items[i].label.toUpperCase(),
            style: const TextStyle(
              color: _muted,
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 3),
          SelectableText(
            items[i].url,
            style: const TextStyle(
              color: _cyan,
              fontSize: 10,
              height: 1.4,
            ),
          ),
          if (i != items.length - 1) const SizedBox(height: 10),
        ],
        const SizedBox(height: 12),
        const Text(
          'Sources describe the company and its reviewed evidence. '
          'They do not mean the company is hiring now.',
          style: TextStyle(
            color: _muted,
            fontSize: 9.5,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _StatusRow {
  final String label;
  final String status;
  final Color color;
  const _StatusRow(this.label, this.status, this.color);
}

class _DataStatusCard extends StatelessWidget {
  final List<_StatusRow> rows;
  const _DataStatusCard({
    required this.rows,
  });
  @override
  Widget build(BuildContext context) {
    return _DynamicSectionCard(
      icon: Icons.layers_outlined,
      iconColor: _violetBright,
      title: 'Data status: reference vs live',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.label,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: row.color.withOpacity(.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: row.color.withOpacity(.2),
                      ),
                    ),
                    child: Text(
                      row.status,
                      style: TextStyle(
                        color: row.color,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          const Text(
            'Reference information describes the company and never means it '
            'is hiring now. Salary and current opportunities appear only when '
            'a connected live source was confirmed in this session. Missing '
            'data is shown as unavailable and is never guessed.',
            style: TextStyle(
              color: _muted,
              fontSize: 9.5,
              height: 1.5,
            ),
          ),
        ],
      ),
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

/// Returns a trimmed string, or null when the value is null/blank.
///
/// Some provider adapters can supply empty strings instead of null, which
/// must never be rendered as blank UI text.
String? _clean(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}

class _JobCompensationList extends StatelessWidget {
  final List<NormalizedJobPosting> jobs;
  const _JobCompensationList({required this.jobs});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final job in jobs.take(8))
          if (job.compensation != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
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
                    _range(job.compensation!),
                    style: const TextStyle(
                      color: _mint,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (_clean(job.location) != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      _clean(job.location)!,
                      style: const TextStyle(color: _muted, fontSize: 9.5),
                    ),
                  ],
                  if (_clean(job.compensation!.sourceUrl) != null ||
                      _clean(job.sourceUrl) != null) ...[
                    const SizedBox(height: 3),
                    InkWell(
                      onTap: () => _openOfficialJobUrl(
                        context,
                        _clean(job.compensation!.sourceUrl) ??
                            _clean(job.sourceUrl),
                      ),
                      borderRadius: BorderRadius.circular(4),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          'Open salary source ↗',
                          style: TextStyle(
                            color: _cyan,
                            fontSize: 9,
                            height: 1.4,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
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
    final suffix = period.isEmpty ? '' : ' / $period';
    if (min != null && max != null) {
      return '$currency ${min.toStringAsFixed(0)} – '
          '${max.toStringAsFixed(0)}$suffix';
    }
    if (min != null) return '$currency ${min.toStringAsFixed(0)}+$suffix';
    return '$currency up to ${max!.toStringAsFixed(0)}$suffix';
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
        for (final job in jobs.take(8)) _buildJob(job, context),
      ],
    );
  }

  Widget _buildJob(NormalizedJobPosting job, BuildContext context) {
    final placeLine = <String>[
      if (_clean(job.location) != null) _clean(job.location)!,
      if (_clean(job.workplaceType) != null) _clean(job.workplaceType)!,
    ].join(' • ');
    final teamLine = <String>[
      if (_clean(job.department) != null) _clean(job.department)!,
      if (_clean(job.team) != null) _clean(job.team)!,
    ].join(' • ');
    final applyUrl = _clean(job.applyUrl);
    return Container(
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
          if (placeLine.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              placeLine,
              style: const TextStyle(
                color: _muted,
                fontSize: 9.5,
              ),
            ),
          ],
          if (teamLine.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              teamLine,
              style: const TextStyle(
                color: _muted,
                fontSize: 9,
              ),
            ),
          ],
          if (applyUrl != null) ...[
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _openOfficialJobUrl(context, applyUrl),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  'Open official job posting ↗',
                  style: TextStyle(
                    color: _cyan,
                    fontSize: 10,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
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
