// ══════════════════════════════════════════════════════════════════════
// lib/services/ai_memory_service.dart
// AI Memory: stores context, generates personalized greetings/advice.
// Uses existing Firebase, does NOT touch CopilotController.
//
// FINAL OPTIMIZATION PASS (this revision):
//   • Authoritative stats (users/{uid}.totalXp, users/{uid}.dailyStreak)
//     are now read through a short-lived per-uid in-memory cache.
//     Repeated syncFromCopilotContext() calls within the TTL window
//     reuse the cached value and skip Firestore entirely — so a normal
//     Copilot refresh does NOT pay the cost of reading users/{uid} and
//     ai_memory/{uid} on every call.
//   • If the fresh authoritative read fails:
//       - a stale cached value is served (never regressed, never
//         invented);
//       - on a true cold start (no cache), one best-effort read of the
//         previously stored ai_memory/{uid} snapshot is used so the value
//         never silently regresses below what was already recorded.
//   • The stored-stats read is only used as a cold-start fallback, not
//     as a routine per-sync read.
//   • Safe career-doc IDs: the per-career document path
//     ai_memory/{uid}/careers/{careerId} now uses the same safe /
//     normalised document-id strategy as CopilotFirestoreService
//     (short ASCII IDs pass through unchanged; oversized or forbidden
//     IDs are deterministically escaped + hashed). The same helper is
//     applied on write AND read, so existing normal IDs such as
//     'ai_engineer', 'software_engineer', 'data_scientist' resolve to
//     the same documents byte-for-byte.
//   • The logical careerId stored INSIDE the summary is unchanged (raw),
//     and careerHistoryIds / careerSwitchLog continue to hold the raw
//     careerId. Only the Firestore document path is normalised.
//   • All previous behaviours preserved: greeting/advice cache keys,
//     context-signature refresh, careerHistoryIds / careerSwitchLog
//     append-only, no fake career buckets, best-effort failures never
//     erase memory and never break the user experience.
//
// ARCHITECTURE (unchanged):
//   User Action
//     → Authoritative Firestore Evidence/Event
//     → Progress/XP/Readiness
//     → CopilotController
//     → CopilotContext
//     → AiMemoryService summary
//     → Personalized greeting/advice
//   This service is a MEMORY/SUMMARY layer only. The source of truth
//   remains CopilotFirestoreService / existing authoritative services.
// ══════════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quest_models.dart';    // AiMemory is defined there
import '../models/copilot_models.dart';
import 'copilot_firestore_service.dart';

class AiMemoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── In-memory cache for authoritative stats ────────────────────────
  //
  // Static so the cache survives across the short-lived AiMemoryService
  // instances the app typically creates per call. Keyed by uid, with a
  // short TTL — so back-to-back Copilot refreshes reuse the same read
  // instead of hitting Firestore every time.
  static final Map<String, _AuthoritativeStats> _statsCache = {};
  static const Duration _statsCacheTtl = Duration(minutes: 3);

  // Firestore-safe document id limits, mirrored from the existing
  // CopilotFirestoreService strategy so per-career paths stay
  // consistent across the app.
  static const int _maxDocIdBytes = 1400;

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

  // ── Authoritative stats — cached read ──────────────────────────────
  //
  // Priority per call:
  //   1. Fresh in-memory cache (no Firestore read).
  //   2. Fresh authoritative read from users/{uid}.
  //   3. Stale in-memory cache (never regresses the value).
  //   4. Cold-start best-effort read of ai_memory/{uid} so the value
  //      never silently regresses below what was already recorded.
  //
  // This service never writes to users/{uid} and never treats its own
  // memory as authoritative.
  Future<_AuthoritativeStats?> _resolveAuthoritativeStats(String uid) async {
    final now = DateTime.now();
    final cached = _statsCache[uid];

    // 1) Fresh cache — zero Firestore reads.
    if (cached != null &&
        now.difference(cached.fetchedAt) < _statsCacheTtl) {
      return cached;
    }

    // 2) Attempt a single authoritative read.
    final fresh = await _readAuthoritativeStats(uid);
    if (fresh != null) {
      _statsCache[uid] = fresh;
      return fresh;
    }

    // 3) Read failed — serve the stale cached value if we have one.
    if (cached != null) {
      return cached;
    }

    // 4) True cold start with a failed authoritative read — one
    //    best-effort fallback to the previously stored snapshot so we
    //    never silently regress XP/streak to 0 or below the recorded
    //    value. Cached with a normal fetchedAt so the next call within
    //    the TTL window reuses it without another read.
    final stored = await _readStoredStats(uid);
    if (stored != null) {
      final entry = _AuthoritativeStats(
        totalXp: stored.xp,
        dailyStreak: stored.streak,
        fetchedAt: now,
      );
      _statsCache[uid] = entry;
      return entry;
    }

    return null;
  }

  /// Reads users/{uid}.totalXp and users/{uid}.dailyStreak. Read-only.
  /// Never throws — returns null on failure or if neither field exists.
  Future<_AuthoritativeStats?> _readAuthoritativeStats(String uid) async {
    try {
      final snap = await _db.collection('users').doc(uid).get();
      if (!snap.exists || snap.data() == null) return null;
      final data = snap.data()!;

      final totalXp =
          data['totalXp'] is num ? (data['totalXp'] as num).toInt() : null;
      final dailyStreak = data['dailyStreak'] is num
          ? (data['dailyStreak'] as num).toInt()
          : null;

      if (totalXp == null && dailyStreak == null) return null;
      return _AuthoritativeStats(
        totalXp: totalXp,
        dailyStreak: dailyStreak,
        fetchedAt: DateTime.now(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Reads the previously stored streak/xp from ai_memory/{uid} — used
  /// ONLY as a cold-start fallback when the authoritative read fails and
  /// no in-memory cache exists. Best-effort; never throws.
  Future<_StoredStats?> _readStoredStats(String uid) async {
    try {
      final doc = await _db.collection('ai_memory').doc(uid).get();
      if (!doc.exists || doc.data() == null) return null;
      final data = doc.data()!;

      final streak =
          data['streak'] is num ? (data['streak'] as num).toInt() : null;
      final xp = data['xp'] is num ? (data['xp'] as num).toInt() : null;

      if (streak == null && xp == null) return null;
      return _StoredStats(streak: streak, xp: xp);
    } catch (_) {
      return null;
    }
  }

  // ── Safe Firestore document-id for the per-career path ─────────────
  //
  // Mirrors CopilotFirestoreService's safe-id strategy so per-career
  // documents stay on consistent paths across the app. Short, ASCII-safe
  // ids pass through UNCHANGED (so 'ai_engineer', 'software_engineer',
  // 'data_scientist' resolve to the exact same documents as before).
  // Oversized or forbidden ids are replaced with a deterministic
  // escaped+hased form that stays within Firestore's byte limit and
  // cannot collide with any other input.
  static String _safeCareerDocId(String careerId) {
    final t = careerId.trim();
    if (t.isEmpty) return '';

    final utf8Len = _utf8ByteLength(t);
    if (utf8Len <= _maxDocIdBytes && !_needsEscaping(t)) {
      return t;
    }

    final digest = _stableHashHex(t);
    const prefixLen = 24;
    final prefix = t.length <= prefixLen ? t : t.substring(0, prefixLen);
    final safePrefix = _escapeForDocId(prefix);
    return '$safePrefix~$digest';
  }

  static bool _needsEscaping(String s) {
    for (final rune in s.runes) {
      if (rune == 0x2F) return true;      // '/'
      if (rune < 0x20) return true;       // control chars
      if (rune == 0x7F) return true;      // DEL
    }
    return false;
  }

  static String _escapeForDocId(String s) {
    final buf = StringBuffer();
    for (final rune in s.runes) {
      if (rune == 0x2F) {
        buf.write('%2F');
      } else if (rune < 0x20 || rune == 0x7F) {
        buf.write('%');
        buf.write(rune.toRadixString(16).padLeft(2, '0').toUpperCase());
      } else {
        buf.writeCharCode(rune);
      }
    }
    return buf.toString();
  }

  static int _utf8ByteLength(String s) {
    var n = 0;
    for (final rune in s.runes) {
      if (rune <= 0x7F) {
        n += 1;
      } else if (rune <= 0x7FF) {
        n += 2;
      } else if (rune <= 0xFFFF) {
        n += 3;
      } else {
        n += 4;
      }
    }
    return n;
  }

  static String _stableHashHex(String s) {
    var hash = BigInt.parse('0xcbf29ce484222325');
    final prime = BigInt.parse('0x100000001b3');
    final mask = BigInt.parse('0xFFFFFFFFFFFFFFFF');
    for (final codeUnit in s.codeUnits) {
      hash = (hash ^ BigInt.from(codeUnit)) & mask;
      hash = (hash * prime) & mask;
    }
    return hash.toRadixString(16).padLeft(16, '0');
  }

  // ── Generate personalized greeting (cached to SharedPreferences) ───
  //
  // Cache key includes a lightweight "context signature" derived from the
  // current top pending action id and top active recommendation id (or
  // 'none'). This lets a newly changed high-priority Copilot action
  // refresh the same day's greeting without extra Firestore reads, while
  // keeping the cache key stable across normal re-renders.
  Future<String> getDailyGreeting({
    required String displayName,
    required AiMemory memory,
    required CopilotState state,
    required int level,
    required String levelTitle,
    CopilotContext? context,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey =
        'greeting_${_todayKey()}_${_contextSignature(context)}';
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

    // Context-aware greeting — prefers a real pending action or strong
    // readiness score over the generic streak-based messages below.
    // Falls straight through when context is null or empty, so every
    // existing caller that doesn't pass context behaves identically.
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

    // Context-aware messages based on state.
    if (state.currentStreak >= 30) {
      return '$timeGreet, $firstName! 🔥 ${state.currentStreak} days straight — you\'re in rare company. Keep the fire alive today.';
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
    final todayKey =
        'advice_${_todayKey()}_${_contextSignature(context)}';
    final cached = prefs.getString(todayKey);
    if (cached != null && cached.isNotEmpty) return cached;

    final advice = _pickAdvice(
      state: state,
      levelTitle: levelTitle,
      context: context,
    );
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
    // Prefer advice grounded in a real active recommendation or pending
    // action from live Copilot context when one exists. Falls back to
    // the exact original deterministic pool rotation when context is
    // null or has nothing pending.
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

    // Simple deterministic rotation based on day of year.
    final idx = DateTime.now().dayOfYear % _advicePool.length;
    return _advicePool[idx];
  }

  /// Lightweight signature for greeting/advice cache keys.
  ///
  /// Derived from the top pending action id and the top active
  /// recommendation id (or '' when unavailable). This lets a newly
  /// changed high-priority Copilot action refresh the same day's greeting
  /// or advice without extra Firestore reads, while keeping the cache key
  /// stable across normal re-renders.
  String _contextSignature(CopilotContext? context) {
    if (context == null) return 'none';
    final topActionId = context.pendingActions.isNotEmpty
        ? context.pendingActions.first.id
        : '';
    final topRecId = context.activeRecommendations.isNotEmpty
        ? context.activeRecommendations.first.id
        : '';
    return '${topActionId}_$topRecId'.hashCode.toString();
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
  // ─── EVERYTHING BELOW THIS LINE IS NEW ──────────────────────────────
  //
  // Turns AI Memory into a permanent, user-specific Career Journey
  // Memory built on top of the existing CopilotContext /
  // CopilotFirestoreService. No new course/job/project databases, no
  // paid AI/API calls, no network access beyond the same Firestore
  // already used above.
  //
  // Design:
  //  • The top-level `ai_memory/{uid}` doc keeps a lightweight SUMMARY of
  //    the user's CURRENT career + progress (counts and scores only — the
  //    authoritative lesson/project/job/interview id lists already live
  //    in CopilotFirestoreService's collections and are never duplicated
  //    here). Safe to overwrite on every sync.
  //  • `ai_memory/{uid}/careers/{careerDocId}` stores that SAME summary
  //    but scoped permanently per career. The careerDocId is the
  //    normalised form of careerId (see _safeCareerDocId). For all
  //    current normal ids ('ai_engineer', 'software_engineer', ...) the
  //    normalisation is a no-op, so existing per-career documents keep
  //    resolving to the same paths. Switching the user's current career
  //    only ever writes to that career's own doc — a previous career's
  //    remembered progress is never touched, overwritten, or deleted.
  //  • `careerHistoryIds` (arrayUnion) and `careerSwitchLog` (arrayUnion)
  //    on the top-level doc give an append-only record of every career
  //    the user has ever selected. NOTE: Firestore arrayUnion preserves
  //    append semantics but does NOT guarantee a chronological read
  //    order — treat these as a set with write-order history, not an
  //    ordered log. Both arrays store the RAW careerId, not the
  //    normalised doc id.
  // ════════════════════════════════════════════════════════════════════

  /// Builds the lightweight, duplication-free progress summary persisted
  /// both at the top level and per-career.
  ///
  /// Counts/scores only — never the raw id lists. XP and streak are
  /// resolved with the rules in [_resolveXp] / [_resolveStreak], using
  /// the authoritative stats when available and the current CopilotState
  /// values as a safe fallback.
  Map<String, dynamic> _summaryFromContext(
    CopilotContext context, {
    required _AuthoritativeStats? authoritative,
  }) {
    final learning = context.learningProgress;
    final project = context.projectProgress;
    final job = context.jobProgress;
    final interview = context.interviewProgress;
    final readiness = context.readiness;

    final resolvedXp = _resolveXp(
      computed: context.state.totalXp,
      authoritative: authoritative?.totalXp,
    );

    final resolvedStreak = _resolveStreak(
      computed: context.state.currentStreak,
      authoritative: authoritative?.dailyStreak,
    );

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
      'xp': resolvedXp,
      'streak': resolvedStreak,
      'pendingActionsCount': context.pendingActions.length,
      'activeRecommendationsCount': context.activeRecommendations.length,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// XP resolution rule:
  ///   • authoritative wins when present,
  ///   • otherwise fall back to the current computed value from context.
  ///
  /// The cached authoritative read path already guarantees that a fresh
  /// value is used when available and that a stale-but-known value is
  /// preferred over nothing, so this resolver stays intentionally simple.
  int _resolveXp({required int computed, required int? authoritative}) =>
      authoritative ?? computed;

  /// Streak resolution rule (same as XP).
  int _resolveStreak({required int computed, required int? authoritative}) =>
      authoritative ?? computed;

  /// Persists a snapshot of [context] into permanent Career Journey
  /// Memory: the current-state summary at the top level, AND a
  /// permanently-scoped copy under `careers/{careerDocId}`. Safe to call
  /// as often as needed.
  ///
  /// When the caller supplies no real careerId, only the top-level
  /// summary is updated — a per-career doc is NEVER written under an
  /// invented bucket.
  Future<void> syncFromCopilotContext(String uid, CopilotContext context) async {
    // Authoritative XP/streak — cached, best-effort, never throws.
    // The cache means a normal Copilot refresh does not pay the cost of
    // reading users/{uid} or ai_memory/{uid} on every call.
    final authoritative = await _resolveAuthoritativeStats(uid);

    final summary = _summaryFromContext(
      context,
      authoritative: authoritative,
    );
    final careerId = context.career?.careerId;

    await _db.collection('ai_memory').doc(uid).set({
      ...summary,
      if (careerId != null && careerId.isNotEmpty)
        'careerHistoryIds': FieldValue.arrayUnion([careerId]),
    }, SetOptions(merge: true));

    if (careerId != null && careerId.isNotEmpty) {
      final careerDocId = _safeCareerDocId(careerId);
      if (careerDocId.isNotEmpty) {
        await _db
            .collection('ai_memory')
            .doc(uid)
            .collection('careers')
            .doc(careerDocId)
            .set(summary, SetOptions(merge: true));
      }
    }
  }

  /// Convenience: loads the user's current [CopilotContext] via
  /// [CopilotFirestoreService] and syncs memory from it in one call.
  /// Never throws — a failure here is swallowed and simply leaves memory
  /// unchanged, since memory sync is a best-effort enrichment, never a
  /// requirement for the rest of the app to keep working.
  Future<void> refreshFromCopilot(String uid, {String? careerId}) async {
    try {
      final context = await CopilotFirestoreService.getCopilotContext(
        uid,
        careerId: careerId,
      );
      await syncFromCopilotContext(uid, context);
    } catch (_) {
      // Best-effort only — swallow and leave existing memory untouched.
    }
  }

  /// Records that the user's current career changed. Appends to the
  /// permanent `careerHistoryIds` / `careerSwitchLog` arrays (never
  /// removes a prior entry) and updates the top-level "current career"
  /// pointer — the OLD career's own `careers/{oldCareerDocId}` doc is
  /// left completely untouched, so its remembered progress stays intact
  /// and separate.
  ///
  /// NOTE: Firestore `arrayUnion` preserves append semantics but does not
  /// guarantee a chronological read order; treat these arrays as a set
  /// with write-order history, not an ordered log. The arrays store the
  /// RAW careerId, not the normalised doc id.
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
  ///
  /// The same [_safeCareerDocId] normalisation is applied here and on
  /// write, so a normal id like 'ai_engineer' resolves to the same
  /// document on both sides.
  Future<Map<String, dynamic>?> getCareerSnapshot(
    String uid,
    String careerId,
  ) async {
    try {
      final careerDocId = _safeCareerDocId(careerId);
      if (careerDocId.isEmpty) return null;
      final doc = await _db
          .collection('ai_memory')
          .doc(uid)
          .collection('careers')
          .doc(careerDocId)
          .get();
      if (!doc.exists || doc.data() == null) return null;
      return doc.data();
    } catch (_) {
      return null;
    }
  }

  /// Returns every careerId the user has ever selected, in Firestore's
  /// arrayUnion write-order (append-only). Ordering is not guaranteed to
  /// be strictly chronological.
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

// ── Internal value types (private) ────────────────────────────────────
//
// Kept private to this file so they do not affect any public API or
// existing serialization.

/// Cached snapshot of the user's authoritative XP/streak.
///
/// `fetchedAt` is used by the in-memory cache TTL. Fresh reads set it to
/// 'now'; a stale value served after a failed refresh keeps its original
/// `fetchedAt` so the next call still attempts a fresh read.
class _AuthoritativeStats {
  final int? totalXp;
  final int? dailyStreak;
  final DateTime fetchedAt;

  const _AuthoritativeStats({
    this.totalXp,
    this.dailyStreak,
    required this.fetchedAt,
  });
}

/// Snapshot read from ai_memory/{uid} — used ONLY as a cold-start fallback
/// when the authoritative read fails and no cache is available.
class _StoredStats {
  final int? streak;
  final int? xp;

  const _StoredStats({this.streak, this.xp});
}