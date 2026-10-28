import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'screens/main_screen.dart';
import 'screens/splash_screen.dart';
import 'firebase_options.dart';
import 'services/copilot_provider.dart';
import 'services/copilot_controller.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Start required initialization, but do not block runApp().
  // SplashScreen renders immediately while this future completes.
  final startupFuture = _initializeStartup();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(AICareerApp(startupFuture: startupFuture));

  // Notifications are initialized after required startup work and never
  // block the first Flutter frame.
  unawaited(_initializeNotifications(startupFuture));
}

Future<void> _initializeStartup() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Preserve existing .env configuration. Log a clear error if missing;
  // the splash remains visible rather than querying services too early.
  try {
    await dotenv.load(fileName: '.env');
  } catch (e, stackTrace) {
    debugPrint('Environment configuration warning: $e');
    debugPrintStack(stackTrace: stackTrace);
  }
}

Future<void> _initializeNotifications(Future<void> startupFuture) async {
  try {
    await startupFuture;
    await FirebaseMessaging.instance.requestPermission();

    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $token');
  } catch (e, stackTrace) {
    debugPrint('FCM initialization warning: $e');
    debugPrintStack(stackTrace: stackTrace);
  }

  try {
    await startupFuture;
    await NotificationService.init();
  } catch (e, stackTrace) {
    debugPrint('Notification service warning: $e');
    debugPrintStack(stackTrace: stackTrace);
  }
}

class AICareerApp extends StatelessWidget {
  const AICareerApp({
    super.key,
    required this.startupFuture,
  });

  final Future<void> startupFuture;

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
            primary: Color(0xFF7C3AED),
            secondary: Color(0xFFA78BFA),
            surface: Color(0xFF1A1A2E),
            background: Color(0xFF0F0F1A),
          ),
          textTheme: GoogleFonts.interTextTheme(
            ThemeData.dark().textTheme,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0F0F1A),
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF13131F),
            selectedItemColor: Color(0xFFA78BFA),
            unselectedItemColor: Color(0xFF666677),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
          ),
        ),
        home: SplashScreen(startupFuture: startupFuture),
      ),
    );
  }
}
