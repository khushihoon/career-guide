import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../lib/data/courses/course_generator_config.dart';
import '../lib/services/local_course_generator.dart';

/// OPTIONAL Course Generator API. The Flutter app works without it
/// (it has a built-in generator). Run this only if you want real AI.
///
/// Public response contracts are unchanged:
///   GET  /health               -> {success, message, mode}
///   POST /generate-course      -> {success, mock, course}
///   POST /generate-lesson-list -> {success, mock, lessonList}
///
/// What changed:
///  * CORS: in development (CAREER_GUIDE_ENV != production) any
///    http://localhost:* or http://127.0.0.1:* origin is allowed, which is
///    what `flutter run -d chrome` uses. Before, an empty
///    COURSE_ALLOWED_ORIGINS rejected every browser request, which the
///    browser reports as "ClientException: Failed to fetch".
///    In production you MUST list origins in COURSE_ALLOWED_ORIGINS.
///  * With no OPENAI_API_KEY the server answers with the built-in local
///    generator (mock=true, source="local-template") instead of generic
///    placeholder text. The app ignores mock=true and uses its own copy.
///  * AI answers are validated; invalid ones return 502 instead of being
///    passed to the app.
///
/// Environment: PORT, OPENAI_API_KEY, FIREBASE_WEB_API_KEY,
/// COURSE_AUTH_REQUIRED, COURSE_ALLOWED_ORIGINS, COURSE_MAX_BODY_BYTES,
/// COURSE_AI_TIMEOUT_SECONDS, CAREER_GUIDE_ENV.
class CourseGeneratorApi {
  static const String openAiUrl = 'https://api.openai.com/v1/chat/completions';
  static final http.Client _client = http.Client();
  static final Map<String, _Window> _windows = {};
  static int get port =>
      int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  static bool get _production =>
      Platform.environment['CAREER_GUIDE_ENV'] == 'production';
  static bool get _authRequired {
    final v = Platform.environment['COURSE_AUTH_REQUIRED'];
    return v == null || v.trim().isEmpty
        ? _production
        : (v == 'true' || v == '1');
  }

  static int get _maxBody =>
      int.tryParse(Platform.environment['COURSE_MAX_BODY_BYTES'] ?? '') ??
      262144;
  static Duration get _timeout => Duration(
      seconds: int.tryParse(
              Platform.environment['COURSE_AI_TIMEOUT_SECONDS'] ?? '') ??
          45);
  static Set<String> get _origins =>
      (Platform.environment['COURSE_ALLOWED_ORIGINS'] ?? '')
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toSet();
  static bool get _hasAiKey =>
      (Platform.environment['OPENAI_API_KEY'] ?? '').trim().isNotEmpty;

  static Future<void> start() async {
    if (_authRequired &&
        (Platform.environment['FIREBASE_WEB_API_KEY'] ?? '').trim().isEmpty) {
      throw StateError(
          'FIREBASE_WEB_API_KEY is required when course authentication is enabled.');
    }
    final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    stdout.writeln(
        'Course Generator listening on $port; auth=$_authRequired; ai=$_hasAiKey; production=$_production');
    await for (final request in server) {
      unawaited(_handle(request));
    }
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
        });
        return;
      }
      final course = req.method == 'POST' && req.uri.path == '/generate-course';
      final lessons =
          req.method == 'POST' && req.uri.path == '/generate-lesson-list';
      if (!course && !lessons) {
        await _send(
            req, 404, {'success': false, 'error': 'Endpoint not found.'});
        return;
      }
      final userId = await _verifyFirebaseToken(req);
      if (_authRequired && userId == null) {
        await _send(req, 401, {
          'success': false,
          'error': 'A valid Firebase ID token is required.'
        });
        return;
      }
      final key = userId ??
          'ip:${req.connectionInfo?.remoteAddress.address ?? 'unknown'}';
      if (!_allow(key)) {
        req.response.headers.set('Retry-After', '60');
        await _send(req, 429, {
          'success': false,
          'error': 'Too many requests. Please try again shortly.'
        });
        return;
      }
      final data = await _readBody(req);
      if (data == null) return;
      if (course) {
        await _generateCourse(req, data);
      } else {
        await _generateLessonList(req, data);
      }
    } on _TooLarge {
      await _send(
          req, 413, {'success': false, 'error': 'Request body is too large.'});
    } on _BadJson catch (e) {
      await _send(req, 400, {'success': false, 'error': e.message});
    } on LocalGenerationException catch (e) {
      await _send(req, 422, {'success': false, 'error': e.message});
    } on _AiTimeout {
      await _send(req, 504,
          {'success': false, 'error': 'AI provider request timed out.'});
    } on _AiUnavailable {
      await _send(
          req, 502, {'success': false, 'error': 'AI provider is unavailable.'});
    } on _AiStatus catch (e) {
      await _send(req, 502, {
        'success': false,
        'error': 'AI provider returned an error.',
        'providerStatus': e.status
      });
    } on _BadAiResponse {
      await _send(req, 502,
          {'success': false, 'error': 'AI provider returned invalid JSON.'});
    } catch (e) {
      stderr.writeln('Course Generator request failed: $e');
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
    return uri.host == 'localhost' ||
        uri.host == '127.0.0.1' ||
        uri.host == '::1';
  }

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

  /// Firebase Auth REST accounts:lookup validates the ID token against the
  /// project selected by FIREBASE_WEB_API_KEY (a project key, not an Admin
  /// credential). Do not disable auth on a public production service.
  static Future<String?> _verifyFirebaseToken(HttpRequest req) async {
    if (!_authRequired) return null;
    final header = req.headers.value(HttpHeaders.authorizationHeader) ?? '';
    if (!header.startsWith('Bearer ')) return null;
    final token = header.substring(7).trim();
    final key = (Platform.environment['FIREBASE_WEB_API_KEY'] ?? '').trim();
    if (token.isEmpty || token.length > 8192 || key.isEmpty) return null;
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
      return id.isEmpty ? null : id;
    } catch (_) {
      return null;
    }
  }

  static bool _allow(String key) {
    final now = DateTime.now().toUtc();
    final window = _windows[key];
    if (window == null ||
        now.difference(window.start) >= const Duration(minutes: 1)) {
      _windows[key] = _Window(now, 1);
      if (_windows.length > 10000) _windows.remove(_windows.keys.first);
      return true;
    }
    if (window.count >= 30) return false;
    window.count++;
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
    if (decoded is! Map)
      throw const _BadJson('Request body must be a JSON object.');
    return Map<String, dynamic>.from(decoded);
  }

  static int? _intOf(dynamic v) =>
      v is int ? v : (v is num ? v.toInt() : int.tryParse('$v'));

  static Future<void> _generateCourse(
      HttpRequest req, Map<String, dynamic> data) async {
    final prompt = data['prompt']?.toString().trim() ?? '';
    if (prompt.length > 50000) {
      await _send(req, 400,
          {'success': false, 'error': 'Course generation prompt is too long.'});
      return;
    }
    final mock = !_hasAiKey;
    final Map<String, dynamic> course;
    if (mock) {
      final careerId = (data['careerId'] ?? '').toString();
      final level = _intOf(data['level']);
      if (careerId.isEmpty || level == null) {
        await _send(req, 400,
            {'success': false, 'error': 'careerId and level are required.'});
        return;
      }
      course = LocalCourseGenerator.generateCourse(
        careerId: careerId,
        level: level,
        lessonIndex: _intOf(data['lessonIndex']),
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
      if (CourseJsonValidator.validate(course).isNotEmpty)
        throw const _BadAiResponse();
    }
    await _send(req, 200, {'success': true, 'mock': mock, 'course': course});
  }

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
    final mock = !_hasAiKey;
    final Map<String, dynamic> result;
    if (mock) {
      final careerId = (data['careerId'] ?? '').toString();
      final level = _intOf(data['level']);
      if (careerId.isEmpty || level == null) {
        await _send(req, 400,
            {'success': false, 'error': 'careerId and level are required.'});
        return;
      }
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
          .isNotEmpty) throw const _BadAiResponse();
    }
    await _send(
        req, 200, {'success': true, 'mock': mock, 'lessonList': result});
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
    }
    if (response.statusCode < 200 || response.statusCode >= 300)
      throw _AiStatus(response.statusCode);
    try {
      final outer = jsonDecode(response.body);
      if (outer is! Map ||
          outer['choices'] is! List ||
          (outer['choices'] as List).isEmpty) throw const _BadAiResponse();
      final choice = (outer['choices'] as List).first;
      if (choice is! Map || choice['message'] is! Map)
        throw const _BadAiResponse();
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
    req.response.write(jsonEncode(data));
    await req.response.close();
  }
}

class _Window {
  _Window(this.start, this.count);
  final DateTime start;
  int count;
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
