// ══════════════════════════════════════════════════════════════════════
// lib/models/quest_models.dart
// NEW — Quest / Mission system models
// ══════════════════════════════════════════════════════════════════════

enum QuestType { daily, weekly, monthly, bonus }
enum QuestStatus { locked, active, completed, expired }

extension QuestTypeX on QuestType {
  String get label {
    switch (this) {
      case QuestType.daily:   return 'Daily';
      case QuestType.weekly:  return 'Weekly';
      case QuestType.monthly: return 'Monthly';
      case QuestType.bonus:   return 'Bonus';
    }
  }

  String get emoji {
    switch (this) {
      case QuestType.daily:   return '🌅';
      case QuestType.weekly:  return '📅';
      case QuestType.monthly: return '🗓️';
      case QuestType.bonus:   return '⚡';
    }
  }

  int get baseXp {
    switch (this) {
      case QuestType.daily:   return 50;
      case QuestType.weekly:  return 250;
      case QuestType.monthly: return 1000;
      case QuestType.bonus:   return 150;
    }
  }
}

class Quest {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  final QuestStatus status;
  final int xpReward;
  final int progressCurrent;
  final int progressTarget;
  final DateTime expiresAt;
  final String? badgeId;        // optional achievement to unlock on complete
  final bool isAiGenerated;

  const Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.xpReward,
    required this.progressCurrent,
    required this.progressTarget,
    required this.expiresAt,
    this.badgeId,
    this.isAiGenerated = false,
  });

  bool get isCompleted => status == QuestStatus.completed;
  bool get isExpired   => status == QuestStatus.expired ||
      (DateTime.now().isAfter(expiresAt) && !isCompleted);

  double get progressPercent =>
      progressTarget == 0 ? 0 : (progressCurrent / progressTarget).clamp(0.0, 1.0);

  factory Quest.fromMap(Map<String, dynamic> map) => Quest(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        type: QuestType.values.firstWhere(
          (t) => t.name == (map['type'] as String),
          orElse: () => QuestType.daily,
        ),
        status: QuestStatus.values.firstWhere(
          (s) => s.name == (map['status'] as String),
          orElse: () => QuestStatus.active,
        ),
        xpReward: (map['xpReward'] as int?) ?? 50,
        progressCurrent: (map['progressCurrent'] as int?) ?? 0,
        progressTarget: (map['progressTarget'] as int?) ?? 1,
        expiresAt: DateTime.fromMillisecondsSinceEpoch(
            map['expiresAt'] as int),
        badgeId: map['badgeId'] as String?,
        isAiGenerated: (map['isAiGenerated'] as bool?) ?? false,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type.name,
        'status': status.name,
        'xpReward': xpReward,
        'progressCurrent': progressCurrent,
        'progressTarget': progressTarget,
        'expiresAt': expiresAt.millisecondsSinceEpoch,
        if (badgeId != null) 'badgeId': badgeId,
        'isAiGenerated': isAiGenerated,
      };

  Quest copyWith({
    QuestStatus? status,
    int? progressCurrent,
  }) =>
      Quest(
        id: id,
        title: title,
        description: description,
        type: type,
        status: status ?? this.status,
        xpReward: xpReward,
        progressCurrent: progressCurrent ?? this.progressCurrent,
        progressTarget: progressTarget,
        expiresAt: expiresAt,
        badgeId: badgeId,
        isAiGenerated: isAiGenerated,
      );
}

// ── AI Memory model ────────────────────────────────────────────────────
class AiMemory {
  final List<String> goals;
  final List<String> interests;
  final List<String> recentAchievements;
  final String? companionName;
  final String? lastAdvice;
  final DateTime? lastAdviceDate;
  final String contextSummary;

  const AiMemory({
    this.goals = const [],
    this.interests = const [],
    this.recentAchievements = const [],
    this.companionName,
    this.lastAdvice,
    this.lastAdviceDate,
    this.contextSummary = '',
  });

  factory AiMemory.fromMap(Map<String, dynamic> map) => AiMemory(
        goals: List<String>.from(map['goals'] as List? ?? []),
        interests: List<String>.from(map['interests'] as List? ?? []),
        recentAchievements:
            List<String>.from(map['recentAchievements'] as List? ?? []),
        companionName: map['companionName'] as String?,
        lastAdvice: map['lastAdvice'] as String?,
        lastAdviceDate: map['lastAdviceDate'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                map['lastAdviceDate'] as int)
            : null,
        contextSummary: (map['contextSummary'] as String?) ?? '',
      );

  Map<String, dynamic> toMap() => {
        'goals': goals,
        'interests': interests,
        'recentAchievements': recentAchievements,
        if (companionName != null) 'companionName': companionName,
        if (lastAdvice != null) 'lastAdvice': lastAdvice,
        if (lastAdviceDate != null)
          'lastAdviceDate': lastAdviceDate!.millisecondsSinceEpoch,
        'contextSummary': contextSummary,
      };
}

// ── Leveling system ────────────────────────────────────────────────────
class LevelSystem {
  static const List<int> _thresholds = [
    0, 200, 500, 1000, 2000, 3500, 5500, 8000, 11500, 16000,
    21000, 27000, 34000, 42000, 51000, 62000, 75000, 90000, 107000, 125000,
    145000, 167000, 192000, 220000, 250000,
    300000, 360000, 425000, 495000, 500000,
  ];

  static const List<String> _titles = [
    'Curious Beginner', 'Aspiring Learner', 'Skill Seeker',
    'Knowledge Builder', 'Dedicated Learner', 'Consistent Grinder',
    'Skill Crafter', 'AI Practitioner', 'Career Accelerator',
    'Rising Expert', 'AI Explorer', 'Deep Learner',
    'Tech Artisan', 'Pattern Recognizer', 'AI Specialist',
    'Systems Thinker', 'Senior Practitioner', 'Emerging Leader',
    'Domain Expert', 'Copilot Elite', 'Thought Leader',
    'AI Strategist', 'Knowledge Architect', 'Innovation Pioneer',
    'AI Visionary', 'Master Practitioner', 'Career Sage',
    'Industry Oracle', 'AI Luminary', 'Legend',
  ];

  /// Returns 1-based level for a given XP total
  static int levelFor(int xp) {
    int level = 1;
    for (int i = 1; i < _thresholds.length; i++) {
      if (xp >= _thresholds[i]) {
        level = i + 1;
      } else {
        break;
      }
    }
    return level.clamp(1, _titles.length);
  }

  static String titleFor(int xp) {
    final level = levelFor(xp);
    return _titles[(level - 1).clamp(0, _titles.length - 1)];
  }

  /// XP needed to reach the next level boundary
  static int xpForNextLevel(int xp) {
    final level = levelFor(xp);
    if (level >= _thresholds.length) return 0;
    return _thresholds[level] - xp;
  }

  /// Progress within current level (0.0–1.0)
  static double progressInLevel(int xp) {
    final level = levelFor(xp);
    if (level >= _thresholds.length) return 1.0;
    final levelStart = _thresholds[level - 1];
    final levelEnd   = _thresholds[level];
    return ((xp - levelStart) / (levelEnd - levelStart)).clamp(0.0, 1.0);
  }
}

// ── Leaderboard entry ──────────────────────────────────────────────────
class LeaderboardEntry {
  final String uid;
  final String displayName;
  final String? photoUrl;
  final int totalXp;
  final int level;
  final int rank;
  final int weeklyXp;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.uid,
    required this.displayName,
    this.photoUrl,
    required this.totalXp,
    required this.level,
    required this.rank,
    required this.weeklyXp,
    this.isCurrentUser = false,
  });

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map, String docId) =>
      LeaderboardEntry(
        uid: docId,
        displayName: map['displayName'] as String,
        photoUrl: map['photoUrl'] as String?,
        totalXp: (map['totalXp'] as int?) ?? 0,
        level: (map['level'] as int?) ?? 1,
        rank: (map['rank'] as int?) ?? 0,
        weeklyXp: (map['weeklyXp'] as int?) ?? 0,
      );
}

// ── Analytics snapshot ─────────────────────────────────────────────────
class AnalyticsSnapshot {
  final List<WeeklyXp> weeklyXp;
  final Map<String, double> skillMastery;
  final int careerReadinessScore;
  final double learningVelocity;     // avg XP/day last 7 days
  final int totalGoalsCompleted;
  final int totalSessionMinutes;

  const AnalyticsSnapshot({
    this.weeklyXp = const [],
    this.skillMastery = const {},
    this.careerReadinessScore = 0,
    this.learningVelocity = 0,
    this.totalGoalsCompleted = 0,
    this.totalSessionMinutes = 0,
  });
}

class WeeklyXp {
  final String weekLabel;   // "Jun W1"
  final int xp;
  const WeeklyXp({required this.weekLabel, required this.xp});
}