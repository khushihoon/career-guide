// ══════════════════════════════════════════════════════════════════════════════
// lib/models/copilot_models.dart
// AI Career Copilot — all data models.
// Null-safe. No changes required to existing models.dart.
//
// FINAL COMPATIBILITY PASS (this revision):
//   • CareerGoal.softwareEngineer is now a first-class career value.
//     Its label, emoji, and fromString() restore it correctly from both
//     "Software Engineer" (canonical label) and "software_engineer"
//     (canonical id used by CopilotController) so persisted data written
//     by either form loads cleanly.
//   • Every other enum value, field, constructor, and Firestore
//     serialization method is byte-for-byte preserved, so old documents
//     and existing callers keep working exactly as before.
// ══════════════════════════════════════════════════════════════════════════════

// ─── Skill Level ──────────────────────────────────────────────────────────────

enum SkillLevel { beginner, intermediate, advanced, expert }

extension SkillLevelExt on SkillLevel {
  String get label {
    switch (this) {
      case SkillLevel.beginner:     return 'Beginner';
      case SkillLevel.intermediate: return 'Intermediate';
      case SkillLevel.advanced:     return 'Advanced';
      case SkillLevel.expert:       return 'Expert';
    }
  }

  int get value {
    switch (this) {
      case SkillLevel.beginner:     return 1;
      case SkillLevel.intermediate: return 2;
      case SkillLevel.advanced:     return 3;
      case SkillLevel.expert:       return 4;
    }
  }

  static SkillLevel fromString(String s) {
    switch (s.toLowerCase()) {
      case 'intermediate': return SkillLevel.intermediate;
      case 'advanced':     return SkillLevel.advanced;
      case 'expert':       return SkillLevel.expert;
      default:             return SkillLevel.beginner;
    }
  }
}

// ─── Career Goal ──────────────────────────────────────────────────────────────

enum CareerGoal {
  aiEngineer,
  mlEngineer,
  dataScientist,
  nlpEngineer,
  cvEngineer,
  promptEngineer,
  aiResearcher,
  aiProductManager,
  softwareEngineer,
}

extension CareerGoalExt on CareerGoal {
  String get label {
    switch (this) {
      case CareerGoal.aiEngineer:       return 'AI Engineer';
      case CareerGoal.mlEngineer:       return 'ML Engineer';
      case CareerGoal.dataScientist:    return 'Data Scientist';
      case CareerGoal.nlpEngineer:      return 'NLP Engineer';
      case CareerGoal.cvEngineer:       return 'CV Engineer';
      case CareerGoal.promptEngineer:   return 'Prompt Engineer';
      case CareerGoal.aiResearcher:     return 'AI Researcher';
      case CareerGoal.aiProductManager: return 'AI Product Manager';
      case CareerGoal.softwareEngineer: return 'Software Engineer';
    }
  }

  String get emoji {
    switch (this) {
      case CareerGoal.aiEngineer:       return '🤖';
      case CareerGoal.mlEngineer:       return '🧠';
      case CareerGoal.dataScientist:    return '📊';
      case CareerGoal.nlpEngineer:      return '💬';
      case CareerGoal.cvEngineer:       return '👁️';
      case CareerGoal.promptEngineer:   return '✍️';
      case CareerGoal.aiResearcher:     return '🔬';
      case CareerGoal.aiProductManager: return '🚀';
      case CareerGoal.softwareEngineer: return '💻';
    }
  }

  /// Canonical career id used by the Copilot intelligence layer
  /// (matches `CopilotController._careerIdForGoal`).
  String get careerId {
    switch (this) {
      case CareerGoal.aiEngineer:       return 'ai_engineer';
      case CareerGoal.mlEngineer:       return 'ml_engineer';
      case CareerGoal.dataScientist:    return 'data_scientist';
      case CareerGoal.nlpEngineer:      return 'llm_engineer';
      case CareerGoal.cvEngineer:       return 'cv_engineer';
      case CareerGoal.promptEngineer:   return 'prompt_engineer';
      case CareerGoal.aiResearcher:     return 'ai_researcher';
      case CareerGoal.aiProductManager: return 'ai_product_manager';
      case CareerGoal.softwareEngineer: return 'software_engineer';
    }
  }

  /// Tolerant parser for persisted career data.
  ///
  /// Accepts, in order of preference:
  ///   • the canonical label ("Software Engineer"),
  ///   • the canonical careerId ("software_engineer"),
  ///   • the enum name ("softwareEngineer").
  ///
  /// Falls back to AI Engineer only when nothing matches — preserving the
  /// previous behaviour for unknown values and old documents.
  static CareerGoal fromString(String s) {
    if (s.isEmpty) return CareerGoal.aiEngineer;
    final needle = s.trim().toLowerCase();

    for (final g in CareerGoal.values) {
      if (g.label.toLowerCase() == needle) return g;
      if (g.careerId.toLowerCase() == needle) return g;
      if (g.name.toLowerCase() == needle) return g;
    }
    return CareerGoal.aiEngineer;
  }
}

// ─── User Skill ───────────────────────────────────────────────────────────────

class UserSkill {
  final String name;
  final SkillLevel level;
  final DateTime addedAt;

  const UserSkill({
    required this.name,
    required this.level,
    required this.addedAt,
  });

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'level': level.name,
        'addedAt': addedAt.toIso8601String(),
      };

  factory UserSkill.fromFirestore(Map<String, dynamic> map) => UserSkill(
        name: map['name'] as String? ?? '',
        level: SkillLevelExt.fromString(map['level'] as String? ?? 'beginner'),
        addedAt:
            DateTime.tryParse(map['addedAt'] as String? ?? '') ?? DateTime.now(),
      );
}

// ─── User Skill Profile ───────────────────────────────────────────────────────

class UserSkillProfile {
  final String uid;
  final CareerGoal targetRole;
  final List<UserSkill> skills;
  final int experienceMonths;
  final String currentRole;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserSkillProfile({
    required this.uid,
    required this.targetRole,
    required this.skills,
    required this.experienceMonths,
    required this.currentRole,
    required this.createdAt,
    required this.updatedAt,
  });

  List<String> get skillNames => skills.map((s) => s.name).toList();

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'targetRole': targetRole.label,
        'skills': skills.map((s) => s.toFirestore()).toList(),
        'experienceMonths': experienceMonths,
        'currentRole': currentRole,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory UserSkillProfile.fromFirestore(Map<String, dynamic> map) {
    final rawSkills = map['skills'] as List<dynamic>? ?? [];
    return UserSkillProfile(
      uid: map['uid'] as String? ?? '',
      targetRole:
          CareerGoalExt.fromString(map['targetRole'] as String? ?? ''),
      skills: rawSkills
          .map((s) => UserSkill.fromFirestore(s as Map<String, dynamic>))
          .toList(),
      experienceMonths: (map['experienceMonths'] as num?)?.toInt() ?? 0,
      currentRole: map['currentRole'] as String? ?? 'Student',
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  UserSkillProfile copyWith({
    CareerGoal? targetRole,
    List<UserSkill>? skills,
    int? experienceMonths,
    String? currentRole,
  }) =>
      UserSkillProfile(
        uid: uid,
        targetRole: targetRole ?? this.targetRole,
        skills: skills ?? this.skills,
        experienceMonths: experienceMonths ?? this.experienceMonths,
        currentRole: currentRole ?? this.currentRole,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );
}

// ─── Skill Gap ────────────────────────────────────────────────────────────────

class SkillGap {
  final String skillName;
  final SkillLevel requiredLevel;
  final SkillLevel? currentLevel; // null = not learned yet
  final int priority;             // 1=critical, 2=important, 3=nice-to-have
  final String reason;

  const SkillGap({
    required this.skillName,
    required this.requiredLevel,
    this.currentLevel,
    required this.priority,
    required this.reason,
  });

  bool get isNew => currentLevel == null;

  double get gapScore {
    final req = requiredLevel.value;
    final cur = currentLevel?.value ?? 0;
    return (req - cur) / req;
  }

  String get priorityLabel {
    switch (priority) {
      case 1:  return 'Critical';
      case 2:  return 'Important';
      default: return 'Nice to have';
    }
  }

  Map<String, dynamic> toFirestore() => {
        'skillName': skillName,
        'requiredLevel': requiredLevel.name,
        'currentLevel': currentLevel?.name,
        'priority': priority,
        'reason': reason,
      };

  factory SkillGap.fromFirestore(Map<String, dynamic> map) => SkillGap(
        skillName: map['skillName'] as String? ?? '',
        requiredLevel:
            SkillLevelExt.fromString(map['requiredLevel'] as String? ?? ''),
        currentLevel: map['currentLevel'] == null
            ? null
            : SkillLevelExt.fromString(map['currentLevel'] as String),
        priority: (map['priority'] as num?)?.toInt() ?? 2,
        reason: map['reason'] as String? ?? '',
      );
}

// ─── Learning Resource ────────────────────────────────────────────────────────

class LearningResource {
  final String title;
  final String platform;
  final String url;
  final bool isFree;
  final String duration;
  final String icon;

  const LearningResource({
    required this.title,
    required this.platform,
    required this.url,
    required this.isFree,
    required this.duration,
    required this.icon,
  });

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'platform': platform,
        'url': url,
        'isFree': isFree,
        'duration': duration,
        'icon': icon,
      };

  factory LearningResource.fromFirestore(Map<String, dynamic> map) =>
      LearningResource(
        title: map['title'] as String? ?? '',
        platform: map['platform'] as String? ?? '',
        url: map['url'] as String? ?? '',
        isFree: map['isFree'] as bool? ?? true,
        duration: map['duration'] as String? ?? '',
        icon: map['icon'] as String? ?? '📚',
      );
}

// ─── Roadmap Phase ────────────────────────────────────────────────────────────

class RoadmapPhase {
  final int phaseNumber;
  final String title;
  final String description;
  final List<String> skills;
  final List<LearningResource> resources;
  final String estimatedDuration;
  bool isCompleted;
  bool isUnlocked;

  RoadmapPhase({
    required this.phaseNumber,
    required this.title,
    required this.description,
    required this.skills,
    required this.resources,
    required this.estimatedDuration,
    this.isCompleted = false,
    this.isUnlocked = false,
  });

  Map<String, dynamic> toFirestore() => {
        'phaseNumber': phaseNumber,
        'title': title,
        'description': description,
        'skills': skills,
        'resources': resources.map((r) => r.toFirestore()).toList(),
        'estimatedDuration': estimatedDuration,
        'isCompleted': isCompleted,
        'isUnlocked': isUnlocked,
      };

  factory RoadmapPhase.fromFirestore(Map<String, dynamic> map) {
    final rawRes = map['resources'] as List<dynamic>? ?? [];
    return RoadmapPhase(
      phaseNumber: (map['phaseNumber'] as num?)?.toInt() ?? 0,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      skills: List<String>.from(map['skills'] as List? ?? []),
      resources: rawRes
          .map((r) =>
              LearningResource.fromFirestore(r as Map<String, dynamic>))
          .toList(),
      estimatedDuration: map['estimatedDuration'] as String? ?? '',
      isCompleted: map['isCompleted'] as bool? ?? false,
      isUnlocked: map['isUnlocked'] as bool? ?? false,
    );
  }
}

// ─── Personalized Roadmap ─────────────────────────────────────────────────────

class PersonalizedRoadmap {
  final String uid;
  final CareerGoal targetRole;
  final List<RoadmapPhase> phases;
  final int currentPhaseIndex;
  final DateTime generatedAt;
  final DateTime? completedAt;

  const PersonalizedRoadmap({
    required this.uid,
    required this.targetRole,
    required this.phases,
    required this.currentPhaseIndex,
    required this.generatedAt,
    this.completedAt,
  });

  double get overallProgress {
    if (phases.isEmpty) return 0;
    return phases.where((p) => p.isCompleted).length / phases.length;
  }

  RoadmapPhase? get currentPhase {
    if (currentPhaseIndex >= phases.length) return null;
    return phases[currentPhaseIndex];
  }

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'targetRole': targetRole.label,
        'phases': phases.map((p) => p.toFirestore()).toList(),
        'currentPhaseIndex': currentPhaseIndex,
        'generatedAt': generatedAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
      };

  factory PersonalizedRoadmap.fromFirestore(Map<String, dynamic> map) {
    final rawPhases = map['phases'] as List<dynamic>? ?? [];
    return PersonalizedRoadmap(
      uid: map['uid'] as String? ?? '',
      targetRole:
          CareerGoalExt.fromString(map['targetRole'] as String? ?? ''),
      phases: rawPhases
          .map((p) =>
              RoadmapPhase.fromFirestore(p as Map<String, dynamic>))
          .toList(),
      currentPhaseIndex: (map['currentPhaseIndex'] as num?)?.toInt() ?? 0,
      generatedAt:
          DateTime.tryParse(map['generatedAt'] as String? ?? '') ??
              DateTime.now(),
      completedAt: map['completedAt'] == null
          ? null
          : DateTime.tryParse(map['completedAt'] as String),
    );
  }

  PersonalizedRoadmap copyWith({
    List<RoadmapPhase>? phases,
    int? currentPhaseIndex,
    DateTime? completedAt,
  }) =>
      PersonalizedRoadmap(
        uid: uid,
        targetRole: targetRole,
        phases: phases ?? this.phases,
        currentPhaseIndex: currentPhaseIndex ?? this.currentPhaseIndex,
        generatedAt: generatedAt,
        completedAt: completedAt ?? this.completedAt,
      );
}

// ─── Goal Category ────────────────────────────────────────────────────────────
// IMPORTANT: These are the canonical GoalCategory values used by DailyGoal.
// goal_content_database.dart uses LocalGoalCategory (separate enum) to avoid
// name conflicts.

enum GoalCategory { learning, practice, networking, application, project }

extension GoalCategoryExt on GoalCategory {
  String get label {
    switch (this) {
      case GoalCategory.learning:    return 'Learning';
      case GoalCategory.practice:    return 'Practice';
      case GoalCategory.networking:  return 'Networking';
      case GoalCategory.application: return 'Application';
      case GoalCategory.project:     return 'Project';
    }
  }

  String get icon {
    switch (this) {
      case GoalCategory.learning:    return '📚';
      case GoalCategory.practice:    return '💻';
      case GoalCategory.networking:  return '🤝';
      case GoalCategory.application: return '📝';
      case GoalCategory.project:     return '🚀';
    }
  }

  static GoalCategory fromString(String s) {
    return GoalCategory.values.firstWhere(
      (g) => g.label.toLowerCase() == s.toLowerCase(),
      orElse: () => GoalCategory.learning,
    );
  }
}

// ─── Daily Goal ───────────────────────────────────────────────────────────────

class DailyGoal {
  final String id;
  final String uid;
  final String title;
  final GoalCategory category;
  final String date; // yyyy-MM-dd
  bool isCompleted;
  final int xpReward;
  final String? linkedSkill;

  DailyGoal({
    required this.id,
    required this.uid,
    required this.title,
    required this.category,
    required this.date,
    this.isCompleted = false,
    required this.xpReward,
    this.linkedSkill,
  });

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'uid': uid,
        'title': title,
        'category': category.label,
        'date': date,
        'isCompleted': isCompleted,
        'xpReward': xpReward,
        'linkedSkill': linkedSkill,
      };

  factory DailyGoal.fromFirestore(Map<String, dynamic> map) => DailyGoal(
        id: map['id'] as String? ?? '',
        uid: map['uid'] as String? ?? '',
        title: map['title'] as String? ?? '',
        category:
            GoalCategoryExt.fromString(map['category'] as String? ?? ''),
        date: map['date'] as String? ?? '',
        isCompleted: map['isCompleted'] as bool? ?? false,
        xpReward: (map['xpReward'] as num?)?.toInt() ?? 10,
        linkedSkill: map['linkedSkill'] as String?,
      );

  // ── Added for LocalGoalGeneratorService compatibility ──────────────
  /// Alias so generator service can call toFirestore() as toMap()
  Map<String, dynamic> toMap() => toFirestore();

  /// Alias so generator service can call DailyGoal.fromFirestore() as fromMap()
  factory DailyGoal.fromMap(Map<String, dynamic> map) =>
      DailyGoal.fromFirestore(map);

  /// CopyWith for optimistic UI updates in CopilotController
  DailyGoal copyWith({bool? isCompleted}) => DailyGoal(
        id: id,
        uid: uid,
        title: title,
        category: category,
        date: date,
        isCompleted: isCompleted ?? this.isCompleted,
        xpReward: xpReward,
        linkedSkill: linkedSkill,
      );
}

// ─── Progress Entry ───────────────────────────────────────────────────────────

class ProgressEntry {
  final String id;
  final String uid;
  final DateTime date;
  final int xpEarned;
  final int goalsCompleted;
  final int totalGoals;
  final List<String> completedSkills;

  const ProgressEntry({
    required this.id,
    required this.uid,
    required this.date,
    required this.xpEarned,
    required this.goalsCompleted,
    required this.totalGoals,
    required this.completedSkills,
  });

  double get completionRate =>
      totalGoals == 0 ? 0 : goalsCompleted / totalGoals;

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'uid': uid,
        'date': date.toIso8601String(),
        'xpEarned': xpEarned,
        'goalsCompleted': goalsCompleted,
        'totalGoals': totalGoals,
        'completedSkills': completedSkills,
      };

  factory ProgressEntry.fromFirestore(Map<String, dynamic> map) =>
      ProgressEntry(
        id: map['id'] as String? ?? '',
        uid: map['uid'] as String? ?? '',
        date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
        xpEarned: (map['xpEarned'] as num?)?.toInt() ?? 0,
        goalsCompleted: (map['goalsCompleted'] as num?)?.toInt() ?? 0,
        totalGoals: (map['totalGoals'] as num?)?.toInt() ?? 0,
        completedSkills:
            List<String>.from(map['completedSkills'] as List? ?? []),
      );
}

// ─── Copilot State ────────────────────────────────────────────────────────────

class CopilotState {
  final UserSkillProfile? skillProfile;
  final List<SkillGap> skillGaps;
  final PersonalizedRoadmap? roadmap;
  final List<DailyGoal> todayGoals;
  final List<ProgressEntry> progressHistory;
  final bool isLoading;
  final String? error;

  const CopilotState({
    this.skillProfile,
    this.skillGaps = const [],
    this.roadmap,
    this.todayGoals = const [],
    this.progressHistory = const [],
    this.isLoading = false,
    this.error,
  });

  bool get hasProfile => skillProfile != null;
  bool get hasRoadmap  => roadmap != null;

  int get totalXp =>
      progressHistory.fold(0, (sum, e) => sum + e.xpEarned);

  int get currentStreak {
    if (progressHistory.isEmpty) return 0;
    final sorted = [...progressHistory]
      ..sort((a, b) => b.date.compareTo(a.date));
    int streak = 0;
    DateTime expected = DateTime.now();
    for (final entry in sorted) {
      final diff = expected.difference(entry.date).inDays.abs();
      if (diff <= 1 && entry.goalsCompleted > 0) {
        streak++;
        expected = entry.date.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  CopilotState copyWith({
    UserSkillProfile? skillProfile,
    List<SkillGap>? skillGaps,
    PersonalizedRoadmap? roadmap,
    List<DailyGoal>? todayGoals,
    List<ProgressEntry>? progressHistory,
    bool? isLoading,
    String? error,
  }) =>
      CopilotState(
        skillProfile: skillProfile ?? this.skillProfile,
        skillGaps: skillGaps ?? this.skillGaps,
        roadmap: roadmap ?? this.roadmap,
        todayGoals: todayGoals ?? this.todayGoals,
        progressHistory: progressHistory ?? this.progressHistory,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

// ══════════════════════════════════════════════════════════════════════════════
// ─── EVERYTHING BELOW THIS LINE IS NEW ─────────────────────────────────────────
//
// Additive-only extension of the Copilot data layer. Nothing above this line
// was modified: every existing class, field, enum, constructor, and
// toFirestore/fromFirestore pair is untouched, so all existing persisted
// Firestore documents, callers, and serialization logic keep working exactly
// as before.
//
// These new models let the Copilot reason over:
//   Selected Career + User Skills + Current Progress + Historical Progress
// without ever overwriting or resetting previously stored data. Every list
// here (history, completed ids, recommendations, actions) is designed to be
// APPENDED to by the service/controller layer, never replaced wholesale —
// callers should read the existing list, add to it, and persist the union.
//
// All new fromMap factories use safe defaults so OLD Firestore documents
// (written before this update, with none of these fields) still decode
// cleanly into sensible empty/zeroed objects instead of throwing.
// ══════════════════════════════════════════════════════════════════════════════

// ─── Career Context ─────────────────────────────────────────────────────────
// The career the Copilot is currently reasoning about. Deliberately stores
// plain strings (careerId/categoryId) rather than importing StaticCareerPath /
// GeneratedCareerPath from career_level_data.dart or dynamic_career_paths.dart,
// so this file stays fully self-contained and doesn't couple the data layer
// to the course-screen data layer.

class CareerContext {
  final String careerId;
  final String careerTitle;
  final String categoryId;
  final String emoji;
  final bool isStaticCareer; // true = real authored lessons, false = AI-generated
  final DateTime selectedAt;

  const CareerContext({
    required this.careerId,
    required this.careerTitle,
    required this.categoryId,
    required this.emoji,
    required this.isStaticCareer,
    required this.selectedAt,
  });

  Map<String, dynamic> toFirestore() => {
        'careerId': careerId,
        'careerTitle': careerTitle,
        'categoryId': categoryId,
        'emoji': emoji,
        'isStaticCareer': isStaticCareer,
        'selectedAt': selectedAt.toIso8601String(),
      };

  factory CareerContext.fromFirestore(Map<String, dynamic> map) =>
      CareerContext(
        careerId: map['careerId'] as String? ?? '',
        careerTitle: map['careerTitle'] as String? ?? '',
        categoryId: map['categoryId'] as String? ?? '',
        emoji: map['emoji'] as String? ?? '🎯',
        isStaticCareer: map['isStaticCareer'] as bool? ?? true,
        selectedAt: DateTime.tryParse(map['selectedAt'] as String? ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toMap() => toFirestore();
  factory CareerContext.fromMap(Map<String, dynamic> map) =>
      CareerContext.fromFirestore(map);

  CareerContext copyWith({
    String? careerId,
    String? careerTitle,
    String? categoryId,
    String? emoji,
    bool? isStaticCareer,
  }) =>
      CareerContext(
        careerId: careerId ?? this.careerId,
        careerTitle: careerTitle ?? this.careerTitle,
        categoryId: categoryId ?? this.categoryId,
        emoji: emoji ?? this.emoji,
        isStaticCareer: isStaticCareer ?? this.isStaticCareer,
        selectedAt: selectedAt,
      );
}

// ─── Learning Progress Context ────────────────────────────────────────────────
// Course/lesson progress for the selected career. `completedLessonIds` is
// permanent history — callers append new ids to it, never clear it, so a
// user's completed-lesson record survives career switches and re-syncs.

class LearningProgressContext {
  final String careerId;
  final int totalLessons;
  final List<String> completedLessonIds; // permanent history, append-only
  final String? currentLevelTitle;
  final String? lastLessonId;
  final DateTime updatedAt;

  const LearningProgressContext({
    required this.careerId,
    required this.totalLessons,
    this.completedLessonIds = const [],
    this.currentLevelTitle,
    this.lastLessonId,
    required this.updatedAt,
  });

  int get completedCount => completedLessonIds.length;

  double get progress =>
      totalLessons == 0 ? 0 : completedCount / totalLessons;

  Map<String, dynamic> toFirestore() => {
        'careerId': careerId,
        'totalLessons': totalLessons,
        'completedLessonIds': completedLessonIds,
        'currentLevelTitle': currentLevelTitle,
        'lastLessonId': lastLessonId,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory LearningProgressContext.fromFirestore(Map<String, dynamic> map) =>
      LearningProgressContext(
        careerId: map['careerId'] as String? ?? '',
        totalLessons: (map['totalLessons'] as num?)?.toInt() ?? 0,
        completedLessonIds:
            List<String>.from(map['completedLessonIds'] as List? ?? []),
        currentLevelTitle: map['currentLevelTitle'] as String?,
        lastLessonId: map['lastLessonId'] as String?,
        updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toMap() => toFirestore();
  factory LearningProgressContext.fromMap(Map<String, dynamic> map) =>
      LearningProgressContext.fromFirestore(map);

  /// Returns a NEW instance with one more lesson id appended to history.
  /// Never mutates or drops existing completedLessonIds.
  LearningProgressContext withLessonCompleted(String lessonId,
          {String? levelTitle}) =>
      LearningProgressContext(
        careerId: careerId,
        totalLessons: totalLessons,
        completedLessonIds: completedLessonIds.contains(lessonId)
            ? completedLessonIds
            : [...completedLessonIds, lessonId],
        currentLevelTitle: levelTitle ?? currentLevelTitle,
        lastLessonId: lessonId,
        updatedAt: DateTime.now(),
      );
}

// ─── Project Progress Context ─────────────────────────────────────────────────

class ProjectProgressContext {
  final int totalProjects;
  final List<String> completedProjectIds; // permanent history, append-only
  final String? currentProjectId;
  final DateTime updatedAt;

  const ProjectProgressContext({
    this.totalProjects = 0,
    this.completedProjectIds = const [],
    this.currentProjectId,
    required this.updatedAt,
  });

  int get completedCount => completedProjectIds.length;

  double get progress =>
      totalProjects == 0 ? 0 : completedCount / totalProjects;

  Map<String, dynamic> toFirestore() => {
        'totalProjects': totalProjects,
        'completedProjectIds': completedProjectIds,
        'currentProjectId': currentProjectId,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory ProjectProgressContext.fromFirestore(Map<String, dynamic> map) =>
      ProjectProgressContext(
        totalProjects: (map['totalProjects'] as num?)?.toInt() ?? 0,
        completedProjectIds:
            List<String>.from(map['completedProjectIds'] as List? ?? []),
        currentProjectId: map['currentProjectId'] as String?,
        updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toMap() => toFirestore();
  factory ProjectProgressContext.fromMap(Map<String, dynamic> map) =>
      ProjectProgressContext.fromFirestore(map);

  ProjectProgressContext withProjectCompleted(String projectId) =>
      ProjectProgressContext(
        totalProjects: totalProjects,
        completedProjectIds: completedProjectIds.contains(projectId)
            ? completedProjectIds
            : [...completedProjectIds, projectId],
        currentProjectId: currentProjectId,
        updatedAt: DateTime.now(),
      );
}

// ─── Job Progress Context ─────────────────────────────────────────────────────

class JobProgressContext {
  final List<String> appliedJobIds;   // permanent history, append-only
  final List<String> savedJobIds;
  final int offersReceived;
  final DateTime updatedAt;

  const JobProgressContext({
    this.appliedJobIds = const [],
    this.savedJobIds = const [],
    this.offersReceived = 0,
    required this.updatedAt,
  });

  int get applicationsSent => appliedJobIds.length;

  Map<String, dynamic> toFirestore() => {
        'appliedJobIds': appliedJobIds,
        'savedJobIds': savedJobIds,
        'offersReceived': offersReceived,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory JobProgressContext.fromFirestore(Map<String, dynamic> map) =>
      JobProgressContext(
        appliedJobIds: List<String>.from(map['appliedJobIds'] as List? ?? []),
        savedJobIds: List<String>.from(map['savedJobIds'] as List? ?? []),
        offersReceived: (map['offersReceived'] as num?)?.toInt() ?? 0,
        updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toMap() => toFirestore();
  factory JobProgressContext.fromMap(Map<String, dynamic> map) =>
      JobProgressContext.fromFirestore(map);

  JobProgressContext withJobApplied(String jobId) => JobProgressContext(
        appliedJobIds: appliedJobIds.contains(jobId)
            ? appliedJobIds
            : [...appliedJobIds, jobId],
        savedJobIds: savedJobIds,
        offersReceived: offersReceived,
        updatedAt: DateTime.now(),
      );
}

// ─── Interview Progress Context ───────────────────────────────────────────────

class InterviewProgressContext {
  final List<String> completedInterviewIds; // permanent history, append-only
  final int mockInterviewsDone;
  final double averageScore; // 0–100
  final DateTime? lastInterviewDate;
  final DateTime updatedAt;

  const InterviewProgressContext({
    this.completedInterviewIds = const [],
    this.mockInterviewsDone = 0,
    this.averageScore = 0,
    this.lastInterviewDate,
    required this.updatedAt,
  });

  Map<String, dynamic> toFirestore() => {
        'completedInterviewIds': completedInterviewIds,
        'mockInterviewsDone': mockInterviewsDone,
        'averageScore': averageScore,
        'lastInterviewDate': lastInterviewDate?.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory InterviewProgressContext.fromFirestore(Map<String, dynamic> map) =>
      InterviewProgressContext(
        completedInterviewIds:
            List<String>.from(map['completedInterviewIds'] as List? ?? []),
        mockInterviewsDone:
            (map['mockInterviewsDone'] as num?)?.toInt() ?? 0,
        averageScore: (map['averageScore'] as num?)?.toDouble() ?? 0,
        lastInterviewDate: map['lastInterviewDate'] == null
            ? null
            : DateTime.tryParse(map['lastInterviewDate'] as String),
        updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toMap() => toFirestore();
  factory InterviewProgressContext.fromMap(Map<String, dynamic> map) =>
      InterviewProgressContext.fromFirestore(map);

  InterviewProgressContext withInterviewCompleted(
    String interviewId, {
    double? score,
  }) {
    final newIds = completedInterviewIds.contains(interviewId)
        ? completedInterviewIds
        : [...completedInterviewIds, interviewId];
    double newAverage = averageScore;
    if (score != null) {
      final priorTotal = averageScore * mockInterviewsDone;
      newAverage = (priorTotal + score) / (mockInterviewsDone + 1);
    }
    return InterviewProgressContext(
      completedInterviewIds: newIds,
      mockInterviewsDone: mockInterviewsDone + (score != null ? 1 : 0),
      averageScore: newAverage,
      lastInterviewDate: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

// ─── Career Readiness ─────────────────────────────────────────────────────────
// A derived snapshot, not a source of truth — always recomputed from the
// contexts above. Safe to regenerate as often as needed; never itself
// mutates historical data.

class CareerReadiness {
  final double skillReadiness;     // 0–1
  final double learningReadiness;  // 0–1
  final double projectReadiness;   // 0–1
  final double interviewReadiness; // 0–1
  final double jobReadiness;       // 0–1
  final DateTime computedAt;

  const CareerReadiness({
    required this.skillReadiness,
    required this.learningReadiness,
    required this.projectReadiness,
    required this.interviewReadiness,
    required this.jobReadiness,
    required this.computedAt,
  });

  /// Simple unweighted average of the five readiness dimensions.
  double get overallScore =>
      (skillReadiness +
          learningReadiness +
          projectReadiness +
          interviewReadiness +
          jobReadiness) /
      5;

  String get readinessLabel {
    final s = overallScore;
    if (s >= 0.85) return 'Job Ready';
    if (s >= 0.6) return 'Almost There';
    if (s >= 0.3) return 'Building Momentum';
    return 'Just Starting';
  }

  factory CareerReadiness.empty() => CareerReadiness(
        skillReadiness: 0,
        learningReadiness: 0,
        projectReadiness: 0,
        interviewReadiness: 0,
        jobReadiness: 0,
        computedAt: DateTime.now(),
      );

  Map<String, dynamic> toFirestore() => {
        'skillReadiness': skillReadiness,
        'learningReadiness': learningReadiness,
        'projectReadiness': projectReadiness,
        'interviewReadiness': interviewReadiness,
        'jobReadiness': jobReadiness,
        'computedAt': computedAt.toIso8601String(),
      };

  factory CareerReadiness.fromFirestore(Map<String, dynamic> map) =>
      CareerReadiness(
        skillReadiness: (map['skillReadiness'] as num?)?.toDouble() ?? 0,
        learningReadiness:
            (map['learningReadiness'] as num?)?.toDouble() ?? 0,
        projectReadiness: (map['projectReadiness'] as num?)?.toDouble() ?? 0,
        interviewReadiness:
            (map['interviewReadiness'] as num?)?.toDouble() ?? 0,
        jobReadiness: (map['jobReadiness'] as num?)?.toDouble() ?? 0,
        computedAt: DateTime.tryParse(map['computedAt'] as String? ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toMap() => toFirestore();
  factory CareerReadiness.fromMap(Map<String, dynamic> map) =>
      CareerReadiness.fromFirestore(map);
}

// ─── Next Best Action ──────────────────────────────────────────────────────────

enum NextActionType { lesson, project, interview, application, skillReview, networking }

extension NextActionTypeExt on NextActionType {
  String get label {
    switch (this) {
      case NextActionType.lesson:        return 'Lesson';
      case NextActionType.project:       return 'Project';
      case NextActionType.interview:     return 'Interview Prep';
      case NextActionType.application:   return 'Job Application';
      case NextActionType.skillReview:   return 'Skill Review';
      case NextActionType.networking:    return 'Networking';
    }
  }

  static NextActionType fromString(String s) {
    return NextActionType.values.firstWhere(
      (t) => t.name == s || t.label == s,
      orElse: () => NextActionType.lesson,
    );
  }
}

class NextBestAction {
  final String id;
  final NextActionType type;
  final String title;
  final String description;
  final int priority; // 1=highest
  final String? relatedSkill;
  final DateTime createdAt;
  final bool isCompleted;

  const NextBestAction({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.priority = 2,
    this.relatedSkill,
    required this.createdAt,
    this.isCompleted = false,
  });

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'type': type.name,
        'title': title,
        'description': description,
        'priority': priority,
        'relatedSkill': relatedSkill,
        'createdAt': createdAt.toIso8601String(),
        'isCompleted': isCompleted,
      };

  factory NextBestAction.fromFirestore(Map<String, dynamic> map) =>
      NextBestAction(
        id: map['id'] as String? ?? '',
        type: NextActionTypeExt.fromString(map['type'] as String? ?? ''),
        title: map['title'] as String? ?? '',
        description: map['description'] as String? ?? '',
        priority: (map['priority'] as num?)?.toInt() ?? 2,
        relatedSkill: map['relatedSkill'] as String?,
        createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
            DateTime.now(),
        isCompleted: map['isCompleted'] as bool? ?? false,
      );

  Map<String, dynamic> toMap() => toFirestore();
  factory NextBestAction.fromMap(Map<String, dynamic> map) =>
      NextBestAction.fromFirestore(map);

  NextBestAction copyWith({bool? isCompleted}) => NextBestAction(
        id: id,
        type: type,
        title: title,
        description: description,
        priority: priority,
        relatedSkill: relatedSkill,
        createdAt: createdAt,
        isCompleted: isCompleted ?? this.isCompleted,
      );
}

// ─── Copilot Recommendation ─────────────────────────────────────────────────────

enum RecommendationCategory {
  skillGap,
  learningPath,
  project,
  interviewPrep,
  jobMatch,
  streakNudge,
}

extension RecommendationCategoryExt on RecommendationCategory {
  String get label {
    switch (this) {
      case RecommendationCategory.skillGap:      return 'Skill Gap';
      case RecommendationCategory.learningPath:  return 'Learning Path';
      case RecommendationCategory.project:       return 'Project';
      case RecommendationCategory.interviewPrep: return 'Interview Prep';
      case RecommendationCategory.jobMatch:      return 'Job Match';
      case RecommendationCategory.streakNudge:   return 'Streak Nudge';
    }
  }

  static RecommendationCategory fromString(String s) {
    return RecommendationCategory.values.firstWhere(
      (c) => c.name == s || c.label == s,
      orElse: () => RecommendationCategory.learningPath,
    );
  }
}

/// A single evolving piece of Copilot guidance. Recommendations are meant to
/// be generated fresh as progress changes and APPENDED to history (with old
/// ones marked `isDismissed` rather than deleted) — never used to overwrite
/// prior recommendation history wholesale.
class CopilotRecommendation {
  final String id;
  final RecommendationCategory category;
  final String title;
  final String description;
  final int priority; // 1=highest
  final DateTime createdAt;
  final bool isDismissed;

  const CopilotRecommendation({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    this.priority = 2,
    required this.createdAt,
    this.isDismissed = false,
  });

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'category': category.name,
        'title': title,
        'description': description,
        'priority': priority,
        'createdAt': createdAt.toIso8601String(),
        'isDismissed': isDismissed,
      };

  factory CopilotRecommendation.fromFirestore(Map<String, dynamic> map) =>
      CopilotRecommendation(
        id: map['id'] as String? ?? '',
        category: RecommendationCategoryExt.fromString(
            map['category'] as String? ?? ''),
        title: map['title'] as String? ?? '',
        description: map['description'] as String? ?? '',
        priority: (map['priority'] as num?)?.toInt() ?? 2,
        createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
            DateTime.now(),
        isDismissed: map['isDismissed'] as bool? ?? false,
      );

  Map<String, dynamic> toMap() => toFirestore();
  factory CopilotRecommendation.fromMap(Map<String, dynamic> map) =>
      CopilotRecommendation.fromFirestore(map);

  CopilotRecommendation copyWith({bool? isDismissed}) => CopilotRecommendation(
        id: id,
        category: category,
        title: title,
        description: description,
        priority: priority,
        createdAt: createdAt,
        isDismissed: isDismissed ?? this.isDismissed,
      );
}

// ─── Copilot Context (aggregate) ───────────────────────────────────────────────

class CopilotContext {
  final CopilotState state;
  final CareerContext? career;
  final LearningProgressContext learningProgress;
  final ProjectProgressContext projectProgress;
  final JobProgressContext jobProgress;
  final InterviewProgressContext interviewProgress;
  final CareerReadiness readiness;
  final List<NextBestAction> nextActions;
  final List<CopilotRecommendation> recommendations;

  CopilotContext({
    required this.state,
    this.career,
    LearningProgressContext? learningProgress,
    ProjectProgressContext? projectProgress,
    JobProgressContext? jobProgress,
    InterviewProgressContext? interviewProgress,
    CareerReadiness? readiness,
    this.nextActions = const [],
    this.recommendations = const [],
  })  : learningProgress = learningProgress ??
            LearningProgressContext(
              careerId: career?.careerId ?? '',
              totalLessons: 0,
              updatedAt: DateTime.now(),
            ),
        projectProgress =
            projectProgress ?? ProjectProgressContext(updatedAt: DateTime.now()),
        jobProgress = jobProgress ?? JobProgressContext(updatedAt: DateTime.now()),
        interviewProgress = interviewProgress ??
            InterviewProgressContext(updatedAt: DateTime.now()),
        readiness = readiness ?? CareerReadiness.empty();

  /// Only non-dismissed recommendations, highest priority first.
  List<CopilotRecommendation> get activeRecommendations {
    final active = recommendations.where((r) => !r.isDismissed).toList();
    active.sort((a, b) => a.priority.compareTo(b.priority));
    return active;
  }

  /// Only incomplete actions, highest priority first.
  List<NextBestAction> get pendingActions {
    final pending = nextActions.where((a) => !a.isCompleted).toList();
    pending.sort((a, b) => a.priority.compareTo(b.priority));
    return pending;
  }

  Map<String, dynamic> toFirestore() => {
        'skillProfile': state.skillProfile?.toFirestore(),
        'skillGaps': state.skillGaps.map((g) => g.toFirestore()).toList(),
        'roadmap': state.roadmap?.toFirestore(),
        'todayGoals': state.todayGoals.map((g) => g.toFirestore()).toList(),
        'progressHistory':
            state.progressHistory.map((p) => p.toFirestore()).toList(),
        'career': career?.toFirestore(),
        'learningProgress': learningProgress.toFirestore(),
        'projectProgress': projectProgress.toFirestore(),
        'jobProgress': jobProgress.toFirestore(),
        'interviewProgress': interviewProgress.toFirestore(),
        'readiness': readiness.toFirestore(),
        'nextActions': nextActions.map((a) => a.toFirestore()).toList(),
        'recommendations':
            recommendations.map((r) => r.toFirestore()).toList(),
      };

  factory CopilotContext.fromFirestore(Map<String, dynamic> map) {
    final rawGaps = map['skillGaps'] as List<dynamic>? ?? [];
    final rawGoals = map['todayGoals'] as List<dynamic>? ?? [];
    final rawHistory = map['progressHistory'] as List<dynamic>? ?? [];
    final rawActions = map['nextActions'] as List<dynamic>? ?? [];
    final rawRecs = map['recommendations'] as List<dynamic>? ?? [];

    final state = CopilotState(
      skillProfile: map['skillProfile'] == null
          ? null
          : UserSkillProfile.fromFirestore(
              map['skillProfile'] as Map<String, dynamic>),
      skillGaps: rawGaps
          .map((g) => SkillGap.fromFirestore(g as Map<String, dynamic>))
          .toList(),
      roadmap: map['roadmap'] == null
          ? null
          : PersonalizedRoadmap.fromFirestore(
              map['roadmap'] as Map<String, dynamic>),
      todayGoals: rawGoals
          .map((g) => DailyGoal.fromFirestore(g as Map<String, dynamic>))
          .toList(),
      progressHistory: rawHistory
          .map((p) => ProgressEntry.fromFirestore(p as Map<String, dynamic>))
          .toList(),
    );

    return CopilotContext(
      state: state,
      career: map['career'] == null
          ? null
          : CareerContext.fromFirestore(map['career'] as Map<String, dynamic>),
      learningProgress: map['learningProgress'] == null
          ? null
          : LearningProgressContext.fromFirestore(
              map['learningProgress'] as Map<String, dynamic>),
      projectProgress: map['projectProgress'] == null
          ? null
          : ProjectProgressContext.fromFirestore(
              map['projectProgress'] as Map<String, dynamic>),
      jobProgress: map['jobProgress'] == null
          ? null
          : JobProgressContext.fromFirestore(
              map['jobProgress'] as Map<String, dynamic>),
      interviewProgress: map['interviewProgress'] == null
          ? null
          : InterviewProgressContext.fromFirestore(
              map['interviewProgress'] as Map<String, dynamic>),
      readiness: map['readiness'] == null
          ? null
          : CareerReadiness.fromFirestore(
              map['readiness'] as Map<String, dynamic>),
      nextActions: rawActions
          .map((a) => NextBestAction.fromFirestore(a as Map<String, dynamic>))
          .toList(),
      recommendations: rawRecs
          .map((r) =>
              CopilotRecommendation.fromFirestore(r as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => toFirestore();
  factory CopilotContext.fromMap(Map<String, dynamic> map) =>
      CopilotContext.fromFirestore(map);

  CopilotContext copyWith({
    CopilotState? state,
    CareerContext? career,
    LearningProgressContext? learningProgress,
    ProjectProgressContext? projectProgress,
    JobProgressContext? jobProgress,
    InterviewProgressContext? interviewProgress,
    CareerReadiness? readiness,
    List<NextBestAction>? nextActions,
    List<CopilotRecommendation>? recommendations,
  }) =>
      CopilotContext(
        state: state ?? this.state,
        career: career ?? this.career,
        learningProgress: learningProgress ?? this.learningProgress,
        projectProgress: projectProgress ?? this.projectProgress,
        jobProgress: jobProgress ?? this.jobProgress,
        interviewProgress: interviewProgress ?? this.interviewProgress,
        readiness: readiness ?? this.readiness,
        nextActions: nextActions ?? this.nextActions,
        recommendations: recommendations ?? this.recommendations,
      );
}