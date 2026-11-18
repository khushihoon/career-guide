// Independent JavaScript reference implementation of
// CopilotFirestoreService._safeId (== lib/services/safe_doc_id.dart safeDocId).
//
// Purpose: generate expected values for the SHARED test vectors used by
//   test/safe_doc_id_test.dart   (Dart, compares safeDocId AND the original
//                                 CopilotFirestoreService._safeId)
// so the vectors are not produced by the code under test.
//
// Run:  node tools/safe_id_reference.js            -> prints vectors as JSON
//       node tools/safe_id_reference.js --check    -> self-checks invariants
const MAX_ID_BYTES = 1400;

function utf8Len(s) {
  let n = 0;
  for (const ch of s) {
    const r = ch.codePointAt(0);
    n += r <= 0x7f ? 1 : r <= 0x7ff ? 2 : r <= 0xffff ? 3 : 4;
  }
  return n;
}
function needsEscaping(s) {
  for (const ch of s) {
    const r = ch.codePointAt(0);
    if (r === 0x2f || r < 0x20 || r === 0x7f) return true;
  }
  return false;
}
function escapeForDocId(s) {
  let out = '';
  for (const ch of s) {
    const r = ch.codePointAt(0);
    if (r === 0x2f) out += '%2F';
    else if (r < 0x20 || r === 0x7f) out += '%' + r.toString(16).padStart(2, '0').toUpperCase();
    else out += ch;
  }
  return out;
}
function stableHashHex(s) {
  let h = 0xcbf29ce484222325n;
  const prime = 0x100000001b3n;
  const mask = 0xffffffffffffffffn;
  for (let i = 0; i < s.length; i++) { // UTF-16 code units == Dart String.codeUnits
    h = (h ^ BigInt(s.charCodeAt(i))) & mask;
    h = (h * prime) & mask;
  }
  return h.toString(16).padStart(16, '0');
}
function safeId(raw) {
  const t = (raw == null ? '' : raw).trim();
  if (t === '') return '';
  if (utf8Len(t) <= MAX_ID_BYTES && !needsEscaping(t)) return t;
  const digest = stableHashHex(t);
  const prefix = t.length <= 24 ? t : t.slice(0, 24); // UTF-16 units, like Dart substring
  return escapeForDocId(prefix) + '~' + digest;
}

// Inputs. Whitespace vectors use only ASCII space/tab/newline (identical
// trim() behaviour in Dart and JS). Emoji are placed after index 24 in long
// ids so the 24-unit prefix never splits a surrogate pair.
const inputs = [
  ['null', null],
  ['empty', ''],
  ['spaces_only', '   '],
  ['plain', 'software_engineer'],
  ['plain_trimmed', '  ai_engineer \n'],
  ['event_quiz', 'quiz:ai_engineer_level1_lesson2:3'],
  ['event_goal', 'goal:software_engineer:software_engineer_se_f_01_2026-11-14_0'],
  ['unicode_latin', 'ñandú_résumé'],
  ['unicode_cjk', '日本語のコース'],
  ['unicode_emoji', 'course_🚀_level1'],
  ['slash_simple', 'a/b'],
  ['slash_leading', '/abc'],
  ['slash_long_prefix', 'quiz/ai_engineer/level1/lesson2/question3/extra'],
  ['control_soh', 'ab\u0001cd'],
  ['control_newline_inside', 'ab\ncd'],
  ['control_tab_inside', 'ab\tcd'],
  ['control_del', 'ab\u007fcd'],
  ['control_mixed_slash', 'x/\u0001/\u007f/y'],
  ['boundary_1400_ascii', 'a'.repeat(1400)],
  ['long_1401_ascii', 'a'.repeat(1401)],
  ['long_cjk_1410_bytes', '日'.repeat(470)],
  ['long_cjk_1398_bytes_passes', '日'.repeat(466)],
  ['long_mixed_emoji_after_prefix', 'x'.repeat(30) + '🚀'.repeat(400)],
];

const vectors = inputs.map(([name, input]) => ({ name, input, expected: safeId(input) }));

if (process.argv.includes('--check')) {
  let failed = 0;
  const ok = (cond, msg) => { if (!cond) { failed++; console.error('FAIL', msg); } };
  const by = Object.fromEntries(vectors.map((v) => [v.name, v]));
  ok(by.null.expected === '' && by.empty.expected === '' && by.spaces_only.expected === '', 'empty-ish -> ""');
  ok(by.plain.expected === 'software_engineer', 'plain passes through');
  ok(by.plain_trimmed.expected === 'ai_engineer', 'trim');
  ok(by.event_quiz.expected === by.event_quiz.input, 'event ids with ":" pass through');
  ok(by.unicode_latin.expected === 'ñandú_résumé', 'non-ASCII short ids pass through');
  ok(by.unicode_cjk.expected === '日本語のコース', 'CJK short ids pass through');
  ok(by.slash_simple.expected.startsWith('a%2Fb~') && by.slash_simple.expected.length === 'a%2Fb~'.length + 16, 'slash escaped + 16-hex digest');
  ok(by.control_soh.expected.startsWith('ab%01cd~'), 'control char escaped as %01');
  ok(by.control_del.expected.startsWith('ab%7Fcd~'), 'DEL escaped as %7F');
  ok(by.boundary_1400_ascii.expected === 'a'.repeat(1400), '1400 bytes still passes through');
  ok(by.long_1401_ascii.expected === 'a'.repeat(24) + '~' + stableHashHex('a'.repeat(1401)), '1401 bytes is hashed');
  ok(by.long_cjk_1410_bytes.expected.startsWith('日'.repeat(24) + '~'), 'long CJK hashed, prefix is 24 units');
  ok(by.long_cjk_1398_bytes_passes.expected === '日'.repeat(466), '1398-byte CJK passes through');
  // Determinism and uniqueness
  ok(safeId('a/b') === safeId('a/b'), 'deterministic');
  ok(safeId('a/b') !== safeId('a%2Fb'), 'escaped form cannot collide with a literal "%2F" id');
  for (const v of vectors) {
    ok(!v.expected.includes('/'), `no slash in output for ${v.name}`);
    ok(utf8Len(v.expected) <= 1400, `output within byte limit for ${v.name}`);
  }
  console.log(failed === 0 ? `reference self-check OK (${vectors.length} vectors)` : `${failed} FAILED`);
  process.exit(failed === 0 ? 0 : 1);
}

console.log(JSON.stringify(vectors, null, 2));