
// ══════════════════════════════════════════════════════════════════════
// lib/models/achievement_models.dart
// Achievement Engine models.
//
// Backward-compatible with the existing AchievementService rule engine
// and AchievementScreen UI. All Firestore field names are preserved so
// existing stored documents keep loading without migration.
//
// The model is intentionally simple: it carries display + persisted
// achievement state only. Unlock logic, progress calculation, and rule
// definitions live in AchievementService — never here.
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
  final double progress;       // 0.0–1.0, clamped
  final int progressTarget;    // >= 0
  final int progressCurrent;   // >= 0, <= progressTarget when target > 0

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

  /// Historical unlock is defined strictly by the presence of an
  /// [unlockedAt] timestamp. Current progress can never re-lock an
  /// achievement.
  bool get isUnlocked => unlockedAt != null;

  // ── Defensive Firestore parsing ────────────────────────────────────
  //
  // Every field is parsed defensively so one malformed stored value can
  // never crash the whole cabinet. Missing or invalid values fall back
  // to safe defaults that preserve the "locked, no progress" state
  // rather than inventing progress.
  factory Achievement.fromMap(Map<String, dynamic> map) {
    final rawId          = map['id'];
    final rawTitle       = map['title'];
    final rawDescription = map['description'];
    final rawIcon        = map['icon'];
    final rawRarity      = map['rarity'];
    final rawXpBonus     = map['xpBonus'];
    final rawUnlockedAt  = map['unlockedAt'];
    final rawProgress    = map['progress'];
    final rawTarget      = map['progressTarget'];
    final rawCurrent     = map['progressCurrent'];

    // Title/description/icon/id fall back to empty strings so a malformed
    // record never breaks parsing. The catalog still supplies the real
    // display values via _allWithProgress for known ids.
    final id          = rawId is String ? rawId : '';
    final title       = rawTitle is String ? rawTitle : '';
    final description = rawDescription is String ? rawDescription : '';
    final icon        = rawIcon is String ? rawIcon : '';

    final rarity = rawRarity is String
        ? AchievementRarity.values.firstWhere(
            (r) => r.name == rawRarity,
            orElse: () => AchievementRarity.common,
          )
        : AchievementRarity.common;

    final xpBonus = rawXpBonus is num
        ? rawXpBonus.toInt().clamp(0, 1000000)
        : 0;

    DateTime? unlockedAt;
    if (rawUnlockedAt is int) {
      unlockedAt = DateTime.fromMillisecondsSinceEpoch(rawUnlockedAt);
    } else if (rawUnlockedAt is num) {
      unlockedAt =
          DateTime.fromMillisecondsSinceEpoch(rawUnlockedAt.toInt());
    } else if (rawUnlockedAt is String) {
      unlockedAt = DateTime.tryParse(rawUnlockedAt);
    }

    // progress is stored as a 0.0–1.0 double, but tolerate 0–100 as well.
    double progress = 0;
    if (rawProgress is num) {
      final v = rawProgress.toDouble();
      if (!v.isNaN && !v.isInfinite) {
        progress = v > 1.0 ? (v / 100.0) : v;
      }
    }

    int progressTarget = 1;
    if (rawTarget is num) {
      final t = rawTarget.toInt();
      progressTarget = t < 0 ? 0 : t;
    }

    int progressCurrent = 0;
    if (rawCurrent is num) {
      final c = rawCurrent.toInt();
      progressCurrent = c < 0 ? 0 : c;
    }

    // Clamp progress to a safe [0, 1] range.
    progress = progress.clamp(0.0, 1.0);

    // Never let current exceed target when a target is defined.
    if (progressTarget > 0 && progressCurrent > progressTarget) {
      progressCurrent = progressTarget;
    }

    return Achievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      rarity: rarity,
      xpBonus: xpBonus,
      unlockedAt: unlockedAt,
      progress: progress,
      progressTarget: progressTarget,
      progressCurrent: progressCurrent,
    );
  }

  // ── Firestore serialization ────────────────────────────────────────
  //
  // Field names are preserved exactly as before so existing stored
  // documents remain readable and no migration is required.
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
//
// This is the single client-side source of achievement definitions. The
// AchievementService supplies the rule engine that unlocks them, and the
// AchievementScreen renders whatever this catalog plus the persisted
// unlock history produce. No other catalog should be created.
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