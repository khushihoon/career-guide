// ══════════════════════════════════════════════════════════════════════
// lib/screens/skill_gap_screen.dart
//
// Skill Gap Analysis — reads real SkillGap data from CopilotController.
//
// Architecture boundaries (deliberate):
//  • All progress/gap/readiness data is read from CopilotController.state
//    and CopilotController.copilotContext — nothing is computed here.
//  • "Fix this gap" opens a real actionable sheet. The primary CTA
//    resolves a real TopicCourse for the SELECTED skill, in this order:
//      1) career-scoped match against CourseContentData — the user's
//         selected career first, so the same skill name cannot resolve
//         to a course that belongs to a different career.
//           a) exact topic match within the selected career,
//           b) safe partial topic match within the selected career,
//      2) legacy global CourseContentData.findByTopic(skillName) — only
//         used when no career-scoped match exists,
//      3) AiCourseService.generateCourse(...) — deterministic generated
//         course, used ONLY when a real authored course isn't available
//         AND the selected career context is known.
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


// UI-only presentation tokens.
// CopilotController / SkillGap remain the source of truth.
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

class SkillGapScreen extends StatelessWidget {
  const SkillGapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = CopilotProvider.maybeOf(context);

    if (ctrl == null) {
      return const Scaffold(
        backgroundColor: _bg,
        body: Center(
          child: CircularProgressIndicator(color: _violetBright),
        ),
      );
    }

    final state = ctrl.state;
    final gaps = state.skillGaps;
    final role = ctrl.copilotContext?.career?.careerTitle ??
        state.skillProfile?.targetRole.label ??
        'Your Career';
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Rise Your Skills',
          style: TextStyle(
            color: _text,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
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
                        strokeWidth: 2,
                        color: _violetBright,
                      ),
                    )
                  : const Icon(
                      Icons.refresh_rounded,
                      color: _violetBright,
                      size: 20,
                    ),
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
      return const Center(
        child: CircularProgressIndicator(color: _violetBright),
      );
    }

    if (state.error != null && gaps.isEmpty) {
      return _stateShell(
        icon: Icons.refresh_rounded,
        accent: _amber,
        title: 'Let’s refresh your skill journey',
        message: state.error!,
        buttonLabel: uid == null ? null : 'Try again',
        onPressed: uid == null ? null : () => ctrl.rerunAnalysis(uid),
      );
    }

    if (!state.hasProfile) {
      return _stateShell(
        icon: Icons.auto_awesome_rounded,
        accent: _violetBright,
        title: 'Your skill journey starts here',
        message:
            'Set up your skill profile and let Copilot discover the real gaps on your career path.',
        buttonLabel: 'Build my skill profile',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SkillProfileScreen(),
          ),
        ),
      );
    }

    if (gaps.isEmpty) {
      return state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: _violetBright),
            )
          : _stateShell(
              icon: Icons.emoji_events_rounded,
              accent: _mint,
              title: 'Nothing holding you back right now',
              message:
                  'Your current evidence meets the skill requirements Copilot has checked. Keep growing.',
              buttonLabel: uid == null ? null : 'Re-check my skills',
              onPressed:
                  uid == null ? null : () => ctrl.rerunAnalysis(uid),
            );
    }

    // Real SkillGap data only. The UI does not invent levels, scores or gaps.
    final sorted = [...gaps]
      ..sort((a, b) {
        final priority = a.priority.compareTo(b.priority);
        if (priority != 0) return priority;

        final score = b.gapScore.compareTo(a.gapScore);
        if (score != 0) return score;

        return a.skillName.compareTo(b.skillName);
      });

    final open = sorted
        .where(
          (g) => (g.currentLevel?.value ?? 0) < g.requiredLevel.value,
        )
        .toList();

    final risen = sorted
        .where(
          (g) => (g.currentLevel?.value ?? 0) >= g.requiredLevel.value,
        )
        .toList();

    final nextGap = open.isEmpty ? null : open.first;
    final priority1 =
        sorted.where((g) => g.priority == 1 && _isOpen(g)).toList();
    final priority2 =
        sorted.where((g) => g.priority == 2 && _isOpen(g)).toList();
    final priority3 =
        sorted.where((g) => g.priority >= 3 && _isOpen(g)).toList();

    final readiness = ctrl.copilotContext?.readiness;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
            child: _hero(
              role: role,
              open: open,
              risen: risen,
              readiness: readiness,
              nextGap: nextGap,
            ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.025),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 22)),
        if (priority1.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _section(
                context: context,
                ctrl: ctrl,
                uid: uid,
                title: 'Your Next Skills to Rise',
                subtitle: 'The real gaps closest to your next career level.',
                icon: Icons.local_fire_department_rounded,
                accent: _pink,
                gaps: priority1,
                hero: true,
              ),
            ),
          ),
        if (priority1.isNotEmpty && priority2.isNotEmpty)
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        if (priority2.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _section(
                context: context,
                ctrl: ctrl,
                uid: uid,
                title: 'Build Your Momentum',
                subtitle: 'Real skills to strengthen next.',
                icon: Icons.bolt_rounded,
                accent: _amber,
                gaps: priority2,
              ),
            ),
          ),
        if (priority2.isNotEmpty && priority3.isNotEmpty)
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        if (priority3.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _section(
                context: context,
                ctrl: ctrl,
                uid: uid,
                title: 'Grow Further',
                subtitle: 'Future growth opportunities already found in your path.',
                icon: Icons.spa_rounded,
                accent: _mint,
                gaps: priority3,
              ),
            ),
          ),
        if (risen.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 26, 18, 0),
              child: _risenSection(risen),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  static bool _isOpen(SkillGap gap) =>
      (gap.currentLevel?.value ?? 0) < gap.requiredLevel.value;

  Widget _hero({
    required String role,
    required List<SkillGap> open,
    required List<SkillGap> risen,
    required CareerReadiness? readiness,
    required SkillGap? nextGap,
  }) {
    final readinessPercent =
        readiness == null ? null : (readiness.skillReadiness * 100).round();

    final message = nextGap == null
        ? 'Skill Risen! Keep building your career momentum.'
        : nextGap.currentLevel == null
            ? 'Every strong career starts with one skill. Let’s rise it.'
            : nextGap.gapScore >= 0.66
                ? 'You’re on a great track. Your next level is waiting.'
                : 'You’re building momentum. Keep your journey moving.';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _violet.withOpacity(0.34),
            _surface2,
            _cyan.withOpacity(0.08),
          ],
        ),
        border: Border.all(color: _violet.withOpacity(0.30)),
        boxShadow: [
          BoxShadow(
            color: _violet.withOpacity(0.10),
            blurRadius: 28,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [_violet, _cyan],
                  ),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RISE YOUR SKILLS',
                      style: TextStyle(
                        color: _violetBright,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              height: 1.25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your Copilot is turning real skill evidence into your next growth moves.',
            style: TextStyle(
              color: _muted,
              fontSize: 12,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _statPill('${open.length}', 'skills to rise', _cyan),
              const SizedBox(width: 8),
              _statPill('${risen.length}', 'skills risen', _mint),
              if (readinessPercent != null) ...[
                const SizedBox(width: 8),
                _statPill(
                  '$readinessPercent%',
                  'skill readiness',
                  _violetBright,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _statPill(String value, String label, Color accent) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.045),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent.withOpacity(0.18)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: accent,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _muted,
                fontSize: 9,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required BuildContext context,
    required CopilotController ctrl,
    required String? uid,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accent,
    required List<SkillGap> gaps,
    bool hero = false,
  }) {
    if (gaps.isEmpty) return const SizedBox.shrink();

    Future<void> openGap(SkillGap gap) async {
      if (uid == null) return;
      await _showFixGapSheet(context, ctrl, gap, uid);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: accent.withOpacity(0.25)),
              ),
              child: Icon(icon, color: accent, size: 20),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _text,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$subtitle  •  ${gaps.length} real skill${gaps.length == 1 ? '' : 's'}',
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (hero)
          _HeroSkillCard(
            gap: gaps.first,
            accent: accent,
            onFixThisGap: uid == null ? null : () => openGap(gaps.first),
          )
        else
          ...gaps.map(
            (gap) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ProgressSkillCard(
                gap: gap,
                accent: accent,
                onFixThisGap: uid == null ? null : () => openGap(gap),
              ),
            ),
          ),
        if (hero && gaps.length > 1) ...[
          const SizedBox(height: 10),
          ...gaps.skip(1).map(
                (gap) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ProgressSkillCard(
                    gap: gap,
                    accent: accent,
                    onFixThisGap: uid == null ? null : () => openGap(gap),
                  ),
                ),
              ),
        ],
      ],
    );
  }

  Widget _risenSection(List<SkillGap> risen) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _mint.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _mint.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: _mint,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Skills You’ve Risen',
                      style: TextStyle(
                        color: _text,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Real skills that have reached their required level.',
                      style: TextStyle(color: _muted, fontSize: 10.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: risen.map(
              (gap) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _mint.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _mint.withOpacity(0.18)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: _mint,
                        size: 15,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        gap.skillName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _showFixGapSheet(
    BuildContext context,
    CopilotController ctrl,
    SkillGap gap,
    String uid,
  ) async {
    final ctx = ctrl.copilotContext;
    final pending = ctx?.nextActions ?? const <NextBestAction>[];

    NextBestAction? matched;
    for (final action in pending) {
      if (action.relatedSkill != null &&
          action.relatedSkill!.toLowerCase() == gap.skillName.toLowerCase()) {
        matched = action;
        break;
      }
    }

    final careerContext = ctx?.career;
    final realCourse = _resolveRealCourse(
      gap.skillName,
      careerId: careerContext?.careerId,
    );

    if (!context.mounted) return;

    await showModalBottomSheet(
      context: context,
      backgroundColor: _surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetCtx) => _FixGapSheet(
        gap: gap,
        action: matched,
        careerTitle: careerContext?.careerTitle ??
            ctrl.state.skillProfile?.targetRole.label ??
            'Your Career',
        realCourseTitle: realCourse?.topicTitle,
        hasAnyCoursePath: realCourse != null || careerContext != null,
        onStartLearning: () async {
          if (sheetCtx.mounted) Navigator.pop(sheetCtx);
          if (!context.mounted) return;

          TopicCourse? courseToOpen = realCourse;

          if (courseToOpen == null && careerContext != null) {
            try {
              courseToOpen = await AiCourseService.generateCourse(
                careerId: careerContext.careerId,
                careerTitle: careerContext.careerTitle,
                categoryId: careerContext.categoryId,
                level: gap.requiredLevel.value < 1
                    ? 1
                    : gap.requiredLevel.value,
                levelTitle:
                    '${gap.skillName} — ${gap.requiredLevel.label}',
                topics: [gap.skillName],
                difficulty: gap.requiredLevel.label,
              );
            } catch (_) {
              courseToOpen = null;
            }
          }

          if (!context.mounted) return;

          if (courseToOpen == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Couldn’t prepare a course for this skill. '
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
              builder: (_) => CourseEngineScreen(
                course: courseToOpen!,
              ),
            ),
          );

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

  static TopicCourse? _resolveRealCourse(
    String skillName, {
    String? careerId,
  }) {
    final skill = skillName.trim();
    if (skill.isEmpty) return null;

    if (careerId != null && careerId.isNotEmpty) {
      final careerCourses = CourseContentData.forCareer(careerId);

      if (careerCourses.isNotEmpty) {
        final exact = _findInList(
          careerCourses,
          skill,
          exactOnly: true,
        );
        if (exact != null) return exact;

        final partial = _findInList(
          careerCourses,
          skill,
          exactOnly: false,
        );
        if (partial != null) return partial;
      }
    }

    return CourseContentData.findByTopic(skill);
  }

  static TopicCourse? _findInList(
    List<TopicCourse> courses,
    String skill, {
    required bool exactOnly,
  }) {
    final needle = skill.toLowerCase();

    if (exactOnly) {
      for (final course in courses) {
        if (course.topicTitle.toLowerCase() == needle) {
          return course;
        }
      }
      return null;
    }

    for (final course in courses) {
      final hay = course.topicTitle.toLowerCase();
      if (hay.contains(needle) || needle.contains(hay)) {
        return course;
      }
    }

    return null;
  }

  Widget _stateShell({
    required IconData icon,
    required Color accent,
    required String title,
    required String message,
    required String? buttonLabel,
    required VoidCallback? onPressed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: accent.withOpacity(0.18)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withOpacity(0.10),
                ),
                child: Icon(icon, color: accent, size: 30),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
              if (buttonLabel != null && onPressed != null) ...[
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Text(
                      buttonLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSkillCard extends StatelessWidget {
  final SkillGap gap;
  final Color accent;
  final VoidCallback? onFixThisGap;

  const _HeroSkillCard({
    required this.gap,
    required this.accent,
    required this.onFixThisGap,
  });

  @override
  Widget build(BuildContext context) {
    final current = gap.currentLevel?.value ?? 0;
    final required = gap.requiredLevel.value;
    final progress = (current / 4).clamp(0.0, 1.0);
    final target = (required / 4).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withOpacity(0.18),
            _surface2,
            _bg,
          ],
        ),
        border: Border.all(color: accent.withOpacity(0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SkillIcon(
                skillName: gap.skillName,
                accent: accent,
                large: true,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  gap.skillName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _Badge(
                text: 'NEXT TO RISE',
                color: accent,
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'YOUR SKILL JOURNEY',
            style: TextStyle(
              color: _muted,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.9,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _Milestone(
                  label: 'YOU ARE HERE',
                  value: _friendlyLevel(current),
                  color: _cyan,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: _violetBright,
                  size: 18,
                ),
              ),
              Expanded(
                child: _Milestone(
                  label: 'NEXT MILESTONE',
                  value: _friendlyLevel(required),
                  color: accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _JourneyBar(
            progress: progress,
            target: target,
            accent: accent,
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: _cyan,
                size: 15,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  gap.reason,
                  style: const TextStyle(
                    color: Color(0xFFD2D7E5),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onFixThisGap,
              icon: const Icon(
                Icons.rocket_launch_rounded,
                size: 18,
              ),
              label: const Text(
                'Rise This Skill',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressSkillCard extends StatelessWidget {
  final SkillGap gap;
  final Color accent;
  final VoidCallback? onFixThisGap;

  const _ProgressSkillCard({
    required this.gap,
    required this.accent,
    required this.onFixThisGap,
  });

  @override
  Widget build(BuildContext context) {
    final current = gap.currentLevel?.value ?? 0;
    final required = gap.requiredLevel.value;
    final progress = (current / 4).clamp(0.0, 1.0);
    final target = (required / 4).clamp(0.0, 1.0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onFixThisGap,
        borderRadius: BorderRadius.circular(19),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: accent.withOpacity(0.14)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _SkillIcon(
                    skillName: gap.skillName,
                    accent: accent,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gap.skillName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${_friendlyLevel(current)}  →  ${_friendlyLevel(required)}',
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: accent.withOpacity(0.8),
                    size: 14,
                  ),
                ],
              ),
              const SizedBox(height: 11),
              _JourneyBar(
                progress: progress,
                target: target,
                accent: accent,
                height: 5,
              ),
              const SizedBox(height: 9),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    color: accent,
                    size: 14,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      gap.reason,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 10,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Rise →',
                    style: TextStyle(
                      color: accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillIcon extends StatelessWidget {
  final String skillName;
  final Color accent;
  final bool large;

  const _SkillIcon({
    required this.skillName,
    required this.accent,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = large ? 48.0 : 38.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(large ? 16 : 13),
        gradient: LinearGradient(
          colors: [
            accent.withOpacity(0.22),
            _violet.withOpacity(0.10),
          ],
        ),
        border: Border.all(color: accent.withOpacity(0.22)),
      ),
      child: Icon(
        _iconFor(skillName),
        color: accent,
        size: large ? 24 : 19,
      ),
    );
  }

  static IconData _iconFor(String skill) {
    final s = skill.toLowerCase();

    if (s.contains('python')) return Icons.code_rounded;
    if (s.contains('sql') || s.contains('database')) {
      return Icons.storage_rounded;
    }
    if (s.contains('machine learning') || s == 'ml') {
      return Icons.auto_graph_rounded;
    }
    if (s.contains('deep learning')) return Icons.hub_rounded;
    if (s.contains('llm') || s.contains('rag') || s.contains('prompt')) {
      return Icons.psychology_rounded;
    }
    if (s.contains('git')) return Icons.account_tree_rounded;
    if (s.contains('testing')) return Icons.fact_check_rounded;
    if (s.contains('api')) return Icons.api_rounded;
    if (s.contains('system design')) return Icons.architecture_rounded;
    if (s.contains('statistics')) return Icons.bar_chart_rounded;
    if (s.contains('visual')) return Icons.insights_rounded;
    if (s.contains('transformer')) return Icons.transform_rounded;
    if (s.contains('mlops')) return Icons.settings_suggest_rounded;

    return Icons.auto_awesome_rounded;
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.20)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _Milestone extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _Milestone({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.035),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 7.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyBar extends StatelessWidget {
  final double progress;
  final double target;
  final Color accent;
  final double height;

  const _JourneyBar({
    required this.progress,
    required this.target,
    required this.accent,
    this.height = 7,
  });

  @override
  Widget build(BuildContext context) {
    final p = progress.clamp(0.0, 1.0).toDouble();
    final t = target.clamp(0.0, 1.0).toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: height + 8,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: height,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  color: const Color(0xFF080B14),
                  borderRadius: BorderRadius.circular(height),
                ),
              ),
              FractionallySizedBox(
                widthFactor: t,
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(height),
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: p,
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accent, _violetBright],
                    ),
                    borderRadius: BorderRadius.circular(height),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String _friendlyLevel(int value) {
  switch (value) {
    case 0:
      return 'Starting Out';
    case 1:
      return 'Building';
    case 2:
      return 'Growing Strong';
    case 3:
      return 'Highly Skilled';
    default:
      return 'Mastery';
  }
}

class _FixGapSheet extends StatelessWidget {
  final SkillGap gap;
  final NextBestAction? action;
  final String careerTitle;
  final String? realCourseTitle;
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

  @override
  Widget build(BuildContext context) {
    final current = gap.currentLevel?.value ?? 0;
    final required = gap.requiredLevel.value;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: _border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [_violet, _cyan],
                      ),
                    ),
                    child: const Icon(
                      Icons.rocket_launch_rounded,
                      color: Colors.white,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'RISE THIS SKILL',
                          style: TextStyle(
                            color: _cyan,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          gap.skillName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                careerTitle,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: _surface2,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _violet.withOpacity(0.18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'YOUR NEXT MILESTONE',
                      style: TextStyle(
                        color: _violetBright,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _levelBox(
                            'YOU ARE HERE',
                            _friendlyLevel(current),
                            _cyan,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: _violetBright,
                            size: 18,
                          ),
                        ),
                        Expanded(
                          child: _levelBox(
                            'NEXT',
                            _friendlyLevel(required),
                            _violetBright,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    _JourneyBar(
                      progress: (current / 4).clamp(0.0, 1.0),
                      target: (required / 4).clamp(0.0, 1.0),
                      accent: _violet,
                      height: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'WHY THIS SKILL MATTERS',
                style: TextStyle(
                  color: _muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                gap.reason,
                style: const TextStyle(
                  color: Color(0xFFD2D7E5),
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
              if (action != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _cyan.withOpacity(0.055),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _cyan.withOpacity(0.14),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            color: _cyan,
                            size: 15,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'YOUR COPILOT’S NEXT MOVE',
                            style: TextStyle(
                              color: _cyan,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        action!.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        action!.description,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 18),
              if (hasAnyCoursePath) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onStartLearning,
                    icon: const Icon(
                      Icons.rocket_launch_rounded,
                      size: 18,
                    ),
                    label: const Text(
                      'Rise This Skill',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _violet,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    realCourseTitle != null
                        ? 'Opens the real "$realCourseTitle" course.'
                        : 'Opens a course targeting this real skill gap.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 10,
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _surface2,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Your Copilot needs to refresh your learning path before it can open the right course for this skill.',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onRefresh,
                    icon: const Icon(
                      Icons.refresh_rounded,
                      size: 16,
                    ),
                    label: const Text('Refresh Copilot'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _violetBright,
                      side: BorderSide(
                        color: _violet.withOpacity(0.55),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
              ],
              if (action != null && onMarkDone != null) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onMarkDone,
                    icon: const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: _mint,
                    ),
                    label: const Text(
                      'Mark Copilot action as done',
                      style: TextStyle(color: _mint),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _mint.withOpacity(0.35),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Center(
                  child: Text(
                    'Completing this action is not the same as mastering the skill.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _muted,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: _muted),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _levelBox(
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.035),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 7,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StateShell extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String title;
  final String message;
  final String? buttonLabel;
  final VoidCallback? onPressed;

  const _StateShell({
    required this.icon,
    required this.accent,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: accent.withOpacity(0.18)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withOpacity(0.10),
                ),
                child: Icon(icon, color: accent, size: 30),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
              if (buttonLabel != null && onPressed != null) ...[
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Text(
                      buttonLabel!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
