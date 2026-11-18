# XP Gateway API setup

The trusted XP gateway is hosted inside the existing Course Generator HTTP server.
It is deliberately disabled unless `XP_GATEWAY_ENABLED=true` is set.

## Enable it on the backend host

Set these server-side environment variables (never add them to Flutter assets,
`.env` bundled with the app, or Git):

- `XP_GATEWAY_ENABLED=true`
- `FIREBASE_PROJECT_ID=ai-career-app-a38db`
- `XP_USER_PER_MINUTE=60` (optional; bounded to 1–600)
- On a Google-managed host with an attached service account:
  `XP_FIRESTORE_CREDENTIALS=metadata`
- Otherwise store the service-account JSON in the host's secret manager as
  `GOOGLE_SERVICE_ACCOUNT_JSON` or base64 as
  `GOOGLE_SERVICE_ACCOUNT_JSON_B64`.

The service account must belong to the same Firebase project and have only the
minimum Firestore IAM role required by the adapter: **Cloud Datastore User**
(`roles/datastore.user`). Do not put the private key in source control.

If XP is enabled but the project ID or credentials are missing/invalid, the
backend refuses to start. This is intentional fail-closed behaviour.

## Endpoints

Both endpoints require:

- `Authorization: Bearer <Firebase ID token>`
- `X-Firebase-AppCheck: <App Check token>` when App Check is enforced
- `Content-Type: application/json`

The UID is taken only from the verified Firebase token. The request body must
not be used to choose a user.

### Record quiz or challenge result

`POST /xp/course-event`

```json
{
  "careerId": "software_engineer",
  "courseId": "software_engineer_level1_lesson1",
  "kind": "quiz",
  "index": 0,
  "selectedIndex": 2
}
```

Use `kind: "challenge"` for a challenge answer. The trusted gateway calculates
correctness and XP from the server's local curriculum; it does not accept an XP
amount from the client.

### Complete a daily goal

`POST /xp/complete-goal`

```json
{
  "careerId": "software_engineer",
  "goalId": "software_engineer_se_f_01_2026-11-18_0"
}
```

The gateway verifies the goal against the server's goal catalog and the stored
goal document before awarding XP.

## Deliberately disabled for this first integration

Project XP is explicitly disabled in the HTTP integration. The current gateway
checks that quiz/challenge outcome events exist, but that alone is not proof
that a project was submitted or independently verified. Do not enable project
XP until trusted project-evidence verification is implemented.

## Deployment warning

Do not deploy the server-authoritative `firestore.rules` until the Flutter
client's existing XP, rewards, quest, achievement and leaderboard writers
have been migrated to trusted server endpoints and tested. Enabling these API
routes alone does not migrate those client writers.
