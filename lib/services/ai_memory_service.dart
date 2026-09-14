// ══════════════════════════════════════════════════════════════════════
// lib/services/ai_memory_service.dart
// NEW — AI Memory: stores context, generates personalized greetings/advice
// Uses existing Firebase, does NOT touch CopilotController
// ══════════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quest_models.dart';    // AiMemory is defined there
import '../models/copilot_models.dart';

class AiMemoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Fetch AI memory ────────────────────────────────────────────────
  Future<AiMemory> fetchMemory(String uid) async {
    try {
      final doc = await _db.collection('ai_memory').doc(uid).get();
      if (!doc.exists) return const AiMemory();
      return AiMemory.fromMap(doc.data()!);
    } catch (_) {
      return const AiMemory();
    }
  }

  // ── Persist updated memory ─────────────────────────────────────────
  Future<void> saveMemory(String uid, AiMemory memory) async {
    await _db
        .collection('ai_memory')
        .doc(uid)
        .set(memory.toMap(), SetOptions(merge: true));
  }

  // ── Record an achievement for AI context ──────────────────────────
  Future<void> recordAchievement(String uid, String achievement) async {
    await _db.collection('ai_memory').doc(uid).set({
      'recentAchievements': FieldValue.arrayUnion([achievement]),
    }, SetOptions(merge: true));
  }

  // ── Generate personalized greeting (cached to SharedPreferences) ───
  /// Returns a greeting string, regenerated at most once per day.
  Future<String> getDailyGreeting({
    required String displayName,
    required AiMemory memory,
    required CopilotState state,
    required int level,
    required String levelTitle,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = 'greeting_${_todayKey()}';
    final cached = prefs.getString(todayKey);
    if (cached != null && cached.isNotEmpty) return cached;

    final greeting = _buildGreeting(
      displayName: displayName,
      memory: memory,
      state: state,
      level: level,
      levelTitle: levelTitle,
    );

    await prefs.setString(todayKey, greeting);
    return greeting;
  }

  String _buildGreeting({
    required String displayName,
    required AiMemory memory,
    required CopilotState state,
    required int level,
    required String levelTitle,
  }) {
    final firstName = displayName.split(' ').first;
    final hour = DateTime.now().hour;

    final timeGreet = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    // Context-aware messages based on state
    if (state.currentStreak >= 30) {
      return '$timeGreet, $firstName! 🔥 ${ state.currentStreak} days straight — you\'re in rare company. Keep the fire alive today.';
    }
    if (state.currentStreak >= 7) {
      return '$timeGreet, $firstName! 📅 ${state.currentStreak}-day streak is real momentum. Level $level looks good on you.';
    }
    if (memory.recentAchievements.isNotEmpty) {
      final last = memory.recentAchievements.last;
      return '$timeGreet, $firstName! 🏅 Still celebrating "$last". What\'s next for the $levelTitle?';
    }
    if (level >= 10) {
      return '$timeGreet, $firstName. $levelTitle energy. Your roadmap is waiting.';
    }
    if (state.todayGoals.isEmpty) {
      return '$timeGreet, $firstName! Your AI-generated goals for today are ready. Let\'s build something great.';
    }
    final completed =
        state.todayGoals.where((g) => g.isCompleted).length;
    if (completed > 0) {
      return '$timeGreet, $firstName! $completed goal${completed > 1 ? 's' : ''} done today. Momentum is everything.';
    }
    return '$timeGreet, $firstName! Ready to make progress today?';
  }

  // ── Generate AI companion daily advice (cached per day) ───────────
  Future<String> getDailyAdvice({
    required AiMemory memory,
    required CopilotState state,
    required String levelTitle,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = 'advice_${_todayKey()}';
    final cached = prefs.getString(todayKey);
    if (cached != null && cached.isNotEmpty) return cached;

    final advice = _pickAdvice(state: state, levelTitle: levelTitle);
    await prefs.setString(todayKey, advice);
    return advice;
  }

  static const List<String> _advicePool = [
    '💡 Consistency beats intensity. 20 minutes of focused learning today compounds into expertise in 6 months.',
    '🎯 Focus on your top skill gap first — plugging the biggest hole has the highest career ROI.',
    '🧠 Spaced repetition: revisit what you learned 3 days ago for 5 minutes. It locks it in permanently.',
    '🌐 Build in public. Share one thing you learned this week on LinkedIn. It accelerates your career 3x.',
    '🔗 Every goal you complete is a signal to future employers. XP is your proof of work.',
    '⚡ The best learners don\'t study more — they study smarter. Do one deep-focus session today.',
    '🚀 AI skills compound. Every skill you add multiplies the value of all previous skills.',
    '💬 Talk to one person in your target field this week. One conversation > ten hours of solo study.',
    '📊 Your career readiness score rises with every task. Small actions, big trajectory.',
    '🎓 Learning is a product skill. The ability to learn fast IS the most valuable AI skill.',
    '🏆 Leaderboard position is a signal, not the goal. Use it to calibrate pace, not to compare worth.',
    '🌱 Plateaus are normal. If progress feels slow, you\'re consolidating — push through with one extra goal.',
  ];

  String _pickAdvice({
    required CopilotState state,
    required String levelTitle,
  }) {
    // Simple deterministic rotation based on day of year
    final idx = DateTime.now().dayOfYear % _advicePool.length;
    return _advicePool[idx];
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}_${now.month}_${now.day}';
  }

  // ── Update goals/interests from profile ───────────────────────────
  Future<void> syncFromProfile(
    String uid,
    CopilotState state,
  ) async {
    if (!state.hasProfile) return;

    final goals = <String>[];
    if (state.roadmap != null) {
      goals.add(state.roadmap!.targetRole.label);
    }

    final interests = state.skillGaps
        .take(5)
        .map((g) => g.skillName)
        .toList();

    await _db.collection('ai_memory').doc(uid).set({
      'goals': goals,
      'interests': interests,
    }, SetOptions(merge: true));
  }
}

extension on DateTime {
  int get dayOfYear {
    return difference(DateTime(year, 1, 1)).inDays;
  }
}