import 'package:flutter/material.dart';

import '../models/home_market_models.dart';
import '../services/home_market_service.dart';
import '../services/career_company_relationship_service.dart';
import '../services/verified_company_data.dart';
import '../services/verified_company_skills_step6e3.dart';
import 'company_intelligence_dynamic_panel.dart';
import 'career_intelligence_screen.dart';

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

/// Step 6E-4 — Company Intelligence
///
/// This screen is intentionally driven only by data that currently exists in
/// HomeCompany. It does not invent live hiring, salary, roles, or skills.
/// Dynamic normalized source data is connected through the Step 6E-4 engine.
///
/// Step 6E-4 UI contract:
/// - verified_company_data.dart remains the reference company layer;
/// - verified_company_skills_step6e3.dart remains the reviewed reference
///   skill layer;
/// - CompanyIntelligenceDynamicPanel is the normalized source layer;
/// - live opportunities and compensation are displayed only when a normalized
///   source snapshot contains them;
/// - the absence of a snapshot is a valid state and must never be filled by
///   guessed company skills, salary, or hiring claims.
///
/// The screen therefore stays reusable for any company record. Adding a new
/// company does not require adding another screen class. The future backend
/// ingestion worker only needs to publish normalized provider payloads into
/// CompanyIntelligenceRepository.
//
// The UI intentionally does not contain provider-specific parsing logic.
// Greenhouse, Lever, Ashby, SmartRecruiters and future providers are handled
// by services/data adapters outside this screen. This keeps the presentation
// layer stable while the source ecosystem evolves.
//
// The same screen can therefore represent: reference-only company data,
// reviewed observed skill data, current normalized opportunities, and
// verified compensation data without changing its public constructor.
//
// This separation is especially important for a worldwide application because
// companies may use different ATS providers, different currencies, different
// salary disclosure policies, and different publishing schedules.
//
// No UI label in this screen should imply that a company is hiring merely
// because a reference career relationship exists.
//
// No salary figure should be rendered merely because a role normally has a
// salary. A numeric figure must come from a connected source snapshot.
//
// No skill should be rendered as a company requirement merely because the
// company operates in AI, software, data, or another technology area.
// Observed skills come from the normalized evidence pipeline or the explicitly
// labeled verified reference batch.
//

class CompanyIntelligenceScreen extends StatelessWidget {
  static const HomeMarketService _marketService = HomeMarketService();

  static const CareerCompanyRelationshipService _relationshipService =
      CareerCompanyRelationshipService();

  static const VerifiedCompanyDataService _verifiedCompanyService =
      VerifiedCompanyDataService();

  static const VerifiedCompanySkillsService _verifiedSkillsService =
      VerifiedCompanySkillsService();

  final HomeCompany company;

  const CompanyIntelligenceScreen({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    final verified = _verifiedProfile;
    final description = _verifiedDescription;
    final headquarters = _verifiedHeadquarters;
    final engineeringAreas = _verifiedEngineeringAreas;
    final roleFamilies = _verifiedRoleFamilies;
    final verifiedSkills = _verifiedSkillProfile;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: _bg,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                tooltip: 'Back',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: _text,
                ),
              ),
              title: const Text(
                'Company Intelligence',
                style: TextStyle(
                  color: _text,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 30),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _HeroCard(company: company),

                  const SizedBox(height: 14),

                  const _TruthBadge(),

                  if (verified != null) ...[
                    const SizedBox(height: 12),
                    _VerifiedSourceCard(profile: verified),
                  ],

                  const SizedBox(height: 14),

                  _careerLayer(),

                  const SizedBox(height: 12),

                  if (_hasText(description)) ...[
                    _SectionCard(
                      icon: Icons.auto_awesome_rounded,
                      iconColor: _cyan,
                      title: 'What this company does',
                      child: Text(
                        description!.trim(),
                        style: const TextStyle(
                          color: _text,
                          fontSize: 13,
                          height: 1.55,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (company.country != null ||
                      _hasText(headquarters)) ...[
                    _SectionCard(
                      icon: Icons.public_rounded,
                      iconColor: _violetBright,
                      title: 'Company footprint',
                      child: Row(
                        children: [
                          if (_hasText(company.country))
                            Expanded(
                              child: _FactTile(
                                icon: Icons.public_rounded,
                                label: 'COUNTRY',
                                value: company.country!.trim(),
                                color: _cyan,
                              ),
                            ),
                          if (_hasText(company.country) &&
                              _hasText(headquarters))
                            const SizedBox(width: 10),
                          if (_hasText(headquarters))
                            Expanded(
                              child: _FactTile(
                                icon: Icons.location_on_outlined,
                                label: 'HEADQUARTERS',
                                value: headquarters!.trim(),
                                color: _violetBright,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (engineeringAreas.isNotEmpty) ...[
                    _SectionCard(
                      icon: Icons.track_changes_rounded,
                      iconColor: _mint,
                      title: 'Engineering / focus areas',
                      child: _ChipWrap(
                        items: engineeringAreas,
                        color: _mint,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (roleFamilies.isNotEmpty) ...[
                    _SectionCard(
                      icon: Icons.work_outline_rounded,
                      iconColor: _amber,
                      title: 'Notable roles',
                      child: _ChipWrap(
                        items: roleFamilies,
                        color: _amber,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  CompanyIntelligenceDynamicPanel(
                    company: company,
                    verifiedFallback: verifiedSkills,
                  ),

                  const SizedBox(height: 12),

                  _SectionCard(
                    icon: Icons.layers_outlined,
                    iconColor: _violetBright,
                    title: 'Data status',
                    child: const _NotConnectedBlock(
                      message:
                          'Reference company information and reviewed skill '
                          'signals are shown separately from live intelligence. '
                          'Current jobs and compensation appear only when '
                          'supported by a normalized source snapshot.',
                    ),
                  ),

                  const SizedBox(height: 14),

                  const _ReferenceFooter(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _careerLayer() {
    final careers = _relationshipService.careersForCompany(
      company,
      _marketService.getCareers(),
    );

    return _SectionCard(
      icon: Icons.route_rounded,
      iconColor: _mint,
      title: 'Careers connected to this company',
      child: careers.isEmpty
          ? const _NotConnectedBlock(
              message:
                  'No reference career relationship is mapped for this company yet.',
            )
          : Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Reference relationships show career areas where this company can be relevant. They do not mean the company is hiring now.',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 11,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                for (final career in careers) ...[
                  _CareerRelationshipTile(career: career),
                  if (career != careers.last)
                    const SizedBox(height: 8),
                ],
              ],
            ),
    );
  }

  VerifiedCompanyProfile? get _verifiedProfile {
    return _verifiedCompanyService.byCompanyName(company.name);
  }

  VerifiedCompanySkillProfile? get _verifiedSkillProfile {
    return _verifiedSkillsService.byCompanyName(company.name);
  }

  String? get _verifiedDescription {
    return _verifiedProfile?.description ?? company.description;
  }

  String? get _verifiedHeadquarters {
    return _verifiedProfile?.headquarters ?? company.headquarters;
  }

  List<String> get _verifiedEngineeringAreas {
    return _verifiedProfile?.engineeringAreas ?? company.focusAreas;
  }

  List<String> get _verifiedRoleFamilies {
    return _verifiedProfile?.roleFamilies ?? company.notableRoles;
  }

  static bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

class _CareerRelationshipTile extends StatelessWidget {
  final HomeCareer career;

  const _CareerRelationshipTile({
    required this.career,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CareerIntelligenceScreen(
            career: career,
          ),
        ),
      ),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _surface2,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.work_outline_rounded,
              color: _mint,
              size: 19,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                career.title,
                style: const TextStyle(
                  color: _text,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: _muted,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final HomeCompany company;

  const _HeroCard({
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    final logo = company.logo?.trim();

    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _violet.withOpacity(.18),
            _cyan.withOpacity(.08),
            _surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: _surface2,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _border),
            ),
            alignment: Alignment.center,
            child: logo == null || logo.isEmpty
                ? Text(
                    company.name.isEmpty
                        ? '?'
                        : company.name.characters.first.toUpperCase(),
                    style: const TextStyle(
                      color: _text,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                : Text(
                    logo,
                    style: const TextStyle(fontSize: 27),
                  ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'COMPANY INTELLIGENCE',
                  style: TextStyle(
                    color: _cyan,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  company.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 23,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Explore what is currently known about this company.',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 11.5,
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

class _VerifiedSourceCard extends StatelessWidget {
  final VerifiedCompanyProfile profile;

  const _VerifiedSourceCard({
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final verifiedDate =
        profile.lastVerified.toIso8601String().split('T').first;

    return _SectionCard(
      icon: Icons.verified_rounded,
      iconColor: _mint,
      title: 'Verified company reference',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile.sourceLabel,
            style: const TextStyle(
              color: _mint,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Last verified: $verifiedDate',
            style: const TextStyle(
              color: _muted,
              fontSize: 10.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          _VerifiedLinkRow(
            label: 'Official website',
            value: profile.officialWebsite,
          ),
          const SizedBox(height: 8),
          _VerifiedLinkRow(
            label: 'Careers website',
            value: profile.careersWebsite,
          ),
        ],
      ),
    );
  }
}

class _VerifiedLinkRow extends StatelessWidget {
  final String label;
  final String value;

  const _VerifiedLinkRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _surface2,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: _muted,
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _text,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifiedSkillsContent extends StatelessWidget {
  final VerifiedCompanySkillProfile profile;

  const _VerifiedSkillsContent({
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final verifiedDate =
        profile.lastVerified.toIso8601String().split('T').first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Observed in reviewed official company/job sources',
          style: TextStyle(
            color: _muted,
            fontSize: 10.5,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 12),
        if (profile.skills.isNotEmpty) ...[
          const _SkillGroupLabel(
            icon: Icons.code_rounded,
            title: 'Core skills',
            color: _pink,
          ),
          const SizedBox(height: 8),
          _SkillChipWrap(
            items: profile.skills,
            color: _pink,
          ),
          const SizedBox(height: 14),
        ],
        if (profile.technologies.isNotEmpty) ...[
          const _SkillGroupLabel(
            icon: Icons.memory_rounded,
            title: 'Technologies & tools',
            color: _cyan,
          ),
          const SizedBox(height: 8),
          _SkillChipWrap(
            items: profile.technologies,
            color: _cyan,
          ),
          const SizedBox(height: 14),
        ],
        if (profile.engineeringConcepts.isNotEmpty) ...[
          const _SkillGroupLabel(
            icon: Icons.account_tree_rounded,
            title: 'Engineering concepts',
            color: _violetBright,
          ),
          const SizedBox(height: 8),
          _SkillChipWrap(
            items: profile.engineeringConcepts,
            color: _violetBright,
          ),
          const SizedBox(height: 14),
        ],
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _surface2,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.verified_outlined,
                color: _mint,
                size: 17,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  '${profile.sourceLabel}\nLast verified: $verifiedDate',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'These signals describe skills observed in selected reviewed '
          'postings. They are not universal requirements for every role '
          'and do not mean the company is hiring for every listed skill now.',
          style: TextStyle(
            color: _muted,
            fontSize: 9.5,
            height: 1.5,
          ),
        ),
        if (profile.sourceUrls.isNotEmpty) ...[
          const SizedBox(height: 10),
          _VerifiedSourceList(
            sourceUrls: profile.sourceUrls,
          ),
        ],
      ],
    );
  }
}

class _SkillGroupLabel extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SkillGroupLabel({
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

class _SkillChipWrap extends StatelessWidget {
  final List<String> items;
  final Color color;

  const _SkillChipWrap({
    required this.items,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: [
        for (final item in items)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: color.withOpacity(.18),
              ),
            ),
            child: Text(
              item,
              style: TextStyle(
                color: color,
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _VerifiedSourceList extends StatelessWidget {
  final List<String> sourceUrls;

  const _VerifiedSourceList({
    required this.sourceUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _surface2,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.source_outlined,
                color: _muted,
                size: 16,
              ),
              SizedBox(width: 7),
              Text(
                'Reviewed source pages',
                style: TextStyle(
                  color: _text,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < sourceUrls.length; index++) ...[
            Text(
              '${index + 1}. ${sourceUrls[index]}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _muted,
                fontSize: 9,
                height: 1.4,
              ),
            ),
            if (index != sourceUrls.length - 1)
              const SizedBox(height: 5),
          ],
        ],
      ),
    );
  }
}

class _TruthBadge extends StatelessWidget {
  const _TruthBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: _mint.withOpacity(.07),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _mint.withOpacity(.18),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_outlined,
            color: _mint,
            size: 19,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Reference information',
              style: TextStyle(
                color: _mint,
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              'This profile does not mean the company is hiring now.',
              style: TextStyle(
                color: _muted,
                fontSize: 10.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(.09),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: iconColor.withOpacity(.16),
                  ),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
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

class _FactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _FactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _surface2,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: _muted,
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _text,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipWrap extends StatelessWidget {
  final List<String> items;
  final Color color;

  const _ChipWrap({
    required this.items,
    required this.color,
  });

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

class _NotConnectedBlock extends StatelessWidget {
  final String message;

  const _NotConnectedBlock({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _surface2,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _muted,
            size: 18,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: _muted,
                fontSize: 10.5,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferenceFooter extends StatelessWidget {
  const _ReferenceFooter();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      child: Text(
        'Truth rule: reference data is shown as reference data. '
        'Company skill signals are shown only when supported by reviewed '
        'verified sources. Live hiring and salary remain separate verified '
        'data layers.',
        style: TextStyle(
          color: _muted,
          fontSize: 10,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}