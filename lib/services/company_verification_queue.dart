/// Career Guide — Company Verification Queue
///
/// This file centralizes the relationship-layer companies that have NOT yet
/// been promoted to the verified company registry.
///
/// PURPOSE:
/// - Preserve the whole relationship-layer scope across verification batches
///   so nothing is silently lost.
/// - Make it explicit which companies still require official-source evidence.
///
/// AUTHORITY (locked):
/// - `verified_company_data.dart` is the authoritative registry for canonical
///   company identity and verified reference intelligence.
/// - This queue is WORKFLOW data only. It never overrides the registry and is
///   never used to decide what is shown as verified.
/// - On any conflict, the registry wins and this queue is reconciled to it.
/// - `sourceChecked` in `company_reference_registry.dart` is evidence metadata,
///   not an authority. A company with `sourceChecked: true` can still be
///   pending here until its details are promoted to the verified registry.
///
/// RULES:
/// - Membership in this queue means PENDING_VERIFICATION, not verified.
/// - Do not add skills/technologies/roles for queued companies.
/// - Do not create fake profiles to "complete" the queue.
/// - Move an entry out of this queue only when official evidence has been
///   verified and the company has been added to `verified_company_data.dart`.
///
/// REGISTRY CONSISTENCY:
/// - This file must NOT contain any company that already exists in
///   `verified_company_data.dart`.
/// - Every Home / relationship-layer company that does NOT resolve to a
///   verified profile must appear here.
///
/// COUNTS (final audit 2026-10-09):
/// - Verified registry profiles: 105 unique canonical company profiles.
/// - Pending verification queue: 0 entries.
/// - Home/relationship-layer names are resolved by canonical names or approved
///   aliases; the four additional profiles Microsoft, NVIDIA, Amazon and Apple
///   remain part of the broader registry universe.
/// - Final audit reconciled every former queue entry with a verified profile
///   or a documented successor identity; unsupported role/skill fields remain
///   empty rather than being guessed.
///
/// This file is REFERENCE data about verification status.
/// It is NOT skill evidence and NOT live hiring data.
class CompanyVerificationQueue {
  CompanyVerificationQueue._();

  /// Relationship-layer companies still awaiting official-source verification.
  ///
  /// Re-queued companies (previously claimed as verified with sources that
  /// were not actually reviewed):
  ///   - Scale AI
  ///   - Tabnine
  ///   - Codeium
  ///   - ElevenLabs
  ///   - Mistral AI
  ///   - xAI
  // Final audit: all former pending entries are reconciled with the registry.
  // FINAL AUDIT 2026-10-09: all 29 formerly pending entries were promoted
  // to the registry using official company / successor evidence. Queue is empty.
  static const List<String> pending = <String>[];

  static int get pendingCount => pending.length;

  static bool isPending(String name) {
    final normalized = _normalize(name);
    for (final item in pending) {
      if (_normalize(item) == normalized) return true;
    }
    return false;
  }

  static String _normalize(String value) => value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
}
