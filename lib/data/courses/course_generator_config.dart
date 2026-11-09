// lib/data/courses/course_generator_config.dart
//
// Settings for course generation. Pure Dart (no Flutter imports) so the
// optional backend can import it too.

class CourseGeneratorConfig {
  // How many concepts each generated lesson has.
  static const int conceptsPerLesson = 5;

  // How many quiz questions each generated lesson has.
  static const int quizQuestionsPerLesson = 5;

  // How many mini challenges each generated lesson has.
  static const int challengesPerLesson = 2;

  // Every generated lesson ends with a final project.
  static const bool generateFinalProject = true;

  static const int defaultQuizXp = 10;
  static const int defaultChallengeXp = 15;
  static const int defaultProjectXp = 50;

  static const String defaultTeachingStyle =
      'simple, practical, beginner-friendly and career-focused';

  static const String outputFormat = 'json';

  // ── Cache settings ────────────────────────────────────────────
  static const bool cacheEnabled = true;
  static const String cacheKeyPrefix = 'generated_course_';
  static const String cacheIndexKey = 'generated_course_index_v1';

  // ── Multi-lesson levels ───────────────────────────────────────
  // Security, Design, Emerging, Testing and Specialized levels show
  // exactly this many lessons.
  static const int lessonsPerDynamicLevel = 10;

  // ── NEW: optional backend ─────────────────────────────────────
  // The app now generates courses on the device (free, offline).
  // A backend is OPTIONAL. To use one, run the app with:
  //   flutter run --dart-define=COURSE_BACKEND_URL=https://your-server
  // Leave it empty (default) to use only the built-in generator.
  static const String backendBaseUrl =
      String.fromEnvironment('COURSE_BACKEND_URL', defaultValue: '');

  // How long to wait for the optional backend before falling back.
  static const int backendTimeoutSeconds = 25;

  // Lesson-count limits (must match the backend).
  static const int minLessonCount = 1;
  static const int maxLessonCount = 50;

  // ── Cache / content versioning ────────────────────────────────
  /// Version of the LOCALLY generated content (local_curriculum.dart plus
  /// the templates in local_course_generator.dart). BUMP THIS NUMBER every
  /// time you edit either file. Cached local courses and lesson lists made
  /// with an older number are discarded and rebuilt; backend (real AI)
  /// content is not affected. Saved progress and XP are never touched.
  static const int localContentVersion = 1;

  /// Layout version of the cache entries themselves. Bump only if the
  /// stored metadata format in course_generator_service.dart changes.
  static const int cacheSchemaVersion = 2;

  /// A backend answer bigger than this is rejected (bytes).
  static const int maxBackendResponseBytes = 1000000;
}
