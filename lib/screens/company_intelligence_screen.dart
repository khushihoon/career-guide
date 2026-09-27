import 'package:flutter/material.dart';

import '../models/home_market_models.dart';
import '../services/home_market_service.dart';
import '../services/career_company_relationship_service.dart';
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

/// Step 6C — Company Intelligence
///
/// This screen is intentionally driven only by data that currently exists in
/// HomeCompany. It does not invent live hiring, salary, roles, or skills.
/// Those will be connected in later data-layer steps when verified sources
/// are available.
class CompanyIntelligenceScreen extends StatelessWidget {
  static const HomeMarketService _marketService = HomeMarketService();
  static const CareerCompanyRelationshipService _relationshipService =
      CareerCompanyRelationshipService();

  final HomeCompany company;

  const CompanyIntelligenceScreen({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
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
                  _TruthBadge(),
                  const SizedBox(height: 14),
                  _careerLayer(),
                  const SizedBox(height: 12),
                  if (_hasText(company.description)) ...[
                    _SectionCard(
                      icon: Icons.auto_awesome_rounded,
                      iconColor: _cyan,
                      title: 'What this company does',
                      child: Text(
                        company.description!.trim(),
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
                      company.headquarters != null) ...[
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
                              _hasText(company.headquarters))
                            const SizedBox(width: 10),
                          if (_hasText(company.headquarters))
                            Expanded(
                              child: _FactTile(
                                icon: Icons.location_on_outlined,
                                label: 'HEADQUARTERS',
                                value: company.headquarters!.trim(),
                                color: _violetBright,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (company.focusAreas.isNotEmpty) ...[
                    _SectionCard(
                      icon: Icons.track_changes_rounded,
                      iconColor: _mint,
                      title: 'Engineering / focus areas',
                      child: _ChipWrap(
                        items: company.focusAreas,
                        color: _mint,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (company.notableRoles.isNotEmpty) ...[
                    _SectionCard(
                      icon: Icons.work_outline_rounded,
                      iconColor: _amber,
                      title: 'Notable roles',
                      child: _ChipWrap(
                        items: company.notableRoles,
                        color: _amber,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  _SectionCard(
                    icon: Icons.psychology_alt_outlined,
                    iconColor: _pink,
                    title: 'Skills & technologies',
                    child: const _NotConnectedBlock(
                      message:
                          'Company-specific skill requirements are not connected yet. '
                          'They will be added only from verified company/job sources.',
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    icon: Icons.payments_outlined,
                    iconColor: _amber,
                    title: 'Salary intelligence',
                    child: const _NotConnectedBlock(
                      message:
                          'Verified company salary data is not connected yet. '
                          'No salary number is shown here until the source, '
                          'currency, period, and date are verified.',
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    icon: Icons.work_history_outlined,
                    iconColor: _cyan,
                    title: 'Current opportunities',
                    child: const _NotConnectedBlock(
                      message:
                          'Current hiring is not connected yet. '
                          'This company profile must never be interpreted as '
                          'proof that the company is hiring right now.',
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    icon: Icons.link_rounded,
                    iconColor: _violetBright,
                    title: 'Next data connection',
                    child: const _NotConnectedBlock(
                      message:
                          'Verified company careers pages and public job feeds '
                          'will be connected through the market-data layer later. '
                          'The UI is ready for that data without changing the '
                          'company profile architecture.',
                    ),
                  ),
                  const SizedBox(height: 14),
                  _ReferenceFooter(),
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
                    style: TextStyle(color: _muted, fontSize: 11, height: 1.45),
                  ),
                ),
                const SizedBox(height: 10),
                for (final career in careers) ...[
                  _CareerRelationshipTile(career: career),
                  if (career != careers.last) const SizedBox(height: 8),
                ],
              ],
            ),
    );
  }

  static bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

class _CareerRelationshipTile extends StatelessWidget {
  final HomeCareer career;

  const _CareerRelationshipTile({required this.career});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CareerIntelligenceScreen(career: career),
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
            const Icon(Icons.work_outline_rounded, color: _mint, size: 19),
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
            const Icon(Icons.arrow_forward_ios_rounded, color: _muted, size: 14),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final HomeCompany company;

  const _HeroCard({required this.company});

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

class _TruthBadge extends StatelessWidget {
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
          Icon(icon, color: color, size: 18),
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
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      child: Text(
        'Truth rule: reference data is shown as reference data. '
        'Live hiring, salary, and company-specific skill requirements '
        'will be displayed only after verified sources are connected.',
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
