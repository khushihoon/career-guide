import 'dart:convert';

import 'package:http/http.dart' as http;

import 'company_intelligence_ids.dart';
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
/// TRUST RULES (the backend is a courier, not an authority):
/// - Which source is used, its type, URL, label and its "official" /
///   "supports live jobs" / "supports compensation" flags come ONLY from the
///   app's own source catalog. Values in the backend envelope never override
///   them.
/// - The envelope must be for the requested company; otherwise it is rejected.
/// - The payload must be recent ([maxPayloadAge]). An old payload is rejected,
///   so a stale backend copy can never be presented as live data.
/// - Outside local development the backend must use HTTPS.
///
/// BACKEND URL:
/// The backend address is read from the build-time setting
/// `CAREER_GUIDE_BACKEND_URL` (pass it with
/// `--dart-define=CAREER_GUIDE_BACKEND_URL=https://your-host`). When it is not
/// set, the local development address is used. A released app must always be
/// built with an HTTPS address: on a phone `localhost` means the phone itself.
class CompanyIntelligenceLiveIngestionService {
  final CompanyIntelligenceService intelligenceService;
  final CompanyIntelligenceLiveSourceCatalog sourceCatalog;

  const CompanyIntelligenceLiveIngestionService({
    this.intelligenceService = const CompanyIntelligenceService(),
    this.sourceCatalog = const CompanyIntelligenceLiveSourceCatalog(),
  });

  /// Backend used by the ingestion service.
  ///
  /// The server contract used by this service is:
  ///   GET  /health
  ///   POST /ingest
  ///   POST /ingest/source
  ///
  /// This service uses POST /ingest/source because the backend is responsible
  /// for fetching the configured public company source.
  static const String developmentBackendBaseUrl = String.fromEnvironment(
    'CAREER_GUIDE_BACKEND_URL',
    defaultValue: 'http://localhost:8091',
  );

  /// A payload fetched longer ago than this is not treated as live.
  static const Duration maxPayloadAge = Duration(hours: 6);

  Future<CompanyIntelligenceSnapshot?> refreshCompany(
    String companyName, {
    String backendBaseUrl = developmentBackendBaseUrl,
  }) async {
    final config = sourceCatalog.forCompanyName(companyName);
    if (config == null) return null;

    final baseUrl = _cleanBaseUrl(backendBaseUrl);

    if (!_isAllowedBackend(baseUrl)) {
      throw StateError(
        'Company Intelligence backend must use HTTPS '
        '(plain HTTP is allowed only for local development).',
      );
    }

    final endpoint = Uri.parse(
      '$baseUrl/ingest/source',
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

      // The envelope must be for the company that was requested.
      final envelopeCompanyId = envelope['companyId']?.toString().trim() ?? '';
      if (envelopeCompanyId.isNotEmpty &&
          CompanyIntelligenceIds.fromIdOrName(envelopeCompanyId) !=
              CompanyIntelligenceIds.fromIdOrName(config.companyId)) {
        throw StateError(
          'Company Intelligence ingestion returned data for a different '
          'company than requested.',
        );
      }

      final payload = envelope['payload']?.toString();
      if (payload == null || payload.trim().isEmpty) {
        throw const FormatException(
          'Company Intelligence ingestion returned an empty provider payload.',
        );
      }

      final fetchedAt = _validatedFetchTime(envelope['fetchedAt']);

      // Source identity and trust flags come from the app's own catalog only.
      final snapshot = await intelligenceService.ingestProviderPayload(
        companyId: config.companyId,
        companyName: config.companyName,
        sourceType: config.sourceType,
        sourceUrl: config.sourceUrl,
        payload: payload,
        fetchedAt: fetchedAt,
        sourceLabel: config.sourceLabel,
        isOfficialCompanySource: config.isOfficialCompanySource,
        supportsLiveJobs: config.supportsLiveJobs,
        supportsCompensation: config.supportsCompensation,
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
    final baseUrl = _cleanBaseUrl(backendBaseUrl);

    if (!_isAllowedBackend(baseUrl)) return false;

    final endpoint = Uri.parse('$baseUrl/health');
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

  /// The time the backend says it fetched the source.
  ///
  /// - Missing or in the future: the current time is used.
  /// - Older than [maxPayloadAge]: rejected, so the data is never shown as
  ///   live.
  DateTime _validatedFetchTime(dynamic value) {
    final now = DateTime.now();
    final parsed = _parseDate(value);

    if (parsed == null || parsed.isAfter(now.add(const Duration(minutes: 5)))) {
      return now;
    }

    if (now.difference(parsed) > maxPayloadAge) {
      throw StateError(
        'Company Intelligence ingestion returned an outdated payload, so it '
        'is not treated as live data.',
      );
    }

    return parsed;
  }

  String _cleanBaseUrl(String value) {
    return value.trim().replaceAll(RegExp(r'/+$'), '');
  }

  /// HTTPS is required. Plain HTTP is accepted only for local development
  /// hosts (this machine, or the Android emulator's host alias).
  bool _isAllowedBackend(String baseUrl) {
    final uri = Uri.tryParse(baseUrl);

    if (uri == null || !uri.hasScheme || uri.host.isEmpty) return false;

    if (uri.scheme == 'https') return true;

    if (uri.scheme != 'http') return false;

    const developmentHosts = <String>{
      'localhost',
      '127.0.0.1',
      '10.0.2.2',
    };

    return developmentHosts.contains(uri.host);
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}