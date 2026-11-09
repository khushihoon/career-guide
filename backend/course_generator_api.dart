import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../lib/data/courses/course_generator_config.dart';
import '../lib/services/local_course_generator.dart';

/// Course Generator API + secure Claude proxy.
///
/// Public response contracts:
///   GET  /health               -> {success, message, mode, claude}
///   POST /generate-course      -> {success, mock, request, course}
///   POST /generate-lesson-list -> {success, mock, request, lessonList}
///   POST /claude/messages      -> {success, content, stopReason, usage}
///
/// CHANGED (to match lib/services/course_generator_service.dart):
///  * /generate-course and /generate-lesson-list now ALSO return `request`,
///    which repeats the validated request identity:
///      course:      {careerId, categoryId, level, lessonIndex | null}
///      lesson list: {careerId, categoryId, level, lessonCount}
///    The values come from the validated request, never from AI text. The app
///    compares them with what it asked for and rejects a mismatch.
///  * careerId, categoryId and level are now required for both routes
///    (also when OPENAI_API_KEY is set).
///  * In AI mode the course's careerId/categoryId are forced to the request
///    values before validation.
///  * Error bodies of the course routes no longer include internal details
///    (no `providerStatus`, no internal message for unsupported courses).
///    The /claude/messages error behaviour is unchanged.
///
/// SECURITY MODEL (unchanged)
///  * ANTHROPIC_API_KEY / OPENAI_API_KEY exist ONLY in this server's
///    environment. The Flutter app never sees them.
///  * /claude/messages ALWAYS requires a valid Firebase ID token.
///  * Per-IP pre-auth limit (protects the token-verification step), then
///    per-user per-minute limit, then per-user daily quota (protects your
///    Anthropic credit).
///  * Provider error bodies are never returned to callers.
///
/// Environment:
///   PORT, ANTHROPIC_API_KEY, OPENAI_API_KEY, FIREBASE_WEB_API_KEY,
///   CAREER_GUIDE_ENV=production, COURSE_ALLOWED_ORIGINS,
///   COURSE_AUTH_REQUIRED, COURSE_MAX_BODY_BYTES, COURSE_AI_TIMEOUT_SECONDS,
///   TRUST_PROXY=true  (set on Render/Cloud Run so per-IP limits see the real
///                      client address),
///   CLAUDE_RATE_PER_MINUTE (default 10), CLAUDE_DAILY_LIMIT (default 100).
class CourseGeneratorApi {
  static const String openAiUrl = 'https://api.openai.com/v1/chat/completions';
  static const String anthropicUrl = 'https://api.anthropic.com/v1/messages';
  static const String _claudeModel = 'claude-sonnet-4-20250514';
  static final http.Client _client = http.Client();
  static final Map<String, _Window> _windows = {};
  static final Map<String, _CachedToken> _tokenCache = {};
  static final Map<String, _Window> _daily = {};
  static const Duration _tokenCacheTtl = Duration(minutes: 2);

  /// Max total characters (system + all messages) per Claude request.
  static const int _maxClaudeTotalChars = 120000;

  static int get port =>
      int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  static bool get _production =>
      (Platform.environment['CAREER_GUIDE_ENV'] ?? '').trim().toLowerCase() ==
      'production';
  static bool get _trustProxy =>
      (Platform.environment['TRUST_PROXY'] ?? '').trim().toLowerCase() ==
      'true';
  static bool get _authRequired {
    // Production authentication is mandatory and cannot be disabled by env override.
    if (_production) return true;
    final value = (Platform.environment['COURSE_AUTH_REQUIRED'] ?? '')
        .trim()
        .toLowerCase();
    return value == 'true' || value == '1';
  }

  static int get _maxBody {
    final configured =
        int.tryParse(Platform.environment['COURSE_MAX_BODY_BYTES'] ?? '');
    // Always keep an upper bound, even if deployment configuration is wrong.
    return configured == null
        ? 262144
        : configured.clamp(1024, 1048576).toInt();
  }

  static Duration get _timeout {
    final configured =
        int.tryParse(Platform.environment['COURSE_AI_TIMEOUT_SECONDS'] ?? '');
    return Duration(
        seconds: configured == null ? 45 : configured.clamp(5, 90).toInt());
  }

  static int get _claudePerMinute {
    final v =
        int.tryParse(Platform.environment['CLAUDE_RATE_PER_MINUTE'] ?? '');
    return v == null ? 10 : v.clamp(1, 60).toInt();
  }

  static int get _claudeDailyLimit {
    final v = int.tryParse(Platform.environment['CLAUDE_DAILY_LIMIT'] ?? '');
    return v == null ? 100 : v.clamp(1, 10000).toInt();
  }

  static Set<String> get _origins =>
      (Platform.environment['COURSE_ALLOWED_ORIGINS'] ?? '')
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toSet();
  static bool get _hasAiKey =>
      (Platform.environment['OPENAI_API_KEY'] ?? '').trim().isNotEmpty;
  static bool get _hasClaudeKey =>
      (Platform.environment['ANTHROPIC_API_KEY'] ?? '').trim().isNotEmpty;

  static Future<void> start() async {
    if ((_authRequired || _hasClaudeKey) &&
        (Platform.environment['FIREBASE_WEB_API_KEY'] ?? '').trim().isEmpty) {
      throw StateError(
          'FIREBASE_WEB_API_KEY is required when course authentication is enabled.');
    }
    final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    // Never print key values — only booleans.
    stdout.writeln(
        'Course Generator listening on $port; auth=$_authRequired; ai=$_hasAiKey; claude=$_hasClaudeKey; production=$_production');
    await for (final request in server) {
      unawaited(_handle(request));
    }
  }

  /// Best-effort real client address. Behind a trusted reverse proxy
  /// (TRUST_PROXY=true) the LAST X-Forwarded-For entry is the one appended by
  /// that proxy, so it cannot be forged by the caller.
  static String _clientIp(HttpRequest req) {
    if (_trustProxy) {
      final xff = req.headers.value('x-forwarded-for');
      if (xff != null && xff.trim().isNotEmpty) {
        final parts = xff
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        if (parts.isNotEmpty && parts.last.length <= 64) return parts.last;
      }
    }
    return req.connectionInfo?.remoteAddress.address ?? 'unknown';
  }

  static Future<void> _handle(HttpRequest req) async {
    try {
      if (!_cors(req)) {
        await _send(
            req, 403, {'success': false, 'error': 'Origin is not allowed.'});
        return;
      }
      if (req.method == 'OPTIONS') {
        req.response.statusCode = HttpStatus.noContent;
        await req.response.close();
        return;
      }
      if (req.method == 'GET' && req.uri.path == '/health') {
        await _send(req, 200, {
          'success': true,
          'message': 'Course Generator Backend is running.',
          'mode': _hasAiKey ? 'live' : 'mock',
          'claude': _hasClaudeKey,
        });
        return;
      }
      final course = req.method == 'POST' && req.uri.path == '/generate-course';
      final lessons =
          req.method == 'POST' && req.uri.path == '/generate-lesson-list';
      final claude = req.method == 'POST' && req.uri.path == '/claude/messages';
      if (!course && !lessons && !claude) {
        await _send(
            req, 404, {'success': false, 'error': 'Endpoint not found.'});
        return;
      }

      // Cheap per-IP limit BEFORE the token-verification network call, so
      // unauthenticated floods cannot burn Firebase lookup quota.
      final ip = _clientIp(req);
      if (!_allow('ip:$ip:pre', limit: 120)) {
        req.response.headers.set('Retry-After', '60');
        await _send(req, 429, {
          'success': false,
          'error': 'Too many requests. Please try again shortly.'
        });
        return;
      }

      // Claude is always authenticated; production requires auth for every API route.
      final authRequiredForRequest = _authRequired || claude;
      final userId = await _verifyFirebaseToken(
        req,
        required: authRequiredForRequest,
      );
      if (authRequiredForRequest && userId == null) {
        await _send(req, 401, {
          'success': false,
          'error': 'A valid Firebase ID token is required.'
        });
        return;
      }
      final key = userId ?? 'ip:$ip';
      if (!_allow('$key:${claude ? 'claude' : 'general'}',
          limit: claude ? _claudePerMinute : 30)) {
        req.response.headers.set('Retry-After', '60');
        await _send(req, 429, {
          'success': false,
          'error': 'Too many requests. Please try again shortly.'
        });
        return;
      }
      if (claude && userId != null && !_allowDaily(userId)) {
        req.response.headers.set('Retry-After', '3600');
        await _send(req, 429, {
          'success': false,
          'error': 'Daily AI request limit reached. Please try again tomorrow.'
        });
        return;
      }
      final contentType = req.headers.contentType;
      if (contentType == null || contentType.mimeType != 'application/json') {
        await _send(req, 415, {
          'success': false,
          'error': 'Content-Type must be application/json.',
        });
        return;
      }
      final data = await _readBody(req);
      if (data == null) return;
      if (course) {
        await _generateCourse(req, data);
      } else if (lessons) {
        await _generateLessonList(req, data);
      } else {
        await _generateClaudeMessage(req, data);
      }
    } on _TooLarge {
      await _send(
          req, 413, {'success': false, 'error': 'Request body is too large.'});
    } on _BadJson catch (e) {
      await _send(req, 400, {'success': false, 'error': e.message});
    } on LocalGenerationException catch (e) {
      // CHANGED: details go to the server log only, not to the caller.
      stderr.writeln('Unsupported course request: ${e.message}');
      await _send(req, 422,
          {'success': false, 'error': 'This course is not available.'});
    } on _AiTimeout {
      await _send(req, 504,
          {'success': false, 'error': 'AI provider request timed out.'});
    } on _AiUnavailable {
      await _send(
          req, 502, {'success': false, 'error': 'AI provider is unavailable.'});
    } on _AiStatus catch (e) {
      // CHANGED: provider status code is logged, not returned.
      stderr.writeln('AI provider returned HTTP ${e.status}.');
      await _send(req, 502,
          {'success': false, 'error': 'AI provider returned an error.'});
    } on _BadAiResponse {
      await _send(req, 502,
          {'success': false, 'error': 'AI provider returned invalid JSON.'});
    } on _ClaudeNotConfigured {
      await _send(req, 503, {
        'success': false,
        'error': 'Claude service is not configured on the server.'
      });
    } on _ClaudeTimeout {
      await _send(
          req, 504, {'success': false, 'error': 'Claude request timed out.'});
    } on _ClaudeUnavailable {
      await _send(req, 502,
          {'success': false, 'error': 'Claude provider is unavailable.'});
    } on _ClaudeProviderError catch (e) {
      // Provider overloaded / rate limited -> 503 so clients may retry.
      final busy = e.status == 429 || e.status == 529;
      await _send(req, busy ? 503 : 502, {
        'success': false,
        'error': busy
            ? 'Claude is busy. Please try again shortly.'
            : 'Claude provider returned an error.',
        'providerStatus': e.status
      });
    } on _BadClaudeRequest catch (e) {
      await _send(req, 400, {'success': false, 'error': e.message});
    } on _BadClaudeResponse {
      await _send(req, 502, {
        'success': false,
        'error': 'Claude provider returned an invalid response.'
      });
    } catch (e) {
      // Avoid logging exception messages that could contain request/provider data.
      stderr.writeln('Course Generator request failed (${e.runtimeType}).');
      try {
        await _send(
            req, 500, {'success': false, 'error': 'Internal server error.'});
      } catch (_) {
        try {
          await req.response.close();
        } catch (_) {}
      }
    }
  }

  static bool _originAllowed(String origin) {
    if (_origins.contains(origin)) return true;
    if (_production) return false; // production needs an explicit list
    final uri = Uri.tryParse(origin);
    if (uri == null) return false;
    return uri.scheme == 'http' &&
        (uri.host == 'localhost' ||
            uri.host == '127.0.0.1' ||
            uri.host == '::1') &&
        uri.userInfo.isEmpty &&
        (uri.path.isEmpty || uri.path == '/') &&
        uri.query.isEmpty &&
        uri.fragment.isEmpty;
  }

  /// Native Android/iOS apps send no Origin header and are allowed through;
  /// browsers must match the allowlist.
  static bool _cors(HttpRequest req) {
    final origin = req.headers.value('Origin');
    if (origin != null) {
      if (!_originAllowed(origin)) return false;
      req.response.headers
        ..set(HttpHeaders.accessControlAllowOriginHeader, origin)
        ..set(HttpHeaders.varyHeader, 'Origin')
        ..set(HttpHeaders.accessControlAllowMethodsHeader, 'GET, POST, OPTIONS')
        ..set(HttpHeaders.accessControlAllowHeadersHeader,
            'Content-Type, Authorization, Accept')
        ..set(HttpHeaders.accessControlMaxAgeHeader, '600');
    }
    req.response.headers.contentType = ContentType.json;
    return true;
  }

  /// Firebase Auth REST accounts:lookup validates the supplied ID token
  /// against the Firebase project selected by FIREBASE_WEB_API_KEY. This is
  /// not equivalent to Admin SDK verifyIdToken(checkRevoked: true): revoked
  /// token/session checks require an Admin-SDK-capable trusted service or a
  /// gateway that performs that check. Never describe this REST check as a
  /// revocation check.
  ///
  /// A successful lookup is cached in memory for [_tokenCacheTtl] (2 min) to
  /// avoid one Google round-trip per request. Revocation/disable therefore
  /// takes effect within that window.
  static Future<String?> _verifyFirebaseToken(
    HttpRequest req, {
    bool required = false,
  }) async {
    if (!required) return null;
    final header = req.headers.value(HttpHeaders.authorizationHeader) ?? '';
    final parts = header.trim().split(RegExp(r'\s+'));
    if (parts.length != 2 || parts.first.toLowerCase() != 'bearer') {
      return null;
    }
    final token = parts[1];
    if (token.contains(RegExp(r'\s'))) return null;
    final key = (Platform.environment['FIREBASE_WEB_API_KEY'] ?? '').trim();
    if (token.isEmpty || token.length > 8192 || key.isEmpty) return null;

    final now = DateTime.now().toUtc();
    final cached = _tokenCache[token];
    if (cached != null && cached.expiresAt.isAfter(now)) return cached.uid;
    if (cached != null) _tokenCache.remove(token);

    try {
      final response = await _client
          .post(
            Uri.https('identitytoolkit.googleapis.com', '/v1/accounts:lookup',
                {'key': key}),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'idToken': token}),
          )
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;
      final value = jsonDecode(response.body);
      if (value is! Map ||
          value['users'] is! List ||
          (value['users'] as List).isEmpty) return null;
      final first = (value['users'] as List).first;
      if (first is! Map) return null;
      final id = first['localId']?.toString().trim() ?? '';
      // Reject disabled accounts when the Identity Toolkit response exposes the flag.
      if (first['disabled'] == true) return null;
      if (id.isEmpty || id.length > 128) return null;

      if (_tokenCache.length >= 2000) {
        _tokenCache.removeWhere((_, v) => !v.expiresAt.isAfter(now));
        if (_tokenCache.length >= 2000) _tokenCache.clear();
      }
      _tokenCache[token] = _CachedToken(id, now.add(_tokenCacheTtl));
      return id;
    } catch (_) {
      return null;
    }
  }

  // In-process protection only. Production must additionally enforce a shared
  // limit at the API gateway/load balancer when running multiple instances.
  static bool _allow(String key, {int limit = 30}) {
    final now = DateTime.now().toUtc();
    final window = _windows[key];
    if (window == null ||
        now.difference(window.start) >= const Duration(minutes: 1)) {
      _windows[key] = _Window(now, 1);
      if (_windows.length > 10000) _windows.remove(_windows.keys.first);
      return true;
    }
    if (window.count >= limit) return false;
    window.count++;
    return true;
  }

  /// Per-user daily Claude quota (UTC day). In-memory: resets if the
  /// instance restarts or sleeps — it limits abuse, it is not billing-grade.
  static bool _allowDaily(String uid) {
    final now = DateTime.now().toUtc();
    final day = '${now.year}-${now.month}-${now.day}';
    final key = '$uid:$day';
    final w = _daily[key];
    if (w == null) {
      if (_daily.length > 20000) {
        _daily.removeWhere((k, _) => !k.endsWith(':$day'));
        if (_daily.length > 20000) _daily.clear();
      }
      _daily[key] = _Window(now, 1);
      return true;
    }
    if (w.count >= _claudeDailyLimit) return false;
    w.count++;
    return true;
  }

  static Future<Map<String, dynamic>?> _readBody(HttpRequest req) async {
    if (req.contentLength > _maxBody) throw const _TooLarge();
    final bytes = BytesBuilder(copy: false);
    await for (final chunk in req) {
      bytes.add(chunk);
      if (bytes.length > _maxBody) throw const _TooLarge();
    }
    final String body;
    try {
      body = utf8.decode(bytes.takeBytes(), allowMalformed: false);
    } catch (_) {
      throw const _BadJson('Request body must be valid UTF-8 JSON.');
    }
    if (body.trim().isEmpty) throw const _BadJson('Request body is empty.');
    dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } catch (_) {
      throw const _BadJson('Request body must be valid JSON.');
    }
    if (decoded is! Map) {
      throw const _BadJson('Request body must be a JSON object.');
    }
    return Map<String, dynamic>.from(decoded);
  }

  static int? _intOf(dynamic v) =>
      v is int ? v : (v is num ? v.toInt() : int.tryParse('$v'));

  /// CHANGED: shared id check used for careerId and categoryId.
  static bool _validId(String v) =>
      v.isNotEmpty &&
      v.length <= 120 &&
      !v.contains(RegExp(r'[\x00-\x1F\x7F]'));

  /// Authenticated server-side proxy for Claude. The Flutter app sends only
  /// prompts and conversation messages; ANTHROPIC_API_KEY never leaves server.
  /// Request: {system?, messages: [{role, content}], max_tokens?, temperature?}
  /// Response: {success, content, stopReason, usage}
  static Future<void> _generateClaudeMessage(
      HttpRequest req, Map<String, dynamic> data) async {
    final key = (Platform.environment['ANTHROPIC_API_KEY'] ?? '').trim();
    if (key.isEmpty) throw const _ClaudeNotConfigured();

    final system = data['system']?.toString() ?? '';
    if (system.length > 20000) {
      throw const _BadClaudeRequest('System prompt is too long.');
    }

    final rawMessages = data['messages'];
    if (rawMessages is! List ||
        rawMessages.isEmpty ||
        rawMessages.length > 40) {
      throw const _BadClaudeRequest(
          'messages must contain between 1 and 40 messages.');
    }

    final messages = <Map<String, String>>[];
    var hasUserMessage = false;
    var totalChars = system.length;
    for (final item in rawMessages) {
      if (item is! Map) {
        throw const _BadClaudeRequest('Each message must be an object.');
      }
      final role = item['role']?.toString();
      final content = item['content']?.toString();
      if ((role != 'user' && role != 'assistant') ||
          content == null ||
          content.trim().isEmpty ||
          content.length > 20000) {
        throw const _BadClaudeRequest('Message role or content is invalid.');
      }
      totalChars += content.length;
      if (role == 'user') hasUserMessage = true;
      messages.add({'role': role!, 'content': content});
    }
    if (!hasUserMessage) {
      throw const _BadClaudeRequest('At least one user message is required.');
    }
    if (totalChars > _maxClaudeTotalChars) {
      throw const _BadClaudeRequest('Request is too long.');
    }

    final requestedTokens = _intOf(data['max_tokens']) ?? 2048;
    if (requestedTokens < 1 || requestedTokens > 4096) {
      throw const _BadClaudeRequest('max_tokens must be between 1 and 4096.');
    }
    final body = <String, dynamic>{
      'model': _claudeModel,
      'max_tokens': requestedTokens,
      'messages': messages,
      if (system.trim().isNotEmpty) 'system': system,
    };
    final temperature = data['temperature'];
    if (temperature != null) {
      if (temperature is! num || temperature < 0 || temperature > 1) {
        throw const _BadClaudeRequest('temperature must be between 0 and 1.');
      }
      body['temperature'] = temperature;
    }

    final http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse(anthropicUrl),
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': key,
              'anthropic-version': '2023-06-01',
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw const _ClaudeTimeout();
    } on SocketException {
      throw const _ClaudeUnavailable();
    } on http.ClientException {
      throw const _ClaudeUnavailable();
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      // Never return provider response bodies: they may contain sensitive data.
      throw _ClaudeProviderError(response.statusCode);
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map || decoded['content'] is! List) {
        throw const _BadClaudeResponse();
      }
      final textParts = <String>[];
      for (final block in decoded['content'] as List) {
        if (block is Map &&
            block['type'] == 'text' &&
            block['text'] is String) {
          textParts.add(block['text'] as String);
        }
      }
      if (textParts.isEmpty) throw const _BadClaudeResponse();
      await _send(req, 200, {
        'success': true,
        'content': textParts.join('\n'),
        'stopReason': decoded['stop_reason'],
        'usage':
            decoded['usage'] is Map ? decoded['usage'] : <String, dynamic>{},
      });
    } on _BadClaudeResponse {
      rethrow;
    } catch (_) {
      throw const _BadClaudeResponse();
    }
  }

  /// CHANGED: requires careerId, categoryId and level in both modes, and
  /// answers with `request` (the validated identity) next to `course`.
  static Future<void> _generateCourse(
      HttpRequest req, Map<String, dynamic> data) async {
    final prompt = data['prompt']?.toString().trim() ?? '';
    if (prompt.length > 50000) {
      await _send(req, 400,
          {'success': false, 'error': 'Course generation prompt is too long.'});
      return;
    }
    final careerId = (data['careerId'] ?? '').toString().trim();
    final categoryId = (data['categoryId'] ?? '').toString().trim();
    final level = _intOf(data['level']);
    final lessonIndex =
        data['lessonIndex'] == null ? null : _intOf(data['lessonIndex']);
    if (!_validId(careerId) ||
        !_validId(categoryId) ||
        level == null ||
        level < 1 ||
        level > 100 ||
        (data['lessonIndex'] != null &&
            (lessonIndex == null ||
                lessonIndex < 1 ||
                lessonIndex > CourseGeneratorConfig.maxLessonCount))) {
      await _send(req, 400, {
        'success': false,
        'error':
            'careerId, categoryId and level are required and must be valid.'
      });
      return;
    }
    final mock = !_hasAiKey;
    final Map<String, dynamic> course;
    if (mock) {
      course = LocalCourseGenerator.generateCourse(
        careerId: careerId,
        level: level,
        lessonIndex: lessonIndex,
      );
    } else {
      if (prompt.isEmpty) {
        await _send(req, 400, {
          'success': false,
          'error': 'Course generation prompt is required.'
        });
        return;
      }
      course = await _callAi(prompt,
          'You are an expert career-course generator. Generate educational course content according to the supplied prompt. Return ONLY valid JSON; no Markdown or code fences.');
      // Identity comes from the validated request, never from the AI text.
      course['careerId'] = careerId;
      course['categoryId'] = categoryId;
      if (CourseJsonValidator.validate(course).isNotEmpty) {
        throw const _BadAiResponse();
      }
    }
    await _send(req, 200, {
      'success': true,
      'mock': mock,
      'request': {
        'careerId': careerId,
        'categoryId': categoryId,
        'level': level,
        'lessonIndex': lessonIndex,
      },
      'course': course,
    });
  }

  /// CHANGED: requires careerId, categoryId and level in both modes, and
  /// answers with `request` next to `lessonList`.
  static Future<void> _generateLessonList(
      HttpRequest req, Map<String, dynamic> data) async {
    final prompt = data['prompt']?.toString().trim() ?? '';
    if (prompt.length > 50000) {
      await _send(req, 400,
          {'success': false, 'error': 'Lesson list prompt is too long.'});
      return;
    }
    final count = _intOf(data['lessonCount']) ??
        CourseGeneratorConfig.lessonsPerDynamicLevel;
    if (count < CourseGeneratorConfig.minLessonCount ||
        count > CourseGeneratorConfig.maxLessonCount) {
      await _send(req, 400, {
        'success': false,
        'error':
            'lessonCount must be between ${CourseGeneratorConfig.minLessonCount} and ${CourseGeneratorConfig.maxLessonCount}.'
      });
      return;
    }
    final careerId = (data['careerId'] ?? '').toString().trim();
    final categoryId = (data['categoryId'] ?? '').toString().trim();
    final level = _intOf(data['level']);
    if (!_validId(careerId) ||
        !_validId(categoryId) ||
        level == null ||
        level < 1 ||
        level > 100) {
      await _send(req, 400, {
        'success': false,
        'error':
            'careerId, categoryId and level are required and must be valid.'
      });
      return;
    }
    final mock = !_hasAiKey;
    final Map<String, dynamic> result;
    if (mock) {
      result = LocalCourseGenerator.generateLessonList(
          careerId: careerId, level: level, lessonCount: count);
    } else {
      if (prompt.isEmpty) {
        await _send(req, 400,
            {'success': false, 'error': 'Lesson list prompt is required.'});
        return;
      }
      result = await _callAi(prompt,
          'You are an expert career-curriculum designer. Generate a lesson syllabus according to the supplied prompt. Return ONLY valid JSON; no Markdown or code fences.');
      if (CourseJsonValidator.validateLessonList(result, expectedCount: count)
          .isNotEmpty) {
        throw const _BadAiResponse();
      }
    }
    await _send(req, 200, {
      'success': true,
      'mock': mock,
      'request': {
        'careerId': careerId,
        'categoryId': categoryId,
        'level': level,
        'lessonCount': count,
      },
      'lessonList': result,
    });
  }

  static Future<Map<String, dynamic>> _callAi(
      String prompt, String systemPrompt) async {
    final key = (Platform.environment['OPENAI_API_KEY'] ?? '').trim();
    final http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse(openAiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $key'
            },
            body: jsonEncode({
              'model': 'gpt-4o-mini',
              'temperature': 0.7,
              'response_format': {'type': 'json_object'},
              'messages': [
                {'role': 'system', 'content': systemPrompt},
                {'role': 'user', 'content': prompt}
              ],
            }),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw const _AiTimeout();
    } on SocketException {
      throw const _AiUnavailable();
    } on http.ClientException {
      throw const _AiUnavailable();
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _AiStatus(response.statusCode);
    }
    try {
      final outer = jsonDecode(response.body);
      if (outer is! Map ||
          outer['choices'] is! List ||
          (outer['choices'] as List).isEmpty) throw const _BadAiResponse();
      final choice = (outer['choices'] as List).first;
      if (choice is! Map || choice['message'] is! Map) {
        throw const _BadAiResponse();
      }
      final content =
          (choice['message'] as Map)['content']?.toString().trim() ?? '';
      final parsed = jsonDecode(content);
      if (parsed is! Map) throw const _BadAiResponse();
      return Map<String, dynamic>.from(parsed);
    } on _BadAiResponse {
      rethrow;
    } catch (_) {
      throw const _BadAiResponse();
    }
  }

  static Future<void> _send(
      HttpRequest req, int status, Map<String, dynamic> data) async {
    req.response.statusCode = status;
    req.response.headers
      ..contentType = ContentType.json
      ..set('Cache-Control', 'no-store')
      ..set('X-Content-Type-Options', 'nosniff');
    if (_production) {
      req.response.headers.set('Strict-Transport-Security', 'max-age=31536000');
    }
    req.response.write(jsonEncode(data));
    await req.response.close();
  }
}

class _ClaudeNotConfigured implements Exception {
  const _ClaudeNotConfigured();
}

class _ClaudeTimeout implements Exception {
  const _ClaudeTimeout();
}

class _ClaudeUnavailable implements Exception {
  const _ClaudeUnavailable();
}

class _ClaudeProviderError implements Exception {
  const _ClaudeProviderError(this.status);
  final int status;
}

class _BadClaudeRequest implements Exception {
  const _BadClaudeRequest(this.message);
  final String message;
}

class _BadClaudeResponse implements Exception {
  const _BadClaudeResponse();
}

class _Window {
  _Window(this.start, this.count);
  final DateTime start;
  int count;
}

class _CachedToken {
  const _CachedToken(this.uid, this.expiresAt);
  final String uid;
  final DateTime expiresAt;
}

class _TooLarge implements Exception {
  const _TooLarge();
}

class _BadJson implements Exception {
  const _BadJson(this.message);
  final String message;
}

class _AiTimeout implements Exception {
  const _AiTimeout();
}

class _AiUnavailable implements Exception {
  const _AiUnavailable();
}

class _BadAiResponse implements Exception {
  const _BadAiResponse();
}

class _AiStatus implements Exception {
  _AiStatus(this.status);
  final int status;
}

Future<void> main() async {
  await CourseGeneratorApi.start();
}
