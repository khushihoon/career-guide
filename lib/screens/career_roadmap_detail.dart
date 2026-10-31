// ══════════════════════════════════════════════════════════════════════
// lib/screens/career_roadmap_detail.dart
//
// Per-career roadmap screen.
// Uses IDENTICAL _CareerPhaseCard UI to the existing _PhaseCard in
// roadmap_screen.dart so the experience is 100% consistent.
//
// SharedPrefs key pattern: career_{careerId}_phase_{phaseId}
// This NEVER collides with existing phase_v2_X keys.
//
// Zero changes to roadmap_screen.dart internals.
// Zero changes to models.dart, firebase_service, navigation.
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'career_roadmap_hub.dart';
import 'copilot_hub_screen.dart'; // existing Career Copilot screen
import '../widgets/resource_card.dart'; // ← interactive resource cards

class CareerRoadmapDetail extends StatefulWidget {
  final CareerData career;
  final Color catColor;

  const CareerRoadmapDetail({
    super.key,
    required this.career,
    required this.catColor,
  });

  @override
  State<CareerRoadmapDetail> createState() => _CareerRoadmapDetailState();
}

class _CareerRoadmapDetailState extends State<CareerRoadmapDetail> {
  // ── Design tokens (match whole app) ─────────────────────────────────
  static const _bg = Color(0xFF0F0F1A);
  static const _surface = Color(0xFF1A1A2E);
  static const _border = Color(0xFF2A2A40);
  static const _primary = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted = Color(0xFF888899);

  // Progress state — parallel to _phases list
  late List<bool> _done;

  @override
  void initState() {
    super.initState();
    _done = List.filled(widget.career.phases.length, false);
    _loadProgress();
  }

  // ── SharedPrefs with career-scoped keys ──────────────────────────────
  String _key(int phaseId) => 'career_${widget.career.id}_phase_$phaseId';

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < widget.career.phases.length; i++) {
        _done[i] = prefs.getBool(_key(widget.career.phases[i].id)) ?? false;
      }
    });
  }

  Future<void> _toggle(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final phase = widget.career.phases[index];
    final newVal = !_done[index];
    setState(() => _done[index] = newVal);
    await prefs.setBool(_key(phase.id), newVal);
  }

  int get _doneCount => _done.where((d) => d).length;
  double get _progress => widget.career.phases.isEmpty
      ? 0
      : _doneCount / widget.career.phases.length;

  @override
  Widget build(BuildContext context) {
    final career = widget.career;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App bar ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _border),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(career.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ]),
              ),
            ),

            // ── Hero header ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Career icon + meta row
                    Row(children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: widget.catColor.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: widget.catColor.withOpacity(0.35)),
                        ),
                        child: Center(
                          child: Text(career.emoji,
                              style: const TextStyle(fontSize: 28)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(career.tagline,
                                style: const TextStyle(
                                    color: _muted, fontSize: 13, height: 1.3)),
                            const SizedBox(height: 6),
                            Row(children: [
                              _metaChip(career.level, widget.catColor),
                              const SizedBox(width: 6),
                              _metaChip('${career.phases.length} phases',
                                  const Color(0xFF60A5FA)),
                            ]),
                          ],
                        ),
                      ),
                    ]).animate().fadeIn(delay: 60.ms),

                    const SizedBox(height: 14),

                    // Progress bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(
                            '$_doneCount/${career.phases.length} phases completed',
                            style: const TextStyle(color: _muted, fontSize: 12),
                          ),
                          const Spacer(),
                          Text(
                            '${(_progress * 100).toInt()}%',
                            style: TextStyle(
                              color: _progress == 1
                                  ? const Color(0xFF4ADE80)
                                  : widget.catColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: _progress,
                            minHeight: 8,
                            backgroundColor: _border,
                            valueColor: AlwaysStoppedAnimation(
                              _progress == 1
                                  ? const Color(0xFF4ADE80)
                                  : widget.catColor,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 100.ms),

                    const SizedBox(height: 14),

                    // Top skills row
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: career.skills
                          .map(
                            (s) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _primary.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: _primary.withOpacity(0.25)),
                              ),
                              child: Text(s,
                                  style: const TextStyle(
                                      color: _secondary, fontSize: 11)),
                            ),
                          )
                          .toList(),
                    ).animate().fadeIn(delay: 130.ms),

                    const SizedBox(height: 18),

                    // "Learning Path" section label
                    const Text('Your Learning Path',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )).animate().fadeIn(delay: 150.ms),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // ── Phase list ─────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    return Column(
                      children: [
                        _CareerPhaseCard(
                          phase: career.phases[i],
                          index: i,
                          isDone: _done[i],
                          catColor: widget.catColor,
                          onToggle: () => _toggle(i),
                        )
                            .animate()
                            .fadeIn(delay: Duration(milliseconds: 170 + i * 45))
                            .slideY(begin: 0.08, duration: 280.ms),
                        if (i < career.phases.length - 1)
                          Center(
                            child: Container(
                              width: 2,
                              height: 16,
                              color: _done[i]
                                  ? widget.catColor.withOpacity(0.5)
                                  : _border,
                            ),
                          ),
                      ],
                    );
                  },
                  childCount: career.phases.length,
                ),
              ),
            ),

            // ── Completion banner ──────────────────────────────────────
            if (_doneCount == career.phases.length && career.phases.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: _CompletionBanner(career: career),
                ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 48)),
          ],
        ),
      ),
    );
  }

  Widget _metaChip(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(label,
            style: TextStyle(
                color: color, fontSize: 10, fontWeight: FontWeight.w600)),
      );
}

// ══════════════════════════════════════════════════════════════════════
// PHASE CARD — identical design language to existing _PhaseCard
// ══════════════════════════════════════════════════════════════════════

class _CareerPhaseCard extends StatefulWidget {
  final CareerPhase phase;
  final int index;
  final bool isDone;
  final Color catColor;
  final VoidCallback onToggle;

  const _CareerPhaseCard({
    required this.phase,
    required this.index,
    required this.isDone,
    required this.catColor,
    required this.onToggle,
  });

  @override
  State<_CareerPhaseCard> createState() => _CareerPhaseCardState();
}

class _CareerPhaseCardState extends State<_CareerPhaseCard> {
  bool _expanded = false;

  static const _surface = Color(0xFF1A1A2E);
  static const _border = Color(0xFF2A2A40);
  static const _primary = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted = Color(0xFF888899);

  @override
  Widget build(BuildContext context) {
    final p = widget.phase;
    final done = widget.isDone;
    final catColor = widget.catColor;
    final lvColor = Color(int.parse('FF${p.levelColor}', radix: 16));

    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: done ? catColor.withOpacity(0.5) : _border,
          width: done ? 1.5 : 1,
        ),
      ),
      child: Column(children: [
        // ── Header ───────────────────────────────────────────────────
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              // Number / check circle
              GestureDetector(
                onTap: widget.onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: done ? catColor : const Color(0xFF0F0F20),
                    shape: BoxShape.circle,
                    border: Border.all(color: done ? catColor : _border),
                    boxShadow: done
                        ? [
                            BoxShadow(
                                color: catColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 1)
                          ]
                        : [],
                  ),
                  child: Center(
                    child: done
                        ? const Icon(Icons.check, size: 20, color: Colors.white)
                        : Text('${widget.index + 1}',
                            style: const TextStyle(
                                color: _muted,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title / subtitle / chips
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.title,
                        style: TextStyle(
                          color: done ? catColor : Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 2),
                    Text(p.subtitle,
                        style: const TextStyle(color: _muted, fontSize: 12)),
                    const SizedBox(height: 5),
                    Row(children: [
                      _chip(p.duration, const Color(0xFF60A5FA)),
                      const SizedBox(width: 6),
                      _chip(p.level, lvColor),
                    ]),
                  ],
                ),
              ),

              // Expand arrow
              Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: _muted,
                size: 22,
              ),
            ]),
          ),
        ),

        // ── Expanded body ─────────────────────────────────────────────
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: catColor.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: catColor.withOpacity(0.28)),
                  ),
                  child: Row(children: [
                    const Text('💰 ', style: TextStyle(fontSize: 14)),
                    const Text('Salary after this phase: ',
                        style: TextStyle(color: _muted, fontSize: 12)),
                    Flexible(
                      child: Text(p.salaryUnlock,
                          style: TextStyle(
                              color: catColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  ]),
                ),

                const SizedBox(height: 14),

                // Topics
                _sectionLabel('📋 Topics'),
                const SizedBox(height: 8),
                ...p.topics.map((t) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('  • ',
                              style: TextStyle(color: catColor, fontSize: 13)),
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
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1A0F),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF1A3A1A)),
                  ),
                  child: Text(p.project,
                      style: const TextStyle(
                          color: Color(0xFF6EE7B7), fontSize: 13, height: 1.4)),
                ),

                const SizedBox(height: 14),

                // Resources
                _sectionLabel('📚 Resources'),
                const SizedBox(height: 8),
                ResourceCardList(resources: p.resources),

                const SizedBox(height: 14),

                // Continue with Copilot — same action on every career roadmap phase.
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CopilotHubScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.smart_toy_rounded, size: 18),
                    label: const Text('Continue with Copilot'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: _primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),                
              ],
            ),
          ),
        ],
      ]),
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

// ══════════════════════════════════════════════════════════════════════
// COMPLETION BANNER
// ══════════════════════════════════════════════════════════════════════

class _CompletionBanner extends StatelessWidget {
  final CareerData career;
  const _CompletionBanner({required this.career});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4ADE80).withOpacity(0.18),
            const Color(0xFF7C3AED).withOpacity(0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color(0xFF4ADE80).withOpacity(0.4), width: 1.5),
      ),
      child: Column(children: [
        const Text('🎉', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 10),
        Text(
          '${career.title} Roadmap Complete!',
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'You\'ve completed every phase.\nTime to apply what you\'ve learned — build a project, update your LinkedIn, and start applying!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF888899), fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFF4ADE80).withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: const Color(0xFF4ADE80).withOpacity(0.35)),
          ),
          child: const Text(
            '✅ Roadmap Completed',
            style: TextStyle(
                color: Color(0xFF4ADE80),
                fontWeight: FontWeight.w600,
                fontSize: 13),
          ),
        ),
      ]),
    );
  }
}
