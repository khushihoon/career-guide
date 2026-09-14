import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../lib/data/courses/course_generator_config.dart';

/// Course Generator Backend API
///
/// Receives a course-generation prompt from the Flutter app.
///
/// - If OPENAI_API_KEY is set  -> calls OpenAI and returns real content.
/// - If OPENAI_API_KEY is NOT set -> returns MOCK content in the exact
///   same JSON schema, so the entire Flutter -> Backend -> JSON ->
///   TopicCourse -> cache pipeline can be tested with zero configuration.
///
/// To add a real key later: set OPENAI_API_KEY. No Flutter code changes.
/// To swap AI providers later: edit only the "CALL AI" section below.
///
/// Example:
/// dart run backend/course_generator_api.dart                (mock mode)
/// OPENAI_API_KEY=sk-xxx dart run backend/course_generator_api.dart (real)
class CourseGeneratorApi {
  static const int port = 8080;

  static const String openAiUrl =
      'https://api.openai.com/v1/chat/completions';

  static Future<void> start() async {
    final server = await HttpServer.bind(
      InternetAddress.anyIPv4,
      port,
    );

    final mockMode = (Platform.environment['OPENAI_API_KEY'] ?? '').trim().isEmpty;
    print('Course Generator Backend running on port $port'
        '${mockMode ? "  [MOCK MODE - no OPENAI_API_KEY set]" : "  [LIVE AI MODE]"}');

    await for (final request in server) {
      await _handleRequest(request);
    }
  }

  static Future<void> _handleRequest(
    HttpRequest request,
  ) async {
    // ----------------------------------------------------------
    // CORS
    // ----------------------------------------------------------

    request.response.headers
      ..set(
        'Access-Control-Allow-Origin',
        '*',
      )
      ..set(
        'Access-Control-Allow-Headers',
        'Content-Type',
      )
      ..set(
        'Access-Control-Allow-Methods',
        'POST, OPTIONS',
      )
      ..contentType = ContentType.json;

    // ----------------------------------------------------------
    // OPTIONS
    // ----------------------------------------------------------

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.ok;
      await request.response.close();
      return;
    }

    // ----------------------------------------------------------
    // HEALTH CHECK
    // ----------------------------------------------------------

    if (request.method == 'GET' &&
        request.uri.path == '/health') {
      final mockMode =
          (Platform.environment['OPENAI_API_KEY'] ?? '').trim().isEmpty;
      await _sendJson(
        request,
        HttpStatus.ok,
        {
          'success': true,
          'message': 'Course Generator Backend is running.',
          'mode': mockMode ? 'mock' : 'live',
        },
      );
      return;
    }

    // ----------------------------------------------------------
    // COURSE GENERATION
    // ----------------------------------------------------------

    if (request.method == 'POST' &&
        request.uri.path == '/generate-course') {
      await _generateCourse(request);
      return;
    }

    // ----------------------------------------------------------
    // LESSON LIST GENERATION (multi-lesson-per-level system —
    // Security, Design, Emerging, Testing, Specialized only)
    // ----------------------------------------------------------

    if (request.method == 'POST' &&
        request.uri.path == '/generate-lesson-list') {
      await _generateLessonList(request);
      return;
    }

    await _sendJson(
      request,
      HttpStatus.notFound,
      {
        'success': false,
        'error': 'Endpoint not found.',
      },
    );
  }

  static Future<void> _generateCourse(
    HttpRequest request,
  ) async {
    try {
      // --------------------------------------------------------
      // READ REQUEST BODY
      // --------------------------------------------------------

      final body =
          await utf8.decoder.bind(request).join();

      if (body.trim().isEmpty) {
        await _sendJson(
          request,
          HttpStatus.badRequest,
          {
            'success': false,
            'error': 'Request body is empty.',
          },
        );
        return;
      }

      final decoded = jsonDecode(body);

      if (decoded is! Map) {
        await _sendJson(
          request,
          HttpStatus.badRequest,
          {
            'success': false,
            'error':
                'Request body must be a JSON object.',
          },
        );
        return;
      }

      final data =
          Map<String, dynamic>.from(decoded);

      final prompt =
          data['prompt']?.toString().trim() ?? '';

      if (prompt.isEmpty) {
        await _sendJson(
          request,
          HttpStatus.badRequest,
          {
            'success': false,
            'error':
                'Course generation prompt is required.',
          },
        );
        return;
      }

      // --------------------------------------------------------
      // API KEY / PROVIDER SELECTION
      // --------------------------------------------------------

      final apiKey = Platform.environment['OPENAI_API_KEY'];
      final useMock = apiKey == null || apiKey.trim().isEmpty;

      Map<String, dynamic> courseJson;

      if (useMock) {
        // ----------------------------------------------------
        // MOCK MODE -- no key configured. Lets the full pipeline
        // be tested end-to-end without any AI provider.
        // ----------------------------------------------------
        courseJson = _buildMockCourse(data);
      } else {
        // ----------------------------------------------------
        // CALL AI (swap provider here later if needed -- this is
        // the ONLY section that needs to change to use a
        // different AI provider/config)
        // ----------------------------------------------------
        final aiResponse = await http.post(
          Uri.parse(openAiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            'model': 'gpt-4o-mini',
            'temperature': 0.7,
            'response_format': {
              'type': 'json_object',
            },
            'messages': [
              {
                'role': 'system',
                'content': '''
You are an expert career-course generator.

Generate educational course content exactly according
to the user's supplied prompt.

Return ONLY valid JSON.
Do not return Markdown.
Do not wrap JSON inside code blocks.
''',
              },
              {
                'role': 'user',
                'content': prompt,
              },
            ],
          }),
        );

        if (aiResponse.statusCode < 200 || aiResponse.statusCode >= 300) {
          await _sendJson(
            request,
            HttpStatus.badGateway,
            {
              'success': false,
              'error': 'AI provider returned an error.',
              'providerStatus': aiResponse.statusCode,
            },
          );
          return;
        }

        final aiData = jsonDecode(aiResponse.body);
        final choices = aiData['choices'];

        if (choices is! List || choices.isEmpty) {
          throw const FormatException('AI response contains no choices.');
        }

        final firstChoice = choices.first;
        if (firstChoice is! Map) {
          throw const FormatException('Invalid AI choice format.');
        }

        final message = firstChoice['message'];
        if (message is! Map) {
          throw const FormatException('AI response contains no message.');
        }

        final content = message['content']?.toString().trim();
        if (content == null || content.isEmpty) {
          throw const FormatException('AI returned empty course content.');
        }

        final parsed = jsonDecode(content);
        if (parsed is! Map) {
          throw const FormatException('AI course response is not a JSON object.');
        }

        courseJson = Map<String, dynamic>.from(parsed);
      }

      // --------------------------------------------------------
      // RETURN COURSE
      // --------------------------------------------------------

      await _sendJson(
        request,
        HttpStatus.ok,
        {
          'success': true,
          'mock': useMock,
          'course': courseJson,
        },
      );
    } catch (e) {
      await _sendJson(
        request,
        HttpStatus.internalServerError,
        {
          'success': false,
          'error': e.toString(),
        },
      );
    }
  }

  // ============================================================
  // MOCK COURSE BUILDER
  //
  // Produces schema-correct content directly from the request
  // fields (careerId, levelTitle, topics, difficulty), using the
  // SAME CourseGeneratorConfig counts as real generation, so the
  // mock output structurally matches what real AI content will be.
  // ============================================================

  static Map<String, dynamic> _buildMockCourse(Map<String, dynamic> data) {
    final careerId = (data['careerId'] ?? '').toString();
    final careerTitle = (data['careerTitle'] ?? 'Career').toString();
    final categoryId = (data['categoryId'] ?? '').toString();
    final level = data['level'] is int
        ? data['level'] as int
        : int.tryParse('${data['level']}') ?? 1;
    final levelTitle = (data['levelTitle'] ?? 'Level $level').toString();
    final difficulty = (data['difficulty'] ?? 'Medium').toString();
    final topics = (data['topics'] is List)
        ? List<String>.from((data['topics'] as List).map((e) => e.toString()))
        : <String>['Core Concepts'];

    final concepts = List.generate(CourseGeneratorConfig.conceptsPerLesson, (i) {
      final topic = topics[i % topics.length];
      return {
        'title': topic,
        'definition': '$topic explained clearly for $careerTitle learners.',
        'analogy': 'Think of $topic like a real-world tool you already use every day.',
        'example': 'A practical example of $topic applied to a $careerTitle task.',
        'keyTakeaway': 'Remember: $topic is a foundational skill for $levelTitle.',
        'codeSnippet': null,
      };
    });

    final quiz = List.generate(CourseGeneratorConfig.quizQuestionsPerLesson, (i) {
      return {
        'question': 'Question ${i + 1} about ${topics[i % topics.length]}?',
        'options': ['Correct answer', 'Wrong option A', 'Wrong option B', 'Wrong option C'],
        'correctIndex': 0,
        'explanation': 'This is the correct answer because it matches the definition covered above.',
        'xpReward': CourseGeneratorConfig.defaultQuizXp,
      };
    });

    final challenges = List.generate(CourseGeneratorConfig.challengesPerLesson, (i) {
      return {
        'prompt': 'Scenario ${i + 1}: apply ${topics[i % topics.length]} to solve a real problem.',
        'options': ['Best approach', 'Weaker option A', 'Weaker option B', 'Weaker option C'],
        'correctIndex': 0,
        'explanation': 'The best approach directly applies the concept correctly.',
        'xpReward': CourseGeneratorConfig.defaultChallengeXp,
      };
    });

    return {
      'id': '${careerId}_level$level',
      'topicTitle': levelTitle,
      'careerId': careerId,
      'categoryId': categoryId,
      'difficulty': difficulty,
      'estimatedMinutes': 30 + (level * 5),
      'totalXp': (CourseGeneratorConfig.defaultQuizXp * CourseGeneratorConfig.quizQuestionsPerLesson) +
          (CourseGeneratorConfig.defaultChallengeXp * CourseGeneratorConfig.challengesPerLesson) +
          CourseGeneratorConfig.defaultProjectXp,
      'intro': 'Welcome to $levelTitle — build practical, real-world $careerTitle '
          'skills you can apply right away.',
      'emoji': '🧪',
      'concepts': concepts,
      'quiz': quiz,
      'challenges': challenges,
      'finalProject': CourseGeneratorConfig.generateFinalProject
          ? {
              'title': '$levelTitle Capstone',
              'goal': 'Apply everything from this level to a small $careerTitle project.',
              'steps': topics.map((t) => 'Practice: $t').toList(),
              'expectedOutput': 'A working demo showing you can apply ${topics.join(", ")}.',
              'xpReward': CourseGeneratorConfig.defaultProjectXp,
            }
          : {
              'title': 'No project configured',
              'goal': '',
              'steps': <String>[],
              'expectedOutput': '',
              'xpReward': 0,
            },
    };
  }

  // ============================================================
  // LESSON LIST GENERATION (multi-lesson-per-level system)
  //
  // Returns exactly `lessonCount` lesson titles for ONE level —
  // never full lesson content. Each returned title is later fed,
  // one at a time, into the EXISTING /generate-course endpoint
  // above (unchanged) to produce that lesson's full content.
  // ============================================================

  static Future<void> _generateLessonList(HttpRequest request) async {
    try {
      final body = await utf8.decoder.bind(request).join();

      if (body.trim().isEmpty) {
        await _sendJson(
          request,
          HttpStatus.badRequest,
          {'success': false, 'error': 'Request body is empty.'},
        );
        return;
      }

      final decoded = jsonDecode(body);
      if (decoded is! Map) {
        await _sendJson(
          request,
          HttpStatus.badRequest,
          {'success': false, 'error': 'Request body must be a JSON object.'},
        );
        return;
      }

      final data = Map<String, dynamic>.from(decoded);
      final prompt = data['prompt']?.toString().trim() ?? '';

      if (prompt.isEmpty) {
        await _sendJson(
          request,
          HttpStatus.badRequest,
          {'success': false, 'error': 'Lesson list prompt is required.'},
        );
        return;
      }

      final careerTitle = (data['careerTitle'] ?? 'Career').toString();
      final levelTitle = (data['levelTitle'] ?? 'Level').toString();
      final lessonCount = data['lessonCount'] is int
          ? data['lessonCount'] as int
          : int.tryParse('${data['lessonCount']}') ?? 10;

      final apiKey = Platform.environment['OPENAI_API_KEY'];
      final useMock = apiKey == null || apiKey.trim().isEmpty;

      Map<String, dynamic> lessonListJson;

      if (useMock) {
        // No key configured — generic, career-agnostic syllabus so
        // the full pipeline can be tested end-to-end without any AI
        // provider. Nothing here is written per-career; it only uses
        // the career/level titles passed in the request.
        lessonListJson = _buildMockLessonList(careerTitle, levelTitle, lessonCount);
      } else {
        // Same AI-call pattern as /generate-course above — only the
        // system prompt and expected JSON shape differ.
        final aiResponse = await http.post(
          Uri.parse(openAiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            'model': 'gpt-4o-mini',
            'temperature': 0.7,
            'response_format': {'type': 'json_object'},
            'messages': [
              {
                'role': 'system',
                'content': '''
You are an expert career-curriculum designer.

Generate a lesson syllabus exactly according to the user's supplied
prompt.

Return ONLY valid JSON.
Do not return Markdown.
Do not wrap JSON inside code blocks.
''',
              },
              {'role': 'user', 'content': prompt},
            ],
          }),
        );

        if (aiResponse.statusCode < 200 || aiResponse.statusCode >= 300) {
          await _sendJson(
            request,
            HttpStatus.badGateway,
            {
              'success': false,
              'error': 'AI provider returned an error.',
              'providerStatus': aiResponse.statusCode,
            },
          );
          return;
        }

        final aiData = jsonDecode(aiResponse.body);
        final choices = aiData['choices'];
        if (choices is! List || choices.isEmpty) {
          throw const FormatException('AI response contains no choices.');
        }
        final firstChoice = choices.first;
        if (firstChoice is! Map) {
          throw const FormatException('Invalid AI choice format.');
        }
        final message = firstChoice['message'];
        if (message is! Map) {
          throw const FormatException('AI response contains no message.');
        }
        final content = message['content']?.toString().trim();
        if (content == null || content.isEmpty) {
          throw const FormatException('AI returned empty lesson list content.');
        }

        final parsed = jsonDecode(content);
        if (parsed is! Map) {
          throw const FormatException('AI lesson list response is not a JSON object.');
        }
        lessonListJson = Map<String, dynamic>.from(parsed);
      }

      await _sendJson(
        request,
        HttpStatus.ok,
        {
          'success': true,
          'mock': useMock,
          'lessonList': lessonListJson,
        },
      );
    } catch (e) {
      await _sendJson(
        request,
        HttpStatus.internalServerError,
        {'success': false, 'error': e.toString()},
      );
    }
  }

  /// Generic, career-agnostic mock syllabus. Uses ONLY the career and
  /// level titles passed in — no per-career content is written here,
  /// but every title is phrased as a real, distinct lesson name (never
  /// a generic category label like "Core Concept" or "Getting
  /// Started"), so the 10 titles read naturally and stay specific to
  /// the career + level they belong to.
  static Map<String, dynamic> _buildMockLessonList(
    String careerTitle,
    String levelTitle,
    int lessonCount,
  ) {
    final titleTemplates = <String>[
      'What Every $careerTitle Professional Should Know About $levelTitle',
      'Mastering $levelTitle: A $careerTitle Perspective',
      '$levelTitle in Action: Real $careerTitle Workflows',
      'Step-by-Step: Applying $levelTitle on the Job',
      'A $careerTitle Case Study on $levelTitle',
      'Common Pitfalls When Tackling $levelTitle',
      'Pro Tips for Succeeding at $levelTitle',
      'From Theory to Practice: $levelTitle',
      'Building Confidence with $levelTitle',
      'Putting It All Together: $levelTitle',
    ];

    return {
      'lessons': List.generate(lessonCount, (i) {
        return {
          'index': i + 1,
          'title': titleTemplates[i % titleTemplates.length],
        };
      }),
    };
  }

  // ============================================================
  // JSON RESPONSE
  // ============================================================

  static Future<void> _sendJson(
    HttpRequest request,
    int statusCode,
    Map<String, dynamic> data,
  ) async {
    request.response.statusCode = statusCode;
    request.response.headers.contentType = ContentType.json;
    request.response.write(jsonEncode(data));
    await request.response.close();
  }
}

// ================================================================
// SERVER ENTRY POINT
// ================================================================

Future<void> main() async {
  await CourseGeneratorApi.start();
}