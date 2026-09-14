// ══════════════════════════════════════════════════════════════════════
// lib/screens/copilot_hub_screen.dart
//
// UPGRADED — World-class AI Career Copilot
// Architecture preserved: CopilotProvider, CopilotController, Firebase,
// XP system, streak system, roadmap system, skill gap system all intact.
//
// NEW SYSTEMS ADDED (non-breaking):
//  • AI Memory: personalized greetings + daily advice
//  • Daily Reward Box: streak-scaled XP with pulse animation
//  • Leveling System: level badge + XP progress bar
//  • Quest Preview: daily quests with progress
//  • Achievement Toasts: pop-up on badge unlock
//  • Leaderboard Teaser: global rank widget
//  • AI Companion Card: contextual advice
//  • Analytics Teaser: career readiness score
//  • Glassmorphism design language
//  • All new screens accessible from hub
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
import '../widgets/glassmorphism_card.dart';
import 'skill_profile_screen.dart';
import 'skill_gap_screen.dart';
import 'personalized_roadmap_screen.dart';
import 'progress_screen.dart';
import 'quest_screen.dart';
import 'achievement_screen.dart';
import 'leaderboard_screen.dart';
import 'analytics_screen.dart';

class CopilotHubScreen extends StatefulWidget {
  const CopilotHubScreen({super.key});

  @override
  State<CopilotHubScreen> createState() => _CopilotHubScreenState();
}

class _CopilotHubScreenState extends State<CopilotHubScreen> {
  // ── Design tokens (unchanged) ─────────────────────────────────────
  static const _bg        = Color(0xFF0F0F1A);
  static const _surface   = Color(0xFF1A1A2E);
  static const _border    = Color(0xFF2A2A40);
  static const _primary   = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted     = Color(0xFF888899);

  // ── Existing state (unchanged) ────────────────────────────────────
  String? _uid;
  bool _initCalled = false;

  // ── New services ──────────────────────────────────────────────────
  final _achievementService = AchievementService();
  final _memoryService      = AiMemoryService();
  final _rewardService      = RewardService();
  final _questService       = QuestService();
  final _leaderboardService = LeaderboardService();

  // ── New state ─────────────────────────────────────────────────────
  String _greeting        = '';
  String _advice          = '';
  bool   _canClaimReward  = false;
  int    _userRank        = 0;
  List<Quest> _quests     = [];
  AiMemory _memory        = const AiMemory();
  bool _newDataLoaded     = false;

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
          // ── Existing init (unchanged) ──────────────────────────
          CopilotProvider.maybeOf(context)?.init(_uid!);
          // ── New parallel loads ─────────────────────────────────
          await _loadNewData();
        }
      });
    }
  }

  Future<void> _loadNewData() async {
    if (_uid == null || !mounted) return;

    final ctrl  = CopilotProvider.maybeOf(context);
    final state = ctrl?.state;

    final level      = LevelSystem.levelFor(state?.totalXp ?? 0);
    final levelTitle = LevelSystem.titleFor(state?.totalXp ?? 0);
    final displayName =
        FirebaseAuth.instance.currentUser?.displayName ?? 'there';

    // Load in parallel for performance
    final results = await Future.wait([
      _memoryService.fetchMemory(_uid!),
      _rewardService.canClaimDailyBox(_uid!),
      _questService.fetchQuests(_uid!),
      _leaderboardService.getCurrentUserRank(_uid!, state?.totalXp ?? 0),
    ]);

    final memory       = results[0] as AiMemory;
    final canClaim     = results[1] as bool;
    final quests       = results[2] as List<Quest>;
    final rank         = results[3] as int;

    final greeting = await _memoryService.getDailyGreeting(
      displayName: displayName,
      memory: memory,
      state: state ?? const CopilotState(),
      level: level,
      levelTitle: levelTitle,
    );

    final advice = await _memoryService.getDailyAdvice(
      memory: memory,
      state: state ?? const CopilotState(),
      levelTitle: levelTitle,
    );

    if (mounted) {
      setState(() {
        _memory         = memory;
        _greeting       = greeting;
        _advice         = advice;
        _canClaimReward = canClaim;
        _quests         = quests;
        _userRank       = rank;
        _newDataLoaded  = true;
      });
    }

    // Sync memory with profile in background
    if (state != null) {
      _memoryService.syncFromProfile(_uid!, state);
    }

    // Sync leaderboard in background
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && state != null) {
      _leaderboardService.syncUserToLeaderboard(
        uid: _uid!,
        displayName: user.displayName ?? 'Learner',
        photoUrl: user.photoURL,
        totalXp: state.totalXp,
        level: level,
        weeklyXp: 0, // TODO: compute from analytics
      );
    }
  }

  // ── Claim daily reward ─────────────────────────────────────────────
  Future<void> _claimReward(int streak) async {
    if (_uid == null) return;
    final result = await _rewardService.claimDailyBox(_uid!, streak);
    setState(() => _canClaimReward = false);
    if (mounted && result.xpAmount > 0) {
      _showRewardSnack(result);
      // Check for new achievements after XP change
      final ctrl  = CopilotProvider.maybeOf(context);
      if (ctrl != null) {
        final state = ctrl.state;
        final level = LevelSystem.levelFor(state.totalXp + result.xpAmount);
        final newAchievements = await _achievementService.checkAndUnlock(
          uid: _uid!,
          state: state,
          totalGoalsCompleted: 0,
          currentLevel: level,
        );
        for (final a in newAchievements) {
          if (mounted) AchievementToast.show(context, a);
        }
      }
    }
  }

  void _showRewardSnack(RewardResult result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          Text(result.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Text('${result.message} +${result.xpAmount} XP',
              style: const TextStyle(color: Colors.white)),
        ]),
        backgroundColor: _primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── Toggle goal (extended to check achievements + quests) ──────────
  Future<void> _toggleGoalWithChecks(
      CopilotController ctrl, DailyGoal goal) async {
    if (_uid == null) return;
    await ctrl.toggleGoal(_uid!, goal);

    final state = ctrl.state;
    final completedToday =
        state.todayGoals.where((g) => g.isCompleted).length;
    final level = LevelSystem.levelFor(state.totalXp);

    // Check achievements
    final newAchievements = await _achievementService.checkAndUnlock(
      uid: _uid!,
      state: state,
      totalGoalsCompleted: completedToday,
      currentLevel: level,
    );
    for (final a in newAchievements) {
      if (mounted) AchievementToast.show(context, a);
    }

    // Update quest progress
    await _questService.onGoalCompleted(_uid!, completedToday);

    // Surprise reward roll
    final surprise = await _rewardService.rollSurpriseReward(_uid!);
    if (surprise != null && mounted) _showRewardSnack(surprise);

    // Refresh quests
    final quests = await _questService.fetchQuests(_uid!);
    if (mounted) setState(() => _quests = quests);
  }

  // ─────────────────────────────────────────────────────────────────
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

  // ── Loading (unchanged) ────────────────────────────────────────────
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

  // ── Setup (enhanced) ──────────────────────────────────────────────
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
            _featureRow(Icons.radar,      'Skill Gap Analysis'),
            const SizedBox(height: 10),
            _featureRow(Icons.route,      'Personalised Roadmap'),
            const SizedBox(height: 10),
            _featureRow(Icons.bolt,       'Daily Goals & XP'),
            const SizedBox(height: 10),
            _featureRow(Icons.emoji_events, 'Achievements & Badges'),
            const SizedBox(height: 10),
            _featureRow(Icons.leaderboard,'Global Leaderboard'),
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
          Text(text,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
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

    return RefreshIndicator(
      color: _secondary,
      backgroundColor: _surface,
      onRefresh: () async {
        if (_uid != null) {
          await ctrl.rerunAnalysis(_uid!);
          await _loadNewData();
        }
      },
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
                          _greeting.isEmpty
                              ? 'Hey $name 🤖'
                              : _greeting,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          LevelSystem.titleFor(totalXp),
                          style: const TextStyle(
                              color: _secondary, fontSize: 12),
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

          // ── Stats strip (unchanged widget, kept) ─────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _StatsStrip(
                state: state,
                rank: _userRank,
              ),
            ).animate().fadeIn(delay: 80.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

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

          // ── AI Companion Card ─────────────────────────────────────
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

          // ── AI Loading banner ─────────────────────────────────────
          if (state.isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: _aiBanner(),
              ),
            ),

          // ── Error banner ──────────────────────────────────────────
          if (state.error != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: _errorBanner(state.error!),
              ),
            ),

          // ── Today's Goals ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionHeader(
                  "Today's Goals", Icons.today, null),
            ).animate().fadeIn(delay: 140.ms),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: _DailyGoalsCard(
                state: state,
                ctrl: ctrl,
                uid: _uid,
                onToggle: (goal) =>
                    _toggleGoalWithChecks(ctrl, goal),
              ),
            ).animate().fadeIn(delay: 160.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Daily Quests Preview ──────────────────────────────────
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

          // ── Skill Gaps (unchanged widget, kept) ───────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionHeader(
                'Skill Gaps',
                Icons.radar,
                () => _go(const SkillGapScreen()),
              ),
            ).animate().fadeIn(delay: 220.ms),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: _SkillGapPreview(state: state),
            ).animate().fadeIn(delay: 240.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Roadmap (unchanged widget, kept) ─────────────────────
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

          // ── Leaderboard Teaser ────────────────────────────────────
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

          // ── Quick Actions (extended) ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _QuickActions(
                onProgress:     () => _go(const ProgressScreen()),
                onEdit:         () => _go(const SkillProfileScreen()),
                onRerun:        () {
                  if (_uid != null) ctrl.rerunAnalysis(_uid!);
                },
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

  // ── Shared helpers (mostly unchanged) ─────────────────────────────

  Widget _sectionHeader(
      String title, IconData icon, VoidCallback? onSeeAll) {
    return Row(
      children: [
        Icon(icon, size: 17, color: _secondary),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600)),
        const Spacer(),
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
          gradient: const LinearGradient(
              colors: [_primary, _secondary]),
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
            Text(
              'Lv.$level',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
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
            Text('AI is analysing your profile…',
                style: TextStyle(color: _secondary, fontSize: 13)),
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

  void _go(Widget screen) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
}

// ════════════════════════════════════════════════════════════════════
// PRIVATE WIDGETS
// ════════════════════════════════════════════════════════════════════

// ── Stats Strip (extended with rank) ─────────────────────────────────
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
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF888899), fontSize: 10)),
          ],
        ),
      );

  Widget _div() => Container(
      width: 1, height: 30, color: const Color(0xFF2A2A40));
}

// ── Daily Goals Card (extended with custom toggle callback) ───────────
class _DailyGoalsCard extends StatelessWidget {
  final CopilotState state;
  final CopilotController ctrl;
  final String? uid;
  final Future<void> Function(DailyGoal) onToggle;

  const _DailyGoalsCard({
    required this.state,
    required this.ctrl,
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
    final xpEarned  = state.todayGoals
        .where((g) => g.isCompleted)
        .fold(0, (s, g) => s + g.xpReward);

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
              const Spacer(),
              Text('+$xpEarned XP earned',
                  style: const TextStyle(
                      color: Color(0xFFA78BFA), fontSize: 12)),
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

// ── Goal Tile (unchanged) ─────────────────────────────────────────────
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
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 7, vertical: 2),
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
    final daily = quests.where((q) => q.type == QuestType.daily).take(2).toList();

    if (daily.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A40)),
        ),
        child: const Center(
          child: Text('No quests yet. Opening quests screen…',
              style:
                  TextStyle(color: Color(0xFF888899), fontSize: 13)),
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

// ── Skill Gap Preview (unchanged) ─────────────────────────────────────
class _SkillGapPreview extends StatelessWidget {
  final CopilotState state;
  const _SkillGapPreview({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.skillGaps.isEmpty) {
      return _empty('Skill analysis not run yet.');
    }
    final top = state.skillGaps.take(3).toList();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A40)),
      ),
      child: Column(
        children: [
          ...top.map((g) => _GapRow(gap: g)),
          if (state.skillGaps.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '+${state.skillGaps.length - 3} more · tap See all',
                style: const TextStyle(
                    color: Color(0xFF888899), fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }

  Widget _empty(String msg) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A40)),
        ),
        child: Center(
          child: Text(msg,
              style: const TextStyle(
                  color: Color(0xFF888899), fontSize: 13)),
        ),
      );
}

class _GapRow extends StatelessWidget {
  final SkillGap gap;
  const _GapRow({required this.gap});

  Color get _color {
    switch (gap.priority) {
      case 1:  return const Color(0xFFEF4444);
      case 2:  return const Color(0xFFF59E0B);
      default: return const Color(0xFF6EE7B7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(gap.skillName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
                Text(gap.reason,
                    style: const TextStyle(
                        color: Color(0xFF888899), fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(gap.priorityLabel,
                style: TextStyle(color: _color, fontSize: 10)),
          ),
        ],
      ),
    );
  }
}

// ── Roadmap Preview (unchanged) ───────────────────────────────────────
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
    final pct   = roadmap.overallProgress;

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
        border: Border.all(
            color: const Color(0xFF7C3AED).withOpacity(0.3)),
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
                        fontSize: 14)),
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
                ),
                const SizedBox(height: 2),
                Text(
                  rank > 0
                      ? 'Keep earning XP to climb the ranks'
                      : 'Complete goals to start ranking',
                  style: const TextStyle(
                      color: Color(0xFF888899), fontSize: 11),
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

// ── Quick Actions (extended) ──────────────────────────────────────────
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
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      );
}