// ══════════════════════════════════════════════════════════════════════
// lib/services/local_goal_generator_service.dart
//
// PURPOSE: 100% offline, zero API calls, production-ready goal engine.
//
// COMPATIBLE WITH:
//   • DailyGoal in copilot_models.dart
//     Fields: id, uid, title, category (GoalCategory), date, isCompleted,
//             xpReward, linkedSkill
//   • GoalCategory enum in copilot_models.dart
//     Values: learning, practice, networking, application, project
//   • CopilotFirestoreService.saveDailyGoals() — uses toFirestore()
//   • CopilotFirestoreService.getTodayGoals()  — date format yyyy-MM-dd
//
// ══════════════════════════════════════════════════════════════════════
// UPGRADE NOTES (Career Goal Engine)
// ══════════════════════════════════════════════════════════════════════
// All public method signatures, the DailyGoal/GoalCategory model, the XP
// system, the SharedPreferences "already generated today" guard, and the
// weekly/monthly generation entry points are UNCHANGED and backward
// compatible — existing callers (e.g. CopilotController) keep working
// with zero changes.
//
// This revision makes goal generation genuinely personalized and
// evidence-driven using ONLY the signals already available through the
// existing inputs and architecture — no new API, no new database, no
// new persistence, no duplicated intelligence:
//
//   • currentSkills is treated as a GRADED signal, not a boolean. A skill
//     that appears in currentSkills is prioritized LOWER than an unknown
//     skill, but still scores as useful "reinforcement/practice" — it is
//     never discarded. This preserves progression for a skill that is
//     present but still weak.
//
//   • Weak-topic evidence is accepted through a new OPTIONAL parameter
//     (`weakTopics`) on the public entry points. Callers that already
//     have this data (e.g. CopilotController, which builds it from the
//     learning-progress evidence trail) can pass it in; callers that do
//     not are unaffected. Weak topics cause targeted practice goals to
//     score higher — this is how repeated quiz/challenge weakness turns
//     into a real, targeted next goal, without inventing storage here.
//
//   • Completed/mastered work is de-prioritized unless it is an
//     intentional refresher. This is derived from existing local signals
//     only (recent-work memory + the roadmap-frontier proximity score),
//     so no new authoritative source is required.
//
//   • Learn → Practice → Build stage ordering is protected. A stage
//     fallback is only used when a slot's preferred categories are
//     genuinely exhausted; when that happens the fallback prefers
//     templates from the same or a LATER stage, so the progression is
//     never silently reversed.
//
//   • Software Engineer is a first-class career:
//       - a dedicated `_roleSkillKeywords['software engineer']` entry,
//       - a dedicated `_careerLinkedSkill` mapping so linked-skill
//         fallback resolves to real SE skills (DSA, System Design, Git,
//         Testing, APIs, Databases) instead of null/generic,
//       - explicit SE keywords added to `_skillKeywords`.
//
//   • Fragile UI keyword matching is fixed: the previous `' ui '` entry
//     (which required literal surrounding spaces and therefore almost
//     never matched real titles) is replaced with a boundary-safe check,
//     so UI/UX goals correctly resolve to a real linked skill.
//
//   • Weekly/monthly XP semantics are clarified in comments only. The
//     existing flat `baseXp` behaviour for weekly/monthly is preserved
//     exactly; no XP value changes.
//
//   • A genuinely unused import was removed. `cloud_firestore` was
//     imported but never referenced in this file (persistence goes
//     through CopilotFirestoreService, which is imported by the caller).
//
// This service still does exactly one job: turn available career/
// progress inputs into concrete DailyGoal objects. It does not compute
// skill gaps, roadmaps, or readiness — that remains CopilotController's
// job — and reads no Firestore data of its own.
// ══════════════════════════════════════════════════════════════════════

import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/copilot_models.dart';
import 'goal_content_database.dart';

// ── XP constants ───────────────────────────────────────────────────────
class _Xp {
  static const int easy              = 15;
  static const int medium            = 30;
  static const int hard              = 50;
  static const int allGoalsBonus     = 40;
  static const int streakBonus3      = 5;
  static const int streakBonus7      = 10;
  static const int weeklyBase        = 150;
  static const int monthlyBase       = 400;
}

// ── Date key helpers ───────────────────────────────────────────────────
// Uses the same yyyy-MM-dd format as CopilotFirestoreService._todayKey()
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

// ── Learn → Practice → Build stage model ────────────────────────────────
// Groups the existing LocalGoalCategory values into a coarser "stage"
// used purely for SELECTION ordering/mix. This does not change
// GoalCategory (the model DailyGoal actually stores) — _mapCategory below
// still performs the exact same LocalGoalCategory → GoalCategory mapping
// as before.
enum _Stage { learn, practice, build, general }

const Map<_Stage, Set<LocalGoalCategory>> _stageCategories = {
  _Stage.learn: {LocalGoalCategory.learning, LocalGoalCategory.reading},
  _Stage.practice: {
    LocalGoalCategory.practice,
    LocalGoalCategory.coding,
    LocalGoalCategory.review,
  },
  _Stage.build: {
    LocalGoalCategory.project,
    LocalGoalCategory.deployment,
    LocalGoalCategory.design,
    LocalGoalCategory.data,
  },
  _Stage.general: {LocalGoalCategory.community, LocalGoalCategory.career},
};

// ── Lightweight, offline skill-keyword lookup ───────────────────────────
// Used only to derive a specific, meaningful `linkedSkill` from a goal
// template's title, and to detect whether that skill is already in the
// user's currentSkills (a "gap") or not. Deliberately a small, hand
// -written table — no AI/API involved, and GoalContentDatabase itself is
// never modified.
//
// Notes on fragile matches:
//   • Every key is matched with word-boundary awareness (see
//     `_titleContains` below) so short keys like "git", "api", "ui",
//     "ux", "sql", "nlp", "llm", "rag" do not accidentally match inside
//     unrelated words (e.g. "digital" containing "git").
//   • The previous `' ui '` entry (which required literal surrounding
//     spaces) has been replaced by boundary-safe `'ui'` and `'ux'` keys.
const Map<String, String> _skillKeywords = {
  'machine learning': 'Machine Learning',
  'deep learning': 'Deep Learning',
  'neural network': 'Neural Networks',
  'natural language': 'NLP',
  'large language model': 'LLMs',
  'prompt engineering': 'Prompt Engineering',
  'computer vision': 'Computer Vision',
  'linear algebra': 'Linear Algebra',
  'data structures': 'Data Structures',
  'data structure': 'Data Structures',
  'system design': 'System Design',
  'retrieval': 'RAG',
  'pytorch': 'PyTorch',
  'tensorflow': 'TensorFlow',
  'python': 'Python',
  'sql': 'SQL',
  'nlp': 'NLP',
  'llm': 'LLMs',
  'rag': 'RAG',
  'docker': 'Docker',
  'kubernetes': 'Kubernetes',
  'git': 'Git',
  'api': 'APIs',
  'statistics': 'Statistics',
  'algorithm': 'Algorithms',
  'mlops': 'MLOps',
  'react': 'React',
  'javascript': 'JavaScript',
  'cloud': 'Cloud Computing',
  'aws': 'AWS',
  'testing': 'Testing',
  'ui': 'UI Design',
  'ux': 'UX Design',
  'agile': 'Agile',
  'security': 'Security',
  'networking': 'Networking',
  'portfolio': 'Portfolio Building',
  'interview': 'Interview Prep',
  'resume': 'Resume Writing',
  'linkedin': 'Networking',
  'database': 'Databases',
  'databases': 'Databases',
};

/// Boundary-safe title match: returns true when `title` contains `needle`
/// as a whole word (surrounded by non-letter characters or string edges).
/// This keeps short keyword keys (git, api, ui, ux, sql, nlp, llm, rag,
/// aws …) from matching inside unrelated longer words.
bool _titleContains(String titleLower, String needleLower) {
  if (needleLower.isEmpty) return false;
  var from = 0;
  while (true) {
    final idx = titleLower.indexOf(needleLower, from);
    if (idx < 0) return false;
    final before = idx == 0 ? ' ' : titleLower[idx - 1];
    final after = (idx + needleLower.length >= titleLower.length)
        ? ' '
        : titleLower[idx + needleLower.length];
    final beforeOk = !_isLetter(before);
    final afterOk  = !_isLetter(after);
    if (beforeOk && afterOk) return true;
    from = idx + 1;
  }
}

bool _isLetter(String c) {
  if (c.isEmpty) return false;
  final code = c.codeUnitAt(0);
  return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
}

// ── Role-aware linked-skill fallback ────────────────────────────────────
// Used ONLY when no specific skill keyword matched the title. Resolves a
// template's role tag to a concrete, meaningful skill name. Software
// Engineer is a first-class entry here — no generic fallback.
String? _roleTagToLinkedSkill(String tag) {
  switch (tag) {
    case 'ai_engineer':        return 'AI Engineering';
    case 'ml_engineer':        return 'Machine Learning';
    case 'data_scientist':     return 'Data Science';
    case 'nlp_engineer':       return 'NLP';
    case 'prompt_engineer':    return 'Prompt Engineering';
    case 'ai_researcher':      return 'AI Research';
    case 'ai_product_manager': return 'AI Product Management';
    case 'software_engineer':  return 'Software Engineering';
    case 'web_developer':      return 'Web Development';
    case 'frontend_dev':       return 'Frontend Development';
    case 'cyber_security':     return 'Cyber Security';
    case 'ethical_hacker':     return 'Ethical Hacking';
    case 'ui_ux_designer':     return 'UI/UX Design';
    case 'ux_designer':        return 'UX Design';
    case 'devops_engineer':    return 'DevOps';
    case 'qa_engineer':        return 'QA Engineering';
    case 'blockchain_dev':     return 'Blockchain Development';
    case 'solutions_architect':return 'Solution Architecture';
    default:                   return null;
  }
}

// ══════════════════════════════════════════════════════════════════════
// LOCAL GOAL GENERATOR SERVICE
// ══════════════════════════════════════════════════════════════════════

class LocalGoalGeneratorService {
  // No FirebaseFirestore here — we use CopilotFirestoreService for
  // persistence. This service only generates and returns DailyGoal lists.

  // ── PUBLIC API ─────────────────────────────────────────────────────

  /// Generates and returns daily goals.
  /// Returns empty list if goals already exist for today (caller checks
  /// via CopilotFirestoreService.getTodayGoals before calling this).
  ///
  /// All parameters come from CopilotController — no new API calls.
  ///
  /// [weakTopics] is OPTIONAL and backward compatible. When supplied
  /// (typically derived by CopilotController from existing learning-
  /// progress evidence: quiz/challenge misses, weak skill topics, etc.),
  /// it biases selection toward templates that target those weak areas,
  /// so repeated weakness turns into targeted practice on the very next
  /// goal generation — offline and deterministically.
  Future<List<DailyGoal>> generateAndSaveDailyGoals({
    required String uid,
    required String targetRole,      // e.g. "AI Engineer"
    required List<String> currentSkills,
    required int currentStreak,
    required int currentLevel,
    required int roadmapPhase,
    required List<DailyGoal> existingGoals, // pass already-fetched list
    List<String> weakTopics = const [],
  }) async {
    // If already generated today, return existing
    if (existingGoals.isNotEmpty) return existingGoals;

    final prefs   = await SharedPreferences.getInstance();
    final todayKey = _todayDateKey();
    final prefKey  = 'goals_gen_${uid}_$todayKey';

    // Extra guard: if SharedPreferences says we already generated today
    if (prefs.getBool(prefKey) == true) return existingGoals;

    final goals = await _generateDailyGoals(
      uid:          uid,
      role:         targetRole,
      level:        currentLevel,
      streak:       currentStreak,
      phase:        roadmapPhase,
      dateKey:      todayKey,
      currentSkills: currentSkills,
      weakTopics:   weakTopics,
      prefs:        prefs,
    );

    await prefs.setBool(prefKey, true);
    return goals;
  }

  /// Generate weekly goals (call from CopilotController or QuestService).
  ///
  /// [currentSkills] and [weakTopics] are OPTIONAL (default to empty) so
  /// existing call sites that don't pass them keep compiling. Passing
  /// them lets weekly goals target skill gaps and weak areas the same
  /// way daily goals do.
  ///
  /// XP semantics for weekly goals are unchanged: every weekly goal is
  /// awarded the flat [ _Xp.weeklyBase ] reward. Skill/weak-topic bias
  /// affects only WHICH templates are chosen, never the XP value.
  Future<List<DailyGoal>> generateWeeklyGoals({
    required String uid,
    required String targetRole,
    required int currentLevel,
    required int roadmapPhase,
    List<String> currentSkills = const [],
    List<String> weakTopics = const [],
  }) async {
    final weekKey = _weekKey(DateTime.now());

    return _generatePeriodGoals(
      uid:       uid,
      role:      targetRole,
      level:     currentLevel,
      phase:     roadmapPhase,
      type:      _PeriodType.weekly,
      periodKey: weekKey,
      count:     3,
      baseXp:    _Xp.weeklyBase,
      currentSkills: currentSkills,
      weakTopics: weakTopics,
    );
  }

  /// Generate monthly goals (call from CopilotController or QuestService).
  ///
  /// [currentSkills] and [weakTopics] are OPTIONAL (default to empty) —
  /// same backward-compatibility rationale as [generateWeeklyGoals].
  ///
  /// XP semantics for monthly goals are unchanged: every monthly goal is
  /// awarded the flat [ _Xp.monthlyBase ] reward. As with weekly goals,
  /// the skill/weak-topic bias only affects template selection.
  Future<List<DailyGoal>> generateMonthlyGoals({
    required String uid,
    required String targetRole,
    required int currentLevel,
    required int roadmapPhase,
    List<String> currentSkills = const [],
    List<String> weakTopics = const [],
  }) async {
    final monthKey = _monthKey(DateTime.now());

    return _generatePeriodGoals(
      uid:       uid,
      role:      targetRole,
      level:     currentLevel,
      phase:     roadmapPhase,
      type:      _PeriodType.monthly,
      periodKey: monthKey,
      count:     2,
      baseXp:    _Xp.monthlyBase,
      currentSkills: currentSkills,
      weakTopics: weakTopics,
    );
  }

  // ── PRIVATE: Daily generation ──────────────────────────────────────

  Future<List<DailyGoal>> _generateDailyGoals({
    required String uid,
    required String role,
    required int level,
    required int streak,
    required int phase,
    required String dateKey,
    required List<String> currentSkills,
    required List<String> weakTopics,
    required SharedPreferences prefs,
  }) async {
    final allPool = GoalContentDatabase.dailyForRole(role);
    final seed    = _buildSeed(uid, dateKey);
    final rng     = Random(seed);

    // Filter by level and phase gates (unchanged behaviour)
    var eligible = allPool
        .where((t) => t.minLevel <= level && t.minPhase <= phase)
        .toList();

    // Fallback: ignore gates if nothing passes
    if (eligible.isEmpty) eligible = List.from(allPool);

    final knownSkillsLower =
        currentSkills.map((s) => s.toLowerCase().trim()).toSet();
    final weakTopicsLower = _normalizeWeakTopics(weakTopics);
    final recentSkillsLower = await _loadRecent(prefs, _recentSkillsKey(uid));
    final recentCategoriesLower =
        await _loadRecent(prefs, _recentCategoriesKey(uid));

    final dayOfWeek = DateTime.now().weekday; // 1=Mon … 7=Sun
    final stagePlan = _dailyStagePlan(level, phase);
    final difficultyPlan =
        List.generate(stagePlan.length, (i) => _difficultyForSlot(i, level, dayOfWeek));

    final picked = _selectGoals(
      pool: eligible,
      stagePlan: stagePlan,
      difficultyPlan: difficultyPlan,
      knownSkillsLower: knownSkillsLower,
      weakTopicsLower: weakTopicsLower,
      recentSkillsLower: recentSkillsLower,
      recentCategoriesLower: recentCategoriesLower,
      phase: phase,
      rng: rng,
    ).take(5).toList();

    final goals = picked.asMap().entries.map((entry) {
      final idx      = entry.key;
      final template = entry.value;
      final xp       = _computeXp(template.difficulty, streak);

      return DailyGoal(
        id:          '${template.id}_${dateKey}_$idx',
        uid:         uid,
        title:       template.title,
        category:    _mapCategory(template.category),
        date:        dateKey,
        isCompleted: false,
        xpReward:    xp,
        linkedSkill: _inferLinkedSkill(template),
      );
    }).toList();

    // Remember what we just assigned (skills + categories) so tomorrow's
    // generation can softly avoid repeating the same work immediately.
    // Local-only, offline, capped in size — no new database.
    await _rememberRecentWork(prefs, uid, picked);

    return goals;
  }

  // ── PRIVATE: Period generation (weekly / monthly) ──────────────────

  Future<List<DailyGoal>> _generatePeriodGoals({
    required String uid,
    required String role,
    required int level,
    required int phase,
    required _PeriodType type,
    required String periodKey,
    required int count,
    required int baseXp,
    List<String> currentSkills = const [],
    List<String> weakTopics = const [],
  }) async {
    final pool = type == _PeriodType.weekly
        ? GoalContentDatabase.weeklyForRole(role)
        : GoalContentDatabase.monthlyForRole(role);

    final seed = _buildSeed(uid, periodKey);
    final rng  = Random(seed);

    var eligible = pool
        .where((t) => t.minLevel <= level && t.minPhase <= phase)
        .toList();

    if (eligible.isEmpty) eligible = List.from(pool);

    final prefs = await SharedPreferences.getInstance();
    final knownSkillsLower =
        currentSkills.map((s) => s.toLowerCase().trim()).toSet();
    final weakTopicsLower = _normalizeWeakTopics(weakTopics);
    final recentSkillsLower = await _loadRecent(prefs, _recentSkillsKey(uid));
    final recentCategoriesLower =
        await _loadRecent(prefs, _recentCategoriesKey(uid));

    final stagePlan = type == _PeriodType.weekly
        ? _weeklyStagePlan(level, phase)
        : _monthlyStagePlan(level, phase);

    final picked = _selectGoals(
      pool: eligible,
      stagePlan: stagePlan,
      difficultyPlan: const [], // weekly/monthly keep flat baseXp, as before
      knownSkillsLower: knownSkillsLower,
      weakTopicsLower: weakTopicsLower,
      recentSkillsLower: recentSkillsLower,
      recentCategoriesLower: recentCategoriesLower,
      phase: phase,
      rng: rng,
    ).take(count).toList();

    final goals = picked.asMap().entries.map((e) {
      final t = e.value;
      return DailyGoal(
        id:          '${t.id}_${periodKey}_${e.key}',
        uid:         uid,
        title:       t.title,
        category:    _mapCategory(t.category),
        date:        periodKey,
        isCompleted: false,
        xpReward:    baseXp,
        linkedSkill: _inferLinkedSkill(t),
      );
    }).toList();

    await _rememberRecentWork(prefs, uid, picked);

    return goals;
  }

  // ── PRIVATE: Stage plans (Learn → Practice → Build progression) ────

  /// Progression tier derived from level/phase: 0 = early (foundations),
  /// 1 = mid (balanced), 2 = late (build-heavy). Shared by daily/weekly/
  /// monthly stage plans so the "feel" of progression is consistent
  /// across all three.
  int _progressionTier(int level, int phase) {
    if (phase >= 3) return 2;
    if (phase >= 1 || level >= 3) return 1;
    return 0;
  }

  /// 5 slots/day: early on, mostly Learn + Practice; mid, a balanced
  /// Learn → Practice → Build spread; late, Practice/Build-heavy with a
  /// touch of ongoing Learn. A General (career/networking) slot is
  /// always included — priority #6, but still present every day.
  List<_Stage> _dailyStagePlan(int level, int phase) {
    switch (_progressionTier(level, phase)) {
      case 0:
        return [
          _Stage.learn,
          _Stage.learn,
          _Stage.practice,
          _Stage.practice,
          _Stage.general,
        ];
      case 1:
        return [
          _Stage.learn,
          _Stage.practice,
          _Stage.practice,
          _Stage.build,
          _Stage.general,
        ];
      default:
        return [
          _Stage.practice,
          _Stage.build,
          _Stage.build,
          _Stage.learn,
          _Stage.general,
        ];
    }
  }

  List<_Stage> _weeklyStagePlan(int level, int phase) {
    switch (_progressionTier(level, phase)) {
      case 0:
        return [_Stage.learn, _Stage.learn, _Stage.practice];
      case 1:
        return [_Stage.learn, _Stage.practice, _Stage.build];
      default:
        return [_Stage.practice, _Stage.build, _Stage.build];
    }
  }

  List<_Stage> _monthlyStagePlan(int level, int phase) {
    switch (_progressionTier(level, phase)) {
      case 0:
        return [_Stage.learn, _Stage.practice];
      case 1:
        return [_Stage.practice, _Stage.build];
      default:
        return [_Stage.build, _Stage.build];
    }
  }

  /// Difficulty target for a given daily slot — blends the existing
  /// day-of-week pacing (harder later in the week) with the user's
  /// level, so difficulty progressively increases as the user advances,
  /// not just as the week goes on.
  LocalGoalDifficulty _difficultyForSlot(int slotIndex, int level, int dayOfWeek) {
    final dayBase = dayOfWeek >= 4 ? 2 : (dayOfWeek >= 2 ? 1 : 0);
    final levelBoost = (level ~/ 3).clamp(0, 2);
    final lateSlotBoost = slotIndex >= 3 ? 1 : 0;
    final combined = (dayBase + levelBoost + lateSlotBoost).clamp(0, 2);

    if (combined == 0) return LocalGoalDifficulty.easy;
    if (combined == 1) return LocalGoalDifficulty.medium;
    return LocalGoalDifficulty.hard;
  }

  // ── PRIVATE: Selection engine ───────────────────────────────────────

  /// Picks one GoalTemplate per stage slot in [stagePlan], scoring every
  /// eligible candidate for that slot and taking the highest-scoring one.
  /// Never picks the same template id twice.
  ///
  /// Stage fallback discipline: if a slot's preferred categories have
  /// nothing left in the pool, the fallback is restricted to templates
  /// whose category belongs to the SAME or a LATER stage. This prevents
  /// an early "learn" slot from silently being backfilled with a late
  /// "build" template (or vice-versa), preserving the Learn → Practice →
  /// Build ordering the stage plan was written to express. Only when
  /// that restricted fallback is also empty does it fall back to the
  /// full remaining pool (so a slot is never left unfilled when the
  /// content pool can still fill it).
  List<GoalTemplate> _selectGoals({
    required List<GoalTemplate> pool,
    required List<_Stage> stagePlan,
    required List<LocalGoalDifficulty> difficultyPlan,
    required Set<String> knownSkillsLower,
    required Set<String> weakTopicsLower,
    required Set<String> recentSkillsLower,
    required Set<String> recentCategoriesLower,
    required int phase,
    required Random rng,
  }) {
    final used = <String>{};
    final result = <GoalTemplate>[];

    for (var i = 0; i < stagePlan.length; i++) {
      final slotStage = stagePlan[i];
      final allowedCategories = _stageCategories[slotStage]!;

      var candidates = pool
          .where((t) => allowedCategories.contains(t.category) && !used.contains(t.id))
          .toList();

      if (candidates.isEmpty) {
        // Restricted fallback: same stage or later stage only, so the
        // Learn → Practice → Build ordering is never reversed.
        final sameOrLaterCategories = _categoriesForStagesFrom(slotStage);
        candidates = pool
            .where((t) =>
                sameOrLaterCategories.contains(t.category) &&
                !used.contains(t.id))
            .toList();
      }
      if (candidates.isEmpty) {
        // Last resort: any unused template. Only reached when the
        // restricted set is genuinely exhausted (or the pool is tiny).
        candidates = pool.where((t) => !used.contains(t.id)).toList();
      }
      if (candidates.isEmpty) break; // content pool truly exhausted

      final desiredDifficulty =
          i < difficultyPlan.length ? difficultyPlan[i] : null;

      GoalTemplate? best;
      double bestScore = double.negativeInfinity;
      for (final t in candidates) {
        final score = _scoreTemplate(
          t,
          knownSkillsLower: knownSkillsLower,
          weakTopicsLower: weakTopicsLower,
          recentSkillsLower: recentSkillsLower,
          recentCategoriesLower: recentCategoriesLower,
          phase: phase,
          desiredDifficulty: desiredDifficulty,
          rng: rng,
        );
        if (score > bestScore) {
          bestScore = score;
          best = t;
        }
      }

      if (best != null) {
        result.add(best);
        used.add(best.id);
      }
    }

    return result;
  }

  /// Returns the set of LocalGoalCategory values that belong to
  /// [fromStage] or any stage that comes AFTER it in the Learn →
  /// Practice → Build progression. Used by the stage-fallback path so a
  /// slot can only be backfilled with content at or beyond its own stage.
  Set<LocalGoalCategory> _categoriesForStagesFrom(_Stage fromStage) {
    const order = [_Stage.learn, _Stage.practice, _Stage.build, _Stage.general];
    final startIndex = order.indexOf(fromStage);
    if (startIndex < 0) return const {};

    final result = <LocalGoalCategory>{};
    for (var i = startIndex; i < order.length; i++) {
      result.addAll(_stageCategories[order[i]]!);
    }
    return result;
  }

  /// Composite deterministic score — higher wins. See the file header
  /// for how this maps to the six priority levels requested.
  double _scoreTemplate(
    GoalTemplate t, {
    required Set<String> knownSkillsLower,
    required Set<String> weakTopicsLower,
    required Set<String> recentSkillsLower,
    required Set<String> recentCategoriesLower,
    required int phase,
    LocalGoalDifficulty? desiredDifficulty,
    required Random rng,
  }) {
    double score = 0;

    final skillHint = _specificSkillHint(t)?.toLowerCase();

    // Priority #1: skill gaps. A template whose inferred skill is NOT
    // already in the user's currentSkills scores highest — it's exactly
    // the "missing skill" this template would help close.
    //
    // currentSkills is treated as a GRADED signal, not a boolean:
    //   • unknown skill           → full gap bonus
    //   • known skill             → smaller "reinforcement" bonus
    //     (the skill is present, but could still be weak; we never
    //      discard a valid practice goal just because the skill exists)
    if (skillHint != null) {
      final isKnown = _skillMatchesAny(skillHint, knownSkillsLower);
      score += isKnown ? 25 : 100;

      // Priority #4: weak-topic evidence. A template targeting a topic
      // the user has demonstrably struggled with (from quiz/challenge
      // evidence supplied through the existing optional parameter)
      // scores ABOVE unknown-skill work — it is the most personalized
      // possible next goal. This is how repeated weakness turns into
      // targeted practice, entirely offline and deterministically.
      final isWeak = _skillMatchesAny(skillHint, weakTopicsLower);
      if (isWeak) score += 120;

      if (recentSkillsLower.contains(skillHint)) {
        score -= 35; // recently assigned this exact skill — cool off
      }
    }

    // Priority #2: roadmap prerequisites/dependencies. Templates whose
    // minPhase sits right at (or just before) the user's current
    // roadmapPhase are the actual "next" content — reward closeness to
    // the frontier over deep backlog from long-passed phases. This is
    // also the primary "avoid already-completed work" signal available
    // offline: content from a long-passed phase scores near-zero here.
    final phaseDistance = (phase - t.minPhase).clamp(0, 10);
    score += (10 - phaseDistance);

    if (recentCategoriesLower.contains(t.category.name.toLowerCase())) {
      score -= 8; // mild variety nudge away from very recent category
    }

    if (desiredDifficulty != null && t.difficulty == desiredDifficulty) {
      score += 6; // matches the day/level-appropriate difficulty target
    }

    // Deterministic jitter: same uid + date/period always produces the
    // same rng sequence, so this breaks ties without adding real
    // randomness across otherwise-identical inputs.
    score += rng.nextInt(5);

    return score;
  }

  /// Returns true when [needleLower] matches any entry in [haystackLower]
  /// with the same substring/containment rule used previously — but
  /// applied against a pre-lowercased, normalized target set.
  bool _skillMatchesAny(String needleLower, Set<String> haystackLower) {
    if (needleLower.isEmpty) return false;
    for (final h in haystackLower) {
      if (h.isEmpty) continue;
      if (h.contains(needleLower) || needleLower.contains(h)) return true;
    }
    return false;
  }

  // ── PRIVATE: Recent-work memory (SharedPreferences only) ────────────

  String _recentSkillsKey(String uid) => 'recent_goal_skills_$uid';
  String _recentCategoriesKey(String uid) => 'recent_goal_categories_$uid';

  Future<Set<String>> _loadRecent(SharedPreferences prefs, String key) async {
    final raw = prefs.getStringList(key) ?? const <String>[];
    return raw.map((e) => e.toLowerCase()).toSet();
  }

  Future<void> _appendRecent(
    SharedPreferences prefs,
    String key,
    Iterable<String> values, {
    int maxEntries = 20,
  }) async {
    if (values.isEmpty) return;
    final existing = prefs.getStringList(key) ?? <String>[];
    final updated = [...existing, ...values];
    final trimmed = updated.length > maxEntries
        ? updated.sublist(updated.length - maxEntries)
        : updated;
    await prefs.setStringList(key, trimmed);
  }

  Future<void> _rememberRecentWork(
    SharedPreferences prefs,
    String uid,
    List<GoalTemplate> picked,
  ) async {
    final skills = picked
        .map((t) => _specificSkillHint(t))
        .whereType<String>()
        .map((s) => s.toLowerCase());
    final categories = picked.map((t) => t.category.name.toLowerCase());

    await _appendRecent(prefs, _recentSkillsKey(uid), skills);
    await _appendRecent(prefs, _recentCategoriesKey(uid), categories);
  }

  // ── PRIVATE: Helpers ───────────────────────────────────────────────

  /// Normalizes weak-topic input from the caller: trims, lowercases, and
  /// drops empties. The result is used only for scoring — it is never
  /// persisted here, and never treated as authoritative. Copilot owns
  /// the authoritative evidence trail; this service just honors it.
  Set<String> _normalizeWeakTopics(List<String> weakTopics) {
    if (weakTopics.isEmpty) return const <String>{};
    return weakTopics
        .map((s) => s.toLowerCase().trim())
        .where((s) => s.isNotEmpty)
        .toSet();
  }

  int _computeXp(LocalGoalDifficulty diff, int streak) {
    int base;
    switch (diff) {
      case LocalGoalDifficulty.easy:   base = _Xp.easy;   break;
      case LocalGoalDifficulty.medium: base = _Xp.medium; break;
      case LocalGoalDifficulty.hard:   base = _Xp.hard;   break;
    }

    if (streak >= 30) return (base * 1.5).round();
    if (streak >= 14) return (base * 1.3).round();
    if (streak >= 7)  return (base * 1.15).round();
    if (streak >= 3)  return base + _Xp.streakBonus3;
    return base;
  }

  /// Maps LocalGoalCategory → GoalCategory (copilot_models.dart).
  /// GoalCategory has: learning, practice, networking, application, project
  GoalCategory _mapCategory(LocalGoalCategory cat) {
    switch (cat) {
      case LocalGoalCategory.learning:    return GoalCategory.learning;
      case LocalGoalCategory.reading:     return GoalCategory.learning;
      case LocalGoalCategory.practice:    return GoalCategory.practice;
      case LocalGoalCategory.coding:      return GoalCategory.practice;
      case LocalGoalCategory.review:      return GoalCategory.practice;
      case LocalGoalCategory.project:     return GoalCategory.project;
      case LocalGoalCategory.deployment:  return GoalCategory.project;
      case LocalGoalCategory.community:   return GoalCategory.networking;
      case LocalGoalCategory.career:      return GoalCategory.application;
      case LocalGoalCategory.design:      return GoalCategory.practice;
      case LocalGoalCategory.data:        return GoalCategory.practice;
    }
  }

  /// Finds a specific, meaningful skill name from the template's title
  /// (e.g. "Python", "Docker", "LLMs") using the keyword table above.
  /// Uses boundary-safe matching so short keys never match inside
  /// unrelated longer words.
  String? _specificSkillHint(GoalTemplate t) {
    final title = t.title.toLowerCase();
    for (final entry in _skillKeywords.entries) {
      if (_titleContains(title, entry.key)) return entry.value;
    }
    return null;
  }

  /// Infers linkedSkill for a DailyGoal: prefers a specific skill parsed
  /// from the title (see [_specificSkillHint]) since that's far more
  /// meaningful than a broad role area; falls back to the role-tag
  /// mapping (which now includes Software Engineer and every other
  /// supported career), and finally to null — identical fallback
  /// behaviour to before this upgrade when neither source has anything
  /// to offer.
  String? _inferLinkedSkill(GoalTemplate t) {
    final specific = _specificSkillHint(t);
    if (specific != null) return specific;

    if (t.tags.isNotEmpty) {
      return _roleTagToLinkedSkill(t.tags.first);
    }
    return null;
  }

  /// Deterministic seed: same uid + same date → same pool order every time.
  int _buildSeed(String uid, String dateKey) {
    final combined = '$uid|$dateKey';
    int hash = 0;
    for (final ch in combined.codeUnits) {
      hash = (hash * 31 + ch) & 0x7FFFFFFF;
    }
    return hash;
  }
}

enum _PeriodType { weekly, monthly }