
// ══════════════════════════════════════════════════════════════════════
// lib/models/quest_models.dart
// Quest / Mission system models + AI Memory, Leveling, Leaderboard,
// and Analytics helper models.
//
// Defensive parsing pass: fromMap factories now tolerate missing, null,
// malformed, or wrong-type Firestore values with sensible defaults.
// Public classes, fields, enum names, XP values, and LevelSystem
// thresholds/titles are unchanged.
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
      progressTarget <= 0
          ? 0.0
          : (progressCurrent / progressTarget).clamp(0.0, 1.0);

  /// Defensive parse. Missing or malformed fields fall back to safe
  /// defaults; never throws on a single bad record.
  factory Quest.fromMap(Map<String, dynamic> map) {
    // --- id / title / description ---
    final id          = map['id'] is String ? map['id'] as String : '';
    final title       = map['title'] is String ? map['title'] as String : '';
    final description =
        map['description'] is String ? map['description'] as String : '';

    // --- type / status ---
    final rawType = map['type'];
    final type = rawType is String
        ? QuestType.values.firstWhere(
            (t) => t.name == rawType,
            orElse: () => QuestType.daily,
          )
        : QuestType.daily;

    final rawStatus = map['status'];
    final status = rawStatus is String
        ? QuestStatus.values.firstWhere(
            (s) => s.name == rawStatus,
            orElse: () => QuestStatus.active,
          )
        : QuestStatus.active;

    // --- xpReward ---
    final rawXp = map['xpReward'];
    final xpReward = rawXp is num ? rawXp.toInt() : 50;

    // --- progressCurrent / progressTarget, sanitized ---
    final rawTarget = map['progressTarget'];
    int progressTarget = rawTarget is num ? rawTarget.toInt() : 1;
    if (progressTarget < 0) progressTarget = 0;

    final rawCurrent = map['progressCurrent'];
    int progressCurrent = rawCurrent is num ? rawCurrent.toInt() : 0;
    if (progressCurrent < 0) progressCurrent = 0;
    if (progressTarget > 0 && progressCurrent > progressTarget) {
      progressCurrent = progressTarget;
    }

    // --- expiresAt, defensive ---
    final rawExpires = map['expiresAt'];
    DateTime expiresAt;
    if (rawExpires is int) {
      expiresAt = DateTime.fromMillisecondsSinceEpoch(rawExpires);
    } else if (rawExpires is num) {
      expiresAt = DateTime.fromMillisecondsSinceEpoch(rawExpires.toInt());
    } else if (rawExpires is String) {
      expiresAt = DateTime.tryParse(rawExpires) ??
          DateTime.now().add(const Duration(days: 1));
    } else {
      expiresAt = DateTime.now().add(const Duration(days: 1));
    }

    // --- optional fields ---
    final badgeId = map['badgeId'] is String ? map['badgeId'] as String : null;
    final isAiGenerated =
        map['isAiGenerated'] is bool ? map['isAiGenerated'] as bool : false;

    return Quest(
      id: id,
      title: title,
      description: description,
      type: type,
      status: status,
      xpReward: xpReward,
      progressCurrent: progressCurrent,
      progressTarget: progressTarget,
      expiresAt: expiresAt,
      badgeId: badgeId,
      isAiGenerated: isAiGenerated,
    );
  }

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

  factory AiMemory.fromMap(Map<String, dynamic> map) {
    // Safe list parsing: only accept List, and keep only string entries.
    List<String> readStringList(dynamic raw) {
      if (raw is! List) return const [];
      final out = <String>[];
      for (final e in raw) {
        if (e is String) out.add(e);
      }
      return out;
    }

    final rawAdviceDate = map['lastAdviceDate'];
    DateTime? lastAdviceDate;
    if (rawAdviceDate is int) {
      lastAdviceDate =
          DateTime.fromMillisecondsSinceEpoch(rawAdviceDate);
    } else if (rawAdviceDate is num) {
      lastAdviceDate =
          DateTime.fromMillisecondsSinceEpoch(rawAdviceDate.toInt());
    }

    return AiMemory(
      goals: readStringList(map['goals']),
      interests: readStringList(map['interests']),
      recentAchievements: readStringList(map['recentAchievements']),
      companionName:
          map['companionName'] is String ? map['companionName'] as String : null,
      lastAdvice:
          map['lastAdvice'] is String ? map['lastAdvice'] as String : null,
      lastAdviceDate: lastAdviceDate,
      contextSummary:
          map['contextSummary'] is String ? map['contextSummary'] as String : '',
    );
  }

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
    final range = levelEnd - levelStart;
    if (range <= 0) return 0.0;
    return ((xp - levelStart) / range).clamp(0.0, 1.0);
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

  /// Defensive parse. [docId] is always used as the uid so the caller
  /// can trust the returned entry's identity even if the map is
  /// malformed.
  factory LeaderboardEntry.fromMap(
    Map<String, dynamic> map,
    String docId,
  ) {
    final displayName =
        map['displayName'] is String ? map['displayName'] as String : '';
    final photoUrl =
        map['photoUrl'] is String ? map['photoUrl'] as String : null;

    final rawTotalXp   = map['totalXp'];
    final rawLevel     = map['level'];
    final rawRank      = map['rank'];
    final rawWeeklyXp  = map['weeklyXp'];

    int totalXp  = rawTotalXp  is num ? rawTotalXp.toInt()  : 0;
    int level    = rawLevel    is num ? rawLevel.toInt()    : 1;
    int rank     = rawRank     is num ? rawRank.toInt()     : 0;
    int weeklyXp = rawWeeklyXp is num ? rawWeeklyXp.toInt() : 0;

    if (totalXp  < 0) totalXp  = 0;
    if (level    < 1) level    = 1;
    if (rank     < 0) rank     = 0;
    if (weeklyXp < 0) weeklyXp = 0;

    final isCurrentUser =
        map['isCurrentUser'] is bool ? map['isCurrentUser'] as bool : false;

    return LeaderboardEntry(
      uid: docId,
      displayName: displayName,
      photoUrl: photoUrl,
      totalXp: totalXp,
      level: level,
      rank: rank,
      weeklyXp: weeklyXp,
      isCurrentUser: isCurrentUser,
    );
  }
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