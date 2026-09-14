// ══════════════════════════════════════════════════════════════════════
// lib/main.dart
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'firebase_options.dart';
import 'services/copilot_provider.dart';
import 'services/copilot_controller.dart';
import 'services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );

  await FirebaseMessaging.instance.requestPermission();
  String? token = await FirebaseMessaging.instance.getToken();
  debugPrint("FCM Token: $token");

  await dotenv.load(fileName: '.env');

  await NotificationService.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:           Colors.transparent,
      statusBarIconBrightness:  Brightness.light,
    ),
  );

  runApp(const AICareerApp());
}

class AICareerApp extends StatelessWidget {
  const AICareerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CopilotProvider(
      controller: CopilotController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AI Career App',
        routes: {
          '/home': (_) => const MainScreen(),
        },
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0F0F1A),
          colorScheme: const ColorScheme.dark(
            primary:    Color(0xFF7C3AED),
            secondary:  Color(0xFFA78BFA),
            surface:    Color(0xFF1A1A2E),
            background: Color(0xFF0F0F1A),
          ),
          textTheme: GoogleFonts.interTextTheme(
            ThemeData.dark().textTheme,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0F0F1A),
            elevation: 0,
            titleTextStyle: TextStyle(
              color:      Colors.white,
              fontSize:   18,
              fontWeight: FontWeight.w600,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor:     Color(0xFF13131F),
            selectedItemColor:   Color(0xFFA78BFA),
            unselectedItemColor: Color(0xFF666677),
            type:      BottomNavigationBarType.fixed,
            elevation: 0,
          ),
        ),
        // ✅ SplashScreen is always home — it handles routing internally
        home: const SplashScreen(),
      ),
    );
  }
}