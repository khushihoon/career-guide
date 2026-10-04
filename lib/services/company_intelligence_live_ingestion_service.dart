import 'dart:convert';

import 'package:http/http.dart' as http;

import 'company_intelligence_live_source_catalog.dart';
import 'company_intelligence_models.dart';
import 'company_intelligence_service.dart';

/// Step 6E-4 — Live source ingestion bridge.
///
/// Flutter does not fetch arbitrary ATS/provider endpoints directly. Instead,
/// the development/production ingestion endpoint fetches the permitted source
/// and returns a small, validated envelope containing the provider payload.
///
/// The provider payload is then passed through the existing 6E-4 repository:
///
/// source payload
///   -> provider adapter
///   -> normalized postings
///   -> deterministic extraction
///   -> CompanyIntelligenceSnapshot
///   -> local cache
///   -> UI
///
/// The backend URL is intentionally isolated here so it can be changed to a
/// real HTTPS deployment later without touching the Company Intelligence UI.
class CompanyIntelligenceLiveIngestionService {
  final CompanyIntelligenceService intelligenceService;
  final CompanyIntelligenceLiveSourceCatalog sourceCatalog;

  const CompanyIntelligenceLiveIngestionService({
    this.intelligenceService = const CompanyIntelligenceService(),
    this.sourceCatalog = const CompanyIntelligenceLiveSourceCatalog(),
  });

  /// Development backend used by the local Dart ingestion server.
  ///
  /// The server contract used by this service is:
  ///   GET  /health
  ///   POST /ingest
  ///   POST /ingest/source
  ///
  /// This service uses POST /ingest/source because the backend is responsible
  /// for fetching the configured public company source.
  ///
  /// For Play Store / production deployment this must be changed to the
  /// deployed HTTPS backend. Do not point a released Android app at
  /// localhost because localhost then means the user's device itself.
  static const String developmentBackendBaseUrl =
      'http://localhost:8091';

  Future<CompanyIntelligenceSnapshot?> refreshCompany(
    String companyName, {
    String backendBaseUrl = developmentBackendBaseUrl,
  }) async {
    final config = sourceCatalog.forCompanyName(companyName);
    if (config == null) return null;

    final endpoint = Uri.parse(
      '$backendBaseUrl/ingest/source',
    );

    final client = http.Client();

    try {
      final requestBody = <String, dynamic>{
        'companyId': config.companyId,
        'companyName': config.companyName,
        'sourceType': config.sourceType.name,
        'sourceUrl': config.sourceUrl,
      };

      final response = await client
          .post(
            endpoint,
            headers: const <String, String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 25));

      if (response.statusCode != 200) {
        String details = response.body.trim();

        if (details.isEmpty) {
          details = 'No response body was returned by the ingestion backend.';
        }

        throw StateError(
          'Company Intelligence ingestion returned HTTP '
          '${response.statusCode}: $details',
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map) {
        throw const FormatException(
          'Company Intelligence ingestion returned a non-object response.',
        );
      }

      final envelope = Map<String, dynamic>.from(decoded);
      if (envelope['success'] != true) {
        throw StateError(
          envelope['error']?.toString() ??
              'Company Intelligence ingestion reported an unknown error.',
        );
      }

      final payload = envelope['payload']?.toString();
      if (payload == null || payload.trim().isEmpty) {
        throw const FormatException(
          'Company Intelligence ingestion returned an empty provider payload.',
        );
      }

      final sourceType = _sourceTypeFromEnvelope(
        envelope['sourceType']?.toString(),
        fallback: config.sourceType,
      );

      final snapshot = await intelligenceService.ingestProviderPayload(
        companyId: config.companyId,
        companyName: config.companyName,
        sourceType: sourceType,
        sourceUrl: envelope['sourceUrl']?.toString() ?? config.sourceUrl,
        payload: payload,
        fetchedAt: _parseDate(envelope['fetchedAt']) ?? DateTime.now(),
        sourceLabel: envelope['sourceLabel']?.toString() ?? config.sourceLabel,
        isOfficialCompanySource:
            envelope['isOfficialCompanySource'] == true ||
                config.isOfficialCompanySource,
        supportsLiveJobs:
            envelope['supportsLiveJobs'] == true || config.supportsLiveJobs,
        supportsCompensation: envelope['supportsCompensation'] == true ||
            config.supportsCompensation,
      );

      return snapshot;
    } on FormatException {
      rethrow;
    } on StateError {
      rethrow;
    } catch (error) {
      throw StateError(
        'Company Intelligence live refresh failed for ${config.companyName}: $error',
      );
    } finally {
      client.close();
    }
  }

  Future<CompanyIntelligenceSnapshot?> refreshOpenAi() {
    return refreshCompany('OpenAI');
  }

  /// Checks whether the configured ingestion backend is reachable.
  ///
  /// This is useful during local development and can also be used by a
  /// future production diagnostics screen. It does not fetch company data.
  Future<bool> checkBackendHealth({
    String backendBaseUrl = developmentBackendBaseUrl,
  }) async {
    final endpoint = Uri.parse('$backendBaseUrl/health');
    final client = http.Client();

    try {
      final response = await client
          .get(
            endpoint,
            headers: const <String, String>{
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (_) {
      return false;
    } finally {
      client.close();
    }
  }

  CompanySourceType _sourceTypeFromEnvelope(
    String? value, {
    required CompanySourceType fallback,
  }) {
    if (value == null || value.trim().isEmpty) return fallback;

    for (final type in CompanySourceType.values) {
      if (type.name == value) return type;
    }

    return fallback;
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}


