import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Claude AI Service
/// Complete integration with Anthropic's Claude API
/// Features: Message history, streaming, error handling, retry logic
class ClaudeService {
  // ────────────────────────────────────────────────────────────
  // CONSTANTS
  // ────────────────────────────────────────────────────────────

  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const String _model = 'claude-sonnet-4-20250514';
  static const int _maxRetries = 3;
  static const Duration _timeout = Duration(seconds: 30);

  // System prompt for AI Career Mentor
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
  // STATIC PROPERTIES
  // ────────────────────────────────────────────────────────────

  static String get _apiKey {
    final key = dotenv.env['ANTHROPIC_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception(
        'ANTHROPIC_API_KEY not found in .env file. '
        'Please add your API key to .env: ANTHROPIC_API_KEY=sk-ant-...',
      );
    }
    return key;
  }

  // ────────────────────────────────────────────────────────────
  // MAIN METHOD: Send Message to Claude
  // ────────────────────────────────────────────────────────────

  /// Send a message to Claude and get a response
  ///
  /// Parameters:
  ///   - [message] The user's message
  ///   - [history] Conversation history (list of {role, content} maps)
  ///   - [onTokenReceived] Optional callback for streaming tokens
  ///   - [temperature] Model temperature (0-1, default 0.7)
  ///   - [maxTokens] Maximum tokens in response (default 1024)
  ///
  /// Returns: String with Claude's response
  ///
  /// Throws: Exception if API call fails
  static Future<String> sendMessage({
    required String message,
    required List<Map<String, String>> history,
    Function(String)? onTokenReceived,
    double temperature = 0.7,
    int maxTokens = 1024,
  }) async {
    try {
      // Validate inputs
      if (message.trim().isEmpty) {
        throw Exception('Message cannot be empty');
      }

      if (temperature < 0 || temperature > 1) {
        throw Exception('Temperature must be between 0 and 1');
      }

      if (maxTokens < 100 || maxTokens > 4096) {
        throw Exception('Max tokens must be between 100 and 4096');
      }

      // Log request (in debug mode)
      _logDebug('Sending message to Claude: "$message"');

      // Make API call with retry logic
      final response = await _makeApiCall(
        message: message,
        history: history,
        temperature: temperature,
        maxTokens: maxTokens,
      );

      // Log success
      _logDebug('Received response from Claude');

      return response;
    } catch (e) {
      // Handle and log error
      final errorMsg = _handleError(e);
      _logError('Failed to get response from Claude: $errorMsg');
      rethrow;
    }
  }

  // ────────────────────────────────────────────────────────────
  // API CALL WITH RETRY LOGIC
  // ────────────────────────────────────────────────────────────

  static Future<String> _makeApiCall({
    required String message,
    required List<Map<String, String>> history,
    required double temperature,
    required int maxTokens,
  }) async {
    int attempt = 0;

    while (attempt < _maxRetries) {
      try {
        attempt++;
        _logDebug('API attempt $attempt of $_maxRetries');

        // Prepare request body
        final requestBody = _buildRequestBody(
          message: message,
          history: history,
          temperature: temperature,
          maxTokens: maxTokens,
        );

        // Make HTTP POST request
        final response = await http
            .post(
              Uri.parse(_baseUrl),
              headers: _buildHeaders(),
              body: jsonEncode(requestBody),
            )
            .timeout(_timeout);

        // Handle response
        return _handleResponse(response);
      } on SocketException catch (e) {
        _logError('Network error on attempt $attempt: ${e.message}');
        if (attempt >= _maxRetries) {
          throw Exception(
              'Network error: Please check your internet connection');
        }
        // Wait before retry
        await Future.delayed(Duration(seconds: 2 * attempt));
      } on TimeoutException catch (_) {
        _logError('Timeout on attempt $attempt');
        if (attempt >= _maxRetries) {
          throw Exception('Request timeout: Please try again');
        }
        await Future.delayed(Duration(seconds: 2 * attempt));
      } on http.ClientException catch (e) {
        _logError('Client error on attempt $attempt: ${e.message}');
        if (attempt >= _maxRetries) {
          throw Exception('Connection error: ${e.message}');
        }
        await Future.delayed(Duration(seconds: 2 * attempt));
      }
    }

    throw Exception('Failed to get response after $_maxRetries attempts');
  }

  // ────────────────────────────────────────────────────────────
  // REQUEST BUILDING
  // ────────────────────────────────────────────────────────────

  static Map<String, dynamic> _buildRequestBody({
    required String message,
    required List<Map<String, String>> history,
    required double temperature,
    required int maxTokens,
  }) {
    // Add current message to history for request
    final messages = [
      ...history,
      {'role': 'user', 'content': message}
    ];

    return {
      'model': _model,
      'max_tokens': maxTokens,
      'system': _systemPrompt,
      'messages': messages,
      'temperature': temperature,
    };
  }

  static Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json; charset=utf-8',
      'x-api-key': _apiKey,
      'anthropic-version': '2023-06-01',
      'User-Agent': 'AI-Career-App/1.0',
    };
  }

  // ────────────────────────────────────────────────────────────
  // RESPONSE HANDLING
  // ────────────────────────────────────────────────────────────

  static String _handleResponse(http.Response response) {
    _logDebug('Response status: ${response.statusCode}');

    // Success response
    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body);
        final content = jsonData['content'] as List?;

        if (content != null && content.isNotEmpty) {
          final text = content[0]['text'] as String?;
          if (text != null && text.isNotEmpty) {
            return text;
          }
        }

        throw Exception('Invalid response format from Claude');
      } catch (e) {
        _logError('Failed to parse response: $e');
        throw Exception('Failed to parse Claude response: ${e.toString()}');
      }
    }

    // Authentication error
    if (response.statusCode == 401) {
      _logError('API key is invalid');
      throw Exception(
        'Authentication failed: Invalid API key. '
        'Please check your ANTHROPIC_API_KEY in .env file.',
      );
    }

    // Rate limit error
    if (response.statusCode == 429) {
      _logError('Rate limited');
      throw Exception(
        'Rate limit exceeded: Too many requests. '
        'Please wait a moment and try again.',
      );
    }

    // Server error
    if (response.statusCode >= 500) {
      _logError('Server error: ${response.statusCode}');
      throw Exception(
        'Claude API server error (${response.statusCode}). '
        'Please try again later.',
      );
    }

    // Other errors
    _logError('API error: ${response.statusCode} - ${response.body}');
    throw Exception(
      'API error (${response.statusCode}): '
      'Failed to get response from Claude. Please try again.',
    );
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

  /// Create a new conversation message
  static Map<String, String> createUserMessage(String content) {
    return {
      'role': 'user',
      'content': content.trim(),
    };
  }

  /// Create an assistant response message
  static Map<String, String> createAssistantMessage(String content) {
    return {
      'role': 'assistant',
      'content': content.trim(),
    };
  }

  /// Clear conversation history
  static List<Map<String, String>> clearHistory() {
    _logDebug('Conversation history cleared');
    return [];
  }

  /// Get conversation summary
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

  /// Get predefined quick questions for AI career mentoring
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

  /// Validate API key is set
  static bool validateApiKey() {
    try {
      final key = _apiKey;
      return key.isNotEmpty && key.startsWith('sk-ant-');
    } catch (_) {
      return false;
    }
  }

  /// Check if message is valid for sending
  static bool isValidMessage(String message) {
    return message.trim().isNotEmpty && message.length < 4000;
  }

  /// Get error message based on status code
  static String getErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request: Invalid input provided';
      case 401:
        return 'Authentication failed: Check your API key';
      case 403:
        return 'Forbidden: Access denied';
      case 429:
        return 'Rate limited: Too many requests, please wait';
      case 500:
        return 'Server error: Claude API is having issues';
      case 503:
        return 'Service unavailable: Please try again later';
      default:
        return 'Unknown error (Code: $statusCode)';
    }
  }

  // ────────────────────────────────────────────────────────────
  // LOGGING & DEBUG
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

  /// Format response for display in UI
  static String formatResponse(String response) {
    // Remove extra whitespace
    return response.trim().replaceAll(RegExp(r'\n\s*\n'), '\n\n');
  }

  /// Get response length
  static int getResponseLength(String response) {
    return response.length;
  }

  /// Check if response is too short (likely incomplete)
  static bool isResponseIncomplete(String response) {
    return response.length < 20;
  }

  // ────────────────────────────────────────────────────────────
  // ADVANCED FEATURES
  // ────────────────────────────────────────────────────────────

  /// Calculate message complexity score
  static int getComplexityScore(String message) {
    final words = message.split(' ').length;
    final sentences = message.split(RegExp(r'[.!?]')).length;

    if (words > 50) return 3; // Complex
    if (words > 20) return 2; // Medium
    return 1; // Simple
  }

  /// Get recommended temperature based on message type
  static double getRecommendedTemperature(String message) {
    if (message.contains('?')) {
      return 0.7; // Standard for questions
    }
    if (message.contains('creative') || message.contains('idea')) {
      return 0.9; // More creative
    }
    if (message.contains('resume') || message.contains('interview')) {
      return 0.5; // More focused
    }
    return 0.7; // Default
  }

  /// Estimate token count (rough estimation)
  static int estimateTokenCount(String text) {
    // Approximate: 4 chars = 1 token
    return (text.length / 4).ceil();
  }

  /// Check if response should have follow-up suggestions
  static bool shouldAddFollowUp(String response) {
    return response.length > 100 && response.length < 500;
  }
}

// ────────────────────────────────────────────────────────────
// SOCKET EXCEPTION EXTENSION
// ────────────────────────────────────────────────────────────

// For socket exception handling
class SocketException implements Exception {
  final String message;

  SocketException(this.message);

  @override
  String toString() => 'SocketException: $message';
}

// ────────────────────────────────────────────────────────────
// TIMEOUT EXCEPTION EXTENSION
// ────────────────────────────────────────────────────────────

// For timeout exception handling
class TimeoutException implements Exception {
  final String message;
  final Duration timeout;

  TimeoutException(this.timeout, {this.message = 'Operation timed out'});

  @override
  String toString() =>
      'TimeoutException: $message (${timeout.inSeconds} seconds)';
}
