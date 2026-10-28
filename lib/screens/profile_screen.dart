import 'dart:async';
// ══════════════════════════════════════════════════════════════════════
// lib/screens/profile_screen.dart
// Professional AI Career Profile Screen
//
// ARCHITECTURE (compatibility / data-source correction)
// ─────────────────────────────────────────────────────
// This is a legacy profile screen. It remains a UI / consumer layer
// and never becomes an authority for XP, career, or progress
// persistence. Specifically:
//
//   • XP
//       The single lifetime XP value displayed on this screen is read
//       from `users/{uid}.totalXp` — the same authoritative lifetime XP
//       field that the current Copilot architecture uses. The legacy
//       `users/{uid}.xpPoints` value and the per-day
//       `copilot_progress.xpEarned` values are NOT added into it and
//       are NOT used as lifetime XP.
//
//       • Authoritative source: users/{uid}.totalXp
//       • Legacy fallback (only when the authoritative value is
//         genuinely absent): users/{uid}.xpPoints
//       • Never sums the two.
//       • Never treats the last-30-day progress sum as lifetime XP.
//
//       The 30-day progress sum is retained ONLY as an activity metric
//       under a clearly labelled "Copilot XP (last 30 days)" tile — it
//       is not presented as lifetime XP.
//
//   • Career
//       The Edit Profile role list is a UI selection list for this
//       legacy screen only. It now includes the canonical
//       "Software Engineer" label so it is selectable alongside the
//       other careers. No second career enum or database is created;
//       `copilot_models.dart` is not modified.
//
//       The Copilot skill profile's `targetRole` continues to be read
//       separately and is preferred for display when available.
//
//   • Persistence
//       Profile edits continue to write only to the same existing
//       `users/{uid}` document fields that this screen already wrote
//       before. XP is never written or mutated from this screen.
//
//   • Safety
//       Every read is defensive: missing Firestore fields, missing
//       Copilot data, and legacy-only users are all handled without
//       crashing. When the authoritative XP is unavailable, the last
//       known value is kept; only when nothing is available does the
//       screen fall back to `xpPoints` for display.
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import 'saved_jobs_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  // ── Design tokens ──────────────────────────────────────────────────
  static const _bg = Color(0xFF0F0F1A);
  static const _surface = Color(0xFF1A1A2E);
  static const _border = Color(0xFF2A2A40);
  static const _primary = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _muted = Color(0xFF888899);
  static const _green = Color(0xFF4ADE80);
  static const _amber = Color(0xFFF59E0B);
  static const _red = Color(0xFFEF4444);

  // ── State ───────────────────────────────────────────────────────────
  String _userName = '';
  String _userEmail = '';
  String _userPhotoUrl = '';
  String _city = 'India 🇮🇳';
  String _bio = '';
  String _phone = '';
  String _targetRole = 'AI Engineer';
  String _experience = '0–1 years';
  List<String> _userSkills = [];

  int _appliedJobs = 0;
  int _savedJobsCount = 0;

  /// Authoritative lifetime XP — sourced from users/{uid}.totalXp.
  /// This is the ONLY lifetime XP value this screen trusts. It is never
  /// summed with legacy XP and never derived from progress history.
  int _lifetimeXp = 0;

  /// Legacy XP (users/{uid}.xpPoints). Kept ONLY as a display fallback
  /// for pre-Copilot users whose authoritative totalXp is genuinely
  /// absent. Never added to _lifetimeXp.
  int _legacyXp = 0;

  /// Whether the authoritative users/{uid}.totalXp field has been
  /// observed. When true, _lifetimeXp is authoritative and _legacyXp is
  /// not consulted for the lifetime XP display.
  bool _hasAuthoritativeXp = false;

  int _doneSteps = 0;
  int _streakDays = 0;

  bool _loading = true;
  late TabController _tabCtrl;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _xpSubscription;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // XP level thresholds
  static const _levels = [
    _Level('🌱 Beginner', 0, 150, Color(0xFF6EE7B7)),
    _Level('📚 Learner', 150, 400, Color(0xFF60A5FA)),
    _Level('⚡ Practitioner', 400, 800, Color(0xFFA78BFA)),
    _Level('🔥 Builder', 800, 1500, Color(0xFFF59E0B)),
    _Level('🚀 Expert', 1500, 3000, Color(0xFFEF4444)),
    _Level('🏆 Master', 3000, 9999, Color(0xFFFFD700)),
  ];

  /// The authoritative lifetime XP value shown across the screen.
  /// Prefers authoritative Copilot XP and only falls back to the legacy
  /// field when the authoritative value has never been observed.
  int get _xpPoints => _hasAuthoritativeXp ? _lifetimeXp : _legacyXp;

  _Level get _currentLevel => _levels.lastWhere(
        (l) => _xpPoints >= l.minXp,
        orElse: () => _levels.first,
      );

  double get _levelProgress {
    final l = _currentLevel;
    if (l.maxXp == 9999) return 1.0;
    return ((_xpPoints - l.minXp) / (l.maxXp - l.minXp)).clamp(0.0, 1.0);
  }

  int get _xpToNextLevel {
    final l = _currentLevel;
    if (l.maxXp == 9999) return 0;
    return l.maxXp - _xpPoints;
  }

  // Copilot-derived display values
  int _copilotXpLast30 = 0; // activity metric ONLY — never lifetime XP
  int _copilotStreak = 0;
  int _roadmapPct = 0;
  String _copilotRole = '';

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _bindLiveXp();
    _loadAll();
  }

  @override
  void dispose() {
    _xpSubscription?.cancel();
    _tabCtrl.dispose();
    super.dispose();
  }

  void _bindLiveXp() {
    final user = _auth.currentUser;
    if (user == null) return;

    _xpSubscription =
        _firestore.collection('users').doc(user.uid).snapshots().listen((doc) {
      final raw = doc.data()?['totalXp'];
      final xp = raw is num ? raw.toInt() : null;
      if (xp == null || xp < 0 || !mounted) return;
      if (_lifetimeXp == xp && _hasAuthoritativeXp) return;
      setState(() {
        _lifetimeXp = xp;
        _hasAuthoritativeXp = true;
      });
    });
  }

  Future<void> _loadAll() async {
    if (mounted) setState(() => _loading = true);
    await Future.wait([
      _loadUserData(),
      _loadStats(),
      _loadCopilotData(),
    ]);
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() {
          _userName = 'Guest User';
          _userEmail = '';
          _loading = false;
        });
      }
      return;
    }
    if (mounted) {
      setState(() {
        _userName = user.displayName ?? user.email?.split('@').first ?? 'User';
        _userEmail = user.email ?? '';
        _userPhotoUrl = user.photoURL ?? '';
      });
    }

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final d = doc.data()!;

        // Authoritative lifetime XP — users/{uid}.totalXp.
        // Only this field is treated as lifetime XP. It is never summed
        // with anything else, and it is never derived from
        // copilot_progress.xpEarned.
        final num? totalXpRaw = d['totalXp'] as num?;
        final int? totalXp = totalXpRaw?.toInt();

        // Legacy XP — users/{uid}.xpPoints. Kept ONLY for display
        // fallback when the authoritative value is genuinely absent.
        final num? legacyXpRaw = d['xpPoints'] as num?;
        final int? legacyXp = legacyXpRaw?.toInt();

        if (!mounted) return;
        setState(() {
          _city = d['city'] ?? d['location'] ?? 'India 🇮🇳';
          _bio = d['bio'] ?? '';
          _phone = d['phone'] ?? '';
          _appliedJobs = (d['appliedJobs'] as num?)?.toInt() ?? 0;
          _doneSteps = (d['completedSteps'] as num?)?.toInt() ?? 0;
          _userSkills = List<String>.from(d['skills'] ?? []);
          _targetRole = d['targetRole'] ?? 'AI Engineer';
          _experience = d['experience'] ?? '0–1 years';

          if (totalXp != null && totalXp >= 0) {
            _lifetimeXp = totalXp;
            _hasAuthoritativeXp = true;
          } else if (legacyXp != null && legacyXp >= 0) {
            _legacyXp = legacyXp;
          }
        });
      }
    } catch (_) {}

    // Count saved jobs
    try {
      final saved = await _firestore
          .collection('saved_jobs')
          .where('userId', isEqualTo: user.uid)
          .get();
      if (mounted) setState(() => _savedJobsCount = saved.docs.length);
    } catch (_) {}
  }

  Future<void> _loadStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int done = 0;
      for (int i = 1; i <= 15; i++) {
        if (prefs.getBool('rmap_$i') ?? prefs.getBool('phase_v2_$i') ?? false) {
          done++;
        }
      }
      final streak = prefs.getInt('streak_days') ?? 0;
      if (!mounted) return;
      setState(() {
        if (done > _doneSteps) _doneSteps = done;
        _streakDays = streak;
      });
    } catch (_) {}
  }

  Future<void> _loadCopilotData() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      // Copilot skill profile (target role is preferred for display).
      final profileDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('copilot')
          .doc('skill_profile')
          .get();
      if (profileDoc.exists) {
        final d = profileDoc.data()!;
        final role = d['targetRole'];
        if (role is String && role.isNotEmpty && mounted) {
          setState(() => _copilotRole = role);
        }
      }

      // Copilot roadmap progress.
      final roadmapDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('copilot')
          .doc('roadmap')
          .get();
      if (roadmapDoc.exists) {
        final phases = (roadmapDoc.data()!['phases'] as List?) ?? [];
        final completed = phases.where((p) => p['isCompleted'] == true).length;
        if (phases.isNotEmpty && mounted) {
          setState(
              () => _roadmapPct = ((completed / phases.length) * 100).round());
        }
      }

      // 30-day activity window. This is an ACTIVITY metric only — it is
      // NOT treated as lifetime XP and is never added to the
      // authoritative lifetime XP value.
      final progressSnap = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('copilot_progress')
          .orderBy('date', descending: true)
          .limit(30)
          .get();

      int last30Xp = 0;
      int streak = 0;
      DateTime? lastDate;
      for (final doc in progressSnap.docs) {
        final d = doc.data();
        final xp = (d['xpEarned'] as num?)?.toInt() ?? 0;
        final date = DateTime.tryParse(d['date'] as String? ?? '');
        last30Xp += xp;
        if (date != null) {
          if (lastDate == null) {
            streak = 1;
            lastDate = date;
          } else {
            final diff = lastDate!.difference(date).inDays;
            if (diff <= 1 && ((d['goalsCompleted'] as num?) ?? 0) > 0) {
              streak++;
              lastDate = date;
            }
          }
        }
      }

      if (!mounted) return;
      setState(() {
        _copilotXpLast30 = last30Xp;
        _copilotStreak = streak;
        if (streak > _streakDays) _streakDays = streak;
      });
    } catch (_) {}
  }

  // ══════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _primary))
          : RefreshIndicator(
              color: _secondary,
              backgroundColor: _surface,
              onRefresh: _loadAll,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHero()),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: _buildLevelCard(),
                    ).animate().fadeIn(delay: 100.ms),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildStatsRow(),
                    ).animate().fadeIn(delay: 150.ms),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildTabBar(),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverToBoxAdapter(child: _buildTabContent()),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // HERO HEADER
  // ══════════════════════════════════════════════════════════════════
  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _primary.withOpacity(0.25),
            _surface.withOpacity(0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 94,
                height: 94,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [_primary, _secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: _secondary, width: 2.5),
                ),
                child: _userPhotoUrl.isNotEmpty
                    ? ClipOval(
                        child: Image.network(_userPhotoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _avatarIcon()),
                      )
                    : _avatarIcon(),
              ),
              GestureDetector(
                onTap: _editProfile,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: _primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 14, color: Colors.white),
                ),
              ),
            ],
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 14),
          Text(_userName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold))
              .animate()
              .fadeIn(delay: 100.ms),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(colors: [_primary, _secondary]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _copilotRole.isNotEmpty ? _copilotRole : _targetRole,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.location_on, size: 12, color: _muted),
              const SizedBox(width: 3),
              Text(_city, style: const TextStyle(color: _muted, fontSize: 12)),
            ],
          ).animate().fadeIn(delay: 150.ms),
          if (_bio.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(_bio,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 13, height: 1.4)),
          ],
          const SizedBox(height: 16),
          if (_userEmail.isNotEmpty)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: _userEmail));
                _snack('Email copied!');
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.email_outlined,
                        size: 14, color: _secondary),
                    const SizedBox(width: 6),
                    Text(_userEmail,
                        style: const TextStyle(color: _muted, fontSize: 12)),
                    const SizedBox(width: 6),
                    const Icon(Icons.copy, size: 12, color: _muted),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  Widget _avatarIcon() => Center(
        child: Text(
          _userName.isNotEmpty ? _userName[0].toUpperCase() : '?',
          style: const TextStyle(
              color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold),
        ),
      );

  // ══════════════════════════════════════════════════════════════════
  // XP LEVEL CARD
  // ══════════════════════════════════════════════════════════════════
  Widget _buildLevelCard() {
    final level = _currentLevel;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: level.color.withOpacity(0.4)),
        gradient: LinearGradient(
          colors: [level.color.withOpacity(0.08), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(level.name,
                  style: TextStyle(
                      color: level.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: level.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('$_xpPoints XP',
                    style: TextStyle(
                        color: level.color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _levelProgress,
              minHeight: 8,
              backgroundColor: _border,
              valueColor: AlwaysStoppedAnimation(level.color),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('${(_levelProgress * 100).toInt()}% to next level',
                  style: const TextStyle(color: _muted, fontSize: 11)),
              const Spacer(),
              if (_xpToNextLevel > 0)
                Text('$_xpToNextLevel XP to go',
                    style: TextStyle(color: level.color, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // STATS ROW
  // ══════════════════════════════════════════════════════════════════
  Widget _buildStatsRow() {
    return Row(
      children: [
        _statTile('💼', '$_appliedJobs', 'Applied'),
        const SizedBox(width: 8),
        _statTile('🔖', '$_savedJobsCount', 'Saved'),
        const SizedBox(width: 8),
        _statTile('🔥', '$_streakDays', 'Streak'),
        const SizedBox(width: 8),
        _statTile('✅', '$_doneSteps', 'Phases'),
      ],
    );
  }

  Widget _statTile(String emoji, String val, String label) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 4),
              Text(val,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: _muted, fontSize: 10)),
            ],
          ),
        ),
      );

  // ══════════════════════════════════════════════════════════════════
  // TAB BAR
  // ══════════════════════════════════════════════════════════════════
  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: TabBar(
        controller: _tabCtrl,
        onTap: (_) => setState(() {}),
        indicator: BoxDecoration(
          color: _primary,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: _muted,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: '📊 Career'),
          Tab(text: '🛠️ Skills'),
          Tab(text: '⚙️ Settings'),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // TAB CONTENT
  // ══════════════════════════════════════════════════════════════════
  Widget _buildTabContent() {
    return AnimatedBuilder(
      animation: _tabCtrl,
      builder: (_, __) {
        switch (_tabCtrl.index) {
          case 0:
            return _careerTab();
          case 1:
            return _skillsTab();
          default:
            return _settingsTab();
        }
      },
    );
  }

  // ──────────────────────────────────────────────────────────────────
  // TAB 0 — CAREER
  // ──────────────────────────────────────────────────────────────────
  Widget _careerTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('🗺️ Roadmap Progress'),
          const SizedBox(height: 10),
          _progressCard(
            label: 'AI Learning Roadmap',
            value: _doneSteps / 15,
            detail: '$_doneSteps / 15 phases completed',
            color: _primary,
          ),
          if (_roadmapPct > 0) ...[
            const SizedBox(height: 10),
            _progressCard(
              label: 'AI Copilot Roadmap',
              value: _roadmapPct / 100,
              detail: '$_roadmapPct% complete',
              color: const Color(0xFF60A5FA),
            ),
          ],
          const SizedBox(height: 20),
          _sectionTitle('🎯 Career Goal'),
          const SizedBox(height: 10),
          _careerGoalCard(),
          const SizedBox(height: 20),
          _sectionTitle('📋 Activity'),
          const SizedBox(height: 10),
          _activityGrid(),
          const SizedBox(height: 20),
          _sectionTitle('💼 Jobs'),
          const SizedBox(height: 10),
          _actionCard(
            icon: Icons.bookmark_outline,
            title: 'Saved Jobs',
            subtitle: '$_savedJobsCount jobs saved',
            color: _secondary,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SavedJobsScreen())),
          ),
          const SizedBox(height: 10),
          _actionCard(
            icon: Icons.send_outlined,
            title: 'Applied Jobs',
            subtitle: '$_appliedJobs applications sent',
            color: _green,
            onTap: _showAppliedJobs,
          ),
        ],
      ),
    );
  }

  Widget _progressCard({
    required String label,
    required double value,
    required String detail,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${(value * 100).toInt()}%',
                  style: TextStyle(
                      color: color, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              minHeight: 7,
              backgroundColor: _border,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 6),
          Text(detail, style: const TextStyle(color: _muted, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _careerGoalCard() {
    final role = _copilotRole.isNotEmpty ? _copilotRole : _targetRole;
    final exp = _experience;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _primary.withOpacity(0.3)),
        gradient: LinearGradient(
          colors: [_primary.withOpacity(0.08), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('🎯', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text('Experience: $exp',
                    style: const TextStyle(color: _muted, fontSize: 12)),
              ],
            ),
          ),
          GestureDetector(
            onTap: _editProfile,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _primary),
              ),
              child: const Text('Edit',
                  style: TextStyle(color: _secondary, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityGrid() {
    // The first tile is clearly labelled as a 30-day activity metric so
    // it cannot be mistaken for the authoritative lifetime XP shown in
    // the level card. It is not added to the lifetime XP value.
    return Row(
      children: [
        _activityTile(
            '⚡', '$_copilotXpLast30', 'XP (30 days)', const Color(0xFF60A5FA)),
        const SizedBox(width: 10),
        _activityTile('🔥', '$_copilotStreak', 'Day Streak', _amber),
        const SizedBox(width: 10),
        _activityTile('🏆', _currentLevel.name.split(' ').first, 'Level',
            _currentLevel.color),
      ],
    );
  }

  Widget _activityTile(String emoji, String val, String label, Color color) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 4),
              Text(val,
                  style: TextStyle(
                      color: color, fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(color: _muted, fontSize: 10)),
            ],
          ),
        ),
      );

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: const TextStyle(color: _muted, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _muted, size: 20),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────
  // TAB 1 — SKILLS
  // ──────────────────────────────────────────────────────────────────
  Widget _skillsTab() {
    final recommended = _recommendedSkills(
        _copilotRole.isNotEmpty ? _copilotRole : _targetRole);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _sectionTitle('🛠️ Your Skills'),
              const Spacer(),
              GestureDetector(
                onTap: _addSkills,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _primary.withOpacity(0.4)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, size: 14, color: _secondary),
                      SizedBox(width: 4),
                      Text('Add',
                          style: TextStyle(color: _secondary, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_userSkills.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _border),
              ),
              child: Column(
                children: [
                  const Icon(Icons.engineering, color: _muted, size: 36),
                  const SizedBox(height: 8),
                  const Text('No skills added yet',
                      style: TextStyle(color: _muted, fontSize: 13)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _addSkills,
                    child: const Text('+ Add your skills',
                        style: TextStyle(color: _secondary, fontSize: 13)),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _border),
              ),
              child: Wrap(
                spacing: 7,
                runSpacing: 7,
                children:
                    _userSkills.map((s) => _skillChip(s, _primary)).toList(),
              ),
            ),
          const SizedBox(height: 20),
          _sectionTitle('💡 Recommended for $_targetRole'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Based on your career goal',
                    style: TextStyle(color: _muted, fontSize: 11)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: recommended.map((s) {
                    final have = _userSkills
                        .map((x) => x.toLowerCase())
                        .contains(s.toLowerCase());
                    return _skillChip(s, have ? _green : _amber,
                        icon: have ? Icons.check : null);
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle('📈 Skill Gap'),
          const SizedBox(height: 10),
          _skillGapBar(),
        ],
      ),
    );
  }

  Widget _skillChip(String skill, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
          ],
          Text(skill,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _skillGapBar() {
    final recommended = _recommendedSkills(
        _copilotRole.isNotEmpty ? _copilotRole : _targetRole);
    final have = _userSkills.map((s) => s.toLowerCase()).toSet();
    final matching =
        recommended.where((s) => have.contains(s.toLowerCase())).length;
    final pct = recommended.isEmpty ? 0.0 : matching / recommended.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$matching / ${recommended.length} core skills',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('${(pct * 100).toInt()}% job ready for $_targetRole',
                        style: const TextStyle(color: _muted, fontSize: 11)),
                  ],
                ),
              ),
              _circularPct(pct),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 7,
              backgroundColor: _border,
              valueColor: AlwaysStoppedAnimation(
                pct > 0.7
                    ? _green
                    : pct > 0.4
                        ? _amber
                        : _red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circularPct(double pct) {
    final color = pct > 0.7
        ? _green
        : pct > 0.4
            ? _amber
            : _red;
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: pct,
            strokeWidth: 5,
            backgroundColor: _border,
            valueColor: AlwaysStoppedAnimation(color),
          ),
          Center(
            child: Text('${(pct * 100).toInt()}%',
                style: TextStyle(
                    color: color, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────
  // TAB 2 — SETTINGS
  // ──────────────────────────────────────────────────────────────────
  Widget _settingsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('👤 Account'),
          const SizedBox(height: 10),
          _settingItem(Icons.edit_outlined, 'Edit Profile', _editProfile),
          _settingItem(Icons.lock_outline, 'Change Password', _changePassword),
          _settingItem(Icons.verified_user_outlined, 'Email Verification',
              _checkEmailVerified),
          const SizedBox(height: 20),
          _sectionTitle('📊 Career Tools'),
          const SizedBox(height: 10),
          _settingItem(Icons.bookmark_outline, 'Saved Jobs', _goSavedJobs),
          _settingItem(
              Icons.send_outlined, 'My Applications', _showAppliedJobs),
          _settingItem(Icons.description_outlined, 'My Resume', _showResume),
          _settingItem(
              Icons.notifications_outlined, 'Job Alerts', _sendJobAlert),
          const SizedBox(height: 20),
          _sectionTitle('🤝 Community'),
          const SizedBox(height: 10),
          _settingItem(Icons.star_outline, 'Rate the App', _rateApp),
          _settingItem(Icons.share_outlined, 'Share with Friends', _shareApp),
          _settingItem(Icons.people_outline, 'Join Community', _joinCommunity),
          const SizedBox(height: 20),
          _sectionTitle('ℹ️ Info'),
          const SizedBox(height: 10),
          _settingItem(Icons.help_outline, 'Help & Support', _showHelp),
          _settingItem(
              Icons.privacy_tip_outlined, 'Privacy Policy', _openPrivacy),
          _settingItem(Icons.info_outline, 'About the App', _showAbout),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _logout,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _red.withOpacity(0.4)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: _red, size: 20),
                  SizedBox(width: 8),
                  Text('Log Out',
                      style: TextStyle(
                          color: _red,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _deleteAccount,
            child: Center(
              child: Text('Delete Account',
                  style: TextStyle(
                      color: _red.withOpacity(0.5),
                      fontSize: 12,
                      decoration: TextDecoration.underline)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            Icon(icon, color: _secondary, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF444455), size: 18),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // ACTIONS
  // ══════════════════════════════════════════════════════════════════

  void _editProfile() {
    final nameCtrl = TextEditingController(text: _userName);
    final bioCtrl = TextEditingController(text: _bio);
    final cityCtrl = TextEditingController(text: _city);
    final phoneCtrl = TextEditingController(text: _phone);
    String role = _targetRole;
    String exp = _experience;

    // UI selection list for this legacy editor ONLY. Software Engineer is
    // included so the canonical `CareerGoal.softwareEngineer` label is
    // selectable. No second career enum is created, and copilot_models.dart
    // is not modified.
    const roles = [
      'AI Engineer',
      'ML Engineer',
      'Data Scientist',
      'NLP Engineer',
      'CV Engineer',
      'Prompt Engineer',
      'AI Researcher',
      'AI Product Manager',
      'Software Engineer',
    ];
    const exps = [
      '0–1 years',
      '1–2 years',
      '2–3 years',
      '3–5 years',
      '5+ years'
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setBS) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text('Edit Profile',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                _inputField('Full Name', nameCtrl),
                const SizedBox(height: 12),
                _inputField('City / Country', cityCtrl,
                    hint: 'e.g. Bengaluru, India'),
                const SizedBox(height: 12),
                _inputField('Phone', phoneCtrl,
                    hint: '+91 9876543210', keyboard: TextInputType.phone),
                const SizedBox(height: 12),
                _inputField('Bio', bioCtrl,
                    hint: 'Brief intro about yourself', maxLines: 2),
                const SizedBox(height: 12),
                _dropdownField(
                    'Target Role', role, roles, (v) => setBS(() => role = v!)),
                const SizedBox(height: 12),
                _dropdownField(
                    'Experience', exp, exps, (v) => setBS(() => exp = v!)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final user = _auth.currentUser;
                      if (user != null) {
                        final name = nameCtrl.text.trim();
                        if (name.isNotEmpty) await user.updateDisplayName(name);
                        await _firestore
                            .collection('users')
                            .doc(user.uid)
                            .update({
                          'name': name,
                          'city': cityCtrl.text.trim(),
                          'phone': phoneCtrl.text.trim(),
                          'bio': bioCtrl.text.trim(),
                          'targetRole': role,
                          'experience': exp,
                          'updatedAt': DateTime.now().toIso8601String(),
                        });
                        if (!mounted) return;
                        setState(() {
                          _userName = name.isNotEmpty ? name : _userName;
                          _city = cityCtrl.text.trim();
                          _phone = phoneCtrl.text.trim();
                          _bio = bioCtrl.text.trim();
                          _targetRole = role;
                          _experience = exp;
                        });
                      }
                      if (mounted) Navigator.pop(context);
                      _snack('Profile updated ✓');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Save Changes',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addSkills() {
    final allSkills = [
      'Python',
      'PyTorch',
      'TensorFlow',
      'Scikit-learn',
      'NumPy',
      'Pandas',
      'Machine Learning',
      'Deep Learning',
      'NLP',
      'Computer Vision',
      'LLMs',
      'LangChain',
      'HuggingFace',
      'RAG',
      'Prompt Engineering',
      'MLOps',
      'Docker',
      'Kubernetes',
      'FastAPI',
      'AWS',
      'GCP',
      'Azure',
      'SQL',
      'Spark',
      'Airflow',
      'Git',
      'Linux',
      'Statistics',
      'R',
      'YOLO',
      'OpenCV',
      'Transformers',
      'BERT',
      'GPT',
      'LoRA',
      'RLHF',
    ];
    final selected = Set<String>.from(_userSkills);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setBS) => DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollCtrl) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Row(
                  children: [
                    const Text('Add Skills',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        final user = _auth.currentUser;
                        if (user != null) {
                          final list = selected.toList();
                          await _firestore
                              .collection('users')
                              .doc(user.uid)
                              .update({'skills': list});
                          if (!mounted) return;
                          setState(() => _userSkills = list);
                        }
                        if (mounted) Navigator.pop(context);
                        _snack('Skills updated ✓');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allSkills.map((s) {
                        final sel = selected.contains(s);
                        return GestureDetector(
                          onTap: () => setBS(() {
                            if (sel) {
                              selected.remove(s);
                            } else {
                              selected.add(s);
                            }
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: sel
                                  ? _primary.withOpacity(0.2)
                                  : const Color(0xFF0F0F20),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: sel ? _primary : _border,
                                  width: sel ? 1.5 : 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (sel)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Icon(Icons.check,
                                        size: 12, color: _secondary),
                                  ),
                                Text(s,
                                    style: TextStyle(
                                        color: sel
                                            ? _secondary
                                            : const Color(0xFF888899),
                                        fontSize: 12,
                                        fontWeight: sel
                                            ? FontWeight.w600
                                            : FontWeight.normal)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword() async {
    final user = _auth.currentUser;
    if (user?.email == null) return;
    try {
      await _auth.sendPasswordResetEmail(email: user!.email!);
      _snack('Password reset email sent to ${user.email}');
    } catch (e) {
      _snack('Error: $e');
    }
  }

  void _checkEmailVerified() {
    final user = _auth.currentUser;
    if (user == null) return;
    if (user.emailVerified) {
      _snack('✅ Email is verified');
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: _surface,
          title:
              const Text('Verify Email', style: TextStyle(color: Colors.white)),
          content: const Text(
              'Your email is not verified. Send a verification email?',
              style: TextStyle(color: _muted)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: _muted)),
            ),
            ElevatedButton(
              onPressed: () async {
                await user.sendEmailVerification();
                if (mounted) Navigator.pop(context);
                _snack('Verification email sent ✓');
              },
              style: ElevatedButton.styleFrom(backgroundColor: _primary),
              child: const Text('Send'),
            ),
          ],
        ),
      );
    }
  }

  void _goSavedJobs() => Navigator.push(
      context, MaterialPageRoute(builder: (_) => const SavedJobsScreen()));

  void _showAppliedJobs() async {
    final user = _auth.currentUser;
    if (user == null) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: _surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollCtrl) => Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Text('My Applications',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('applications')
                    .where('userId', isEqualTo: user.uid)
                    .snapshots(),
                builder: (_, snap) {
                  if (!snap.hasData || snap.data!.docs.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.send_outlined, color: _muted, size: 44),
                          SizedBox(height: 12),
                          Text('No applications yet',
                              style: TextStyle(color: _muted)),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    itemCount: snap.data!.docs.length,
                    itemBuilder: (_, i) {
                      final d =
                          snap.data!.docs[i].data() as Map<String, dynamic>;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F0F20),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _border),
                        ),
                        child: Row(
                          children: [
                            Text(d['icon'] ?? '💼',
                                style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(d['jobTitle'] ?? '',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                  Text(d['companyName'] ?? '',
                                      style: const TextStyle(
                                          color: _muted, fontSize: 12)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _green.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('Applied',
                                  style:
                                      TextStyle(color: _green, fontSize: 10)),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResume() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('📄 Resume Summary',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            _resumeRow('👤 Name', _userName),
            _resumeRow('🎯 Role',
                _copilotRole.isNotEmpty ? _copilotRole : _targetRole),
            _resumeRow('📍 Location', _city),
            _resumeRow('⏱️ Experience', _experience),
            if (_userSkills.isNotEmpty)
              _resumeRow('🛠️ Skills', _userSkills.take(5).join(', ')),
            _resumeRow('💼 Applied', '$_appliedJobs jobs'),
            _resumeRow('⚡ XP', '$_xpPoints points'),
            _resumeRow('✅ Phases', '$_doneSteps / 15 completed'),
            const SizedBox(height: 16),
            const Text(
                '💡 Tip: Upload your full resume to LinkedIn and attach it when applying',
                style: TextStyle(color: _muted, fontSize: 12, height: 1.4)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _launch('https://www.linkedin.com'),
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('Open LinkedIn'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _secondary,
                  side: const BorderSide(color: _primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resumeRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(label,
                  style: const TextStyle(color: _muted, fontSize: 13)),
            ),
            Expanded(
              child: Text(value,
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ],
        ),
      );

  void _sendJobAlert() async {
    if (_userEmail.isEmpty) {
      _snack('No email found');
      return;
    }
    final uri = Uri(
      scheme: 'mailto',
      path: _userEmail,
      query:
          'subject=AI Job Alert Subscription&body=Subscribe me to AI/ML job alerts for ${_targetRole}.',
    );
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _rateApp() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.example.ai_career_app';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      _snack('Could not open Play Store');
    }
  }

  void _shareApp() async {
    final uri = Uri(
      scheme: 'mailto',
      path: '',
      query:
          'subject=Check out AI Career App!&body=I found this amazing AI Career App!%0A%0A'
          'Features:%0A'
          '• AI Learning Roadmap (15 phases)%0A'
          '• 100+ AI Job Listings%0A'
          '• AI Career Copilot%0A'
          '• AI Mentor (Aria)%0A'
          '• 60+ Courses + 50+ Tools%0A%0A'
          'https://play.google.com/store/apps/details?id=com.example.ai_career_app',
    );
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _joinCommunity() async {
    const url = 'https://t.me/aicareercommunity';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      _snack('Could not open Telegram');
    }
  }

  void _showHelp() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('📞 Help & Support',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _helpOption(Icons.email_outlined, 'Email Support',
                'mailto:support@aicareerapp.com?subject=Support Request'),
            _helpOption(Icons.telegram, 'Join Telegram Community',
                'https://t.me/aicareercommunity'),
            _helpOption(Icons.menu_book_outlined, 'User Guide / FAQ',
                'https://aicareerapp.com/faq'),
            _helpOption(Icons.bug_report_outlined, 'Report a Bug',
                'mailto:bugs@aicareerapp.com?subject=Bug Report'),
          ],
        ),
      ),
    );
  }

  Widget _helpOption(IconData icon, String title, String url) {
    return GestureDetector(
      onTap: () => _launch(url),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F20),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: _secondary, size: 20),
            const SizedBox(width: 12),
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: _muted),
          ],
        ),
      ),
    );
  }

  void _openPrivacy() => _launch('https://aicareerapp.com/privacy');

  void _showAbout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('About AI Career App',
            style: TextStyle(color: Colors.white)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0',
                style: TextStyle(color: _muted, fontSize: 13)),
            SizedBox(height: 8),
            Text(
              'AI Career App helps you navigate your AI career journey '
              'with a personalised roadmap, 100+ real job listings, '
              'an AI mentor, curated courses, and an AI Copilot that '
              'analyses your skills and generates a learning plan.',
              style:
                  TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: _secondary)),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to log out?',
            style: TextStyle(color: _muted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _muted)),
          ),
          ElevatedButton(
            onPressed: () async {
              await _auth.signOut();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Account', style: TextStyle(color: _red)),
        content: const Text(
          'This will permanently delete your account and all data. This cannot be undone.',
          style: TextStyle(color: _muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _muted)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final user = _auth.currentUser;
                if (user != null) {
                  await _firestore.collection('users').doc(user.uid).delete();
                  await user.delete();
                }
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
                  );
                }
              } catch (e) {
                if (mounted) Navigator.pop(context);
                _snack('Re-login required to delete account');
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: _red,
                foregroundColor: Colors.white,
                elevation: 0),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ── Form helpers ────────────────────────────────────────────────────
  Widget _inputField(String label, TextEditingController ctrl,
      {String? hint, int maxLines = 1, TextInputType? keyboard}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _muted, fontSize: 12)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: keyboard,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: _muted, fontSize: 13),
            filled: true,
            fillColor: const Color(0xFF0F0F20),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _primary, width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _dropdownField(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _muted, fontSize: 12)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF0F0F20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : items.first,
              isExpanded: true,
              dropdownColor: _surface,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              iconEnabledColor: _secondary,
              items: items
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // ── Utilities ───────────────────────────────────────────────────────
  Widget _sectionTitle(String t) => Text(t,
      style: const TextStyle(
          color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600));

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: _surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ── Recommended skills per role ─────────────────────────────────────
  List<String> _recommendedSkills(String role) {
    final map = <String, List<String>>{
      'AI Engineer': [
        'Python',
        'PyTorch',
        'LLMs',
        'LangChain',
        'FastAPI',
        'Docker',
        'AWS'
      ],
      'ML Engineer': [
        'Python',
        'Scikit-learn',
        'XGBoost',
        'PyTorch',
        'MLflow',
        'Docker',
        'SQL'
      ],
      'Data Scientist': [
        'Python',
        'SQL',
        'Pandas',
        'NumPy',
        'Matplotlib',
        'Scikit-learn',
        'Statistics'
      ],
      'NLP Engineer': [
        'Python',
        'HuggingFace',
        'Transformers',
        'BERT',
        'spaCy',
        'LLMs',
        'RAG'
      ],
      'CV Engineer': [
        'Python',
        'PyTorch',
        'OpenCV',
        'YOLO',
        'CNN',
        'TensorRT',
        'Albumentations'
      ],
      'Prompt Engineer': [
        'Python',
        'Prompt Engineering',
        'LangChain',
        'OpenAI API',
        'RAG',
        'Evaluation'
      ],
      'AI Researcher': [
        'Python',
        'PyTorch',
        'JAX',
        'Statistics',
        'LaTeX',
        'Papers',
        'Mathematics'
      ],
      'AI Product Manager': [
        'SQL',
        'Python basics',
        'ML concepts',
        'A/B Testing',
        'Product Strategy'
      ],
      'Software Engineer': [
        'Data Structures & Algorithms',
        'System Design',
        'Git',
        'Testing',
        'APIs',
        'Databases'
      ],
    };
    return map[role] ?? map['AI Engineer']!;
  }
}

// ══════════════════════════════════════════════════════════════════════
// LEVEL MODEL
// ══════════════════════════════════════════════════════════════════════
class _Level {
  final String name;
  final int minXp;
  final int maxXp;
  final Color color;
  const _Level(this.name, this.minXp, this.maxXp, this.color);
}
