// ══════════════════════════════════════════════════════════════════════
// lib/features/copilot/screens/skill_gap_screen.dart
//
// Skill Gap Analysis — reads real SkillGap data from CopilotController.
//
// Architecture boundaries (deliberate):
//  • All progress/gap/readiness data is read from CopilotController.state
//    and CopilotController.copilotContext — nothing is computed here.
//  • "Fix this gap" opens a real actionable sheet. The primary CTA
//    resolves a real TopicCourse for the SELECTED skill, in this order:
//      1) CourseContentData.findByTopic(skillName) — real authored course
//      2) AiCourseService.generateCourse(...) — deterministic generated
//         course, used ONLY when a real authored course isn't available
//         AND the selected career context is known
//    Then opens the existing CourseEngineScreen with that course.
//  • When neither path can safely resolve a course, the sheet shows a
//    clear fallback with a "Refresh Copilot" action — it never silently
//    marks the gap as fixed or fabricates a course.
//  • No Firestore/network calls happen in this file. FirebaseAuth's
//    currentUser is a local, synchronous read, used only to pass `uid`
//    into the existing controller methods that require it.
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/copilot_models.dart';
import '../../models/course_content_data.dart';
import '../../services/copilot_controller.dart';
import '../../services/copilot_provider.dart';
import '../../services/ai_course_service.dart';
import 'skill_profile_screen.dart';
import 'course_engine_screen.dart';

class SkillGapScreen extends StatelessWidget {
  const SkillGapScreen({super.key});

  static const _bg      = Color(0xFF0F0F1A);
  static const _surface = Color(0xFF1A1A2E);
  static const _border  = Color(0xFF2A2A40);
  static const _primary = Color(0xFF7C3AED);
  static const _secondary=Color(0xFFA78BFA);
  static const _muted   = Color(0xFF888899);
  static const _green   = Color(0xFF4ADE80);
  static const _red     = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final ctrl = CopilotProvider.maybeOf(context);

    if (ctrl == null) {
      return Scaffold(
        backgroundColor: _bg,
        body: const Center(
          child: CircularProgressIndicator(color: _primary),
        ),
      );
    }

    final state = ctrl.state;
    final gaps  = state.skillGaps;

    final role = ctrl.copilotContext?.career?.careerTitle ??
        state.skillProfile?.targetRole.label ??
        'Your Role';

    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text('Skill Gap Analysis',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (state.hasProfile && uid != null)
            IconButton(
              tooltip: 'Refresh analysis',
              icon: state.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: _secondary),
                    )
                  : const Icon(Icons.refresh, color: _secondary, size: 20),
              onPressed:
                  state.isLoading ? null : () => ctrl.rerunAnalysis(uid),
            ),
        ],
      ),
      body: _buildBody(context, ctrl, state, gaps, role, uid),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CopilotController ctrl,
    CopilotState state,
    List<SkillGap> gaps,
    String role,
    String? uid,
  ) {
    if (state.isLoading && gaps.isEmpty && !state.hasProfile) {
      return const Center(child: CircularProgressIndicator(color: _primary));
    }

    if (state.error != null && gaps.isEmpty) {
      return _errorState(context, ctrl, state.error!, uid);
    }

    if (!state.hasProfile) {
      return _noProfileState(context);
    }

    if (gaps.isEmpty) {
      return state.isLoading
          ? const Center(child: CircularProgressIndicator(color: _primary))
          : _noGapsState(context, ctrl, uid);
    }

    final readiness = ctrl.copilotContext?.readiness;

    final sortedGaps = [...gaps]
      ..sort((a, b) {
        final byPriority = a.priority.compareTo(b.priority);
        if (byPriority != 0) return byPriority;
        return b.gapScore.compareTo(a.gapScore);
      });

    final grouped = <int, List<SkillGap>>{};
    for (final g in sortedGaps) {
      grouped.putIfAbsent(g.priority, () => []).add(g);
    }
    final priorityOrder = grouped.keys.toList()..sort();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: _headerCard(role, gaps, readiness),
          ).animate().fadeIn(),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        for (final priority in priorityOrder) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionHeader(
                grouped[priority]!.first.priorityLabel,
                grouped[priority]!.length,
                _priorityColor(priority),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final gap = grouped[priority]![i];
                  final mastered = gap.currentLevel != null &&
                      gap.currentLevel!.value >= gap.requiredLevel.value;

                  final card = mastered
                      ? _MasteredGapCard(gap: gap)
                      : _GapCard(
                          gap: gap,
                          onFixThisGap: (uid == null)
                              ? null
                              : () => _showFixGapSheet(
                                    context,
                                    ctrl,
                                    gap,
                                    uid,
                                  ),
                        );

                  return card
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: i * 60))
                      .slideX(begin: 0.05);
                },
                childCount: grouped[priority]!.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Color _priorityColor(int priority) {
    switch (priority) {
      case 1:  return _red;
      case 2:  return const Color(0xFFF59E0B);
      default: return const Color(0xFF6EE7B7);
    }
  }

  Widget _sectionHeader(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          '$label ($count)',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _headerCard(
      String role, List<SkillGap> gaps, CareerReadiness? readiness) {
    final critical  = gaps.where((g) => g.priority == 1).length;
    final important = gaps.where((g) => g.priority == 2).length;
    final nice      = gaps.where((g) => g.priority == 3).length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primary.withOpacity(0.25), _secondary.withOpacity(0.10)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _primary.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.radar, color: Color(0xFFA78BFA), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Gap Analysis for $role',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ],
          ),
          if (readiness != null) ...[
            const SizedBox(height: 6),
            Text(
              'Skill readiness: ${(readiness.skillReadiness * 100).round()}%',
              style: const TextStyle(color: _muted, fontSize: 11),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              _badge('$critical', 'Critical', const Color(0xFFEF4444)),
              const SizedBox(width: 10),
              _badge('$important', 'Important', const Color(0xFFF59E0B)),
              const SizedBox(width: 10),
              _badge('$nice', 'Nice to have', const Color(0xFF6EE7B7)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(count,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(color: color.withOpacity(0.8), fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _noProfileState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.radar, color: Color(0xFF444455), size: 56),
            const SizedBox(height: 16),
            const Text('Analysis not available yet',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text(
              'Set up your skill profile so your Copilot can find real gaps to close.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SkillProfileScreen()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Set up skill profile',
                  style: TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noGapsState(BuildContext context, CopilotController ctrl, String? uid) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: _green, size: 56),
            const SizedBox(height: 16),
            const Text('No open gaps right now',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text(
              "You're meeting the bar on everything your Copilot has checked so far.",
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 20),
            if (uid != null)
              OutlinedButton(
                onPressed: () => ctrl.rerunAnalysis(uid),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _primary),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Re-check for new gaps',
                    style: TextStyle(color: _secondary, fontSize: 13)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _errorState(
      BuildContext context, CopilotController ctrl, String error, String? uid) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: _red, size: 56),
            const SizedBox(height: 16),
            const Text('Couldn\'t load your analysis',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _muted, fontSize: 12, height: 1.4),
            ),
            const SizedBox(height: 20),
            if (uid != null)
              ElevatedButton(
                onPressed: () => ctrl.rerunAnalysis(uid),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Try again',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
              ),
          ],
        ),
      ),
    );
  }

  // ── Fix this gap → actionable career-learning flow ──────────────────

  Future<void> _showFixGapSheet(
    BuildContext context,
    CopilotController ctrl,
    SkillGap gap,
    String uid,
  ) async {
    final ctx = ctrl.copilotContext;
    final pending = ctx?.pendingActions ?? const <NextBestAction>[];

    NextBestAction? matched;
    for (final action in pending) {
      if (action.relatedSkill != null &&
          action.relatedSkill!.toLowerCase() == gap.skillName.toLowerCase()) {
        matched = action;
        break;
      }
    }

    // Snapshot the real career context before opening the sheet. This
    // may be null — the real-course path (CourseContentData.findByTopic)
    // works without it, so a missing career context no longer blocks the
    // primary CTA.
    final careerContext = ctx?.career;

    // Resolve a real authored course for this skill once, up front, so
    // the sheet can immediately show whether a ready-made course exists.
    final realCourse = _resolveRealCourse(gap.skillName);

    if (!context.mounted) return;

    await showModalBottomSheet(
      context: context,
      backgroundColor: _surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => _FixGapSheet(
        gap: gap,
        action: matched,
        careerTitle: careerContext?.careerTitle ??
            ctrl.state.skillProfile?.targetRole.label ??
            'Your Role',
        realCourseTitle: realCourse?.topicTitle,
        hasAnyCoursePath: realCourse != null || careerContext != null,
        onStartLearning: () async {
          // Close the sheet before navigating.
          if (sheetCtx.mounted) Navigator.pop(sheetCtx);
          if (!context.mounted) return;

          TopicCourse? courseToOpen = realCourse;

          // Fallback: if no real authored course exists but we DO have a
          // real career context, use the existing deterministic course
          // generator to build a skill-targeted course.
          if (courseToOpen == null && careerContext != null) {
            try {
              courseToOpen = await AiCourseService.generateCourse(
                careerId: careerContext.careerId,
                careerTitle: careerContext.careerTitle,
                categoryId: careerContext.categoryId,
                level: gap.requiredLevel.value < 1
                    ? 1
                    : gap.requiredLevel.value,
                levelTitle: '${gap.skillName} — ${gap.requiredLevel.label}',
                topics: [gap.skillName],
                difficulty: gap.requiredLevel.label,
              );
            } catch (_) {
              courseToOpen = null;
            }
          }

          if (!context.mounted) return;

          // If we genuinely could not resolve any course, keep the
          // fallback: no navigation, just refresh Copilot.
          if (courseToOpen == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Couldn\'t prepare a course for this gap. '
                  'Try refreshing Copilot.',
                ),
                backgroundColor: Color(0xFFEF4444),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CourseEngineScreen(course: courseToOpen!),
            ),
          );

          // After returning, refresh Copilot intelligence so readiness
          // and next actions reflect the learning flow's saved progress.
          if (!context.mounted) return;
          await ctrl.refreshIntelligence(
            uid,
            careerId: careerContext?.careerId,
          );
        },
        onMarkDone: matched == null
            ? null
            : () async {
                await ctrl.completeNextAction(uid, matched!.id);
                if (sheetCtx.mounted) Navigator.pop(sheetCtx);
              },
        onRefresh: () async {
          await ctrl.refreshIntelligence(uid);
          if (sheetCtx.mounted) Navigator.pop(sheetCtx);
        },
      ),
    );
  }

  /// Looks up a real authored course for [skillName] using the existing
  /// course content database. Returns null when nothing matches — the
  /// caller then decides whether to fall back to generated content or to
  /// the Refresh Copilot path.
  static TopicCourse? _resolveRealCourse(String skillName) {
    if (skillName.trim().isEmpty) return null;
    return CourseContentData.findByTopic(skillName);
  }
}

// ── Fix-this-gap bottom sheet content ─────────────────────────────────

class _FixGapSheet extends StatelessWidget {
  final SkillGap gap;
  final NextBestAction? action;
  final String careerTitle;

  /// Title of a real authored course that matches this skill, when one
  /// exists. Used only for a small informational line — no fabrication.
  final String? realCourseTitle;

  /// True when at least one course path (real authored or generated with
  /// real career context) is available. Drives whether the primary CTA
  /// is shown or the Refresh Copilot fallback is shown.
  final bool hasAnyCoursePath;

  final Future<void> Function() onStartLearning;
  final Future<void> Function()? onMarkDone;
  final Future<void> Function() onRefresh;

  const _FixGapSheet({
    required this.gap,
    required this.action,
    required this.careerTitle,
    required this.realCourseTitle,
    required this.hasAnyCoursePath,
    required this.onStartLearning,
    required this.onMarkDone,
    required this.onRefresh,
  });

  static const _border   = Color(0xFF2A2A40);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);
  static const _green    = Color(0xFF4ADE80);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: _border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Fix: ${gap.skillName}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Career: $careerTitle',
                style: const TextStyle(color: _muted, fontSize: 12),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _primary.withOpacity(0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _kv('Current level',
                        gap.currentLevel?.label ?? 'Not started'),
                    const SizedBox(height: 6),
                    _kv('Target level', gap.requiredLevel.label),
                    const SizedBox(height: 6),
                    _kv(
                      'Gap',
                      '${gap.requiredLevel.value - (gap.currentLevel?.value ?? 0)} level(s)',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              const Text('Why it matters',
                  style: TextStyle(
                      color: _muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3)),
              const SizedBox(height: 4),
              Text(gap.reason,
                  style: const TextStyle(
                      color: Color(0xFFCCCCDD), fontSize: 12, height: 1.4)),

              if (action != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _primary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _primary.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.bolt, color: _secondary, size: 16),
                          SizedBox(width: 6),
                          Text('Your Copilot\'s next action',
                              style: TextStyle(
                                  color: _secondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(action!.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(action!.description,
                          style: const TextStyle(
                              color: _muted, fontSize: 12, height: 1.4)),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 18),

              if (hasAnyCoursePath) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => onStartLearning(),
                    icon: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 18),
                    label: const Text(
                      'Start fixing this gap',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  realCourseTitle != null
                      ? 'Opens the real "$realCourseTitle" course.'
                      : 'Opens a course targeting this skill gap.',
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _border.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Your Copilot needs to refresh your learning path before '
                    'it can open the right course for this skill.',
                    style: TextStyle(
                        color: _muted, fontSize: 12, height: 1.4),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => onRefresh(),
                    icon: const Icon(Icons.refresh,
                        size: 16, color: _secondary),
                    label: const Text(
                      'Refresh Copilot',
                      style: TextStyle(color: _secondary),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],

              if (action != null && onMarkDone != null) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => onMarkDone!(),
                    icon: const Icon(Icons.check,
                        size: 16, color: _green),
                    label: const Text(
                      'Mark Copilot action as done',
                      style: TextStyle(color: _green),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: _green.withOpacity(0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Marks the Copilot action complete — this is not the same '
                  'as mastering the skill.',
                  style: TextStyle(color: _muted, fontSize: 11),
                ),
              ],

              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close',
                      style: TextStyle(color: _muted)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kv(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: _muted, fontSize: 11),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// ── Open gap card ───────────────────────────────────────────────────────

class _GapCard extends StatelessWidget {
  final SkillGap gap;
  final VoidCallback? onFixThisGap;
  const _GapCard({required this.gap, required this.onFixThisGap});

  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);

  Color get _priorityColor {
    switch (gap.priority) {
      case 1:  return const Color(0xFFEF4444);
      case 2:  return const Color(0xFFF59E0B);
      default: return const Color(0xFF6EE7B7);
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelsToClose = gap.requiredLevel.value - (gap.currentLevel?.value ?? 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: _priorityColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(gap.skillName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _priorityColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(gap.priorityLabel,
                    style:
                        TextStyle(color: _priorityColor, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _LevelBar(gap: gap),
          const SizedBox(height: 6),
          Text(
            levelsToClose > 0
                ? 'Gap: $levelsToClose level${levelsToClose > 1 ? 's' : ''} to close'
                : 'Gap: less than one level to close',
            style: const TextStyle(
                color: _secondary, fontSize: 11, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          const Text('Why it matters',
              style: TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3)),
          const SizedBox(height: 2),
          Text(gap.reason,
              style: const TextStyle(
                  color: Color(0xFFCCCCDD), fontSize: 12, height: 1.4)),
          if (onFixThisGap != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onFixThisGap,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: _priorityColor.withOpacity(0.6)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Fix this gap',
                    style: TextStyle(
                        color: _priorityColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Mastered / closed gap card ──────────────────────────────────────────

class _MasteredGapCard extends StatelessWidget {
  final SkillGap gap;
  const _MasteredGapCard({required this.gap});

  static const _surface = Color(0xFF1A1A2E);
  static const _green   = Color(0xFF4ADE80);
  static const _muted   = Color(0xFF888899);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _green.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _green.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: _green, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(gap.skillName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                const SizedBox(height: 2),
                Text(
                  'Mastered — meets the ${gap.requiredLevel.label} bar',
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _green.withOpacity(0.3)),
            ),
            child: const Text('Closed',
                style: TextStyle(color: _green, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _LevelBar extends StatelessWidget {
  final SkillGap gap;
  const _LevelBar({required this.gap});

  @override
  Widget build(BuildContext context) {
    final required = gap.requiredLevel.value;
    final current  = gap.currentLevel?.value ?? 0;
    const max      = 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              gap.isNew
                  ? 'Not started'
                  : 'Current: ${gap.currentLevel!.label}',
              style: const TextStyle(
                  color: Color(0xFF888899), fontSize: 11),
            ),
            Text('Target: ${gap.requiredLevel.label}',
                style: const TextStyle(
                    color: Color(0xFFA78BFA), fontSize: 11)),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFF0F0F20),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            FractionallySizedBox(
              widthFactor: required / max,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            if (current > 0)
              FractionallySizedBox(
                widthFactor: current / max,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}