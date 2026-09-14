// ══════════════════════════════════════════════════════════════════════
// lib/screens/splash_screen.dart
//
// Professional Splash Screen
// Flow: App open → Splash (4.5s) → LoginScreen (logged out)
//                               → MainScreen  (already logged in)
//
// Logo path: assets/images/logo.png  ✅ FIXED
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
  // ── Design colours (match whole app) ────────────────────────────────
  static const _bg        = Color(0xFF0B0B16);
  static const _primary   = Color(0xFF7C3AED);
  static const _secondary = Color(0xFFA78BFA);
  static const _accent    = Color(0xFF06B6D4);

  // ── Controllers ───────────────────────────────────────────────────────
  late final AnimationController _orbitCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _shimmerCtrl;

  late final Animation<double> _orbitAnim;
  late final Animation<double> _pulseAnim;
  late final Animation<double> _shimmerAnim;

  // ── Taglines ─────────────────────────────────────────────────────────
  final List<String> _taglines = const [
    'Analyse · Learn · Grow',
    'AI Roadmap Personalised for You',
    '100+ Real AI Jobs, One App',
    'Your AI Mentor is Ready',
  ];
  int  _taglineIndex = 0;
  bool _exiting      = false;

  // ── Particles (fixed positions — no LayoutBuilder inside Stack) ──────
  static const List<_Particle> _particles = [
    _Particle(topFrac: 0.10, leftFrac: 0.07, size: 4, delay: 0),
    _Particle(topFrac: 0.17, leftFrac: 0.84, size: 3, delay: 300),
    _Particle(topFrac: 0.27, leftFrac: 0.21, size: 5, delay: 600),
    _Particle(topFrac: 0.34, leftFrac: 0.71, size: 3, delay: 200),
    _Particle(topFrac: 0.54, leftFrac: 0.09, size: 4, delay: 400),
    _Particle(topFrac: 0.61, leftFrac: 0.89, size: 3, delay: 700),
    _Particle(topFrac: 0.74, leftFrac: 0.29, size: 5, delay: 100),
    _Particle(topFrac: 0.79, leftFrac: 0.77, size: 3, delay: 500),
    _Particle(topFrac: 0.89, leftFrac: 0.54, size: 4, delay: 350),
  ];

  @override
  void initState() {
    super.initState();

    // Full-screen immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Orbit ring — 8 s full rotation
    _orbitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _orbitAnim = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _orbitCtrl, curve: Curves.linear),
    );

    // Pulse — logo breathing
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Shimmer bar
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut),
    );

    // Rotate taglines every 900 ms after initial 1.2 s delay
    Future.delayed(const Duration(milliseconds: 1200), _rotateTags);

    // Navigate at 4.5 s
    Future.delayed(const Duration(milliseconds: 4500), _navigate);
  }

  void _rotateTags() {
    if (!mounted || _exiting) return;
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted || _exiting) return;
      setState(() => _taglineIndex = (_taglineIndex + 1) % _taglines.length);
      _rotateTags();
    });
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    setState(() => _exiting = true);

    // Restore system UI
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
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) =>
            user != null ? const MainScreen() : const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _orbitCtrl.dispose();
    _pulseCtrl.dispose();
    _shimmerCtrl.dispose();
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

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── 1. Background ─────────────────────────────────────────
          _buildBackground(),

          // ── 2. Particles (use actual pixel values from size) ──────
          ..._particles.map((p) => Positioned(
                top:  p.topFrac  * size.height,
                left: p.leftFrac * size.width,
                child: _buildParticle(p),
              )),

          // ── 3. Main content ───────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Logo + orbit ring
                _buildLogoSection(),

                const SizedBox(height: 32),

                // App name
                const Text(
                  'AI Career App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 600.ms)
                    .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: 600.ms,
                        curve: Curves.easeOut),

                const SizedBox(height: 10),

                // Rotating tagline
                _buildTagline(),

                const Spacer(flex: 2),

                // Shimmer strip
                _buildShimmerStrip(),

                const SizedBox(height: 12),

                // Powered-by
                const Text(
                  'Powered by Claude AI  ·  Firebase  ·  Flutter',
                  style: TextStyle(
                    color: Color(0xFF3A3A55),
                    fontSize: 11,
                    letterSpacing: 0.4,
                  ),
                ).animate().fadeIn(delay: 1600.ms, duration: 700.ms),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Background ────────────────────────────────────────────────────────
  Widget _buildBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Deep radial gradient
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.2),
              radius: 1.1,
              colors: [Color(0xFF1A0A35), Color(0xFF0B0B16)],
            ),
          ),
        ),
        // Grid dots
        CustomPaint(painter: _GridPainter()),
        // Top-right cyan glow
        Positioned(
          top: -60, right: -60,
          child: Container(
            width: 260, height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [_accent.withOpacity(0.07), Colors.transparent],
              ),
            ),
          ),
        ),
        // Bottom-left purple glow
        Positioned(
          bottom: -80, left: -80,
          child: Container(
            width: 300, height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [_primary.withOpacity(0.09), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Single particle widget ────────────────────────────────────────────
  Widget _buildParticle(_Particle p) {
    return SizedBox(
      width: p.size,
      height: p.size,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _secondary.withOpacity(0.35),
        ),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .fadeIn(
              delay: Duration(milliseconds: p.delay), duration: 800.ms)
          .then()
          .fadeOut(duration: 800.ms),
    );
  }

  // ── Logo section ──────────────────────────────────────────────────────
  Widget _buildLogoSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer dashed orbit ring with glowing dots
        AnimatedBuilder(
          animation: _orbitAnim,
          builder: (_, __) => CustomPaint(
            size: const Size(210, 210),
            painter: _OrbitPainter(
              angle: _orbitAnim.value,
              primaryColor: _primary,
              accentColor: _accent,
            ),
          ),
        ),

        // Inner radial glow
        Container(
          width: 155, height: 155,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                _primary.withOpacity(0.18),
                _primary.withOpacity(0.04),
                Colors.transparent,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),

        // Logo with pulse
        AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, child) =>
              Transform.scale(scale: _pulseAnim.value, child: child),
          child: Container(
            width: 122, height: 122,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF12112A),
              border: Border.all(
                color: _secondary.withOpacity(0.45),
                width: 1.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: _primary.withOpacity(0.40),
                  blurRadius: 32,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: _accent.withOpacity(0.14),
                  blurRadius: 52,
                  spreadRadius: 10,
                ),
              ],
            ),
            padding: const EdgeInsets.all(18),
            // ✅ CORRECT logo path
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.auto_awesome,
                size: 58,
                color: _secondary,
              ),
            ),
          ),
        ),

        // Sparkle dots on orbit
        AnimatedBuilder(
          animation: _orbitAnim,
          builder: (_, __) => CustomPaint(
            size: const Size(210, 210),
            painter: _SparklePainter(
                angle: _orbitAnim.value, color: _secondary),
          ),
        ),
      ],
    )
        .animate()
        .scale(
          begin: const Offset(0.65, 0.65),
          end: const Offset(1.0, 1.0),
          duration: 750.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 500.ms);
  }

  // ── Rotating tagline ──────────────────────────────────────────────────
  Widget _buildTagline() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.4),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        ),
      ),
      child: Text(
        _taglines[_taglineIndex],
        key: ValueKey(_taglineIndex),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _secondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // ── Shimmer loading strip ─────────────────────────────────────────────
  Widget _buildShimmerStrip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 56),
      child: AnimatedBuilder(
        animation: _shimmerAnim,
        builder: (_, __) {
          return Container(
            height: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFF1E1E38),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: ShaderMask(
                shaderCallback: (rect) => LinearGradient(
                  begin: Alignment(_shimmerAnim.value - 1, 0),
                  end:   Alignment(_shimmerAnim.value + 1, 0),
                  colors: const [
                    Colors.transparent,
                    _secondary,
                    _primary,
                    _secondary,
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                ).createShader(rect),
                child: Container(color: Colors.white),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 1200.ms, duration: 500.ms);
  }
}

// ══════════════════════════════════════════════════════════════════════
// DATA
// ══════════════════════════════════════════════════════════════════════

class _Particle {
  final double topFrac;
  final double leftFrac;
  final double size;
  final int    delay;
  const _Particle({
    required this.topFrac,
    required this.leftFrac,
    required this.size,
    required this.delay,
  });
}

// ══════════════════════════════════════════════════════════════════════
// PAINTERS
// ══════════════════════════════════════════════════════════════════════

class _OrbitPainter extends CustomPainter {
  final double angle;
  final Color  primaryColor;
  final Color  accentColor;

  const _OrbitPainter({
    required this.angle,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width  / 2;
    final cy = size.height / 2;
    final r  = size.width  / 2 - 2;

    // Dashed ring
    final dashPaint = Paint()
      ..color      = primaryColor.withOpacity(0.28)
      ..style      = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const dashCount = 48;
    const dashAngle = (2 * math.pi) / dashCount;
    for (int i = 0; i < dashCount; i++) {
      final s = i * dashAngle;
      final e = s + dashAngle * 0.55;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        s, e - s, false, dashPaint,
      );
    }

    // Leading cyan dot
    final dx = cx + r * math.cos(angle);
    final dy = cy + r * math.sin(angle);
    canvas.drawCircle(Offset(dx, dy), 9,
        Paint()
          ..color      = accentColor.withOpacity(0.18)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9));
    canvas.drawCircle(Offset(dx, dy), 4.2, Paint()..color = accentColor);
    canvas.drawCircle(Offset(dx - 1, dy - 1), 1.6,
        Paint()..color = Colors.white.withOpacity(0.85));

    // Trailing purple dot (180° offset)
    final dx2 = cx + r * math.cos(angle + math.pi);
    final dy2 = cy + r * math.sin(angle + math.pi);
    canvas.drawCircle(Offset(dx2, dy2), 8,
        Paint()
          ..color      = primaryColor.withOpacity(0.15)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7));
    canvas.drawCircle(Offset(dx2, dy2), 3.2,
        Paint()..color = primaryColor.withOpacity(0.72));
  }

  @override
  bool shouldRepaint(_OrbitPainter o) => o.angle != angle;
}

class _SparklePainter extends CustomPainter {
  final double angle;
  final Color  color;
  const _SparklePainter({required this.angle, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width  / 2;
    final cy = size.height / 2;
    final r  = size.width  / 2 - 2;

    for (int i = 0; i < 4; i++) {
      final a       = angle * 0.4 + (i * math.pi / 2);
      final px      = cx + r * math.cos(a);
      final py      = cy + r * math.sin(a);
      final opacity = (0.5 + 0.5 * math.sin(angle * 2 + i)).clamp(0.2, 0.9);
      _star(canvas, Offset(px, py), 3, color.withOpacity(opacity));
    }
  }

  void _star(Canvas canvas, Offset c, double r, Color col) {
    final p = Path();
    for (int i = 0; i < 4; i++) {
      final a = i * math.pi / 2;
      final o = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      final n = Offset(
          c.dx + r * 0.4 * math.cos(a + math.pi / 4),
          c.dy + r * 0.4 * math.sin(a + math.pi / 4));
      if (i == 0) p.moveTo(o.dx, o.dy); else p.lineTo(o.dx, o.dy);
      p.lineTo(n.dx, n.dy);
    }
    p.close();
    canvas.drawPath(p, Paint()..color = col);
  }

  @override
  bool shouldRepaint(_SparklePainter o) => o.angle != angle;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7C3AED).withOpacity(0.055)
      ..style = PaintingStyle.fill;
    const spacing = 30.0;
    for (double x = 0; x < size.width;  x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter _) => false;
}