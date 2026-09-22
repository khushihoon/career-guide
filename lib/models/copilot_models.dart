// ══════════════════════════════════════════════════════════════════════════════
// lib/models/copilot_models.dart
//
// 🔒 COPILOT MODELS — FROZEN
// CAREER PROGRESSION ENGINE — MODEL CONTRACT v1
//
// This file is the stable model contract for the Career Copilot.
// It contains MODELS only. No Firestore, no Firebase, no network, no AI/API,
// no business orchestration, no reward or readiness engines.
//
// ── Architectural ownership (do not blur) ───────────────────────────────────
//
//   Evidence / Event layer   → authoritative historical truth (owned elsewhere)
//   Aggregate layer          → current progress state  (the *Context models)
//   Readiness Engine         → derived, career-specific readiness (elsewhere)
//   Next Best Action Engine  → the decision itself      (elsewhere)
//   CopilotContext           → assembled READ MODEL
//   AI Memory                → non-authoritative personalization summary
//   UI                       → presentation only
//
// ── Progression pipeline ────────────────────────────────────────────────────
//
//   SELECTED CAREER
//        ↓
//   CAREER BLUEPRINT
//        ↓
//   USER EVIDENCE
//        ↓
//   PROGRESS AGGREGATES
//        ↓
//   READINESS
//        ↓
//   NEXT BEST ACTION
//        ↓
//   COPILOT CONTEXT
//        ↓
//   UI / AI MEMORY
//
// ── Concepts modeled here ───────────────────────────────────────────────────
//
//   • WHAT a career requires           → CareerBlueprint / CareerRequirement
//   • WHICH career is active           → CareerContext
//   • HOW evidence is classified       → SkillEvidenceType
//   • CURRENT aggregates per career    → Learning/Project/Job/Interview contexts
//   • DERIVED readiness snapshot       → CareerReadiness
//   • ONE executable next step         → NextBestAction
//   • Evolving guidance                → CopilotRecommendation
//   • Assembled runtime context        → CopilotContext
//
// ── Historical safety ───────────────────────────────────────────────────────
//
// Career switching must NOT delete or overwrite history. Historical evidence
// lives in the authoritative evidence layer. Every list on these models is
// append-only by convention; callers persist the union, never a wholesale
// replacement.
//
// ── XP and streak ───────────────────────────────────────────────────────────
//
// `CopilotState.totalXp` and `CopilotState.currentStreak` are COMPATIBILITY
// views, preserved for existing UI callers. They are NOT authoritative.
// Authoritative XP/streak is owned by the Firestore evidence layer.
//
// ── Serialization safety ────────────────────────────────────────────────────
//
// All new fields are optional and safely defaulted on parse. Old Firestore
// documents decode cleanly. Unknown enum values fall back to safe defaults.
// No unsafe casts.
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

// ─── Skill Evidence Type ─────────────────────────────────────────────────────
//
// Classifies HOW a skill was demonstrated. Course completion is NOT mastery;
// a project is NOT an assessment. This enum lets the intelligence layer
// reason about evidence quality without collapsing everything into a single
// fake skill score.
//
// Actual immutable evidence records are owned by the evidence layer; this
// enum only describes the shape of an evidence reference.

enum SkillEvidenceType {
  learning,   // consumed content (lesson, course)
  practice,   // deliberate drills (exercises, katas)
  project,    // shipped work demonstrating the skill
  assessment, // graded evaluation / validation (quiz, mock interview)
}

extension SkillEvidenceTypeExt on SkillEvidenceType {
  String get label {
    switch (this) {
      case SkillEvidenceType.learning:   return 'Learning';
      case SkillEvidenceType.practice:   return 'Practice';
      case SkillEvidenceType.project:    return 'Project';
      case SkillEvidenceType.assessment: return 'Assessment';
    }
  }

  static SkillEvidenceType fromString(String s) {
    return SkillEvidenceType.values.firstWhere(
      (e) => e.name == s || e.label.toLowerCase() == s.toLowerCase(),
      orElse: () => SkillEvidenceType.learning,
    );
  }
}

// ─── Career Stage ────────────────────────────────────────────────────────────
//
// A coarse pipeline stage. Used by blueprints and progression snapshots to
// describe where a user is in the career journey. This is a REFERENCE enum,
// not per-user state — the authoritative stage is computed by services.
//
// NOTE: progress_tracking_service.dart has a legacy `CareerStage` enum with
// a different set of values. That legacy service is expected to be adapted
// onto this canonical model layer later; this file must not be redesigned
// to match the legacy shapes.

enum CareerStage {
  exploration,   // 0 knowledge / choosing a career
  assessment,    // identifying skill gaps
  learning,      // foundational learning
  practice,      // deliberate practice
  projects,      // building real projects
  portfolio,     // packaging work
  cvReady,       // CV / resume ready
  interviewPrep, // interview preparation and mocks
  jobSearch,     // applying for roles
  jobReady,      // meets the career blueprint bar
  growth,        // continuous professional growth
}

extension CareerStageExt on CareerStage {
  String get label {
    switch (this) {
      case CareerStage.exploration:   return 'Exploration';
      case CareerStage.assessment:    return 'Assessment';
      case CareerStage.learning:      return 'Learning';
      case CareerStage.practice:      return 'Practice';
      case CareerStage.projects:      return 'Projects';
      case CareerStage.portfolio:     return 'Portfolio';
      case CareerStage.cvReady:       return 'CV Ready';
      case CareerStage.interviewPrep: return 'Interview Prep';
      case CareerStage.jobSearch:     return 'Job Search';
      case CareerStage.jobReady:      return 'Job Ready';
      case CareerStage.growth:        return 'Growth';
    }
  }

  static CareerStage fromString(String s) {
    return CareerStage.values.firstWhere(
      (st) => st.name == s || st.label.toLowerCase() == s.toLowerCase(),
      orElse: () => CareerStage.exploration,
    );
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

  /// Optional evidence marker describing HOW this skill was most recently
  /// demonstrated. Null means "not specified" (existing behaviour). This is
  /// additive: existing constructors and Firestore documents keep working.
  final SkillEvidenceType? lastEvidenceType;

  /// Optional career scope. Null means "not career-scoped" (existing
  /// behaviour). Additive.
  final String? careerId;

  const UserSkill({
    required this.name,
    required this.level,
    required this.addedAt,
    this.lastEvidenceType,
    this.careerId,
  });

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'level': level.name,
        'addedAt': addedAt.toIso8601String(),
        if (lastEvidenceType != null)
          'lastEvidenceType': lastEvidenceType!.name,
        if (careerId != null) 'careerId': careerId,
      };

  factory UserSkill.fromFirestore(Map<String, dynamic> map) => UserSkill(
        name: map['name'] as String? ?? '',
        level: SkillLevelExt.fromString(map['level'] as String? ?? 'beginner'),
        addedAt:
            DateTime.tryParse(map['addedAt'] as String? ?? '') ?? DateTime.now(),
        lastEvidenceType: map['lastEvidenceType'] == null
            ? null
            : SkillEvidenceTypeExt.fromString(
                map['lastEvidenceType'] as String),
        careerId: map['careerId'] as String?,
      );

  UserSkill copyWith({
    String? name,
    SkillLevel? level,
    DateTime? addedAt,
    SkillEvidenceType? lastEvidenceType,
    String? careerId,
  }) =>
      UserSkill(
        name: name ?? this.name,
        level: level ?? this.level,
        addedAt: addedAt ?? this.addedAt,
        lastEvidenceType: lastEvidenceType ?? this.lastEvidenceType,
        careerId: careerId ?? this.careerId,
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

// ─── Skill Gap Status ─────────────────────────────────────────────────────────

enum SkillGapStatus { open, improving, closed }

extension SkillGapStatusExt on SkillGapStatus {
  String get label {
    switch (this) {
      case SkillGapStatus.open:      return 'Open';
      case SkillGapStatus.improving: return 'Improving';
      case SkillGapStatus.closed:    return 'Closed';
    }
  }

  static SkillGapStatus fromString(String s) {
    return SkillGapStatus.values.firstWhere(
      (st) => st.name == s || st.label.toLowerCase() == s.toLowerCase(),
      orElse: () => SkillGapStatus.open,
    );
  }
}

// ─── Skill Gap ────────────────────────────────────────────────────────────────
//
// WHAT is missing, WHY it matters, HOW significant the gap is.
//
// Additive:
//   • Optional `careerId` for career isolation.
//   • Optional `evidenceRefs` so future services can attach concrete
//     evidence references (lesson ids, project ids, assessment ids) without
//     collapsing them into a single fake score.
//   • Optional `status` for lifecycle (open / improving / closed).

class SkillGap {
  final String skillName;
  final SkillLevel requiredLevel;
  final SkillLevel? currentLevel; // null = not learned yet
  final int priority;             // 1=critical, 2=important, 3=nice-to-have
  final String reason;

  /// Optional career scope. Null = not career-scoped (existing behaviour).
  final String? careerId;

  /// Optional status. Null = unspecified; existing callers keep working.
  final SkillGapStatus? status;

  /// Optional concrete evidence references (lesson / project / assessment
  /// ids). Append-only by convention; the service owns their lifecycle.
  final List<String> evidenceRefs;

  const SkillGap({
    required this.skillName,
    required this.requiredLevel,
    this.currentLevel,
    required this.priority,
    required this.reason,
    this.careerId,
    this.status,
    this.evidenceRefs = const [],
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
        if (careerId != null) 'careerId': careerId,
        if (status != null) 'status': status!.name,
        if (evidenceRefs.isNotEmpty) 'evidenceRefs': evidenceRefs,
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
        careerId: map['careerId'] as String?,
        status: map['status'] == null
            ? null
            : SkillGapStatusExt.fromString(map['status'] as String),
        evidenceRefs:
            List<String>.from(map['evidenceRefs'] as List? ?? const []),
      );

  SkillGap copyWith({
    SkillLevel? currentLevel,
    int? priority,
    String? reason,
    String? careerId,
    SkillGapStatus? status,
    List<String>? evidenceRefs,
  }) =>
      SkillGap(
        skillName: skillName,
        requiredLevel: requiredLevel,
        currentLevel: currentLevel ?? this.currentLevel,
        priority: priority ?? this.priority,
        reason: reason ?? this.reason,
        careerId: careerId ?? this.careerId,
        status: status ?? this.status,
        evidenceRefs: evidenceRefs ?? this.evidenceRefs,
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
//
// NOTE ON XP/STREAK AUTHORITY
// ---------------------------
// `totalXp` and `currentStreak` below are COMPATIBILITY views derived from
// `progressHistory`. They remain for backward compatibility with existing
// UI code. They are NOT the authoritative source of XP or streak.
//
// The authoritative XP value lives on `users/{uid}.totalXp` and is read by
// `CopilotFirestoreService.getUserTotalXp`. Callers that need authoritative
// XP must use that service, not this getter.

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

  /// COMPATIBILITY VIEW — not authoritative.
  /// See the class-level note above. Authoritative XP lives on Firestore.
  int get totalXp =>
      progressHistory.fold(0, (sum, e) => sum + e.xpEarned);

  /// COMPATIBILITY VIEW — not authoritative.
  /// Streak is career momentum; the authoritative value is owned by the
  /// evidence layer. This getter only inspects existing progressHistory and
  /// is preserved for existing UI consumers.
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
// ─── CAREER PROGRESSION ENGINE — ADDITIVE CONTRACTS ──────────────────────────
//
// Everything below is additive. Every new field is optional, safe-defaulted
// on parse, and never breaks old Firestore documents or existing callers.
// Every list is append-only by convention.
// ══════════════════════════════════════════════════════════════════════════════

// ─── Career Context ─────────────────────────────────────────────────────────
// Identifies WHICH career is currently active. Does not describe what the
// career requires (that is CareerBlueprint) and does not carry user progress.

class CareerContext {
  final String careerId;
  final String careerTitle;
  final String categoryId;
  final String emoji;
  final bool isStaticCareer; // true = real authored lessons, false = AI-generated
  final DateTime selectedAt;

  /// Optional blueprint version reference. Null when the user's career
  /// selection predates blueprint versioning.
  final String? blueprintVersionRef;

  const CareerContext({
    required this.careerId,
    required this.careerTitle,
    required this.categoryId,
    required this.emoji,
    required this.isStaticCareer,
    required this.selectedAt,
    this.blueprintVersionRef,
  });

  Map<String, dynamic> toFirestore() => {
        'careerId': careerId,
        'careerTitle': careerTitle,
        'categoryId': categoryId,
        'emoji': emoji,
        'isStaticCareer': isStaticCareer,
        'selectedAt': selectedAt.toIso8601String(),
        if (blueprintVersionRef != null)
          'blueprintVersionRef': blueprintVersionRef,
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
        blueprintVersionRef: map['blueprintVersionRef'] as String?,
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
    String? blueprintVersionRef,
  }) =>
      CareerContext(
        careerId: careerId ?? this.careerId,
        careerTitle: careerTitle ?? this.careerTitle,
        categoryId: categoryId ?? this.categoryId,
        emoji: emoji ?? this.emoji,
        isStaticCareer: isStaticCareer ?? this.isStaticCareer,
        selectedAt: selectedAt,
        blueprintVersionRef: blueprintVersionRef ?? this.blueprintVersionRef,
      );
}

// ─── Career Blueprint ───────────────────────────────────────────────────────
//
// A DEFINITION of what job-ready means for a specific career. It is NOT
// user progress. The readiness and next-action engines compare the user's
// real evidence against this contract.
//
// Blueprint   = WHAT THE CAREER REQUIRES.
// User data   = WHAT THE USER HAS DONE.
// These must remain conceptually separate.

class CareerRequirement {
  /// Free-form category: 'skill', 'learning', 'practice', 'project',
  /// 'portfolio', 'cv', 'interview', 'job', or a future extension.
  final String category;

  /// Stable identifier for the requirement within its category
  /// (e.g. skill name, project archetype id).
  final String key;

  /// Human-readable description for UIs.
  final String description;

  /// Optional numeric threshold. Meaning depends on category:
  ///   • skill     → required SkillLevel.value (1..4)
  ///   • learning  → required completed lessons / courses count
  ///   • practice  → required practice sessions
  ///   • project   → required completed projects
  ///   • portfolio → required portfolio items
  ///   • interview → required interview practices
  ///   • job       → required applications
  final num? targetValue;

  /// Optional priority hint (1 = critical). Null = unspecified.
  final int? priority;

  const CareerRequirement({
    required this.category,
    required this.key,
    required this.description,
    this.targetValue,
    this.priority,
  });

  Map<String, dynamic> toFirestore() => {
        'category': category,
        'key': key,
        'description': description,
        if (targetValue != null) 'targetValue': targetValue,
        if (priority != null) 'priority': priority,
      };

  factory CareerRequirement.fromFirestore(Map<String, dynamic> map) =>
      CareerRequirement(
        category: map['category'] as String? ?? '',
        key: map['key'] as String? ?? '',
        description: map['description'] as String? ?? '',
        targetValue: map['targetValue'] as num?,
        priority: (map['priority'] as num?)?.toInt(),
      );

  Map<String, dynamic> toMap() => toFirestore();
  factory CareerRequirement.fromMap(Map<String, dynamic> map) =>
      CareerRequirement.fromFirestore(map);
}

class CareerBlueprint {
  final String careerId;
  final String careerTitle;

  /// Optional category id (e.g. 'ai', 'software') — mirrors CareerContext.
  final String? categoryId;

  /// Blueprint version. Bump when requirements change so downstream can
  /// detect stale readiness computations.
  final int version;

  /// Optional human-readable summary of what this career is about.
  final String? summary;

  /// The ordered pipeline stages this career expects the user to pass
  /// through. Empty = unspecified (caller falls back to a default order).
  final List<CareerStage> stages;

  /// Career-scoped requirements. Different careers can express different
  /// requirement sets.
  final List<CareerRequirement> requirements;

  /// Optional metadata bag for future tooling. Bounded by convention to
  /// small key/value pairs; not intended for large structured data.
  final Map<String, dynamic> metadata;

  const CareerBlueprint({
    required this.careerId,
    required this.careerTitle,
    this.categoryId,
    this.version = 1,
    this.summary,
    this.stages = const [],
    this.requirements = const [],
    this.metadata = const {},
  });

  Map<String, dynamic> toFirestore() => {
        'careerId': careerId,
        'careerTitle': careerTitle,
        if (categoryId != null) 'categoryId': categoryId,
        'version': version,
        if (summary != null) 'summary': summary,
        'stages': stages.map((s) => s.name).toList(),
        'requirements': requirements.map((r) => r.toFirestore()).toList(),
        if (metadata.isNotEmpty) 'metadata': metadata,
      };

  factory CareerBlueprint.fromFirestore(Map<String, dynamic> map) {
    final rawStages = map['stages'] as List<dynamic>? ?? [];
    final rawReqs = map['requirements'] as List<dynamic>? ?? [];
    return CareerBlueprint(
      careerId: map['careerId'] as String? ?? '',
      careerTitle: map['careerTitle'] as String? ?? '',
      categoryId: map['categoryId'] as String?,
      version: (map['version'] as num?)?.toInt() ?? 1,
      summary: map['summary'] as String?,
      stages: rawStages
          .map((s) => CareerStageExt.fromString(s as String))
          .toList(),
      requirements: rawReqs
          .map((r) =>
              CareerRequirement.fromFirestore(r as Map<String, dynamic>))
          .toList(),
      metadata: Map<String, dynamic>.from(
          (map['metadata'] as Map?) ?? const <String, dynamic>{}),
    );
  }

  Map<String, dynamic> toMap() => toFirestore();
  factory CareerBlueprint.fromMap(Map<String, dynamic> map) =>
      CareerBlueprint.fromFirestore(map);

  CareerBlueprint copyWith({
    String? careerId,
    String? careerTitle,
    String? categoryId,
    int? version,
    String? summary,
    List<CareerStage>? stages,
    List<CareerRequirement>? requirements,
    Map<String, dynamic>? metadata,
  }) =>
      CareerBlueprint(
        careerId: careerId ?? this.careerId,
        careerTitle: careerTitle ?? this.careerTitle,
        categoryId: categoryId ?? this.categoryId,
        version: version ?? this.version,
        summary: summary ?? this.summary,
        stages: stages ?? this.stages,
        requirements: requirements ?? this.requirements,
        metadata: metadata ?? this.metadata,
      );
}

// ─── Learning Progress Context ────────────────────────────────────────────────
//
// Course/lesson progress scoped to a career.
// `completedLessonIds` and `completedCourseIds` are permanent history —
// callers append ids to them, never clear them, so the user's completed
// record survives career switches and re-syncs.

class LearningProgressContext {
  final String careerId;
  final int totalLessons;
  final List<String> completedLessonIds; // permanent history, append-only
  final String? currentLevelTitle;
  final String? lastLessonId;
  final DateTime updatedAt;

  /// Optional course-level history. Append-only by convention.
  final List<String> completedCourseIds;

  /// Optional current stage hint. Null = unspecified.
  final CareerStage? currentStage;

  const LearningProgressContext({
    required this.careerId,
    required this.totalLessons,
    this.completedLessonIds = const [],
    this.currentLevelTitle,
    this.lastLessonId,
    required this.updatedAt,
    this.completedCourseIds = const [],
    this.currentStage,
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
        if (completedCourseIds.isNotEmpty)
          'completedCourseIds': completedCourseIds,
        if (currentStage != null) 'currentStage': currentStage!.name,
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
        completedCourseIds:
            List<String>.from(map['completedCourseIds'] as List? ?? const []),
        currentStage: map['currentStage'] == null
            ? null
            : CareerStageExt.fromString(map['currentStage'] as String),
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
        completedCourseIds: completedCourseIds,
        currentStage: currentStage,
      );

  LearningProgressContext copyWith({
    int? totalLessons,
    List<String>? completedLessonIds,
    String? currentLevelTitle,
    String? lastLessonId,
    List<String>? completedCourseIds,
    CareerStage? currentStage,
  }) =>
      LearningProgressContext(
        careerId: careerId,
        totalLessons: totalLessons ?? this.totalLessons,
        completedLessonIds: completedLessonIds ?? this.completedLessonIds,
        currentLevelTitle: currentLevelTitle ?? this.currentLevelTitle,
        lastLessonId: lastLessonId ?? this.lastLessonId,
        updatedAt: DateTime.now(),
        completedCourseIds: completedCourseIds ?? this.completedCourseIds,
        currentStage: currentStage ?? this.currentStage,
      );
}

// ─── Project Progress Context ─────────────────────────────────────────────────
//
// `completedProjectIds` is permanent history — append-only.
// `projectMilestones` records progress within projects; it never replaces
// the completed-projects list.

class ProjectProgressContext {
  final int totalProjects;
  final List<String> completedProjectIds; // permanent history, append-only
  final String? currentProjectId;
  final DateTime updatedAt;

  /// Optional career scope. Null = unscoped (existing behaviour).
  final String? careerId;

  /// Optional per-project milestone map: { projectId: [milestoneId, ...] }.
  /// Append-only by convention; callers persist the union, never replace.
  final Map<String, List<String>> projectMilestones;

  const ProjectProgressContext({
    this.totalProjects = 0,
    this.completedProjectIds = const [],
    this.currentProjectId,
    required this.updatedAt,
    this.careerId,
    this.projectMilestones = const {},
  });

  int get completedCount => completedProjectIds.length;

  double get progress =>
      totalProjects == 0 ? 0 : completedCount / totalProjects;

  Map<String, dynamic> toFirestore() => {
        'totalProjects': totalProjects,
        'completedProjectIds': completedProjectIds,
        'currentProjectId': currentProjectId,
        'updatedAt': updatedAt.toIso8601String(),
        if (careerId != null) 'careerId': careerId,
        if (projectMilestones.isNotEmpty)
          'projectMilestones': projectMilestones
              .map((k, v) => MapEntry(k, List<String>.from(v))),
      };

  factory ProjectProgressContext.fromFirestore(Map<String, dynamic> map) {
    final rawMilestones =
        (map['projectMilestones'] as Map?) ?? const <String, dynamic>{};
    final milestones = <String, List<String>>{};
    rawMilestones.forEach((k, v) {
      if (k is String) {
        milestones[k] = List<String>.from((v as List?) ?? const []);
      }
    });
    return ProjectProgressContext(
      totalProjects: (map['totalProjects'] as num?)?.toInt() ?? 0,
      completedProjectIds:
          List<String>.from(map['completedProjectIds'] as List? ?? []),
      currentProjectId: map['currentProjectId'] as String?,
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      careerId: map['careerId'] as String?,
      projectMilestones: milestones,
    );
  }

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
        careerId: careerId,
        projectMilestones: projectMilestones,
      );

  ProjectProgressContext withMilestoneCompleted(
    String projectId,
    String milestoneId,
  ) {
    final existing = projectMilestones[projectId] ?? const <String>[];
    final updated = existing.contains(milestoneId)
        ? existing
        : [...existing, milestoneId];
    final nextMap = <String, List<String>>{...projectMilestones};
    nextMap[projectId] = updated;
    return ProjectProgressContext(
      totalProjects: totalProjects,
      completedProjectIds: completedProjectIds,
      currentProjectId: currentProjectId,
      updatedAt: DateTime.now(),
      careerId: careerId,
      projectMilestones: nextMap,
    );
  }
}

// ─── Job Progress Context ─────────────────────────────────────────────────────
//
// `appliedJobIds` and `savedJobIds` are permanent history — append-only.
// `applicationStates` enriches per-application status; it never replaces
// the applied-jobs list.

class JobProgressContext {
  final List<String> appliedJobIds;   // permanent history, append-only
  final List<String> savedJobIds;
  final int offersReceived;
  final DateTime updatedAt;

  /// Optional career scope. Null = unscoped (existing behaviour).
  final String? careerId;

  /// Optional per-application state map: { jobId: 'applied' | 'screening'
  /// | 'interviewing' | 'offer' | 'rejected' | ... }. Open vocabulary;
  /// the service owns the canonical state machine.
  final Map<String, String> applicationStates;

  const JobProgressContext({
    this.appliedJobIds = const [],
    this.savedJobIds = const [],
    this.offersReceived = 0,
    required this.updatedAt,
    this.careerId,
    this.applicationStates = const {},
  });

  int get applicationsSent => appliedJobIds.length;

  Map<String, dynamic> toFirestore() => {
        'appliedJobIds': appliedJobIds,
        'savedJobIds': savedJobIds,
        'offersReceived': offersReceived,
        'updatedAt': updatedAt.toIso8601String(),
        if (careerId != null) 'careerId': careerId,
        if (applicationStates.isNotEmpty)
          'applicationStates': applicationStates,
      };

  factory JobProgressContext.fromFirestore(Map<String, dynamic> map) {
    final rawStates =
        (map['applicationStates'] as Map?) ?? const <String, dynamic>{};
    final states = <String, String>{};
    rawStates.forEach((k, v) {
      if (k is String && v is String) states[k] = v;
    });
    return JobProgressContext(
      appliedJobIds: List<String>.from(map['appliedJobIds'] as List? ?? []),
      savedJobIds: List<String>.from(map['savedJobIds'] as List? ?? []),
      offersReceived: (map['offersReceived'] as num?)?.toInt() ?? 0,
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      careerId: map['careerId'] as String?,
      applicationStates: states,
    );
  }

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
        careerId: careerId,
        applicationStates: applicationStates,
      );

  JobProgressContext withApplicationState(String jobId, String state) {
    final next = <String, String>{...applicationStates};
    next[jobId] = state;
    return JobProgressContext(
      appliedJobIds: appliedJobIds,
      savedJobIds: savedJobIds,
      offersReceived: offersReceived,
      updatedAt: DateTime.now(),
      careerId: careerId,
      applicationStates: next,
    );
  }
}

// ─── Interview Attempt ────────────────────────────────────────────────────────
//
// One concrete attempt at an interview. Multiple attempts for the same
// interviewId are legitimate and must NOT inflate the unique-completed
// count. `attempts` is append-only history; it never replaces
// `completedInterviewIds`.

class InterviewAttempt {
  final String interviewId;
  final DateTime attemptedAt;
  final double? score; // 0–100, null = ungraded attempt

  const InterviewAttempt({
    required this.interviewId,
    required this.attemptedAt,
    this.score,
  });

  Map<String, dynamic> toFirestore() => {
        'interviewId': interviewId,
        'attemptedAt': attemptedAt.toIso8601String(),
        if (score != null) 'score': score,
      };

  factory InterviewAttempt.fromFirestore(Map<String, dynamic> map) =>
      InterviewAttempt(
        interviewId: map['interviewId'] as String? ?? '',
        attemptedAt:
            DateTime.tryParse(map['attemptedAt'] as String? ?? '') ??
                DateTime.now(),
        score: (map['score'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => toFirestore();
  factory InterviewAttempt.fromMap(Map<String, dynamic> map) =>
      InterviewAttempt.fromFirestore(map);
}

// ─── Interview Progress Context ───────────────────────────────────────────────
//
// SEMANTICS
// ---------
//   • completedInterviewIds = UNIQUE completed interview IDs.
//   • mockInterviewsDone    = number of UNIQUE completed interviews that
//                             have at least one scored attempt. Duplicate
//                             attempts of the same interviewId never
//                             inflate this count.
//   • attempts              = append-only history of EVERY attempt,
//                             including repeats and ungraded ones.
//   • averageScore          = mean of ALL scored attempts across every
//                             attempt in `attempts`. A second scored
//                             attempt for the same interviewId is
//                             therefore reflected in the average.
//
// LEGACY DOCUMENT COMPATIBILITY
// -----------------------------
// Older Firestore documents may carry `mockInterviewsDone` and
// `averageScore` WITHOUT an `attempts` history. In that case the aggregate
// values are treated as opaque legacy totals and preserved:
//
//   • When `attempts` is EMPTY and legacy aggregate values are present,
//     `withInterviewCompleted()` folds the new attempt into the existing
//     aggregates using the legacy scalar semantics, rather than recomputing
//     from an empty attempt list (which would erase the legacy values).
//
//   • When `attempts` is NON-EMPTY, the modern semantics above apply and the
//     aggregates are recomputed from the full attempt history.

class InterviewProgressContext {
  final List<String> completedInterviewIds; // unique completed ids, append-only
  final int mockInterviewsDone;             // unique interviews with a score
  final double averageScore;                // 0–100 over ALL scored attempts
  final DateTime? lastInterviewDate;
  final DateTime updatedAt;

  /// Optional career scope. Null = unscoped (existing behaviour).
  final String? careerId;

  /// Optional per-attempt history. Append-only by convention.
  final List<InterviewAttempt> attempts;

  const InterviewProgressContext({
    this.completedInterviewIds = const [],
    this.mockInterviewsDone = 0,
    this.averageScore = 0,
    this.lastInterviewDate,
    required this.updatedAt,
    this.careerId,
    this.attempts = const [],
  });

  Map<String, dynamic> toFirestore() => {
        'completedInterviewIds': completedInterviewIds,
        'mockInterviewsDone': mockInterviewsDone,
        'averageScore': averageScore,
        'lastInterviewDate': lastInterviewDate?.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (careerId != null) 'careerId': careerId,
        if (attempts.isNotEmpty)
          'attempts': attempts.map((a) => a.toFirestore()).toList(),
      };

  factory InterviewProgressContext.fromFirestore(Map<String, dynamic> map) {
    final rawAttempts = map['attempts'] as List<dynamic>? ?? const [];
    return InterviewProgressContext(
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
      careerId: map['careerId'] as String?,
      attempts: rawAttempts
          .map((a) =>
              InterviewAttempt.fromFirestore(a as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => toFirestore();
  factory InterviewProgressContext.fromMap(Map<String, dynamic> map) =>
      InterviewProgressContext.fromFirestore(map);

  /// Records an interview attempt.
  ///
  /// Rules (do not change):
  ///   • The attempt is ALWAYS appended to [attempts].
  ///   • The interviewId is appended to [completedInterviewIds] only the
  ///     first time it is seen (unique completed count).
  ///
  /// Legacy behaviour (no attempt history available):
  ///   • If the pre-existing [attempts] list is EMPTY, the legacy aggregate
  ///     values [mockInterviewsDone] and [averageScore] are preserved and
  ///     only updated by folding the new attempt into them. This prevents an
  ///     older Firestore document that stored only aggregates (no attempt
  ///     history) from being reset to zero the first time a new attempt is
  ///     recorded.
  ///
  /// Modern behaviour (attempt history available):
  ///   • [mockInterviewsDone] counts UNIQUE interviews with at least one
  ///     scored attempt.
  ///   • [averageScore] is the mean of ALL scored attempts across every
  ///     attempt in [attempts].
  InterviewProgressContext withInterviewCompleted(
    String interviewId, {
    double? score,
  }) {
    final alreadyCompleted = completedInterviewIds.contains(interviewId);
    final newIds = alreadyCompleted
        ? completedInterviewIds
        : [...completedInterviewIds, interviewId];

    // Append the raw attempt to history. Ungraded attempts are recorded
    // (score == null) and do not affect the average.
    final newAttempts = <InterviewAttempt>[
      ...attempts,
      InterviewAttempt(
        interviewId: interviewId,
        attemptedAt: DateTime.now(),
        score: score,
      ),
    ];

    final int newMockInterviewsDone;
    final double newAverage;

    if (attempts.isEmpty) {
      // ── Legacy path: no attempt history available ────────────────────
      // Treat the existing [mockInterviewsDone] and [averageScore] as the
      // authoritative totals so far, and fold the new attempt into them.
      // This preserves prior aggregate values for old documents that only
      // stored totals (before `attempts` existed).
      //
      // Rules for the legacy fold:
      //   • An ungraded attempt does not change either value.
      //   • A scored attempt on a NEW interview increments the count and
      //     updates the running average using the legacy count as N.
      //   • A scored attempt on an ALREADY-completed interview updates the
      //     running average using the legacy count as N, but does NOT
      //     increment the count (the interview is already counted). This
      //     preserves the "unique interviews with a score" invariant while
      //     still reflecting the new attempt in the average.
      if (score == null) {
        newMockInterviewsDone = mockInterviewsDone;
        newAverage = averageScore;
      } else if (!alreadyCompleted) {
        final priorTotal = averageScore * mockInterviewsDone;
        newMockInterviewsDone = mockInterviewsDone + 1;
        newAverage = newMockInterviewsDone == 0
            ? 0.0
            : (priorTotal + score) / newMockInterviewsDone;
      } else {
        // Already-counted interview receiving a scored attempt. Keep the
        // count stable; fold the new score into the running average using
        // the existing count as N.
        newMockInterviewsDone = mockInterviewsDone;
        if (mockInterviewsDone <= 0) {
          newAverage = score;
        } else {
          final priorTotal = averageScore * mockInterviewsDone;
          // Reuse the same N so we don't artificially inflate uniqueness.
          newAverage = (priorTotal + score) / (mockInterviewsDone + 1);
        }
      }
    } else {
      // ── Modern path: full attempt history available ──────────────────
      // Recompute aggregates from ALL attempts.
      double sum = 0;
      int scoredCount = 0;
      final scoredInterviewIds = <String>{};
      for (final a in newAttempts) {
        final s = a.score;
        if (s != null) {
          sum += s;
          scoredCount++;
          scoredInterviewIds.add(a.interviewId);
        }
      }
      newAverage = scoredCount == 0 ? 0.0 : sum / scoredCount;
      newMockInterviewsDone = scoredInterviewIds.length;
    }

    return InterviewProgressContext(
      completedInterviewIds: newIds,
      mockInterviewsDone: newMockInterviewsDone,
      averageScore: newAverage,
      lastInterviewDate: DateTime.now(),
      updatedAt: DateTime.now(),
      careerId: careerId,
      attempts: newAttempts,
    );
  }
}

// ─── Portfolio Readiness ─────────────────────────────────────────────────────
//
// A DERIVED summary of portfolio readiness. It carries only counts, never
// the underlying evidence list (which belongs to the authoritative
// evidence layer). Populated by the readiness engine; never fabricated.

class PortfolioReadiness {
  final int itemCount;          // portfolio items currently published
  final int targetCount;        // blueprint target
  final List<String> highlights;// optional item ids flagged as highlights

  const PortfolioReadiness({
    this.itemCount = 0,
    this.targetCount = 0,
    this.highlights = const [],
  });

  /// Ratio in [0, 1]. Returns 0.0 when [targetCount] is non-positive
  /// (avoids division by zero). Guaranteed to return a real `double`.
  double get ratio {
    if (targetCount <= 0) return 0.0;
    final raw = itemCount / targetCount;
    return raw.clamp(0.0, 1.0).toDouble();
  }

  Map<String, dynamic> toFirestore() => {
        'itemCount': itemCount,
        'targetCount': targetCount,
        if (highlights.isNotEmpty) 'highlights': highlights,
      };

  factory PortfolioReadiness.fromFirestore(Map<String, dynamic> map) =>
      PortfolioReadiness(
        itemCount: (map['itemCount'] as num?)?.toInt() ?? 0,
        targetCount: (map['targetCount'] as num?)?.toInt() ?? 0,
        highlights: List<String>.from(map['highlights'] as List? ?? const []),
      );

  Map<String, dynamic> toMap() => toFirestore();
  factory PortfolioReadiness.fromMap(Map<String, dynamic> map) =>
      PortfolioReadiness.fromFirestore(map);
}

// ─── CV Readiness ────────────────────────────────────────────────────────────
//
// A DERIVED summary of CV/resume readiness. Section flags only, never
// fabricated content. Populated by the readiness engine.

class CvReadiness {
  final bool hasSummary;
  final bool hasExperienceSection;
  final bool hasEducationSection;
  final bool hasSkillsSection;
  final bool hasProjectsSection;
  final DateTime? lastReviewedAt;

  const CvReadiness({
    this.hasSummary = false,
    this.hasExperienceSection = false,
    this.hasEducationSection = false,
    this.hasSkillsSection = false,
    this.hasProjectsSection = false,
    this.lastReviewedAt,
  });

  double get ratio {
    var done = 0;
    if (hasSummary) done++;
    if (hasExperienceSection) done++;
    if (hasEducationSection) done++;
    if (hasSkillsSection) done++;
    if (hasProjectsSection) done++;
    return done / 5;
  }

  Map<String, dynamic> toFirestore() => {
        'hasSummary': hasSummary,
        'hasExperienceSection': hasExperienceSection,
        'hasEducationSection': hasEducationSection,
        'hasSkillsSection': hasSkillsSection,
        'hasProjectsSection': hasProjectsSection,
        if (lastReviewedAt != null)
          'lastReviewedAt': lastReviewedAt!.toIso8601String(),
      };

  factory CvReadiness.fromFirestore(Map<String, dynamic> map) => CvReadiness(
        hasSummary: map['hasSummary'] as bool? ?? false,
        hasExperienceSection:
            map['hasExperienceSection'] as bool? ?? false,
        hasEducationSection: map['hasEducationSection'] as bool? ?? false,
        hasSkillsSection: map['hasSkillsSection'] as bool? ?? false,
        hasProjectsSection: map['hasProjectsSection'] as bool? ?? false,
        lastReviewedAt: map['lastReviewedAt'] == null
            ? null
            : DateTime.tryParse(map['lastReviewedAt'] as String),
      );

  Map<String, dynamic> toMap() => toFirestore();
  factory CvReadiness.fromMap(Map<String, dynamic> map) =>
      CvReadiness.fromFirestore(map);
}

// ─── Career Readiness ─────────────────────────────────────────────────────────
//
// A DERIVED SNAPSHOT. Never authoritative. Always recomputed from the
// contexts above + the active CareerBlueprint, by the Readiness Engine.
// This model never calculates whether someone is job-ready.
//
// `overallScore` and `readinessLabel` are COMPATIBILITY / SUMMARY values
// preserved for existing callers. They are NOT the career-specific
// readiness decision. Do not present `readinessLabel == 'Job Ready'`
// as proof of job readiness.

class CareerReadiness {
  final double skillReadiness;     // 0–1
  final double learningReadiness;  // 0–1
  final double projectReadiness;   // 0–1
  final double interviewReadiness; // 0–1
  final double jobReadiness;       // 0–1
  final DateTime computedAt;

  /// Optional career scope. Null = unscoped (existing behaviour).
  final String? careerId;

  /// Optional derived portfolio snapshot.
  final PortfolioReadiness? portfolioReadiness;

  /// Optional derived CV snapshot.
  final CvReadiness? cvReadiness;

  /// Optional human-readable blockers (why the user is not yet ready).
  final List<String> blockers;

  /// Optional list of missing requirement keys/descriptions.
  final List<String> missingRequirements;

  /// Optional engine version that produced this snapshot.
  final String? engineVersion;

  const CareerReadiness({
    required this.skillReadiness,
    required this.learningReadiness,
    required this.projectReadiness,
    required this.interviewReadiness,
    required this.jobReadiness,
    required this.computedAt,
    this.careerId,
    this.portfolioReadiness,
    this.cvReadiness,
    this.blockers = const [],
    this.missingRequirements = const [],
    this.engineVersion,
  });

  /// COMPATIBILITY / SUMMARY VALUE — not the authoritative readiness
  /// decision. The Readiness Engine owns the real, career-specific
  /// computation against the CareerBlueprint. This getter remains so
  /// existing UI code keeps working; do not treat it as a source of truth.
  double get overallScore =>
      (skillReadiness +
          learningReadiness +
          projectReadiness +
          interviewReadiness +
          jobReadiness) /
      5;

  /// COMPATIBILITY / SUMMARY LABEL.
  ///
  /// This is NOT the authoritative career-specific "Job Ready" decision.
  /// It is a coarse presentation string derived from the compatibility
  /// [overallScore] getter above, kept only so existing UI callers keep
  /// compiling. The authoritative job-readiness decision is produced by
  /// the Readiness Engine against the CareerBlueprint and must NOT be
  /// inferred from this string.
  ///
  /// Note the deliberate "~" prefix below: the strings are still readable
  /// but are clearly qualified summaries, so a value of `'~ Job Ready'`
  /// cannot be mistaken for the authoritative `'Job Ready'` decision.
  String get readinessLabel {
    final s = overallScore;
    if (s >= 0.85) return '~ Job Ready';
    if (s >= 0.6) return '~ Almost There';
    if (s >= 0.3) return '~ Building Momentum';
    return '~ Just Starting';
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
        if (careerId != null) 'careerId': careerId,
        if (portfolioReadiness != null)
          'portfolioReadiness': portfolioReadiness!.toFirestore(),
        if (cvReadiness != null) 'cvReadiness': cvReadiness!.toFirestore(),
        if (blockers.isNotEmpty) 'blockers': blockers,
        if (missingRequirements.isNotEmpty)
          'missingRequirements': missingRequirements,
        if (engineVersion != null) 'engineVersion': engineVersion,
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
        careerId: map['careerId'] as String?,
        portfolioReadiness: map['portfolioReadiness'] == null
            ? null
            : PortfolioReadiness.fromFirestore(
                map['portfolioReadiness'] as Map<String, dynamic>),
        cvReadiness: map['cvReadiness'] == null
            ? null
            : CvReadiness.fromFirestore(
                map['cvReadiness'] as Map<String, dynamic>),
        blockers: List<String>.from(map['blockers'] as List? ?? const []),
        missingRequirements:
            List<String>.from(map['missingRequirements'] as List? ?? const []),
        engineVersion: map['engineVersion'] as String?,
      );

  Map<String, dynamic> toMap() => toFirestore();
  factory CareerReadiness.fromMap(Map<String, dynamic> map) =>
      CareerReadiness.fromFirestore(map);

  CareerReadiness copyWith({
    double? skillReadiness,
    double? learningReadiness,
    double? projectReadiness,
    double? interviewReadiness,
    double? jobReadiness,
    String? careerId,
    PortfolioReadiness? portfolioReadiness,
    CvReadiness? cvReadiness,
    List<String>? blockers,
    List<String>? missingRequirements,
    String? engineVersion,
  }) =>
      CareerReadiness(
        skillReadiness: skillReadiness ?? this.skillReadiness,
        learningReadiness: learningReadiness ?? this.learningReadiness,
        projectReadiness: projectReadiness ?? this.projectReadiness,
        interviewReadiness: interviewReadiness ?? this.interviewReadiness,
        jobReadiness: jobReadiness ?? this.jobReadiness,
        computedAt: DateTime.now(),
        careerId: careerId ?? this.careerId,
        portfolioReadiness: portfolioReadiness ?? this.portfolioReadiness,
        cvReadiness: cvReadiness ?? this.cvReadiness,
        blockers: blockers ?? this.blockers,
        missingRequirements: missingRequirements ?? this.missingRequirements,
        engineVersion: engineVersion ?? this.engineVersion,
      );
}

// ─── Next Best Action ──────────────────────────────────────────────────────────
//
// Represents ONE executable next step. The decision (which action is best)
// is owned by the Next Best Action Engine. This model represents that
// decision, so the user can understand WHAT / WHY / HOW / OUTCOME.

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

  /// Optional career scope. Null = unscoped.
  final String? careerId;

  /// Structured explanation fields. Null = unspecified; existing UIs that
  /// only read `title`/`description` keep working.
  final String? what;
  final String? why;
  final String? how;
  final String? expectedOutcome;

  /// Optional requirement key this action addresses.
  final String? relatedRequirement;

  /// Optional opaque destination identifier.
  final String? destinationRef;

  /// Optional human-readable duration hint.
  final String? estimatedDuration;

  /// Optional evidence kind this action produces when completed.
  final SkillEvidenceType? completionEvidenceType;

  /// Optional state version tag for deterministic decisions.
  final String? stateVersion;

  const NextBestAction({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.priority = 2,
    this.relatedSkill,
    required this.createdAt,
    this.isCompleted = false,
    this.careerId,
    this.what,
    this.why,
    this.how,
    this.expectedOutcome,
    this.relatedRequirement,
    this.destinationRef,
    this.estimatedDuration,
    this.completionEvidenceType,
    this.stateVersion,
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
        if (careerId != null) 'careerId': careerId,
        if (what != null) 'what': what,
        if (why != null) 'why': why,
        if (how != null) 'how': how,
        if (expectedOutcome != null) 'expectedOutcome': expectedOutcome,
        if (relatedRequirement != null)
          'relatedRequirement': relatedRequirement,
        if (destinationRef != null) 'destinationRef': destinationRef,
        if (estimatedDuration != null)
          'estimatedDuration': estimatedDuration,
        if (completionEvidenceType != null)
          'completionEvidenceType': completionEvidenceType!.name,
        if (stateVersion != null) 'stateVersion': stateVersion,
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
        careerId: map['careerId'] as String?,
        what: map['what'] as String?,
        why: map['why'] as String?,
        how: map['how'] as String?,
        expectedOutcome: map['expectedOutcome'] as String?,
        relatedRequirement: map['relatedRequirement'] as String?,
        destinationRef: map['destinationRef'] as String?,
        estimatedDuration: map['estimatedDuration'] as String?,
        completionEvidenceType: map['completionEvidenceType'] == null
            ? null
            : SkillEvidenceTypeExt.fromString(
                map['completionEvidenceType'] as String),
        stateVersion: map['stateVersion'] as String?,
      );

  Map<String, dynamic> toMap() => toFirestore();
  factory NextBestAction.fromMap(Map<String, dynamic> map) =>
      NextBestAction.fromFirestore(map);

  NextBestAction copyWith({
    bool? isCompleted,
    String? title,
    String? description,
    int? priority,
    String? stateVersion,
  }) =>
      NextBestAction(
        id: id,
        type: type,
        title: title ?? this.title,
        description: description ?? this.description,
        priority: priority ?? this.priority,
        relatedSkill: relatedSkill,
        createdAt: createdAt,
        isCompleted: isCompleted ?? this.isCompleted,
        careerId: careerId,
        what: what,
        why: why,
        how: how,
        expectedOutcome: expectedOutcome,
        relatedRequirement: relatedRequirement,
        destinationRef: destinationRef,
        estimatedDuration: estimatedDuration,
        completionEvidenceType: completionEvidenceType,
        stateVersion: stateVersion ?? this.stateVersion,
      );
}

// ─── Copilot Recommendation ─────────────────────────────────────────────────────
//
// Represents evolving guidance. Recommendations are generated fresh as
// progress changes and APPENDED to history (old ones marked `isDismissed`,
// never deleted). The recommendation engine owns the decision logic.

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

class CopilotRecommendation {
  final String id;
  final RecommendationCategory category;
  final String title;
  final String description;
  final int priority; // 1=highest
  final DateTime createdAt;
  final bool isDismissed;

  /// Optional career scope. Null = unscoped.
  final String? careerId;

  /// Structured explanation fields.
  final String? what;
  final String? why;
  final String? how;
  final String? expectedOutcome;

  /// Optional requirement key this recommendation relates to.
  final String? relatedRequirement;

  /// Optional state version tag for deterministic decisions.
  final String? stateVersion;

  const CopilotRecommendation({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    this.priority = 2,
    required this.createdAt,
    this.isDismissed = false,
    this.careerId,
    this.what,
    this.why,
    this.how,
    this.expectedOutcome,
    this.relatedRequirement,
    this.stateVersion,
  });

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'category': category.name,
        'title': title,
        'description': description,
        'priority': priority,
        'createdAt': createdAt.toIso8601String(),
        'isDismissed': isDismissed,
        if (careerId != null) 'careerId': careerId,
        if (what != null) 'what': what,
        if (why != null) 'why': why,
        if (how != null) 'how': how,
        if (expectedOutcome != null) 'expectedOutcome': expectedOutcome,
        if (relatedRequirement != null)
          'relatedRequirement': relatedRequirement,
        if (stateVersion != null) 'stateVersion': stateVersion,
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
        careerId: map['careerId'] as String?,
        what: map['what'] as String?,
        why: map['why'] as String?,
        how: map['how'] as String?,
        expectedOutcome: map['expectedOutcome'] as String?,
        relatedRequirement: map['relatedRequirement'] as String?,
        stateVersion: map['stateVersion'] as String?,
      );

  Map<String, dynamic> toMap() => toFirestore();
  factory CopilotRecommendation.fromMap(Map<String, dynamic> map) =>
      CopilotRecommendation.fromFirestore(map);

  CopilotRecommendation copyWith({
    bool? isDismissed,
    String? title,
    String? description,
    int? priority,
    String? stateVersion,
  }) =>
      CopilotRecommendation(
        id: id,
        category: category,
        title: title ?? this.title,
        description: description ?? this.description,
        priority: priority ?? this.priority,
        createdAt: createdAt,
        isDismissed: isDismissed ?? this.isDismissed,
        careerId: careerId,
        what: what,
        why: why,
        how: how,
        expectedOutcome: expectedOutcome,
        relatedRequirement: relatedRequirement,
        stateVersion: stateVersion ?? this.stateVersion,
      );
}

// ─── Copilot Context (aggregate READ MODEL) ────────────────────────────────────
//
// CopilotContext is an ASSEMBLED READ MODEL — the current runtime context
// the Copilot reasons from. It is NOT the permanent historical database.
//
//   • Historical evidence belongs in the authoritative evidence/event layer.
//   • Current aggregates belong in their dedicated aggregate documents.
//   • CopilotContext is assembled from those authoritative sources for
//     consumption by the UI / AI memory / Next Best Action engine.
//
// Serialization is preserved for backward compatibility with existing
// callers. It must not be treated as a replacement for the authoritative
// evidence/aggregate documents.

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

  /// Optional career blueprint the context was assembled against.
  final CareerBlueprint? blueprint;

  /// Optional current pipeline stage hint.
  final CareerStage? currentStage;

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
    this.blueprint,
    this.currentStage,
  })  : learningProgress = learningProgress ??
            LearningProgressContext(
              careerId: career?.careerId ?? '',
              totalLessons: 0,
              updatedAt: DateTime.now(),
            ),
        // Default progress contexts inherit the ACTIVE career id so career
        // scope is explicit and consistent across all aggregates. When no
        // career is active, careerId remains null (unscoped).
        projectProgress = projectProgress ??
            ProjectProgressContext(
              updatedAt: DateTime.now(),
              careerId: career?.careerId,
            ),
        jobProgress = jobProgress ??
            JobProgressContext(
              updatedAt: DateTime.now(),
              careerId: career?.careerId,
            ),
        interviewProgress = interviewProgress ??
            InterviewProgressContext(
              updatedAt: DateTime.now(),
              careerId: career?.careerId,
            ),
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
        if (blueprint != null) 'blueprint': blueprint!.toFirestore(),
        if (currentStage != null) 'currentStage': currentStage!.name,
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
      blueprint: map['blueprint'] == null
          ? null
          : CareerBlueprint.fromFirestore(
              map['blueprint'] as Map<String, dynamic>),
      currentStage: map['currentStage'] == null
          ? null
          : CareerStageExt.fromString(map['currentStage'] as String),
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
    CareerBlueprint? blueprint,
    CareerStage? currentStage,
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
        blueprint: blueprint ?? this.blueprint,
        currentStage: currentStage ?? this.currentStage,
      );
}