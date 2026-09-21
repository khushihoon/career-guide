// ══════════════════════════════════════════════════════════════════════
// lib/screens/splash_screen.dart
//
// Career Guide — Cinematic Splash Screen
// Flow: App open → Splash (~5s) → LoginScreen (logged out)
//                               → MainScreen  (already logged in)
//
// Fully self-contained — no external image assets required.
// The "Ascent Badge" mark (hexagon + rising bars + spark) is drawn
// natively with CustomPainter so it never fails to load.
// ══════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Palette ────────────────────────────────────────────────────────
  static const _bgTop     = Color(0xFF190C3B);
  static const _bgMid     = Color(0xFF0E0A24);
  static const _bgBottom  = Color(0xFF06050F);
  static const _primary   = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _accent    = Color(0xFF22D3EE);
  static const _horizon   = Color(0xFFFDE68A);

  // ── Controllers ──────────────────────────────────────────────────────
  late final AnimationController _bgCtrl;
  late final AnimationController _pathCtrl;
  late final AnimationController _floatCtrl;
  late final AnimationController _orbitCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _progressCtrl;

  late final Animation<double> _orbitAnim;
  late final Animation<double> _pulseAnim;

  static const int _splashMs = 4800;

  final List<String> _stages = const ['Learn', 'Practice', 'Build', 'Grow'];
  int  _stageIndex = 0;
  bool _exiting    = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Slow ambient loop — stars twinkle, light streaks drift
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Flowing light along the career path
    _pathCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    // Floating career icons bobbing
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    // Orbit ring around the logo — 9 s full rotation
    _orbitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();
    _orbitAnim = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _orbitCtrl, curve: Curves.linear),
    );

    // Logo breathing pulse
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.06).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Loading progress bar
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _splashMs - 300),
    )..forward();

    Future.delayed(const Duration(milliseconds: 500), _rotateStages);
    Future.delayed(const Duration(milliseconds: _splashMs), _navigate);
  }

  void _rotateStages() {
    if (!mounted || _exiting) return;
    Future.delayed(const Duration(milliseconds: 950), () {
      if (!mounted || _exiting) return;
      setState(() => _stageIndex = (_stageIndex + 1) % _stages.length);
      _rotateStages();
    });
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    setState(() => _exiting = true);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    final user = FirebaseAuth.instance.currentUser;
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder: (_, __, ___) =>
            user != null ? const MainScreen() : const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1.0).animate(anim),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _pathCtrl.dispose();
    _floatCtrl.dispose();
    _orbitCtrl.dispose();
    _pulseCtrl.dispose();
    _progressCtrl.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortSide = math.min(size.width, size.height);

    return Scaffold(
      backgroundColor: _bgBottom,
      body: AnimatedOpacity(
        opacity: _exiting ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildSky(size),
            _buildCityAndPath(),
            ..._buildFloatingIcons(size),
            SafeArea(child: _buildTopBar()),
            SafeArea(child: _buildCenterContent(shortSide)),
            SafeArea(child: _buildBottomLoader()),
          ],
        ),
      ),
    );
  }

  // ── Sky / background ────────────────────────────────────────────────
  Widget _buildSky(Size size) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_bgTop, _bgMid, _bgBottom],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _bgCtrl,
          builder: (_, __) => CustomPaint(
            painter: _StarFieldPainter(t: _bgCtrl.value),
            size: Size.infinite,
          ),
        ),
        Positioned(
          top: -size.height * 0.15, left: -size.width * 0.2,
          child: Container(
            width: size.width * 1.2, height: size.width * 1.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [_primary.withOpacity(0.14), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          top: -size.height * 0.05, right: -size.width * 0.25,
          child: Container(
            width: size.width, height: size.width,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [_accent.withOpacity(0.08), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── City skyline + rising career path ───────────────────────────────
  Widget _buildCityAndPath() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _pathCtrl,
        builder: (_, __) => CustomPaint(
          painter: _PathPainter(flow: _pathCtrl.value),
          size: Size.infinite,
        ),
      ),
    );
  }

  // ── Floating career icons along the path ────────────────────────────
  List<Widget> _buildFloatingIcons(Size size) {
    final icons = <_CareerIcon>[
      _CareerIcon(icon: Icons.school_rounded,      leftFrac: 0.20, topFrac: 0.72, size: 44, seed: 0.0, color: _accent),
      _CareerIcon(icon: Icons.code_rounded,         leftFrac: 0.78, topFrac: 0.63, size: 40, seed: 0.6, color: _secondary),
      _CareerIcon(icon: Icons.construction_rounded, leftFrac: 0.24, topFrac: 0.52, size: 34, seed: 1.2, color: _accent),
      _CareerIcon(icon: Icons.work_rounded,         leftFrac: 0.74, topFrac: 0.43, size: 30, seed: 1.8, color: _secondary),
      _CareerIcon(icon: Icons.emoji_events_rounded, leftFrac: 0.50, topFrac: 0.34, size: 26, seed: 2.4, color: _horizon),
    ];

    return icons.map((c) {
      return AnimatedBuilder(
        animation: _floatCtrl,
        builder: (_, __) {
          final bob = math.sin((_floatCtrl.value * 2 * math.pi) + c.seed) * 6;
          return Positioned(
            left: c.leftFrac * size.width - c.size / 2,
            top: c.topFrac * size.height - c.size / 2 + bob,
            child: Container(
              width: c.size, height: c.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF15102E).withOpacity(0.75),
                border: Border.all(color: c.color.withOpacity(0.45), width: 1.2),
                boxShadow: [
                  BoxShadow(color: c.color.withOpacity(0.35), blurRadius: 16, spreadRadius: 1),
                ],
              ),
              child: Icon(c.icon, size: c.size * 0.5, color: c.color),
            ),
          );
        },
      ).animate().fadeIn(delay: (700 + c.seed * 220).ms, duration: 600.ms);
    }).toList();
  }

  // ── Top bar: progression words + tagline ────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: _buildStageProgress()),
          const SizedBox(width: 12),
          Text(
            'A Brighter You',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w500,
            ),
          ).animate().fadeIn(delay: 900.ms, duration: 700.ms),
        ],
      ),
    );
  }

  Widget _buildStageProgress() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: List.generate(_stages.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white.withOpacity(0.25)),
          );
        }
        final idx = i ~/ 2;
        final active = idx == _stageIndex;
        return AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 400),
          style: TextStyle(
            color: active ? _accent : Colors.white.withOpacity(0.35),
            fontSize: active ? 13 : 12,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: 0.3,
          ),
          child: Text(_stages[idx]),
        );
      }),
    ).animate().fadeIn(delay: 700.ms, duration: 600.ms);
  }

  // ── Center: logo, name, tagline ──────────────────────────────────────
  Widget _buildCenterContent(double shortSide) {
    final double badgeSize = (shortSide * 0.42).clamp(150.0, 230.0).toDouble();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLogo(badgeSize),
          const SizedBox(height: 22),
          const Text(
            'CAREER GUIDE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 3.5,
            ),
          )
              .animate()
              .fadeIn(delay: 500.ms, duration: 650.ms)
              .slideY(begin: 0.25, end: 0, duration: 650.ms, curve: Curves.easeOut),
          const SizedBox(height: 8),
          Text(
            'PLAN  •  LEARN  •  BUILD  •  GROW',
            style: TextStyle(
              color: _secondary.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.2,
            ),
          ).animate().fadeIn(delay: 750.ms, duration: 600.ms),
        ],
      ),
    );
  }

  Widget _buildLogo(double badgeSize) {
    final ringSize = badgeSize * 1.55;
    return SizedBox(
      width: ringSize,
      height: ringSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _orbitAnim,
            builder: (_, __) => CustomPaint(
              size: Size(ringSize, ringSize),
              painter: _OrbitRingPainter(
                angle: _orbitAnim.value,
                primary: _primary,
                accent: _accent,
              ),
            ),
          ),
          Container(
            width: badgeSize * 1.05, height: badgeSize * 1.05,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _primary.withOpacity(0.22),
                  _primary.withOpacity(0.05),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, __) => Transform.scale(
              scale: _pulseAnim.value,
              child: CustomPaint(
                size: Size(badgeSize, badgeSize),
                painter: _AscentBadgePainter(glow: _pulseAnim.value),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.6, 0.6),
          end: const Offset(1.0, 1.0),
          duration: 800.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 550.ms);
  }

  // ── Bottom loader ────────────────────────────────────────────────────
  Widget _buildBottomLoader() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Getting your personalized journey ready...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12.5,
                letterSpacing: 0.3,
              ),
            ).animate().fadeIn(delay: 1300.ms, duration: 600.ms),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: _progressCtrl,
              builder: (_, __) {
                final v = Curves.easeOutCubic
                    .transform(_progressCtrl.value.clamp(0.0, 1.0).toDouble());
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        height: 5,
                        color: const Color(0xFF1E1E38),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: v,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                gradient: const LinearGradient(colors: [_accent, _primary]),
                                boxShadow: [
                                  BoxShadow(color: _accent.withOpacity(0.5), blurRadius: 8),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(v * 100).toInt()}%',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                );
              },
            ).animate().fadeIn(delay: 1400.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// DATA
// ══════════════════════════════════════════════════════════════════════

class _CareerIcon {
  final IconData icon;
  final double leftFrac;
  final double topFrac;
  final double size;
  final double seed;
  final Color color;
  const _CareerIcon({
    required this.icon,
    required this.leftFrac,
    required this.topFrac,
    required this.size,
    required this.seed,
    required this.color,
  });
}

class _Bar {
  final double x, w, h, opacity;
  const _Bar({required this.x, required this.w, required this.h, required this.opacity});
}

// ══════════════════════════════════════════════════════════════════════
// PAINTERS
// ══════════════════════════════════════════════════════════════════════

/// Twinkling stars + drifting light streaks.
class _StarFieldPainter extends CustomPainter {
  final double t;
  _StarFieldPainter({required this.t});

  static final List<Offset> _starFrac = List.generate(42, (i) {
    final rnd = math.Random(i * 97 + 11);
    return Offset(rnd.nextDouble(), rnd.nextDouble() * 0.7);
  });

  static final List<double> _seeds =
      List.generate(42, (i) => math.Random(i * 13 + 3).nextDouble());

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < _starFrac.length; i++) {
      final o = _starFrac[i];
      final seed = _seeds[i];
      final twinkle = (math.sin((t * 2 * math.pi) + seed * 10) + 1) / 2;
      final opacity = 0.15 + twinkle * 0.55;
      final r = 0.6 + (seed * 1.4);
      canvas.drawCircle(
        Offset(o.dx * size.width, o.dy * size.height),
        r,
        Paint()..color = Colors.white.withOpacity(opacity),
      );
    }

    for (int i = 0; i < 3; i++) {
      final seed = i * 0.33;
      final progress = (t + seed) % 1.0;
      final y = size.height * (0.08 + i * 0.14);
      final startX = -size.width * 0.3 + progress * size.width * 1.6;
      final rect = Rect.fromLTWH(startX, y, size.width * 0.32, 2);
      final paint = Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFF67E8F9).withOpacity(0.5),
            Colors.transparent,
          ],
        ).createShader(rect)
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(startX, y), Offset(startX + size.width * 0.32, y + 10), paint);
    }
  }

  @override
  bool shouldRepaint(_StarFieldPainter old) => old.t != t;
}

/// Skyline silhouette + perspective career road with flowing light.
class _PathPainter extends CustomPainter {
  final double flow;
  _PathPainter({required this.flow});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final horizonY = h * 0.40;
    final vanishX = w * 0.5;

    // Horizon glow
    canvas.drawCircle(
      Offset(vanishX, horizonY),
      w * 0.5,
      Paint()
        ..shader = RadialGradient(
          colors: [const Color(0xFFFDE68A).withOpacity(0.14), Colors.transparent],
        ).createShader(Rect.fromCircle(center: Offset(vanishX, horizonY), radius: w * 0.5)),
    );

    // City silhouette
    final buildingPaint = Paint()..color = const Color(0xFF120C2A);
    final rnd = math.Random(7);
    double x = 0;
    while (x < w) {
      final bw = 18 + rnd.nextDouble() * 30;
      final bh = 30 + rnd.nextDouble() * 90;
      final rect = Rect.fromLTWH(x, horizonY - bh, bw, bh);
      canvas.drawRect(rect, buildingPaint);
      final winPaint = Paint()
        ..color = const Color(0xFF67E8F9).withOpacity(0.18 + rnd.nextDouble() * 0.15);
      for (double wy = rect.top + 6; wy < rect.bottom - 4; wy += 10) {
        for (double wx = rect.left + 4; wx < rect.right - 4; wx += 8) {
          if (rnd.nextDouble() > 0.6) {
            canvas.drawRect(Rect.fromLTWH(wx, wy, 2, 3), winPaint);
          }
        }
      }
      x += bw + 4;
    }

    // Atmospheric scrim so the skyline fades into the sky
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, horizonY),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B0716), Colors.transparent],
        ).createShader(Rect.fromLTWH(0, 0, w, horizonY)),
    );

    // Road — perspective trapezoid rising to the horizon
    final roadTopHalfWidth = w * 0.03;
    final roadBottomHalfWidth = w * 0.42;
    final roadPath = Path()
      ..moveTo(vanishX - roadTopHalfWidth, horizonY)
      ..lineTo(vanishX + roadTopHalfWidth, horizonY)
      ..lineTo(vanishX + roadBottomHalfWidth, h)
      ..lineTo(vanishX - roadBottomHalfWidth, h)
      ..close();

    canvas.drawPath(
      roadPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF2A1B5C).withOpacity(0.55),
            const Color(0xFF120C2A).withOpacity(0.05),
          ],
        ).createShader(Rect.fromLTWH(0, horizonY, w, h - horizonY)),
    );

    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = const Color(0xFF7C3AED).withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawLine(
      Offset(vanishX - roadTopHalfWidth, horizonY),
      Offset(vanishX - roadBottomHalfWidth, h),
      edgePaint,
    );
    canvas.drawLine(
      Offset(vanishX + roadTopHalfWidth, horizonY),
      Offset(vanishX + roadBottomHalfWidth, h),
      edgePaint,
    );

    // Flowing light dashes climbing the road toward the horizon
    const dashCount = 9;
    for (int i = 0; i < dashCount; i++) {
      final tt = ((i / dashCount) + flow) % 1.0;
      final yy = horizonY + tt * (h - horizonY);
      final dashW = 3 + tt * 10;
      final dashH = 8 + tt * 22;
      final opacity = 0.25 + (1 - tt) * 0.5;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(vanishX, yy), width: dashW, height: dashH),
          const Radius.circular(3),
        ),
        Paint()..color = const Color(0xFF67E8F9).withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(_PathPainter old) => old.flow != flow;
}

/// The Career Guide "Ascent Badge" mark — hexagon badge with three rising
/// diagonal bars culminating in a glowing spark node.
class _AscentBadgePainter extends CustomPainter {
  final double glow;
  _AscentBadgePainter({required this.glow});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final cx = w / 2;
    final cy = size.height / 2;
    final r = w / 2 * 0.94;

    Offset hexPoint(double angleDeg) {
      final a = angleDeg * math.pi / 180;
      return Offset(cx + r * math.cos(a), cy + r * math.sin(a));
    }

    final hexPath = Path()
      ..moveTo(hexPoint(-90).dx, hexPoint(-90).dy)
      ..lineTo(hexPoint(-30).dx, hexPoint(-30).dy)
      ..lineTo(hexPoint(30).dx, hexPoint(30).dy)
      ..lineTo(hexPoint(90).dx, hexPoint(90).dy)
      ..lineTo(hexPoint(150).dx, hexPoint(150).dy)
      ..lineTo(hexPoint(210).dx, hexPoint(210).dy)
      ..close();

    canvas.drawPath(
      hexPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Color(0xFF241454), Color(0xFF150E33), Color(0xFF0B0B16)],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
    );
    canvas.drawPath(
      hexPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = const Color(0xFF8B5CF6).withOpacity(0.5),
    );

    // Bevel highlights on the top two edges
    canvas.drawLine(
      hexPoint(-90), hexPoint(-30),
      Paint()
        ..strokeWidth = 2.4
        ..color = const Color(0xFFC4B5FD).withOpacity(0.45)
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      hexPoint(210), hexPoint(-90),
      Paint()
        ..strokeWidth = 2.4
        ..color = const Color(0xFFC4B5FD).withOpacity(0.3)
        ..strokeCap = StrokeCap.round,
    );

    // Ascending step bars
    final barBaseY = cy + r * 0.42;
    final barData = <_Bar>[
      _Bar(x: cx - r * 0.34, w: r * 0.19, h: r * 0.32, opacity: 0.55),
      _Bar(x: cx - r * 0.06, w: r * 0.19, h: r * 0.62, opacity: 0.78),
      _Bar(x: cx + r * 0.22, w: r * 0.19, h: r * 0.98, opacity: 1.0),
    ];

    for (final b in barData) {
      final rect = Rect.fromLTWH(b.x, barBaseY - b.h, b.w, b.h);
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(b.w * 0.18));
      canvas.drawRRect(
        rrect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              const Color(0xFF7C3AED).withOpacity(b.opacity),
              const Color(0xFF22D3EE).withOpacity(b.opacity),
            ],
          ).createShader(rect),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(b.x, rect.top, b.w, rect.height * 0.08),
          Radius.circular(b.w * 0.18),
        ),
        Paint()..color = Colors.white.withOpacity(0.35 * b.opacity),
      );
    }

    // Spark node above the tallest bar
    final lastBar = barData.last;
    final sparkCenter = Offset(lastBar.x + lastBar.w / 2, barBaseY - lastBar.h - r * 0.06);
    final sparkR = r * 0.1 * glow;
    canvas.drawCircle(
      sparkCenter,
      sparkR * 2.6,
      Paint()
        ..shader = RadialGradient(
          colors: [const Color(0xFF67E8F9).withOpacity(0.55 * glow), Colors.transparent],
        ).createShader(Rect.fromCircle(center: sparkCenter, radius: sparkR * 2.6)),
    );
    canvas.drawCircle(sparkCenter, sparkR, Paint()..color = const Color(0xFFA5F3FC));
    canvas.drawCircle(
      sparkCenter, sparkR,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.white.withOpacity(0.6),
    );
    canvas.drawCircle(
      Offset(sparkCenter.dx - sparkR * 0.3, sparkCenter.dy - sparkR * 0.3),
      sparkR * 0.3,
      Paint()..color = Colors.white.withOpacity(0.85),
    );
  }

  @override
  bool shouldRepaint(_AscentBadgePainter old) => old.glow != glow;
}

/// Rotating dashed light ring around the logo.
class _OrbitRingPainter extends CustomPainter {
  final double angle;
  final Color primary;
  final Color accent;
  _OrbitRingPainter({required this.angle, required this.primary, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 4;

    final dashPaint = Paint()
      ..color = primary.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    const dashCount = 54;
    const dashAngle = (2 * math.pi) / dashCount;
    for (int i = 0; i < dashCount; i++) {
      final s = i * dashAngle;
      final e = s + dashAngle * 0.5;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        s, e - s, false, dashPaint,
      );
    }

    final dx = cx + r * math.cos(angle);
    final dy = cy + r * math.sin(angle);
    canvas.drawCircle(
      Offset(dx, dy), 8,
      Paint()
        ..color = accent.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawCircle(Offset(dx, dy), 3.6, Paint()..color = accent);
    canvas.drawCircle(Offset(dx - 1, dy - 1), 1.3, Paint()..color = Colors.white.withOpacity(0.85));

    final dx2 = cx + r * math.cos(angle + math.pi);
    final dy2 = cy + r * math.sin(angle + math.pi);
    canvas.drawCircle(
      Offset(dx2, dy2), 7,
      Paint()
        ..color = primary.withOpacity(0.16)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawCircle(Offset(dx2, dy2), 2.8, Paint()..color = primary.withOpacity(0.7));
  }

  @override
  bool shouldRepaint(_OrbitRingPainter o) => o.angle != angle;
}