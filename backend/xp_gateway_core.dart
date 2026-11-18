// ══════════════════════════════════════════════════════════════════════
// backend/xp_gateway_core.dart
// PHASE 3 / STAGE 2 — TRUSTED XP GATEWAY
//
// Pure Dart business logic. Identity and App Check must be verified by the
// API layer before calling this gateway. The uid argument must come only
// from the verified Firebase token, never from request JSON.
//
// XpStore must be implemented with privileged server-side Firestore access.
// All transaction reads must occur before writes. create() must fail if the
// document already exists. increment()/arrayUnion() must be atomic.
// ══════════════════════════════════════════════════════════════════════

import 'dart:collection';

import '../lib/models/copilot_models.dart' show CareerGoal, CareerGoalExt;
import '../lib/models/quest_models.dart' show LevelSystem;
import '../lib/services/goal_content_database.dart';
import '../lib/services/local_course_generator.dart';
import '../lib/services/safe_doc_id.dart';

typedef Json = Map<String, dynamic>;

abstract class XpTx {
  Future<Json?> get(String path);
  void create(String path, Json data);
  void merge(String path, Json data);
  void increment(String path, Map<String, num> deltas);
  void arrayUnion(String path, String field, List<String> values);
}

abstract class XpStore {
  Future<T> runTransaction<T>(Future<T> Function(XpTx tx) body);
}

class GatewayRejection implements Exception {
  const GatewayRejection(this.status, this.code, this.message);
  final int status;
  final String code;
  final String message;

  @override
  String toString() => 'GatewayRejection($status, $code)';
}

GatewayRejection _bad(String code, String message) =>
    GatewayRejection(400, code, message);
GatewayRejection _unprocessable(String code, String message) =>
    GatewayRejection(422, code, message);

String? _cleanString(dynamic value, {int max = 128}) {
  if (value is! String) return null;
  final result = value.trim();
  if (result.isEmpty ||
      result.length > max ||
      RegExp(r'[\x00-\x1F\x7F]').hasMatch(result)) {
    return null;
  }
  return result;
}

int? _wholeInt(dynamic value) {
  if (value is int) return value;
  if (value is num && value.isFinite && value == value.truncate()) {
    return value.toInt();
  }
  return null;
}

int _readInt(dynamic value) {
  if (value is int) return value < 0 ? 0 : value;
  if (value is num && value.isFinite && value == value.truncate()) {
    final result = value.toInt();
    return result < 0 ? 0 : result;
  }
  return 0;
}

class CourseEventRequest {
  const CourseEventRequest({
    required this.careerId,
    required this.courseId,
    required this.kind,
    this.index,
    this.selectedIndex,
  });

  final String careerId;
  final String courseId;
  final String kind;
  final int? index;
  final int? selectedIndex;

  factory CourseEventRequest.fromJson(Json json) {
    final careerId = _cleanString(json['careerId'], max: 120);
    final courseId = _cleanString(json['courseId'], max: 160);
    final kind = _cleanString(json['kind'], max: 20);
    if (careerId == null || courseId == null || kind == null) {
      throw _bad('bad_request', 'careerId, courseId and kind are required.');
    }
    if (careerId.contains('/') || courseId.contains('/')) {
      throw _bad('bad_id', 'careerId and courseId must be valid identifiers.');
    }
    if (!const {'quiz', 'challenge', 'project'}.contains(kind)) {
      throw _bad('bad_kind', 'kind must be quiz, challenge or project.');
    }
    return CourseEventRequest(
      careerId: careerId,
      courseId: courseId,
      kind: kind,
      index: _wholeInt(json['index']),
      selectedIndex: _wholeInt(json['selectedIndex']),
    );
  }
}

class GoalRequest {
  const GoalRequest({required this.careerId, required this.goalId});
  final String careerId;
  final String goalId;

  factory GoalRequest.fromJson(Json json) {
    final careerId = _cleanString(json['careerId'], max: 120);
    final goalId = _cleanString(json['goalId'], max: 200);
    if (careerId == null || goalId == null) {
      throw _bad('bad_request', 'careerId and goalId are required.');
    }
    if (careerId.contains('/') || goalId.contains('/')) {
      throw _bad('bad_id', 'careerId and goalId must be valid identifiers.');
    }
    return GoalRequest(careerId: careerId, goalId: goalId);
  }
}

class GatewayResult {
  const GatewayResult({
    required this.awarded,
    required this.xp,
    required this.eventId,
    this.totalXp,
    this.isCompleted,
    this.reason,
  });

  final bool awarded;
  final int xp;
  final String eventId;
  final int? totalXp;
  final bool? isCompleted;
  final String? reason;

  Json toJson() => <String, dynamic>{
        'awarded': awarded,
        'xp': xp,
        'eventId': eventId,
        if (totalXp != null) 'totalXp': totalXp,
        if (isCompleted != null) 'isCompleted': isCompleted,
        if (reason != null) 'reason': reason,
      };
}

enum ProjectXpPolicy { enabled, disabled }

class XpGatewayConfig {
  const XpGatewayConfig({
    this.maxGoalsPerDay = 4,
    this.goalDateToleranceDays = 1,
    this.courseCacheEntries = 256,
    this.projectPolicy = ProjectXpPolicy.enabled,
  });

  final int maxGoalsPerDay;
  final int goalDateToleranceDays;
  final int courseCacheEntries;
  final ProjectXpPolicy projectPolicy;

  // Keep this constructor const for compatibility with existing call sites.
  void validate() {
    if (maxGoalsPerDay < 1 ||
        maxGoalsPerDay > 20 ||
        goalDateToleranceDays < 0 ||
        goalDateToleranceDays > 7 ||
        courseCacheEntries < 0 ||
        courseCacheEntries > 4096) {
      throw ArgumentError('XpGatewayConfig values are out of range.');
    }
  }
}

class XpGateway {
  XpGateway({
    required this.store,
    DateTime Function()? clock,
    this.config = const XpGatewayConfig(),
  }) : _clock = clock ?? DateTime.now {
    config.validate();
  }

  final XpStore store;
  final XpGatewayConfig config;
  final DateTime Function() _clock;
  final LinkedHashMap<String, _CourseFacts> _courseCache =
      LinkedHashMap<String, _CourseFacts>();

  Future<GatewayResult> recordCourseEvent(
      String uid, CourseEventRequest request) async {
    _checkUid(uid);
    final plan = _planCourseEvent(request);
    final safeCareer = safeDocId(request.careerId);
    final safeEvent = safeDocId(plan.eventId);
    if (safeCareer.isEmpty || safeEvent.isEmpty) {
      throw _unprocessable('bad_id', 'Identifier is not valid.');
    }

    final nowUtc = _clock().toUtc();
    final userPath = 'users/$uid';
    final progressPath = '$userPath/copilot_learning_progress/$safeCareer';
    final eventPath = '$progressPath/events/$safeEvent';
    final weeklyPath = _weeklyPath(uid, nowUtc);

    return store.runTransaction<GatewayResult>((tx) async {
      // READ PHASE — each outcome event is idempotent. A recorded miss
      // must not block a later correct answer, which is a supported retry.
      final existing = await tx.get(eventPath);
      if (existing != null) {
        return GatewayResult(
          awarded: false,
          xp: 0,
          eventId: safeEvent,
          reason: 'already_recorded',
        );
      }
      // A project claim is valid only after every quiz and challenge
      // question for this exact course has a server-created outcome event.
      if (request.kind == 'project') {
        final facts = _factsFor(request.careerId, request.courseId);
        for (var i = 0; i < facts.quizCorrect.length; i++) {
          final hit = safeDocId('quiz:${request.courseId}:$i');
          final miss = safeDocId('quiz_miss:${request.courseId}:$i');
          final hitDoc = await tx.get('$progressPath/events/$hit');
          final missDoc = await tx.get('$progressPath/events/$miss');
          if (hitDoc == null && missDoc == null) {
            throw const GatewayRejection(
              409,
              'prerequisites_missing',
              'Complete every quiz question before claiming project XP.',
            );
          }
        }
        for (var i = 0; i < facts.challengeCorrect.length; i++) {
          final hit = safeDocId('challenge:${request.courseId}:$i');
          final miss = safeDocId('challenge_miss:${request.courseId}:$i');
          final hitDoc = await tx.get('$progressPath/events/$hit');
          final missDoc = await tx.get('$progressPath/events/$miss');
          if (hitDoc == null && missDoc == null) {
            throw const GatewayRejection(
              409,
              'prerequisites_missing',
              'Complete every challenge question before claiming project XP.',
            );
          }
        }
      }

      final userDoc = await tx.get(userPath);
      final weeklyDoc = plan.xp > 0 ? await tx.get(weeklyPath) : null;

      final newTotal = _readInt(userDoc?['totalXp']) + plan.xp;
      final nowIso = nowUtc.toIso8601String();

      // WRITE PHASE — the outcome event and XP mutations are atomic.
      tx.create(eventPath, <String, dynamic>{
        'eventId': safeEvent,
        'eventType': plan.eventType,
        'careerId': safeCareer,
        'topic': plan.topic,
        'correct': plan.correct,
        'xp': plan.xp,
        'metadata': <String, dynamic>{},
        'recordedAt': nowIso,
      });
      tx.merge(progressPath, <String, dynamic>{
        'careerId': safeCareer,
        'updatedAt': nowIso,
      });
      tx.arrayUnion(progressPath, 'completedCourseEventIds', [safeEvent]);
      tx.arrayUnion(progressPath, 'courseEvidenceIds', [safeEvent]);

      if (plan.xp > 0) {
        tx.increment(userPath, {'totalXp': plan.xp});
        tx.increment(progressPath, {'careerTotalXp': plan.xp});
        _writeLeaderboard(
          tx,
          uid: uid,
          userDoc: userDoc,
          newTotal: newTotal,
          xpDelta: plan.xp,
          weeklyDoc: weeklyDoc,
          nowUtc: nowUtc,
        );
      }

      return GatewayResult(
        awarded: true,
        xp: plan.xp,
        eventId: safeEvent,
        totalXp: newTotal,
      );
    });
  }

  /// Marks a goal complete once. This endpoint intentionally does not toggle
  /// a completed goal back to incomplete; uncompletion must be a separate
  /// non-awarding operation.
  Future<GatewayResult> completeGoal(String uid, GoalRequest request) async {
    _checkUid(uid);
    final facts = _parseGoal(request.careerId, request.goalId);

    final safeCareer = safeDocId(request.careerId);
    final safeGoal = safeDocId(request.goalId);
    if (safeCareer.isEmpty || safeGoal.isEmpty) {
      throw _unprocessable('bad_id', 'Identifier is not valid.');
    }

    final nowUtc = _clock().toUtc();
    final userPath = 'users/$uid';
    final goalPath = '$userPath/copilot_daily_goals/${request.goalId}';
    final canonicalPath =
        '$userPath/copilot_goal_events/${safeCareer}__goal_$safeGoal';

    // A second idempotency key prevents claiming the same template twice on
    // the same day by changing only the generated goal index.
    final templateDayKey =
        safeDocId('${safeCareer}__${facts.templateId}__${facts.dateKey}');
    final templateDayPath =
        '$userPath/copilot_goal_template_events/$templateDayKey';

    final progressPath = '$userPath/copilot_learning_progress/$safeCareer';
    final careerEventPath = '$progressPath/events/goal:$safeGoal';
    final weeklyPath = _weeklyPath(uid, nowUtc);
    final canonicalEventId = 'goal:$safeCareer:$safeGoal';

    return store.runTransaction<GatewayResult>((tx) async {
      // READ PHASE
      final goalDoc = await tx.get(goalPath);
      if (goalDoc == null) {
        throw const GatewayRejection(
            404, 'goal_not_found', 'This goal does not exist.');
      }
      final storedUid = goalDoc['uid'];
      final storedDate = goalDoc['date'];
      if ((storedUid is String && storedUid != uid) ||
          (storedDate is String && storedDate != facts.dateKey)) {
        throw _unprocessable(
          'goal_mismatch',
          'This goal does not match the verified account or date.',
        );
      }

      final canonical = await tx.get(canonicalPath);
      final templateDay = await tx.get(templateDayPath);
      final careerEvent = await tx.get(careerEventPath);
      final userDoc = await tx.get(userPath);
      final weeklyDoc = await tx.get(weeklyPath);

      final current = goalDoc['isCompleted'] == true;
      final alreadyAwarded =
          canonical != null || templateDay != null || careerEvent != null;
      final award = !current && !alreadyAwarded;

      if (award && !_dateInWindow(facts.dateKey, nowUtc)) {
        throw _unprocessable(
          'goal_date_out_of_range',
          'This goal is not available to complete today.',
        );
      }

      final nowIso = nowUtc.toIso8601String();
      final xp = award ? facts.xp : 0;
      final newTotal = _readInt(userDoc?['totalXp']) + xp;

      // WRITE PHASE
      if (!current) {
        tx.merge(goalPath, <String, dynamic>{
          'isCompleted': true,
          'completedAt': nowIso,
        });
      }

      if (award) {
        tx.increment(userPath, {'totalXp': xp, 'totalGoalsCompleted': 1});
        tx.increment(progressPath, {'careerTotalXp': xp});
        tx.merge(progressPath, <String, dynamic>{
          'careerId': safeCareer,
          'updatedAt': nowIso,
        });

        final record = <String, dynamic>{
          'eventId': canonicalEventId,
          'eventType': 'goal',
          'careerId': safeCareer,
          'topic': facts.skill,
          'correct': true,
          'xp': xp,
          'metadata': <String, dynamic>{
            'goalId': request.goalId,
            'templateId': facts.templateId,
            'date': facts.dateKey,
          },
          'recordedAt': nowIso,
        };
        tx.create(canonicalPath, <String, dynamic>{
          ...record,
          'goalId': request.goalId,
        });
        tx.create(templateDayPath, <String, dynamic>{
          'careerId': safeCareer,
          'templateId': facts.templateId,
          'date': facts.dateKey,
          'goalId': request.goalId,
          'xp': xp,
          'recordedAt': nowIso,
        });
        if (careerEvent == null) {
          tx.create(careerEventPath, record);
        }

        _writeLeaderboard(
          tx,
          uid: uid,
          userDoc: userDoc,
          newTotal: newTotal,
          xpDelta: xp,
          weeklyDoc: weeklyDoc,
          nowUtc: nowUtc,
        );
      }

      return GatewayResult(
        awarded: award,
        xp: xp,
        eventId: canonicalEventId,
        totalXp: award ? newTotal : null,
        isCompleted: true,
        reason:
            award ? null : (current ? 'already_completed' : 'already_awarded'),
      );
    });
  }

  void _writeLeaderboard(
    XpTx tx, {
    required String uid,
    required Json? userDoc,
    required int newTotal,
    required int xpDelta,
    required Json? weeklyDoc,
    required DateTime nowUtc,
  }) {
    final name = _displayName(userDoc);
    final level = LevelSystem.levelFor(newTotal);
    final previousWeekly = _readInt(weeklyDoc?['xp'] ?? weeklyDoc?['weeklyXp']);
    final newWeekly = previousWeekly + xpDelta;
    final nowMs = nowUtc.millisecondsSinceEpoch;

    tx.merge('leaderboard/global/entries/$uid', <String, dynamic>{
      'displayName': name,
      'totalXp': newTotal,
      'level': level,
      'weeklyXp': newWeekly,
      'updatedAt': nowMs,
    });
    tx.merge(_weeklyPath(uid, nowUtc), <String, dynamic>{
      'displayName': name,
      'totalXp': newTotal,
      'level': level,
      'weeklyXp': newWeekly,
      'xp': newWeekly,
      'updatedAt': nowMs,
    });
  }

  /// UTC Monday week ID, matching LeaderboardService._currentWeekIdUtc.
  String _weeklyPath(String uid, DateTime nowUtc) {
    final monday = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day)
        .subtract(Duration(days: nowUtc.weekday - 1));
    return 'leaderboard/weekly_${monday.year}_${monday.month}_${monday.day}'
        '/entries/$uid';
  }

  String _displayName(Json? userDoc) {
    final raw = userDoc?['name'];
    if (raw is! String) return 'Learner';
    var value = raw
        .replaceAll(RegExp(r'[\x00-\x1F\x7F]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (value.length > 60) value = value.substring(0, 60).trim();
    return value.isEmpty ? 'Learner' : value;
  }

  _CoursePlan _planCourseEvent(CourseEventRequest request) {
    final facts = _factsFor(request.careerId, request.courseId);
    switch (request.kind) {
      case 'quiz':
        return _planChoice(
          request: request,
          facts: facts,
          correctIndexes: facts.quizCorrect,
          xpValues: facts.quizXp,
          hitType: 'quiz',
          missType: 'quiz_miss',
        );
      case 'challenge':
        return _planChoice(
          request: request,
          facts: facts,
          correctIndexes: facts.challengeCorrect,
          xpValues: facts.challengeXp,
          hitType: 'challenge',
          missType: 'challenge_miss',
        );
      case 'project':
        if (config.projectPolicy == ProjectXpPolicy.disabled) {
          throw const GatewayRejection(
            403,
            'project_xp_disabled',
            'Project XP is currently disabled.',
          );
        }
        return _CoursePlan(
          eventId: 'project:${request.courseId}',
          eventType: 'project',
          xp: facts.projectXp,
          correct: true,
          topic: facts.topicTitle,
        );
    }
    throw _bad('bad_kind', 'Unsupported kind.');
  }

  _CoursePlan _planChoice({
    required CourseEventRequest request,
    required _CourseFacts facts,
    required List<int> correctIndexes,
    required List<int> xpValues,
    required String hitType,
    required String missType,
  }) {
    final index = request.index;
    if (index == null || index < 0 || index >= correctIndexes.length) {
      throw _unprocessable('bad_index', 'Question index is out of range.');
    }
    if (xpValues.length != correctIndexes.length) {
      throw StateError('Trusted course content has mismatched XP vectors.');
    }
    final selected = request.selectedIndex;
    if (selected == null || selected < 0 || selected > 3) {
      throw _bad('bad_selected_index', 'selectedIndex must be 0-3.');
    }
    final correct = selected == correctIndexes[index];
    return _CoursePlan(
      eventId: correct
          ? '$hitType:${request.courseId}:$index'
          : '$missType:${request.courseId}:$index',
      eventType: correct ? hitType : missType,
      xp: correct ? xpValues[index] : 0,
      correct: correct,
      topic: facts.topicTitle,
    );
  }

  _CourseFacts _factsFor(String careerId, String courseId) {
    final cached = _courseCache.remove(courseId);
    if (cached != null) {
      _courseCache[courseId] = cached;
      if (cached.careerId != careerId) {
        throw _unprocessable('unknown_course', 'This course is not available.');
      }
      return cached;
    }

    final prefix = '${careerId}_level';
    if (!courseId.startsWith(prefix)) {
      throw _unprocessable('unknown_course', 'This course is not available.');
    }
    final match = RegExp(r'^(\d{1,3})(?:_lesson(\d{1,3}))?$')
        .firstMatch(courseId.substring(prefix.length));
    if (match == null) {
      throw _unprocessable('unknown_course', 'This course is not available.');
    }

    final level = int.parse(match.group(1)!);
    final lessonIndex =
        match.group(2) == null ? null : int.parse(match.group(2)!);

    final Map<String, dynamic> course;
    try {
      course = LocalCourseGenerator.generateCourse(
        careerId: careerId,
        level: level,
        lessonIndex: lessonIndex,
      );
    } on LocalGenerationException {
      throw _unprocessable('unknown_course', 'This course is not available.');
    }
    if (course['id'] != courseId) {
      throw _unprocessable('unknown_course', 'This course is not available.');
    }

    List<int> readInts(dynamic rawList, String key) {
      if (rawList is! List) {
        throw StateError('Trusted course content is missing $key list.');
      }
      return rawList.map((item) {
        if (item is! Map ||
            item[key] is! num ||
            !(item[key] as num).isFinite ||
            (item[key] as num) != (item[key] as num).truncate()) {
          throw StateError('Trusted course content has invalid $key.');
        }
        return (item[key] as num).toInt();
      }).toList(growable: false);
    }

    final finalProject = course['finalProject'];
    if (finalProject is! Map ||
        finalProject['xpReward'] is! num ||
        !(finalProject['xpReward'] as num).isFinite ||
        (finalProject['xpReward'] as num) !=
            (finalProject['xpReward'] as num).truncate()) {
      throw StateError('Trusted course content has invalid project XP.');
    }

    final facts = _CourseFacts(
      careerId: careerId,
      topicTitle:
          course['topicTitle'] is String ? course['topicTitle'] as String : '',
      quizCorrect: readInts(course['quiz'], 'correctIndex'),
      quizXp: readInts(course['quiz'], 'xpReward'),
      challengeCorrect: readInts(course['challenges'], 'correctIndex'),
      challengeXp: readInts(course['challenges'], 'xpReward'),
      projectXp: (finalProject['xpReward'] as num).toInt(),
    );

    if (facts.quizCorrect.any((index) => index < 0 || index > 3) ||
        facts.challengeCorrect.any((index) => index < 0 || index > 3) ||
        facts.quizXp.any((xp) => xp < 0) ||
        facts.challengeXp.any((xp) => xp < 0) ||
        facts.projectXp < 0) {
      throw StateError('Trusted course content contains out-of-range values.');
    }

    if (config.courseCacheEntries > 0) {
      _courseCache[courseId] = facts;
      while (_courseCache.length > config.courseCacheEntries) {
        _courseCache.remove(_courseCache.keys.first);
      }
    }
    return facts;
  }

  CareerGoal? _careerGoal(String careerId) {
    for (final career in CareerGoal.values) {
      if (career.careerId == careerId) return career;
    }
    return null;
  }

  /// Expected ID: {careerId}_{templateId}_{yyyy-MM-dd}_{index}.
  _GoalFacts _parseGoal(String careerId, String goalId) {
    if (careerId.contains('/') || goalId.contains('/')) {
      throw _unprocessable('invalid_goal_id', 'Goal id is not valid.');
    }
    final career = _careerGoal(careerId);
    if (career == null) {
      throw _unprocessable('unsupported_career', 'Unsupported career.');
    }

    final prefix = '${careerId}_';
    if (!goalId.startsWith(prefix)) {
      throw _unprocessable('invalid_goal_id', 'Goal id is not valid.');
    }
    final match = RegExp(r'^(.+)_(\d{4}-\d{2}-\d{2})_(\d{1,2})$')
        .firstMatch(goalId.substring(prefix.length));
    if (match == null) {
      throw _unprocessable('invalid_goal_id', 'Goal id is not valid.');
    }

    final templateId = match.group(1)!;
    final dateKey = match.group(2)!;
    final index = int.parse(match.group(3)!);
    if (index >= config.maxGoalsPerDay) {
      throw _unprocessable('goal_index_out_of_range', 'Goal id is not valid.');
    }

    GoalTemplate? template;
    for (final item in GoalContentDatabase.dailyForRole(career.label)) {
      if (item.id == templateId) {
        template = item;
        break;
      }
    }
    if (template == null) {
      throw _unprocessable('unknown_goal_template', 'Goal is not recognised.');
    }

    // Validate canonical calendar date here, before using it in an idempotency
    // key or allowing any transaction write.
    if (!_isCanonicalDate(dateKey)) {
      throw _unprocessable('invalid_goal_date', 'Goal date is not valid.');
    }

    return _GoalFacts(
      templateId: template.id,
      dateKey: dateKey,
      xp: template.xp,
      skill: template.skill,
    );
  }

  bool _isCanonicalDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return false;
    final canonical = '${parsed.year.toString().padLeft(4, '0')}-'
        '${parsed.month.toString().padLeft(2, '0')}-'
        '${parsed.day.toString().padLeft(2, '0')}';
    return canonical == value;
  }

  bool _dateInWindow(String dateKey, DateTime nowUtc) {
    if (!_isCanonicalDate(dateKey)) return false;
    final parsed = DateTime.parse(dateKey);
    final day = DateTime.utc(parsed.year, parsed.month, parsed.day);
    final today = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);
    return day.difference(today).inDays.abs() <= config.goalDateToleranceDays;
  }

  void _checkUid(String uid) {
    if (uid.trim().isEmpty ||
        uid != uid.trim() ||
        uid.length > 128 ||
        uid.contains('/') ||
        RegExp(r'[\s\x00-\x1F\x7F]').hasMatch(uid)) {
      throw const GatewayRejection(
        401,
        'bad_identity',
        'A verified identity is required.',
      );
    }
  }
}

class _CourseFacts {
  const _CourseFacts({
    required this.careerId,
    required this.topicTitle,
    required this.quizCorrect,
    required this.quizXp,
    required this.challengeCorrect,
    required this.challengeXp,
    required this.projectXp,
  });

  final String careerId;
  final String topicTitle;
  final List<int> quizCorrect;
  final List<int> quizXp;
  final List<int> challengeCorrect;
  final List<int> challengeXp;
  final int projectXp;
}

class _CoursePlan {
  const _CoursePlan({
    required this.eventId,
    required this.eventType,
    required this.xp,
    required this.correct,
    required this.topic,
  });

  final String eventId;
  final String eventType;
  final int xp;
  final bool correct;
  final String topic;
}

class _GoalFacts {
  const _GoalFacts({
    required this.templateId,
    required this.dateKey,
    required this.xp,
    required this.skill,
  });

  final String templateId;
  final String dateKey;
  final int xp;
  final String? skill;
}
