import 'dart:async' as async;
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../data/courses/course_generator_config.dart';
import 'backend_auth_headers.dart';

/// Claude AI Service (SECURE VERSION)
///
/// The Anthropic API key NEVER lives in the Flutter app. This service talks
/// to your own backend endpoint `POST {COURSE_BACKEND_URL}/claude/messages`
/// (see backend/course_generator_api.dart). The backend:
///   * verifies the Firebase ID token AND the Firebase App Check token,
///   * rate-limits per user and applies daily quotas / a global cap,
///   * validates the request,
///   * adds ANTHROPIC_API_KEY from its own environment and calls Anthropic.
///
/// PHASE 2: every request now carries
///   Authorization: Bearer <Firebase ID token>
///   X-Firebase-AppCheck: <App Check token>
/// A missing App Check token is never faked: the header is simply omitted and
/// an enforcing (production) backend rejects the request.
///
/// Public API is unchanged: sendMessage, createUserMessage,
/// createAssistantMessage, clearHistory, getHistorySummary, getQuickQuestions,
/// validateApiKey (now: "is the secure backend configured?"), isValidMessage,
/// getErrorMessage, formatResponse, ... and the SocketException /
/// TimeoutException classes used by MentorScreen.
class ClaudeService {
  // ────────────────────────────────────────────────────────────
  // CONSTANTS
  // ────────────────────────────────────────────────────────────

  static const int _maxRetries = 3;

  /// Backend allows up to 45s for Anthropic; give it a little more.
  /// (Free hosts may also need a cold-start wake-up.)
  static const Duration _timeout = Duration(seconds: 60);

  /// Backend accepts max 40 messages; stay safely below.
  static const int _maxHistoryMessages = 30;
  static const int _maxContentChars = 20000;

  /// The backend rejects requests whose system prompt plus all messages
  /// exceed CLAUDE_MAX_TOTAL_CHARS (default 60000). Stay below it so a long
  /// conversation is trimmed here instead of failing with "Request is too
  /// long".
  static const int _maxTotalChars = 58000;

  /// A 503 that asks the client to wait longer than this is not transient
  /// (for example the daily global AI cap): do not retry it.
  static const int _maxRetryAfterSeconds = 30;

  // System prompt for AI Career Mentor (not a secret; safe in the client)
  static const String _systemPrompt = '''
You are an expert AI career mentor inside a mobile app called "AI Career App" for students and professionals in India. Your name is Aria, and you're powered by Claude AI.

Your expertise includes:
- AI/ML career paths and job roles (AI Engineer, Data Scientist, ML Engineer, NLP Engineer, Computer Vision Engineer, Prompt Engineer)
- Required skills for each role (Python, Machine Learning, Deep Learning, PyTorch, TensorFlow, etc.)
- Salary ranges in India (₹12-35 LPA) and global opportunities
- Best learning resources (Coursera, Fast.ai, DeepLearning.AI, Google, Udemy)
- Interview preparation tips and best practices
- Resume and portfolio advice for tech roles
- Latest AI tools and technologies (ChatGPT, Claude, Hugging Face, LangChain, GitHub Copilot, Midjourney, etc.)
- Career roadmap for beginners to experts

Your personality:
- You are encouraging and motivating
- You provide practical, actionable advice
- You focus on the Indian job market but mention global opportunities
- You use simple, clear language suitable for students
- You celebrate achievements and acknowledge challenges
- You are knowledgeable but humble and willing to learn

Response guidelines:
- Keep responses concise (under 150 words) and practical
- Use bullet points sparingly - mostly use flowing paragraphs
- Be specific with examples and resources
- End with a question to encourage further discussion
- Use emojis occasionally for warmth (but not excessively)
- Always be positive and constructive
- Personalize responses based on context when possible

Topics you can help with:
- "What AI career should I choose?" → Discuss options, salaries, requirements
- "How do I learn Machine Learning?" → Provide roadmap, resources, timeline
- "What skills do I need?" → List specific skills with learning priority
- "Interview preparation?" → Tips, common questions, practice resources
- "Portfolio projects?" → Ideas, implementation tips, showcase strategies
- "Current AI tools?" → Explain what they do, when to use them
- "Salary expectations?" → Give ranges for different roles in India
- "How to get first AI job?" → Steps, timeline, strategies
- "Best courses?" → Recommend specific courses with pros/cons
- "Freelancing in AI?" → Guidance on starting, platforms, rates
''';

  // ────────────────────────────────────────────────────────────
  // BACKEND CONFIGURATION
  // ────────────────────────────────────────────────────────────

  static http.Client _client = http.Client();
  static String? _baseOverride;

  /// Delay unit between retries (tests set this to Duration.zero).
  @visibleForTesting
  static Duration retryBaseDelay = const Duration(seconds: 2);

  @visibleForTesting
  static set httpClient(http.Client c) => _client = c;

  @visibleForTesting
  static set backendBaseUrlOverride(String? v) => _baseOverride = v;

  /// Supplies the Firebase ID token. Default: current Firebase user.
  /// Tests can replace it. [forceRefresh] is used once after a 401.
  @visibleForTesting
  static Future<String?> Function({bool forceRefresh}) tokenProvider =
      _defaultTokenProvider;

  /// Supplies the Firebase App Check token. Default: the App Check SDK; it
  /// returns null (never throws) when App Check is unavailable. Tests can
  /// replace it. [forceRefresh] is used once after a 401.
  @visibleForTesting
  static Future<String?> Function({bool forceRefresh}) appCheckTokenProvider =
      BackendAuthHeaders.defaultAppCheckToken;

  static Future<String?> _defaultTokenProvider({
    bool forceRefresh = false,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return user.getIdToken(forceRefresh);
  }

  static String get _base {
    var b = (_baseOverride ?? CourseGeneratorConfig.backendBaseUrl).trim();
    while (b.endsWith('/')) {
      b = b.substring(0, b.length - 1);
    }
    return b;
  }

  static bool _isLocalHost(String host) =>
      host == 'localhost' || host == '127.0.0.1' || host == '10.0.2.2';

  /// True when a usable, SECURE backend URL is configured.
  /// HTTPS is mandatory; plain HTTP is accepted only in debug builds against
  /// localhost / the Android emulator host. Tokens are therefore only ever
  /// sent over https or to a local development server.
  static bool get isBackendConfigured {
    final b = _base;
    if (b.isEmpty) return false;
    final uri = Uri.tryParse(b);
    if (uri == null || uri.host.isEmpty) return false;
    if (uri.scheme == 'https') return true;
    return kDebugMode && uri.scheme == 'http' && _isLocalHost(uri.host);
  }

  // ────────────────────────────────────────────────────────────
  // MAIN METHOD: Send Message to Claude (via backend)
  // ────────────────────────────────────────────────────────────

  /// Send a message and get Claude's response.
  ///
  /// [history] may already contain the current user message (MentorScreen
  /// does this); it is not duplicated.
  /// [onTokenReceived] is kept for API compatibility (no streaming).
  static Future<String> sendMessage({
    required String message,
    required List<Map<String, String>> history,
    Function(String)? onTokenReceived,
    double temperature = 0.7,
    int maxTokens = 1024,
  }) async {
    try {
      if (message.trim().isEmpty) {
        throw Exception('Message cannot be empty');
      }
      if (temperature < 0 || temperature > 1) {
        throw Exception('Temperature must be between 0 and 1');
      }
      if (maxTokens < 100 || maxTokens > 4096) {
        throw Exception('Max tokens must be between 100 and 4096');
      }

      _logDebug('Sending message to AI backend');

      final response = await complete(
        system: _systemPrompt,
        messages: _composeMessages(message, history),
        maxTokens: maxTokens,
        temperature: temperature,
      );

      _logDebug('Received response from AI backend');
      return response;
    } catch (e) {
      _logError('Failed to get AI response: ${_handleError(e)}');
      rethrow;
    }
  }

  /// Generic secure completion used by MentorScreen (through sendMessage)
  /// and CopilotAIService. Always goes through the authenticated backend.
  static Future<String> complete({
    required String system,
    required List<Map<String, String>> messages,
    int maxTokens = 1024,
    double? temperature,
  }) async {
    if (!isBackendConfigured) {
      throw Exception(
        'AI service is not available right now. '
        'The app is missing a secure backend URL (COURSE_BACKEND_URL).',
      );
    }
    if (messages.isEmpty) {
      throw Exception('At least one message is required');
    }

    final body = <String, dynamic>{
      'system': system,
      'messages': _fitToBudget(system, messages),
      'max_tokens': maxTokens,
      if (temperature != null) 'temperature': temperature,
    };

    return _postWithRetry(body);
  }

  // ────────────────────────────────────────────────────────────
  // HTTP WITH RETRY
  // ────────────────────────────────────────────────────────────

  static Future<String> _postWithRetry(Map<String, dynamic> body) async {
    final uri = Uri.parse('$_base/claude/messages');
    final encoded = jsonEncode(body);

    var attempt = 0;
    var refreshedToken = false;
    Object? lastError;

    while (attempt < _maxRetries) {
      final token = await tokenProvider(forceRefresh: refreshedToken);
      if (token == null || token.isEmpty) {
        throw Exception('Please sign in to use the AI mentor.');
      }

      // App Check token: never throws; null means "omit the header" and an
      // enforcing backend will reject the request (fail closed).
      final appCheckToken = await _appCheckTokenSafe(refreshedToken);

      attempt++;
      _logDebug('API attempt $attempt of $_maxRetries');

      try {
        final response = await _client
            .post(
              uri,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=utf-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
                if (appCheckToken != null)
                  BackendAuthHeaders.appCheckHeaderName: appCheckToken,
              },
              body: encoded,
            )
            .timeout(_timeout);

        _logDebug('Response status: ${response.statusCode}');

        if (response.statusCode == 200) {
          return _parseSuccess(response.body);
        }

        // Expired token (ID token and/or App Check token): refresh both once,
        // without consuming a retry.
        if (response.statusCode == 401 && !refreshedToken) {
          refreshedToken = true;
          attempt--;
          continue;
        }

        // Retry only transient server-side problems.
        final transient = response.statusCode == 500 ||
            response.statusCode == 502 ||
            response.statusCode == 503 ||
            response.statusCode == 504;
        if (transient && attempt < _maxRetries) {
          // A long Retry-After (for example the daily global AI cap) is not
          // transient: fail fast instead of burning the per-minute limit.
          final retryAfter =
              int.tryParse(response.headers['retry-after'] ?? '');
          if (retryAfter != null && retryAfter > _maxRetryAfterSeconds) {
            throw Exception(
                _messageForStatus(response.statusCode, response.body));
          }
          lastError = Exception(getErrorMessage(response.statusCode));
          await Future<void>.delayed(retryBaseDelay * attempt);
          continue;
        }

        throw Exception(_messageForStatus(response.statusCode, response.body));
      } on async.TimeoutException {
        _logError('Timeout on attempt $attempt');
        lastError = TimeoutException(_timeout);
        if (attempt >= _maxRetries) break;
        await Future<void>.delayed(retryBaseDelay * attempt);
      } on http.ClientException catch (e) {
        _logError('Network error on attempt $attempt');
        lastError = SocketException(e.message);
        if (attempt >= _maxRetries) break;
        await Future<void>.delayed(retryBaseDelay * attempt);
      }
    }

    if (lastError is TimeoutException) {
      throw TimeoutException(_timeout,
          message: 'Request timeout: Please try again');
    }
    if (lastError is SocketException) {
      throw SocketException(
          'Network error: Please check your internet connection');
    }
    if (lastError is Exception) throw lastError;
    throw Exception('Failed to get response after $_maxRetries attempts');
  }

  /// Fetches the App Check token without ever throwing or hanging.
  static Future<String?> _appCheckTokenSafe(bool forceRefresh) async {
    try {
      final token = await appCheckTokenProvider(forceRefresh: forceRefresh)
          .timeout(BackendAuthHeaders.tokenTimeout);
      if (token == null || token.isEmpty) return null;
      return token;
    } catch (_) {
      return null;
    }
  }

  static String _parseSuccess(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map &&
          decoded['success'] == true &&
          decoded['content'] is String &&
          (decoded['content'] as String).isNotEmpty) {
        return decoded['content'] as String;
      }
    } catch (_) {
      // fall through
    }
    throw Exception('Invalid response format from AI service');
  }

  /// The short `error` text from a backend JSON error body, or null.
  static String? _serverError(String body) {
    try {
      final decoded = jsonDecode(body);
      final err = decoded is Map ? decoded['error']?.toString() : null;
      if (err != null && err.isNotEmpty && err.length < 200) return err;
    } catch (_) {}
    return null;
  }

  /// Maps backend status codes to user-safe messages. Never echoes the
  /// response body to the UI (it may contain provider details).
  static String _messageForStatus(int status, String body) {
    switch (status) {
      case 400:
        // Backend 400s carry short, safe validation messages.
        final err = _serverError(body);
        if (err != null) return err;
        return getErrorMessage(400);
      case 401:
        return 'Your session or app verification has expired. '
            'Please sign in again or update the app.';
      case 429:
        // The backend's own daily-quota text is short and safe to show.
        final err = _serverError(body);
        if (err != null && err.startsWith('Daily AI request limit')) {
          return err;
        }
        return 'Rate limit exceeded: Too many requests. '
            'Please wait a moment and try again.';
      case 503:
        return 'AI service is busy or not configured. Please try again later.';
      default:
        return getErrorMessage(status);
    }
  }

  // ────────────────────────────────────────────────────────────
  // REQUEST BUILDING
  // ────────────────────────────────────────────────────────────

  static List<Map<String, String>> _composeMessages(
    String message,
    List<Map<String, String>> history,
  ) {
    final msgs = <Map<String, String>>[];
    for (final m in history) {
      final role = m['role'] == 'assistant' ? 'assistant' : 'user';
      var content = (m['content'] ?? '').trim();
      if (content.isEmpty) continue;
      if (content.length > _maxContentChars) {
        content = content.substring(0, _maxContentChars);
      }
      msgs.add(<String, String>{'role': role, 'content': content});
    }

    var current = message.trim();
    if (current.length > _maxContentChars) {
      current = current.substring(0, _maxContentChars);
    }

    // MentorScreen already adds the user message to history; do not
    // send it twice.
    final last = msgs.isEmpty ? null : msgs.last;
    if (last == null || last['role'] != 'user' || last['content'] != current) {
      msgs.add(<String, String>{'role': 'user', 'content': current});
    }

    while (msgs.length > _maxHistoryMessages) {
      msgs.removeAt(0);
    }
    while (msgs.isNotEmpty && msgs.first['role'] != 'user') {
      msgs.removeAt(0);
    }
    return msgs;
  }

  /// Keeps the NEWEST messages that fit the backend's total-size limit
  /// (system prompt + all messages). Older messages are dropped first; the
  /// newest message is truncated if it alone is too long. The result always
  /// starts with a user message.
  static List<Map<String, String>> _fitToBudget(
    String system,
    List<Map<String, String>> messages,
  ) {
    var budget = _maxTotalChars - system.length;
    if (budget < 1000) budget = 1000;

    final kept = <Map<String, String>>[];
    var used = 0;
    for (var i = messages.length - 1; i >= 0; i--) {
      final role = messages[i]['role'] == 'assistant' ? 'assistant' : 'user';
      var content = messages[i]['content'] ?? '';
      if (kept.isEmpty && content.length > budget) {
        content = content.substring(0, budget);
      }
      if (used + content.length > budget) break;
      kept.insert(0, <String, String>{'role': role, 'content': content});
      used += content.length;
    }
    while (kept.isNotEmpty && kept.first['role'] != 'user') {
      kept.removeAt(0);
    }
    if (kept.isNotEmpty) return kept;

    // Nothing fit (should not happen): send only the newest message, cut to
    // the budget, as a user message.
    var fallback = messages.last['content'] ?? '';
    if (fallback.length > budget) fallback = fallback.substring(0, budget);
    return <Map<String, String>>[
      <String, String>{'role': 'user', 'content': fallback},
    ];
  }

  // ────────────────────────────────────────────────────────────
  // ERROR HANDLING
  // ────────────────────────────────────────────────────────────

  static String _handleError(Object error) {
    if (error is SocketException) {
      return 'Network error: ${error.message}. Check your internet connection.';
    } else if (error is TimeoutException) {
      return 'Request timeout: The server took too long to respond.';
    } else if (error is FormatException) {
      return 'Invalid response format from server.';
    } else if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    } else {
      return error.toString();
    }
  }

  // ────────────────────────────────────────────────────────────
  // CONVERSATION MANAGEMENT
  // ────────────────────────────────────────────────────────────

  static Map<String, String> createUserMessage(String content) {
    return {'role': 'user', 'content': content.trim()};
  }

  static Map<String, String> createAssistantMessage(String content) {
    return {'role': 'assistant', 'content': content.trim()};
  }

  static List<Map<String, String>> clearHistory() {
    _logDebug('Conversation history cleared');
    return [];
  }

  static String getHistorySummary(List<Map<String, String>> history) {
    final userMessages = history
        .where((msg) => msg['role'] == 'user')
        .map((msg) => msg['content'] ?? '')
        .toList();
    return 'Messages: ${userMessages.length}';
  }

  // ────────────────────────────────────────────────────────────
  // QUICK QUESTIONS
  // ────────────────────────────────────────────────────────────

  static List<String> getQuickQuestions() {
    return [
      'Best AI career in 2025?',
      'How to become a Data Scientist?',
      'Skills needed for ML Engineer?',
      'AI salary expectations in India?',
      'How to get my first AI job?',
      'Best AI courses for beginners?',
      'What is prompt engineering?',
      'Top AI tools to learn?',
      'Interview preparation tips?',
      'How to build AI portfolio?',
    ];
  }

  // ────────────────────────────────────────────────────────────
  // VALIDATION
  // ────────────────────────────────────────────────────────────

  /// Kept for backward compatibility with MentorScreen.
  /// There is no API key in the app any more; this returns true when the
  /// secure backend URL is configured.
  static bool validateApiKey() => isBackendConfigured;

  static bool isValidMessage(String message) {
    return message.trim().isNotEmpty && message.length < 4000;
  }

  static String getErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request: Invalid input provided';
      case 401:
        return 'Authentication failed: Please sign in again';
      case 403:
        return 'Forbidden: Access denied';
      case 429:
        return 'Rate limited: Too many requests, please wait';
      case 500:
        return 'Server error: AI service is having issues';
      case 502:
      case 504:
        return 'AI service is temporarily unavailable. Please try again later.';
      case 503:
        return 'Service unavailable: Please try again later';
      default:
        return 'Unknown error (Code: $statusCode)';
    }
  }

  // ────────────────────────────────────────────────────────────
  // LOGGING & DEBUG (never logs message content, tokens or keys)
  // ────────────────────────────────────────────────────────────

  static void _logDebug(String message) {
    if (kDebugMode) {
      debugPrint('🤖 ClaudeService: $message');
    }
  }

  static void _logError(String message) {
    if (kDebugMode) {
      debugPrint('❌ ClaudeService Error: $message');
    }
  }

  // ────────────────────────────────────────────────────────────
  // FORMATTING HELPERS
  // ────────────────────────────────────────────────────────────

  static String formatResponse(String response) {
    return response.trim().replaceAll(RegExp(r'\n\s*\n'), '\n\n');
  }

  static int getResponseLength(String response) {
    return response.length;
  }

  static bool isResponseIncomplete(String response) {
    return response.length < 20;
  }

  // ────────────────────────────────────────────────────────────
  // ADVANCED FEATURES
  // ────────────────────────────────────────────────────────────

  static int getComplexityScore(String message) {
    final words = message.split(' ').length;
    if (words > 50) return 3; // Complex
    if (words > 20) return 2; // Medium
    return 1; // Simple
  }

  static double getRecommendedTemperature(String message) {
    if (message.contains('?')) {
      return 0.7;
    }
    if (message.contains('creative') || message.contains('idea')) {
      return 0.9;
    }
    if (message.contains('resume') || message.contains('interview')) {
      return 0.5;
    }
    return 0.7;
  }

  static int estimateTokenCount(String text) {
    return (text.length / 4).ceil();
  }

  static bool shouldAddFollowUp(String response) {
    return response.length > 100 && response.length < 500;
  }
}

// ────────────────────────────────────────────────────────────
// EXCEPTION TYPES (kept: MentorScreen catches these by name)
// ────────────────────────────────────────────────────────────

class SocketException implements Exception {
  final String message;

  SocketException(this.message);

  @override
  String toString() => 'SocketException: $message';
}

class TimeoutException implements Exception {
  final String message;
  final Duration timeout;

  TimeoutException(this.timeout, {this.message = 'Operation timed out'});

  @override
  String toString() =>
      'TimeoutException: $message (${timeout.inSeconds} seconds)';
}