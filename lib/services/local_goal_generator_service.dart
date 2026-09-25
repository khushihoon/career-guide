// lib/services/local_goal_generator_service.dart
//
// PRODUCTION V2 — Decision-driven, career-scoped, offline.
//
// This service converts CareerGoalEngine decisions into DailyGoal records.
// It does not own readiness, XP, skill mastery, or historical evidence.
// XP is only copied from the authored goal difficulty as a display/reward
// hint; authoritative XP remains with the existing completion/evidence flow.
//
// ──────────────────────────────────────────────────────────────────────
// PHASE 3 FIX — RECENT-TEMPLATE ANTI-REPETITION (this revision)
// ──────────────────────────────────────────────────────────────────────
// PROBLEM FOUND:
//   CareerGoalEngine.decideDaily() already implements real anti-
//   repetition logic keyed on `recentGoalIds` / `completedGoalIds` (a
//   template whose id appears in either set is skipped entirely). But
//   this service's call into decideDaily() always passed empty defaults
//   for both — only `recentSkillNames` was actually being populated
//   (via the existing _readRecentSkills/_rememberRecentSkills pair).
//   Since scoring inputs (level, roadmap phase, skill gaps) often don't
//   change day to day, the same top-scoring template could legitimately
//   get re-picked on consecutive generation days, which is exactly the
//   "random repetition / already completed goals" failure mode the
//   product contract explicitly calls out.
//
// FIX APPLIED:
//   The exact same local-tracking pattern already used for recent
//   skills is now ALSO applied to template ids: a rolling window of the
//   most recently generated GoalTemplate ids is persisted locally
//   (SharedPreferences, per uid+career — no new database, no Firestore
//   collection, no new architecture) and fed into decideDaily() as
//   `recentGoalIds`. The engine's existing skip-if-recent logic now
//   actually has real data to act on.
//
// SCOPE NOTE:
//   `completedGoalIds` remains intentionally NOT populated from
//   Firestore evidence in this pass. Doing so would require correlating
//   DailyGoal.id (which embeds the template id as a substring) back
//   against the full completion history via a new Firestore query on
//   every generation — meaningfully heavier, and arguably a second
//   progress-tracking mechanism layered on top of the existing one.
//   The local recentGoalIds window already solves the practical
//   repetition problem (a template cannot resurface for several days
//   after being shown) without that added weight — consistent with the
//   "do not overengineer" principle. This is a deliberate, documented
//   scope boundary, not an oversight.
// ──────────────────────────────────────────────────────────────────────

import 'package:shared_preferences/shared_preferences.dart';
import '../models/copilot_models.dart';
import 'career_goal_engine.dart';
import 'goal_content_database.dart';

class LocalGoalGeneratorService {
  final CareerGoalEngine _engine;

  /// How many recently-shown template ids to remember before the oldest
  /// entries roll off. Sized generously above a typical 4-goals/day cap
  /// so a template stays "recent" for several days, not just one.
  static const int _recentTemplateWindow = 24;

  const LocalGoalGeneratorService({CareerGoalEngine engine = const CareerGoalEngine()})
      : _engine = engine;

  Future<List<DailyGoal>> generateAndSaveDailyGoals({
    required String uid,
    required String targetRole,
    required List<String> currentSkills,
    required int currentStreak,
    required int currentLevel,
    required int roadmapPhase,
    required List<DailyGoal> existingGoals,
    String? careerId,
    CopilotContext? context,
    String? preferredSkill,
    Set<String> completedGoalIds = const {},
    Set<String> recentGoalIds = const {},
  }) async {
    if (existingGoals.isNotEmpty) return existingGoals;

    final prefs = await SharedPreferences.getInstance();
    final todayKey = _todayDateKey();
    final prefKey = _generationKey(uid, careerId, todayKey);

    // Generation guard is only a local duplicate-prevention optimisation.
    // Firestore remains the source of truth for today's goals.
    if (prefs.getBool(prefKey) == true) return existingGoals;

    final profile = context?.state.skillProfile;
    final career = _careerFromRole(targetRole);
    final effectiveCareer = profile?.targetRole ?? career;

    final recentSkillNames = <String>{
      ..._readRecentSkills(prefs, uid, careerId),
    };

    // PHASE 3 FIX: feed the engine's existing recentGoalIds parameter
    // from real local history instead of leaving it permanently empty.
    // Any ids the caller explicitly supplies are honoured too (unioned),
    // so a future caller with real Firestore-backed completion evidence
    // can still participate without this service needing to change.
    final effectiveRecentGoalIds = <String>{
      ...recentGoalIds,
      ..._readRecentTemplateIds(prefs, uid, careerId),
    };

    final decision = _engine.decideDaily(
      career: effectiveCareer,
      profile: profile,
      skillGaps: context?.state.skillGaps ?? const <SkillGap>[],
      context: context,
      preferredSkill: preferredSkill,
      currentLevel: currentLevel,
      roadmapPhase: roadmapPhase,
      completedGoalIds: completedGoalIds,
      recentGoalIds: effectiveRecentGoalIds,
      recentSkillNames: recentSkillNames,
      maxGoals: 4,
    );

    // Safe compatibility fallback for legacy callers that do not yet provide
    // CopilotContext/skill gaps. It still uses authored career content and
    // avoids random shuffling as the primary behaviour.
    final templates = decision.templates.isNotEmpty
        ? decision.templates
        : _fallbackTemplates(
            effectiveCareer,
            currentLevel,
            roadmapPhase,
            recentSkillNames,
          );

    final goals = <DailyGoal>[];
    for (var i = 0; i < templates.length; i++) {
      final template = templates[i];
      final linkedSkill = template.skill ?? _inferSkill(template);
      goals.add(
        DailyGoal(
          id: '${_safeCareerId(careerId ?? effectiveCareer.name)}_${template.id}_${todayKey}_$i',
          uid: uid,
          title: _friendlyTitle(template, i, decision.focusSkill),
          category: _mapCategory(template.category),
          date: todayKey,
          isCompleted: false,
          xpReward: template.xp,
          linkedSkill: linkedSkill,
        ),
      );
    }

    await _rememberRecentSkills(
      prefs,
      uid,
      careerId,
      goals.map((g) => g.linkedSkill).whereType<String>(),
    );
    // PHASE 3 FIX: remember today's picked template ids so tomorrow's
    // (and the following days') generation can skip them via
    // recentGoalIds, closing the loop the engine already supported.
    await _rememberRecentTemplateIds(
      prefs,
      uid,
      careerId,
      templates.map((t) => t.id),
    );
    await prefs.setBool(prefKey, true);
    return goals;
  }

  Future<List<DailyGoal>> generateWeeklyGoals({
    required String uid,
    required String targetRole,
    required int currentLevel,
    required int roadmapPhase,
    List<String> currentSkills = const [],
    String? careerId,
  }) async {
    return _generatePeriodGoals(
      uid: uid,
      targetRole: targetRole,
      currentLevel: currentLevel,
      roadmapPhase: roadmapPhase,
      currentSkills: currentSkills,
      careerId: careerId,
      periodKey: _weekKey(DateTime.now()),
      count: 3,
      baseXp: 150,
    );
  }

  Future<List<DailyGoal>> generateMonthlyGoals({
    required String uid,
    required String targetRole,
    required int currentLevel,
    required int roadmapPhase,
    List<String> currentSkills = const [],
    String? careerId,
  }) async {
    return _generatePeriodGoals(
      uid: uid,
      targetRole: targetRole,
      currentLevel: currentLevel,
      roadmapPhase: roadmapPhase,
      currentSkills: currentSkills,
      careerId: careerId,
      periodKey: _monthKey(DateTime.now()),
      count: 2,
      baseXp: 400,
    );
  }

  Future<List<DailyGoal>> _generatePeriodGoals({
    required String uid,
    required String targetRole,
    required int currentLevel,
    required int roadmapPhase,
    required List<String> currentSkills,
    required String? careerId,
    required String periodKey,
    required int count,
    required int baseXp,
  }) async {
    final pool = GoalContentDatabase.dailyForRole(targetRole)
        .where((t) => t.minLevel <= currentLevel && t.minPhase <= roadmapPhase)
        .toList();
    final source = pool.isNotEmpty
        ? pool
        : GoalContentDatabase.dailyForRole(targetRole);

    final known = currentSkills.map(_key).toSet();
    source.sort((a, b) {
      final aSkill = a.skill == null ? '' : _key(a.skill!);
      final bSkill = b.skill == null ? '' : _key(b.skill!);
      final aGap = aSkill.isNotEmpty && !known.contains(aSkill) ? 0 : 1;
      final bGap = bSkill.isNotEmpty && !known.contains(bSkill) ? 0 : 1;
      return aGap.compareTo(bGap);
    });

    return source.take(count).toList().asMap().entries.map((entry) {
      final t = entry.value;
      return DailyGoal(
        id: '${_safeCareerId(careerId ?? targetRole)}_${t.id}_${periodKey}_${entry.key}',
        uid: uid,
        title: t.title,
        category: _mapCategory(t.category),
        date: periodKey,
        isCompleted: false,
        xpReward: baseXp,
        linkedSkill: t.skill ?? _inferSkill(t),
      );
    }).toList();
  }

  CareerGoal _careerFromRole(String role) {
    final normal = role.toLowerCase().trim();
    for (final career in CareerGoal.values) {
      if (career.label.toLowerCase() == normal || career.name == normal) {
        return career;
      }
    }
    if (normal.contains('machine learning')) return CareerGoal.mlEngineer;
    if (normal.contains('data')) return CareerGoal.dataScientist;
    if (normal.contains('computer vision')) return CareerGoal.cvEngineer;
    if (normal.contains('nlp')) return CareerGoal.nlpEngineer;
    if (normal.contains('prompt')) return CareerGoal.promptEngineer;
    if (normal.contains('research')) return CareerGoal.aiResearcher;
    if (normal.contains('product')) return CareerGoal.aiProductManager;
    if (normal.contains('software')) return CareerGoal.softwareEngineer;
    return CareerGoal.aiEngineer;
  }

  List<GoalTemplate> _fallbackTemplates(
    CareerGoal career,
    int level,
    int phase,
    Set<String> recentSkills,
  ) {
    final pool = GoalContentDatabase.dailyForRole(career.label);
    final eligible = pool.where((t) =>
        t.minLevel <= level && t.minPhase <= phase).toList();
    final source = eligible.isNotEmpty ? eligible : pool;
    source.sort((a, b) {
      final ar = recentSkills.contains(_key(a.skill ?? _inferSkill(a) ?? '')) ? 1 : 0;
      final br = recentSkills.contains(_key(b.skill ?? _inferSkill(b) ?? '')) ? 1 : 0;
      return ar.compareTo(br);
    });
    return source.take(4).toList();
  }

  String _friendlyTitle(GoalTemplate template, int index, String? focusSkill) {
    final title = template.title.trim();
    if (index == 0 && focusSkill != null &&
        (template.skill ?? '').trim().isNotEmpty) {
      return '🎯 Focus: ${template.skill} — $title';
    }
    if (index == 0) return '🌱 Start small — $title';
    if (index == 1) return '🧠 Practice — $title';
    if (index == 2) return '🛠 Build it — $title';
    return '✨ Make it real — $title';
  }

  GoalCategory _mapCategory(LocalGoalCategory category) {
    switch (category) {
      case LocalGoalCategory.learning:
      case LocalGoalCategory.reading:
        return GoalCategory.learning;
      case LocalGoalCategory.practice:
      case LocalGoalCategory.coding:
      case LocalGoalCategory.review:
      case LocalGoalCategory.data:
      case LocalGoalCategory.design:
        return GoalCategory.practice;
      case LocalGoalCategory.project:
      case LocalGoalCategory.deployment:
        return GoalCategory.project;
      case LocalGoalCategory.community:
        return GoalCategory.networking;
      case LocalGoalCategory.career:
        return GoalCategory.application;
    }
  }

  String? _inferSkill(GoalTemplate t) {
    final text = '${t.title} ${t.description}'.toLowerCase();
    const map = <String, String>{
      'pytorch': 'PyTorch',
      'tensorflow': 'TensorFlow',
      'python': 'Python',
      'machine learning': 'Machine Learning',
      'deep learning': 'Deep Learning',
      'llm': 'LLMs',
      'rag': 'RAG',
      'prompt engineering': 'Prompt Engineering',
      'computer vision': 'Computer Vision',
      'nlp': 'NLP',
      'sql': 'SQL',
      'algorithm': 'Algorithms',
      'data structure': 'Data Structures',
      'system design': 'System Design',
      'docker': 'Docker',
      'git': 'Git',
      'testing': 'Testing',
      'security': 'Security',
      'api': 'APIs',
      'mlops': 'MLOps',
      'cloud': 'Cloud Computing',
    };
    for (final e in map.entries) {
      if (text.contains(e.key)) return e.value;
    }
    return null;
  }

  Set<String> _readRecentSkills(
    SharedPreferences prefs,
    String uid,
    String? careerId,
  ) {
    final raw = prefs.getStringList(
          'career_goal_recent_skills_${uid}_${_safeCareerId(careerId ?? 'general')}',
        ) ??
        const <String>[];
    return raw.map(_key).where((e) => e.isNotEmpty).toSet();
  }

  Future<void> _rememberRecentSkills(
    SharedPreferences prefs,
    String uid,
    String? careerId,
    Iterable<String> skills,
  ) async {
    final key =
        'career_goal_recent_skills_${uid}_${_safeCareerId(careerId ?? 'general')}';
    final old = prefs.getStringList(key) ?? const <String>[];
    final merged = <String>[...skills, ...old]
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.trim())
        .toSet()
        .take(12)
        .toList();
    await prefs.setStringList(key, merged);
  }

  /// PHASE 3 FIX: mirrors _readRecentSkills exactly, but for template
  /// ids instead of skill names. Same storage mechanism (SharedPreferences,
  /// per uid+career), same "no new architecture" footprint.
  Set<String> _readRecentTemplateIds(
    SharedPreferences prefs,
    String uid,
    String? careerId,
  ) {
    final raw = prefs.getStringList(
          'career_goal_recent_templates_${uid}_${_safeCareerId(careerId ?? 'general')}',
        ) ??
        const <String>[];
    return raw.where((e) => e.trim().isNotEmpty).toSet();
  }

  /// PHASE 3 FIX: mirrors _rememberRecentSkills exactly, but for template
  /// ids. Keeps a rolling window of [_recentTemplateWindow] ids so a
  /// template stays "recent" (and therefore skipped by the engine) for
  /// several generation cycles, not just the next one.
  Future<void> _rememberRecentTemplateIds(
    SharedPreferences prefs,
    String uid,
    String? careerId,
    Iterable<String> templateIds,
  ) async {
    final key =
        'career_goal_recent_templates_${uid}_${_safeCareerId(careerId ?? 'general')}';
    final old = prefs.getStringList(key) ?? const <String>[];
    final merged = <String>[...templateIds, ...old]
        .where((id) => id.trim().isNotEmpty)
        .toSet()
        .take(_recentTemplateWindow)
        .toList();
    await prefs.setStringList(key, merged);
  }

  String _generationKey(String uid, String? careerId, String date) =>
      'career_goal_generated_${uid}_${_safeCareerId(careerId ?? 'general')}_$date';

  String _safeCareerId(String value) => value
      .toLowerCase()
      .trim()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '')
      .replaceAll(RegExp(r'_+'), '_');

  String _key(String value) =>
      value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();

  String _todayDateKey() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  String _weekKey(DateTime d) {
    final monday = d.subtract(Duration(days: d.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  String _monthKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}';
}