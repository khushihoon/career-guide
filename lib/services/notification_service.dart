// ══════════════════════════════════════════════════════════════════════
// lib/services/notification_service.dart
//
// Professional AI Career App — Notification Service
//
// Features:
//  • Permission request (Android 13+ / iOS)
//  • 8 smart notification types with real job/course data
//  • Daily motivation (rotating tips)
//  • Scheduled daily reminders (9 AM, 7 PM)
//  • Streak alerts & XP milestone notifications
//  • New job alert with real company/role data
//  • Course recommendation based on random pick from kCourses
//  • Notification tap → deep link payload routing
//  • Full channel setup (Android 8+)
//  • One-line API from anywhere in the app
//
// ═══ SETUP — 3 steps ONLY ════════════════════════════════════════════
//  1. pubspec.yaml  →  flutter_local_notifications: ^17.2.2
//  2. AndroidManifest.xml  →  see _AndroidManifestSnippet below
//  3. main.dart  →  await NotificationService.init();
//                   (before runApp or right after Firebase.initializeApp)
// ══════════════════════════════════════════════════════════════════════

// ═══ AndroidManifest.xml additions (inside <manifest>) ═══════════════
// <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
// <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
// <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
//
// Inside <application>:
// <receiver android:exported="false"
//     android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"/>
// <receiver android:exported="false"
//     android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
//   <intent-filter>
//     <action android:name="android.intent.action.BOOT_COMPLETED"/>
//     <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
//   </intent-filter>
// </receiver>
// ══════════════════════════════════════════════════════════════════════

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ─── Notification IDs (never collide) ────────────────────────────────
class _NID {
  static const int welcome         = 0;
  static const int dailyMorning    = 1;
  static const int dailyEvening    = 2;
  static const int newJob          = 3;
  static const int courseRec       = 4;
  static const int streakReminder  = 5;
  static const int xpMilestone     = 6;
  static const int goalReminder    = 7;
  static const int weeklyDigest    = 8;
  static const int interviewTip    = 9;
  static const int salaryInsight   = 10;
}

// ─── Notification payload keys ────────────────────────────────────────
class NotificationPayload {
  static const String job      = 'job';
  static const String course   = 'course';
  static const String roadmap  = 'roadmap';
  static const String copilot  = 'copilot';
  static const String profile  = 'profile';
  static const String mentor   = 'mentor';
}

// ══════════════════════════════════════════════════════════════════════
// NOTIFICATION SERVICE
// ══════════════════════════════════════════════════════════════════════

class NotificationService {
  // Singleton
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialised = false;

  // Callback: called when user taps a notification (set from main.dart)
  static void Function(String payload)? onNotificationTap;

  // ══════════════════════════════════════════════════════════════════
  // INIT — call once in main.dart
  // ══════════════════════════════════════════════════════════════════
  static Future<void> init({
    void Function(String payload)? onTap,
  }) async {
    if (_initialised) return;
    onNotificationTap = onTap;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS     = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(android: android, iOS: iOS);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse res) {
        final payload = res.payload ?? '';
        debugPrint('🔔 Notification tapped: $payload');
        onNotificationTap?.call(payload);
      },
    );

    // Request Android 13+ permission
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialised = true;
    debugPrint('✅ NotificationService initialised');
  }

  // ══════════════════════════════════════════════════════════════════
  // CHANNELS — call once for Android 8+
  // ══════════════════════════════════════════════════════════════════
  static Future<void> createChannels() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    final channels = [
      const AndroidNotificationChannel(
        'ai_jobs',
        'New AI Jobs',
        description: 'Real-time AI & ML job alerts from top companies',
        importance: Importance.high,
        playSound: true,
      ),
      const AndroidNotificationChannel(
        'ai_courses',
        'Course Recommendations',
        description: 'Curated AI learning resources and course updates',
        importance: Importance.defaultImportance,
        playSound: true,
      ),
      const AndroidNotificationChannel(
        'ai_daily',
        'Daily Reminders',
        description: 'Daily motivation, goals, and career tips',
        importance: Importance.defaultImportance,
        playSound: true,
      ),
      const AndroidNotificationChannel(
        'ai_progress',
        'Progress & Achievements',
        description: 'XP milestones, streaks, and roadmap progress',
        importance: Importance.high,
        playSound: true,
      ),
      const AndroidNotificationChannel(
        'ai_tips',
        'Career Tips',
        description: 'Interview tips, salary insights, and career advice',
        importance: Importance.low,
        playSound: false,
      ),
    ];

    for (final ch in channels) {
      await android.createNotificationChannel(ch);
    }
  }

  // ══════════════════════════════════════════════════════════════════
  // NOTIFICATION DETAIL BUILDERS
  // ══════════════════════════════════════════════════════════════════

  static NotificationDetails _details({
    required String channelId,
    required String channelName,
    Importance importance = Importance.high,
    Priority priority = Priority.high,
    StyleInformation? styleInfo,
    String? ticker,
    bool playSound = true,
    bool enableVibration = true,
    List<AndroidNotificationAction>? actions,
  }) {
    final android = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: importance,
      priority: priority,
      playSound: playSound,
      enableVibration: enableVibration,
      ticker: ticker,
      styleInformation: styleInfo,
      actions: actions,
    );

    const iOS = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(android: android, iOS: iOS);
  }

  // ══════════════════════════════════════════════════════════════════
  // PUBLIC API
  // ══════════════════════════════════════════════════════════════════

  // ─── 1. Welcome notification (show on first launch) ───────────────
  static Future<void> showWelcome(String userName) async {
    _ensureInit();
    final first = userName.isNotEmpty ? userName.split(' ').first : 'there';
    await _plugin.show(
      _NID.welcome,
      '👋 Welcome, $first!',
      'Your AI career journey starts now. Set your goal and get your personalised roadmap in 60 seconds.',
      _details(
        channelId: 'ai_daily',
        channelName: 'Daily Reminders',
        styleInfo: const BigTextStyleInformation(
          'Your AI career journey starts now. Set your goal and get your personalised roadmap in 60 seconds. Tap to open your AI Copilot and analyse your skills →',
          htmlFormatBigText: true,
          contentTitle: '👋 Welcome aboard!',
          summaryText: 'AI Career App',
        ),
      ),
      payload: NotificationPayload.copilot,
    );
  }

  // ─── 2. New job alert with real job data ───────────────────────────
  static Future<void> showNewJobAlert({
    required String title,
    required String company,
    required String location,
    required String salary,
    required List<String> skills,
    String? applyUrl,
  }) async {
    _ensureInit();
    final skillStr = skills.take(3).join(' · ');
    await _plugin.show(
      _NID.newJob,
      '💼 New Job: $title at $company',
      '$location · $salary',
      _details(
        channelId: 'ai_jobs',
        channelName: 'New AI Jobs',
        importance: Importance.high,
        ticker: 'New AI Job Alert',
        styleInfo: BigTextStyleInformation(
          '📍 $location\n💰 $salary\n🛠️ Skills: $skillStr\n\nTap to view and apply →',
          htmlFormatBigText: false,
          contentTitle: '$title at $company',
          summaryText: 'AI Career App · Job Alert',
        ),
        actions: const [
          AndroidNotificationAction('apply', 'Apply Now', showsUserInterface: true),
          AndroidNotificationAction('save', 'Save Job'),
        ],
      ),
      payload: NotificationPayload.job,
    );
  }

  // ─── 3. Course recommendation ─────────────────────────────────────
  static Future<void> showCourseRecommendation({
    required String courseTitle,
    required String platform,
    required String price,
    String? url,
  }) async {
    _ensureInit();
    final isFree = price.toLowerCase().contains('free');
    final badge  = isFree ? '🆓 Free' : '💳 $price';
    await _plugin.show(
      _NID.courseRec,
      '📚 Recommended: $courseTitle',
      '$platform · $badge',
      _details(
        channelId: 'ai_courses',
        channelName: 'Course Recommendations',
        importance: Importance.defaultImportance,
        styleInfo: BigTextStyleInformation(
          'Platform: $platform\nCost: $badge\n\nThis course directly maps to your target role. Start today — even 30 minutes counts. Tap to open →',
          htmlFormatBigText: false,
          contentTitle: courseTitle,
          summaryText: 'AI Career App · Course Pick',
        ),
        actions: const [
          AndroidNotificationAction('open_course', 'Open Course', showsUserInterface: true),
          AndroidNotificationAction('remind_later', 'Remind Me Later'),
        ],
      ),
      payload: NotificationPayload.course,
    );
  }

  // ─── 4. Daily morning motivation ──────────────────────────────────
  static Future<void> showDailyMorning({int? doneSteps, int? totalSteps}) async {
    _ensureInit();
    final tip   = _morningTips[Random().nextInt(_morningTips.length)];
    final steps = doneSteps != null && totalSteps != null
        ? '\n🗺️ Roadmap: $doneSteps/$totalSteps phases done'
        : '';
    await _plugin.show(
      _NID.dailyMorning,
      '☀️ Good Morning! Your AI career awaits',
      tip,
      _details(
        channelId: 'ai_daily',
        channelName: 'Daily Reminders',
        importance: Importance.defaultImportance,
        playSound: true,
        styleInfo: BigTextStyleInformation(
          '$tip$steps\n\nTap to check today\'s goals and continue your roadmap →',
          htmlFormatBigText: false,
          contentTitle: 'Daily AI Career Tip',
          summaryText: 'AI Career App',
        ),
        actions: const [
          AndroidNotificationAction('open_roadmap', 'Open Roadmap', showsUserInterface: true),
          AndroidNotificationAction('open_goals', 'Today\'s Goals', showsUserInterface: true),
        ],
      ),
      payload: NotificationPayload.roadmap,
    );
  }

  // ─── 5. Evening learning reminder ─────────────────────────────────
  static Future<void> showEveningReminder({
    int? completedGoals,
    int? totalGoals,
  }) async {
    _ensureInit();
    final done    = completedGoals ?? 0;
    final total   = totalGoals ?? 4;
    final pending = total - done;
    final String body;

    if (pending <= 0) {
      body = "🎉 You crushed all today's goals! Take a quick look at tomorrow's roadmap.";
    } else {
      body = "You have $pending goal${pending > 1 ? 's' : ''} left today. "
          "Even 20 minutes of focused learning compounds over time. You've got this!";
    }

    await _plugin.show(
      _NID.dailyEvening,
      pending <= 0 ? '🏆 All Goals Completed!' : '🌙 $pending Goal${pending > 1 ? 's' : ''} Remaining',
      body,
      _details(
        channelId: 'ai_daily',
        channelName: 'Daily Reminders',
        importance: Importance.defaultImportance,
        styleInfo: BigTextStyleInformation(
          '$body\n\nProgress: $done / $total goals completed today.',
          htmlFormatBigText: false,
          contentTitle: 'Evening Check-in',
          summaryText: 'AI Career App',
        ),
        actions: const [
          AndroidNotificationAction('open_goals', 'Open Goals', showsUserInterface: true),
          AndroidNotificationAction('open_mentor', 'Ask Mentor', showsUserInterface: true),
        ],
      ),
      payload: NotificationPayload.copilot,
    );
  }

  // ─── 6. Streak reminder ────────────────────────────────────────────
  static Future<void> showStreakReminder(int currentStreak) async {
    _ensureInit();
    final String title;
    final String body;

    if (currentStreak == 0) {
      title = '🔴 Start Your Streak Today!';
      body  = 'Complete at least one goal today to begin your learning streak. '
              'Even the best AI engineers started with day 1.';
    } else if (currentStreak < 7) {
      title = '🔥 $currentStreak-Day Streak — Keep Going!';
      body  = 'You\'re on a $currentStreak-day learning streak. '
              'Complete today\'s goal to keep the momentum.';
    } else if (currentStreak < 30) {
      title = '🔥 Incredible! $currentStreak-Day Streak!';
      body  = '$currentStreak days of consistent learning. '
              'You\'re building the habits that top AI engineers have.';
    } else {
      title = '🏆 $currentStreak-Day Streak — Legend!';
      body  = '$currentStreak days straight. That level of consistency is what '
              'separates good engineers from great ones.';
    }

    await _plugin.show(
      _NID.streakReminder,
      title,
      body,
      _details(
        channelId: 'ai_progress',
        channelName: 'Progress & Achievements',
        importance: Importance.high,
        styleInfo: BigTextStyleInformation(
          '$body\n\nTap to complete today\'s goals →',
          htmlFormatBigText: false,
          contentTitle: '🔥 Learning Streak',
          summaryText: 'AI Career App',
        ),
        actions: const [
          AndroidNotificationAction('open_goals', 'Complete Goals', showsUserInterface: true),
        ],
      ),
      payload: NotificationPayload.copilot,
    );
  }

  // ─── 7. XP Milestone ──────────────────────────────────────────────
  static Future<void> showXpMilestone(int xp) async {
    _ensureInit();
    final level = _levelForXp(xp);
    await _plugin.show(
      _NID.xpMilestone,
      '⚡ $xp XP — You reached $level!',
      'Your consistent learning is paying off. Check your profile to see the next milestone.',
      _details(
        channelId: 'ai_progress',
        channelName: 'Progress & Achievements',
        importance: Importance.high,
        styleInfo: BigTextStyleInformation(
          'You\'ve earned $xp XP and levelled up to $level!\n\n'
          'Top AI engineers are built through consistent daily effort — '
          'and that\'s exactly what you\'re doing. Keep going!',
          htmlFormatBigText: false,
          contentTitle: '⚡ XP Milestone: $xp XP',
          summaryText: 'AI Career App · Achievement',
        ),
        actions: const [
          AndroidNotificationAction('open_profile', 'View Profile', showsUserInterface: true),
        ],
      ),
      payload: NotificationPayload.profile,
    );
  }

  // ─── 8. Roadmap phase completed ────────────────────────────────────
  static Future<void> showPhaseCompleted({
    required int phaseNumber,
    required String phaseTitle,
    required int totalPhases,
    required String salaryUnlock,
  }) async {
    _ensureInit();
    await _plugin.show(
      _NID.goalReminder,
      '✅ Phase $phaseNumber Complete: $phaseTitle',
      '$phaseNumber/$totalPhases phases done · Salary range unlocked: $salaryUnlock',
      _details(
        channelId: 'ai_progress',
        channelName: 'Progress & Achievements',
        importance: Importance.high,
        styleInfo: BigTextStyleInformation(
          'You completed Phase $phaseNumber: $phaseTitle\n\n'
          '📈 Salary range unlocked: $salaryUnlock\n'
          '🗺️ Progress: $phaseNumber/$totalPhases phases\n\n'
          'Tap to continue to the next phase →',
          htmlFormatBigText: false,
          contentTitle: '🎉 Phase $phaseNumber Completed!',
          summaryText: 'AI Career App · Roadmap',
        ),
        actions: const [
          AndroidNotificationAction('next_phase', 'Next Phase', showsUserInterface: true),
          AndroidNotificationAction('open_profile', 'View Progress', showsUserInterface: true),
        ],
      ),
      payload: NotificationPayload.roadmap,
    );
  }

  // ─── 9. Weekly digest ─────────────────────────────────────────────
  static Future<void> showWeeklyDigest({
    required int jobsApplied,
    required int goalsCompleted,
    required int xpEarned,
    required int streakDays,
  }) async {
    _ensureInit();
    final jobAlert  = _weeklyJobs[Random().nextInt(_weeklyJobs.length)];
    await _plugin.show(
      _NID.weeklyDigest,
      '📊 Your Week in AI Career',
      '$goalsCompleted goals · $xpEarned XP · $streakDays-day streak',
      _details(
        channelId: 'ai_daily',
        channelName: 'Daily Reminders',
        importance: Importance.defaultImportance,
        styleInfo: BigTextStyleInformation(
          '📊 This week\'s summary:\n'
          '✅ Goals completed: $goalsCompleted\n'
          '💼 Jobs applied: $jobsApplied\n'
          '⚡ XP earned: $xpEarned\n'
          '🔥 Streak: $streakDays days\n\n'
          '🔔 Hot job this week: ${jobAlert['role']} at ${jobAlert['company']} — ${jobAlert['salary']}\n\n'
          'Keep the momentum going next week! →',
          htmlFormatBigText: false,
          contentTitle: '📊 Weekly AI Career Digest',
          summaryText: 'AI Career App',
        ),
        actions: const [
          AndroidNotificationAction('open_jobs', 'Browse Jobs', showsUserInterface: true),
          AndroidNotificationAction('open_roadmap', 'Open Roadmap', showsUserInterface: true),
        ],
      ),
      payload: NotificationPayload.job,
    );
  }

  // ─── 10. Interview tip ────────────────────────────────────────────
  static Future<void> showInterviewTip() async {
    _ensureInit();
    final tip = _interviewTips[Random().nextInt(_interviewTips.length)];
    await _plugin.show(
      _NID.interviewTip,
      '🎯 Interview Tip: ${tip['title']}',
      tip['tip']!,
      _details(
        channelId: 'ai_tips',
        channelName: 'Career Tips',
        importance: Importance.low,
        playSound: false,
        styleInfo: BigTextStyleInformation(
          '${tip['detail']}\n\nTap to ask your AI Mentor about this →',
          htmlFormatBigText: false,
          contentTitle: '🎯 ${tip['title']}',
          summaryText: 'AI Career App · Interview Prep',
        ),
        actions: const [
          AndroidNotificationAction('ask_mentor', 'Ask AI Mentor', showsUserInterface: true),
        ],
      ),
      payload: NotificationPayload.mentor,
    );
  }

  // ─── 11. Salary insight ──────────────────────────────────────────
  static Future<void> showSalaryInsight(String targetRole) async {
    _ensureInit();
    final insight = _salaryInsights[targetRole] ??
        _salaryInsights['AI Engineer']!;
    await _plugin.show(
      _NID.salaryInsight,
      '💰 Salary Insight: $targetRole',
      '${insight['india']} in India · ${insight['global']} globally',
      _details(
        channelId: 'ai_tips',
        channelName: 'Career Tips',
        importance: Importance.low,
        playSound: false,
        styleInfo: BigTextStyleInformation(
          '💰 $targetRole Salary Ranges:\n\n'
          '🇮🇳 India: ${insight['india']}\n'
          '🌍 Global: ${insight['global']}\n\n'
          '📈 Top factor: ${insight['tip']}\n\n'
          'Tap to see your full roadmap →',
          htmlFormatBigText: false,
          contentTitle: '💰 $targetRole Market Data',
          summaryText: 'AI Career App · Salary Insight',
        ),
        actions: const [
          AndroidNotificationAction('open_roadmap', 'View Roadmap', showsUserInterface: true),
        ],
      ),
      payload: NotificationPayload.roadmap,
    );
  }

  // ─── 12. Random job alert from kJobs-style data ───────────────────
  static Future<void> showRandomJobAlert() async {
    _ensureInit();
    final job = _hotJobs[Random().nextInt(_hotJobs.length)];
    await showNewJobAlert(
      title:    job['title']!,
      company:  job['company']!,
      location: job['location']!,
      salary:   job['salary']!,
      skills:   (job['skills'] as String).split(', '),
      applyUrl: job['url'],
    );
  }

  // ─── 13. Random course recommendation ────────────────────────────
  static Future<void> showRandomCourse() async {
    _ensureInit();
    final c = _featuredCourses[Random().nextInt(_featuredCourses.length)];
    await showCourseRecommendation(
      courseTitle: c['title']!,
      platform:    c['platform']!,
      price:       c['price']!,
      url:         c['url'],
    );
  }

  // ─── Cancel single notification ───────────────────────────────────
  static Future<void> cancel(int id) => _plugin.cancel(id);

  // ─── Cancel all notifications ─────────────────────────────────────
  static Future<void> cancelAll() => _plugin.cancelAll();

  // ─── Check if permission is granted ──────────────────────────────
  static Future<bool> hasPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.areNotificationsEnabled() ?? false;
  }

  // ══════════════════════════════════════════════════════════════════
  // BACKWARD COMPATIBLE — original API preserved exactly
  // ══════════════════════════════════════════════════════════════════

  /// Original method — still works exactly as before
  static Future<void> showNotification() async {
    await showRandomJobAlert();
  }

  // ══════════════════════════════════════════════════════════════════
  // PRIVATE HELPERS
  // ══════════════════════════════════════════════════════════════════

  static void _ensureInit() {
    if (!_initialised) {
      debugPrint('⚠️ NotificationService.init() not called. Call it in main.dart.');
    }
  }

  static String _levelForXp(int xp) {
    if (xp >= 3000) return '🏆 Master';
    if (xp >= 1500) return '🚀 Expert';
    if (xp >= 800)  return '🔥 Builder';
    if (xp >= 400)  return '⚡ Practitioner';
    if (xp >= 150)  return '📚 Learner';
    return '🌱 Beginner';
  }

  // ══════════════════════════════════════════════════════════════════
  // REAL DATA BANKS
  // ══════════════════════════════════════════════════════════════════

  /// Real AI/ML companies and roles — matches kJobs in models.dart
  static const List<Map<String, String>> _hotJobs = [
    {'title':'AI Engineer',          'company':'OpenAI',           'location':'Remote / USA',         'salary':'₹18–28 LPA', 'skills':'Python, LLMs, PyTorch, API',              'url':'https://openai.com/careers'},
    {'title':'Research Scientist',   'company':'Anthropic',        'location':'San Francisco, USA',   'salary':'₹25–40 LPA', 'skills':'Python, RL, Transformers, Safety',         'url':'https://anthropic.com/careers'},
    {'title':'ML Engineer',          'company':'Google DeepMind',  'location':'London, UK',           'salary':'₹30–50 LPA', 'skills':'JAX, Python, TensorFlow, Research',        'url':'https://deepmind.google/careers'},
    {'title':'Data Scientist',       'company':'Microsoft',        'location':'Hyderabad, India',     'salary':'₹15–22 LPA', 'skills':'Python, Azure ML, SQL, Power BI',          'url':'https://careers.microsoft.com'},
    {'title':'NLP Engineer',         'company':'Amazon',           'location':'Bengaluru, India',     'salary':'₹14–20 LPA', 'skills':'NLP, BERT, Python, AWS',                   'url':'https://amazon.jobs'},
    {'title':'Computer Vision Eng',  'company':'Tesla AI',         'location':'Palo Alto, USA',       'salary':'₹22–35 LPA', 'skills':'Python, OpenCV, YOLO, PyTorch',            'url':'https://www.tesla.com/careers'},
    {'title':'Generative AI Eng',    'company':'Adobe',            'location':'Bengaluru, India',     'salary':'₹18–28 LPA', 'skills':'Diffusion Models, Python, PyTorch',        'url':'https://adobe.com/careers'},
    {'title':'LLM Engineer',         'company':'Mistral AI',       'location':'Paris, France',        'salary':'₹28–45 LPA', 'skills':'Python, PyTorch, Transformers, LoRA',      'url':'https://mistral.ai/careers'},
    {'title':'MLOps Engineer',       'company':'Swiggy',           'location':'Bengaluru, India',     'salary':'₹12–20 LPA', 'skills':'Python, Docker, Kubernetes, MLflow',       'url':'https://careers.swiggy.com'},
    {'title':'AI Product Manager',   'company':'Meesho',           'location':'Bengaluru, India',     'salary':'₹15–25 LPA', 'skills':'ML Concepts, SQL, Product Management',     'url':'https://careers.meesho.com'},
    {'title':'Applied Scientist',    'company':'Flipkart',         'location':'Bengaluru, India',     'salary':'₹18–30 LPA', 'skills':'Python, ML, NLP, Recommendation Systems',  'url':'https://www.flipkartcareers.com'},
    {'title':'Deep Learning Eng',    'company':'NVIDIA India',     'location':'Pune, India',          'salary':'₹20–35 LPA', 'skills':'CUDA, C++, Python, TensorRT',              'url':'https://nvidia.wd5.myworkdayjobs.com'},
    {'title':'Prompt Engineer',      'company':'Krutrim',          'location':'Bengaluru, India',     'salary':'₹10–18 LPA', 'skills':'Python, LLMs, Prompt Engineering',         'url':'https://krutrim.com/careers'},
    {'title':'AI Safety Researcher', 'company':'Anthropic',        'location':'Remote',               'salary':'₹30–55 LPA', 'skills':'Python, Interpretability, Safety, RLHF',   'url':'https://anthropic.com/careers'},
    {'title':'Speech AI Engineer',   'company':'Sarvam AI',        'location':'Bengaluru, India',     'salary':'₹15–25 LPA', 'skills':'ASR, TTS, Python, Indic NLP',              'url':'https://sarvam.ai/careers'},
    {'title':'RAG Engineer',         'company':'Glean',            'location':'Palo Alto, USA',       'salary':'₹25–42 LPA', 'skills':'Python, LangChain, Vector DB, LLMs',       'url':'https://glean.com/careers'},
    {'title':'AI Research Intern',   'company':'Google Brain',     'location':'Mountain View, USA',   'salary':'₹8–14 LPA',  'skills':'Python, JAX, Research Papers',             'url':'https://research.google/careers'},
    {'title':'Robotics ML Engineer', 'company':'Figure AI',        'location':'Sunnyvale, USA',       'salary':'₹35–60 LPA', 'skills':'Python, C++, ROS, PyTorch, RL',            'url':'https://figure.ai/careers'},
  ];

  /// Real courses from kCourses + extended set
  static const List<Map<String, String>> _featuredCourses = [
    {'title':'Machine Learning Specialization', 'platform':'Coursera — Andrew Ng',     'price':'Free to audit', 'url':'https://www.coursera.org/specializations/machine-learning-introduction'},
    {'title':'Practical Deep Learning for Coders', 'platform':'fast.ai',              'price':'100% Free',     'url':'https://course.fast.ai'},
    {'title':'LLM Engineering & Prompt Design', 'platform':'DeepLearning.AI',         'price':'Free',          'url':'https://www.deeplearning.ai/short-courses/'},
    {'title':'HuggingFace NLP Course',          'platform':'HuggingFace',             'price':'Free',          'url':'https://huggingface.co/learn/nlp-course'},
    {'title':'MLOps Zoomcamp',                  'platform':'DataTalks.Club',          'price':'Free',          'url':'https://github.com/DataTalksClub/mlops-zoomcamp'},
    {'title':'Deep Learning Specialization',    'platform':'DeepLearning.AI',         'price':'Free to audit', 'url':'https://www.coursera.org/specializations/deep-learning'},
    {'title':'CS229: Machine Learning',         'platform':'Stanford (YouTube)',       'price':'Free',          'url':'https://www.youtube.com/playlist?list=PLoROMvodv4rMiGQp3WXShtMGgzqpfVfbU'},
    {'title':'Spinning Up in Deep RL',          'platform':'OpenAI',                  'price':'Free',          'url':'https://spinningup.openai.com'},
    {'title':'MIT 6.S191: Deep Learning',       'platform':'MIT OpenCourseWare',      'price':'Free',          'url':'http://introtodeeplearning.com'},
    {'title':'AI Agents in LangGraph',          'platform':'DeepLearning.AI',         'price':'Free',          'url':'https://www.deeplearning.ai/short-courses/ai-agents-in-langgraph/'},
    {'title':'Building RAG Applications',       'platform':'DeepLearning.AI',         'price':'Free',          'url':'https://www.deeplearning.ai/short-courses/building-and-evaluating-advanced-rag/'},
    {'title':'Google ML Crash Course',          'platform':'Google Developers',       'price':'Free',          'url':'https://developers.google.com/machine-learning/crash-course'},
    {'title':'LLM Course by Maxime Labonne',    'platform':'GitHub',                  'price':'Free',          'url':'https://github.com/mlabonne/llm-course'},
    {'title':'CS231n: CNN for Visual Recognition','platform':'Stanford (YouTube)',    'price':'Free',          'url':'http://cs231n.stanford.edu/'},
    {'title':'Deep RL Course',                  'platform':'HuggingFace',             'price':'Free',          'url':'https://huggingface.co/learn/deep-rl-course'},
    {'title':'Quantization Fundamentals',       'platform':'DeepLearning.AI',         'price':'Free',          'url':'https://www.deeplearning.ai/short-courses/quantization-fundamentals-with-hugging-face/'},
  ];

  /// Morning motivational tips (career-specific)
  static const List<String> _morningTips = [
    'Spend 30 min on your roadmap today. Consistency beats intensity every time.',
    '3 LeetCode mediums + 1 ML concept = a stronger interview day.',
    'The best AI engineers read 2–3 papers per week. Start with one abstract today.',
    'Open your AI Copilot and tick off one daily goal before lunch.',
    'Review your skill gaps. One hour on a gap skill beats 5 hours on what you already know.',
    'Apply to one job today, even if you feel "not ready". Action creates confidence.',
    'Write one line about what you learned yesterday. Reflection compounds learning.',
    'Your GitHub profile is your live resume. Push something today.',
    'Browse the Arxiv daily digest. Even understanding the title of a paper is progress.',
    'Message one person in the AI community on LinkedIn today. Referrals get 30% more callbacks.',
    'Top AI companies hire for curiosity first. What are you genuinely curious about today?',
    'AI Engineer salaries in India grew 40% in 2024. Your skills are more valuable than ever.',
  ];

  /// Interview tips with full detail
  static const List<Map<String, String>> _interviewTips = [
    {
      'title': 'Explain Gradient Descent',
      'tip':   'Always start with intuition before math.',
      'detail': 'Say: "Gradient descent is like finding the lowest point in a valley by always stepping downhill." Then derive the update rule. Interviewers at Google and Anthropic look for intuition first, equations second.',
    },
    {
      'title': 'Bias-Variance Tradeoff',
      'tip':   'Draw the curves — don\'t just explain.',
      'detail': 'Sketch U-shaped test error and decreasing training error on paper. Then say: "The sweet spot is model complexity that minimises both." This visual approach is remembered far longer than verbal explanations.',
    },
    {
      'title': 'System Design for ML',
      'tip':   'Start with data, not the model.',
      'detail': 'When asked "design a recommendation system", say: "Before models, I need to understand data freshness requirements, feedback loop latency, and serving constraints." This signals senior-level thinking.',
    },
    {
      'title': 'Describe a Failed Project',
      'tip':   'Use STAR + what you learned.',
      'detail': 'Structure: Situation → Task → Action → Result (and what you\'d do differently). Hiring managers at top AI labs value intellectual honesty and learning agility more than success stories.',
    },
    {
      'title': 'Transformer Architecture',
      'tip':   'Explain attention in one sentence first.',
      'detail': '"Attention lets the model look at all input tokens simultaneously and weight them by relevance." Then go deeper: Q/K/V matrices, multi-head, positional encodings. This is asked at 80% of ML engineer screens.',
    },
    {
      'title': 'Why Do LLMs Hallucinate?',
      'tip':   'Root cause: next-token prediction doesn\'t know truth.',
      'detail': 'LLMs are trained to predict the most likely next token, not to verify factual accuracy. They don\'t have a truth module. Mention RAG and RLHF as mitigation strategies — this shows applied knowledge.',
    },
    {
      'title': 'Handle Imbalanced Data',
      'tip':   'Name 4 techniques — then pick based on context.',
      'detail': '1. SMOTE oversampling 2. Class weights 3. Focal loss 4. Threshold tuning. The key insight: "The right technique depends on whether false positives or false negatives are more costly for the business." Context wins.',
    },
    {
      'title': 'Explain LoRA Fine-tuning',
      'tip':   'Low-rank = fewer parameters = same quality.',
      'detail': '"LoRA freezes the base model and trains small low-rank matrices A and B. Their product approximates the full weight update, using 0.1% of parameters with ~95% of the performance." This is heavily asked in 2025.',
    },
  ];

  /// Weekly hot jobs digest
  static const List<Map<String, String>> _weeklyJobs = [
    {'role':'AI Engineer',        'company':'OpenAI',          'salary':'₹18–28 LPA'},
    {'role':'ML Engineer',        'company':'Google DeepMind', 'salary':'₹30–50 LPA'},
    {'role':'NLP Engineer',       'company':'Amazon',          'salary':'₹14–20 LPA'},
    {'role':'LLM Engineer',       'company':'Mistral AI',      'salary':'₹28–45 LPA'},
    {'role':'MLOps Engineer',     'company':'Swiggy',          'salary':'₹12–20 LPA'},
    {'role':'Deep Learning Eng',  'company':'NVIDIA India',    'salary':'₹20–35 LPA'},
    {'role':'GenAI Engineer',     'company':'Adobe',           'salary':'₹18–28 LPA'},
    {'role':'Speech AI Engineer', 'company':'Sarvam AI',       'salary':'₹15–25 LPA'},
  ];

  /// Salary insights per role
  static const Map<String, Map<String, String>> _salaryInsights = {
    'AI Engineer': {
      'india':  '₹12–35 LPA (fresher to senior)',
      'global': '\$110–220K USD',
      'tip':    'LLM + deployed product experience adds 20–30% to offers',
    },
    'ML Engineer': {
      'india':  '₹10–30 LPA',
      'global': '\$100–180K USD',
      'tip':    'Kaggle Master rank or FAANG experience = instant shortlist',
    },
    'Data Scientist': {
      'india':  '₹8–25 LPA',
      'global': '\$90–160K USD',
      'tip':    'SQL + domain knowledge (fintech/health) = 15% salary premium',
    },
    'NLP Engineer': {
      'india':  '₹12–28 LPA',
      'global': '\$110–165K USD',
      'tip':    'Indic language expertise is scarce and commands 20% premium in India',
    },
    'CV Engineer': {
      'india':  '₹12–30 LPA',
      'global': '\$110–170K USD',
      'tip':    'C++ + real-time inference skills double your interview conversion rate',
    },
    'Prompt Engineer': {
      'india':  '₹8–18 LPA',
      'global': '\$60–130K USD',
      'tip':    'Domain expertise (law/medicine/code) adds 3–5× to pay rate',
    },
    'AI Researcher': {
      'india':  '₹25–70 LPA',
      'global': '\$150–300K USD',
      'tip':    'One NeurIPS/ICML paper is worth more than 5 certifications',
    },
    'AI Product Manager': {
      'india':  '₹15–35 LPA',
      'global': '\$120–200K USD',
      'tip':    'Shipped AI products beat MBA at top AI companies',
    },
  };
}