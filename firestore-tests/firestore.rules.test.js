// Phase 3 / Stage 1 — rules tests for the SERVER-AUTHORITATIVE target rules.
//
// Run with:
//   firebase emulators:exec --only firestore --project demo-ai-career \
//     "npm test --prefix firestore-tests"
//
// "Server" writes are simulated with env.withSecurityRulesDisabled(), which
// behaves like the Admin SDK (rules are bypassed).
//
// NOTE: tests that used to assert the OLD client-authoritative contract
// (client may increment totalXp, run the toggleGoal transaction, write
// leaderboard rows, ...) are deliberately INVERTED here: those operations
// move to the trusted backend. They are marked "(moved to server)".
const fs = require('fs');
const path = require('path');
const {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} = require('@firebase/rules-unit-testing');
const {
  doc, getDoc, setDoc, updateDoc, deleteDoc, collection, getDocs, query,
  where, runTransaction, increment, arrayUnion, serverTimestamp,
} = require('firebase/firestore');

let env;

const db = (uid) => env.authenticatedContext(uid).firestore();
const anon = () => env.unauthenticatedContext().firestore();
const asServer = (fn) => env.withSecurityRulesDisabled(async (ctx) => fn(ctx.firestore()));

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-ai-career',
    firestore: {
      rules: fs.readFileSync(path.resolve(__dirname, '..', 'firestore.rules'), 'utf8'),
    },
  });
});

afterAll(async () => { await env.cleanup(); });

beforeEach(async () => {
  await env.clearFirestore();
  await asServer(async (a) => {
    await setDoc(doc(a, 'users/alice'), { name: 'Alice', bio: '', totalXp: 100, totalGoalsCompleted: 0 });
    await setDoc(doc(a, 'users/bob'), { name: 'Bob', totalXp: 0 });
    await setDoc(doc(a, 'rewards/alice'), {
      streakShieldCount: 1, claimedMilestoneIds: ['streak_3'], dailyBoxClaimedOn: '2026_11_9',
    });
    await setDoc(doc(a, 'quests/alice'), { daily: [], weekly: [], monthly: [], claimedQuestIds: ['q1'] });
    await setDoc(doc(a, 'achievements/alice'), { unlocked: [{ id: 'first_goal', unlockedAt: 1 }], inProgress: [] });
    await setDoc(doc(a, 'analytics/alice'), { weeklyXp: [], totalGoalsCompleted: 3 });
    await setDoc(doc(a, 'ai_memory/alice'), { xp: 100 });
    await setDoc(doc(a, 'users/alice/copilot_daily_goals/g1'), { id: 'g1', xpReward: 20, isCompleted: false });
    await setDoc(doc(a, 'users/alice/copilot_daily_goals/g_done'), { id: 'g_done', xpReward: 20, isCompleted: true });
    await setDoc(doc(a, 'users/alice/copilot_goal_events/goal:g0'), { xp: 20, eventType: 'goal' });
    await setDoc(doc(a, 'users/alice/copilot_job_offer_events/jobOffer:o1'), { xp: 0 });
    await setDoc(doc(a, 'users/alice/copilot_learning_progress/software_engineer'), {
      careerId: 'software_engineer', careerTotalXp: 10, completedLessonIds: ['l0'],
    });
    await setDoc(doc(a, 'users/alice/copilot_learning_progress/software_engineer/events/quiz:c1:0'), { xp: 10 });
    await setDoc(doc(a, 'users/alice/copilot_progress/p1'), { xpEarned: 5 });
    await setDoc(doc(a, 'rewards/alice/history/dailybox_2026_11_9'), { xpAmount: 20 });
    await setDoc(doc(a, 'saved_jobs/alice_job1'), { userId: 'alice', jobId: 'job1' });
    await setDoc(doc(a, 'applications/alice_job1'), { userId: 'alice', jobId: 'job1', coverLetter: 'hi' });
    await setDoc(doc(a, 'leaderboard/global/entries/alice'), { displayName: 'Alice', totalXp: 100, level: 1, weeklyXp: 10 });
    await setDoc(doc(a, 'leaderboard/global/entries/bob'), { displayName: 'Bob', totalXp: 0, level: 1, weeklyXp: 0 });
  });
});

describe('authentication and ownership', () => {
  test('anonymous cannot read or write user data', async () => {
    await assertFails(getDoc(doc(anon(), 'users/alice')));
    await assertFails(setDoc(doc(anon(), 'users/alice'), { name: 'x' }));
    await assertFails(getDoc(doc(anon(), 'leaderboard/global/entries/alice')));
    await assertFails(getDoc(doc(anon(), 'analytics/alice')));
  });

  test.each([
    'users/alice', 'rewards/alice', 'quests/alice', 'achievements/alice',
    'analytics/alice', 'ai_memory/alice', 'applications/alice_job1',
    'saved_jobs/alice_job1', 'users/alice/copilot_daily_goals/g1',
    'users/alice/copilot_goal_events/goal:g0',
    'users/alice/copilot_learning_progress/software_engineer/events/quiz:c1:0',
    'rewards/alice/history/dailybox_2026_11_9',
  ])('bob cannot read %s', async (p) => {
    await assertFails(getDoc(doc(db('bob'), p)));
  });

  test('owner can read own documents (incl. analytics, ledgers, history)', async () => {
    for (const p of [
      'users/alice', 'rewards/alice', 'quests/alice', 'achievements/alice',
      'analytics/alice', 'rewards/alice/history/dailybox_2026_11_9',
      'users/alice/copilot_goal_events/goal:g0',
      'users/alice/copilot_job_offer_events/jobOffer:o1',
      'users/alice/copilot_learning_progress/software_engineer/events/quiz:c1:0',
    ]) {
      await assertSucceeds(getDoc(doc(db('alice'), p)));
    }
  });

  test('unlisted user subcollection stays owner-only (compat)', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), 'users/alice/future_collection/x'), { a: 1 }));
    await assertFails(setDoc(doc(db('bob'), 'users/alice/future_collection/x'), { a: 1 }));
  });

  test('existing client-written Copilot docs keep working (copilot_progress, copilot/*)', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), 'users/alice/copilot_progress/p2'), { xpEarned: 9, goalsCompleted: 1 }));
    await assertSucceeds(setDoc(doc(db('alice'), 'users/alice/copilot/skill_profile_software_engineer'), { uid: 'alice' }));
    await assertSucceeds(setDoc(doc(db('alice'), 'users/alice/copilot_skill_gaps/gap1'), { skillName: 'Git' }));
  });

  test('default deny for unknown collections and unknown rewards subpaths', async () => {
    await assertFails(setDoc(doc(db('alice'), 'random/x'), { a: 1 }));
    await assertFails(setDoc(doc(db('alice'), 'rewards/alice/other/x'), { a: 1 }));
    await assertFails(getDoc(doc(db('alice'), 'random/x')));
  });
});

describe('users — server-owned XP fields', () => {
  test.each([
    ['increment(1)', { totalXp: increment(1) }],
    ['increment(50)', { totalXp: increment(50) }],
    ['increment(3000)', { totalXp: increment(3000) }],
    ['set huge value', { totalXp: 9999999 }],
    ['decrease', { totalXp: 10 }],
    ['totalGoalsCompleted +1', { totalGoalsCompleted: increment(1) }],
    ['totalGoalsCompleted set', { totalGoalsCompleted: 500 }],
    ['xpPoints set', { xpPoints: 5 }],
  ])('client cannot change XP counters: %s (moved to server)', async (_label, data) => {
    await assertFails(updateDoc(doc(db('alice'), 'users/alice'), data));
  });

  test('forged XP via merge-set is denied too', async () => {
    await assertFails(setDoc(doc(db('alice'), 'users/alice'), { totalXp: 99999 }, { merge: true }));
  });

  test('re-sending the UNCHANGED totalXp alongside a profile edit is allowed', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), 'users/alice'), { totalXp: 100, bio: 'same xp' }, { merge: true }));
  });

  test("a user cannot change another user's XP or profile", async () => {
    await assertFails(updateDoc(doc(db('bob'), 'users/alice'), { totalXp: 100000 }));
    await assertFails(updateDoc(doc(db('bob'), 'users/alice'), { bio: 'hacked' }));
  });

  test('users document cannot be deleted by client', async () => {
    await assertFails(deleteDoc(doc(db('alice'), 'users/alice')));
  });
});

describe('users — create', () => {
  test('signup-style create passes', async () => {
    await assertSucceeds(setDoc(doc(db('carol'), 'users/carol'), { name: 'C', xpPoints: 0, createdAt: new Date() }));
  });
  test('create with explicit zero counters passes', async () => {
    await assertSucceeds(setDoc(doc(db('erin'), 'users/erin'), { name: 'E', totalXp: 0, totalGoalsCompleted: 0 }));
  });
  test.each([
    ['totalXp 1', { totalXp: 1 }],
    ['totalXp 3000 (Phase 1 allowed this)', { totalXp: 3000 }],
    ['xpPoints 5', { xpPoints: 5 }],
    ['totalGoalsCompleted 1', { totalGoalsCompleted: 1 }],
  ])('create with %s is denied', async (_label, extra) => {
    await assertFails(setDoc(doc(db('dave'), 'users/dave'), { name: 'D', ...extra }));
  });
  test("cannot create another user's document", async () => {
    await assertFails(setDoc(doc(db('bob'), 'users/zed'), { name: 'Z' }));
  });
});

describe('users — legitimate profile and field updates keep working', () => {
  test('ProfileScreen edit payload passes', async () => {
    await assertSucceeds(updateDoc(doc(db('alice'), 'users/alice'), {
      name: 'Alice B', city: 'Dehradun, India', phone: '+91 9876543210',
      bio: 'Learning AI', targetRole: 'Software Engineer', experience: '1–2 years',
      updatedAt: '2026-11-14T00:00:00.000Z',
    }));
  });
  test('skills update passes', async () => {
    await assertSucceeds(updateDoc(doc(db('alice'), 'users/alice'), { skills: ['Python', 'Git'] }));
  });
  test('other, not-yet-inventoried fields stay client-writable (compat)', async () => {
    await assertSucceeds(updateDoc(doc(db('alice'), 'users/alice'), {
      appliedJobs: 2, completedSteps: 4, dailyStreak: 3, lastActiveAt: 1,
    }));
  });
  test.each([
    ['oversized bio', { bio: 'x'.repeat(1001) }],
    ['oversized name', { name: 'n'.repeat(101) }],
    ['name not a string', { name: 12345 }],
    ['skills not a list', { skills: 'python' }],
    ['too many skills', { skills: Array(201).fill('s') }],
  ])('invalid profile value is denied: %s', async (_label, data) => {
    await assertFails(updateDoc(doc(db('alice'), 'users/alice'), data));
  });
});

describe('XP ledgers are server-written (client cannot forge evidence)', () => {
  const base = 'users/alice/copilot_learning_progress/software_engineer/events/';

  test('client cannot create ledger rows, even small or zero-XP ones', async () => {
    await assertFails(setDoc(doc(db('alice'), 'users/alice/copilot_goal_events/goal:g1'), { xp: 20 }));
    await assertFails(setDoc(doc(db('alice'), 'users/alice/copilot_goal_events/goal:g2'), { xp: 0 }));
    await assertFails(setDoc(doc(db('alice'), base + 'quiz:c1:1'), { xp: 10, correct: true }));
    await assertFails(setDoc(doc(db('alice'), base + 'project:c9'), { xp: 100 }));
    await assertFails(setDoc(doc(db('alice'), 'users/alice/copilot_job_offer_events/jobOffer:o2'), { xp: 0 }));
    await assertFails(setDoc(doc(db('alice'), 'rewards/alice/history/checkin_2026_11_10'), { xpAmount: 10 }));
  });
  test('client cannot overwrite or delete existing ledger rows', async () => {
    await assertFails(updateDoc(doc(db('alice'), 'users/alice/copilot_goal_events/goal:g0'), { xp: 999 }));
    await assertFails(deleteDoc(doc(db('alice'), 'users/alice/copilot_goal_events/goal:g0')));
    await assertFails(setDoc(doc(db('alice'), base + 'quiz:c1:0'), { xp: 10 }));
    await assertFails(deleteDoc(doc(db('alice'), base + 'quiz:c1:0')));
    await assertFails(deleteDoc(doc(db('alice'), 'rewards/alice/history/dailybox_2026_11_9')));
  });
  test('ledgers cannot be reopened through the generic subcollection wildcard', async () => {
    await assertFails(setDoc(doc(db('alice'), 'users/alice/copilot_goal_events/sneaky'), { xp: 1 }));
    await assertFails(setDoc(doc(db('alice'), 'users/alice/copilot_learning_progress/other/events/e'), { xp: 1 }));
  });
  test('server-written rows are readable by the owner afterwards', async () => {
    await asServer((a) => setDoc(doc(a, base + 'quiz:c1:2'), { xp: 10 }));
    await assertSucceeds(getDoc(doc(db('alice'), base + 'quiz:c1:2')));
    await assertFails(getDoc(doc(db('bob'), base + 'quiz:c1:2')));
  });
});

describe('learning-progress aggregate', () => {
  const agg = 'users/alice/copilot_learning_progress/software_engineer';

  test('legitimate lesson progress writes still pass', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), agg), {
      completedLessonIds: arrayUnion('course:c1'), lastLessonId: 'course:c1',
      currentLevelTitle: 'Intro', totalLessons: 10, updatedAt: '2026-11-14T00:00:00.000Z',
    }, { merge: true }));
  });
  test('first visit to a career (create without XP fields) passes', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), 'users/alice/copilot_learning_progress/data_scientist'), {
      careerId: 'data_scientist', totalLessons: 5,
    }));
  });
  test.each([
    ['careerTotalXp increment', { careerTotalXp: increment(10) }],
    ['careerTotalXp set', { careerTotalXp: 99999 }],
    ['completedCourseEventIds', { completedCourseEventIds: arrayUnion('quiz:c1:9') }],
    ['courseEvidenceIds', { courseEvidenceIds: arrayUnion('quiz:c1:9') }],
  ])('server-owned aggregate field is denied: %s', async (_label, data) => {
    await assertFails(setDoc(doc(db('alice'), agg), data, { merge: true }));
  });
  test('create carrying a server-owned field is denied', async () => {
    await assertFails(setDoc(doc(db('alice'), 'users/alice/copilot_learning_progress/ml_engineer'), {
      careerId: 'ml_engineer', careerTotalXp: 5000,
    }));
  });
  test('aggregate cannot be deleted by the client', async () => {
    await assertFails(deleteDoc(doc(db('alice'), agg)));
  });
  test("another user cannot touch alice's aggregate", async () => {
    await assertFails(setDoc(doc(db('bob'), agg), { totalLessons: 1 }, { merge: true }));
  });
});

describe('daily goals', () => {
  const col = 'users/alice/copilot_daily_goals/';

  test('creating goals (as the generator does) passes', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), col + 'g2'), {
      id: 'g2', title: 'Read', xpReward: 50, isCompleted: false, date: '2026-11-14', careerId: 'software_engineer',
    }));
  });
  test('re-saving an existing uncompleted goal with merge passes', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), col + 'g1'), { id: 'g1', xpReward: 20, isCompleted: false }, { merge: true }));
  });
  test('client cannot create an already-completed goal', async () => {
    await assertFails(setDoc(doc(db('alice'), col + 'g3'), { id: 'g3', xpReward: 20, isCompleted: true }));
  });
  test('client cannot flip isCompleted either way (moved to server)', async () => {
    await assertFails(updateDoc(doc(db('alice'), col + 'g1'), { isCompleted: true }));
    await assertFails(updateDoc(doc(db('alice'), col + g_done_id()), { isCompleted: false }));
    await assertFails(setDoc(doc(db('alice'), col + g_done_id()), { id: 'g_done', isCompleted: false }, { merge: true }));
  });
  test('reward cap and type checks remain (defence in depth)', async () => {
    await assertFails(setDoc(doc(db('alice'), col + 'g4'), { id: 'g4', xpReward: 501 }));
    await assertFails(setDoc(doc(db('alice'), col + 'g5'), { id: 'g5', xpReward: -5 }));
    await assertFails(setDoc(doc(db('alice'), col + 'g6'), { id: 'g6', xpReward: 'lots' }));
  });
  test('editing other goal fields and deleting a goal still work', async () => {
    await assertSucceeds(updateDoc(doc(db('alice'), col + 'g1'), { title: 'Edited' }));
    await assertSucceeds(deleteDoc(doc(db('alice'), col + 'g1')));
  });
  test("bob cannot write alice's goals", async () => {
    await assertFails(setDoc(doc(db('bob'), col + 'g7'), { id: 'g7', xpReward: 1 }));
  });
});

function g_done_id() { return 'g_done'; }

describe('old client transaction shapes are now denied (moved to server)', () => {
  test('toggleGoalCompletion-style transaction fails', async () => {
    const d = db('alice');
    await assertFails(runTransaction(d, async (tx) => {
      const goalRef = doc(d, 'users/alice/copilot_daily_goals/g1');
      const userRef = doc(d, 'users/alice');
      await tx.get(goalRef);
      tx.update(goalRef, { isCompleted: true });
      tx.set(userRef, { totalXp: increment(20) }, { merge: true });
      tx.set(doc(d, 'users/alice/copilot_goal_events/software_engineer__goal_g1'), { xp: 20, eventType: 'goal' }, { merge: true });
    }));
  });
  test('recordCourseEvent-style transaction fails', async () => {
    const d = db('alice');
    await assertFails(runTransaction(d, async (tx) => {
      tx.set(doc(d, 'users/alice/copilot_learning_progress/software_engineer/events/quiz:c1:7'), { xp: 10 });
      tx.set(doc(d, 'users/alice'), { totalXp: increment(10) }, { merge: true });
    }));
  });
  test('milestone-style transaction fails', async () => {
    const d = db('alice');
    await assertFails(runTransaction(d, async (tx) => {
      const r = doc(d, 'rewards/alice');
      await tx.get(r);
      tx.set(r, { claimedMilestoneIds: arrayUnion('streak_100') }, { merge: true });
      tx.set(doc(d, 'users/alice'), { totalXp: increment(1000) }, { merge: true });
      tx.set(doc(d, 'rewards/alice/history/milestone_streak_100'), { xpAmount: 1000 });
    }));
  });
});

describe('rewards, quests and achievements are server-only', () => {
  test.each([
    ['shield +1', { streakShieldCount: increment(1) }],
    ['shield huge', { streakShieldCount: 100 }],
    ['claimed milestones reset', { claimedMilestoneIds: [] }],
    ['claimed milestone added', { claimedMilestoneIds: arrayUnion('streak_100') }],
    ['daily-box gate reset', { dailyBoxClaimedOn: '' }],
    ['check-in gate reset', { lastCheckInOn: '' }],
    ['surprise gate reset', { surpriseRollDate: '' }],
    ['multiplier', { xpMultiplierValue: 3, xpMultiplierExpiresAt: Date.now() + 1000 }],
  ])('client cannot write rewards/alice: %s', async (_label, data) => {
    await assertFails(updateDoc(doc(db('alice'), 'rewards/alice'), data));
  });
  test('client cannot create or delete reward docs', async () => {
    await assertFails(setDoc(doc(db('carol'), 'rewards/carol'), { streakShieldCount: 0 }));
    await assertFails(deleteDoc(doc(db('alice'), 'rewards/alice')));
  });
  test('quests cannot be written, claimed or reset by the client', async () => {
    await assertFails(updateDoc(doc(db('alice'), 'quests/alice'), { claimedQuestIds: arrayUnion('q2') }));
    await assertFails(updateDoc(doc(db('alice'), 'quests/alice'), { claimedQuestIds: [] }));
    await assertFails(updateDoc(doc(db('alice'), 'quests/alice'), {
      daily: [{ id: 'daily_goals_3_x', status: 'completed', xpReward: 100000 }],
    }));
    await assertFails(setDoc(doc(db('carol'), 'quests/carol'), { daily: [] }));
    await assertFails(deleteDoc(doc(db('alice'), 'quests/alice')));
  });
  test('achievements cannot be written by the client', async () => {
    await assertFails(updateDoc(doc(db('alice'), 'achievements/alice'), {
      unlocked: arrayUnion({ id: 'level_20', unlockedAt: 2 }),
    }));
    await assertFails(updateDoc(doc(db('alice'), 'achievements/alice'), { unlocked: [] }));
    await assertFails(setDoc(doc(db('carol'), 'achievements/carol'), { unlocked: [] }));
  });
  test('analytics cache cannot be written by the client', async () => {
    await assertFails(setDoc(doc(db('alice'), 'analytics/alice'), { totalGoalsCompleted: 99999 }));
    await assertFails(updateDoc(doc(db('alice'), 'analytics/alice'), { totalGoalsCompleted: 99999 }));
  });
  test("bob cannot write alice's rewards, quests or achievements", async () => {
    await assertFails(updateDoc(doc(db('bob'), 'rewards/alice'), { streakShieldCount: 50 }));
    await assertFails(updateDoc(doc(db('bob'), 'quests/alice'), { claimedQuestIds: [] }));
    await assertFails(updateDoc(doc(db('bob'), 'achievements/alice'), { unlocked: [] }));
  });
});

describe('leaderboard is server-written', () => {
  const entry = (xp, extra = {}) => ({ displayName: 'Alice', totalXp: xp, level: 1, weeklyXp: 10, xp: 10, updatedAt: 1, ...extra });

  test('client cannot create or update entries, even "valid-looking" ones (moved to server)', async () => {
    await assertFails(setDoc(doc(db('alice'), 'leaderboard/global/entries/alice'), entry(100), { merge: true }));
    await assertFails(setDoc(doc(db('alice'), 'leaderboard/global/entries/alice'), entry(101), { merge: true }));
    await assertFails(setDoc(doc(db('alice'), 'leaderboard/global/entries/alice'), entry(0, { level: 100 }), { merge: true }));
    await assertFails(setDoc(doc(db('alice'), 'leaderboard/weekly_2026_11_9/entries/alice'), entry(100), { merge: true }));
    await assertFails(setDoc(doc(db('alice'), 'leaderboard/hacked/entries/alice'), entry(100)));
    await assertFails(updateDoc(doc(db('alice'), 'leaderboard/global/entries/alice'), { displayName: 'Evil <b>' }));
  });
  test("user cannot write another user's entry", async () => {
    await assertFails(setDoc(doc(db('bob'), 'leaderboard/global/entries/alice'), entry(0)));
  });
  test('signed-in users can read all entries; anonymous cannot', async () => {
    await assertSucceeds(getDocs(collection(db('bob'), 'leaderboard/global/entries')));
    await assertFails(getDocs(collection(anon(), 'leaderboard/global/entries')));
  });
  test('owner can delete own entry but not someone else\'s', async () => {
    await assertFails(deleteDoc(doc(db('alice'), 'leaderboard/global/entries/bob')));
    await assertSucceeds(deleteDoc(doc(db('alice'), 'leaderboard/global/entries/alice')));
  });
});

describe('ai_memory (non-authoritative, unchanged)', () => {
  test('owner read/write ok, others denied', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), 'ai_memory/alice'), { goals: ['x'] }, { merge: true }));
    await assertSucceeds(setDoc(doc(db('alice'), 'ai_memory/alice/careers/software_engineer'), { xp: 1 }));
    await assertFails(setDoc(doc(db('bob'), 'ai_memory/alice'), { goals: ['x'] }, { merge: true }));
  });
});

describe('saved_jobs and applications (unchanged behaviour)', () => {
  test('get on a non-existent own-prefixed doc succeeds (existence check)', async () => {
    await assertSucceeds(getDoc(doc(db('alice'), 'saved_jobs/alice_newjob')));
    await assertSucceeds(getDoc(doc(db('alice'), 'applications/alice_newjob')));
  });
  test("get on a non-existent doc with another user's prefix is denied", async () => {
    await assertFails(getDoc(doc(db('alice'), 'saved_jobs/bob_newjob')));
  });
  test('create must carry own userId', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), 'saved_jobs/alice_job2'), { userId: 'alice', jobId: 'job2' }));
    await assertFails(setDoc(doc(db('alice'), 'saved_jobs/alice_job3'), { userId: 'bob', jobId: 'job3' }));
    await assertSucceeds(setDoc(doc(db('alice'), 'applications/alice_job2'),
      { userId: 'alice', jobId: 'job2', status: 'applied', appliedAt: serverTimestamp() }));
    await assertFails(setDoc(doc(db('alice'), 'applications/alice_job9'), { userId: 'bob' }));
  });
  test('oversized cover letter denied on create AND update', async () => {
    await assertFails(setDoc(doc(db('alice'), 'applications/alice_job4'),
      { userId: 'alice', coverLetter: 'x'.repeat(10001) }));
    await assertFails(updateDoc(doc(db('alice'), 'applications/alice_job1'),
      { coverLetter: 'x'.repeat(10001) }));
    await assertSucceeds(updateDoc(doc(db('alice'), 'applications/alice_job1'), { coverLetter: 'updated' }));
  });
  test('userId cannot be reassigned', async () => {
    await assertFails(updateDoc(doc(db('alice'), 'applications/alice_job1'), { userId: 'bob' }));
  });
  test('list requires userId filter; other users blocked', async () => {
    await assertSucceeds(getDocs(query(collection(db('alice'), 'saved_jobs'), where('userId', '==', 'alice'))));
    await assertFails(getDocs(collection(db('alice'), 'saved_jobs')));
    await assertFails(getDocs(query(collection(db('bob'), 'applications'), where('userId', '==', 'alice'))));
  });
  test("bob cannot update or delete alice's records", async () => {
    await assertFails(updateDoc(doc(db('bob'), 'saved_jobs/alice_job1'), { jobId: 'x' }));
    await assertFails(deleteDoc(doc(db('bob'), 'applications/alice_job1')));
    await assertSucceeds(deleteDoc(doc(db('alice'), 'saved_jobs/alice_job1')));
  });
});