import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'company_intelligence_live_source_catalog.dart';
import 'company_intelligence_models.dart';
import 'company_intelligence_service.dart';

/// Step 6E-4 — Live source ingestion bridge.
///
/// Phase 1 enforces the server/client contract and fails closed when identity,
/// source, payload, or freshness metadata cannot be validated.
class CompanyIntelligenceLiveIngestionService {
  final CompanyIntelligenceService intelligenceService;
  final CompanyIntelligenceLiveSourceCatalog sourceCatalog;

  const CompanyIntelligenceLiveIngestionService({
    this.intelligenceService = const CompanyIntelligenceService(),
    this.sourceCatalog = const CompanyIntelligenceLiveSourceCatalog(),
  });

  /// Set in a release build with:
  /// --dart-define=CAREER_GUIDE_BACKEND_URL=https://your-api.example.com
  static const String developmentBackendBaseUrl = String.fromEnvironment(
    'CAREER_GUIDE_BACKEND_URL',
    defaultValue: 'http://localhost:8091',
  );

  static const Duration requestTimeout = Duration(seconds: 55);
  static const Duration maxPayloadAge = Duration(hours: 6);
  static const Duration allowedFutureSkew = Duration(minutes: 5);

  Future<CompanyIntelligenceSnapshot?> refreshCompany(
    String companyName, {
    String backendBaseUrl = developmentBackendBaseUrl,
  }) async {
    final config = sourceCatalog.forCompanyName(companyName);
    if (config == null) return null;

    final baseUrl = _validatedBackendBaseUrl(backendBaseUrl);
    final endpoint = Uri.parse('$baseUrl/ingest/source');
    final client = http.Client();

    try {
      // Production backend verifies Firebase ID tokens server-side. No static
      // API secret is embedded in the app. Local development remains usable
      // without sign-in while backend auth is disabled in local mode.
      final user = FirebaseAuth.instance.currentUser;
      final idToken = user == null ? null : await user.getIdToken();
      final headers = <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (idToken != null && idToken.isNotEmpty)
          'Authorization': 'Bearer $idToken',
      };
      final response = await client
          .post(
            endpoint,
            headers: headers,
            body: jsonEncode(<String, dynamic>{
              'companyId': config.companyId,
              'companyName': config.companyName,
              'sourceType': config.sourceType.name,
              'sourceUrl': config.sourceUrl,
            }),
          )
          .timeout(requestTimeout);

      if (response.statusCode != 200) {
        // Do not surface arbitrary server/provider response bodies to the UI.
        throw StateError(
          'Company Intelligence ingestion returned HTTP ${response.statusCode}.',
        );
      }

      final dynamic decoded = jsonDecode(response.body);
      if (decoded is! Map) {
        throw const FormatException(
          'Ingestion backend returned a non-object JSON response.',
        );
      }
      final envelope = Map<String, dynamic>.from(decoded);
      if (envelope['success'] != true) {
        throw StateError(
          envelope['error']?.toString() ??
              'Ingestion backend did not confirm success.',
        );
      }

      _requireExactString(envelope, 'companyId', config.companyId);
      _requireExactString(envelope, 'companyName', config.companyName);
      _requireExactString(envelope, 'sourceType', config.sourceType.name);
      _requireExactString(envelope, 'sourceUrl', config.sourceUrl);

      final payload = envelope['payload'];
      if (payload is! String || payload.trim().isEmpty) {
        throw const FormatException(
          'Ingestion backend omitted the provider payload required by the client adapter pipeline.',
        );
      }
      if (utf8.encode(payload).length > 2 * 1024 * 1024) {
        throw const FormatException(
          'Ingestion backend provider payload exceeded the 2 MiB client limit.',
        );
      }

      final jobs = envelope['jobs'];
      final jobCount = envelope['jobCount'];
      if (jobs is! List || jobCount is! int || jobCount != jobs.length) {
        throw const FormatException(
          'Ingestion backend jobs/jobCount contract is invalid.',
        );
      }
      final snapshot = envelope['snapshot'];
      if (snapshot is! Map ||
          snapshot['companyId'] != config.companyId ||
          snapshot['companyName'] != config.companyName) {
        throw const FormatException(
          'Ingestion backend snapshot identity did not match the configured company.',
        );
      }
      final fetchedAt = _validatedFetchTime(envelope['fetchedAt']);

      // Source trust/capabilities come from the app's configured catalog, not
      // from backend response flags that could accidentally elevate trust.
      return intelligenceService.ingestProviderPayload(
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
    } on FormatException {
      rethrow;
    } on StateError {
      rethrow;
    } catch (error) {
      // Error details may contain implementation/network data. Keep the user
      // message useful without forwarding arbitrary exception text.
      throw StateError(
        'Company Intelligence live refresh failed for ${config.companyName} (${error.runtimeType}).',
      );
    } finally {
      client.close();
    }
  }

  Future<CompanyIntelligenceSnapshot?> refreshOpenAi({
    String backendBaseUrl = developmentBackendBaseUrl,
  }) => refreshCompany('OpenAI', backendBaseUrl: backendBaseUrl);

  Future<bool> checkBackendHealth({
    String backendBaseUrl = developmentBackendBaseUrl,
  }) async {
    final baseUrl = _validatedBackendBaseUrl(backendBaseUrl);
    final client = http.Client();
    try {
      final response = await client
          .get(
            Uri.parse('$baseUrl/health'),
            headers: const <String, String>{'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return false;
      final dynamic decoded = jsonDecode(response.body);
      return decoded is Map &&
          decoded['success'] == true &&
          decoded['status'] == 'running';
    } catch (_) {
      return false;
    } finally {
      client.close();
    }
  }

  String _validatedBackendBaseUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    if (uri == null || uri.host.isEmpty || uri.userInfo.isNotEmpty) {
      throw const FormatException('Backend base URL is invalid.');
    }
    final developmentHost = _isDevelopmentHost(uri.host.toLowerCase());

    // Debug builds may connect to a development server running on the same
    // computer or on the private LAN (for a physical Android device test).
    // Public HTTP endpoints and all release-build HTTP endpoints are rejected.
    if (uri.scheme != 'https' &&
        !(uri.scheme == 'http' && developmentHost && !kReleaseMode)) {
      throw const FormatException(
        'Backend must use HTTPS. HTTP is allowed only for a local/private-LAN debug server.',
      );
    }
    if (kReleaseMode && developmentHost) {
      throw const FormatException(
        'Release builds cannot use loopback/private-LAN backend addresses. Configure CAREER_GUIDE_BACKEND_URL with the deployed HTTPS API.',
      );
    }
    if (uri.hasQuery || uri.hasFragment) {
      throw const FormatException(
        'Backend base URL must not contain a query or fragment.',
      );
    }
    final path = uri.path.endsWith('/')
        ? uri.path.substring(0, uri.path.length - 1)
        : uri.path;
    return uri.replace(path: path, query: null, fragment: null).toString();
  }

  bool _isDevelopmentHost(String host) {
    if (const <String>{
      'localhost',
      '::1',
      '10.0.2.2', // Android emulator host alias.
    }.contains(host)) {
      return true;
    }

    // Permit RFC1918 IPv4 addresses only for debug testing on a physical
    // device. Do not permit link-local, public, multicast, or unspecified IPs.
    final parts = host.split('.');
    if (parts.length != 4) return false;

    final octets = <int>[];
    for (final part in parts) {
      final octet = int.tryParse(part);
      if (octet == null || octet < 0 || octet > 255) return false;
      octets.add(octet);
    }

    final first = octets[0];
    final second = octets[1];
    return first == 127 ||
        first == 10 ||
        (first == 172 && second >= 16 && second <= 31) ||
        (first == 192 && second == 168);
  }

  void _requireExactString(
    Map<String, dynamic> envelope,
    String key,
    String expected,
  ) {
    final actual = envelope[key];
    if (actual is! String || actual.trim() != expected) {
      throw FormatException(
        'Ingestion backend $key did not match the configured source.',
      );
    }
  }

  DateTime _validatedFetchTime(dynamic value) {
    if (value is! String || value.trim().isEmpty) {
      throw const FormatException(
        'Ingestion backend omitted the required fetchedAt timestamp.',
      );
    }
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      throw const FormatException(
        'Ingestion backend returned an invalid fetchedAt timestamp.',
      );
    }
    final now = DateTime.now().toUtc();
    final fetchedAt = parsed.toUtc();
    if (fetchedAt.isAfter(now.add(allowedFutureSkew))) {
      throw const FormatException(
        'Ingestion backend timestamp is too far in the future.',
      );
    }
    if (now.difference(fetchedAt) > maxPayloadAge) {
      throw const FormatException(
        'Ingestion backend response is stale and cannot confirm current hiring.',
      );
    }
    return fetchedAt;
  }
}
