// Run with:
//   firebase emulators:exec --only firestore --project demo-ai-career \
//     "npm test --prefix firestore-tests"
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
  await env.withSecurityRulesDisabled(async (ctx) => {
    const a = ctx.firestore();
    await setDoc(doc(a, 'users/alice'), { name: 'Alice', bio: '', totalXp: 100, totalGoalsCompleted: 0 });
    await setDoc(doc(a, 'users/bob'), { name: 'Bob', totalXp: 0 });
    await setDoc(doc(a, 'rewards/alice'), {
      streakShieldCount: 1, claimedMilestoneIds: ['streak_3'], dailyBoxClaimedOn: '2026_11_9',
    });
    await setDoc(doc(a, 'quests/alice'), { daily: [], weekly: [], monthly: [], claimedQuestIds: ['q1'] });
    await setDoc(doc(a, 'achievements/alice'), { unlocked: [{ id: 'first_goal', unlockedAt: 1 }], inProgress: [] });
    await setDoc(doc(a, 'ai_memory/alice'), { xp: 100 });
    await setDoc(doc(a, 'users/alice/copilot_daily_goals/g1'), { id: 'g1', xpReward: 20, isCompleted: false });
    await setDoc(doc(a, 'users/alice/copilot_goal_events/goal:g0'), { xp: 20, eventType: 'goal' });
    await setDoc(doc(a, 'users/alice/copilot_learning_progress/software_engineer/events/quiz:c1:0'), { xp: 10 });
    await setDoc(doc(a, 'rewards/alice/history/dailybox_2026_11_9'), { xpAmount: 20 });
    await setDoc(doc(a, 'saved_jobs/alice_job1'), { userId: 'alice', jobId: 'job1' });
    await setDoc(doc(a, 'applications/alice_job1'), { userId: 'alice', jobId: 'job1', coverLetter: 'hi' });
    await setDoc(doc(a, 'leaderboard/global/entries/alice'), { displayName: 'Alice', totalXp: 100, level: 1, weeklyXp: 10 });
  });
});

describe('authentication and ownership', () => {
  test('anonymous cannot read or write user data', async () => {
    await assertFails(getDoc(doc(anon(), 'users/alice')));
    await assertFails(setDoc(doc(anon(), 'users/alice'), { name: 'x' }));
    await assertFails(getDoc(doc(anon(), 'leaderboard/global/entries/alice')));
  });

  test.each([
    'users/alice', 'rewards/alice', 'quests/alice', 'achievements/alice',
    'ai_memory/alice', 'applications/alice_job1', 'saved_jobs/alice_job1',
    'users/alice/copilot_daily_goals/g1', 'rewards/alice/history/dailybox_2026_11_9',
  ])('bob cannot read %s', async (p) => {
    await assertFails(getDoc(doc(db('bob'), p)));
  });

  test('owner can read own documents', async () => {
    await assertSucceeds(getDoc(doc(db('alice'), 'users/alice')));
    await assertSucceeds(getDoc(doc(db('alice'), 'rewards/alice')));
  });

  test('unlisted user subcollection stays owner-only (compat)', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), 'users/alice/future_collection/x'), { a: 1 }));
    await assertFails(setDoc(doc(db('bob'), 'users/alice/future_collection/x'), { a: 1 }));
  });

  test('default deny for unknown collections and unknown rewards subpaths', async () => {
    await assertFails(getDoc(doc(db('alice'), 'analytics/alice')));
    await assertFails(setDoc(doc(db('alice'), 'random/x'), { a: 1 }));
    await assertFails(setDoc(doc(db('alice'), 'rewards/alice/other/x'), { a: 1 }));
  });
});

describe('users.totalXp / totalGoalsCompleted', () => {
  test('legit XP increase and unrelated update pass', async () => {
    await assertSucceeds(updateDoc(doc(db('alice'), 'users/alice'), { totalXp: increment(50) }));
    await assertSucceeds(updateDoc(doc(db('alice'), 'users/alice'), { bio: 'new bio' }));
  });
  test('XP decrease is denied', async () => {
    await assertFails(updateDoc(doc(db('alice'), 'users/alice'), { totalXp: 10 }));
  });
  test('XP jump above per-write cap is denied', async () => {
    await assertFails(updateDoc(doc(db('alice'), 'users/alice'), { totalXp: increment(5000) }));
    await assertFails(updateDoc(doc(db('alice'), 'users/alice'), { totalXp: 9999999 }));
  });
  test('goal counter may rise by 1 only', async () => {
    await assertSucceeds(updateDoc(doc(db('alice'), 'users/alice'), { totalGoalsCompleted: increment(1) }));
    await assertFails(updateDoc(doc(db('alice'), 'users/alice'), { totalGoalsCompleted: increment(2) }));
  });
  test('users document cannot be deleted by client', async () => {
    await assertFails(deleteDoc(doc(db('alice'), 'users/alice')));
  });
  test('signup-style create passes, create with huge XP fails', async () => {
    await assertSucceeds(setDoc(doc(db('carol'), 'users/carol'), { name: 'C', xpPoints: 0, createdAt: new Date() }));
    await assertFails(setDoc(doc(db('dave'), 'users/dave'), { name: 'D', totalXp: 999999 }));
  });
});

describe('XP ledgers are create-only', () => {
  test('goal event create passes; update/delete denied', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), 'users/alice/copilot_goal_events/goal:g1'), { xp: 20 }));
    await assertFails(updateDoc(doc(db('alice'), 'users/alice/copilot_goal_events/goal:g0'), { xp: 999 }));
    await assertFails(deleteDoc(doc(db('alice'), 'users/alice/copilot_goal_events/goal:g0')));
  });
  test('career event: bounded xp, no update, no delete', async () => {
    const base = 'users/alice/copilot_learning_progress/software_engineer/events/';
    await assertSucceeds(setDoc(doc(db('alice'), base + 'quiz:c1:1'), { xp: 10 }));
    await assertFails(setDoc(doc(db('alice'), base + 'quiz:c1:2'), { xp: 600 }));
    await assertFails(setDoc(doc(db('alice'), base + 'quiz:c1:0'), { xp: 10 })); // overwrite
    await assertFails(deleteDoc(doc(db('alice'), base + 'quiz:c1:0')));
  });
  test('learning-progress aggregate doc remains writable', async () => {
    await assertSucceeds(setDoc(
      doc(db('alice'), 'users/alice/copilot_learning_progress/software_engineer'),
      { careerTotalXp: increment(10), completedLessonIds: arrayUnion('l1') }, { merge: true }));
  });
  test('reward history is create-only', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), 'rewards/alice/history/checkin_2026_11_10'), { xpAmount: 10 }));
    await assertFails(setDoc(doc(db('alice'), 'rewards/alice/history/dailybox_2026_11_9'), { xpAmount: 20 }));
    await assertFails(deleteDoc(doc(db('alice'), 'rewards/alice/history/dailybox_2026_11_9')));
  });
});

describe('daily goals', () => {
  test('reward within cap passes; above cap / negative fails', async () => {
    const col = 'users/alice/copilot_daily_goals/';
    await assertSucceeds(setDoc(doc(db('alice'), col + 'g2'), { id: 'g2', xpReward: 50 }));
    await assertFails(setDoc(doc(db('alice'), col + 'g3'), { id: 'g3', xpReward: 501 }));
    await assertFails(setDoc(doc(db('alice'), col + 'g4'), { id: 'g4', xpReward: -5 }));
  });
});

describe('real app transaction shapes', () => {
  test('toggleGoalCompletion-style transaction succeeds', async () => {
    const d = db('alice');
    await assertSucceeds(runTransaction(d, async (tx) => {
      const goalRef = doc(d, 'users/alice/copilot_daily_goals/g1');
      const userRef = doc(d, 'users/alice');
      await tx.get(goalRef);
      tx.update(goalRef, { isCompleted: true });
      tx.set(userRef, { totalXp: increment(20) }, { merge: true });
      tx.set(doc(d, 'users/alice/copilot_learning_progress/software_engineer'),
        { careerTotalXp: increment(20) }, { merge: true });
      tx.set(userRef, { totalGoalsCompleted: increment(1) }, { merge: true }); // 2nd write, same doc
      tx.set(doc(d, 'users/alice/copilot_goal_events/software_engineer__goal_g1'),
        { xp: 20, eventType: 'goal' }, { merge: true });
      tx.set(doc(d, 'users/alice/copilot_learning_progress/software_engineer/events/goal:g1'),
        { xp: 20 }, { merge: true });
    }));
  });

  test('replaying the same completion (canonical record exists) fails', async () => {
    const d = db('alice');
    await assertFails(runTransaction(d, async (tx) => {
      tx.set(doc(d, 'users/alice/copilot_goal_events/goal:g0'),
        { xp: 20, eventType: 'goal' }, { merge: true });
    }));
  });

  test('milestone-style transaction (3 writes to rewards doc) succeeds', async () => {
    const d = db('alice');
    await assertSucceeds(runTransaction(d, async (tx) => {
      const r = doc(d, 'rewards/alice');
      await tx.get(r);
      tx.set(r, { claimedMilestoneIds: arrayUnion('streak_100') }, { merge: true });
      tx.set(doc(d, 'users/alice'), { totalXp: increment(1000) }, { merge: true });
      tx.set(r, { streakShieldCount: increment(2) }, { merge: true });
      tx.set(r, { xpMultiplierValue: 2.0, xpMultiplierExpiresAt: Date.now() + 48 * 3600 * 1000,
        xpMultiplierActivatedAt: Date.now() }, { merge: true });
      tx.set(doc(d, 'rewards/alice/history/milestone_streak_100'), { xpAmount: 1000 });
    }));
  });
});

describe('rewards / quests / achievements cannot be reset', () => {
  test('claimedMilestoneIds cannot shrink, can grow', async () => {
    await assertFails(updateDoc(doc(db('alice'), 'rewards/alice'), { claimedMilestoneIds: [] }));
    await assertSucceeds(updateDoc(doc(db('alice'), 'rewards/alice'), { claimedMilestoneIds: arrayUnion('streak_7') }));
  });
  test('shield count: +1 ok, use -1 ok, +3 and negative denied', async () => {
    await assertSucceeds(updateDoc(doc(db('alice'), 'rewards/alice'), { streakShieldCount: increment(1) }));
    await assertSucceeds(updateDoc(doc(db('alice'), 'rewards/alice'), { streakShieldCount: increment(-1) }));
    await assertFails(updateDoc(doc(db('alice'), 'rewards/alice'), { streakShieldCount: increment(3) }));
    await assertFails(updateDoc(doc(db('alice'), 'rewards/alice'), { streakShieldCount: -1 }));
  });
  test('XP multiplier bounded (value and duration)', async () => {
    await assertFails(updateDoc(doc(db('alice'), 'rewards/alice'), { xpMultiplierValue: 10 }));
    await assertFails(updateDoc(doc(db('alice'), 'rewards/alice'),
      { xpMultiplierValue: 1.5, xpMultiplierExpiresAt: Date.now() + 365 * 24 * 3600 * 1000 }));
    await assertSucceeds(updateDoc(doc(db('alice'), 'rewards/alice'),
      { xpMultiplierValue: 1.5, xpMultiplierExpiresAt: Date.now() + 12 * 3600 * 1000 }));
  });
  test('claimedQuestIds cannot shrink; oversized quest arrays denied', async () => {
    await assertFails(updateDoc(doc(db('alice'), 'quests/alice'), { claimedQuestIds: [] }));
    await assertSucceeds(updateDoc(doc(db('alice'), 'quests/alice'), { claimedQuestIds: arrayUnion('q2') }));
    await assertFails(updateDoc(doc(db('alice'), 'quests/alice'), { daily: Array(25).fill({ id: 'x' }) }));
  });
  test('achievements.unlocked cannot shrink, can grow', async () => {
    await assertFails(updateDoc(doc(db('alice'), 'achievements/alice'), { unlocked: [] }));
    await assertSucceeds(updateDoc(doc(db('alice'), 'achievements/alice'),
      { unlocked: arrayUnion({ id: 'goals_5', unlockedAt: 2 }) }));
  });
});

describe('leaderboard', () => {
  const entry = (xp, extra = {}) => ({ displayName: 'Alice', totalXp: xp, level: 1, weeklyXp: 10, xp: 10, updatedAt: 1, ...extra });
  test('own entry up to own users.totalXp passes; above fails', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), 'leaderboard/global/entries/alice'), entry(100), { merge: true }));
    await assertFails(setDoc(doc(db('alice'), 'leaderboard/global/entries/alice'), entry(101), { merge: true }));
  });
  test('weeklyXp cannot exceed totalXp', async () => {
    await assertFails(setDoc(doc(db('alice'), 'leaderboard/global/entries/alice'), entry(100, { weeklyXp: 500 }), { merge: true }));
  });
  test('weekly board id accepted; bad board id denied', async () => {
    await assertSucceeds(setDoc(doc(db('alice'), 'leaderboard/weekly_2026_11_9/entries/alice'), entry(100), { merge: true }));
    await assertFails(setDoc(doc(db('alice'), 'leaderboard/hacked/entries/alice'), entry(100)));
  });
  test("user cannot write another user's entry", async () => {
    await assertFails(setDoc(doc(db('bob'), 'leaderboard/global/entries/alice'), entry(0)));
  });
  test('signed-in users can read all entries; anonymous cannot', async () => {
    await assertSucceeds(getDocs(collection(db('bob'), 'leaderboard/global/entries')));
    await assertFails(getDocs(collection(anon(), 'leaderboard/global/entries')));
  });
});

describe('saved_jobs and applications', () => {
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
  test('oversized cover letter denied', async () => {
    await assertFails(setDoc(doc(db('alice'), 'applications/alice_job4'),
      { userId: 'alice', coverLetter: 'x'.repeat(10001) }));
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