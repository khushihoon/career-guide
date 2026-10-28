import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/courses/course_generator_config.dart';
import '../models/course_content_data.dart';
import 'local_course_generator.dart';

/// ===============================================================
/// CourseGeneratorService  (v2 — local-first, free, works offline)
///
/// Flutter UI
///    ↓
/// CourseGeneratorService
///    ├─ (optional) your backend, only if you run the app with
///    │     --dart-define=COURSE_BACKEND_URL=https://your-server
///    └─ LocalCourseGenerator (built in, free, no API key, no internet)
///    ↓
/// Validated JSON  →  TopicCourse  →  SharedPreferences cache  →  UI
///
/// RULES
///  * The built-in generator is the default. The app no longer fails
///    just because a backend is stopped or unreachable.
///  * A backend answer is used only if it is real (mock != true) and
///    passes validation. Otherwise the local generator is used and the
///    reason is kept in [lastBackendError].
///  * Locally generated content is marked source="local-template".
///    It is template-based, NOT live AI output.
///  * No API key ever lives in the Flutter app.
/// ===============================================================
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

  /// Kept for older code that reads these. Empty when no backend is set.
  static String get backendUrl =>
      backendEnabled ? '$_base/generate-course' : '';
  static String get lessonListBackendUrl =>
      backendEnabled ? '$_base/generate-lesson-list' : '';

  /// Optional: set this from your app start-up to send the Firebase ID
  /// token to a backend that requires login, for example:
  ///   CourseGeneratorService.authTokenProvider =
  ///       () async => FirebaseAuth.instance.currentUser?.getIdToken();
  static Future<String?> Function()? authTokenProvider;

  /// Where the most recent result came from: "backend",
  /// "local-template" or "local-fallback" (backend failed, local used).
  static String? lastSource;

  /// Why the optional backend was not used last time (null if it was).
  static String? lastBackendError;

  static http.Client _client = http.Client();

  @visibleForTesting
  static set httpClient(http.Client c) => _client = c;

  /// Tests only: pretend COURSE_BACKEND_URL was set.
  @visibleForTesting
  static set backendBaseUrlOverride(String? v) => _baseOverride = v;

  @visibleForTesting
  static void resetForTest() {
    _client = http.Client();
    // Do not clear _baseOverride here: test-group setup may configure the
    // fake backend URL before this reset hook runs. Tests that need the
    // backend disabled should explicitly set backendBaseUrlOverride = null.
    authTokenProvider = null;
    lastSource = null;
    lastBackendError = null;
  }

  // ===============================================================
  // PROMPTS (only used when an optional backend / AI is configured)
  // ===============================================================

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

Return ONLY valid JSON, no Markdown:

{
  "lessons": [
    { "index": 1, "title": "Lesson title" }
  ]
}
''';
  }

  // ===============================================================
  // OPTIONAL BACKEND CALL
  // ===============================================================

  /// Returns the decoded JSON object, or null if the backend is off,
  /// unreachable, slow, returned an error, or returned mock content.
  /// The reason is stored in [lastBackendError].
  static Future<Map<String, dynamic>?> _tryBackend(
    String url,
    Map<String, dynamic> body,
  ) async {
    if (!backendEnabled) {
      lastBackendError = 'Backend disabled: COURSE_BACKEND_URL is empty.';
      return null;
    }
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final provider = authTokenProvider;
      if (provider != null) {
        final token = await provider();
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }
      }
      final response = await _client
          .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(
              Duration(seconds: CourseGeneratorConfig.backendTimeoutSeconds));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        lastBackendError = 'Backend returned HTTP ${response.statusCode}.';
        return null;
      }
      if (response.body.trim().isEmpty) {
        lastBackendError = 'Backend returned an empty response.';
        return null;
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map) {
        lastBackendError = 'Backend response was not a JSON object.';
        return null;
      }
      final map = Map<String, dynamic>.from(decoded);
      if (map['success'] == false) {
        lastBackendError = 'Backend reported an error: ${map['error']}';
        return null;
      }
      if (map['mock'] == true) {
        lastBackendError =
            'Backend is in mock mode (no AI key), so local content is used.';
        return null;
      }
      return map;
    } on TimeoutException {
      lastBackendError = 'Backend timed out.';
    } on FormatException {
      lastBackendError = 'Backend returned invalid JSON.';
    } catch (e) {
      // Web: "ClientException: Failed to fetch" (server down or CORS).
      // Android: SocketException (wrong address / no network).
      lastBackendError = 'Could not reach backend: $e';
    }
    return null;
  }

  // ===============================================================
  // GENERATE COURSE
  // ===============================================================

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
    lastBackendError = null;

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
      final resp = await _tryBackend(backendUrl, <String, dynamic>{
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
      if (resp != null) {
        final raw = resp['course'] ?? resp;
        if (raw is Map) {
          final m = Map<String, dynamic>.from(raw);

          // Backward compatibility: some existing generators produce MCQ
          // challenges with `question`, while TopicCourse expects `prompt`.
          // Normalize only the missing field; preserve any supplied prompt.
          final rawChallenges = m['challenges'];
          if (rawChallenges is List) {
            for (final item in rawChallenges) {
              if (item is Map) {
                final prompt = item['prompt'];
                final question = item['question'];
                if ((prompt is! String || prompt.trim().isEmpty) &&
                    question is String &&
                    question.trim().isNotEmpty) {
                  item['prompt'] = question;
                }
              }
            }
          }

          final problems = CourseJsonValidator.validate(m);
          print('COURSE BACKEND VALIDATION PROBLEMS: $problems');
          if (problems.isEmpty) {
            final course = courseFromJson(jsonEncode(m));
            lastSource = 'backend';
            return _GeneratedCourse(course, 'backend');
          }
          lastBackendError =
              'Backend course was invalid: ${problems.join(' ')}';
        } else {
          lastBackendError = 'Backend response had no course object.';
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
      lastSource =
          backendEnabled ? 'local-fallback' : LocalCourseGenerator.source;
      return _GeneratedCourse(course, LocalCourseGenerator.source);
    } on LocalGenerationException catch (e) {
      throw Exception('Course generation failed: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Course generation failed: ${e.message}');
    }
  }

  // ===============================================================
  // GENERATE-OR-LOAD (cache-aware entry point the UI calls)
  // ===============================================================

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
    final cacheKey = _cacheKeyFor(careerId, level, lessonIndex: lessonIndex);

    if (!forceRegenerate) {
      final cached = await _loadFromCache(cacheKey);
      if (cached != null) return cached;
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
    await _saveToCache(cacheKey, normalized, g.source);
    return normalized;
  }

  static Future<bool> isCourseCached(
    String careerId,
    int level, {
    int? lessonIndex,
  }) async {
    final cached = await _loadFromCache(
        _cacheKeyFor(careerId, level, lessonIndex: lessonIndex));
    return cached != null;
  }

  /// Every generated course cached on this device (not lesson lists).
  static Future<List<TopicCourse>> getAllCachedCourses() async {
    if (!CourseGeneratorConfig.cacheEnabled) return <TopicCourse>[];
    final prefs = await SharedPreferences.getInstance();
    final index =
        prefs.getStringList(CourseGeneratorConfig.cacheIndexKey) ?? <String>[];
    final result = <TopicCourse>[];
    for (final key in index) {
      if (key.endsWith(_lessonListSuffix)) continue;
      final course = await _loadFromCache(key);
      if (course != null) result.add(course);
    }
    return result;
  }

  /// Wipes ALL generated content: courses, lesson lists and the index.
  /// Lesson progress/XP keys (course_done_*, course_xp_*) are untouched.
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

  // ===============================================================
  // JSON → TopicCourse  (validated: no silent empty courses)
  // ===============================================================

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

  // ===============================================================
  // CACHE INTERNALS (SharedPreferences)
  // ===============================================================

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
  /// They are generic filler, so they are ignored and regenerated.
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

  static Future<TopicCourse?> _loadFromCache(String key) async {
    if (!CourseGeneratorConfig.cacheEnabled) return null;
    final prefs = await SharedPreferences.getInstance();
    final storageKey = '${CourseGeneratorConfig.cacheKeyPrefix}$key';
    final raw = prefs.getString(storageKey);
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) throw const FormatException('not an object');
      final map = Map<String, dynamic>.from(decoded);
      if (_isLegacyPlaceholder(map)) {
        await prefs.remove(storageKey);
        return null;
      }
      return courseFromJson(raw);
    } catch (_) {
      // Corrupt or invalid entry: remove it so it is regenerated cleanly.
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

  static Future<void> _saveToCache(
      String key, TopicCourse course, String source) async {
    if (!CourseGeneratorConfig.cacheEnabled) return;
    final prefs = await SharedPreferences.getInstance();
    final json = _courseToJson(course)..['source'] = source;
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

  // ===============================================================
  // LESSON LIST — multi-lesson-per-level system
  // ===============================================================

  static Future<List<LessonStub>> generateLessonList({
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
      throw Exception('Lesson list generation failed: lessonCount must be '
          'between ${CourseGeneratorConfig.minLessonCount} and '
          '${CourseGeneratorConfig.maxLessonCount}.');
    }
    lastBackendError = null;

    if (backendEnabled) {
      final prompt = buildLessonListPrompt(
        careerTitle: careerTitle,
        levelTitle: levelTitle,
        difficulty: difficulty,
        lessonCount: lessonCount,
      );
      final resp = await _tryBackend(lessonListBackendUrl, <String, dynamic>{
        'careerId': careerId,
        'careerTitle': careerTitle,
        'categoryId': categoryId,
        'level': level,
        'levelTitle': levelTitle,
        'difficulty': difficulty,
        'lessonCount': lessonCount,
        'prompt': prompt,
      });
      if (resp != null) {
        final raw = resp['lessonList'] ?? resp;
        if (raw is Map) {
          final m = Map<String, dynamic>.from(raw);
          final problems = CourseJsonValidator.validateLessonList(m,
              expectedCount: lessonCount);
          if (problems.isEmpty) {
            lastSource = 'backend';
            return lessonListFromJson(jsonEncode(m));
          }
          lastBackendError =
              'Backend lesson list was invalid: ${problems.take(3).join(' ')}';
        }
      }
    }

    try {
      final json = LocalCourseGenerator.generateLessonList(
        careerId: careerId,
        level: level,
        lessonCount: lessonCount,
      );
      lastSource =
          backendEnabled ? 'local-fallback' : LocalCourseGenerator.source;
      return lessonListFromJson(jsonEncode(json));
    } on LocalGenerationException catch (e) {
      throw Exception('Lesson list generation failed: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Lesson list generation failed: ${e.message}');
    }
  }

  static List<LessonStub> lessonListFromJson(String jsonString) {
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map) {
      throw const FormatException(
          'Lesson list response must be a JSON object.');
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
    final cacheKey = '${careerId}_level$level$_lessonListSuffix';

    final cached = await _loadLessonListFromCache(cacheKey);
    if (cached != null && cached.length >= lessonCount) {
      return cached.take(lessonCount).toList();
    }

    final generated = await generateLessonList(
      careerId: careerId,
      careerTitle: careerTitle,
      categoryId: categoryId,
      level: level,
      levelTitle: levelTitle,
      difficulty: difficulty,
      lessonCount: lessonCount,
    );

    await _saveLessonListToCache(cacheKey, generated);
    return generated;
  }

  static Future<List<LessonStub>?> _loadLessonListFromCache(String key) async {
    if (!CourseGeneratorConfig.cacheEnabled) return null;
    final prefs = await SharedPreferences.getInstance();
    final storageKey = '${CourseGeneratorConfig.cacheKeyPrefix}$key';
    final raw = prefs.getString(storageKey);
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) throw const FormatException('not a list');
      final stubs = decoded.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        final title = _string(map['title']);
        if (title.isEmpty) throw const FormatException('empty title');
        return LessonStub(index: _int(map['index'], fallback: 0), title: title);
      }).toList()
        ..sort((a, b) => a.index.compareTo(b.index));
      if (stubs.isEmpty) throw const FormatException('empty list');
      return stubs;
    } catch (_) {
      await prefs.remove(storageKey);
      return null;
    }
  }

  static Future<void> _saveLessonListToCache(
    String key,
    List<LessonStub> stubs,
  ) async {
    if (!CourseGeneratorConfig.cacheEnabled) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '${CourseGeneratorConfig.cacheKeyPrefix}$key',
      jsonEncode(
          stubs.map((s) => {'index': s.index, 'title': s.title}).toList()),
    );
    await _addToIndex(prefs, key);
  }
}

class _GeneratedCourse {
  const _GeneratedCourse(this.course, this.source);
  final TopicCourse course;
  final String source;
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
