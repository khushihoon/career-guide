// ══════════════════════════════════════════════════════════════════════════════
// lib/features/copilot/services/copilot_ai_service.dart
// Uses the same Claude API key as the existing ClaudeService.
// Generates: skill gap analysis, personalized roadmap, daily goals.
// ══════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/copilot_models.dart';

class CopilotAIService {
  static const _url = 'https://api.anthropic.com/v1/messages';
  static const _model = 'claude-sonnet-4-20250514';

  static String get _key {
    final k = dotenv.env['ANTHROPIC_API_KEY'];
    if (k == null || k.isEmpty)
      throw Exception('ANTHROPIC_API_KEY not set in .env');
    return k;
  }

  // ── Core request ───────────────────────────────────────────────────────────

  static Future<String> _ask(String system, String user) async {
    final res = await http
        .post(
          Uri.parse(_url),
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': _key,
            'anthropic-version': '2023-06-01',
          },
          body: jsonEncode({
            'model': _model,
            'max_tokens': 2048,
            'system': system,
            'messages': [
              {'role': 'user', 'content': user},
            ],
          }),
        )
        .timeout(const Duration(seconds: 45));

    if (res.statusCode != 200) {
      throw Exception('Claude API ${res.statusCode}: ${res.body}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final content = data['content'] as List<dynamic>;
    return (content.first as Map<String, dynamic>)['text'] as String;
  }

  // ── Strip markdown fences so we can jsonDecode cleanly ─────────────────────

  static String _cleanJson(String raw) {
    final fence = RegExp(r'```(?:json)?\s*([\s\S]*?)```');
    final m = fence.firstMatch(raw);
    if (m != null) return m.group(1)!.trim();
    final a = raw.indexOf('[');
    final b = raw.indexOf('{');
    if (a == -1 && b == -1) return raw.trim();
    final idx = (a == -1)
        ? b
        : (b == -1)
            ? a
            : (a < b ? a : b);
    return raw.substring(idx).trim();
  }

  // ── 1. Skill Gap Analysis ──────────────────────────────────────────────────

  static Future<List<SkillGap>> analyseSkillGaps(
      UserSkillProfile profile) async {
    const system = '''
You are an expert AI career coach. Analyse skill gaps for the user's target role.
RESPOND ONLY WITH A VALID JSON ARRAY. No preamble, no explanation, no markdown.
Each item must have these exact keys:
  "skillName": string
  "requiredLevel": "beginner" | "intermediate" | "advanced" | "expert"
  "currentLevel": null | "beginner" | "intermediate" | "advanced" | "expert"
  "priority": 1 | 2 | 3   (1=critical, 2=important, 3=nice-to-have)
  "reason": string (one sentence, max 12 words)
Return 6–9 gaps, ordered by priority ascending (most critical first).
currentLevel null means the user does not have the skill at all.
''';

    final skillsSummary = profile.skills.isEmpty
        ? 'None'
        : profile.skills.map((s) => '${s.name} (${s.level.label})').join(', ');

    final user = '''
Target Role: ${profile.targetRole.label}
Current Role: ${profile.currentRole}
Experience: ${profile.experienceMonths} months
Current Skills: $skillsSummary
''';

    final raw = await _ask(system, user);
    final list = jsonDecode(_cleanJson(raw)) as List<dynamic>;
    return list
        .map((e) => SkillGap.fromFirestore(e as Map<String, dynamic>))
        .toList();
  }

  // ── 2. Generate Personalized Roadmap ──────────────────────────────────────

  static Future<PersonalizedRoadmap> generateRoadmap(
      UserSkillProfile profile, List<SkillGap> gaps) async {
    const system = '''
You are an expert AI career coach. Build a 5-phase personalised learning roadmap.
RESPOND ONLY WITH A VALID JSON ARRAY OF 5 PHASE OBJECTS. No markdown, no preamble.
Each phase must have exactly these keys:
  "phaseNumber": 0-indexed integer (0 to 4)
  "title": string (short, e.g. "Python & Math Foundations")
  "description": string (1–2 sentences)
  "skills": [string, ...]   (3–5 skills)
  "resources": array of 2–3 objects, each with:
      "title": string, "platform": string, "url": string,
      "isFree": boolean, "duration": string, "icon": single emoji
  "estimatedDuration": string (e.g. "3 weeks")
  "isCompleted": false
  "isUnlocked": false
Phase 0 isUnlocked must be true.
Use real, well-known Indian-market resources (Coursera, YouTube, Udemy, Fast.ai, DeepLearning.AI).
''';

    final gapSummary = gaps
        .take(6)
        .map((g) =>
            '${g.skillName}: need ${g.requiredLevel.label}, has ${g.currentLevel?.label ?? "none"} (p${g.priority})')
        .join('\n');

    final user = '''
Target Role: ${profile.targetRole.label}
Current Role: ${profile.currentRole}
Experience: ${profile.experienceMonths} months
Current Skills: ${profile.skillNames.join(', ')}

Top Skill Gaps:
$gapSummary
''';

    final raw = await _ask(system, user);
    final list = jsonDecode(_cleanJson(raw)) as List<dynamic>;
    final phases = list
        .map((e) => RoadmapPhase.fromFirestore(e as Map<String, dynamic>))
        .toList();

    return PersonalizedRoadmap(
      uid: profile.uid,
      targetRole: profile.targetRole,
      phases: phases,
      currentPhaseIndex: 0,
      generatedAt: DateTime.now(),
    );
  }

  // ── 3. Generate Daily Goals ────────────────────────────────────────────────

  static Future<List<DailyGoal>> generateDailyGoals(UserSkillProfile profile,
      PersonalizedRoadmap roadmap, List<SkillGap> gaps) async {
    const system = '''
You are an AI career coach. Create 4 actionable daily goals.
RESPOND ONLY WITH A VALID JSON ARRAY OF 4 OBJECTS. No markdown, no preamble.
Each object must have exactly:
  "title": string (action verb, max 60 chars, e.g. "Watch PyTorch intro lecture on YouTube")
  "category": "Learning" | "Practice" | "Networking" | "Application" | "Project"
  "xpReward": integer 10–50
  "linkedSkill": string | null
Mix: at least 1 Learning, 1 Practice, vary others.
Goals must be achievable in 30–90 minutes each.
''';

    final phase = roadmap.currentPhase;
    final phaseInfo = phase != null
        ? 'Current Phase: ${phase.title} | Skills: ${phase.skills.join(', ')}'
        : 'No active phase';
    final topGap = gaps.isNotEmpty ? gaps.first.skillName : 'Python';
    final today = DateTime.now();
    final dateKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final user = '''
Target Role: ${profile.targetRole.label}
$phaseInfo
Priority Skill Gap: $topGap
Date: $dateKey
''';

    final raw = await _ask(system, user);
    final list = jsonDecode(_cleanJson(raw)) as List<dynamic>;

    return list.asMap().entries.map((entry) {
      final item = entry.value as Map<String, dynamic>;
      return DailyGoal(
        id: '${profile.uid}_${dateKey}_${entry.key}',
        uid: profile.uid,
        title: item['title'] as String? ?? 'Study today',
        category: GoalCategoryExt.fromString(
            item['category'] as String? ?? 'Learning'),
        date: dateKey,
        isCompleted: false,
        xpReward: (item['xpReward'] as num?)?.toInt() ?? 15,
        linkedSkill: item['linkedSkill'] as String?,
      );
    }).toList();
  }
}
