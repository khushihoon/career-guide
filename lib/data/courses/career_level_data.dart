// ══════════════════════════════════════════════════════════════════════
// lib/data/courses/career_level_data.dart
//
// Groups the EXISTING per-level lesson lists (already used inside
// lib/models/course_content_data.dart to build allTopicCourses) into a
// Career → Levels → Lessons structure, WITHOUT touching
// course_content_data.dart and WITHOUT duplicating any lesson data.
//
// This file imports the exact same list constants course_content_data.dart
// already imports (softwareEngineeringPath, aiEngineerLevel1, etc.) — same
// source of truth, just referenced a second time to preserve the level
// boundaries that get flattened away once they're spread into
// allTopicCourses.
//
// Lesson counts (level.lessons.length) always come from these real lists,
// never a hard-coded number.
// ══════════════════════════════════════════════════════════════════════

import '../../models/course_content_data.dart';

import 'software_courses.dart';
import 'software_level_2.dart';
import 'software_level_3.dart';
import 'software_level_4.dart';
import 'software_level_5.dart';
import 'software_level_6.dart';
import 'software_level_7.dart';
import 'software_level_8.dart';
import 'software_level_9.dart';
import 'software_level_10.dart';

import 'ai_engineer_level_1.dart';
import 'ai_engineer_level_2.dart';
import 'ai_engineer_level_3.dart';
import 'ai_engineer_level_4.dart';
import 'ai_engineer_level_5.dart';
import 'ai_engineer_level_6.dart';
import 'ai_engineer_level_7.dart';
import 'ai_engineer_level_8.dart';
import 'ai_engineer_level_9.dart';
import 'ai_engineer_level_10.dart';

import 'data_scientist_level_1.dart';
import 'data_scientist_level_2.dart';
import 'data_scientist_level_3.dart';
import 'data_scientist_level_4.dart';
import 'data_scientist_level_5.dart';
import 'data_scientist_level_6.dart';
import 'data_scientist_level_7.dart';
import 'data_scientist_level_8.dart';
import 'data_scientist_level_9.dart';
import 'data_scientist_level_10.dart';

import 'llm_engineer_level_1.dart';
import 'llm_engineer_level_2.dart';
import 'llm_engineer_level_3.dart';
import 'llm_engineer_level_4.dart';
import 'llm_engineer_level_5.dart';
import 'llm_engineer_level_6.dart';
import 'llm_engineer_level_7.dart';
import 'llm_engineer_level_8.dart';
import 'llm_engineer_level_9.dart';
import 'llm_engineer_level_10.dart';
import 'llm_engineer_level_11.dart';

import 'computer_vision_engineer_level1.dart';
import 'computer_vision_engineer_level2.dart';
import 'computer_vision_engineer_level3.dart';
import 'computer_vision_engineer_level4.dart';
import 'computer_vision_engineer_level5.dart';
import 'computer_vision_engineer_level6.dart';
import 'computer_vision_engineer_level7.dart';
import 'computer_vision_engineer_level8.dart';
import 'computer_vision_engineer_level9.dart';
import 'computer_vision_engineer_level10.dart';
import 'computer_vision_engineer_level11.dart';

// ── Claude Engineer (Cloud & DevOps) — added so this career uses its
//    EXISTING, already-authored per-level lesson files instead of falling
//    back to the AI-generated/dynamic career path. ─────────────────────
import 'claude_engineer_level1.dart';
import 'claude_engineer_level2.dart';
import 'claude_engineer_level3.dart';
import 'claude_engineer_level4.dart';
import 'claude_engineer_level5.dart';
import 'claude_engineer_level6.dart';
import 'claude_engineer_level7.dart';
import 'claude_engineer_level8.dart';
import 'claude_engineer_level9.dart';
import 'claude_engineer_level10.dart';

/// One level's worth of REAL lessons for a static career.
class CareerLevelGroup {
  final int level;
  final String levelTitle;
  final List<TopicCourse> lessons;

  const CareerLevelGroup({
    required this.level,
    required this.levelTitle,
    required this.lessons,
  });
}

/// A fully-static career path (all lesson content already exists —
/// nothing here is ever AI-generated).
class StaticCareerPath {
  final String careerId;
  final String careerTitle;
  final String categoryId;
  final String emoji;
  final List<CareerLevelGroup> levels;

  const StaticCareerPath({
    required this.careerId,
    required this.careerTitle,
    required this.categoryId,
    required this.emoji,
    required this.levels,
  });

  int get totalLessons => levels.fold(0, (sum, l) => sum + l.lessons.length);
}

/// Builds level groups from an ordered list of the real per-level lists.
/// Level numbers are derived from position (index + 1) — never hard-coded.
List<CareerLevelGroup> _levels(List<List<TopicCourse>> perLevelLessons) {
  return [
    for (var i = 0; i < perLevelLessons.length; i++)
      CareerLevelGroup(
        level: i + 1,
        levelTitle: 'Level ${i + 1}',
        lessons: perLevelLessons[i],
      ),
  ];
}

/// Every static, fully-authored career path, grouped by real level data.
/// careerId values match what the existing career-card UI already uses
/// (ai_engineer, data_scientist, llm_engineer, computer_vision_engineer,
/// claude_engineer) so wiring this in requires no change to those IDs.
final List<StaticCareerPath> staticCareerPaths = [
  StaticCareerPath(
    careerId: 'software_engineer',
    careerTitle: 'Software Engineer',
    categoryId: 'software_dev',
    emoji: '💻',
    levels: _levels([
      softwareEngineeringPath,
      softwareCoursesLevel2,
      softwareCoursesLevel3,
      softwareCoursesLevel4,
      softwareCoursesLevel5,
      softwareCoursesLevel6,
      softwareCoursesLevel7,
      softwareCoursesLevel8,
      softwareCoursesLevel9,
      softwareCoursesLevel10,
    ]),
  ),
  StaticCareerPath(
    careerId: 'ai_engineer',
    careerTitle: 'AI Engineer',
    categoryId: 'ai_data',
    emoji: '🤖',
    levels: _levels([
      aiEngineerLevel1,
      aiEngineerLevel2,
      aiEngineerLevel3,
      aiEngineerLevel4,
      aiEngineerLevel5,
      aiEngineerLevel6,
      aiEngineerLevel7,
      aiEngineerLevel8,
      aiEngineerLevel9,
      aiEngineerLevel10,
    ]),
  ),
  StaticCareerPath(
    careerId: 'data_scientist',
    careerTitle: 'Data Scientist',
    categoryId: 'ai_data',
    emoji: '📊',
    levels: _levels([
      dataScientistLevel1,
      dataScientistLevel2,
      dataScientistLevel3,
      dataScientistLevel4,
      dataScientistLevel5,
      dataScientistLevel6,
      dataScientistLevel7,
      dataScientistLevel8,
      dataScientistLevel9,
      dataScientistLevel10,
    ]),
  ),
  StaticCareerPath(
    careerId: 'llm_engineer',
    careerTitle: 'LLM Engineer',
    categoryId: 'ai_data',
    emoji: '🧠',
    levels: _levels([
      llmEngineerLevel1,
      llmEngineerLevel2,
      llmEngineerLevel3,
      llmEngineerLevel4,
      llmEngineerLevel5,
      llmEngineerLevel6,
      llmEngineerLevel7,
      llmEngineerLevel8,
      llmEngineerLevel9,
      llmEngineerLevel10,
      llmEngineerLevel11,
    ]),
  ),
  StaticCareerPath(
    careerId: 'computer_vision_engineer',
    careerTitle: 'Computer Vision Engineer',
    categoryId: 'ai_data',
    emoji: '👁️',
    levels: _levels([
      computerVisionEngineerLevel1,
      computerVisionEngineerLevel2,
      computerVisionEngineerLevel3,
      computerVisionEngineerLevel4,
      computerVisionEngineerLevel5,
      computerVisionEngineerLevel6,
      computerVisionEngineerLevel7,
      computerVisionEngineerLevel8,
      computerVisionEngineerLevel9,
      computerVisionEngineerLevel10,
      computerVisionEngineerLevel11,
    ]),
  ),
  // ── FIX: Claude Engineer now registered as a static career so it shows
  //    its real, already-authored Level 1–10 lessons (from
  //    claude_engineer_level1.dart … claude_engineer_level10.dart)
  //    instead of being treated as an AI-generated/dynamic career path.
  //    Category left as-is: Cloud & DevOps ('cloud_devops').
  StaticCareerPath(
    careerId: 'claude_engineer',
    careerTitle: 'Claude Engineer',
    categoryId: 'cloud_devops',
    emoji: '🧩',
    levels: _levels([
      claudeEngineerLevel1,
      claudeEngineerLevel2,
      claudeEngineerLevel3,
      claudeEngineerLevel4,
      claudeEngineerLevel5,
      claudeEngineerLevel6,
      claudeEngineerLevel7,
      claudeEngineerLevel8,
      claudeEngineerLevel9,
      claudeEngineerLevel10,
    ]),
  ),
];

/// Lookup helper — returns null if careerId isn't a static career
/// (e.g. it's one of the AI-generated careers instead).
StaticCareerPath? findStaticCareer(String careerId) {
  for (final c in staticCareerPaths) {
    if (c.careerId == careerId) return c;
  }
  return null;
}
