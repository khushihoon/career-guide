const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const { getAuth } = require("firebase-admin/auth");
const { getFirestore } = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

exports.deleteMyAccount = onCall(
  { region: "asia-south1", timeoutSeconds: 540, memory: "512MiB" },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Please sign in again.");
    }

    // The UID is derived only from the verified Firebase Auth context.
    const uid = request.auth.uid;
    const authTime = Number(request.auth.token.auth_time || 0);
    const now = Math.floor(Date.now() / 1000);
    if (!authTime || now - authTime > 300) {
      throw new HttpsError("failed-precondition", "RECENT_LOGIN_REQUIRED");
    }

    // Recursive deletion includes every nested Copilot/reward subcollection.
    for (const path of [
      `users/${uid}`,
      `ai_memory/${uid}`,
      `quests/${uid}`,
      `achievements/${uid}`,
      `rewards/${uid}`,
    ]) {
      await db.recursiveDelete(db.doc(path));
    }

    await deleteQueryInChunks(
      db.collection("saved_jobs").where("userId", "==", uid)
    );
    await deleteQueryInChunks(
      db.collection("applications").where("userId", "==", uid)
    );

    // Leaderboard data is stored outside users/{uid}.
    const leaderboardParents = await db.collection("leaderboard").get();
    for (const parent of leaderboardParents.docs) {
      await db.recursiveDelete(parent.ref.collection("entries").doc(uid));
    }

    // Storage cleanup is intentionally omitted until real UID-based upload
    // paths are confirmed from the app's upload implementation.

    // Delete Auth last so an interrupted Firestore cleanup can be retried.
    await getAuth().deleteUser(uid);
    return { success: true };
  }
);

async function deleteQueryInChunks(query) {
  const pageSize = 400;
  while (true) {
    const page = await query.limit(pageSize).get();
    if (page.empty) return;
    const batch = db.batch();
    for (const doc of page.docs) batch.delete(doc.ref);
    await batch.commit();
    if (page.size < pageSize) return;
  }
}
