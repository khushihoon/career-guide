// test/safe_doc_id_test.dart
//
// Expected values were produced by tools/safe_id_reference.js (an
// independent JavaScript implementation; `node tools/safe_id_reference.js
// --check` passes) — NOT by the code under test.
//
// Run: flutter test test/safe_doc_id_test.dart
//
// The same vectors are reused in test/safe_id_parity_with_service_test.dart,
// which compares the ORIGINAL CopilotFirestoreService._safeId (after the
// one-line test hook described in PHASE3_STAGE2_NOTES.md is applied).
import 'package:flutter_test/flutter_test.dart';

import '../lib/services/safe_doc_id.dart';

/// (name, input, expected)
const List<(String, String?, String)> safeIdVectors = [
  ('null', null, ''),
  ('empty', '', ''),
  ('spaces_only', '   ', ''),
  ('plain', 'software_engineer', 'software_engineer'),
  ('plain_trimmed', '  ai_engineer \u000a', 'ai_engineer'),
  (
    'event_quiz',
    'quiz:ai_engineer_level1_lesson2:3',
    'quiz:ai_engineer_level1_lesson2:3'
  ),
  (
    'event_goal',
    'goal:software_engineer:software_engineer_se_f_01_2026-11-14_0',
    'goal:software_engineer:software_engineer_se_f_01_2026-11-14_0'
  ),
  (
    'unicode_latin',
    '\u00f1and\u00fa_r\u00e9sum\u00e9',
    '\u00f1and\u00fa_r\u00e9sum\u00e9'
  ),
  (
    'unicode_cjk',
    '\u65e5\u672c\u8a9e\u306e\u30b3\u30fc\u30b9',
    '\u65e5\u672c\u8a9e\u306e\u30b3\u30fc\u30b9'
  ),
  ('unicode_emoji', 'course_\u{1f680}_level1', 'course_\u{1f680}_level1'),
  ('slash_simple', 'a/b', 'a%2Fb~e620c3190468cf61'),
  ('slash_leading', '/abc', '%2Fabc~3744599cb46e12ba'),
  (
    'slash_long_prefix',
    'quiz/ai_engineer/level1/lesson2/question3/extra',
    'quiz%2Fai_engineer%2Flevel1%2F~92aa84d79f9c574d'
  ),
  ('control_soh', 'ab\u0001cd', 'ab%01cd~b41f6a2f56e9cd96'),
  ('control_newline_inside', 'ab\u000acd', 'ab%0Acd~55b7b52f21b0e727'),
  ('control_tab_inside', 'ab\u0009cd', 'ab%09cd~6fad122f3062a27e'),
  ('control_del', 'ab\u007fcd', 'ab%7Fcd~cbfc802db1a85740'),
  (
    'control_mixed_slash',
    'x/\u0001/\u007f/y',
    'x%2F%01%2F%7F%2Fy~ceef9ee1198a8aa1'
  ),
];

/// Long vectors are generated (identical construction to the JS reference).
List<(String, String, String)> longVectors() {
  final cjk24 = '\u65e5' * 24;
  return [
    ('boundary_1400_ascii', 'a' * 1400, 'a' * 1400),
    ('long_1401_ascii', 'a' * 1401, '${'a' * 24}~5eface4cb1006c14'),
    ('long_cjk_1410_bytes', '\u65e5' * 470, '$cjk24~1a66655a56adf42b'),
    ('long_cjk_1398_bytes_passes', '\u65e5' * 466, '\u65e5' * 466),
    (
      'long_mixed_emoji_after_prefix',
      'x' * 30 + '\u{1f680}' * 400,
      '${'x' * 24}~39529452480d827d'
    ),
  ];
}

void main() {
  group('safeDocId matches the independent reference vectors', () {
    for (final v in safeIdVectors) {
      test(v.$1, () => expect(safeDocId(v.$2), v.$3));
    }
    for (final v in longVectors()) {
      test(v.$1, () => expect(safeDocId(v.$2), v.$3));
    }
  });

  group('invariants', () {
    test('never returns a slash and never exceeds the byte limit', () {
      for (final v in [...safeIdVectors, ...longVectors()]) {
        final out = safeDocId(v.$2);
        expect(out.contains('/'), isFalse, reason: v.$1);
        expect(out.codeUnits.length <= 1400 * 4, isTrue, reason: v.$1);
      }
    });
    test('escaped output cannot collide with a literal %2F id', () {
      expect(safeDocId('a/b'), isNot(safeDocId('a%2Fb')));
    });
    test('deterministic', () {
      expect(safeDocId('x/y'), safeDocId('x/y'));
    });
  });
}
