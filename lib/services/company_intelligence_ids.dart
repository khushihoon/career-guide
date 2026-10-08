import 'verified_company_data.dart';

/// Step 6E-4 — Stable company identifiers.
///
/// The same identifier is used by the Flutter cache and by the future backend
/// ingestion layer. This prevents company-name spelling differences from
/// creating separate intelligence records.
///
/// ID FORMAT (locked, one format across all layers):
/// - lower-case, every run of non-alphanumeric characters becomes a single
///   underscore, no leading/trailing underscore (for example
///   `google_deepmind`, `weights_biases`).
/// - This is the same convention used by the verified registry
///   (`verified_company_data.dart`) and by `HomeMarketService`, so a company
///   keeps the SAME ID before and after it is promoted to the verified
///   registry, and cache keys do not change on promotion.
///
/// IDENTITY (locked):
/// - Canonical identity comes from the authoritative registry
///   ([VerifiedCompanyData.canonicalIdentity]): verified companies and the
///   approved canonicalizations of the registry's ALIAS POLICY (for example
///   Salesforce Einstein → salesforce, Notion AI → notion,
///   Adobe Firefly → adobe).
/// - Unknown companies still receive a deterministic normalized identifier.
///   No other alias is applied, so "Microsoft AI" is NOT merged with
///   "Microsoft".
class CompanyIntelligenceIds {
  const CompanyIntelligenceIds._();

  /// Sentinel returned when no usable company name/ID was supplied.
  ///
  /// Kept exactly as before because other layers compare against this value.
  static const String unknownCompanyId = 'unknown-company';

  /// Returns the canonical stable ID for a company name.
  ///
  /// If the company is a verified company or an approved canonicalization,
  /// its canonical registry ID is returned.
  ///
  /// Otherwise, a deterministic normalized ID is generated from the company
  /// name so unknown/legacy companies remain supported.
  static String fromCompanyName(String value) {
    return _resolve(value);
  }

  /// Returns the canonical stable ID when an ID or company name is supplied.
  ///
  /// Verified IDs are preserved. Verified company names, approved aliases and
  /// approved canonicalizations resolve through the authoritative registry.
  ///
  /// Unknown IDs are normalized but not replaced with unrelated companies.
  static String fromIdOrName(String value) {
    return _resolve(value);
  }

  /// Checks whether the supplied company identifier/name belongs to the
  /// verified canonical company registry (a verified profile exists).
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

  static String _resolve(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return unknownCompanyId;
    }

    final identity = VerifiedCompanyData.canonicalIdentity(trimmed);

    if (identity != null && identity.companyId.trim().isNotEmpty) {
      return identity.companyId;
    }

    return _normalize(trimmed);
  }

  static String _normalize(String value) {
    final normalized = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    return normalized.isEmpty ? unknownCompanyId : normalized;
  }
}
