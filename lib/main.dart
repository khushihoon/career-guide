import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'screens/main_screen.dart';
import 'screens/splash_screen.dart';
import 'firebase_options.dart';
import 'services/copilot_provider.dart';
import 'services/copilot_controller.dart';
import 'services/course_generator_service.dart';
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
  // block the first Flutter frame. Every Firebase call in there waits for
  // startupFuture, i.e. for Firebase.initializeApp() AND App Check activation.
  unawaited(_initializeNotifications(startupFuture));
}

Future<void> _initializeStartup() async {
  // 1. Firebase core. Nothing below touches Firebase before this completes.
  await _initializeFirebase();

  // 2. App Check, immediately after Firebase.initializeApp() and before any
  //    other Firebase-dependent work. This never throws (see below).
  await _activateAppCheck();

  // SECURITY: .env is no longer bundled as an app asset (it would ship inside
  // the APK). isOptional keeps dotenv initialised (empty) so any existing
  // dotenv.env reads do not crash. Secrets live ONLY on the backend server.
  try {
    await dotenv.load(fileName: '.env', isOptional: true);
  } catch (e, stackTrace) {
    debugPrint('Environment configuration warning: $e');
    debugPrintStack(stackTrace: stackTrace);
  }

  // Lets CourseGeneratorService authenticate to the backend. If the user is
  // signed out (null token) it simply uses the built-in free local generator.
  CourseGeneratorService.authTokenProvider =
      () async => FirebaseAuth.instance.currentUser?.getIdToken();
}

/// Initializes the default Firebase app.
///
/// A `duplicate-app` error (for example when a native auto-initialised
/// default app already exists) is tolerated; every other error is rethrown
/// exactly as before, so SplashScreen still receives it through
/// [startupFuture].
Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
    debugPrint('Firebase was already initialized; reusing the existing app.');
  }
}

// Memoised so App Check can never be activated twice by this file.
Future<void>? _appCheckActivation;

/// Activates Firebase App Check once. NEVER throws and never blocks startup
/// for more than 10 seconds.
///
/// On failure the app simply has no App Check token. Backend calls are then
/// sent without the `X-Firebase-AppCheck` header and an enforcing backend
/// rejects them (fail closed). The free, offline LocalCourseGenerator keeps
/// working. Nothing here bypasses or weakens backend enforcement.
Future<void> _activateAppCheck() =>
    _appCheckActivation ??= _runAppCheckActivation();

Future<void> _runAppCheckActivation() async {
  try {
    await _activateAppCheckForPlatform().timeout(const Duration(seconds: 10));
  } on TimeoutException {
    debugPrint(
      'App Check activation timed out. Protected backend calls will be '
      'rejected until App Check is available; free local content still works.',
    );
  } catch (e, stackTrace) {
    // Log only the exception type (and the Firebase error code, which is not
    // secret). Never log tokens or full exception text.
    final code = e is FirebaseException ? ' (${e.code})' : '';
    debugPrint(
      'App Check activation failed: ${e.runtimeType}$code. Protected backend '
      'calls will be rejected; free local content still works.',
    );
    if (kDebugMode) debugPrintStack(stackTrace: stackTrace);
  }
}

/// Provider selection. Uses [kDebugMode] (a compile-time constant), so every
/// debug provider is removed from Profile and Release builds by tree shaking.
///
///  Android Debug              -> AndroidDebugProvider
///  Android Profile / Release  -> AndroidPlayIntegrityProvider
///  iOS Debug                  -> AppleDebugProvider
///  iOS Profile / Release      -> AppleDeviceCheckProvider
///  Chrome / web Debug         -> WebDebugProvider
///  Web Profile / Release      -> NOT activated (reCAPTCHA production
///                                configuration is deferred until approved)
///
/// No debug token is written anywhere in code. In Debug builds the platform
/// SDK generates one per install and prints it only to the local debug
/// console (logcat / browser console); register it in Firebase Console.
Future<void> _activateAppCheckForPlatform() async {
  final appCheck = FirebaseAppCheck.instance;

  if (kIsWeb) {
    if (kDebugMode) {
      await appCheck.activate(providerWeb: WebDebugProvider());
      await appCheck.setTokenAutoRefreshEnabled(true);
    } else {
      debugPrint(
        'App Check: web profile/release provider is deferred until reCAPTCHA '
        'production configuration is approved; App Check is not activated.',
      );
    }
    return;
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      await appCheck.activate(
        providerAndroid: kDebugMode
            ? const AndroidDebugProvider()
            : const AndroidPlayIntegrityProvider(),
      );
      break;
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      await appCheck.activate(
        providerApple: kDebugMode
            ? const AppleDebugProvider()
            : const AppleDeviceCheckProvider(),
      );
      break;
    default:
      debugPrint('App Check: this platform is not supported; not activated.');
      return;
  }
  await appCheck.setTokenAutoRefreshEnabled(true);
}

Future<void> _initializeNotifications(Future<void> startupFuture) async {
  try {
    await startupFuture;
    await FirebaseMessaging.instance.requestPermission();

    // Never print the FCM token in release logs.
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) debugPrint('FCM token obtained.');
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