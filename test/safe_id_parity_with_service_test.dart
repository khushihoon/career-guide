// test/safe_id_parity_with_service_test.dart
//
// Proves safeDocId() == the ORIGINAL CopilotFirestoreService._safeId() on
// identical inputs.
//
// REQUIRES one additive line in lib/services/copilot_firestore_service.dart
// (see PHASE3_STAGE2_NOTES.md, "Parity hook"):
//
//   @visibleForTesting
//   static String safeIdForParityTest(String? raw) => _safeId(raw);
//
// (import 'package:flutter/foundation.dart' show visibleForTesting;)
//
// Run: flutter test test/safe_id_parity_with_service_test.dart
import 'package:flutter_test/flutter_test.dart';

import '../lib/services/copilot_firestore_service.dart';
import '../lib/services/safe_doc_id.dart';
import 'safe_doc_id_test.dart' show safeIdVectors, longVectors;

void main() {
  group('safeDocId == CopilotFirestoreService._safeId', () {
    for (final v in [
      ...safeIdVectors,
      ...longVectors().map((e) => (e.$1, e.$2 as String?, e.$3)),
    ]) {
      test(v.$1, () {
        final original = CopilotFirestoreService.safeIdForParityTest(v.$2);
        expect(safeDocId(v.$2), original);
        expect(original, v.$3); // and both equal the independent reference
      });
    }
  });
}
