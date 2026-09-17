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
// with zero changes. `currentSkills` gained real influence on selection;
// generateWeeklyGoals/generateMonthlyGoals gained an OPTIONAL
// `currentSkills` parameter (defaults to empty list, so old call sites
// still compile and behave sensibly).
//
// Goal SELECTION no longer just shuffles the role pool. Every candidate
// GoalTemplate is scored against:
//   1. Skill gaps        — does it target a skill NOT in currentSkills?
//   2. Roadmap frontier   — is its minPhase close to the user's current
//                           roadmapPhase (freshly unlocked, not old
//                           backlog)?
//   3–5. Learn→Practice→Build stage — templates are picked slot-by-slot
//        against a stage plan (Learn, Practice, Build, General) whose mix
//        shifts from learning-heavy → practice/build-heavy as level and
//        roadmapPhase increase, so "unfinished learning", "targeted
//        practice", and "project/build work" are naturally sequenced in
//        that order rather than competing for the same slots.
//   6. General/career goals fill the lowest-priority slot each period.
// A lightweight, offline "recent work" memory (SharedPreferences only —
// no new database, no network) softly penalises repeating the same
// skill/category too soon. A small amount of deterministic, seeded
// jitter breaks ties WITHOUT making output non-deterministic for a given
// uid + date/period.
//
// This service still does exactly one job: turn available career/
// progress inputs into concrete DailyGoal objects. It does not compute
// skill gaps, roadmaps, or readiness — that remains CopilotController's
// job — and reads no Firestore data of its own.
// ══════════════════════════════════════════════════════════════════════

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
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
const Map<String, String> _skillKeywords = {
  'machine learning': 'Machine Learning',
  'deep learning': 'Deep Learning',
  'neural network': 'Neural Networks',
  'natural language': 'NLP',
  'large language model': 'LLMs',
  'prompt engineering': 'Prompt Engineering',
  'computer vision': 'Computer Vision',
  'linear algebra': 'Linear Algebra',
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
  ' ui ': 'UI Design',
  'ux': 'UX Design',
  'agile': 'Agile',
  'security': 'Security',
  'networking': 'Networking',
  'portfolio': 'Portfolio Building',
  'interview': 'Interview Prep',
  'resume': 'Resume Writing',
  'linkedin': 'Networking',
};

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
  Future<List<DailyGoal>> generateAndSaveDailyGoals({
    required String uid,
    required String targetRole,      // e.g. "AI Engineer"
    required List<String> currentSkills,
    required int currentStreak,
    required int currentLevel,
    required int roadmapPhase,
    required List<DailyGoal> existingGoals, // pass already-fetched list
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
      prefs:        prefs,
    );

    await prefs.setBool(prefKey, true);
    return goals;
  }

  /// Generate weekly goals (call from CopilotController or QuestService).
  ///
  /// [currentSkills] is optional (defaults to empty) so existing call
  /// sites that don't pass it keep compiling; passing it lets weekly
  /// goals target skill gaps the same way daily goals do.
  Future<List<DailyGoal>> generateWeeklyGoals({
    required String uid,
    required String targetRole,
    required int currentLevel,
    required int roadmapPhase,
    List<String> currentSkills = const [],
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
    );
  }

  /// Generate monthly goals (call from CopilotController or QuestService).
  ///
  /// [currentSkills] is optional (defaults to empty) — same backward
  /// -compatibility rationale as [generateWeeklyGoals].
  Future<List<DailyGoal>> generateMonthlyGoals({
    required String uid,
    required String targetRole,
    required int currentLevel,
    required int roadmapPhase,
    List<String> currentSkills = const [],
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
  /// Never picks the same template id twice. Falls back to the whole
  /// remaining pool for a slot if that slot's preferred categories have
  /// nothing left, so slots are still filled whenever the content pool
  /// allows it.
  List<GoalTemplate> _selectGoals({
    required List<GoalTemplate> pool,
    required List<_Stage> stagePlan,
    required List<LocalGoalDifficulty> difficultyPlan,
    required Set<String> knownSkillsLower,
    required Set<String> recentSkillsLower,
    required Set<String> recentCategoriesLower,
    required int phase,
    required Random rng,
  }) {
    final used = <String>{};
    final result = <GoalTemplate>[];

    for (var i = 0; i < stagePlan.length; i++) {
      final allowedCategories = _stageCategories[stagePlan[i]]!;

      var candidates = pool
          .where((t) => allowedCategories.contains(t.category) && !used.contains(t.id))
          .toList();

      if (candidates.isEmpty) {
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

  /// Composite deterministic score — higher wins. See the file header
  /// for how this maps to the six priority levels requested.
  double _scoreTemplate(
    GoalTemplate t, {
    required Set<String> knownSkillsLower,
    required Set<String> recentSkillsLower,
    required Set<String> recentCategoriesLower,
    required int phase,
    LocalGoalDifficulty? desiredDifficulty,
    required Random rng,
  }) {
    double score = 0;

    // Priority #1: skill gaps. A template whose inferred skill is NOT
    // already in the user's currentSkills scores highest — it's exactly
    // the "weak/missing skill" this template would help close. A
    // template for a skill the user already has is still useful
    // (reinforcement) but scores much lower for this factor.
    final skillHint = _specificSkillHint(t)?.toLowerCase();
    if (skillHint != null) {
      final isKnown = knownSkillsLower
          .any((k) => k.isNotEmpty && (k.contains(skillHint) || skillHint.contains(k)));
      score += isKnown ? 15 : 100;

      if (recentSkillsLower.contains(skillHint)) {
        score -= 35; // recently assigned this exact skill — cool off
      }
    }

    // Priority #2: roadmap prerequisites/dependencies. Templates whose
    // minPhase sits right at (or just before) the user's current
    // roadmapPhase are the actual "next" content — reward closeness to
    // the frontier over deep backlog from long-passed phases.
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
  String? _specificSkillHint(GoalTemplate t) {
    final title = t.title.toLowerCase();
    for (final entry in _skillKeywords.entries) {
      if (title.contains(entry.key)) return entry.value;
    }
    return null;
  }

  /// Infers linkedSkill for a DailyGoal: prefers a specific skill parsed
  /// from the title (see [_specificSkillHint]) since that's far more
  /// meaningful than a broad role area; falls back to the original
  /// tag-based role mapping when no specific skill keyword is found, and
  /// finally to null — identical fallback behaviour to before this
  /// upgrade when neither source has anything to offer.
  String? _inferLinkedSkill(GoalTemplate t) {
    final specific = _specificSkillHint(t);
    if (specific != null) return specific;

    if (t.tags.isNotEmpty) {
      // Convert role tag to a readable skill name
      final tag = t.tags.first;
      switch (tag) {
        case 'ai_engineer':        return 'AI Engineering';
        case 'ml_engineer':        return 'Machine Learning';
        case 'data_scientist':     return 'Data Science';
        case 'nlp_engineer':       return 'NLP';
        case 'prompt_engineer':    return 'Prompt Engineering';
        case 'ai_researcher':      return 'AI Research';
        case 'ai_product_manager': return 'AI Product Management';
        default:                   return null;
      }
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