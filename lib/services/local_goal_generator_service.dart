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

    final goals = _generateDailyGoals(
      uid:      uid,
      role:     targetRole,
      level:    currentLevel,
      streak:   currentStreak,
      phase:    roadmapPhase,
      dateKey:  todayKey,
    );

    await prefs.setBool(prefKey, true);
    return goals;
  }

  /// Generate weekly goals (call from CopilotController or QuestService).
  Future<List<DailyGoal>> generateWeeklyGoals({
    required String uid,
    required String targetRole,
    required int currentLevel,
    required int roadmapPhase,
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
    );
  }

  /// Generate monthly goals (call from CopilotController or QuestService).
  Future<List<DailyGoal>> generateMonthlyGoals({
    required String uid,
    required String targetRole,
    required int currentLevel,
    required int roadmapPhase,
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
    );
  }

  // ── PRIVATE: Daily generation ──────────────────────────────────────

  List<DailyGoal> _generateDailyGoals({
    required String uid,
    required String role,
    required int level,
    required int streak,
    required int phase,
    required String dateKey,
  }) {
    final allPool  = GoalContentDatabase.dailyForRole(role);
    final usedIds  = <String>{};
    final seed     = _buildSeed(uid, dateKey);
    final rng      = Random(seed);

    // Filter by level and phase gates
    var eligible = allPool
        .where((t) => t.minLevel <= level && t.minPhase <= phase)
        .toList();

    // Fallback: ignore gates if nothing passes
    if (eligible.isEmpty) eligible = List.from(allPool);

    eligible.shuffle(rng);

    // Day-of-week strategy: easier goals on Monday, harder toward weekend
    final dayOfWeek = DateTime.now().weekday; // 1=Mon … 7=Sun
    final wantsHard   = dayOfWeek >= 4;
    final wantsMedium = dayOfWeek >= 2;

    final easy   = _pick(eligible, LocalGoalDifficulty.easy,   2, usedIds, rng);
    final medium = _pick(eligible, LocalGoalDifficulty.medium, wantsMedium ? 2 : 1, usedIds, rng);
    final hard   = _pick(eligible, LocalGoalDifficulty.hard,   wantsHard ? 1 : 0, usedIds, rng);

    final picked = [...easy, ...medium, ...hard].take(5).toList();

    return picked.asMap().entries.map((entry) {
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
  }

  // ── PRIVATE: Period generation (weekly / monthly) ──────────────────

  List<DailyGoal> _generatePeriodGoals({
    required String uid,
    required String role,
    required int level,
    required int phase,
    required _PeriodType type,
    required String periodKey,
    required int count,
    required int baseXp,
  }) {
    final pool = type == _PeriodType.weekly
        ? GoalContentDatabase.weeklyForRole(role)
        : GoalContentDatabase.monthlyForRole(role);

    final seed = _buildSeed(uid, periodKey);
    final rng  = Random(seed);

    var eligible = pool
        .where((t) => t.minLevel <= level && t.minPhase <= phase)
        .toList();

    if (eligible.isEmpty) eligible = List.from(pool);
    eligible.shuffle(rng);

    final picked = eligible.take(count).toList();

    return picked.asMap().entries.map((e) {
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
  }

  // ── PRIVATE: Helpers ───────────────────────────────────────────────

  List<GoalTemplate> _pick(
    List<GoalTemplate> pool,
    LocalGoalDifficulty diff,
    int count,
    Set<String> usedIds,
    Random rng,
  ) {
    if (count <= 0) return [];

    final candidates = pool
        .where((t) => t.difficulty == diff && !usedIds.contains(t.id))
        .toList()
      ..shuffle(rng);

    final result = <GoalTemplate>[];
    for (final t in candidates) {
      if (result.length >= count) break;
      result.add(t);
      usedIds.add(t.id);
    }

    // Fill with any difficulty if not enough matching ones
    if (result.length < count) {
      final any = pool
          .where((t) => !usedIds.contains(t.id))
          .take(count - result.length)
          .toList();
      result.addAll(any);
      for (final t in any) usedIds.add(t.id);
    }

    return result;
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

  /// Infers linkedSkill from goal template tags or title keywords.
  String? _inferLinkedSkill(GoalTemplate t) {
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