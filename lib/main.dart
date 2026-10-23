
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

  // Firebase must be ready before SplashScreen checks authentication.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Keep existing environment configuration available to app services.
  await dotenv.load(fileName: '.env');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Start the app without waiting for notification setup.
  runApp(const AICareerApp());

  // Notification initialization runs after runApp.
  unawaited(_initializeNotifications());
}

Future<void> _initializeNotifications() async {
  try {
    await FirebaseMessaging.instance.requestPermission();

    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $token');
  } catch (e, stackTrace) {
    debugPrint('FCM initialization warning: $e');
    debugPrintStack(stackTrace: stackTrace);
  }

  try {
    await NotificationService.init();
  } catch (e, stackTrace) {
    debugPrint('Notification service warning: $e');
    debugPrintStack(stackTrace: stackTrace);
  }
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
          bottomNavigationBarTheme:
              const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF13131F),
            selectedItemColor: Color(0xFFA78BFA),
            unselectedItemColor: Color(0xFF666677),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
