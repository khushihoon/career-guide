// Integration tests: "trusted server writes" + proposed rules + existing Flutter readers.
//
// Run with the Firestore emulator (same command as the rules tests):
//   firebase emulators:exec --only firestore --project demo-ai-career \
//     "npm test --prefix firestore-tests"
//
// WHAT THIS PROVES (when run)
//   1. Documents shaped exactly like the Dart gateway's commit (see
//      backend/xp_gateway_core.dart) can be written by the server (rules are
//      bypassed, like the Admin/service-account identity).
//   2. After that, every Flutter reader that touches XP data — the queries in
//      CopilotFirestoreService, LeaderboardService, QuestService,
//      AchievementService, ProfileScreen — still succeeds UNDER THE PROPOSED
//      RULES and returns the values the Dart parsers expect.
//   3. The client cannot reproduce or replay those writes itself.
//   4. Legitimate client writers that coexist with server-owned fields
//      (lesson progress, goal re-saves, profile edits) still work.
//
// LIMITATION: the server-side fixture builders below are a hand-mirrored copy
// of the Dart gateway's document shapes. test/xp_gateway_core_test.dart
// asserts those shapes on the Dart side; keep the two in sync.
const fs = require('fs');
const path = require('path');
const {
  initializeTestEnvironment, assertFails, assertSucceeds,
} = require('@firebase/rules-unit-testing');
const {
  doc, getDoc, setDoc, updateDoc, deleteDoc, collection, getDocs, query, where,
  orderBy, limit, documentId, increment, arrayUnion,
} = require('firebase/firestore');

let env;
const db = (uid) => env.authenticatedContext(uid).firestore();
const asServer = (fn) => env.withSecurityRulesDisabled(async (ctx) => fn(ctx.firestore()));

const NOW_ISO = '2026-11-14T10:00:00.000Z';
const CAREER = 'software_engineer';
const COURSE = 'software_engineer_level1_lesson1';
const WEEK = 'weekly_2026_11_9';

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-ai-career',
    firestore: { rules: fs.readFileSync(path.resolve(__dirname, '..', 'firestore.rules'), 'utf8') },
  });
});
afterAll(async () => { await env.cleanup(); });
beforeEach(async () => {
  await env.clearFirestore();
  await asServer(async (a) => {
    await setDoc(doc(a, 'users/alice'), { name: 'Alice', totalXp: 100, totalGoalsCompleted: 0 });
    await setDoc(doc(a, 'users/bob'), { name: 'Bob', totalXp: 0 });
    await setDoc(doc(a, 'users/alice/copilot_daily_goals/g1'), {
      id: 'g1', uid: 'alice', title: 'Goal', category: 'Practice', date: '2026-11-14',
      isCompleted: false, xpReward: 15, linkedSkill: 'Python', careerId: CAREER,
    });
  });
});

// ── Server-side fixture builders (mirror backend/xp_gateway_core.dart) ──────
async function serverQuizEvent(a, { index = 0, xp = 10, total = 110, weekly = 10, hit = true } = {}) {
  const eventId = `${hit ? 'quiz' : 'quiz_miss'}:${COURSE}:${index}`;
  const progress = `users/alice/copilot_learning_progress/${CAREER}`;
  await setDoc(doc(a, `${progress}/events/${eventId}`), {
    eventId, eventType: hit ? 'quiz' : 'quiz_miss', careerId: CAREER, topic: 'Intro',
    correct: hit, xp: hit ? xp : 0, metadata: {}, recordedAt: NOW_ISO,
  });
  await setDoc(doc(a, progress), {
    careerId: CAREER, updatedAt: NOW_ISO,
    completedCourseEventIds: arrayUnion(eventId), courseEvidenceIds: arrayUnion(eventId),
    ...(hit ? { careerTotalXp: increment(xp) } : {}),
  }, { merge: true });
  if (hit) {
    await setDoc(doc(a, 'users/alice'), { totalXp: increment(xp) }, { merge: true });
    await setDoc(doc(a, 'leaderboard/global/entries/alice'), {
      displayName: 'Alice', totalXp: total, level: 1, weeklyXp: weekly, updatedAt: 1 }, { merge: true });
    await setDoc(doc(a, `leaderboard/${WEEK}/entries/alice`), {
      displayName: 'Alice', totalXp: total, level: 1, weeklyXp: weekly, xp: weekly, updatedAt: 1 }, { merge: true });
  }
}

async function serverGoalCompletion(a, { xp = 15 } = {}) {
  const goalId = 'g1';
  const progress = `users/alice/copilot_learning_progress/${CAREER}`;
  const record = {
    eventId: `goal:${CAREER}:${goalId}`, eventType: 'goal', careerId: CAREER, topic: 'Python',
    correct: true, xp, metadata: { goalId, templateId: 'se_f_01', date: '2026-11-14' }, recordedAt: NOW_ISO,
  };
  await setDoc(doc(a, 'users/alice/copilot_daily_goals/g1'), { isCompleted: true }, { merge: true });
  await setDoc(doc(a, 'users/alice'), { totalXp: increment(xp), totalGoalsCompleted: increment(1) }, { merge: true });
  await setDoc(doc(a, progress), { careerTotalXp: increment(xp), careerId: CAREER, updatedAt: NOW_ISO }, { merge: true });
  await setDoc(doc(a, `users/alice/copilot_goal_events/${CAREER}__goal_${goalId}`), { ...record, goalId });
  await setDoc(doc(a, `${progress}/events/goal:${goalId}`), record);
}

describe('server (gateway) writes, then existing Flutter readers under the rules', () => {
  beforeEach(async () => {
    await asServer(async (a) => {
      await serverQuizEvent(a, { index: 0, xp: 10, total: 110, weekly: 10 });
      await serverQuizEvent(a, { index: 1, hit: false });
      await serverGoalCompletion(a, { xp: 15 });
      await setDoc(doc(a, 'rewards/alice/history/dailybox_2026_11_14'), {
        type: 'xp', xpAmount: 20, source: 'dailyBox', message: 'm', timestamp: NOW_ISO });
      await setDoc(doc(a, 'quests/alice'), { daily: [], weekly: [], monthly: [], claimedQuestIds: [] });
      await setDoc(doc(a, 'achievements/alice'), { unlocked: [], inProgress: [] });
      await setDoc(doc(a, 'leaderboard/global/entries/bob'), { displayName: 'Bob', totalXp: 50, level: 1, weeklyXp: 5 });
    });
  });

  test('getUserTotalXp / getTotalGoalsCompleted / ProfileScreen read integers', async () => {
    const snap = await assertSucceeds(getDoc(doc(db('alice'), 'users/alice')));
    expect(snap.data().totalXp).toBe(125);                 // 100 + 10 + 15
    expect(Number.isInteger(snap.data().totalXp)).toBe(true);
    expect(snap.data().totalGoalsCompleted).toBe(1);
    expect(snap.data().name).toBe('Alice');                // profile fields untouched by the server
  });

  test('getCareerEvents: ordered query over the events ledger', async () => {
    const q = query(collection(db('alice'), `users/alice/copilot_learning_progress/${CAREER}/events`),
      orderBy('recordedAt', 'desc'), limit(200));
    const snap = await assertSucceeds(getDocs(q));
    const ids = snap.docs.map((d) => d.data().eventId).sort();
    expect(ids).toEqual([`goal:${CAREER}:g1`, `quiz:${COURSE}:0`, `quiz_miss:${COURSE}:1`].sort());
    snap.docs.forEach((d) => {
      expect(typeof d.data().recordedAt).toBe('string');
      expect(Number.isInteger(d.data().xp)).toBe(true);
    });
  });

  test('getCareerTotalXp sums the events ledger', async () => {
    const snap = await assertSucceeds(getDocs(collection(db('alice'), `users/alice/copilot_learning_progress/${CAREER}/events`)));
    const total = snap.docs.reduce((s, d) => s + (d.data().xp > 0 ? d.data().xp : 0), 0);
    expect(total).toBe(25);
  });

  test('getCourseXpBreakdown: eventId contains the course id, per eventType', async () => {
    const snap = await assertSucceeds(getDocs(collection(db('alice'), `users/alice/copilot_learning_progress/${CAREER}/events`)));
    let quiz = 0;
    snap.docs.forEach((d) => {
      const x = d.data();
      if (x.xp > 0 && String(x.eventId).includes(COURSE) && x.eventType === 'quiz') quiz += x.xp;
    });
    expect(quiz).toBe(10);
  });

  test('getXpActivitySince: reward history + every career events collection', async () => {
    const hist = await assertSucceeds(getDocs(collection(db('alice'), 'rewards/alice/history')));
    expect(hist.docs[0].data().xpAmount).toBe(20);
    const careers = await assertSucceeds(getDocs(collection(db('alice'), 'users/alice/copilot_learning_progress')));
    expect(careers.size).toBe(1);
    const events = await assertSucceeds(getDocs(collection(careers.docs[0].ref, 'events')));
    expect(events.size).toBe(3);
  });

  test('learningProgressStream: aggregate doc parses (server fields + client fields)', async () => {
    const snap = await assertSucceeds(getDoc(doc(db('alice'), `users/alice/copilot_learning_progress/${CAREER}`)));
    const d = snap.data();
    expect(d.careerTotalXp).toBe(25);
    expect(d.completedCourseEventIds.sort()).toEqual([`quiz:${COURSE}:0`, `quiz_miss:${COURSE}:1`].sort());
    expect(d.careerId).toBe(CAREER);
  });

  test('todayGoalsStream: goal query sees the server-set isCompleted', async () => {
    const snap = await assertSucceeds(getDocs(query(
      collection(db('alice'), 'users/alice/copilot_daily_goals'), where('date', '==', '2026-11-14'))));
    expect(snap.docs[0].data().isCompleted).toBe(true);
  });

  test('LeaderboardService reads: global top, weekly top, rank query, friends whereIn', async () => {
    const g = await assertSucceeds(getDocs(query(collection(db('bob'), 'leaderboard/global/entries'),
      orderBy('totalXp', 'desc'), limit(50))));
    expect(g.docs[0].id).toBe('alice');
    expect(g.docs[0].data().totalXp).toBe(110);
    const w = await assertSucceeds(getDocs(query(collection(db('bob'), `leaderboard/${WEEK}/entries`),
      orderBy('xp', 'desc'), limit(50))));
    expect(w.docs[0].data().xp).toBe(10);
    const above = await assertSucceeds(getDocs(query(collection(db('bob'), 'leaderboard/global/entries'),
      where('totalXp', '>', 50))));
    expect(above.size).toBe(1);
    const friends = await assertSucceeds(getDocs(query(collection(db('bob'), 'leaderboard/global/entries'),
      where(documentId(), 'in', ['alice', 'bob']))));
    expect(friends.size).toBe(2);
  });

  test('QuestService / AchievementService / reward reads still work', async () => {
    await assertSucceeds(getDoc(doc(db('alice'), 'quests/alice')));
    await assertSucceeds(getDoc(doc(db('alice'), 'achievements/alice')));
    await assertSucceeds(getDoc(doc(db('alice'), 'rewards/alice')));
  });

  test('another user cannot read any of it', async () => {
    await assertFails(getDoc(doc(db('bob'), 'users/alice')));
    await assertFails(getDocs(collection(db('bob'), `users/alice/copilot_learning_progress/${CAREER}/events`)));
    await assertFails(getDocs(collection(db('bob'), 'rewards/alice/history')));
  });
});

describe('the client cannot reproduce or replay what the server wrote', () => {
  const events = `users/alice/copilot_learning_progress/${CAREER}/events/`;
  test('re-creating or editing an awarded ledger row is denied', async () => {
    await asServer((a) => serverQuizEvent(a, { index: 0 }));
    await assertFails(setDoc(doc(db('alice'), events + `quiz:${COURSE}:0`), { eventType: 'quiz', xp: 10 }));
    await assertFails(updateDoc(doc(db('alice'), events + `quiz:${COURSE}:0`), { xp: 9999 }));
    await assertFails(deleteDoc(doc(db('alice'), events + `quiz:${COURSE}:0`)));
  });
  test('client cannot fabricate a new XP event, goal event or XP total', async () => {
    await assertFails(setDoc(doc(db('alice'), events + `quiz:${COURSE}:9`), { eventType: 'quiz', xp: 10 }));
    await assertFails(setDoc(doc(db('alice'), `users/alice/copilot_goal_events/${CAREER}__goal_gX`), { xp: 50 }));
    await assertFails(updateDoc(doc(db('alice'), 'users/alice'), { totalXp: increment(10) }));
    await assertFails(updateDoc(doc(db('alice'), 'users/alice'), { totalGoalsCompleted: increment(1) }));
  });
  test('client cannot re-complete, un-complete, or flag a goal itself', async () => {
    await asServer((a) => serverGoalCompletion(a));
    await assertFails(updateDoc(doc(db('alice'), 'users/alice/copilot_daily_goals/g1'), { isCompleted: false }));
    await assertFails(setDoc(doc(db('alice'), 'users/alice/copilot_daily_goals/g1'), { isCompleted: false }, { merge: true }));
  });
  test('client cannot touch server-owned aggregate mirrors', async () => {
    await asServer((a) => serverQuizEvent(a, { index: 0 }));
    const agg = doc(db('alice'), `users/alice/copilot_learning_progress/${CAREER}`);
    await assertFails(setDoc(agg, { careerTotalXp: 99999 }, { merge: true }));
    await assertFails(setDoc(agg, { completedCourseEventIds: arrayUnion('quiz:x:1') }, { merge: true }));
    await assertFails(setDoc(agg, { courseEvidenceIds: arrayUnion('quiz:x:1') }, { merge: true }));
  });
  test('client cannot write leaderboard, rewards, quests or achievements', async () => {
    await assertFails(setDoc(doc(db('alice'), 'leaderboard/global/entries/alice'), { displayName: 'A', totalXp: 1, level: 1, weeklyXp: 0 }, { merge: true }));
    await assertFails(setDoc(doc(db('alice'), 'rewards/alice'), { streakShieldCount: 50 }, { merge: true }));
    await assertFails(updateDoc(doc(db('alice'), 'quests/alice'), { claimedQuestIds: arrayUnion('q') }));
    await assertFails(updateDoc(doc(db('alice'), 'achievements/alice'), { unlocked: arrayUnion({ id: 'level_20', unlockedAt: 1 }) }));
  });
});

describe('legitimate client writers still work next to server-owned fields', () => {
  beforeEach(async () => { await asServer((a) => serverQuizEvent(a, { index: 0 })); });
  const agg = () => doc(db('alice'), `users/alice/copilot_learning_progress/${CAREER}`);

  test('lesson progress merge (appendCompletedLesson) leaves server fields intact', async () => {
    await assertSucceeds(setDoc(agg(), {
      careerId: CAREER, completedLessonIds: arrayUnion('course:' + COURSE),
      lastLessonId: 'course:' + COURSE, updatedAt: NOW_ISO,
    }, { merge: true }));
    const d = (await getDoc(agg())).data();
    expect(d.careerTotalXp).toBe(10);
    expect(d.completedLessonIds).toContain('course:' + COURSE);
  });
  test('saveLearningProgress / Snapshot payloads (no server keys) pass', async () => {
    await assertSucceeds(setDoc(agg(), { careerId: CAREER, totalLessons: 12, currentLevelTitle: 'L1',
      lastLessonId: null, updatedAt: NOW_ISO }, { merge: true }));
    await assertSucceeds(setDoc(agg(), { careerId: CAREER, totalLessons: 12, completedLessonIds: ['a'],
      completedCourseIds: [], updatedAt: NOW_ISO }, { merge: true }));
  });
  test('saveDailyGoals re-save of a NEW goal passes; goals keep client text edits', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), 'users/alice/copilot_daily_goals/g2'), {
      id: 'g2', uid: 'alice', title: 'New', category: 'Learning', date: '2026-11-14',
      isCompleted: false, xpReward: 30, linkedSkill: null, careerId: CAREER }, { merge: true }));
    await assertSucceeds(updateDoc(doc(db('alice'), 'users/alice/copilot_daily_goals/g1'), { title: 'Renamed' }));
  });
  test('ProfileScreen edit passes and does not disturb server XP fields', async () => {
    await assertSucceeds(updateDoc(doc(db('alice'), 'users/alice'), {
      name: 'Alice B', city: 'Dehradun', phone: '+91 1', bio: 'b', targetRole: 'Software Engineer',
      experience: '1–2 years', updatedAt: NOW_ISO }));
    expect((await getDoc(doc(db('alice'), 'users/alice'))).data().totalXp).toBe(110);
  });
  test('Copilot derived docs (skill gaps, progress snapshots, next actions) still work', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), 'users/alice/copilot_progress/alice_2026-11-14_' + CAREER), {
      id: 'p', uid: 'alice', date: NOW_ISO, xpEarned: 25, goalsCompleted: 1, totalGoals: 4, careerId: CAREER }, { merge: true }));
    await assertSucceeds(setDoc(doc(db('alice'), `users/alice/copilot_skill_gaps/${CAREER}__gap_Git`), { skillName: 'Git', careerId: CAREER }));
    await assertSucceeds(setDoc(doc(db('alice'), 'users/alice/copilot_next_actions/a1'), { id: 'a1', careerId: CAREER }, { merge: true }));
  });
});