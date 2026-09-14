// ══════════════════════════════════════════════════════════════════════════════
// lib/features/copilot/services/copilot_firestore_service.dart
// Firestore CRUD for every copilot collection.
// ══════════════════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/copilot_models.dart';

class CopilotFirestoreService {
  static final FirebaseFirestore _db  = FirebaseFirestore.instance;
  static final FirebaseAuth      _auth = FirebaseAuth.instance;

  // ── helpers ────────────────────────────────────────────────────────────────

  static DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  // ── Skill Profile ──────────────────────────────────────────────────────────

  static Future<void> saveSkillProfile(UserSkillProfile profile) =>
      _userDoc(profile.uid)
          .collection('copilot')
          .doc('skill_profile')
          .set(profile.toFirestore());

  static Future<UserSkillProfile?> getSkillProfile(String uid) async {
    final snap = await _userDoc(uid)
        .collection('copilot')
        .doc('skill_profile')
        .get();
    if (!snap.exists || snap.data() == null) return null;
    return UserSkillProfile.fromFirestore(snap.data()!);
  }

  static Stream<UserSkillProfile?> skillProfileStream(String uid) =>
      _userDoc(uid)
          .collection('copilot')
          .doc('skill_profile')
          .snapshots()
          .map((s) =>
              s.exists && s.data() != null
                  ? UserSkillProfile.fromFirestore(s.data()!)
                  : null);

  // ── Skill Gaps ─────────────────────────────────────────────────────────────

  static Future<void> saveSkillGaps(String uid, List<SkillGap> gaps) async {
    final batch = _db.batch();
    final col = _userDoc(uid).collection('copilot_skill_gaps');

    // delete old docs
    final existing = await col.get();
    for (final d in existing.docs) {
      batch.delete(d.reference);
    }
    for (int i = 0; i < gaps.length; i++) {
      batch.set(col.doc('gap_$i'), gaps[i].toFirestore());
    }
    await batch.commit();
  }

  static Future<List<SkillGap>> getSkillGaps(String uid) async {
    final snap = await _userDoc(uid)
        .collection('copilot_skill_gaps')
        .orderBy('priority')
        .get();
    return snap.docs.map((d) => SkillGap.fromFirestore(d.data())).toList();
  }

  // ── Personalized Roadmap ───────────────────────────────────────────────────

  static Future<void> saveRoadmap(PersonalizedRoadmap roadmap) =>
      _userDoc(roadmap.uid)
          .collection('copilot')
          .doc('roadmap')
          .set(roadmap.toFirestore());

  static Future<PersonalizedRoadmap?> getRoadmap(String uid) async {
    final snap =
        await _userDoc(uid).collection('copilot').doc('roadmap').get();
    if (!snap.exists || snap.data() == null) return null;
    return PersonalizedRoadmap.fromFirestore(snap.data()!);
  }

  static Stream<PersonalizedRoadmap?> roadmapStream(String uid) =>
      _userDoc(uid)
          .collection('copilot')
          .doc('roadmap')
          .snapshots()
          .map((s) =>
              s.exists && s.data() != null
                  ? PersonalizedRoadmap.fromFirestore(s.data()!)
                  : null);

  static Future<void> completeRoadmapPhase(
      String uid, int phaseIndex) async {
    final doc = _userDoc(uid).collection('copilot').doc('roadmap');
    final snap = await doc.get();
    if (!snap.exists || snap.data() == null) return;

    final roadmap = PersonalizedRoadmap.fromFirestore(snap.data()!);
    if (phaseIndex >= roadmap.phases.length) return;

    final phases = roadmap.phases.map((p) {
      if (p.phaseNumber == phaseIndex) {
        return RoadmapPhase(
          phaseNumber: p.phaseNumber,
          title: p.title,
          description: p.description,
          skills: p.skills,
          resources: p.resources,
          estimatedDuration: p.estimatedDuration,
          isCompleted: true,
          isUnlocked: p.isUnlocked,
        );
      }
      if (p.phaseNumber == phaseIndex + 1) {
        return RoadmapPhase(
          phaseNumber: p.phaseNumber,
          title: p.title,
          description: p.description,
          skills: p.skills,
          resources: p.resources,
          estimatedDuration: p.estimatedDuration,
          isCompleted: p.isCompleted,
          isUnlocked: true,
        );
      }
      return p;
    }).toList();

    await doc.set(
      roadmap.copyWith(phases: phases, currentPhaseIndex: phaseIndex + 1)
          .toFirestore(),
    );
  }

  // ── Daily Goals ────────────────────────────────────────────────────────────

  static String _todayKey() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  static Future<void> saveDailyGoals(
      String uid, List<DailyGoal> goals) async {
    final batch = _db.batch();
    for (final g in goals) {
      batch.set(
        _userDoc(uid).collection('copilot_daily_goals').doc(g.id),
        g.toFirestore(),
      );
    }
    await batch.commit();
  }

  static Future<List<DailyGoal>> getTodayGoals(String uid) async {
    final snap = await _userDoc(uid)
        .collection('copilot_daily_goals')
        .where('date', isEqualTo: _todayKey())
        .get();
    return snap.docs.map((d) => DailyGoal.fromFirestore(d.data())).toList();
  }

  static Stream<List<DailyGoal>> todayGoalsStream(String uid) =>
      _userDoc(uid)
          .collection('copilot_daily_goals')
          .where('date', isEqualTo: _todayKey())
          .snapshots()
          .map((s) =>
              s.docs.map((d) => DailyGoal.fromFirestore(d.data())).toList());

  static Future<void> toggleGoalCompletion(
      String uid, DailyGoal goal) async {
    await _userDoc(uid)
        .collection('copilot_daily_goals')
        .doc(goal.id)
        .update({'isCompleted': !goal.isCompleted});
  }

  // ── Progress ───────────────────────────────────────────────────────────────

  static Future<void> syncTodayProgress(
      String uid, List<DailyGoal> todayGoals) async {
    final today    = _todayKey();
    final completed = todayGoals.where((g) => g.isCompleted).toList();
    final xp = completed.fold(0, (sum, g) => sum + g.xpReward);
    final completedSkills = completed
        .where((g) => g.linkedSkill != null)
        .map((g) => g.linkedSkill!)
        .toList();

    final data = ProgressEntry(
      id: '${uid}_$today',
      uid: uid,
      date: DateTime.now(),
      xpEarned: xp,
      goalsCompleted: completed.length,
      totalGoals: todayGoals.length,
      completedSkills: completedSkills,
    ).toFirestore();

    await _userDoc(uid)
        .collection('copilot_progress')
        .doc('${uid}_$today')
        .set(data, SetOptions(merge: true));
  }

  static Future<List<ProgressEntry>> getProgressHistory(
      String uid, {int limit = 30}) async {
    final snap = await _userDoc(uid)
        .collection('copilot_progress')
        .orderBy('date', descending: true)
        .limit(limit)
        .get();
    return snap.docs
        .map((d) => ProgressEntry.fromFirestore(d.data()))
        .toList();
  }

  static Stream<List<ProgressEntry>> progressStream(String uid) {
    final sevenAgo =
        DateTime.now().subtract(const Duration(days: 7)).toIso8601String();
    return _userDoc(uid)
        .collection('copilot_progress')
        .where('date', isGreaterThan: sevenAgo)
        .orderBy('date', descending: false)
        .snapshots()
        .map((s) =>
            s.docs.map((d) => ProgressEntry.fromFirestore(d.data())).toList());
  }

  // ════════════════════════════════════════════════════════════════════════
  // ─── EVERYTHING BELOW THIS LINE IS NEW ─────────────────────────────────
  //
  // Nothing above this line was changed: every existing method, collection
  // name, document path, and field is untouched, so all current callers and
  // previously written Firestore documents keep working exactly as before.
  //
  // Design notes:
  //  • Singleton "current state" docs (career context, job/project/interview
  //    progress snapshots, readiness) live under the SAME 'copilot'
  //    subcollection that already holds 'skill_profile' and 'roadmap', using
  //    set(..., SetOptions(merge: true)) so writing new fields never drops
  //    fields the doc doesn't know about yet, and reading an old doc that
  //    lacks these fields never throws (every *.fromFirestore below already
  //    has safe defaults from copilot_models.dart).
  //  • Learning progress is keyed by careerId (its own top-level collection)
  //    because LearningProgressContext carries a careerId field — this keeps
  //    a separate, permanent lesson-completion history PER career, so
  //    switching careers never loses or overwrites another career's progress.
  //  • Anything that represents a user's PAST ACTIVITY — completed lessons,
  //    completed projects, applied jobs, completed interviews, Next Best
  //    Actions, and Recommendations — is only ever appended to
  //    (FieldValue.arrayUnion, new doc per item, or isCompleted/isDismissed
  //    flags). Nothing here ever deletes or truncates that history.
  //  • CareerReadiness is explicitly a derived/recomputed snapshot (see the
  //    comment on the model itself), so overwriting it on every recompute is
  //    correct and does not count as "erasing history".
  // ════════════════════════════════════════════════════════════════════════

  /// Shared helper for the singleton "current state" docs that live
  /// alongside 'skill_profile' and 'roadmap' in the existing 'copilot'
  /// subcollection (career_context, project_progress, job_progress,
  /// interview_progress, readiness).
  static DocumentReference<Map<String, dynamic>> _copilotDoc(
          String uid, String docId) =>
      _userDoc(uid).collection('copilot').doc(docId);

  // ── Career Context ──────────────────────────────────────────────────────

  static Future<void> saveCareerContext(String uid, CareerContext career) =>
      _copilotDoc(uid, 'career_context')
          .set(career.toFirestore(), SetOptions(merge: true));

  static Future<CareerContext?> getCareerContext(String uid) async {
    final snap = await _copilotDoc(uid, 'career_context').get();
    if (!snap.exists || snap.data() == null) return null;
    return CareerContext.fromFirestore(snap.data()!);
  }

  static Stream<CareerContext?> careerContextStream(String uid) =>
      _copilotDoc(uid, 'career_context').snapshots().map((s) =>
          s.exists && s.data() != null
              ? CareerContext.fromFirestore(s.data()!)
              : null);

  // ── Learning Progress (per career — permanent per-career history) ───────

  static DocumentReference<Map<String, dynamic>> _learningProgressDoc(
          String uid, String careerId) =>
      _userDoc(uid).collection('copilot_learning_progress').doc(careerId);

  static Future<void> saveLearningProgress(
          String uid, LearningProgressContext progress) =>
      _learningProgressDoc(uid, progress.careerId)
          .set(progress.toFirestore(), SetOptions(merge: true));

  static Future<LearningProgressContext?> getLearningProgress(
      String uid, String careerId) async {
    final snap = await _learningProgressDoc(uid, careerId).get();
    if (!snap.exists || snap.data() == null) return null;
    return LearningProgressContext.fromFirestore(snap.data()!);
  }

  static Stream<LearningProgressContext?> learningProgressStream(
          String uid, String careerId) =>
      _learningProgressDoc(uid, careerId).snapshots().map((s) =>
          s.exists && s.data() != null
              ? LearningProgressContext.fromFirestore(s.data()!)
              : null);

  /// Appends one completed lesson id to permanent per-career history via
  /// arrayUnion (never overwrites previously completed lessons), and
  /// merge-updates the light metadata fields alongside it. Works whether or
  /// not the doc already exists.
  static Future<void> appendCompletedLesson(
    String uid, {
    required String careerId,
    required String lessonId,
    int? totalLessons,
    String? currentLevelTitle,
  }) async {
    final data = <String, dynamic>{
      'careerId': careerId,
      'completedLessonIds': FieldValue.arrayUnion([lessonId]),
      'lastLessonId': lessonId,
      'updatedAt': DateTime.now().toIso8601String(),
    };
    if (totalLessons != null) data['totalLessons'] = totalLessons;
    if (currentLevelTitle != null) data['currentLevelTitle'] = currentLevelTitle;
    await _learningProgressDoc(uid, careerId)
        .set(data, SetOptions(merge: true));
  }

  // ── Project Progress (singleton snapshot; history is append-only) ───────

  static Future<void> saveProjectProgress(
          String uid, ProjectProgressContext progress) =>
      _copilotDoc(uid, 'project_progress')
          .set(progress.toFirestore(), SetOptions(merge: true));

  static Future<ProjectProgressContext?> getProjectProgress(
      String uid) async {
    final snap = await _copilotDoc(uid, 'project_progress').get();
    if (!snap.exists || snap.data() == null) return null;
    return ProjectProgressContext.fromFirestore(snap.data()!);
  }

  static Stream<ProjectProgressContext?> projectProgressStream(
          String uid) =>
      _copilotDoc(uid, 'project_progress').snapshots().map((s) =>
          s.exists && s.data() != null
              ? ProjectProgressContext.fromFirestore(s.data()!)
              : null);

  /// Appends one completed project id via arrayUnion. Never overwrites
  /// previously completed projects.
  static Future<void> appendCompletedProject(
    String uid,
    String projectId, {
    int? totalProjects,
    String? currentProjectId,
  }) async {
    final data = <String, dynamic>{
      'completedProjectIds': FieldValue.arrayUnion([projectId]),
      'updatedAt': DateTime.now().toIso8601String(),
    };
    if (totalProjects != null) data['totalProjects'] = totalProjects;
    if (currentProjectId != null) data['currentProjectId'] = currentProjectId;
    await _copilotDoc(uid, 'project_progress')
        .set(data, SetOptions(merge: true));
  }

  // ── Job Progress (singleton snapshot; history is append-only) ───────────

  static Future<void> saveJobProgress(String uid, JobProgressContext progress) =>
      _copilotDoc(uid, 'job_progress')
          .set(progress.toFirestore(), SetOptions(merge: true));

  static Future<JobProgressContext?> getJobProgress(String uid) async {
    final snap = await _copilotDoc(uid, 'job_progress').get();
    if (!snap.exists || snap.data() == null) return null;
    return JobProgressContext.fromFirestore(snap.data()!);
  }

  static Stream<JobProgressContext?> jobProgressStream(String uid) =>
      _copilotDoc(uid, 'job_progress').snapshots().map((s) =>
          s.exists && s.data() != null
              ? JobProgressContext.fromFirestore(s.data()!)
              : null);

  /// Appends one applied-job id via arrayUnion. Never overwrites previously
  /// applied jobs.
  static Future<void> appendAppliedJob(String uid, String jobId) async {
    await _copilotDoc(uid, 'job_progress').set({
      'appliedJobIds': FieldValue.arrayUnion([jobId]),
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  /// Appends one saved-job id via arrayUnion. Never removes previously
  /// saved jobs.
  static Future<void> appendSavedJob(String uid, String jobId) async {
    await _copilotDoc(uid, 'job_progress').set({
      'savedJobIds': FieldValue.arrayUnion([jobId]),
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  /// Atomically increments the offers-received counter — a running total,
  /// never reset.
  static Future<void> incrementJobOffers(String uid, {int by = 1}) async {
    await _copilotDoc(uid, 'job_progress').set({
      'offersReceived': FieldValue.increment(by),
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  // ── Interview Progress (singleton snapshot; history is append-only) ─────

  static Future<void> saveInterviewProgress(
          String uid, InterviewProgressContext progress) =>
      _copilotDoc(uid, 'interview_progress')
          .set(progress.toFirestore(), SetOptions(merge: true));

  static Future<InterviewProgressContext?> getInterviewProgress(
      String uid) async {
    final snap = await _copilotDoc(uid, 'interview_progress').get();
    if (!snap.exists || snap.data() == null) return null;
    return InterviewProgressContext.fromFirestore(snap.data()!);
  }

  static Stream<InterviewProgressContext?> interviewProgressStream(
          String uid) =>
      _copilotDoc(uid, 'interview_progress').snapshots().map((s) =>
          s.exists && s.data() != null
              ? InterviewProgressContext.fromFirestore(s.data()!)
              : null);

  /// Appends one completed interview id to permanent history and folds the
  /// optional score into the running average. The weighted-average math
  /// needs the prior count/average, so this does a safe read-modify-write
  /// via the model's own `withInterviewCompleted` helper (which itself only
  /// ever appends to `completedInterviewIds`, never drops entries) rather
  /// than a blind overwrite.
  static Future<void> appendCompletedInterview(
    String uid,
    String interviewId, {
    double? score,
  }) async {
    final ref = _copilotDoc(uid, 'interview_progress');
    final snap = await ref.get();
    final current = (snap.exists && snap.data() != null)
        ? InterviewProgressContext.fromFirestore(snap.data()!)
        : InterviewProgressContext(updatedAt: DateTime.now());
    final updated = current.withInterviewCompleted(interviewId, score: score);
    await ref.set(updated.toFirestore(), SetOptions(merge: true));
  }

  // ── Career Readiness (derived snapshot — safe to recompute/overwrite) ───

  static Future<void> saveCareerReadiness(
          String uid, CareerReadiness readiness) =>
      _copilotDoc(uid, 'readiness')
          .set(readiness.toFirestore(), SetOptions(merge: true));

  static Future<CareerReadiness?> getCareerReadiness(String uid) async {
    final snap = await _copilotDoc(uid, 'readiness').get();
    if (!snap.exists || snap.data() == null) return null;
    return CareerReadiness.fromFirestore(snap.data()!);
  }

  static Stream<CareerReadiness?> careerReadinessStream(String uid) =>
      _copilotDoc(uid, 'readiness').snapshots().map((s) =>
          s.exists && s.data() != null
              ? CareerReadiness.fromFirestore(s.data()!)
              : null);

  // ── Next Best Actions (append-only; completed actions stay as history) ──

  static Future<void> saveNextAction(String uid, NextBestAction action) =>
      _userDoc(uid)
          .collection('copilot_next_actions')
          .doc(action.id)
          .set(action.toFirestore(), SetOptions(merge: true));

  static Future<List<NextBestAction>> getNextActions(
    String uid, {
    bool onlyPending = false,
  }) async {
    Query<Map<String, dynamic>> q =
        _userDoc(uid).collection('copilot_next_actions');
    if (onlyPending) q = q.where('isCompleted', isEqualTo: false);
    final snap = await q.get();
    final actions =
        snap.docs.map((d) => NextBestAction.fromFirestore(d.data())).toList();
    actions.sort((a, b) => a.priority.compareTo(b.priority));
    return actions;
  }

  static Stream<List<NextBestAction>> nextActionsStream(
    String uid, {
    bool onlyPending = false,
  }) {
    Query<Map<String, dynamic>> q =
        _userDoc(uid).collection('copilot_next_actions');
    if (onlyPending) q = q.where('isCompleted', isEqualTo: false);
    return q.snapshots().map((s) {
      final actions =
          s.docs.map((d) => NextBestAction.fromFirestore(d.data())).toList();
      actions.sort((a, b) => a.priority.compareTo(b.priority));
      return actions;
    });
  }

  /// Marks an action as completed WITHOUT deleting it, so it remains in the
  /// user's action history.
  static Future<void> completeNextAction(String uid, String actionId) async {
    await _userDoc(uid)
        .collection('copilot_next_actions')
        .doc(actionId)
        .set({'isCompleted': true}, SetOptions(merge: true));
  }

  // ── Copilot Recommendations (append-only; dismissed, never deleted) ─────

  static Future<void> saveRecommendation(
          String uid, CopilotRecommendation recommendation) =>
      _userDoc(uid)
          .collection('copilot_recommendations')
          .doc(recommendation.id)
          .set(recommendation.toFirestore(), SetOptions(merge: true));

  static Future<List<CopilotRecommendation>> getRecommendations(
    String uid, {
    bool onlyActive = false,
  }) async {
    Query<Map<String, dynamic>> q =
        _userDoc(uid).collection('copilot_recommendations');
    if (onlyActive) q = q.where('isDismissed', isEqualTo: false);
    final snap = await q.get();
    final recs = snap.docs
        .map((d) => CopilotRecommendation.fromFirestore(d.data()))
        .toList();
    recs.sort((a, b) => a.priority.compareTo(b.priority));
    return recs;
  }

  static Stream<List<CopilotRecommendation>> recommendationsStream(
    String uid, {
    bool onlyActive = false,
  }) {
    Query<Map<String, dynamic>> q =
        _userDoc(uid).collection('copilot_recommendations');
    if (onlyActive) q = q.where('isDismissed', isEqualTo: false);
    return q.snapshots().map((s) {
      final recs = s.docs
          .map((d) => CopilotRecommendation.fromFirestore(d.data()))
          .toList();
      recs.sort((a, b) => a.priority.compareTo(b.priority));
      return recs;
    });
  }

  /// Marks a recommendation as dismissed WITHOUT deleting it, so it remains
  /// in the user's recommendation history.
  static Future<void> dismissRecommendation(
      String uid, String recommendationId) async {
    await _userDoc(uid)
        .collection('copilot_recommendations')
        .doc(recommendationId)
        .set({'isDismissed': true}, SetOptions(merge: true));
  }

  // ── Composite Copilot Context ────────────────────────────────────────────
  // Reads/writes the full picture the Copilot reasons over:
  //   Selected Career + User Skills + Current Progress + Historical Progress.
  // Composed from the SAME collections/docs used above — no data is
  // duplicated into a single giant blob, so every piece keeps loading and
  // updating through its own already-safe method.

  /// Fetches every piece needed to build a [CopilotContext] for [uid] in
  /// parallel. [careerId] selects which per-career learning-progress
  /// document to load; if omitted, falls back to the user's currently
  /// selected [CareerContext.careerId] (or an empty/default context if the
  /// user hasn't selected a career yet — never throws on missing data).
  static Future<CopilotContext> getCopilotContext(
    String uid, {
    String? careerId,
  }) async {
    final results = await Future.wait([
      getSkillProfile(uid),
      getSkillGaps(uid),
      getRoadmap(uid),
      getTodayGoals(uid),
      getProgressHistory(uid),
      getCareerContext(uid),
      getProjectProgress(uid),
      getJobProgress(uid),
      getInterviewProgress(uid),
      getCareerReadiness(uid),
      getNextActions(uid),
      getRecommendations(uid),
    ]);

    final skillProfile   = results[0] as UserSkillProfile?;
    final skillGaps      = results[1] as List<SkillGap>;
    final roadmap        = results[2] as PersonalizedRoadmap?;
    final todayGoals     = results[3] as List<DailyGoal>;
    final progressHistory= results[4] as List<ProgressEntry>;
    final career         = results[5] as CareerContext?;
    final projectProgress= results[6] as ProjectProgressContext?;
    final jobProgress    = results[7] as JobProgressContext?;
    final interviewProgress = results[8] as InterviewProgressContext?;
    final readiness      = results[9] as CareerReadiness?;
    final nextActions    = results[10] as List<NextBestAction>;
    final recommendations= results[11] as List<CopilotRecommendation>;

    final resolvedCareerId = careerId ?? career?.careerId;
    final learningProgress = (resolvedCareerId != null &&
            resolvedCareerId.isNotEmpty)
        ? await getLearningProgress(uid, resolvedCareerId)
        : null;

    final state = CopilotState(
      skillProfile: skillProfile,
      skillGaps: skillGaps,
      roadmap: roadmap,
      todayGoals: todayGoals,
      progressHistory: progressHistory,
    );

    return CopilotContext(
      state: state,
      career: career,
      learningProgress: learningProgress,
      projectProgress: projectProgress,
      jobProgress: jobProgress,
      interviewProgress: interviewProgress,
      readiness: readiness,
      nextActions: nextActions,
      recommendations: recommendations,
    );
  }

  /// Persists the "current state" pieces of a [CopilotContext]:
  /// career, per-career learning progress, project/job/interview progress,
  /// and readiness. Deliberately does NOT bulk-write todayGoals,
  /// progressHistory, nextActions, or recommendations here — those are
  /// permanent/append-only history and must go through their dedicated
  /// append/save methods above (saveDailyGoals, syncTodayProgress,
  /// saveNextAction, saveRecommendation, appendCompleted*) so a single
  /// "save everything" call can never accidentally overwrite history.
  /// skillProfile/roadmap ARE included since those were already
  /// singleton "current state" docs with overwrite semantics before this
  /// change (saveSkillProfile/saveRoadmap already behaved this way).
  static Future<void> saveCopilotContext(
    String uid,
    CopilotContext context,
  ) async {
    final futures = <Future<void>>[];

    if (context.state.skillProfile != null) {
      futures.add(saveSkillProfile(context.state.skillProfile!));
    }
    if (context.state.roadmap != null) {
      futures.add(saveRoadmap(context.state.roadmap!));
    }
    if (context.career != null) {
      futures.add(saveCareerContext(uid, context.career!));
    }
    if (context.learningProgress.careerId.isNotEmpty) {
      futures.add(saveLearningProgress(uid, context.learningProgress));
    }
    futures.add(saveProjectProgress(uid, context.projectProgress));
    futures.add(saveJobProgress(uid, context.jobProgress));
    futures.add(saveInterviewProgress(uid, context.interviewProgress));
    futures.add(saveCareerReadiness(uid, context.readiness));

    await Future.wait(futures);
  }
}