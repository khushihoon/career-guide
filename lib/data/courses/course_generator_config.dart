class CourseGeneratorConfig {
  // Kitne concepts har course level mein generate honge
  static const int conceptsPerLesson = 5;

  // Har level mein kitne quiz questions honge
  static const int quizQuestionsPerLesson = 5;

  // Har level mein kitne mini challenges honge
  static const int challengesPerLesson = 2;

  // Har level ke end mein final project generate hoga
  static const bool generateFinalProject = true;

  // Quiz ke liye default XP
  static const int defaultQuizXp = 10;

  // Mini challenge ke liye default XP
  static const int defaultChallengeXp = 15;

  // Final project ke liye default XP
  static const int defaultProjectXp = 50;

  // AI ko content kis style mein banana hai
  static const String defaultTeachingStyle =
      'simple, practical, beginner-friendly and career-focused';

  // AI se structured JSON output lena hai
  static const String outputFormat = 'json';

  // ─────────────────────────────────────────────────────────────
  // CACHE SETTINGS (added for dynamic AI course generation)
  // ─────────────────────────────────────────────────────────────

  /// Whether generated courses should be cached locally so the same
  /// (careerId + level) is never re-generated unnecessarily.
  static const bool cacheEnabled = true;

  /// SharedPreferences key prefix under which each generated course's
  /// raw JSON is stored: "$cacheKeyPrefix<careerId>_level<level>"
  static const String cacheKeyPrefix = 'generated_course_';

  /// SharedPreferences key holding the list of all cached course keys,
  /// used to reload every generated course on app start.
  static const String cacheIndexKey = 'generated_course_index_v1';

  // ─────────────────────────────────────────────────────────────
  // MULTI-LESSON LEVELS (Security, Design, Emerging, Testing,
  // Specialized) — each level shows exactly this many individually
  // generated, individually cached lessons. Software Engineer, AI &
  // Data (real static lessons) and Cloud & DevOps (existing single
  // generated course per level) are unaffected by this constant.
  // ─────────────────────────────────────────────────────────────
  static const int lessonsPerDynamicLevel = 10;
}