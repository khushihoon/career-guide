// ══════════════════════════════════════════════════════════════════════
// lib/screens/copilot_hub_screen.dart
//
// UPGRADED — AI Career Copilot / Career Command Center
//
// ARCHITECTURE (this revision)
// ──────────────────────────
// The Hub is a PRESENTATION + ORCHESTRATION layer. Every business rule
// remains owned by its authoritative service:
//
//   • CopilotController          — copilot state, analysis, goals,
//                                  skill gaps, roadmap, next intelligence
//   • CopilotFirestoreService    — authoritative persistence, exactly-once
//                                  goal completion, lifetime goal count,
//                                  historical career evidence
//   • RewardService              — daily reward, surprise reward, XP grant
//   • AchievementService         — achievement rules/unlocks
//   • QuestService               — quest generation/progress/claims
//   • AiMemoryService            — persistent career memory, greeting,
//                                  advice
//   • LeaderboardService         — leaderboard sync/rank
//
// The Hub never writes directly to Firestore, never duplicates XP or
// goal-completion logic, and never fabricates metrics.
//
// SOURCE OF TRUTH
// ───────────────
//   Firestore authoritative evidence
//     → CopilotFirestoreService
//     → CopilotController
//     → CopilotContext / CopilotState
//     → CopilotHubScreen UI
//
// The UI must NEVER become a competing source of truth.
//
// AUTHORITATIVE REFRESH AFTER XP-CHANGING ACTIONS
// ──────────────────────────────────────────────
// CopilotController.init(uid) intentionally returns early when the uid
// has not changed, so it cannot be used as a same-session refresh after
// a reward grant or goal completion. This file therefore uses the
// controller's existing public rerunAnalysis(uid) path — which first
// reconciles authoritative XP via refreshAuthoritativeState(uid) and
// then reloads the authoritative CopilotContext from Firestore-backed
// services — as the SINGLE authoritative refresh trigger, and then
// re-reads the resulting controller.state.
//
// The refresh flow:
//   1. (optional) rerunAnalysis(uid)  → authoritative controller refresh.
//   2. Read ctrl.state                 → authoritative Copilot state.
//   3. Sync memory, fetch memory,      → fresh greeting + advice.
//      generate greeting + advice.
//   4. Parallel load reward availability, quests, rank (each failure-safe).
//   5. Commit UI under the existing refresh epoch guard.
//
// WEEKLY XP
// ─────────
// The current architecture does NOT expose a real weekly-XP value to the
// Hub: CopilotState exposes only lifetime totalXp, and RewardService /
// QuestService / AchievementService do not surface a week-scoped total.
// To avoid fabricating or estimating a value, the Hub derives a
// week-to-date XP figure from the existing CopilotState.progressHistory,
// which already carries per-day xpEarned entries. This uses ONLY data
// the existing architecture already provides.
//
// NEXT MOVE — HONEST NAVIGATION
// ─────────────────────────────
// The current CopilotContext exposes a coarse NextActionType but no
// per-action destination, duration, or resource id. The Hub therefore
// presents the current NextBestAction verbatim (title + description) and
// routes to the closest existing screen that matches its type. The
// button is labelled contextually (e.g. "Start Fixing Now" for skill
// review) to reflect the action category — it opens the closest existing
// screen for that category.
//
// SKILL GAPS — SINGLE PRESENTATION
// ────────────────────────────────
// When the current NextBestAction is a skillReview, the "Your Next Move"
// card is the single primary surface for the top skill gap. The lower
// duplicate "Skill Gaps" preview section is intentionally NOT rendered on
// the Hub — the full authoritative skill-gap analysis lives on the
// existing SkillGapScreen, which remains the single detailed view.
//
// state.skillGaps is neither read-modify-written, recalculated, filtered,
// reset, nor replaced by this screen. The CopilotController continues to
// own skill-gap state end to end; this screen only decides whether to
// render a preview of it. When a genuine standalone skill-gap preview is
// desired in the future, it can be reintroduced without touching the
// underlying data architecture.
//
// RECOMMENDATIONS
// ───────────────
// The existing CopilotContext already contains a recommendation list.
// The Hub displays the active (non-dismissed) recommendations directly
// from that list — no new recommendation logic is generated here. If
// there are no recommendations, the section is omitted.
//
// DAILY GOAL XP DISPLAY
// ─────────────────────
// The Daily Goals card does NOT display an aggregate "XP today" figure
// derived by summing `goal.xpReward`. That sum is not authoritative: a
// goal's reward is a UI value, not proof of XP actually granted by
// Firestore, and can diverge from the authoritative lifetime XP. The
// per-goal `+N` chip on each goal tile remains, because it is the
// definition of that goal's reward. Authoritative XP remains displayed
// only in the header badge and Stats strip, sourced from
// CopilotState.totalXp.
//
// The existing _refreshEpoch guard prevents a slower older refresh from
// overwriting a newer one's UI. The existing _refreshing guard prevents
// concurrent duplicate refreshes. _claimingReward and _goalsInFlight
// prevent double-tap and concurrent actions.
//
// All previous behaviour is preserved:
//   • Next Move, Roadmap, AI Memory, Daily Reward, Surprise Reward,
//     Achievements, Leaderboard, Analytics, Pull-to-refresh, navigation.
//   • Optional services still fail independently.
//   • No stale values are shown after a successful reward action when
//     the authoritative refresh succeeds.
//   • If the authoritative refresh fails, no values are fabricated and
//     the Hub remains usable.
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/copilot_models.dart';
import '../models/quest_models.dart';
import '../models/achievement_models.dart';
import '../services/copilot_controller.dart';
import '../services/copilot_provider.dart';
import '../services/achievement_service.dart';
import '../services/ai_memory_service.dart';
import '../services/reward_service.dart';
import '../services/quest_service.dart';
import '../services/leaderboard_service.dart';
import '../services/copilot_firestore_service.dart';
import '../widgets/glassmorphism_card.dart';
import 'skill_profile_screen.dart';
import 'skill_gap_screen.dart';
import 'personalized_roadmap_screen.dart';
import 'progress_screen.dart';
import 'quest_screen.dart';
import 'achievement_screen.dart';
import 'leaderboard_screen.dart';
import 'analytics_screen.dart';
import 'reward_screen.dart';

class CopilotHubScreen extends StatefulWidget {
  const CopilotHubScreen({super.key});

  @override
  State<CopilotHubScreen> createState() => _CopilotHubScreenState();
}

class _CopilotHubScreenState extends State<CopilotHubScreen> {
  // ── Design tokens ──────────────────────────────────────────────────
  static const _bg        = Color(0xFF0F0F1A);
  static const _surface   = Color(0xFF1A1A2E);
  static const _border    = Color(0xFF2A2A40);
  static const _primary   = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted     = Color(0xFF888899);

  // ── Services ───────────────────────────────────────────────────────
  final _achievementService = AchievementService();
  final _memoryService      = AiMemoryService();
  final _rewardService      = RewardService();
  final _questService       = QuestService();
  final _leaderboardService = LeaderboardService();

  // ── State ──────────────────────────────────────────────────────────
  String? _uid;
  bool _initCalled = false;

  String _greeting        = '';
  String _advice          = '';
  bool   _canClaimReward  = false;
  int    _userRank        = 0;
  List<Quest> _quests     = const [];
  AiMemory _memory        = const AiMemory();

  /// Guards the whole refresh flow against concurrent duplicate requests
  /// (pull-to-refresh + action-triggered refresh).
  bool _refreshing = false;

  /// Guards daily reward claim against double-tap.
  bool _claimingReward = false;

  /// Guards per-goal toggling so a rapid double-tap cannot fire two
  /// concurrent transactions for the same goal.
  final Set<String> _goalsInFlight = <String>{};

  /// Guards background refreshes so a slow older refresh cannot overwrite
  /// a newer one's setState.
  int _refreshEpoch = 0;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initCalled) {
      _initCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (_uid != null && mounted) {
          CopilotProvider.maybeOf(context)?.init(_uid!);
          await _refreshAll();
        }
      });
    }
  }

  // ══════════════════════════════════════════════════════════════════
  // WEEKLY XP DERIVATION (existing architecture only)
  // ══════════════════════════════════════════════════════════════════

  /// Returns the user's week-to-date XP, derived ONLY from the existing
  /// `CopilotState.progressHistory` entries that already carry a per-day
  /// `xpEarned` value.
  ///
  /// This does NOT fabricate a value:
  ///   • It uses the same authoritative per-day XP the rest of the
  ///     intelligence pipeline already reads.
  ///   • It never substitutes a hardcoded placeholder.
  ///   • It returns 0 only when there genuinely is no history for this
  ///     week (a real, honest zero — not a fake placeholder).
  int _weeklyXpFromState(CopilotState? state) {
    final history = state?.progressHistory;
    if (history == null || history.isEmpty) return 0;

    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));

    var total = 0;
    for (final entry in history) {
      final d = entry.date;
      if (!d.isBefore(weekStart)) {
        total += entry.xpEarned;
      }
    }
    return total < 0 ? 0 : total;
  }

  // ══════════════════════════════════════════════════════════════════
  // REFRESH ORCHESTRATION
  // ══════════════════════════════════════════════════════════════════

  Future<void> _refreshAll({bool rerunAnalysis = false}) async {
    if (_uid == null) return;
    if (_refreshing) return;
    _refreshing = true;
    final epoch = ++_refreshEpoch;

    try {
      final ctrl = CopilotProvider.maybeOf(context);

      if (rerunAnalysis && ctrl != null) {
        try {
          await ctrl.rerunAnalysis(_uid!);
        } catch (_) {}
      }

      final state = ctrl?.state;

      if (state != null) {
        try {
          await _memoryService.syncFromProfile(_uid!, state);
        } catch (_) {}
      }

      AiMemory memory = const AiMemory();
      try {
        memory = await _memoryService.fetchMemory(_uid!);
      } catch (_) {}

      final level      = LevelSystem.levelFor(state?.totalXp ?? 0);
      final levelTitle = LevelSystem.titleFor(state?.totalXp ?? 0);
      final displayName =
          FirebaseAuth.instance.currentUser?.displayName ?? 'there';

      String greeting = '';
      String advice   = '';
      try {
        greeting = await _memoryService.getDailyGreeting(
          displayName: displayName,
          memory: memory,
          state: state ?? const CopilotState(),
          level: level,
          levelTitle: levelTitle,
        );
      } catch (_) {}
      try {
        advice = await _memoryService.getDailyAdvice(
          memory: memory,
          state: state ?? const CopilotState(),
          levelTitle: levelTitle,
        );
      } catch (_) {}

      final results = await Future.wait([
        _rewardService
            .canClaimDailyBox(_uid!)
            .catchError((_) => false),
        _questService
            .fetchQuests(_uid!)
            .catchError((_) => <Quest>[]),
        _leaderboardService
            .getCurrentUserRank(_uid!, state?.totalXp ?? 0)
            .catchError((_) => 0),
      ]);

      final canClaim = results[0] as bool;
      final quests   = results[1] as List<Quest>;
      final rank     = results[2] as int;

      if (!mounted || epoch != _refreshEpoch) return;
      setState(() {
        _memory         = memory;
        _greeting       = greeting;
        _advice         = advice;
        _canClaimReward = canClaim;
        _quests         = quests;
        _userRank       = rank;
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user != null && state != null) {
        try {
          await _leaderboardService.syncUserToLeaderboard(
            uid: _uid!,
            displayName: user.displayName ?? 'Learner',
            photoUrl: user.photoURL,
            totalXp: state.totalXp,
            level: level,
            weeklyXp: _weeklyXpFromState(state),
          );
        } catch (_) {}
      }
    } finally {
      _refreshing = false;
    }
  }

  // ══════════════════════════════════════════════════════════════════
  // GOAL TOGGLE
  // ══════════════════════════════════════════════════════════════════

  Future<void> _toggleGoalWithChecks(
      CopilotController ctrl, DailyGoal goal) async {
    final uid = _uid;
    if (uid == null) return;
    if (_goalsInFlight.contains(goal.id)) return;
    _goalsInFlight.add(goal.id);

    try {
      try {
        await ctrl.toggleGoal(uid, goal);
      } catch (_) {
        return;
      }
      if (!mounted) return;

      final state = ctrl.state;

      int lifetimeCompleted = 0;
      try {
        lifetimeCompleted =
            await CopilotFirestoreService.getTotalGoalsCompleted(uid);
      } catch (_) {}

      final level = LevelSystem.levelFor(state.totalXp);

      try {
        final newly = await _achievementService.checkAndUnlock(
          uid: uid,
          state: state,
          totalGoalsCompleted: lifetimeCompleted,
          currentLevel: level,
        );
        for (final a in newly) {
          if (mounted) AchievementToast.show(context, a);
        }
      } catch (_) {}

      final completedToday =
          state.todayGoals.where((g) => g.isCompleted).length;
      try {
        await _questService.onGoalCompleted(uid, completedToday);
      } catch (_) {}

      if (mounted) await _refreshAll(rerunAnalysis: true);
    } finally {
      _goalsInFlight.remove(goal.id);
    }
  }

  // ══════════════════════════════════════════════════════════════════
  // DAILY REWARD CLAIM
  // ══════════════════════════════════════════════════════════════════

  Future<void> _claimReward(int streak) async {
    final uid = _uid;
    if (uid == null) return;
    if (_claimingReward) return;
    _claimingReward = true;

    try {
      final result = await _rewardService.claimDailyBox(uid, streak);
      if (!mounted) return;
      if (result.xpAmount > 0) _showRewardSnack(result);
      setState(() => _canClaimReward = false);

      await _refreshAll(rerunAnalysis: true);
      if (!mounted) return;

      try {
        final ctrl  = CopilotProvider.maybeOf(context);
        final state = ctrl?.state;

        int lifetimeCompleted = 0;
        try {
          lifetimeCompleted =
              await CopilotFirestoreService.getTotalGoalsCompleted(uid);
        } catch (_) {}

        final level = LevelSystem.levelFor(state?.totalXp ?? 0);
        final newly = await _achievementService.checkAndUnlock(
          uid: uid,
          state: state ?? const CopilotState(),
          totalGoalsCompleted: lifetimeCompleted,
          currentLevel: level,
        );
        for (final a in newly) {
          if (mounted) AchievementToast.show(context, a);
        }
      } catch (_) {}
    } catch (_) {
      // Silently fail; reward availability will refresh on next load.
    } finally {
      _claimingReward = false;
    }
  }

  void _showRewardSnack(RewardResult result) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          Text(result.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text('${result.message} +${result.xpAmount} XP',
                style: const TextStyle(color: Colors.white)),
          ),
        ]),
        backgroundColor: _primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final ctrl = CopilotProvider.maybeOf(context);

    if (ctrl == null) {
      return const Scaffold(
        backgroundColor: _bg,
        body: Center(child: CircularProgressIndicator(color: _primary)),
      );
    }

    final state = ctrl.state;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: state.isLoading && !state.hasProfile
            ? _buildLoading()
            : !state.hasProfile
                ? _buildSetup()
                : _buildDashboard(state, ctrl),
      ),
    );
  }

  // ── Loading ────────────────────────────────────────────────────────
  Widget _buildLoading() => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: _primary),
            SizedBox(height: 16),
            Text('Setting up your Copilot…',
                style: TextStyle(color: _muted, fontSize: 14)),
          ],
        ),
      );

  // ── Setup ──────────────────────────────────────────────────────────
  Widget _buildSetup() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
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
                    color: _primary.withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.auto_awesome,
                  size: 42, color: Colors.white),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

            const SizedBox(height: 24),
            const Text('AI Career Copilot',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              'Your AI-powered career accelerator. Build skills, earn XP, climb the leaderboard and land your dream AI role.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 14, height: 1.5),
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 28),
            _featureRow(Icons.radar,        'Skill Gap Analysis'),
            const SizedBox(height: 10),
            _featureRow(Icons.route,        'Personalised Roadmap'),
            const SizedBox(height: 10),
            _featureRow(Icons.bolt,         'Daily Goals & XP'),
            const SizedBox(height: 10),
            _featureRow(Icons.emoji_events, 'Achievements & Badges'),
            const SizedBox(height: 10),
            _featureRow(Icons.leaderboard,  'Global Leaderboard'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => _go(const SkillProfileScreen()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rocket_launch, size: 18),
                    SizedBox(width: 8),
                    Text('Get Started',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.3),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(IconData icon, String text) => Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: _secondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style:
                    const TextStyle(color: Colors.white70, fontSize: 14)),
          ),
        ],
      );

  // ── Full Dashboard ─────────────────────────────────────────────────
  Widget _buildDashboard(CopilotState state, CopilotController ctrl) {
    final name = FirebaseAuth.instance.currentUser?.displayName
            ?.split(' ')
            .first ??
        'there';
    final totalXp = state.totalXp;
    final level   = LevelSystem.levelFor(totalXp);

    final copilotContext = ctrl.copilotContext;

    final activeRecommendations = (copilotContext?.recommendations ?? const [])
        .where((r) => !r.isDismissed)
        .toList();

    return RefreshIndicator(
      color: _secondary,
      backgroundColor: _surface,
      onRefresh: () => _refreshAll(rerunAnalysis: true),
      child: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greeting.isEmpty ? 'Hey $name 🤖' : _greeting,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          LevelSystem.titleFor(totalXp),
                          style: const TextStyle(
                              color: _secondary, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _xpBadge(totalXp, level),
                ],
              ).animate().fadeIn(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── XP Level Bar ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: XpProgressBar(totalXp: totalXp),
            ).animate().fadeIn(delay: 60.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 14)),

          // ── Stats strip ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _StatsStrip(state: state, rank: _userRank),
            ).animate().fadeIn(delay: 80.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── YOUR NEXT MOVE ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _NextMoveCard(
                state: state,
                copilotContext: copilotContext,
                onOpen: _onOpenNextMove,
              ),
            ).animate().fadeIn(delay: 90.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── Recommendations (from existing CopilotContext) ───────
          if (activeRecommendations.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _sectionHeader(
                    'Recommendations', Icons.lightbulb_outline, null),
              ).animate().fadeIn(delay: 95.ms),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: _RecommendationsPreview(
                  recommendations: activeRecommendations,
                  onDismiss: (id) => _dismissRecommendation(ctrl, id),
                ),
              ).animate().fadeIn(delay: 100.ms),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],

          // ── Daily Reward Box ─────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DailyRewardBox(
                canClaim: _canClaimReward,
                streak: state.currentStreak,
                onClaim: () => _claimReward(state.currentStreak),
              ),
            ).animate().fadeIn(delay: 100.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── AI Companion Card ────────────────────────────────────
          if (_advice.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CompanionCard(
                  greeting: _greeting.isEmpty
                      ? 'Ready to level up today?'
                      : _greeting,
                  advice: _advice,
                ),
              ).animate().fadeIn(delay: 120.ms),
            ),

          if (_advice.isNotEmpty)
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── Refreshing banner ────────────────────────────────────
          if (state.isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: _aiBanner(),
              ),
            ),

          // ── Error banner ─────────────────────────────────────────
          if (state.error != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: _errorBanner(state.error!),
              ),
            ),

          // ── Today's Goals ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionHeader("Today's Goals", Icons.today, null),
            ).animate().fadeIn(delay: 140.ms),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: _DailyGoalsCard(
                state: state,
                uid: _uid,
                onToggle: (goal) => _toggleGoalWithChecks(ctrl, goal),
              ),
            ).animate().fadeIn(delay: 160.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Daily Quests Preview ─────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionHeader(
                'Daily Quests',
                Icons.assignment,
                () => _go(const QuestScreen()),
              ),
            ).animate().fadeIn(delay: 180.ms),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: _QuestsPreview(quests: _quests),
            ).animate().fadeIn(delay: 200.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Skill Gaps ───────────────────────────────────────────
          //
          // The standalone Skill Gaps preview section has been removed
          // from the Hub. The full authoritative skill-gap analysis is
          // shown on the existing SkillGapScreen, which remains the
          // single detailed view. When the current NextBestAction is a
          // skillReview, "Your Next Move" is the single primary surface
          // for the top skill gap and routes to that same screen.
          //
          // state.skillGaps is unaffected by this removal — the
          // CopilotController continues to own it end to end.

          // ── Roadmap ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionHeader(
                'Roadmap',
                Icons.route,
                () => _go(const PersonalizedRoadmapScreen()),
              ),
            ).animate().fadeIn(delay: 260.ms),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: _RoadmapPreview(state: state),
            ).animate().fadeIn(delay: 280.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Leaderboard Teaser ───────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionHeader(
                'Leaderboard',
                Icons.leaderboard,
                () => _go(const LeaderboardScreen()),
              ),
            ).animate().fadeIn(delay: 300.ms),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: _LeaderboardTeaser(
                rank: _userRank,
                xp: state.totalXp,
                onTap: () => _go(const LeaderboardScreen()),
              ),
            ).animate().fadeIn(delay: 320.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Quick Actions ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _QuickActions(
                onProgress:     () => _go(const ProgressScreen()),
                onEdit:         () => _go(const SkillProfileScreen()),
                onRerun:        () => _refreshAll(rerunAnalysis: true),
                onAchievements: () => _go(const AchievementScreen()),
                onAnalytics:    () => _go(const AnalyticsScreen()),
                onLeaderboard:  () => _go(const LeaderboardScreen()),
              ),
            ).animate().fadeIn(delay: 360.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // ── Next Move navigation ───────────────────────────────────────────
  //
  // The current CopilotContext exposes only a coarse NextActionType —
  // no per-action destination, duration, resource id, or course id.
  // The Hub therefore routes to the closest existing category screen
  // that matches the action's type. The button label in the card is
  // contextual, but the routing here is unchanged.
  void _onOpenNextMove(NextBestAction? action) {
    if (!mounted) return;
    if (action == null) {
      _go(const PersonalizedRoadmapScreen());
      return;
    }
    switch (action.type) {
      case NextActionType.lesson:
        _go(const PersonalizedRoadmapScreen());
        break;
      case NextActionType.skillReview:
        _go(const SkillGapScreen());
        break;
      case NextActionType.project:
        _go(const ProgressScreen());
        break;
      case NextActionType.interview:
        _go(const ProgressScreen());
        break;
      case NextActionType.application:
        _go(const ProgressScreen());
        break;
      default:
        _go(const PersonalizedRoadmapScreen());
    }
  }

  // ── Recommendations ────────────────────────────────────────────────
  Future<void> _dismissRecommendation(
      CopilotController ctrl, String recommendationId) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      await ctrl.dismissRecommendation(uid, recommendationId);
    } catch (_) {}
    if (mounted) setState(() {});
  }

  // ── Shared helpers ────────────────────────────────────────────────

  Widget _sectionHeader(
      String title, IconData icon, VoidCallback? onSeeAll) {
    return Row(
      children: [
        Icon(icon, size: 17, color: _secondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Row(
              children: [
                Text('See all',
                    style: TextStyle(color: _secondary, fontSize: 13)),
                Icon(Icons.chevron_right, size: 16, color: _secondary),
              ],
            ),
          ),
      ],
    );
  }

  Widget _xpBadge(int xp, int level) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient:
              const LinearGradient(colors: [_primary, _secondary]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _primary.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Lv.$level',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            const Text('·',
                style: TextStyle(color: Colors.white54, fontSize: 11)),
            const SizedBox(width: 4),
            const Icon(Icons.bolt, size: 13, color: Colors.white),
            const SizedBox(width: 2),
            Text('$xp',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      );

  Widget _aiBanner() => GlassCard(
        padding: const EdgeInsets.all(14),
        borderColor: _primary.withOpacity(0.3),
        gradientColors: [
          _primary.withOpacity(0.12),
          _primary.withOpacity(0.04),
        ],
        child: const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: _secondary),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text('Refreshing your Copilot intelligence…',
                  style: TextStyle(color: _secondary, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      );

  Widget _errorBanner(String error) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber,
                size: 16, color: Colors.redAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(error,
                  style: const TextStyle(
                      color: Colors.redAccent, fontSize: 12)),
            ),
          ],
        ),
      );

  void _go(Widget screen) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// PRIVATE WIDGETS
// ════════════════════════════════════════════════════════════════════

// ── Stats Strip ───────────────────────────────────────────────────────
class _StatsStrip extends StatelessWidget {
  final CopilotState state;
  final int rank;
  const _StatsStrip({required this.state, required this.rank});

  @override
  Widget build(BuildContext context) {
    final done  = state.todayGoals.where((g) => g.isCompleted).length;
    final total = state.todayGoals.length;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Row(
        children: [
          _item('🔥', '${state.currentStreak}', 'Streak'),
          _div(),
          _item('⚡', '${state.totalXp}', 'XP'),
          _div(),
          _item('✅', '$done/$total', 'Today'),
          _div(),
          _item('🌍', rank > 0 ? '#$rank' : '–', 'Rank'),
        ],
      ),
    );
  }

  Widget _item(String emoji, String val, String label) => Expanded(
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(val,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text(label,
                style:
                    const TextStyle(color: Color(0xFF888899), fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      );

  Widget _div() => Container(
      width: 1, height: 30, color: const Color(0xFF2A2A40));
}

// ── YOUR NEXT MOVE ────────────────────────────────────────────────────
class _NextMoveCard extends StatelessWidget {
  final CopilotState state;
  final CopilotContext? copilotContext;
  final void Function(NextBestAction? action) onOpen;

  const _NextMoveCard({
    required this.state,
    required this.copilotContext,
    required this.onOpen,
  });

  NextBestAction? get _bestAction {
    final ctx = copilotContext;
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

  String _typeLabel(NextActionType t) {
    switch (t) {
      case NextActionType.lesson:      return 'Lesson';
      case NextActionType.skillReview: return 'Skill Focus';
      case NextActionType.project:     return 'Project';
      case NextActionType.interview:   return 'Interview Practice';
      case NextActionType.application: return 'Application';
      default:                         return 'Next Step';
    }
  }

  /// Contextual button label. The label describes the action category —
  /// it does NOT change the routing or the underlying NextBestAction.
  /// For skill-review actions the label reads "Start Fixing Now" so the
  /// user understands this is the primary place to begin addressing the
  /// top skill gap. All other action types keep the neutral "Open".
  String _actionLabel(NextActionType t) {
    switch (t) {
      case NextActionType.skillReview: return 'Start Fixing Now';
      default:                          return 'Open';
    }
  }

  /// Contextual button icon to match [_actionLabel]. Kept minimal so the
  /// existing design language is preserved.
  IconData _actionIcon(NextActionType t) {
    switch (t) {
      case NextActionType.skillReview: return Icons.rocket_launch;
      default:                          return Icons.open_in_new;
    }
  }

  String? _youAreHere() {
    final role  = state.skillProfile?.targetRole.label;
    final phase = state.roadmap?.currentPhase;
    if (role != null && phase != null) {
      return '$role · Phase ${phase.phaseNumber + 1}: ${phase.title}';
    }
    if (role != null)  return role;
    if (phase != null) return 'Phase ${phase.phaseNumber + 1}: ${phase.title}';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final action = _bestAction;
    final here   = _youAreHere();

    if (action == null) {
      return GlassCard(
        padding: const EdgeInsets.all(18),
        borderColor: const Color(0xFF7C3AED).withOpacity(0.35),
        gradientColors: [
          const Color(0xFF7C3AED).withOpacity(0.14),
          const Color(0xFF7C3AED).withOpacity(0.04),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('🎯 ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text('Your Next Move',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (here != null) ...[
              Text('📍 $here',
                  style: const TextStyle(
                      color: Color(0xFFA78BFA), fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
            ],
            const Text(
              'Your Copilot is preparing your next step. '
              'Continue with today\'s goals or re-analyse to refresh your plan.',
              style: TextStyle(
                  color: Colors.white70, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => onOpen(null),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Open Roadmap',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      );
    }

    return GlassCard(
      padding: const EdgeInsets.all(18),
      borderColor: const Color(0xFF7C3AED).withOpacity(0.35),
      gradientColors: [
        const Color(0xFF7C3AED).withOpacity(0.14),
        const Color(0xFF7C3AED).withOpacity(0.04),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎯 ', style: TextStyle(fontSize: 16)),
              const Expanded(
                child: Text('Your Next Move',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withOpacity(0.20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_typeLabel(action.type),
                    style: const TextStyle(
                        color: Color(0xFFA78BFA),
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),

          if (here != null) ...[
            const SizedBox(height: 10),
            Text('📍 $here',
                style: const TextStyle(
                    color: Color(0xFFA78BFA), fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],

          const SizedBox(height: 10),

          Text(
            action.title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.3),
          ),

          if (action.description.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡 ', style: TextStyle(fontSize: 13)),
                Expanded(
                  child: Text(
                    action.description,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () => onOpen(action),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_actionIcon(action.type), size: 18),
                  const SizedBox(width: 6),
                  Text(_actionLabel(action.type),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Recommendations Preview ───────────────────────────────────────────
class _RecommendationsPreview extends StatelessWidget {
  final List<CopilotRecommendation> recommendations;
  final void Function(String recommendationId) onDismiss;
  const _RecommendationsPreview({
    required this.recommendations,
    required this.onDismiss,
  });

  Color _colorFor(RecommendationCategory c) {
    switch (c) {
      case RecommendationCategory.skillGap:       return const Color(0xFFEF4444);
      case RecommendationCategory.learningPath:   return const Color(0xFF60A5FA);
      case RecommendationCategory.project:        return const Color(0xFFF59E0B);
      case RecommendationCategory.interviewPrep:  return const Color(0xFFA78BFA);
      case RecommendationCategory.jobMatch:       return const Color(0xFF4ADE80);
      case RecommendationCategory.streakNudge:    return const Color(0xFFF97316);
      default:                                     return const Color(0xFFA78BFA);
    }
  }

  String _labelFor(RecommendationCategory c) {
    switch (c) {
      case RecommendationCategory.skillGap:       return 'Skill Gap';
      case RecommendationCategory.learningPath:   return 'Learning';
      case RecommendationCategory.project:        return 'Project';
      case RecommendationCategory.interviewPrep:  return 'Interview';
      case RecommendationCategory.jobMatch:       return 'Job Match';
      case RecommendationCategory.streakNudge:    return 'Streak';
      default:                                     return 'Insight';
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = recommendations
        .where((r) => !r.isDismissed)
        .toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));

    if (active.isEmpty) return const SizedBox.shrink();

    final shown = active.take(3).toList();

    return Column(
      children: shown.map((r) {
        final color = _colorFor(r.category);
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF2A2A40)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_labelFor(r.category),
                      style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      if (r.description.trim().isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(r.description,
                            style: const TextStyle(
                                color: Color(0xFF888899),
                                fontSize: 11,
                                height: 1.4),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ],
                  ),
                ),
                Semantics(
                  label: 'Dismiss recommendation',
                  button: true,
                  child: GestureDetector(
                    onTap: () => onDismiss(r.id),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 6, top: 2),
                      child: Icon(Icons.close,
                          size: 14, color: Color(0xFF888899)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Daily Goals Card ──────────────────────────────────────────────────
//
// NOTE: This card intentionally does NOT display any aggregated
// "XP today" figure. Summing `goal.xpReward` would only show the reward
// promised by today's goals — not XP that Firestore has actually
// awarded — so it would be a derived, non-authoritative number. The
// per-goal `+N` chip on each goal tile remains because it is the
// definition of that goal's reward. Authoritative XP stays displayed
// only via the header badge and Stats strip, sourced from
// CopilotState.totalXp.
class _DailyGoalsCard extends StatelessWidget {
  final CopilotState state;
  final String? uid;
  final Future<void> Function(DailyGoal) onToggle;

  const _DailyGoalsCard({
    required this.state,
    required this.uid,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (state.todayGoals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A40)),
        ),
        child: const Center(
          child: Text(
            "No goals yet — pull down to generate today's goals.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF888899), fontSize: 13),
          ),
        ),
      );
    }

    final completed = state.todayGoals.where((g) => g.isCompleted).length;
    final total     = state.todayGoals.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('$completed/$total done',
                  style: const TextStyle(
                      color: Color(0xFF888899), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : completed / total,
              minHeight: 5,
              backgroundColor: const Color(0xFF2A2A40),
              valueColor:
                  const AlwaysStoppedAnimation(Color(0xFF7C3AED)),
            ),
          ),
          const SizedBox(height: 12),
          ...state.todayGoals.map((goal) => _GoalTile(
                goal: goal,
                onToggle: () => onToggle(goal),
              )),
        ],
      ),
    );
  }
}

// ── Goal Tile ─────────────────────────────────────────────────────────
class _GoalTile extends StatelessWidget {
  final DailyGoal goal;
  final VoidCallback onToggle;
  const _GoalTile({required this.goal, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onToggle,
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: goal.isCompleted
                    ? const Color(0xFF7C3AED)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: goal.isCompleted
                      ? const Color(0xFF7C3AED)
                      : const Color(0xFF444455),
                  width: 1.5,
                ),
              ),
              child: goal.isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(goal.category.icon,
                style: const TextStyle(fontSize: 15)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                goal.title,
                style: TextStyle(
                  color: goal.isCompleted
                      ? const Color(0xFF888899)
                      : Colors.white,
                  fontSize: 13,
                  decoration: goal.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('+${goal.xpReward}',
                  style: const TextStyle(
                      color: Color(0xFFA78BFA), fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quests Preview ────────────────────────────────────────────────────
class _QuestsPreview extends StatelessWidget {
  final List<Quest> quests;
  const _QuestsPreview({required this.quests});

  @override
  Widget build(BuildContext context) {
    final daily =
        quests.where((q) => q.type == QuestType.daily).take(2).toList();

    if (daily.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A40)),
        ),
        child: const Center(
          child: Text('No daily quests available right now.',
              style: TextStyle(color: Color(0xFF888899), fontSize: 13)),
        ),
      );
    }

    return Column(
      children: daily
          .map((q) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: QuestCard(quest: q),
              ))
          .toList(),
    );
  }
}

// ── Roadmap Preview ───────────────────────────────────────────────────
class _RoadmapPreview extends StatelessWidget {
  final CopilotState state;
  const _RoadmapPreview({required this.state});

  @override
  Widget build(BuildContext context) {
    final roadmap = state.roadmap;
    if (roadmap == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A40)),
        ),
        child: const Center(
          child: Text('Roadmap not generated yet',
              style: TextStyle(color: Color(0xFF888899), fontSize: 13)),
        ),
      );
    }

    final phase = roadmap.currentPhase;
    final pct   = roadmap.overallProgress.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7C3AED).withOpacity(0.14),
            const Color(0xFFA78BFA).withOpacity(0.07),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: const Color(0xFF7C3AED).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(roadmap.targetRole.label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              Text('${(pct * 100).toInt()}%',
                  style: const TextStyle(
                      color: Color(0xFFA78BFA),
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: const Color(0xFF2A2A40),
              valueColor:
                  const AlwaysStoppedAnimation(Color(0xFF7C3AED)),
            ),
          ),
          if (phase != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                    width: 7, height: 7,
                    decoration: const BoxDecoration(
                        color: Color(0xFF7C3AED),
                        shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Phase ${phase.phaseNumber + 1}: ${phase.title}',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(phase.description,
                style: const TextStyle(
                    color: Color(0xFF888899),
                    fontSize: 11,
                    height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    );
  }
}

// ── Leaderboard Teaser ────────────────────────────────────────────────
class _LeaderboardTeaser extends StatelessWidget {
  final int rank;
  final int xp;
  final VoidCallback onTap;
  const _LeaderboardTeaser(
      {required this.rank, required this.xp, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      gradientColors: [
        const Color(0xFF1E1040),
        const Color(0xFF7C3AED).withOpacity(0.12),
      ],
      borderColor: const Color(0xFF7C3AED).withOpacity(0.3),
      child: Row(
        children: [
          const Text('🏆', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rank > 0
                      ? 'You\'re ranked #$rank globally'
                      : 'Join the global leaderboard',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  rank > 0
                      ? 'Keep earning XP to climb the ranks'
                      : 'Complete goals to start ranking',
                  style: const TextStyle(
                      color: Color(0xFF888899), fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right,
              color: Color(0xFFA78BFA), size: 20),
        ],
      ),
    );
  }
}

// ── Quick Actions ─────────────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  final VoidCallback onProgress;
  final VoidCallback onEdit;
  final VoidCallback onRerun;
  final VoidCallback onAchievements;
  final VoidCallback onAnalytics;
  final VoidCallback onLeaderboard;

  const _QuickActions({
    required this.onProgress,
    required this.onEdit,
    required this.onRerun,
    required this.onAchievements,
    required this.onAnalytics,
    required this.onLeaderboard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions',
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Row(
          children: [
            _action(Icons.bar_chart,   'Progress',     onProgress),
            const SizedBox(width: 10),
            _action(Icons.emoji_events,'Achievements', onAchievements),
            const SizedBox(width: 10),
            _action(Icons.analytics,   'Analytics',    onAnalytics),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _action(Icons.leaderboard, 'Leaderboard',  onLeaderboard),
            const SizedBox(width: 10),
            _action(Icons.edit_note,   'Edit Profile', onEdit),
            const SizedBox(width: 10),
            _action(Icons.refresh,     'Re-analyse',   onRerun),
          ],
        ),
      ],
    );
  }

  Widget _action(IconData icon, String label, VoidCallback onTap) =>
      Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF2A2A40)),
            ),
            child: Column(
              children: [
                Icon(icon, color: const Color(0xFFA78BFA), size: 20),
                const SizedBox(height: 6),
                Text(label,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 10),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      );
}