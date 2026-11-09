import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/courses/course_generator_config.dart';
import '../models/course_content_data.dart';
import 'local_course_generator.dart';

// ═══════════════════════════════════════════════════════════════════
// Result / status types
// ═══════════════════════════════════════════════════════════════════

/// Where the CONTENT came from.
enum GenerationOrigin {
  /// Real answer from your optional backend (AI).
  backend,

  /// Built-in free generator, backend not configured.
  local,

  /// Built-in free generator because the backend was configured but failed.
  localFallback,
}

/// Why the optional backend was not used. Safe to show or log: it never
/// contains server text, URLs or response bodies.
enum BackendIssue {
  timeout,
  network,
  http,
  authRejected,
  tooLarge,
  invalidResponse,
  mockMode,
  identityMismatch,
}

extension BackendIssueText on BackendIssue {
  String get message {
    switch (this) {
      case BackendIssue.timeout:
        return 'The course server took too long to answer.';
      case BackendIssue.network:
        return 'The course server could not be reached.';
      case BackendIssue.http:
        return 'The course server returned an error.';
      case BackendIssue.authRejected:
        return 'The course server did not accept the login.';
      case BackendIssue.tooLarge:
        return 'The course server answer was too large.';
      case BackendIssue.invalidResponse:
        return 'The course server answer was not valid.';
      case BackendIssue.mockMode:
        return 'The course server has no AI key, so built-in content is used.';
      case BackendIssue.identityMismatch:
        return 'The course server answered for a different lesson.';
    }
  }
}

/// Where a returned course or lesson list came from.
class GenerationInfo {
  const GenerationInfo({
    required this.origin,
    required this.fromCache,
    this.backendIssue,
  });

  /// How the content was ORIGINALLY produced (even when read from cache).
  final GenerationOrigin origin;

  /// True when this call returned a saved copy instead of generating.
  final bool fromCache;

  /// Set only when the backend was configured but not used for new content.
  final BackendIssue? backendIssue;

  String get originLabel {
    switch (origin) {
      case GenerationOrigin.backend:
        return 'backend';
      case GenerationOrigin.local:
        return 'local-template';
      case GenerationOrigin.localFallback:
        return 'local-fallback';
    }
  }

  /// Examples: "backend", "local-template", "local-fallback",
  /// "cache(local-template)".
  String get label => fromCache ? 'cache($originLabel)' : originLabel;

  static GenerationOrigin parseOrigin(String? v) {
    switch (v) {
      case 'backend':
        return GenerationOrigin.backend;
      case 'local-fallback':
        return GenerationOrigin.localFallback;
      default:
        return GenerationOrigin.local;
    }
  }
}

class CourseLoadResult {
  const CourseLoadResult(this.course, this.info);
  final TopicCourse course;
  final GenerationInfo info;
}

class LessonListResult {
  const LessonListResult(this.lessons, this.info);
  final List<LessonStub> lessons;
  final GenerationInfo info;
}

/// Error shown to the user. The message is safe: no URLs, no server text,
/// no file names. Technical detail goes to debugPrint only.
class CourseGenerationException implements Exception {
  const CourseGenerationException(this.message);
  final String message;
  @override
  String toString() => message;
}

// ═══════════════════════════════════════════════════════════════════
// CourseGeneratorService  (v3 — local-first, free, works offline)
//
// Flutter UI
//    ↓
// CourseGeneratorService
//    ├─ versioned local cache (SharedPreferences)
//    ├─ (optional) your backend, only if you run the app with
//    │     --dart-define=COURSE_BACKEND_URL=https://your-server
//    └─ LocalCourseGenerator (built in, free, no API key, no internet)
//
// RULES
//  * Built-in generator is the default; a stopped/broken backend never
//    breaks the app.
//  * A backend answer is used only if it is real (mock != true), under the
//    size limit, valid, AND is for the exact lesson that was requested.
//  * Locally generated content is template based, NOT live AI.
//  * No API key ever lives in the Flutter app. The Firebase ID token (a
//    short-lived login proof) is sent only over https, or to localhost for
//    development.
// ═══════════════════════════════════════════════════════════════════
class CourseGeneratorService {
  CourseGeneratorService._();

  // ── Optional backend settings ─────────────────────────────────

  static String? _baseOverride;

  static String get _rawBase =>
      (_baseOverride ?? CourseGeneratorConfig.backendBaseUrl).trim();

  static bool get backendEnabled => _rawBase.isNotEmpty;

  static String get _base {
    final b = _rawBase;
    return b.endsWith('/') ? b.substring(0, b.length - 1) : b;
  }

  /// Kept for older code. Empty when no backend is configured.
  static String get backendUrl =>
      backendEnabled ? '$_base/generate-course' : '';
  static String get lessonListBackendUrl =>
      backendEnabled ? '$_base/generate-lesson-list' : '';

  /// Supplies the Firebase ID token for a backend that requires login.
  /// Default: the signed-in Firebase user, if any. Override in tests or
  /// if you use another login system.
  static Future<String?> Function()? authTokenProvider;

  static Future<String?> _defaultTokenProvider() async {
    try {
      return await FirebaseAuth.instance.currentUser?.getIdToken();
    } catch (_) {
      return null; // Firebase not ready or nobody signed in
    }
  }

  // ── Source tracking ───────────────────────────────────────────

  /// Info about the most recent course call / lesson-list call, and the
  /// most recent of either. Kept separately so a lesson-list call cannot
  /// overwrite course info.
  static GenerationInfo? lastCourseInfo;
  static GenerationInfo? lastListInfo;
  static GenerationInfo? lastInfo;

  /// Backward compatible text: "backend", "local-template",
  /// "local-fallback" or "cache(<origin>)".
  static String? get lastSource => lastInfo?.label;

  /// Safe explanation of why the backend was not used last time.
  static String? get lastBackendError => lastInfo?.backendIssue?.message;
  static BackendIssue? get lastBackendIssue => lastInfo?.backendIssue;

  static http.Client _client = http.Client();

  @visibleForTesting
  static set httpClient(http.Client c) => _client = c;

  @visibleForTesting
  static set backendBaseUrlOverride(String? v) => _baseOverride = v;

  @visibleForTesting
  static void resetForTest() {
    _client = http.Client();
    _baseOverride = null;
    authTokenProvider = null;
    lastCourseInfo = null;
    lastListInfo = null;
    lastInfo = null;
  }

  // ═══════════════════════════════════════════════════════════════
  // PROMPTS (only used when an optional backend / AI is configured)
  // ═══════════════════════════════════════════════════════════════

  static String buildCoursePrompt({
    required String careerId,
    required String careerTitle,
    required String categoryId,
    required int level,
    required String levelTitle,
    required List<String> topics,
    required String difficulty,
  }) {
    final topicsText = topics.map((e) => '- $e').join('\n');

    return '''
You are an expert career-course curriculum designer.

Create ONE complete learning course for:

Career ID: $careerId
Career Title: $careerTitle
Category ID: $categoryId
Level: $level
Level Title: $levelTitle
Difficulty: $difficulty

TOPICS TO COVER:
$topicsText

TEACHING STYLE:
${CourseGeneratorConfig.defaultTeachingStyle}

COURSE REQUIREMENTS:

1. Create exactly ${CourseGeneratorConfig.conceptsPerLesson} concept lessons.
2. Create exactly ${CourseGeneratorConfig.quizQuestionsPerLesson} quiz questions.
3. Create exactly ${CourseGeneratorConfig.challengesPerLesson} mini challenges.
4. Create one final project because generateFinalProject = ${CourseGeneratorConfig.generateFinalProject}.
5. Content must be beginner-friendly, practical, career-focused, technically accurate, progressively structured and not generic filler.
6. Each concept MUST contain: title, definition, analogy, example, keyTakeaway, optional codeSnippet.
7. Each quiz question MUST contain: question, exactly 4 different options, correctIndex (0-3), explanation, xpReward.
8. Each mini challenge MUST contain: prompt, exactly 4 different options, correctIndex (0-3), explanation, xpReward.
9. Final project MUST contain: title, goal, steps, expectedOutput, xpReward.
10. Return ONLY valid JSON. No Markdown. No code fences.

JSON SCHEMA:

{
  "id": "unique_course_id",
  "topicTitle": "level topic title",
  "careerId": "$careerId",
  "categoryId": "$categoryId",
  "difficulty": "$difficulty",
  "estimatedMinutes": 45,
  "totalXp": 200,
  "intro": "short motivational introduction",
  "emoji": "appropriate emoji",
  "concepts": [
    { "title": "", "definition": "", "analogy": "", "example": "", "keyTakeaway": "", "codeSnippet": null }
  ],
  "quiz": [
    { "question": "", "options": ["A", "B", "C", "D"], "correctIndex": 0, "explanation": "", "xpReward": ${CourseGeneratorConfig.defaultQuizXp} }
  ],
  "challenges": [
    { "prompt": "", "options": ["A", "B", "C", "D"], "correctIndex": 0, "explanation": "", "xpReward": ${CourseGeneratorConfig.defaultChallengeXp} }
  ],
  "finalProject": {
    "title": "", "goal": "", "steps": ["Step 1", "Step 2", "Step 3", "Step 4"],
    "expectedOutput": "", "xpReward": ${CourseGeneratorConfig.defaultProjectXp}
  }
}
''';
  }

  static String buildLessonListPrompt({
    required String careerTitle,
    required String levelTitle,
    required String difficulty,
    required int lessonCount,
  }) {
    return '''
You are an expert career-curriculum designer.

Design the syllabus for ONE level of a career learning path:

Career: $careerTitle
Level title: $levelTitle
Level difficulty: $difficulty

Produce exactly $lessonCount distinct lesson titles for this level.

REQUIREMENTS:
- Each lesson title must be practical and $careerTitle-specific.
- Lessons must progress logically (foundational first, applied later).
- No duplicate or filler lesson titles.
- Titles should be concise.
- Use index 1 to $lessonCount with no gaps.

Return ONLY valid JSON, no Markdown:

{
  "lessons": [
    { "index": 1, "title": "Lesson title" }
  ]
}
''';
  }

  // ═══════════════════════════════════════════════════════════════
  // OPTIONAL BACKEND CALL
  // ═══════════════════════════════════════════════════════════════

  /// The login token is only sent over https, or to a local development
  /// address, so it can never travel in clear text across the internet.
  static bool _mayAttachToken(Uri uri) {
    if (uri.scheme == 'https') return true;
    return uri.scheme == 'http' &&
        (uri.host == 'localhost' ||
            uri.host == '127.0.0.1' ||
            uri.host == '10.0.2.2');
  }

  static Future<_BackendOutcome> _tryBackend(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      final uri = Uri.parse(url);
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (_mayAttachToken(uri)) {
        final token = await (authTokenProvider ?? _defaultTokenProvider)();
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }
      }
      final response = await _client
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(
              Duration(seconds: CourseGeneratorConfig.backendTimeoutSeconds));

      final code = response.statusCode;
      if (code == 401 || code == 403) {
        debugPrint('Course backend rejected login (HTTP $code).');
        return const _BackendOutcome.fail(BackendIssue.authRejected);
      }
      if (code < 200 || code >= 300) {
        debugPrint('Course backend returned HTTP $code.');
        return const _BackendOutcome.fail(BackendIssue.http);
      }
      if (response.bodyBytes.length >
          CourseGeneratorConfig.maxBackendResponseBytes) {
        return const _BackendOutcome.fail(BackendIssue.tooLarge);
      }
      // Always read the answer as UTF-8. response.body would fall back to
      // latin1 when the server sends no charset and garble characters.
      final text = utf8.decode(response.bodyBytes);
      if (text.trim().isEmpty) {
        return const _BackendOutcome.fail(BackendIssue.invalidResponse);
      }
      final decoded = jsonDecode(text);
      if (decoded is! Map) {
        return const _BackendOutcome.fail(BackendIssue.invalidResponse);
      }
      final map = Map<String, dynamic>.from(decoded);
      if (map['success'] != true) {
        return const _BackendOutcome.fail(BackendIssue.http);
      }
      if (map['mock'] == true) {
        return const _BackendOutcome.fail(BackendIssue.mockMode);
      }
      return _BackendOutcome.ok(map);
    } on TimeoutException {
      return const _BackendOutcome.fail(BackendIssue.timeout);
    } on FormatException {
      return const _BackendOutcome.fail(BackendIssue.invalidResponse);
    } catch (e) {
      // Web: "Failed to fetch" (server down or CORS). Android: no route.
      debugPrint('Course backend not reachable: ${e.runtimeType}');
      return const _BackendOutcome.fail(BackendIssue.network);
    }
  }

  static bool _sameInt(dynamic a, int? b) {
    if (b == null) return a == null;
    return a is num && a == b;
  }

  /// The backend repeats the request it answered in `request`. It must match
  /// what we asked for, so a mixed-up or replayed answer is never shown.
  static bool _courseIdentityOk(
    Map<String, dynamic> envelope,
    Map<String, dynamic> course, {
    required String careerId,
    required String categoryId,
    required int level,
    required int? lessonIndex,
  }) {
    final req = envelope['request'];
    if (req is! Map) return false;
    if (req['careerId'] != careerId) return false;
    if (req['categoryId'] != categoryId) return false;
    if (!_sameInt(req['level'], level)) return false;
    if (!_sameInt(req['lessonIndex'], lessonIndex)) return false;
    if (course['careerId'] != careerId) return false;
    if (course['categoryId'] != categoryId) return false;
    return true;
  }

  static bool _listIdentityOk(
    Map<String, dynamic> envelope, {
    required String careerId,
    required String categoryId,
    required int level,
    required int lessonCount,
  }) {
    final req = envelope['request'];
    if (req is! Map) return false;
    return req['careerId'] == careerId &&
        req['categoryId'] == categoryId &&
        _sameInt(req['level'], level) &&
        _sameInt(req['lessonCount'], lessonCount);
  }

  // ═══════════════════════════════════════════════════════════════
  // GENERATE COURSE
  // ═══════════════════════════════════════════════════════════════

  static Future<TopicCourse> generateCourse({
    required String careerId,
    required String careerTitle,
    required String categoryId,
    required int level,
    required String levelTitle,
    required List<String> topics,
    required String difficulty,
    int? lessonIndex,
  }) async {
    final g = await _generateCourse(
      careerId: careerId,
      careerTitle: careerTitle,
      categoryId: categoryId,
      level: level,
      levelTitle: levelTitle,
      topics: topics,
      difficulty: difficulty,
      lessonIndex: lessonIndex,
    );
    return g.course;
  }

  static Future<_GeneratedCourse> _generateCourse({
    required String careerId,
    required String careerTitle,
    required String categoryId,
    required int level,
    required String levelTitle,
    required List<String> topics,
    required String difficulty,
    int? lessonIndex,
  }) async {
    BackendIssue? issue;

    if (backendEnabled) {
      final prompt = buildCoursePrompt(
        careerId: careerId,
        careerTitle: careerTitle,
        categoryId: categoryId,
        level: level,
        levelTitle: levelTitle,
        topics: topics,
        difficulty: difficulty,
      );
      final out = await _tryBackend(backendUrl, <String, dynamic>{
        'careerId': careerId,
        'careerTitle': careerTitle,
        'categoryId': categoryId,
        'level': level,
        'levelTitle': levelTitle,
        'topics': topics,
        'difficulty': difficulty,
        if (lessonIndex != null) 'lessonIndex': lessonIndex,
        'prompt': prompt,
      });
      issue = out.issue;
      final env = out.body;
      if (env != null) {
        final raw = env['course'];
        if (raw is! Map) {
          issue = BackendIssue.invalidResponse;
        } else {
          final m = Map<String, dynamic>.from(raw);
          if (CourseJsonValidator.validate(m).isNotEmpty) {
            issue = BackendIssue.invalidResponse;
          } else if (!_courseIdentityOk(env, m,
              careerId: careerId,
              categoryId: categoryId,
              level: level,
              lessonIndex: lessonIndex)) {
            issue = BackendIssue.identityMismatch;
          } else {
            final course = courseFromJson(jsonEncode(m));
            return _GeneratedCourse(
              course,
              'backend',
              const GenerationInfo(
                  origin: GenerationOrigin.backend, fromCache: false),
            );
          }
        }
      }
    }

    try {
      final json = LocalCourseGenerator.generateCourse(
        careerId: careerId,
        level: level,
        lessonIndex: lessonIndex,
      );
      final course = courseFromJson(jsonEncode(json));
      final origin = backendEnabled
          ? GenerationOrigin.localFallback
          : GenerationOrigin.local;
      return _GeneratedCourse(
        course,
        LocalCourseGenerator.source,
        GenerationInfo(origin: origin, fromCache: false, backendIssue: issue),
      );
    } on LocalGenerationException catch (e) {
      debugPrint('Local course generation failed: ${e.message}');
      throw const CourseGenerationException(
          'Course generation failed: this lesson is not available yet.');
    } on FormatException catch (e) {
      debugPrint('Local course JSON rejected: ${e.message}');
      throw const CourseGenerationException(
          'Course generation failed: the lesson data was not valid.');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // GENERATE-OR-LOAD (cache-aware entry point the UI calls)
  // ═══════════════════════════════════════════════════════════════

  static Future<TopicCourse> generateOrLoadCourse({
    required String careerId,
    required String careerTitle,
    required String categoryId,
    required int level,
    required String levelTitle,
    required List<String> topics,
    required String difficulty,
    bool forceRegenerate = false,
    int? lessonIndex,
  }) async {
    final r = await generateOrLoadCourseWithInfo(
      careerId: careerId,
      careerTitle: careerTitle,
      categoryId: categoryId,
      level: level,
      levelTitle: levelTitle,
      topics: topics,
      difficulty: difficulty,
      forceRegenerate: forceRegenerate,
      lessonIndex: lessonIndex,
    );
    return r.course;
  }

  /// Same as [generateOrLoadCourse] but also says where the course came
  /// from (backend / local / fallback / cache).
  static Future<CourseLoadResult> generateOrLoadCourseWithInfo({
    required String careerId,
    required String careerTitle,
    required String categoryId,
    required int level,
    required String levelTitle,
    required List<String> topics,
    required String difficulty,
    bool forceRegenerate = false,
    int? lessonIndex,
  }) async {
    final cacheKey = _cacheKeyFor(careerId, level, lessonIndex: lessonIndex);

    if (!forceRegenerate) {
      final cached = await _loadFromCache(
        cacheKey,
        careerId: careerId,
        level: level,
        lessonIndex: lessonIndex,
      );
      if (cached != null) {
        final info = GenerationInfo(origin: cached.origin, fromCache: true);
        lastCourseInfo = info;
        lastInfo = info;
        return CourseLoadResult(cached.course, info);
      }
    }

    final g = await _generateCourse(
      careerId: careerId,
      careerTitle: careerTitle,
      categoryId: categoryId,
      level: level,
      levelTitle: levelTitle,
      topics: topics,
      difficulty: difficulty,
      lessonIndex: lessonIndex,
    );

    final normalized = _withDeterministicId(g.course, cacheKey);
    await _saveToCache(
      cacheKey,
      normalized,
      source: g.source,
      origin: g.info.origin,
      level: level,
      lessonIndex: lessonIndex,
    );
    lastCourseInfo = g.info;
    lastInfo = g.info;
    return CourseLoadResult(normalized, g.info);
  }

  static Future<bool> isCourseCached(
    String careerId,
    int level, {
    int? lessonIndex,
  }) async {
    final cached = await _loadFromCache(
      _cacheKeyFor(careerId, level, lessonIndex: lessonIndex),
      careerId: careerId,
      level: level,
      lessonIndex: lessonIndex,
    );
    return cached != null;
  }

  /// Every valid generated course cached on this device (not lesson lists).
  static Future<List<TopicCourse>> getAllCachedCourses() async {
    if (!CourseGeneratorConfig.cacheEnabled) return <TopicCourse>[];
    final prefs = await SharedPreferences.getInstance();
    final index =
        prefs.getStringList(CourseGeneratorConfig.cacheIndexKey) ?? <String>[];
    final result = <TopicCourse>[];
    for (final key in index) {
      if (key.endsWith(_lessonListSuffix)) continue;
      final cached = await _loadFromCache(key);
      if (cached != null) result.add(cached.course);
    }
    return result;
  }

  /// Wipes ALL generated content: courses, lesson lists and the index.
  /// Lesson progress/XP keys (course_done_*, course_xp_*, course_evt_*,
  /// course_pending_*) are untouched.
  static Future<void> clearGeneratedCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs
        .getKeys()
        .where((k) => k.startsWith(CourseGeneratorConfig.cacheKeyPrefix))
        .toList();
    for (final k in keys) {
      await prefs.remove(k);
    }
    await prefs.remove(CourseGeneratorConfig.cacheIndexKey);
  }

  // ═══════════════════════════════════════════════════════════════
  // JSON → TopicCourse  (validated: no silent empty courses)
  // ═══════════════════════════════════════════════════════════════

  static TopicCourse courseFromJson(String jsonString) {
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map) {
      throw const FormatException('Course response must be a JSON object.');
    }
    final Map<String, dynamic> data;
    if (decoded['course'] is Map) {
      data = Map<String, dynamic>.from(decoded['course'] as Map);
    } else {
      data = Map<String, dynamic>.from(decoded);
    }

    final problems = CourseJsonValidator.validate(data);
    if (problems.isNotEmpty) {
      throw FormatException(
          'Invalid course data: ${problems.take(3).join(' ')}');
    }

    return TopicCourse(
      id: _string(data['id']),
      topicTitle: _string(data['topicTitle']),
      careerId: _string(data['careerId']),
      categoryId: _string(data['categoryId']),
      difficulty: _string(data['difficulty'], fallback: 'Medium'),
      estimatedMinutes: _int(data['estimatedMinutes'], fallback: 45),
      totalXp: _int(data['totalXp'], fallback: 200),
      intro: _string(data['intro']),
      emoji: _string(data['emoji'], fallback: '🚀'),
      concepts: _parseConcepts(data['concepts']),
      quiz: _parseQuiz(data['quiz']),
      challenges: _parseChallenges(data['challenges']),
      finalProject: _parseFinalProject(data['finalProject']),
    );
  }

  static List<ConceptLesson> _parseConcepts(dynamic value) {
    if (value is! List) return <ConceptLesson>[];
    return value.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      return ConceptLesson(
        title: _string(map['title'], fallback: 'Concept'),
        definition: _string(map['definition']),
        analogy: _string(map['analogy']),
        example: _string(map['example']),
        keyTakeaway: _string(map['keyTakeaway']),
        codeSnippet: _nullableString(map['codeSnippet']),
      );
    }).toList();
  }

  static List<QuizQuestion> _parseQuiz(dynamic value) {
    if (value is! List) return <QuizQuestion>[];
    return value.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      final options = _stringList(map['options']);
      return QuizQuestion(
        question: _string(map['question']),
        options: options,
        correctIndex: _safeCorrectIndex(map['correctIndex'], options.length),
        explanation: _string(map['explanation']),
        xpReward: _int(map['xpReward'],
            fallback: CourseGeneratorConfig.defaultQuizXp),
      );
    }).toList();
  }

  static List<MiniChallenge> _parseChallenges(dynamic value) {
    if (value is! List) return <MiniChallenge>[];
    return value.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      final options = _stringList(map['options']);
      return MiniChallenge(
        prompt: _string(map['prompt']),
        options: options,
        correctIndex: _safeCorrectIndex(map['correctIndex'], options.length),
        explanation: _string(map['explanation']),
        xpReward: _int(map['xpReward'],
            fallback: CourseGeneratorConfig.defaultChallengeXp),
      );
    }).toList();
  }

  static FinalProject _parseFinalProject(dynamic value) {
    final map = Map<String, dynamic>.from(value as Map);
    return FinalProject(
      title: _string(map['title'], fallback: 'Practical Career Project'),
      goal: _string(map['goal']),
      steps: _stringList(map['steps']),
      expectedOutput: _string(map['expectedOutput']),
      xpReward: _int(map['xpReward'],
          fallback: CourseGeneratorConfig.defaultProjectXp),
    );
  }

  // ── Safe helpers ───────────────────────────────────────────────

  static String _string(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    final result = value.toString().trim();
    return result.isEmpty ? fallback : result;
  }

  static String? _nullableString(dynamic value) {
    if (value == null) return null;
    final result = value.toString().trim();
    return result.isEmpty ? null : result;
  }

  static int _int(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) return <String>[];
    return value.map((item) => item.toString()).toList();
  }

  static int _safeCorrectIndex(dynamic value, int optionCount) {
    final index = _int(value, fallback: 0);
    if (optionCount == 0) return 0;
    if (index < 0 || index >= optionCount) return 0;
    return index;
  }

  // ═══════════════════════════════════════════════════════════════
  // CACHE INTERNALS (SharedPreferences)
  //
  // Course entry  = the course JSON + metadata keys:
  //   source ("backend" | "local-template"), origin, cacheSchema,
  //   contentVersion (local content only), level, lessonIndex.
  // The course keeps the SAME id/key as before, so saved progress and XP
  // (which are keyed by course id) keep working.
  //
  // An entry is DISCARDED (and rebuilt) when:
  //   * it cannot be parsed or fails validation,
  //   * its id/careerId/level/lessonIndex do not match what is asked for,
  //   * it is local content with a missing or old contentVersion,
  //   * it is an old generic placeholder from the previous mock mode.
  // Backend (AI) content is kept across contentVersion bumps.
  // ═══════════════════════════════════════════════════════════════

  static const String _lessonListSuffix = '_lessonlist';

  static String _cacheKeyFor(String careerId, int level, {int? lessonIndex}) =>
      lessonIndex == null
          ? '${careerId}_level$level'
          : '${careerId}_level${level}_lesson$lessonIndex';

  static TopicCourse _withDeterministicId(TopicCourse c, String id) {
    return TopicCourse(
      id: id,
      topicTitle: c.topicTitle,
      careerId: c.careerId,
      categoryId: c.categoryId,
      difficulty: c.difficulty,
      estimatedMinutes: c.estimatedMinutes,
      totalXp: c.totalXp,
      intro: c.intro,
      emoji: c.emoji,
      concepts: c.concepts,
      quiz: c.quiz,
      challenges: c.challenges,
      finalProject: c.finalProject,
    );
  }

  /// Old placeholder courses made by the previous backend mock mode.
  static bool _isLegacyPlaceholder(Map<String, dynamic> j) {
    try {
      final concepts = j['concepts'];
      if (concepts is List && concepts.isNotEmpty) {
        final d = (concepts.first as Map)['definition']?.toString() ?? '';
        if (d.contains('explained clearly for')) return true;
      }
      final quiz = j['quiz'];
      if (quiz is List && quiz.isNotEmpty) {
        final o = (quiz.first as Map)['options'];
        if (o is List && o.contains('Wrong option A')) return true;
      }
    } catch (_) {}
    return false;
  }

  /// True when saved LOCAL content was made by an older generator.
  static bool _staleLocalContent(Map<String, dynamic> j) {
    if (j['source'] != LocalCourseGenerator.source) return false;
    return j['contentVersion'] != CourseGeneratorConfig.localContentVersion;
  }

  static Future<_CachedCourse?> _loadFromCache(
    String key, {
    String? careerId,
    int? level,
    int? lessonIndex,
  }) async {
    if (!CourseGeneratorConfig.cacheEnabled) return null;
    final prefs = await SharedPreferences.getInstance();
    final storageKey = '${CourseGeneratorConfig.cacheKeyPrefix}$key';
    final raw = prefs.getString(storageKey);
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) throw const FormatException('not an object');
      final map = Map<String, dynamic>.from(decoded);

      if (_isLegacyPlaceholder(map)) throw const FormatException('legacy');
      if (map.containsKey('cacheSchema') &&
          map['cacheSchema'] != CourseGeneratorConfig.cacheSchemaVersion) {
        throw const FormatException('schema');
      }
      if (_staleLocalContent(map)) throw const FormatException('stale');

      // Identity: the entry must be for the lesson that is being asked for.
      if (map['id'] != key) throw const FormatException('id');
      if (careerId != null && map['careerId'] != careerId) {
        throw const FormatException('career');
      }
      if (level != null && map.containsKey('level')) {
        if (map['level'] != level) throw const FormatException('level');
        if (map['lessonIndex'] != lessonIndex) {
          throw const FormatException('lesson');
        }
      }

      final course = courseFromJson(raw); // validates the content
      final origin = GenerationInfo.parseOrigin(
          (map['origin'] ?? map['source'])?.toString());
      return _CachedCourse(course, origin);
    } catch (_) {
      // Corrupt, invalid, stale or wrong-lesson entry: remove, rebuild.
      await prefs.remove(storageKey);
      return null;
    }
  }

  static Future<void> _addToIndex(SharedPreferences prefs, String key) async {
    final index =
        prefs.getStringList(CourseGeneratorConfig.cacheIndexKey) ?? <String>[];
    if (!index.contains(key)) {
      index.add(key);
      await prefs.setStringList(CourseGeneratorConfig.cacheIndexKey, index);
    }
  }

  static String _originText(GenerationOrigin o) {
    switch (o) {
      case GenerationOrigin.backend:
        return 'backend';
      case GenerationOrigin.local:
        return 'local-template';
      case GenerationOrigin.localFallback:
        return 'local-fallback';
    }
  }

  static Future<void> _saveToCache(
    String key,
    TopicCourse course, {
    required String source,
    required GenerationOrigin origin,
    required int level,
    required int? lessonIndex,
  }) async {
    if (!CourseGeneratorConfig.cacheEnabled) return;
    final prefs = await SharedPreferences.getInstance();
    final json = _courseToJson(course)
      ..['source'] = source
      ..['origin'] = _originText(origin)
      ..['cacheSchema'] = CourseGeneratorConfig.cacheSchemaVersion
      ..['level'] = level
      ..['lessonIndex'] = lessonIndex;
    if (source == LocalCourseGenerator.source) {
      json['contentVersion'] = CourseGeneratorConfig.localContentVersion;
    }
    await prefs.setString(
        '${CourseGeneratorConfig.cacheKeyPrefix}$key', jsonEncode(json));
    await _addToIndex(prefs, key);
  }

  static Map<String, dynamic> _courseToJson(TopicCourse c) => {
        'id': c.id,
        'topicTitle': c.topicTitle,
        'careerId': c.careerId,
        'categoryId': c.categoryId,
        'difficulty': c.difficulty,
        'estimatedMinutes': c.estimatedMinutes,
        'totalXp': c.totalXp,
        'intro': c.intro,
        'emoji': c.emoji,
        'concepts': c.concepts
            .map((x) => {
                  'title': x.title,
                  'definition': x.definition,
                  'analogy': x.analogy,
                  'example': x.example,
                  'keyTakeaway': x.keyTakeaway,
                  'codeSnippet': x.codeSnippet,
                })
            .toList(),
        'quiz': c.quiz
            .map((q) => {
                  'question': q.question,
                  'options': q.options,
                  'correctIndex': q.correctIndex,
                  'explanation': q.explanation,
                  'xpReward': q.xpReward,
                })
            .toList(),
        'challenges': c.challenges
            .map((ch) => {
                  'prompt': ch.prompt,
                  'options': ch.options,
                  'correctIndex': ch.correctIndex,
                  'explanation': ch.explanation,
                  'xpReward': ch.xpReward,
                })
            .toList(),
        'finalProject': {
          'title': c.finalProject.title,
          'goal': c.finalProject.goal,
          'steps': c.finalProject.steps,
          'expectedOutput': c.finalProject.expectedOutput,
          'xpReward': c.finalProject.xpReward,
        },
      };

  // ═══════════════════════════════════════════════════════════════
  // LESSON LIST — multi-lesson-per-level system
  //
  // Cache entry (one per career + level, key ..._lessonlist):
  //   { kind, cacheSchema, careerId, level, levelTitle, lessonCount,
  //     source, origin, contentVersion?, lessons:[{index,title}] }
  // It is used only if the identity matches, the local content version is
  // current, the lessons validate (1..N, unique titles) and it holds at
  // least as many lessons as requested. Asking for FEWER lessons returns
  // the first N; asking for MORE rebuilds and replaces the entry.
  // An old-format entry (a bare list) came from the old generic mock mode
  // and is discarded.
  // ═══════════════════════════════════════════════════════════════

  static Future<List<LessonStub>> generateLessonList({
    required String careerId,
    required String careerTitle,
    required String categoryId,
    required int level,
    required String levelTitle,
    required String difficulty,
    int lessonCount = CourseGeneratorConfig.lessonsPerDynamicLevel,
  }) async {
    final r = await _generateLessonList(
      careerId: careerId,
      careerTitle: careerTitle,
      categoryId: categoryId,
      level: level,
      levelTitle: levelTitle,
      difficulty: difficulty,
      lessonCount: lessonCount,
    );
    return r.stubs;
  }

  static CourseGenerationException _badCount() => CourseGenerationException(
      'Lesson list generation failed: the number of lessons must be '
      'between ${CourseGeneratorConfig.minLessonCount} and '
      '${CourseGeneratorConfig.maxLessonCount}.');

  static Future<_GeneratedList> _generateLessonList({
    required String careerId,
    required String careerTitle,
    required String categoryId,
    required int level,
    required String levelTitle,
    required String difficulty,
    required int lessonCount,
  }) async {
    if (lessonCount < CourseGeneratorConfig.minLessonCount ||
        lessonCount > CourseGeneratorConfig.maxLessonCount) {
      throw _badCount();
    }
    BackendIssue? issue;

    if (backendEnabled) {
      final prompt = buildLessonListPrompt(
        careerTitle: careerTitle,
        levelTitle: levelTitle,
        difficulty: difficulty,
        lessonCount: lessonCount,
      );
      final out = await _tryBackend(lessonListBackendUrl, <String, dynamic>{
        'careerId': careerId,
        'careerTitle': careerTitle,
        'categoryId': categoryId,
        'level': level,
        'levelTitle': levelTitle,
        'difficulty': difficulty,
        'lessonCount': lessonCount,
        'prompt': prompt,
      });
      issue = out.issue;
      final env = out.body;
      if (env != null) {
        final raw = env['lessonList'];
        if (raw is! Map) {
          issue = BackendIssue.invalidResponse;
        } else {
          final m = Map<String, dynamic>.from(raw);
          if (CourseJsonValidator.validateLessonList(m,
                  expectedCount: lessonCount)
              .isNotEmpty) {
            issue = BackendIssue.invalidResponse;
          } else if (!_listIdentityOk(env,
              careerId: careerId,
              categoryId: categoryId,
              level: level,
              lessonCount: lessonCount)) {
            issue = BackendIssue.identityMismatch;
          } else {
            return _GeneratedList(
              lessonListFromJson(jsonEncode(m)),
              'backend',
              const GenerationInfo(
                  origin: GenerationOrigin.backend, fromCache: false),
            );
          }
        }
      }
    }

    try {
      final json = LocalCourseGenerator.generateLessonList(
        careerId: careerId,
        level: level,
        lessonCount: lessonCount,
      );
      final origin = backendEnabled
          ? GenerationOrigin.localFallback
          : GenerationOrigin.local;
      return _GeneratedList(
        lessonListFromJson(jsonEncode(json)),
        LocalCourseGenerator.source,
        GenerationInfo(origin: origin, fromCache: false, backendIssue: issue),
      );
    } on LocalGenerationException catch (e) {
      debugPrint('Local lesson list failed: ${e.message}');
      throw const CourseGenerationException(
          'Lesson list generation failed: these lessons are not available yet.');
    } on FormatException catch (e) {
      debugPrint('Local lesson list rejected: ${e.message}');
      throw const CourseGenerationException(
          'Lesson list generation failed: the lesson data was not valid.');
    }
  }

  static List<LessonStub> lessonListFromJson(String jsonString) {
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map) {
      throw const FormatException('Lesson list response must be a JSON object.');
    }
    final Map<String, dynamic> data;
    if (decoded['lessonList'] is Map) {
      data = Map<String, dynamic>.from(decoded['lessonList'] as Map);
    } else {
      data = Map<String, dynamic>.from(decoded);
    }

    final problems = CourseJsonValidator.validateLessonList(data);
    if (problems.isNotEmpty) {
      throw FormatException(
          'Invalid lesson list: ${problems.take(3).join(' ')}');
    }

    final stubs = (data['lessons'] as List).map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      return LessonStub(
        index: _int(map['index'], fallback: 0),
        title: _string(map['title'], fallback: 'Lesson'),
      );
    }).toList();

    stubs.sort((a, b) => a.index.compareTo(b.index));
    return stubs;
  }

  /// Cache-aware entry point for the lesson list.
  static Future<List<LessonStub>> generateOrLoadLessonList({
    required String careerId,
    required String careerTitle,
    required String categoryId,
    required int level,
    required String levelTitle,
    required String difficulty,
    int lessonCount = CourseGeneratorConfig.lessonsPerDynamicLevel,
  }) async {
    final r = await generateOrLoadLessonListWithInfo(
      careerId: careerId,
      careerTitle: careerTitle,
      categoryId: categoryId,
      level: level,
      levelTitle: levelTitle,
      difficulty: difficulty,
      lessonCount: lessonCount,
    );
    return r.lessons;
  }

  static Future<LessonListResult> generateOrLoadLessonListWithInfo({
    required String careerId,
    required String careerTitle,
    required String categoryId,
    required int level,
    required String levelTitle,
    required String difficulty,
    int lessonCount = CourseGeneratorConfig.lessonsPerDynamicLevel,
  }) async {
    if (lessonCount < CourseGeneratorConfig.minLessonCount ||
        lessonCount > CourseGeneratorConfig.maxLessonCount) {
      throw _badCount();
    }
    final cacheKey = '${careerId}_level$level$_lessonListSuffix';

    final cached = await _loadLessonListFromCache(
      cacheKey,
      careerId: careerId,
      level: level,
      levelTitle: levelTitle,
    );
    if (cached != null && cached.stubs.length >= lessonCount) {
      final info = GenerationInfo(origin: cached.origin, fromCache: true);
      lastListInfo = info;
      lastInfo = info;
      return LessonListResult(cached.stubs.take(lessonCount).toList(), info);
    }

    final g = await _generateLessonList(
      careerId: careerId,
      careerTitle: careerTitle,
      categoryId: categoryId,
      level: level,
      levelTitle: levelTitle,
      difficulty: difficulty,
      lessonCount: lessonCount,
    );

    await _saveLessonListToCache(
      cacheKey,
      g.stubs,
      careerId: careerId,
      level: level,
      levelTitle: levelTitle,
      source: g.source,
      origin: g.info.origin,
    );
    lastListInfo = g.info;
    lastInfo = g.info;
    return LessonListResult(g.stubs, g.info);
  }

  static Future<_CachedList?> _loadLessonListFromCache(
    String key, {
    required String careerId,
    required int level,
    required String levelTitle,
  }) async {
    if (!CourseGeneratorConfig.cacheEnabled) return null;
    final prefs = await SharedPreferences.getInstance();
    final storageKey = '${CourseGeneratorConfig.cacheKeyPrefix}$key';
    final raw = prefs.getString(storageKey);
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      // Old format (a bare list) came from the old generic mock: discard.
      if (decoded is! Map) throw const FormatException('legacy');
      final map = Map<String, dynamic>.from(decoded);
      if (map['kind'] != 'lessonlist') throw const FormatException('kind');
      if (map['cacheSchema'] != CourseGeneratorConfig.cacheSchemaVersion) {
        throw const FormatException('schema');
      }
      if (map['careerId'] != careerId) throw const FormatException('career');
      if (map['level'] != level) throw const FormatException('level');
      if (map['levelTitle'] != levelTitle) throw const FormatException('title');
      if (_staleLocalContent(map)) throw const FormatException('stale');

      final lessons = map['lessons'];
      if (lessons is! List) throw const FormatException('lessons');
      final problems = CourseJsonValidator.validateLessonList(
          <String, dynamic>{'lessons': lessons},
          expectedCount: lessons.length);
      if (problems.isNotEmpty) throw const FormatException('invalid');
      if (map['lessonCount'] != lessons.length) {
        throw const FormatException('count');
      }
      final stubs = lessonListFromJson(jsonEncode({'lessons': lessons}));
      final origin = GenerationInfo.parseOrigin(
          (map['origin'] ?? map['source'])?.toString());
      return _CachedList(stubs, origin);
    } catch (_) {
      await prefs.remove(storageKey);
      return null;
    }
  }

  static Future<void> _saveLessonListToCache(
    String key,
    List<LessonStub> stubs, {
    required String careerId,
    required int level,
    required String levelTitle,
    required String source,
    required GenerationOrigin origin,
  }) async {
    if (!CourseGeneratorConfig.cacheEnabled) return;
    final prefs = await SharedPreferences.getInstance();
    final entry = <String, dynamic>{
      'kind': 'lessonlist',
      'cacheSchema': CourseGeneratorConfig.cacheSchemaVersion,
      'careerId': careerId,
      'level': level,
      'levelTitle': levelTitle,
      'lessonCount': stubs.length,
      'source': source,
      'origin': _originText(origin),
      'lessons':
          stubs.map((s) => {'index': s.index, 'title': s.title}).toList(),
    };
    if (source == LocalCourseGenerator.source) {
      entry['contentVersion'] = CourseGeneratorConfig.localContentVersion;
    }
    await prefs.setString(
        '${CourseGeneratorConfig.cacheKeyPrefix}$key', jsonEncode(entry));
    await _addToIndex(prefs, key);
  }
}

// ── private helper types ──────────────────────────────────────────

class _BackendOutcome {
  const _BackendOutcome.ok(Map<String, dynamic> this.body) : issue = null;
  const _BackendOutcome.fail(BackendIssue this.issue) : body = null;
  final Map<String, dynamic>? body;
  final BackendIssue? issue;
}

class _GeneratedCourse {
  const _GeneratedCourse(this.course, this.source, this.info);
  final TopicCourse course;
  final String source; // "backend" | "local-template"
  final GenerationInfo info;
}

class _GeneratedList {
  const _GeneratedList(this.stubs, this.source, this.info);
  final List<LessonStub> stubs;
  final String source;
  final GenerationInfo info;
}

class _CachedCourse {
  const _CachedCourse(this.course, this.origin);
  final TopicCourse course;
  final GenerationOrigin origin;
}

class _CachedList {
  const _CachedList(this.stubs, this.origin);
  final List<LessonStub> stubs;
  final GenerationOrigin origin;
}

/// One entry in a level's syllabus — just a title until the lesson itself
/// is opened and its full content is generated via
/// CourseGeneratorService.generateOrLoadCourse.
class LessonStub {
  final int index;
  final String title;

  const LessonStub({
    required this.index,
    required this.title,
  });
}