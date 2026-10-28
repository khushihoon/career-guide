// ══════════════════════════════════════════════════════════════════════
// lib/widgets/resource_card.dart
//
// Interactive Resource Cards for Roadmap Phases.
//
// BACKWARD COMPATIBLE — works with existing plain-text resource strings.
// No changes required to any roadmap data files.
//
// Usage (drop-in replacement for the old text loop):
//
//   ResourceCardList(resources: p.resources)
//
// That's it. Pass the existing List<String> and it handles everything.
//
// Smart parser converts strings like:
//   '📘 CS50P — Harvard Python (free)'    → course card
//   '🎬 3Blue1Brown (YouTube)'             → video card
//   '📘 Python.org Official Tutorial'      → documentation card
//   '🏋️ LeetCode Easy — 30 problems'      → practice card
//   '🏆 Kaggle Learn ML (free)'            → course card
//   '📄 Eugene Yan Blog'                   → article card
//   '🐙 GitHub — repo name'               → github card
//
// Future-ready: also accepts RoadmapResource objects directly.
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

// ──────────────────────────────────────────────────────────────────────
// RESOURCE TYPE
// ──────────────────────────────────────────────────────────────────────

enum ResourceType { course, documentation, practice, video, article, github }

extension ResourceTypeX on ResourceType {
  String get label {
    switch (this) {
      case ResourceType.course:
        return 'Course';
      case ResourceType.documentation:
        return 'Docs';
      case ResourceType.practice:
        return 'Practice';
      case ResourceType.video:
        return 'Video';
      case ResourceType.article:
        return 'Article';
      case ResourceType.github:
        return 'GitHub';
    }
  }

  String get emoji {
    switch (this) {
      case ResourceType.course:
        return '🎓';
      case ResourceType.documentation:
        return '📖';
      case ResourceType.practice:
        return '💻';
      case ResourceType.video:
        return '🎥';
      case ResourceType.article:
        return '📄';
      case ResourceType.github:
        return '🐙';
    }
  }

  Color get color {
    switch (this) {
      case ResourceType.course:
        return const Color(0xFF7C3AED);
      case ResourceType.documentation:
        return const Color(0xFF60A5FA);
      case ResourceType.practice:
        return const Color(0xFF4ADE80);
      case ResourceType.video:
        return const Color(0xFFEF4444);
      case ResourceType.article:
        return const Color(0xFFF59E0B);
      case ResourceType.github:
        return const Color(0xFF888899);
    }
  }
}

// ──────────────────────────────────────────────────────────────────────
// RESOURCE MODEL  (future-ready: add description, duration etc. later)
// ──────────────────────────────────────────────────────────────────────

class RoadmapResource {
  final String title;
  final ResourceType type;
  final String? url; // optional — shown as "Open Resource"
  final String? description; // optional — shown below title

  const RoadmapResource({
    required this.title,
    required this.type,
    this.url,
    this.description,
  });
}

// ──────────────────────────────────────────────────────────────────────
// SMART PARSER
// Converts existing plain-text resource strings into RoadmapResource.
// Rules match the emoji patterns used across all roadmap data files.
// ──────────────────────────────────────────────────────────────────────

class _ResourceParser {
  // URL map for well-known resources (avoids hard-coding URLs in data)
  static const _urlMap = <String, String>{
    // Courses & platforms
    'coursera': 'https://coursera.org',
    'cs50': 'https://cs50.harvard.edu',
    'cs50p': 'https://cs50.harvard.edu/python',
    'fast.ai': 'https://course.fast.ai',
    'huggingface': 'https://huggingface.co/learn',
    'kaggle learn': 'https://kaggle.com/learn',
    'kaggle': 'https://kaggle.com',
    'deeplearning.ai': 'https://deeplearning.ai',
    'andrew ng':
        'https://coursera.org/specializations/machine-learning-introduction',
    'ml specialization':
        'https://coursera.org/specializations/machine-learning-introduction',
    'deep learning specialization':
        'https://coursera.org/specializations/deep-learning',
    'udemy': 'https://udemy.com',
    'pluralsight': 'https://pluralsight.com',
    'egghead': 'https://egghead.io',
    'frontendmasters': 'https://frontendmasters.com',
    'fullstackdeeplearning': 'https://fullstackdeeplearning.com',
    'datatalks': 'https://github.com/DataTalksClub',
    'made with ml': 'https://madewithml.com',
    'the construct': 'https://theconstructsim.com',
    'neetcode': 'https://neetcode.io',
    'educative': 'https://educative.io',
    'scrimba': 'https://scrimba.com',
    'codecademy': 'https://codecademy.com',
    'freecodecamp': 'https://freecodecamp.org',
    'the odin project': 'https://theodinproject.com',
    'testautomationu': 'https://testautomationu.applitools.com',
    'linux journey': 'https://linuxjourney.com',
    'kodekloud': 'https://kodekloud.com',
    'a cloud guru': 'https://acloudguru.com',
    // Practice
    'leetcode': 'https://leetcode.com',
    'hackerrank': 'https://hackerrank.com',
    'codeforces': 'https://codeforces.com',
    'exercism': 'https://exercism.org',
    'codewars': 'https://codewars.com',
    'frontend mentor': 'https://frontendmentor.io',
    'greatfrontend': 'https://greatfrontend.com',
    'portswigger': 'https://portswigger.net/web-security',
    'tryhackme': 'https://tryhackme.com',
    'hackthebox': 'https://hackthebox.com',
    'blueteamlabs': 'https://blueteamlabsonline.com',
    'letsdefend': 'https://letsdefend.io',
    'pentesterlab': 'https://pentesterlab.com',
    'pwn.college': 'https://pwn.college',
    // Documentation
    'python.org': 'https://docs.python.org',
    'mdn': 'https://developer.mozilla.org',
    'react docs': 'https://react.dev',
    'react.dev': 'https://react.dev',
    'flutter docs': 'https://docs.flutter.dev',
    'flutter.dev': 'https://flutter.dev',
    'dart.dev': 'https://dart.dev/guides',
    'typescript handbook': 'https://typescriptlang.org/docs/handbook',
    'docker docs': 'https://docs.docker.com',
    'kubernetes docs': 'https://kubernetes.io/docs',
    'terraform docs': 'https://developer.hashicorp.com/terraform/docs',
    'fastapi docs': 'https://fastapi.tiangolo.com',
    'next.js docs': 'https://nextjs.org/docs',
    'tailwind': 'https://tailwindcss.com/docs',
    'express': 'https://expressjs.com',
    'node.js docs': 'https://nodejs.org/en/docs',
    'postgresql': 'https://postgresql.org/docs',
    'mongodb university': 'https://university.mongodb.com',
    'playwright docs': 'https://playwright.dev/docs',
    'selenium docs': 'https://selenium.dev/documentation',
    'ros 2 docs': 'https://docs.ros.org',
    'ethereum': 'https://ethereum.org/en/developers',
    'solidity docs': 'https://docs.soliditylang.org',
    'riverpod': 'https://riverpod.dev',
    'riverpod.dev': 'https://riverpod.dev',
    'mlflow docs': 'https://mlflow.org/docs',
    'openai': 'https://platform.openai.com/docs',
    'anthropic': 'https://docs.anthropic.com',
    'langchain': 'https://python.langchain.com/docs',
    'aws': 'https://docs.aws.amazon.com',
    // Video channels
    'youtube': 'https://youtube.com',
    '3blue1brown': 'https://youtube.com/@3blue1brown',
    'statquest': 'https://youtube.com/@statquest',
    'fireship': 'https://youtube.com/@Fireship',
    'traversy media': 'https://youtube.com/@TraversyMedia',
    'kevin powell': 'https://youtube.com/@KevinPowell',
    'neetcode.io': 'https://neetcode.io',
    'andrej karpathy': 'https://youtube.com/@AndrejKarpathy',
    'yannic kilcher': 'https://youtube.com/@YannicKilcher',
    'ippse': 'https://youtube.com/@ippsec',
    'brackeys': 'https://youtube.com/@Brackeys',
    'code monkey': 'https://youtube.com/@CodeMonkeyUnity',
    'hussain nasser': 'https://youtube.com/@hnasr',
    'gaurav sen': 'https://youtube.com/@gkcs',
    // GitHub / Open source
    'github': 'https://github.com',
    'papers with code': 'https://paperswithcode.com',
    'spinning up': 'https://spinningup.openai.com',
    'ostep': 'https://pages.cs.wisc.edu/~remzi/OSTEP/',
    'pro git': 'https://git-scm.com/book/en/v2',
    // Articles / Blogs
    'medium': 'https://medium.com',
    'substack': 'https://substack.com',
    'towards data science': 'https://towardsdatascience.com',
    'owasp': 'https://owasp.org',
    'mitre att&ck': 'https://attack.mitre.org',
    'nist': 'https://nist.gov',
    // ✅ New mappings
    'use the index luke': 'https://use-the-index-luke.com',
    'designing data intensive applications': 'https://dataintensive.net',
    'alex xu': 'https://bytebytego.com',
    'grokking system design':
        'https://educative.io/courses/grokking-the-system-design-interview',
  };

  // Detect resource type from emoji prefix and content
  static ResourceType _detectType(String raw) {
    final lower = raw.toLowerCase();
    // Emoji-based detection (most reliable — matches your data)
    if (raw.startsWith('📘') || raw.startsWith('📙') || raw.startsWith('📗')) {
      // 📘 = book → could be course, docs, or article
      if (lower.contains('youtube') || lower.contains('youtu.be')) {
        return ResourceType.video;
      }
      if (lower.contains('docs') ||
          lower.contains('.org') ||
          lower.contains('manual') ||
          lower.contains('tutorial') ||
          lower.contains('official') ||
          lower.contains('guide') ||
          lower.contains('reference') ||
          lower.contains('handbook')) {
        return ResourceType.documentation;
      }
      if (lower.contains('github') || lower.contains('github.com')) {
        return ResourceType.github;
      }
      return ResourceType.course;
    }
    if (raw.startsWith('🎬') || raw.startsWith('🎥')) {
      return ResourceType.video;
    }
    if (raw.startsWith('🏋️') ||
        raw.startsWith('🏋') ||
        raw.startsWith('🏆') ||
        raw.startsWith('💪') ||
        raw.startsWith('⚔️')) {
      return ResourceType.practice;
    }
    if (raw.startsWith('🐙') || raw.startsWith('📦')) {
      return ResourceType.github;
    }
    if (raw.startsWith('📄') || raw.startsWith('📰') || raw.startsWith('✍️')) {
      return ResourceType.article;
    }
    if (raw.startsWith('📖')) {
      return ResourceType.documentation;
    }

    // Content-based fallback
    if (lower.contains('youtube') ||
        lower.contains('(youtube)') ||
        lower.contains('video') ||
        lower.contains('lecture')) {
      return ResourceType.video;
    }
    if (lower.contains('leetcode') ||
        lower.contains('hackerrank') ||
        lower.contains('kaggle') ||
        lower.contains('exercise') ||
        lower.contains('problem') ||
        lower.contains('challenge') ||
        lower.contains('hackthebox') ||
        lower.contains('tryhackme') ||
        lower.contains('ctf') ||
        lower.contains('competition')) {
      return ResourceType.practice;
    }
    if (lower.contains('github') || lower.contains('.github.io')) {
      return ResourceType.github;
    }
    if (lower.contains('docs') ||
        lower.contains('.org') ||
        lower.contains('official') ||
        lower.contains('documentation') ||
        lower.contains('reference') ||
        lower.contains('manual')) {
      return ResourceType.documentation;
    }
    if (lower.contains('blog') ||
        lower.contains('article') ||
        lower.contains('medium') ||
        lower.contains('substack') ||
        lower.contains('post')) {
      return ResourceType.article;
    }
    return ResourceType.course; // default
  }

  // Clean display title by removing emoji prefix
  static String _cleanTitle(String raw) {
    final stripped = raw
        .replaceAll(
            RegExp(
                r'^[\u{1F300}-\u{1FAFF}🎬🎥📘📗📙📄📖🐙🏋️🏆💪⚔️📦✍️📰🏋\s]+',
                unicode: true),
            '')
        .trim();
    // Remove "(free)" suffix — we show it differently
    return stripped
        .replaceAll(RegExp(r'\s*\(free\)\s*$', caseSensitive: false), '')
        .trim();
  }

  // Try to find a URL from the title
  static String? _resolveUrl(String raw) {
    final lower = raw.toLowerCase();
    // Sort keys by length descending so longer matches win
    final keys = _urlMap.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    for (final key in keys) {
      if (lower.contains(key)) {
        return _urlMap[key];
      }
    }
    // If it looks like a URL itself, use it
    final urlMatch = RegExp(r'https?://[^\s]+').firstMatch(raw);
    if (urlMatch != null) return urlMatch.group(0);
    return null;
  }

  // True if the string contains "(free)"
  static bool _isFree(String raw) => raw.toLowerCase().contains('(free)');

  static RoadmapResource parse(String raw) {
    return RoadmapResource(
      title: _cleanTitle(raw),
      type: _detectType(raw),
      url: _resolveUrl(raw),
      description: _isFree(raw) ? 'Free' : null,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────
// RESOURCE CARD LIST  — drop-in replacement widget
// ──────────────────────────────────────────────────────────────────────

class ResourceCardList extends StatelessWidget {
  /// Pass your existing List<String> resources — works as-is.
  final List<String> resources;

  /// Optional: pass pre-built RoadmapResource objects for future use.
  final List<RoadmapResource>? richResources;

  const ResourceCardList({
    super.key,
    required this.resources,
    this.richResources,
  });

  @override
  Widget build(BuildContext context) {
    // Merge: use richResources if provided, else parse string resources
    final List<RoadmapResource> items = richResources != null
        ? richResources!
        : resources.map(_ResourceParser.parse).toList();

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;
        return _ResourceCard(resource: item)
            .animate()
            .fadeIn(delay: Duration(milliseconds: i * 60))
            .slideX(begin: 0.05, duration: 250.ms);
      }).toList(),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────
// SINGLE RESOURCE CARD
// ──────────────────────────────────────────────────────────────────────

class _ResourceCard extends StatefulWidget {
  final RoadmapResource resource;
  const _ResourceCard({required this.resource});

  @override
  State<_ResourceCard> createState() => _ResourceCardState();
}

class _ResourceCardState extends State<_ResourceCard> {
  bool _pressed = false;

  static const _surface = Color(0xFF1A1A2E);
  static const _border = Color(0xFF2A2A40);
  static const _muted = Color(0xFF888899);

  Future<void> _launch() async {
    final url = widget.resource.url;
    String finalUrl;

    if (url == null || url.isEmpty) {
      // ✅ Google search open karo — no snackbar
      final query = Uri.encodeComponent(widget.resource.title);
      finalUrl = 'https://www.google.com/search?q=$query';
    } else {
      finalUrl = url;
    }

    try {
      final uri = Uri.parse(finalUrl);
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        // Fallback: agar open nahi ho raha to Google search
        final fallbackUri = Uri.parse(
            'https://www.google.com/search?q=${Uri.encodeComponent(widget.resource.title)}');
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (mounted) {
        // Fallback: Google search
        final fallbackUri = Uri.parse(
            'https://www.google.com/search?q=${Uri.encodeComponent(widget.resource.title)}');
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = widget.resource;
    final color = res.type.color;
    final hasUrl = res.url != null && res.url!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          _launch();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          transform: Matrix4.identity()..scale(_pressed ? 0.975 : 1.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _pressed ? color.withOpacity(0.10) : _surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _pressed ? color.withOpacity(0.4) : _border,
                width: _pressed ? 1.2 : 1,
              ),
            ),
            child: Row(
              children: [
                // ── Type icon bubble ────────────────────────────────
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withOpacity(0.25)),
                  ),
                  child: Center(
                    child: Text(
                      res.type.emoji,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // ── Title + type badge ──────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        res.title,
                        style: TextStyle(
                          color: _pressed ? color : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          // Type badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              res.type.label,
                              style: TextStyle(
                                color: color,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // Free badge
                          if (res.description == 'Free') ...[
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFF4ADE80).withOpacity(0.10),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Free',
                                style: TextStyle(
                                  color: Color(0xFF4ADE80),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Action area ─────────────────────────────────────
                if (hasUrl) ...[
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      Icon(
                        // ✅ const hatao
                        Icons.open_in_new,
                        color: color.withOpacity(0.7),
                        size: 15,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Open',
                        style: TextStyle(
                          color: color.withOpacity(0.7),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.search,
                    color: _muted,
                    size: 15,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
