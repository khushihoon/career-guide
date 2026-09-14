import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/courses/course_generator_config.dart';
import '../models/course_content_data.dart';

/// ===============================================================
/// CourseGeneratorService
///
/// Flutter UI
///    ↓
/// CourseGeneratorService
///    ↓
/// Backend API
///    ↓
/// AI Model
///    ↓
/// Strict JSON
///    ↓
/// TopicCourse
///    ↓
/// Local cache (SharedPreferences)
///    ↓
/// Flutter UI
///
/// IMPORTANT:
/// AI API key Flutter app mein nahi rakhi jaati.
/// AI key sirf backend/server par honi chahiye.
/// ===============================================================
class CourseGeneratorService {
  CourseGeneratorService._();

  /// Local backend used during development in Chrome.
  static const String backendUrl =
      'http://localhost:8080/generate-course';

  /// Backend endpoint that returns a level's SYLLABUS — exactly N
  /// lesson titles — before any individual lesson's full content is
  /// generated. Used only by the multi-lesson-per-level system
  /// (Security, Design, Emerging, Testing, Specialized). Software
  /// Engineer, AI & Data, and Cloud & DevOps never call this.
  static const String lessonListBackendUrl =
      'http://localhost:8080/generate-lesson-list';

  // ===============================================================
  // BUILD AI COURSE PROMPT
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

1. Create exactly
   ${CourseGeneratorConfig.conceptsPerLesson} concept lessons.

2. Create exactly
   ${CourseGeneratorConfig.quizQuestionsPerLesson} quiz questions.

3. Create exactly
   ${CourseGeneratorConfig.challengesPerLesson} mini challenges.

4. Create one final project because
   generateFinalProject = ${CourseGeneratorConfig.generateFinalProject}.

5. Content must be:
   - beginner-friendly
   - practical
   - career-focused
   - technically accurate
   - progressively structured
   - useful for real jobs
   - not generic filler

6. Each concept lesson MUST contain:
   - title
   - definition
   - analogy
   - example
   - keyTakeaway
   - optional codeSnippet

7. Each quiz question MUST contain:
   - question
   - exactly 4 options
   - correctIndex
   - explanation
   - xpReward

8. Each mini challenge MUST contain:
   - prompt
   - exactly 4 options
   - correctIndex
   - explanation
   - xpReward

9. Final project MUST contain:
   - title
   - goal
   - steps
   - expectedOutput
   - xpReward

10. Return ONLY valid JSON.
Do NOT use Markdown.
Do NOT wrap JSON in ```json.
Do NOT add explanations outside JSON.

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
    {
      "title": "Concept title",
      "definition": "Clear definition",
      "analogy": "Simple real-world analogy",
      "example": "Practical example",
      "keyTakeaway": "Important takeaway",
      "codeSnippet": null
    }
  ],

  "quiz": [
    {
      "question": "Question",
      "options": [
        "Option A",
        "Option B",
        "Option C",
        "Option D"
      ],
      "correctIndex": 0,
      "explanation": "Why this answer is correct",
      "xpReward": ${CourseGeneratorConfig.defaultQuizXp}
    }
  ],

  "challenges": [
    {
      "prompt": "Practical scenario",
      "options": [
        "Option A",
        "Option B",
        "Option C",
        "Option D"
      ],
      "correctIndex": 0,
      "explanation": "Why this is the best answer",
      "xpReward": ${CourseGeneratorConfig.defaultChallengeXp}
    }
  ],

  "finalProject": {
    "title": "Project title",
    "goal": "Project goal",
    "steps": [
      "Step 1",
      "Step 2",
      "Step 3",
      "Step 4"
    ],
    "expectedOutput": "Expected result",
    "xpReward": ${CourseGeneratorConfig.defaultProjectXp}
  }
}
''';
  }

  // ===============================================================
  // GENERATE COURSE THROUGH BACKEND
  // ===============================================================

  static Future<TopicCourse> generateCourse({
    required String careerId,
    required String careerTitle,
    required String categoryId,
    required int level,
    required String levelTitle,
    required List<String> topics,
    required String difficulty,
  }) async {
    final prompt = buildCoursePrompt(
      careerId: careerId,
      careerTitle: careerTitle,
      categoryId: categoryId,
      level: level,
      levelTitle: levelTitle,
      topics: topics,
      difficulty: difficulty,
    );

    try {
      final response = await http
          .post(
            Uri.parse(backendUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'careerId': careerId,
              'careerTitle': careerTitle,
              'categoryId': categoryId,
              'level': level,
              'levelTitle': levelTitle,
              'topics': topics,
              'difficulty': difficulty,
              'prompt': prompt,
            }),
          )
          .timeout(
            const Duration(seconds: 90),
          );

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw Exception(
          'Backend error ${response.statusCode}: '
          '${response.body}',
        );
      }

      if (response.body.trim().isEmpty) {
        throw Exception('Backend returned empty response.');
      }

      return courseFromJson(response.body);
    } catch (e) {
      throw Exception(
        'Course generation failed: $e',
      );
    }
  }

  // ===============================================================
  // GENERATE-OR-LOAD (cache-aware entry point)
  //
  // This is the method the UI should call. It:
  //   1. Checks local cache for careerId+level
  //   2. Returns cached TopicCourse instantly if found
  //   3. Otherwise calls the backend (generateCourse) and caches result
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
    // Optional: identifies ONE lesson within a level for the
    // multi-lesson-per-level system (Security, Design, Emerging,
    // Testing, Specialized). Leave null for every existing caller
    // (Software Engineer static lessons don't use this method at
    // all; Cloud & DevOps keeps generating one course per level
    // exactly as before) — behaviour and cache keys for those are
    // completely unchanged.
    int? lessonIndex,
  }) async {
    final cacheKey = _cacheKeyFor(careerId, level, lessonIndex: lessonIndex);

    if (!forceRegenerate) {
      final cached = await _loadFromCache(cacheKey);
      if (cached != null) return cached;
    }

    final generated = await generateCourse(
      careerId: careerId,
      careerTitle: careerTitle,
      categoryId: categoryId,
      level: level,
      levelTitle: levelTitle,
      topics: topics,
      difficulty: difficulty,
    );

    final normalized = _withDeterministicId(generated, cacheKey);
    await _saveToCache(cacheKey, normalized);
    return normalized;
  }

  /// Whether a given career/level (or a specific lesson within a
  /// level, when lessonIndex is passed) has already been generated
  /// & cached.
  static Future<bool> isCourseCached(
    String careerId,
    int level, {
    int? lessonIndex,
  }) async {
    final cached =
        await _loadFromCache(_cacheKeyFor(careerId, level, lessonIndex: lessonIndex));
    return cached != null;
  }

  /// Returns every generated course currently cached on this device.
  /// Used by the Learn tab to show generated courses alongside the
  /// existing static 633 lessons.
  static Future<List<TopicCourse>> getAllCachedCourses() async {
    if (!CourseGeneratorConfig.cacheEnabled) return <TopicCourse>[];
    final prefs = await SharedPreferences.getInstance();
    final index =
        prefs.getStringList(CourseGeneratorConfig.cacheIndexKey) ??
            <String>[];
    final List<TopicCourse> result = [];
    for (final key in index) {
      final course = await _loadFromCache(key);
      if (course != null) result.add(course);
    }
    return result;
  }

  /// Debug/testing utility — wipes all cached generated courses.
  static Future<void> clearGeneratedCache() async {
    final prefs = await SharedPreferences.getInstance();
    final index =
        prefs.getStringList(CourseGeneratorConfig.cacheIndexKey) ??
            <String>[];
    for (final key in index) {
      await prefs.remove('${CourseGeneratorConfig.cacheKeyPrefix}$key');
    }
    await prefs.remove(CourseGeneratorConfig.cacheIndexKey);
  }

  // ===============================================================
  // JSON → TopicCourse
  // ===============================================================

  static TopicCourse courseFromJson(String jsonString) {
    final decoded = jsonDecode(jsonString);

    final Map<String, dynamic> data;

    if (decoded is Map<String, dynamic>) {
      // Supports both:
      //
      // { course fields... }
      //
      // and:
      //
      // { "course": { course fields... } }

      if (decoded['course'] is Map<String, dynamic>) {
        data = Map<String, dynamic>.from(
          decoded['course'] as Map,
        );
      } else {
        data = decoded;
      }
    } else {
      throw const FormatException(
        'Course response must be a JSON object.',
      );
    }

    return TopicCourse(
      id: _string(
        data['id'],
        fallback: 'generated_course_${DateTime.now().millisecondsSinceEpoch}',
      ),

      topicTitle: _string(
        data['topicTitle'],
        fallback: 'Generated Course',
      ),

      careerId: _string(
        data['careerId'],
        fallback: '',
      ),

      categoryId: _string(
        data['categoryId'],
        fallback: '',
      ),

      difficulty: _string(
        data['difficulty'],
        fallback: 'Medium',
      ),

      estimatedMinutes: _int(
        data['estimatedMinutes'],
        fallback: 45,
      ),

      totalXp: _int(
        data['totalXp'],
        fallback: 200,
      ),

      intro: _string(
        data['intro'],
        fallback: 'Start learning and build practical career skills.',
      ),

      emoji: _string(
        data['emoji'],
        fallback: '🚀',
      ),

      concepts: _parseConcepts(
        data['concepts'],
      ),

      quiz: _parseQuiz(
        data['quiz'],
      ),

      challenges: _parseChallenges(
        data['challenges'],
      ),

      finalProject: _parseFinalProject(
        data['finalProject'],
      ),
    );
  }

  // ===============================================================
  // CONCEPT PARSER
  // ===============================================================

  static List<ConceptLesson> _parseConcepts(
    dynamic value,
  ) {
    if (value is! List) {
      return <ConceptLesson>[];
    }

    return value.map((item) {
      final map = Map<String, dynamic>.from(
        item as Map,
      );

      return ConceptLesson(
        title: _string(
          map['title'],
          fallback: 'Concept',
        ),
        definition: _string(
          map['definition'],
          fallback: '',
        ),
        analogy: _string(
          map['analogy'],
          fallback: '',
        ),
        example: _string(
          map['example'],
          fallback: '',
        ),
        keyTakeaway: _string(
          map['keyTakeaway'],
          fallback: '',
        ),
        codeSnippet: _nullableString(
          map['codeSnippet'],
        ),
      );
    }).toList();
  }

  // ===============================================================
  // QUIZ PARSER
  // ===============================================================

  static List<QuizQuestion> _parseQuiz(
    dynamic value,
  ) {
    if (value is! List) {
      return <QuizQuestion>[];
    }

    return value.map((item) {
      final map = Map<String, dynamic>.from(
        item as Map,
      );

      final options = _stringList(
        map['options'],
      );

      return QuizQuestion(
        question: _string(
          map['question'],
          fallback: '',
        ),
        options: options,
        correctIndex: _safeCorrectIndex(
          map['correctIndex'],
          options.length,
        ),
        explanation: _string(
          map['explanation'],
          fallback: '',
        ),
        xpReward: _int(
          map['xpReward'],
          fallback: CourseGeneratorConfig.defaultQuizXp,
        ),
      );
    }).toList();
  }

  // ===============================================================
  // CHALLENGE PARSER
  // ===============================================================

  static List<MiniChallenge> _parseChallenges(
    dynamic value,
  ) {
    if (value is! List) {
      return <MiniChallenge>[];
    }

    return value.map((item) {
      final map = Map<String, dynamic>.from(
        item as Map,
      );

      final options = _stringList(
        map['options'],
      );

      return MiniChallenge(
        prompt: _string(
          map['prompt'],
          fallback: '',
        ),
        options: options,
        correctIndex: _safeCorrectIndex(
          map['correctIndex'],
          options.length,
        ),
        explanation: _string(
          map['explanation'],
          fallback: '',
        ),
        xpReward: _int(
          map['xpReward'],
          fallback: CourseGeneratorConfig.defaultChallengeXp,
        ),
      );
    }).toList();
  }

  // ===============================================================
  // FINAL PROJECT PARSER
  // ===============================================================

  static FinalProject _parseFinalProject(
    dynamic value,
  ) {
    if (value is! Map) {
      return FinalProject(
        title: 'Practical Career Project',
        goal: 'Apply the skills learned in this course.',
        steps: const [
          'Review the concepts.',
          'Plan the solution.',
          'Build the project.',
          'Test the project.',
          'Document the result.',
        ],
        expectedOutput: 'A working practical project.',
        xpReward:
            CourseGeneratorConfig.defaultProjectXp,
      );
    }

    final map = Map<String, dynamic>.from(
      value,
    );

    return FinalProject(
      title: _string(
        map['title'],
        fallback: 'Practical Career Project',
      ),
      goal: _string(
        map['goal'],
        fallback: 'Apply the skills learned in this course.',
      ),
      steps: _stringList(
        map['steps'],
      ),
      expectedOutput: _string(
        map['expectedOutput'],
        fallback: 'A working practical project.',
      ),
      xpReward: _int(
        map['xpReward'],
        fallback:
            CourseGeneratorConfig.defaultProjectXp,
      ),
    );
  }

  // ===============================================================
  // SAFE HELPERS
  // ===============================================================

  static String _string(
    dynamic value, {
    String fallback = '',
  }) {
    if (value == null) {
      return fallback;
    }

    final result = value.toString().trim();

    return result.isEmpty ? fallback : result;
  }

  static String? _nullableString(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    final result = value.toString().trim();

    return result.isEmpty ? null : result;
  }

  static int _int(
    dynamic value, {
    int fallback = 0,
  }) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? fallback;
    }

    return fallback;
  }

  static List<String> _stringList(
    dynamic value,
  ) {
    if (value is! List) {
      return <String>[];
    }

    return value
        .map(
          (item) => item.toString(),
        )
        .toList();
  }

  static int _safeCorrectIndex(
    dynamic value,
    int optionCount,
  ) {
    final index = _int(
      value,
      fallback: 0,
    );

    if (optionCount == 0) {
      return 0;
    }

    if (index < 0) {
      return 0;
    }

    if (index >= optionCount) {
      return 0;
    }

    return index;
  }

  // ===============================================================
  // CACHE INTERNALS (SharedPreferences-backed)
  // ===============================================================

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

  static Future<TopicCourse?> _loadFromCache(String key) async {
    if (!CourseGeneratorConfig.cacheEnabled) return null;
    final prefs = await SharedPreferences.getInstance();
    final raw =
        prefs.getString('${CourseGeneratorConfig.cacheKeyPrefix}$key');
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      return courseFromJson(raw);
    } catch (_) {
      return null; // corrupted cache entry — will be regenerated
    }
  }

  static Future<void> _saveToCache(String key, TopicCourse course) async {
    if (!CourseGeneratorConfig.cacheEnabled) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '${CourseGeneratorConfig.cacheKeyPrefix}$key',
      jsonEncode(_courseToJson(course)),
    );

    final index =
        prefs.getStringList(CourseGeneratorConfig.cacheIndexKey) ??
            <String>[];
    if (!index.contains(key)) {
      index.add(key);
      await prefs.setStringList(CourseGeneratorConfig.cacheIndexKey, index);
    }
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
  //
  // Used ONLY by the 5 fully-dynamic categories (Security, Design,
  // Emerging, Testing, Specialized). A level in those categories has
  // no hard-coded lesson content — the app asks the backend for a
  // SYLLABUS of CourseGeneratorConfig.lessonsPerDynamicLevel lesson
  // titles, then generates each lesson's full content on demand via
  // the EXISTING generateOrLoadCourse above (unchanged), called once
  // per lesson with a lessonIndex.
  //
  // Software Engineer, AI & Data, and Cloud & DevOps never call any
  // of this — it is purely additive.
  // ===============================================================

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
- Lessons must progress logically within the level (foundational
  ideas first, more applied/advanced ideas later).
- No duplicate or filler lesson titles.
- Titles should be concise (a few words to one short phrase).

Return ONLY valid JSON, no Markdown, no explanations outside JSON:

{
  "lessons": [
    { "index": 1, "title": "Lesson title" }
    // ...exactly $lessonCount objects total, index 1 to $lessonCount
  ]
}
''';
  }

  static Future<List<LessonStub>> generateLessonList({
    required String careerId,
    required String careerTitle,
    required String categoryId,
    required int level,
    required String levelTitle,
    required String difficulty,
    int lessonCount = CourseGeneratorConfig.lessonsPerDynamicLevel,
  }) async {
    final prompt = buildLessonListPrompt(
      careerTitle: careerTitle,
      levelTitle: levelTitle,
      difficulty: difficulty,
      lessonCount: lessonCount,
    );

    try {
      final response = await http
          .post(
            Uri.parse(lessonListBackendUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'careerId': careerId,
              'careerTitle': careerTitle,
              'categoryId': categoryId,
              'level': level,
              'levelTitle': levelTitle,
              'difficulty': difficulty,
              'lessonCount': lessonCount,
              'prompt': prompt,
            }),
          )
          .timeout(const Duration(seconds: 90));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'Backend error ${response.statusCode}: ${response.body}',
        );
      }
      if (response.body.trim().isEmpty) {
        throw Exception('Backend returned empty response.');
      }

      return lessonListFromJson(response.body);
    } catch (e) {
      throw Exception('Lesson list generation failed: $e');
    }
  }

  static List<LessonStub> lessonListFromJson(String jsonString) {
    final decoded = jsonDecode(jsonString);

    final Map<String, dynamic> data;
    if (decoded is Map<String, dynamic>) {
      if (decoded['lessonList'] is Map<String, dynamic>) {
        data = Map<String, dynamic>.from(decoded['lessonList'] as Map);
      } else {
        data = decoded;
      }
    } else {
      throw const FormatException('Lesson list response must be a JSON object.');
    }

    final lessonsRaw = data['lessons'];
    if (lessonsRaw is! List) {
      throw const FormatException('Lesson list response missing "lessons" array.');
    }

    final stubs = lessonsRaw.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      return LessonStub(
        index: _int(map['index'], fallback: 0),
        title: _string(map['title'], fallback: 'Lesson'),
      );
    }).toList();

    stubs.sort((a, b) => a.index.compareTo(b.index));
    return stubs;
  }

  /// Cache-aware entry point the UI should call. Generates the level's
  /// syllabus once via AI/mock, then reuses it from local cache on
  /// every later visit — the syllabus is never regenerated once it
  /// exists, exactly like a generated lesson itself.
  static Future<List<LessonStub>> generateOrLoadLessonList({
    required String careerId,
    required String careerTitle,
    required String categoryId,
    required int level,
    required String levelTitle,
    required String difficulty,
    int lessonCount = CourseGeneratorConfig.lessonsPerDynamicLevel,
  }) async {
    final cacheKey = '${careerId}_level${level}_lessonlist';

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
    final raw = prefs.getString('${CourseGeneratorConfig.cacheKeyPrefix}$key');
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return decoded.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return LessonStub(
          index: _int(map['index'], fallback: 0),
          title: _string(map['title'], fallback: 'Lesson'),
        );
      }).toList()
        ..sort((a, b) => a.index.compareTo(b.index));
    } catch (_) {
      return null; // corrupted cache entry — will be regenerated
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
      jsonEncode(stubs.map((s) => {'index': s.index, 'title': s.title}).toList()),
    );
  }
}

/// One entry in a level's AI-generated syllabus — just a title until
/// the lesson itself is opened and its full content is generated via
/// CourseGeneratorService.generateOrLoadCourse.
class LessonStub {
  final int index;
  final String title;

  const LessonStub({
    required this.index,
    required this.title,
  });
}