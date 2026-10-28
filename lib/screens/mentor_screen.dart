import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/claude_service.dart';

class MentorScreen extends StatefulWidget {
  const MentorScreen({super.key});

  @override
  State<MentorScreen> createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
  // Controllers
  late TextEditingController _inputController;
  late ScrollController _scrollController;

  // State
  final List<Map<String, dynamic>> _messages = [];
  final List<Map<String, String>> _conversationHistory = [];
  bool _isLoading = false;
  bool _apiKeyValid = false;

  // Quick questions
  final List<String> _quickQuestions = [
    'Best AI career in 2025?',
    'How to become a Data Scientist?',
    'Skills needed for ML Engineer?',
    'AI salary expectations in India?',
  ];

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    _scrollController = ScrollController();

    // Check API key and add initial message
    _initializeScreen();
  }

  void _initializeScreen() {
    // Validate API key
    _apiKeyValid = ClaudeService.validateApiKey();

    // Add welcome message
    _addMessage(
      text:
          "Hi! I'm Aria, your AI career mentor powered by Claude. 🤖\n\nI can help you with:\n• AI career paths & job roles\n• Required skills & learning resources\n• Salary insights for India\n• Interview & portfolio tips\n• Latest AI tools\n\nWhat would you like to know?",
      isUser: false,
      isSystem: true,
    );

    if (!_apiKeyValid) {
      _addMessage(
        text:
            '⚠️ Note: API key not configured. Please add ANTHROPIC_API_KEY to your .env file to chat with the AI mentor.',
        isUser: false,
        isWarning: true,
      );
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Add message to chat
  void _addMessage({
    required String text,
    required bool isUser,
    bool isSystem = false,
    bool isWarning = false,
  }) {
    setState(() {
      _messages.add({
        'text': text,
        'isUser': isUser,
        'isSystem': isSystem,
        'isWarning': isWarning,
        'timestamp': DateTime.now(),
      });
    });

    // Scroll to bottom
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Send message
  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Check API key
    if (!_apiKeyValid) {
      _addMessage(
        text: '⚠️ API key not configured. Please add ANTHROPIC_API_KEY to .env',
        isUser: false,
        isWarning: true,
      );
      return;
    }

    // Add user message
    _addMessage(text: message, isUser: true);

    // Add to history
    _conversationHistory.add(ClaudeService.createUserMessage(message));

    // Clear input
    _inputController.clear();

    // Show loading
    setState(() => _isLoading = true);

    try {
      // Estimate complexity
      final complexity = ClaudeService.getComplexityScore(message);
      final temperature = ClaudeService.getRecommendedTemperature(message);

      _logDebug('Message complexity: $complexity, Temperature: $temperature');

      // Get response from Claude
      final response = await ClaudeService.sendMessage(
        message: message,
        history: _conversationHistory,
        temperature: temperature,
      );

      // Format response
      final formattedResponse = ClaudeService.formatResponse(response);

      // Check if response is incomplete
      if (ClaudeService.isResponseIncomplete(response)) {
        _logError('Response seems incomplete');
      }

      // Add assistant message
      _addMessage(text: formattedResponse, isUser: false);

      // Add to history
      _conversationHistory.add(
        ClaudeService.createAssistantMessage(response),
      );

      // Show success feedback
      _showSuccessSnackBar('Response received');
    } on SocketException catch (e) {
      _handleError('Network error: ${e.message}');
    } on TimeoutException catch (_) {
      _handleError('Request timeout: Please try again');
    } catch (e) {
      _handleError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleError(String error) {
    _addMessage(
      text: '❌ Error: $error',
      isUser: false,
      isWarning: true,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4ADE80),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _logDebug(String message) {
    if (mounted) {
      print('🤖 Mentor: $message');
    }
  }

  void _logError(String message) {
    if (mounted) {
      print('❌ Mentor Error: $message');
    }
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Clear Chat?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will clear all messages and start a new conversation.',
          style: TextStyle(color: Color(0xFF888899)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.clear();
                _conversationHistory.clear();
              });
              _initializeScreen();
              Navigator.pop(context);
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0F0F1A),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aria — AI Mentor',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Powered by Claude',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF888899),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _apiKeyValid
                  ? const Color(0xFF0F2E1A)
                  : Colors.red[900]?.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor:
                      _apiKeyValid ? const Color(0xFF4ADE80) : Colors.red[700],
                ),
                const SizedBox(width: 5),
                Text(
                  _apiKeyValid ? 'Live AI' : 'No API',
                  style: TextStyle(
                    color: _apiKeyValid
                        ? const Color(0xFF4ADE80)
                        : Colors.red[700],
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _clearChat,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.refresh_outlined,
                color: const Color(0xFFA78BFA),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages area
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.smart_toy,
                          size: 64,
                          color: const Color(0xFF7C3AED).withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Start your conversation',
                          style: TextStyle(
                            color: Color(0xFF888899),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        return _buildTypingIndicator();
                      }

                      final msg = _messages[index];
                      return _buildMessageBubble(msg);
                    },
                  ),
          ),

          // Quick questions (show only at start)
          if (_messages.length <= 1 && !_isLoading)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                children: _quickQuestions.map((question) {
                  return GestureDetector(
                    onTap: () => _sendMessage(question),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF7C3AED).withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        question,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFC4B5FD),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Input area
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            decoration: const BoxDecoration(
              color: Color(0xFF0F0F1A),
              border: Border(
                top: BorderSide(
                  color: Color(0xFF1E1E2E),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF2A2A40),
                      ),
                    ),
                    child: TextField(
                      controller: _inputController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: null,
                      minLines: 1,
                      enabled: !_isLoading && _apiKeyValid,
                      onSubmitted: (value) => _sendMessage(value),
                      decoration: const InputDecoration(
                        hintText: 'Ask about AI careers...',
                        hintStyle: TextStyle(
                          color: Color(0xFF666677),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                      cursorColor: const Color(0xFF7C3AED),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    final message = _inputController.text;
                    _sendMessage(message);
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _isLoading || !_apiKeyValid
                          ? const Color(0xFF7C3AED).withOpacity(0.5)
                          : const Color(0xFF7C3AED),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final isUser = msg['isUser'] as bool;
    final text = msg['text'] as String;
    final isSystem = msg['isSystem'] as bool? ?? false;
    final isWarning = msg['isWarning'] as bool? ?? false;

    if (isSystem || isWarning) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isWarning
              ? Colors.red[900]?.withOpacity(0.2)
              : const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isWarning ? Colors.red[700]! : const Color(0xFF2A2A40),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isWarning ? Colors.red[300] : const Color(0xFFDDDDEE),
            fontSize: 13,
            height: 1.5,
          ),
        ),
      );
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.80,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF7C3AED) : const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser ? const Radius.circular(4) : null,
            bottomLeft: !isUser ? const Radius.circular(4) : null,
          ),
          border: isUser
              ? null
              : Border.all(
                  color: const Color(0xFF2A2A40),
                ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : const Color(0xFFDDDDEE),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: const Radius.circular(4),
          ),
          border: Border.all(
            color: const Color(0xFF2A2A40),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(200),
            const SizedBox(width: 4),
            _buildDot(400),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int delay) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFFA78BFA),
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .fadeIn(delay: Duration(milliseconds: delay))
        .then()
        .fadeOut();
  }
}
