// ══════════════════════════════════════════════════════════════════════
// lib/models/achievement_models.dart
// NEW — Achievement Engine models
// ══════════════════════════════════════════════════════════════════════

enum AchievementRarity { common, rare, epic, legendary }

extension AchievementRarityX on AchievementRarity {
  String get label {
    switch (this) {
      case AchievementRarity.common:    return 'Common';
      case AchievementRarity.rare:      return 'Rare';
      case AchievementRarity.epic:      return 'Epic';
      case AchievementRarity.legendary: return 'Legendary';
    }
  }

  // Gradient colors per rarity
  List<int> get gradientHex {
    switch (this) {
      case AchievementRarity.common:    return [0xFF6B7280, 0xFF9CA3AF];
      case AchievementRarity.rare:      return [0xFF3B82F6, 0xFF60A5FA];
      case AchievementRarity.epic:      return [0xFF7C3AED, 0xFFA78BFA];
      case AchievementRarity.legendary: return [0xFFF59E0B, 0xFFFBBF24];
    }
  }

  int get xpBonus {
    switch (this) {
      case AchievementRarity.common:    return 25;
      case AchievementRarity.rare:      return 75;
      case AchievementRarity.epic:      return 200;
      case AchievementRarity.legendary: return 500;
    }
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;           // emoji or asset path
  final AchievementRarity rarity;
  final int xpBonus;
  final DateTime? unlockedAt;
  final double progress;       // 0.0–1.0 for in-progress
  final int progressTarget;
  final int progressCurrent;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.rarity,
    required this.xpBonus,
    this.unlockedAt,
    this.progress = 0,
    this.progressTarget = 1,
    this.progressCurrent = 0,
  });

  bool get isUnlocked => unlockedAt != null;

  factory Achievement.fromMap(Map<String, dynamic> map) => Achievement(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        icon: map['icon'] as String,
        rarity: AchievementRarity.values.firstWhere(
          (r) => r.name == (map['rarity'] as String),
          orElse: () => AchievementRarity.common,
        ),
        xpBonus: (map['xpBonus'] as int?) ?? 25,
        unlockedAt: map['unlockedAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                map['unlockedAt'] as int)
            : null,
        progress: (map['progress'] as num?)?.toDouble() ?? 0,
        progressTarget: (map['progressTarget'] as int?) ?? 1,
        progressCurrent: (map['progressCurrent'] as int?) ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'icon': icon,
        'rarity': rarity.name,
        'xpBonus': xpBonus,
        if (unlockedAt != null)
          'unlockedAt': unlockedAt!.millisecondsSinceEpoch,
        'progress': progress,
        'progressTarget': progressTarget,
        'progressCurrent': progressCurrent,
      };
}

// ── Catalog of all achievements (used client-side) ─────────────────────
class AchievementCatalog {
  static const List<Achievement> all = [
    // ── Common ──────────────────────────────────────────────────────
    Achievement(
      id: 'first_goal',
      title: 'First Step',
      description: 'Complete your very first daily goal',
      icon: '👣',
      rarity: AchievementRarity.common,
      xpBonus: 25,
      progressTarget: 1,
    ),
    Achievement(
      id: 'profile_complete',
      title: 'Know Thyself',
      description: 'Complete your skill profile',
      icon: '🗺️',
      rarity: AchievementRarity.common,
      xpBonus: 25,
      progressTarget: 1,
    ),
    Achievement(
      id: 'three_day_streak',
      title: 'On a Roll',
      description: 'Maintain a 3-day learning streak',
      icon: '🔥',
      rarity: AchievementRarity.common,
      xpBonus: 25,
      progressTarget: 3,
    ),
    Achievement(
      id: 'goals_5',
      title: 'Getting Serious',
      description: 'Complete 5 daily goals',
      icon: '✅',
      rarity: AchievementRarity.common,
      xpBonus: 25,
      progressTarget: 5,
    ),
    // ── Rare ────────────────────────────────────────────────────────
    Achievement(
      id: 'week_streak',
      title: 'Habit Forming',
      description: 'Maintain a 7-day learning streak',
      icon: '📅',
      rarity: AchievementRarity.rare,
      xpBonus: 75,
      progressTarget: 7,
    ),
    Achievement(
      id: 'goals_25',
      title: 'Goal Crusher',
      description: 'Complete 25 daily goals',
      icon: '💪',
      rarity: AchievementRarity.rare,
      xpBonus: 75,
      progressTarget: 25,
    ),
    Achievement(
      id: 'level_5',
      title: 'Rising Star',
      description: 'Reach Level 5',
      icon: '⭐',
      rarity: AchievementRarity.rare,
      xpBonus: 75,
      progressTarget: 5,
    ),
    Achievement(
      id: 'roadmap_started',
      title: 'Charting the Course',
      description: 'Begin your personalized roadmap',
      icon: '🗺️',
      rarity: AchievementRarity.rare,
      xpBonus: 75,
      progressTarget: 1,
    ),
    // ── Epic ────────────────────────────────────────────────────────
    Achievement(
      id: 'month_streak',
      title: 'Unstoppable',
      description: 'Maintain a 30-day learning streak',
      icon: '🌟',
      rarity: AchievementRarity.epic,
      xpBonus: 200,
      progressTarget: 30,
    ),
    Achievement(
      id: 'level_10',
      title: 'AI Practitioner',
      description: 'Reach Level 10',
      icon: '🤖',
      rarity: AchievementRarity.epic,
      xpBonus: 200,
      progressTarget: 10,
    ),
    Achievement(
      id: 'skill_mastered',
      title: 'Deep Diver',
      description: 'Achieve 100% mastery in one skill',
      icon: '🎯',
      rarity: AchievementRarity.epic,
      xpBonus: 200,
      progressTarget: 1,
    ),
    Achievement(
      id: 'goals_100',
      title: 'Century Grinder',
      description: 'Complete 100 daily goals',
      icon: '💯',
      rarity: AchievementRarity.epic,
      xpBonus: 200,
      progressTarget: 100,
    ),
    // ── Legendary ───────────────────────────────────────────────────
    Achievement(
      id: 'hundred_day_streak',
      title: 'Century Club',
      description: 'Maintain a 100-day learning streak',
      icon: '👑',
      rarity: AchievementRarity.legendary,
      xpBonus: 500,
      progressTarget: 100,
    ),
    Achievement(
      id: 'level_20',
      title: 'Copilot Elite',
      description: 'Reach Level 20',
      icon: '🏆',
      rarity: AchievementRarity.legendary,
      xpBonus: 500,
      progressTarget: 20,
    ),
    Achievement(
      id: 'top_10_global',
      title: 'Global Top 10',
      description: 'Reach the top 10 on the global leaderboard',
      icon: '🌍',
      rarity: AchievementRarity.legendary,
      xpBonus: 500,
      progressTarget: 1,
    ),
  ];

  static Achievement? findById(String id) {
    try {
      return all.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}