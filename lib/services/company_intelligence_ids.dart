import 'verified_company_data.dart';

/// Step 6E-4 — Stable company identifiers.
///
/// The same identifier is used by the Flutter cache and by the future backend
/// ingestion layer. This prevents company-name spelling differences from
/// creating separate intelligence records.
///
/// Canonical verified company IDs are resolved through [VerifiedCompanyData].
/// Unknown companies still receive a deterministic normalized identifier.
class CompanyIntelligenceIds {
  const CompanyIntelligenceIds._();

  /// Returns the canonical stable ID for a company name.
  ///
  /// If the company exists in the verified company registry, its canonical
  /// registry ID is returned.
  ///
  /// Otherwise, a deterministic normalized ID is generated from the company
  /// name so unknown/legacy companies remain supported.
  static String fromCompanyName(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return 'unknown-company';
    }

    final verified = VerifiedCompanyData.find(trimmed);

    if (verified != null && verified.companyId.trim().isNotEmpty) {
      return verified.companyId;
    }

    return _normalize(trimmed);
  }

  /// Returns the canonical stable ID when an ID or company name is supplied.
  ///
  /// Verified IDs are preserved. Verified company names and aliases are
  /// resolved through the canonical company registry.
  ///
  /// Unknown IDs are normalized but not replaced with unrelated companies.
  static String fromIdOrName(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return 'unknown-company';
    }

    final verified = VerifiedCompanyData.find(trimmed);

    if (verified != null && verified.companyId.trim().isNotEmpty) {
      return verified.companyId;
    }

    return _normalize(trimmed);
  }

  /// Checks whether the supplied company identifier/name belongs to the
  /// verified canonical company registry.
  static bool isVerified(String value) {
    return VerifiedCompanyData.find(value.trim()) != null;
  }

  /// Returns the canonical company name when the supplied value is verified.
  ///
  /// Returns null when the company is not present in the verified registry.
  static String? canonicalName(String value) {
    return VerifiedCompanyData.find(value.trim())?.companyName;
  }

  /// Returns the canonical ID for a verified company, or null when the
  /// company is not present in the verified registry.
  static String? verifiedId(String value) {
    return VerifiedCompanyData.find(value.trim())?.companyId;
  }

  static String _normalize(String value) {
    final normalized = value
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-');

    final compact = normalized
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');

    return compact.isEmpty ? 'unknown-company' : compact;
  }
}