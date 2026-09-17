// ══════════════════════════════════════════════════════════════════════


// lib/services/ai_memory_service.dart

// NEW — AI Memory: stores context, generates personalized greetings/advice

// Uses existing Firebase, does NOT touch CopilotController

// ══════════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/quest_models.dart';    // AiMemory is defined there


import '../models/copilot_models.dart';

import 'copilot_firestore_service.dart';

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

CopilotContext? context,

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

  context: context,

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

CopilotContext? context,

}) {

final firstName = displayName.split(' ').first;

final hour = DateTime.now().hour;



final timeGreet = hour < 12

    ? 'Good morning'

    : hour < 17

        ? 'Good afternoon'

        : 'Good evening';



// NEW: when live Copilot context is available, prefer a greeting
// grounded in the user's actual current career/progress (a pending
// Next Best Action, or a strong readiness score) over the generic
// streak-based messages below. If context is null, or has nothing
// worth surfacing, this falls straight through to the exact original
// cascade — so every existing call site (which doesn't pass context)
// behaves identically to before.
if (context != null) {
  final pending = context.pendingActions;
  if (pending.isNotEmpty) {
    final action = pending.first;
    final careerTitle = context.career?.careerTitle ?? levelTitle;
    return '$timeGreet, $firstName! For $careerTitle, next up: "${action.title}".';
  }
  if (context.readiness.overallScore >= 0.85) {
    final careerTitle = context.career?.careerTitle ?? levelTitle;
    return '$timeGreet, $firstName! 🚀 You\'re "${context.readiness.readinessLabel}" for $careerTitle — keep pushing.';
  }
}

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

CopilotContext? context,

}) async {

final prefs = await SharedPreferences.getInstance();

final todayKey = 'advice_${_todayKey()}';

final cached = prefs.getString(todayKey);

if (cached != null && cached.isNotEmpty) return cached;



final advice = _pickAdvice(state: state, levelTitle: levelTitle, context: context);

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

CopilotContext? context,

}) {

// NEW: prefer advice grounded in a real active recommendation or
// pending action from live Copilot context, when one exists. Falls
// back to the exact original deterministic pool rotation when context
// is null or has nothing pending — identical behaviour to before for
// every existing call site.
if (context != null) {
  final activeRecs = context.activeRecommendations;
  if (activeRecs.isNotEmpty) {
    return '💡 ${activeRecs.first.description}';
  }
  final pending = context.pendingActions;
  if (pending.isNotEmpty) {
    return '🎯 ${pending.first.description}';
  }
}

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

// ════════════════════════════════════════════════════════════════════
// ─── EVERYTHING BELOW THIS LINE IS NEW ───────────────────────────────
//
// Turns AI Memory into a permanent, user-specific Career Journey
// Memory built on top of the existing CopilotContext /
// CopilotFirestoreService — no new course/job/project databases, no
// paid AI/API calls, no network access beyond the same Firestore
// already used above.
//
// Design:
//  • The top-level `ai_memory/{uid}` doc keeps a lightweight SUMMARY of
//    the user's CURRENT career + progress (counts and scores only — the
//    authoritative lesson/project/job/interview id lists already live
//    in CopilotFirestoreService's collections and are never duplicated
//    here). This summary is safe to overwrite on every sync since it's
//    explicitly a derived snapshot, not raw history.
//  • `ai_memory/{uid}/careers/{careerId}` stores that SAME summary but
//    scoped permanently per career. Switching the user's current career
//    only ever writes to that career's own doc — a previous career's
//    remembered progress is never touched, overwritten, or deleted.
//  • `careerHistoryIds` (arrayUnion) and `careerSwitchLog` (arrayUnion)
//    on the top-level doc give a permanent, append-only record of every
//    career the user has ever selected, in order.
// ════════════════════════════════════════════════════════════════════

/// Builds the lightweight, duplication-free progress summary persisted
/// both at the top level and per-career. Counts/scores only — never the
/// raw id lists, which already live safely in CopilotFirestoreService.
Map<String, dynamic> _summaryFromContext(CopilotContext context) {
  final learning = context.learningProgress;
  final project = context.projectProgress;
  final job = context.jobProgress;
  final interview = context.interviewProgress;
  final readiness = context.readiness;

  return {
    'careerId': context.career?.careerId,
    'careerTitle': context.career?.careerTitle,
    'skillNames': context.state.skillProfile?.skillNames ?? <String>[],
    'skillGapNames':
        context.state.skillGaps.map((g) => g.skillName).toList(),
    'learning': {
      'careerId': learning.careerId,
      'completedCount': learning.completedCount,
      'totalLessons': learning.totalLessons,
      'progress': learning.progress,
    },
    'project': {
      'completedCount': project.completedCount,
      'totalProjects': project.totalProjects,
      'progress': project.progress,
    },
    'job': {
      'applicationsSent': job.applicationsSent,
      'savedCount': job.savedJobIds.length,
      'offersReceived': job.offersReceived,
    },
    'interview': {
      'completedCount': interview.completedInterviewIds.length,
      'mockInterviewsDone': interview.mockInterviewsDone,
      'averageScore': interview.averageScore,
    },
    'readiness': {
      'overall': readiness.overallScore,
      'skill': readiness.skillReadiness,
      'learning': readiness.learningReadiness,
      'project': readiness.projectReadiness,
      'interview': readiness.interviewReadiness,
      'job': readiness.jobReadiness,
      'label': readiness.readinessLabel,
    },
    'xp': context.state.totalXp,
    'streak': context.state.currentStreak,
    'pendingActionsCount': context.pendingActions.length,
    'activeRecommendationsCount': context.activeRecommendations.length,
    'updatedAt': DateTime.now().toIso8601String(),
  };
}

/// Persists a snapshot of [context] into permanent Career Journey
/// Memory: the current-state summary at the top level, AND a
/// permanently-scoped copy under `careers/{careerId}` so switching
/// careers never loses or overwrites a previous career's remembered
/// progress. Safe to call as often as needed (e.g. after
/// CopilotController.refreshIntelligence).
Future<void> syncFromCopilotContext(String uid, CopilotContext context) async {
  final summary = _summaryFromContext(context);
  final careerId = context.career?.careerId;

  await _db.collection('ai_memory').doc(uid).set({
    ...summary,
    if (careerId != null && careerId.isNotEmpty)
      'careerHistoryIds': FieldValue.arrayUnion([careerId]),
  }, SetOptions(merge: true));

  if (careerId != null && careerId.isNotEmpty) {
    await _db
        .collection('ai_memory')
        .doc(uid)
        .collection('careers')
        .doc(careerId)
        .set(summary, SetOptions(merge: true));
  }
}

/// Convenience: loads the user's current [CopilotContext] via
/// [CopilotFirestoreService] and syncs memory from it in one call. Never
/// throws — a failure here is swallowed and simply leaves memory
/// unchanged, since memory sync is a best-effort enrichment, never a
/// requirement for the rest of the app to keep working.
Future<void> refreshFromCopilot(String uid, {String? careerId}) async {
  try {
    final context =
        await CopilotFirestoreService.getCopilotContext(uid, careerId: careerId);
    await syncFromCopilotContext(uid, context);
  } catch (_) {
    // Best-effort only — swallow and leave existing memory untouched.
  }
}

/// Records that the user's current career changed. Appends to the
/// permanent, ordered `careerHistoryIds` / `careerSwitchLog` arrays
/// (never removes a prior entry) and updates the top-level "current
/// career" pointer — the OLD career's own `careers/{oldCareerId}` doc is
/// left completely untouched, so its remembered progress stays intact
/// and separate.
Future<void> recordCareerSwitch(
  String uid, {
  required String careerId,
  required String careerTitle,
}) async {
  await _db.collection('ai_memory').doc(uid).set({
    'currentCareerId': careerId,
    'currentCareerTitle': careerTitle,
    'careerHistoryIds': FieldValue.arrayUnion([careerId]),
    'careerSwitchLog': FieldValue.arrayUnion(
      ['$careerId@${DateTime.now().toIso8601String()}'],
    ),
  }, SetOptions(merge: true));
}

/// Reads the permanent, career-scoped memory snapshot for [careerId] —
/// safe even if the user has since switched to a different career,
/// since each career's doc is only ever written by that same career's
/// own [syncFromCopilotContext] calls.
Future<Map<String, dynamic>?> getCareerSnapshot(
  String uid,
  String careerId,
) async {
  try {
    final doc = await _db
        .collection('ai_memory')
        .doc(uid)
        .collection('careers')
        .doc(careerId)
        .get();
    if (!doc.exists || doc.data() == null) return null;
    return doc.data();
  } catch (_) {
    return null;
  }
}

/// Returns every careerId the user has ever selected, oldest-write-order
/// preserved by Firestore's arrayUnion semantics — the full Career
/// Journey at a glance, without touching any per-career snapshot.
Future<List<String>> getCareerHistoryIds(String uid) async {
  try {
    final doc = await _db.collection('ai_memory').doc(uid).get();
    if (!doc.exists || doc.data() == null) return [];
    final raw = doc.data()!['careerHistoryIds'] as List<dynamic>? ?? [];
    return raw.map((e) => e.toString()).toList();
  } catch (_) {
    return [];
  }
}

}

extension on DateTime {

int get dayOfYear {

return difference(DateTime(year, 1, 1)).inDays;

}

}