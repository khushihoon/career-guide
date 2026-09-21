// ══════════════════════════════════════════════════════════════════════
// lib/screens/analytics_screen.dart
//
// Analytics — READ-ONLY career insight layer.
//
// ARCHITECTURE
// ────────────
// This screen NEVER becomes a source of truth. It only presents:
//   • authoritative lifetime XP from CopilotFirestoreService.getUserTotalXp
//     (users/{uid}.totalXp),
//   • current streak / goals from the current Copilot architecture,
//   • career readiness from the existing CareerReadiness when available,
//   • declared skill levels from the current Copilot skill profile,
//     with the analytics/{uid}.skillMastery cache used ONLY to
//     supplement skills the profile does not already cover,
//   • historical weekly XP from analytics/{uid}, which is treated ONLY
//     as a derived cache and never overrides current authoritative data.
//
// It does not write XP, goals, skills, readiness, achievements, or quests.
// It does not compute a second XP, streak, career, readiness, or
// recommendation system.
//
// DATA OWNERSHIP
// ──────────────
//   • XP            → CopilotFirestoreService.getUserTotalXp(uid)
//   • Streak        → CopilotController.state.currentStreak
//   • Goals done    → CopilotFirestoreService.getTotalGoalsCompleted(uid)
//                     (falls back to analytics cache only when the
//                      authoritative read fails)
//   • Level         → LevelSystem.levelFor(authoritativeXp)
//   • Career        → CopilotController.state.skillProfile?.targetRole
//   • Readiness     → CopilotController.copilotContext?.readiness
//   • Skills        → CopilotController.state.skillProfile?.skills
//                     (SkillLevel shown as a declared level; never as
//                      an exact mastery percentage)
//   • Weekly XP     → analytics/{uid}.weeklyXp (historical cache)
//
// SEMANTIC HONESTY
// ────────────────
// The prior version rendered the declared SkillLevel as an exact
// "Skill Mastery %" — that overstated what the data actually says.
// Now:
//   • Skills from the current profile are shown as their declared
//     level (Beginner / Intermediate / Advanced / Expert) with a
//     coarse bar for orientation.
//   • Mastery percentages are shown ONLY when a real 0..1 mastery value
//     is present in the analytics cache for a skill the current profile
//     does not already cover.
//   • "Focus Area" is a display hint, not an authoritative skill gap.
//
// NEXT ACTION
// ───────────
// If the current Copilot architecture exposes a NextBestAction, it is
// presented here and routed to the best existing destination the current
// architecture allows. This screen never generates its own
// recommendation and never invents a route.
//
// EMPTY / ERROR STATE
// ───────────────────
// A single guarded state machine (loading / empty / data / error) keeps
// the screen useful even when the analytics/{uid} document is missing,
// partially populated, or malformed.
//
// This file uses the existing GlassCard / glassmorphism system, the
// existing flutter_animate setup, and the existing navigation pattern.
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/copilot_models.dart';
import '../services/copilot_provider.dart';
import '../services/copilot_controller.dart';
import '../services/copilot_firestore_service.dart';
import '../widgets/glassmorphism_card.dart';
import 'personalized_roadmap_screen.dart';
import 'skill_gap_screen.dart';
import 'progress_screen.dart';
import '../models/quest_models.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  static const _bg        = Color(0xFF0F0F1A);
  static const _primary   = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted     = Color(0xFF888899);

  // Derived / cached analytics loaded from analytics/{uid}. Never treated
  // as authoritative for any current value.
  _AnalyticsCache _cache = const _AnalyticsCache();

  // Authoritative lifetime XP — loaded from
  // CopilotFirestoreService.getUserTotalXp(uid). Null when the read has
  // not yet succeeded; the UI must not fabricate a value in that case.
  int? _authoritativeXp;

  // Authoritative lifetime goal count. Null until loaded.
  int? _authoritativeGoalsCompleted;

  bool _loading = true;
  bool _loadError = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadError = false;
        });
      }
      return;
    }

    // 1. Load the analytics cache defensively. Derived data only.
    _AnalyticsCache cache = const _AnalyticsCache();
    bool cacheError = false;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('analytics')
          .doc(uid)
          .get();
      if (doc.exists && doc.data() != null) {
        cache = _AnalyticsCache.fromFirestore(doc.data()!);
      }
    } catch (_) {
      cacheError = true;
    }

    // 2. Authoritative lifetime XP — same source used by the Copilot
    //    architecture (users/{uid}.totalXp). Never fabricated.
    int? xp;
    try {
      final v = await CopilotFirestoreService.getUserTotalXp(uid);
      if (v >= 0) xp = v;
    } catch (_) {
      xp = null;
    }

    // 3. Authoritative lifetime goal count.
    int? goals;
    try {
      goals = await CopilotFirestoreService.getTotalGoalsCompleted(uid);
    } catch (_) {
      goals = null;
    }

    if (!mounted) return;
    setState(() {
      _cache = cache;
      _authoritativeXp = xp;
      _authoritativeGoalsCompleted = goals;
      _loading = false;
      _loadError = cacheError && !cache.hasAnyData && xp == null && goals == null;
    });
  }

  // ── Derived view models ────────────────────────────────────────────

  /// The current career label from the canonical Copilot source, or null
  /// when the Copilot skill profile has not been created yet.
  String? _careerLabel(CopilotState? state) {
    return state?.skillProfile?.targetRole.label;
  }

  /// Current authoritative readiness when the Copilot context is
  /// available; null otherwise. This screen never invents a score.
  CareerReadiness? _readiness(CopilotController? ctrl) {
    return ctrl?.copilotContext?.readiness;
  }

  /// The current NextBestAction from the existing Copilot intelligence,
  /// or null when none is available.
  NextBestAction? _nextAction(CopilotController? ctrl) {
    final ctx = ctrl?.copilotContext;
    if (ctx == null || ctx.nextActions.isEmpty) return null;
    final incomplete = ctx.nextActions
        .where((a) => !a.isCompleted)
        .toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
    if (incomplete.isNotEmpty) return incomplete.first;
    final all = List<NextBestAction>.from(ctx.nextActions)
      ..sort((a, b) => a.priority.compareTo(b.priority));
    return all.isNotEmpty ? all.first : null;
  }

  /// The authoritative XP value to display. Prefers the freshly-read
  /// authoritative value; only falls back to the current Copilot state
  /// when that state already holds a trustworthy non-negative value.
  /// Returns null when neither is available, so the UI can present a
  /// neutral state instead of fabricating a number.
  int? _displayXp(CopilotState? state) {
    if (_authoritativeXp != null && _authoritativeXp! >= 0) {
      return _authoritativeXp;
    }
    final local = state?.totalXp;
    if (local != null && local >= 0) return local;
    return null;
  }

  int _totalGoalsForDisplay() {
    if (_authoritativeGoalsCompleted != null) {
      return _authoritativeGoalsCompleted!.clamp(0, 1 << 31);
    }
    return _cache.totalGoalsCompleted.clamp(0, 1 << 31);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl  = CopilotProvider.maybeOf(context);
    final state = ctrl?.state;

    final readiness  = _readiness(ctrl);
    final nextAction = _nextAction(ctrl);
    final career     = _careerLabel(state);
    final displayXp  = _displayXp(state);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Analytics',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _primary))
          : RefreshIndicator(
              color: _secondary,
              backgroundColor: const Color(0xFF1A1A2E),
              onRefresh: _load,
              child: _buildBody(
                state: state,
                readiness: readiness,
                nextAction: nextAction,
                career: career,
                displayXp: displayXp,
              ),
            ),
    );
  }

  Widget _buildBody({
    required CopilotState? state,
    required CareerReadiness? readiness,
    required NextBestAction? nextAction,
    required String? career,
    required int? displayXp,
  }) {
    final hasSkillData =
        (state?.skillProfile?.skills.isNotEmpty ?? false) ||
        _cache.skillMastery.isNotEmpty;

    final hasAnyData =
        state != null &&
        (state.hasProfile ||
            (displayXp ?? 0) > 0 ||
            state.currentStreak > 0 ||
            state.todayGoals.isNotEmpty) ||
        _cache.hasAnyData ||
        hasSkillData;

    if (!hasAnyData) {
      return _buildEmptyState(nextAction);
    }

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        // Career readiness (authoritative when available; otherwise a
        // neutral card that does not fabricate a score).
        _CareerReadinessCard(readiness: readiness)
            .animate()
            .fadeIn(),

        const SizedBox(height: 16),

        // Weekly XP chart (derived cache only).
        if (_cache.weeklyXp.isNotEmpty) ...[
          _WeeklyXpChart(weeks: _cache.weeklyXp)
              .animate()
              .fadeIn(delay: 100.ms),
          const SizedBox(height: 16),
        ],

        // Skill levels / mastery.
        if (hasSkillData) ...[
          _SkillLevelsCard(
            state: state,
            cacheMastery: _cache.skillMastery,
            career: career,
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16),
        ],

        // Focus area + next action.
        _FocusAreaCard(
          state: state,
          cacheMastery: _cache.skillMastery,
          nextAction: nextAction,
          onStart: _onStartNextAction,
        ).animate().fadeIn(delay: 260.ms),

        const SizedBox(height: 16),

        // Career progress summary (only real values).
        _CareerProgressCard(
          state: state,
          readiness: readiness,
        ).animate().fadeIn(delay: 320.ms),

        const SizedBox(height: 16),

        // Stats grid (authoritative XP / streak / goals / level).
        if (state != null) ...[
          _StatsGrid(
            state: state,
            displayXp: displayXp,
            totalGoals: _totalGoalsForDisplay(),
          ).animate().fadeIn(delay: 380.ms),
        ],

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildEmptyState(NextBestAction? nextAction) {
    final message = _loadError
        ? 'We couldn\'t load your analytics right now.'
        : 'Your career analytics are getting ready.';

    final subtitle = _loadError
        ? 'Pull down to try again, or continue learning in the meantime.'
        : 'Complete your first goal to start seeing your progress here.';

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 40),
        Center(
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_primary, _secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: _primary.withOpacity(0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.analytics_outlined,
                color: Colors.white, size: 42),
          ),
        ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
        const SizedBox(height: 24),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _muted, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 24),
        if (nextAction != null)
          GlassCard(
            gradientColors: [
              _primary.withOpacity(0.14),
              _primary.withOpacity(0.04),
            ],
            borderColor: _primary.withOpacity(0.35),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your next move',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(nextAction.title,
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => _onStartNextAction(nextAction),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Start',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Route the existing NextBestAction to the best-matching existing
  // destination that the current architecture already provides. The
  // NextBestAction model only exposes a coarse action type, so where the
  // current architecture has a corresponding screen we route there;
  // otherwise we fall back safely to PersonalizedRoadmapScreen. No new
  // screens, no new routing system, no duplicated Copilot logic.
  void _onStartNextAction(NextBestAction? action) {
    if (action == null) {
      _go(const PersonalizedRoadmapScreen());
      return;
    }
    switch (action.type) {
      case NextActionType.skillReview:
        // Skill-focused action → existing skill-gap screen.
        _go(const SkillGapScreen());
        break;
      case NextActionType.lesson:
        // Learning-path action → existing roadmap screen.
        _go(const PersonalizedRoadmapScreen());
        break;
      case NextActionType.project:
      case NextActionType.interview:
      case NextActionType.application:
        // Progress-oriented actions → existing progress screen.
        _go(const ProgressScreen());
        break;
      default:
        _go(const PersonalizedRoadmapScreen());
    }
  }

  void _go(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

// ══════════════════════════════════════════════════════════════════════
// DERIVED CACHE MODEL
// ══════════════════════════════════════════════════════════════════════

class _AnalyticsCache {
  final List<WeeklyXp> weeklyXp;
  final Map<String, double> skillMastery;
  final int totalGoalsCompleted;

  const _AnalyticsCache({
    this.weeklyXp = const [],
    this.skillMastery = const {},
    this.totalGoalsCompleted = 0,
  });

  bool get hasAnyData =>
      weeklyXp.isNotEmpty || skillMastery.isNotEmpty || totalGoalsCompleted > 0;

  factory _AnalyticsCache.fromFirestore(Map<String, dynamic> data) {
    // Defensive numeric conversions — never trust a raw cast.
    final weekly = <WeeklyXp>[];
    final rawWeekly = data['weeklyXp'];
    if (rawWeekly is List) {
      for (final e in rawWeekly) {
        if (e is! Map) continue;
        try {
          final label = e['week']?.toString() ?? '';
          final xp    = _toInt(e['xp']);
          if (label.isEmpty) continue;
          weekly.add(WeeklyXp(weekLabel: label, xp: xp));
        } catch (_) {
          // Skip malformed entry; keep the rest.
        }
      }
    }

    final mastery = <String, double>{};
    final rawMastery = data['skillMastery'];
    if (rawMastery is Map) {
      rawMastery.forEach((k, v) {
        if (k is! String) return;
        final d = _toDouble(v);
        if (d == null) return;
        mastery[k] = d.clamp(0.0, 1.0);
      });
    }

    return _AnalyticsCache(
      weeklyXp: weekly,
      skillMastery: mastery,
      totalGoalsCompleted:
          _toInt(data['totalGoalsCompleted']).clamp(0, 1 << 31),
    );
  }
}

int _toInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) {
    final parsed = int.tryParse(v);
    if (parsed != null) return parsed;
    final dbl = double.tryParse(v);
    if (dbl != null) return dbl.toInt();
  }
  return 0;
}

double? _toDouble(dynamic v) {
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

class WeeklyXp {
  final String weekLabel;
  final int xp;
  const WeeklyXp({required this.weekLabel, required this.xp});
}

// ══════════════════════════════════════════════════════════════════════
// CAREER READINESS (presentational only — no formula here)
// ══════════════════════════════════════════════════════════════════════

class _CareerReadinessCard extends StatelessWidget {
  final CareerReadiness? readiness;
  const _CareerReadinessCard({required this.readiness});

  @override
  Widget build(BuildContext context) {
    // When the authoritative readiness is not yet available we present a
    // neutral, honest placeholder — never a fabricated score.
    if (readiness == null) {
      return GlassCard(
        gradientColors: [
          const Color(0xFF7C3AED).withOpacity(0.18),
          const Color(0xFFA78BFA).withOpacity(0.06),
        ],
        borderColor: const Color(0xFF7C3AED).withOpacity(0.35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Career Readiness',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              'Your readiness score will appear once your Copilot profile has been analysed.',
              style: TextStyle(
                  color: Color(0xFF888899), fontSize: 12, height: 1.5),
            ),
          ],
        ),
      );
    }

    final score = (readiness!.jobReadiness * 100).clamp(0, 100).round();
    final pct   = score / 100.0;
    final color = score >= 75
        ? const Color(0xFF6EE7B7)
        : score >= 50
            ? const Color(0xFFFBBF24)
            : const Color(0xFFF87171);

    return GlassCard(
      gradientColors: [
        const Color(0xFF7C3AED).withOpacity(0.18),
        const Color(0xFFA78BFA).withOpacity(0.06),
      ],
      borderColor: const Color(0xFF7C3AED).withOpacity(0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Career Readiness',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: pct,
                      strokeWidth: 7,
                      backgroundColor: const Color(0xFF2A2A40),
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                    Text(
                      '$score',
                      style: TextStyle(
                          color: color,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      score >= 75
                          ? 'Job-Ready'
                          : score >= 50
                              ? 'Progressing Well'
                              : 'Keep Building',
                      style: TextStyle(
                          color: color,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    _miniBar(
                      label: 'Learning',
                      value: readiness!.learningReadiness,
                      color: const Color(0xFF60A5FA),
                    ),
                    const SizedBox(height: 4),
                    _miniBar(
                      label: 'Skills',
                      value: readiness!.skillReadiness,
                      color: const Color(0xFFA78BFA),
                    ),
                    const SizedBox(height: 4),
                    _miniBar(
                      label: 'Projects',
                      value: readiness!.projectReadiness,
                      color: const Color(0xFFF59E0B),
                    ),
                    const SizedBox(height: 4),
                    _miniBar(
                      label: 'Interview',
                      value: readiness!.interviewReadiness,
                      color: const Color(0xFF4ADE80),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniBar({
    required String label,
    required double value,
    required Color color,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 62,
          child: Text(label,
              style: const TextStyle(color: Color(0xFF888899), fontSize: 10)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: const Color(0xFF2A2A40),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 32,
          child: Text(
            '${(value * 100).clamp(0, 100).round()}%',
            style: TextStyle(
                color: color, fontSize: 10, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// WEEKLY XP CHART (historical cache)
// ══════════════════════════════════════════════════════════════════════

class _WeeklyXpChart extends StatelessWidget {
  final List<WeeklyXp> weeks;
  const _WeeklyXpChart({required this.weeks});

  @override
  Widget build(BuildContext context) {
    if (weeks.isEmpty) return const SizedBox.shrink();

    final maxXp = weeks.map((w) => w.xp).fold<int>(0, (a, b) => a > b ? a : b);
    final show  = weeks.length > 8 ? weeks.sublist(weeks.length - 8) : weeks;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weekly XP',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: show.map((w) {
                final frac = maxXp == 0 ? 0.0 : w.xp / maxXp;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: (80 * frac).clamp(4.0, 80.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF7C3AED),
                                Color(0xFFA78BFA),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          w.weekLabel.replaceAll('Jun ', ''),
                          style: const TextStyle(
                              color: Color(0xFF888899), fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// SKILL LEVELS / MASTERY
// ══════════════════════════════════════════════════════════════════════
//
// Declared SkillLevel from the current Copilot profile is presented as
// a labelled level (Beginner / Intermediate / Advanced / Expert) with a
// coarse bar for orientation. A true mastery percentage is only shown
// when the analytics cache provides a 0..1 value for a skill the
// profile does not already cover. Nothing is fabricated.

class _SkillLevelsCard extends StatelessWidget {
  final CopilotState? state;
  final Map<String, double> cacheMastery;
  final String? career;

  const _SkillLevelsCard({
    required this.state,
    required this.cacheMastery,
    required this.career,
  });

  @override
  Widget build(BuildContext context) {
    final profileSkills = state?.skillProfile?.skills ?? const <UserSkill>[];

    // Declared skills from the profile, ordered by declared level
    // (highest first) for a natural reading order.
    final declared = List<UserSkill>.from(profileSkills)
      ..sort((a, b) => b.level.value.compareTo(a.level.value));

    // Cache-only mastery entries (skills the profile does not cover).
    final declaredNames = declared.map((s) => s.name.toLowerCase()).toSet();
    final cacheOnly = cacheMastery.entries
        .where((e) => !declaredNames.contains(e.key.toLowerCase()))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (declared.isEmpty && cacheOnly.isEmpty) {
      return const SizedBox.shrink();
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Skill Level',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              if (career != null && career!.isNotEmpty) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Text('· $career',
                      style: const TextStyle(
                          color: Color(0xFF888899), fontSize: 11),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          const Text('Your declared level for each skill',
              style: TextStyle(color: Color(0xFF888899), fontSize: 11)),
          const SizedBox(height: 14),

          // Declared skills — shown as a labelled level with a coarse bar.
          ...declared.take(6).map((s) => _DeclaredSkillRow(skill: s)),

          // Cache-only mastery entries, clearly labelled.
          if (cacheOnly.isNotEmpty) ...[
            if (declared.isNotEmpty) const SizedBox(height: 6),
            const Text(
              'Additional mastery data',
              style: TextStyle(
                  color: Color(0xFF888899),
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...cacheOnly.take(4).map((e) => _MasteryRow(
                  name: e.key,
                  value: e.value.clamp(0.0, 1.0),
                )),
          ],
        ],
      ),
    );
  }
}

/// Row for a declared SkillLevel. This never claims a mastery
/// percentage; it shows the actual declared level label and a coarse
/// bar for visual orientation only.
class _DeclaredSkillRow extends StatelessWidget {
  final UserSkill skill;
  const _DeclaredSkillRow({required this.skill});

  /// Coarse visual width for the bar, derived from the declared level.
  /// This is a UI hint only — NOT a mastery score.
  double get _coarseFraction {
    switch (skill.level) {
      case SkillLevel.beginner:     return 0.25;
      case SkillLevel.intermediate: return 0.55;
      case SkillLevel.advanced:     return 0.80;
      case SkillLevel.expert:       return 1.00;
    }
  }

  Color get _color {
    switch (skill.level) {
      case SkillLevel.beginner:     return const Color(0xFFF59E0B);
      case SkillLevel.intermediate: return const Color(0xFF7C3AED);
      case SkillLevel.advanced:     return const Color(0xFF6EE7B7);
      case SkillLevel.expert:       return const Color(0xFF60A5FA);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(skill.name,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12)),
              ),
              Text(
                skill.level.label,
                style: TextStyle(
                    color: _color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: _coarseFraction,
              minHeight: 5,
              backgroundColor: const Color(0xFF2A2A40),
              valueColor: AlwaysStoppedAnimation(_color),
            ),
          ),
        ],
      ),
    );
  }
}

/// Row for a real 0..1 mastery value from the analytics cache. Only
/// shown for skills the current profile does not already declare.
class _MasteryRow extends StatelessWidget {
  final String name;
  final double value;
  const _MasteryRow({required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    final color = value >= 0.8
        ? const Color(0xFF6EE7B7)
        : value >= 0.5
            ? const Color(0xFF7C3AED)
            : const Color(0xFFF59E0B);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(name,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12)),
              ),
              Text(
                '${(value * 100).clamp(0, 100).round()}%',
                style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 5,
              backgroundColor: const Color(0xFF2A2A40),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// FOCUS AREA / NEXT ACTION
// ══════════════════════════════════════════════════════════════════════

class _FocusAreaCard extends StatelessWidget {
  final CopilotState? state;
  final Map<String, double> cacheMastery;
  final NextBestAction? nextAction;
  final void Function(NextBestAction?) onStart;

  const _FocusAreaCard({
    required this.state,
    required this.cacheMastery,
    required this.nextAction,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    // Determine a "focus area" hint. This is a UI hint only and never
    // claims to be an authoritative skill gap.
    //   1. Prefer an explicit Copilot skillReview action if present.
    //   2. Otherwise, fall back to the weakest declared skill from the
    //      current Copilot profile.
    //   3. Otherwise, fall back to the weakest cache mastery entry.
    // If none of these exist and there is no next action, omit the card.
    String? focusName;
    String? focusLabel;

    if (nextAction != null && nextAction!.type == NextActionType.skillReview) {
      focusName = nextAction!.title;
      focusLabel = 'Copilot suggested skill focus';
    } else {
      final profileSkills = state?.skillProfile?.skills ?? const <UserSkill>[];
      if (profileSkills.isNotEmpty) {
        final weakest = profileSkills.reduce(
            (a, b) => a.level.value <= b.level.value ? a : b);
        focusName = weakest.name;
        focusLabel = 'One of your lowest declared skills';
      } else if (cacheMastery.isNotEmpty) {
        final weakestEntry = cacheMastery.entries
            .reduce((a, b) => a.value <= b.value ? a : b);
        focusName = weakestEntry.key;
        focusLabel = 'One of your lowest mastery signals';
      }
    }

    if (focusName == null && nextAction == null) {
      return const SizedBox.shrink();
    }

    return GlassCard(
      gradientColors: [
        const Color(0xFF7C3AED).withOpacity(0.14),
        const Color(0xFF7C3AED).withOpacity(0.04),
      ],
      borderColor: const Color(0xFF7C3AED).withOpacity(0.30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Focus Area',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (focusName != null) ...[
            Text(focusName,
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            if (focusLabel != null) ...[
              const SizedBox(height: 4),
              Text(focusLabel,
                  style: const TextStyle(
                      color: Color(0xFF888899), fontSize: 11)),
            ],
          ],
          if (nextAction != null) ...[
            const SizedBox(height: 12),
            const Text('Your next Copilot action',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(nextAction!.title,
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
            if (nextAction!.description.trim().isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(nextAction!.description,
                  style: const TextStyle(
                      color: Color(0xFF888899), fontSize: 11, height: 1.4)),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => onStart(nextAction),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Start',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            const Text(
              'Keep an eye on this skill — practice it in your next session.',
              style: TextStyle(
                  color: Color(0xFF888899), fontSize: 11, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// CAREER PROGRESS SUMMARY
// ══════════════════════════════════════════════════════════════════════

class _CareerProgressCard extends StatelessWidget {
  final CopilotState? state;
  final CareerReadiness? readiness;
  const _CareerProgressCard({required this.state, required this.readiness});

  @override
  Widget build(BuildContext context) {
    // Only show rows we can genuinely populate. Never fabricate values.
    final rows = <Widget>[];

    if (readiness != null) {
      rows.add(_row('Learning', readiness!.learningReadiness,
          const Color(0xFF60A5FA)));
      rows.add(_row('Skills', readiness!.skillReadiness,
          const Color(0xFFA78BFA)));
      rows.add(_row('Projects', readiness!.projectReadiness,
          const Color(0xFFF59E0B)));
      rows.add(_row('Interview', readiness!.interviewReadiness,
          const Color(0xFF4ADE80)));
    }

    // Roadmap progress from the current Copilot state.
    final roadmap = state?.roadmap;
    if (roadmap != null) {
      rows.add(_row('Roadmap', roadmap.overallProgress,
          const Color(0xFF7C3AED)));
    }

    if (rows.isEmpty) return const SizedBox.shrink();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Where you are',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Progress across your career journey',
              style: TextStyle(color: Color(0xFF888899), fontSize: 11)),
          const SizedBox(height: 14),
          ...rows,
        ],
      ),
    );
  }

  Widget _row(String label, double value, Color color) {
    final v = value.clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: v,
                minHeight: 5,
                backgroundColor: const Color(0xFF2A2A40),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              '${(v * 100).round()}%',
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// STATS GRID
// ══════════════════════════════════════════════════════════════════════

class _StatsGrid extends StatelessWidget {
  final CopilotState state;
  final int? displayXp;
  final int totalGoals;

  const _StatsGrid({
    required this.state,
    required this.displayXp,
    required this.totalGoals,
  });

  @override
  Widget build(BuildContext context) {
    final xpText = displayXp != null ? '$displayXp' : '—';
    final levelText =
        displayXp != null ? '${LevelSystem.levelFor(displayXp!)}' : '—';

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _StatCell('🔥', '${state.currentStreak}', 'Current Streak'),
        _StatCell('⚡', xpText, 'Total XP'),
        _StatCell('✅', '$totalGoals', 'Goals Completed'),
        _StatCell('🏆', levelText, 'Current Level'),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  const _StatCell(this.emoji, this.value, this.label);

  @override
  Widget build(BuildContext context) => GlassCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF888899), fontSize: 10)),
          ],
        ),
      );
}