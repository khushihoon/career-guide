// ══════════════════════════════════════════════════════════════════════
// lib/services/local_course_generator.dart
//
// FREE, OFFLINE course generator. No internet, no API key, no paid
// service. Pure Dart (no Flutter imports) so the optional backend can
// reuse it.
//
// HONEST DESCRIPTION
//   This is NOT live AI. It builds lessons from the curated topics in
//     * dynamic_career_paths.dart (Cloud & DevOps careers carry topics)
//     * local_curriculum.dart      (the other 10 careers)
//   and uses templates for the teaching text. Quiz questions are made
//   from the real topic descriptions, with wrong options taken from
//   sibling topics, so every answer is checkable.
//
// Output uses exactly the JSON shape the app's parser already reads:
//   { id, topicTitle, careerId, categoryId, difficulty, estimatedMinutes,
//     totalXp, intro, emoji, concepts[], quiz[], challenges[],
//     finalProject{} }  (+ an ignored "source": "local-template" marker)
//
// If a career/level has no curriculum, generation THROWS a
// LocalGenerationException. It never returns empty or fake content.
// ══════════════════════════════════════════════════════════════════════

import '../data/courses/course_generator_config.dart';
import '../data/courses/dynamic_career_paths.dart';
import '../data/courses/local_curriculum.dart';

class LocalGenerationException implements Exception {
  const LocalGenerationException(this.message);
  final String message;
  @override
  String toString() => 'LocalGenerationException: $message';
}

class _Ctx {
  _Ctx({
    required this.path,
    required this.lvl,
    required this.topics,
    required this.otherNames,
    required this.otherLevelTitles,
    required this.lessonIndex,
  });
  final GeneratedCareerPath path;
  final GeneratedLevel lvl;
  final List<CTopic> topics;
  final List<String> otherNames; // topic names from the OTHER levels
  final List<String> otherLevelTitles;
  final int? lessonIndex;

  String get careerId => path.careerId;
  String get career => path.careerTitle;
  int get level => lvl.level;
  String get levelTitle => lvl.levelTitle;
  bool get described => topics.every((t) => t.desc.isNotEmpty);
}

class LocalCourseGenerator {
  LocalCourseGenerator._();

  /// Marker stored with generated content so it is never mistaken for AI.
  static const String source = 'local-template';

  static const List<String> _angles = <String>[
    'core idea',
    'worked example',
    'hands-on practice',
    'common mistakes',
    'review and recap',
  ];

  // ── Public API ─────────────────────────────────────────────────────

  /// True when this career + level can be generated locally.
  static bool supports(String careerId, int level) {
    try {
      _resolve(careerId, level, null);
      return true;
    } on LocalGenerationException {
      return false;
    }
  }

  /// Lesson titles for one level. Returns {"lessons": [{index,title}]}.
  static Map<String, dynamic> generateLessonList({
    required String careerId,
    required int level,
    int lessonCount = CourseGeneratorConfig.lessonsPerDynamicLevel,
  }) {
    if (lessonCount < CourseGeneratorConfig.minLessonCount ||
        lessonCount > CourseGeneratorConfig.maxLessonCount) {
      throw LocalGenerationException(
          'lessonCount must be between ${CourseGeneratorConfig.minLessonCount} '
          'and ${CourseGeneratorConfig.maxLessonCount}.');
    }
    final c = _resolve(careerId, level, null);
    return <String, dynamic>{
      'lessons': <Map<String, dynamic>>[
        for (var i = 1; i <= lessonCount; i++)
          <String, dynamic>{'index': i, 'title': _lessonTitle(c.topics, i)},
      ],
      'source': source,
    };
  }

  /// One full course. Pass [lessonIndex] (1-based) for a single lesson of a
  /// multi-lesson level, or leave it null for a whole-level course.
  static Map<String, dynamic> generateCourse({
    required String careerId,
    required int level,
    int? lessonIndex,
  }) {
    if (lessonIndex != null &&
        (lessonIndex < 1 ||
            lessonIndex > CourseGeneratorConfig.maxLessonCount)) {
      throw const LocalGenerationException('lessonIndex is out of range.');
    }
    final c = _resolve(careerId, level, lessonIndex);
    final n = c.topics.length;
    final multi = lessonIndex != null;
    final focusIdx = multi ? (lessonIndex! - 1) % n : 0;
    final round = multi ? (lessonIndex! - 1) ~/ n : 0;
    final angle = multi ? _angles[round % _angles.length] : 'core idea';
    final focus = c.topics[focusIdx];
    final title = multi ? _lessonTitle(c.topics, lessonIndex!) : c.levelTitle;

    final concepts = _concepts(c, focusIdx, angle, multi);
    final quiz = _questions(
      c: c,
      count: CourseGeneratorConfig.quizQuestionsPerLesson,
      kinds: c.described ? <int>[1, 2, 3, 4, 5] : <int>[3, 4, 5],
      focusIdx: focusIdx,
      tag: 'quiz',
    );
    for (final q in quiz) {
      q['xpReward'] = CourseGeneratorConfig.defaultQuizXp;
    }
    final challenges = _questions(
      c: c,
      count: CourseGeneratorConfig.challengesPerLesson,
      kinds: c.described ? <int>[6] : <int>[7],
      focusIdx: (focusIdx + 1) % n,
      tag: 'chal',
    );
    for (final q in challenges) {
      // Keep the original MCQ field for compatibility with existing readers,
      // and also expose the challenge text under the field required by the
      // course JSON validator and challenge consumers.
      q['prompt'] = q['question'];
      q['xpReward'] = CourseGeneratorConfig.defaultChallengeXp;
    }
    final project = _project(c, focus, multi);

    final totalXp = quiz.length * CourseGeneratorConfig.defaultQuizXp +
        challenges.length * CourseGeneratorConfig.defaultChallengeXp +
        (project['xpReward'] as int);

    return <String, dynamic>{
      'id': multi
          ? '${c.careerId}_level${c.level}_lesson$lessonIndex'
          : '${c.careerId}_level${c.level}',
      'topicTitle': title,
      'careerId': c.careerId,
      'categoryId': c.path.categoryId,
      'difficulty': c.lvl.difficulty,
      'estimatedMinutes': 15 + concepts.length * 3 + quiz.length,
      'totalXp': totalXp,
      'intro': 'Welcome to "$title". This lesson is part of the '
          '"${c.levelTitle}" level of the ${c.career} path. It is built from '
          'the app\'s offline curriculum, so it works without internet or an '
          'AI key.',
      'emoji': c.path.emoji,
      'concepts': concepts,
      'quiz': quiz,
      'challenges': challenges,
      'finalProject': project,
      'source': source,
    };
  }

  // ── Resolving the curriculum ───────────────────────────────────────

  static List<CTopic> _topicsOf(GeneratedCareerPath p, GeneratedLevel l) {
    if (l.topics.isNotEmpty) {
      return l.topics.map((t) => CTopic(t, '')).toList();
    }
    return LocalCurriculum.topicsFor(p.careerId, l.level) ?? const <CTopic>[];
  }

  static _Ctx _resolve(String careerId, int level, int? lessonIndex) {
    GeneratedCareerPath? path;
    for (final p in dynamicCareerPaths) {
      if (p.careerId == careerId) {
        path = p;
        break;
      }
    }
    if (path == null) {
      throw LocalGenerationException(
          'Unknown career id "$careerId". Add it to dynamic_career_paths.dart.');
    }
    GeneratedLevel? lvl;
    for (final l in path.levels) {
      if (l.level == level) {
        lvl = l;
        break;
      }
    }
    if (lvl == null) {
      throw LocalGenerationException('Career "$careerId" has no level $level.');
    }
    final topics = _topicsOf(path, lvl);
    if (topics.length < 4) {
      throw LocalGenerationException(
          'Level $level of "$careerId" needs at least 4 curriculum topics '
          '(found ${topics.length}). Add them to local_curriculum.dart.');
    }
    final otherNames = <String>[];
    final otherTitles = <String>[];
    for (final l in path.levels) {
      if (l.level == level) continue;
      otherTitles.add(l.levelTitle);
      for (final t in _topicsOf(path, l)) {
        otherNames.add(t.name);
      }
    }
    final own = topics.map((t) => t.name).toSet();
    otherNames.removeWhere(own.contains);
    return _Ctx(
      path: path,
      lvl: lvl,
      topics: topics,
      otherNames: otherNames,
      otherLevelTitles: otherTitles,
      lessonIndex: lessonIndex,
    );
  }

  // ── Titles ─────────────────────────────────────────────────────────

  static String _cap(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  static String _lessonTitle(List<CTopic> topics, int i) {
    final n = topics.length;
    final t = topics[(i - 1) % n];
    final round = (i - 1) ~/ n;
    final angle = _angles[round % _angles.length];
    final part = round ~/ _angles.length + 1;
    return '${t.name} — ${_cap(angle)}${part > 1 ? ' (part $part)' : ''}';
  }

  // ── Deterministic helpers (same input => same output) ─────────────

  // Small hash that stays below 2^53 so it behaves the same on Web.
  static int _hash(String s) {
    var h = 7;
    for (final u in s.codeUnits) {
      h = (h * 31 + u) & 0x3FFFFFFF;
    }
    return h;
  }

  static List<String> _pick(List<String> pool, String seed, int count,
      {Set<String> exclude = const <String>{}}) {
    final uniq = <String>{...pool}..removeAll(exclude);
    final list = uniq.toList()
      ..sort((a, b) {
        final c = _hash('$seed|$a').compareTo(_hash('$seed|$b'));
        return c != 0 ? c : a.compareTo(b);
      });
    return list.take(count).toList();
  }

  static Map<String, dynamic>? _mcq({
    required String question,
    required String correct,
    required List<String> wrong,
    required String seed,
    required String explanation,
  }) {
    if (correct.trim().isEmpty) return null;
    final w = _pick(wrong.where((e) => e.trim().isNotEmpty).toList(), seed, 3,
        exclude: <String>{correct});
    if (w.length < 3) return null;
    final pos = _hash(seed) % 4;
    final options = List<String>.from(w)..insert(pos, correct);
    return <String, dynamic>{
      'question': question,
      'options': options,
      'correctIndex': pos,
      'explanation': explanation,
    };
  }

  // ── Concepts ───────────────────────────────────────────────────────

  static String _defn(_Ctx c, CTopic t) => t.desc.isNotEmpty
      ? t.desc
      : 'In the "${c.levelTitle}" level of the ${c.career} path, ${t.name} '
          'is one of the core skills you are expected to practise.';

  static Map<String, dynamic> _concept(String title, String definition,
          String analogy, String example, String takeaway) =>
      <String, dynamic>{
        'title': title,
        'definition': definition,
        'analogy': analogy,
        'example': example,
        'keyTakeaway': takeaway,
        'codeSnippet': null,
      };

  static String _analogy(String angle, String name, String career) {
    switch (angle) {
      case 'worked example':
        return 'Like watching a chef cook before trying the recipe yourself, '
            'following one worked case of $name shows how the steps connect.';
      case 'hands-on practice':
        return 'Like practising scales before a song, repeating small '
            'exercises with $name builds the habit you need on the job.';
      case 'common mistakes':
        return 'Like a pilot\'s checklist, a list of known mistakes with '
            '$name stops you repeating them under pressure.';
      case 'review and recap':
        return 'Like revising with flash cards, a short recap of $name moves '
            'it from short-term to long-term memory.';
      default:
        return 'Think of $name as one tool in a $career\'s toolbox: you learn '
            'what it does first so you can pick it up with confidence later.';
    }
  }

  static String _example(String angle, String name, String career, String lvl) {
    switch (angle) {
      case 'worked example':
        return 'Worked case: a $career gets a task in the "$lvl" level. '
            'Step 1: decide that $name applies. Step 2: try it on a small '
            'sample. Step 3: check the result. Step 4: write down what you '
            'learned.';
      case 'hands-on practice':
        return 'Practice: choose a small sample task related to "$lvl" and '
            'apply $name to it. Limit yourself to 20 minutes and record what '
            'worked and what did not.';
      case 'common mistakes':
        return 'Typical mistakes: using $name without reading the scope, '
            'skipping a check of the result, and not documenting what was '
            'done.';
      case 'review and recap':
        return 'Recap: explain $name from memory, give one example, and name '
            'one related topic from this level.';
      default:
        return 'Say in one sentence what $name is, then name one place in '
            '"$lvl" work where you would meet it.';
    }
  }

  static List<Map<String, dynamic>> _concepts(
      _Ctx c, int focusIdx, String angle, bool multi) {
    final focus = c.topics[focusIdx];
    final cands = <Map<String, dynamic>>[];

    if (multi) {
      cands.add(_concept(
        focus.name,
        _defn(c, focus),
        _analogy(angle, focus.name, c.career),
        _example(angle, focus.name, c.career, c.levelTitle),
        focus.desc.isNotEmpty
            ? 'Remember: ${focus.desc}'
            : 'Remember: ${focus.name} is a core skill of the '
                '"${c.levelTitle}" level. Know when and why to use it.',
      ));
      for (var i = 0; i < c.topics.length; i++) {
        if (i == focusIdx) continue;
        final o = c.topics[i];
        cands.add(_concept(
          'Related: ${o.name}',
          _defn(c, o),
          'In real ${c.career} work, ${o.name} is often used together with '
              '${focus.name}, so knowing both helps you choose the right step.',
          'Ask yourself: when would a ${c.career} need ${o.name} while also '
              'working on ${focus.name}? Write down one situation.',
          'Use ${o.name} together with ${focus.name} when the task needs both.',
        ));
      }
    } else {
      for (final t in c.topics) {
        cands.add(_concept(
          t.name,
          _defn(c, t),
          _analogy('core idea', t.name, c.career),
          _example('core idea', t.name, c.career, c.levelTitle),
          t.desc.isNotEmpty
              ? 'Remember: ${t.desc}'
              : 'Remember: ${t.name} is a core skill of this level.',
        ));
      }
    }

    cands.add(_concept(
      'Applying ${focus.name} as a ${c.career}',
      'Applying a skill means using it on a real task with a clear goal, a '
          'method and a way to check the result.',
      'Like learning to drive, reading about ${focus.name} is only the '
          'start; confidence comes from practice.',
      'Step 1: write the goal. Step 2: apply ${focus.name}. Step 3: check the '
          'result. Step 4: note what you would change.',
      'Practise ${focus.name} on a small task and record the result.',
    ));
    for (final t in c.topics) {
      cands.add(_concept(
        'Checklist: ${t.name}',
        _defn(c, t),
        'Like a pre-flight checklist, a short list for ${t.name} makes sure '
            'you do not skip an important step.',
        'Can you explain ${t.name} in one sentence and give one example from '
            '"${c.levelTitle}"?',
        'If you cannot explain ${t.name} simply, review it again.',
      ));
    }
    final want = CourseGeneratorConfig.conceptsPerLesson;
    return cands.take(want).toList();
  }

  // ── Quiz and challenges ────────────────────────────────────────────

  static Map<String, dynamic>? _buildQ(
      int kind, _Ctx c, CTopic t, String seed) {
    final levelNames = c.topics.map((e) => e.name).toList();
    switch (kind) {
      case 1: // describe the topic
        if (t.desc.isEmpty) return null;
        return _mcq(
          question: 'Which statement best describes "${t.name}"?',
          correct: t.desc,
          wrong: c.topics
              .where((e) => e.name != t.name)
              .map((e) => e.desc)
              .toList(),
          seed: seed,
          explanation: '${t.name}: ${t.desc}',
        );
      case 2: // name the topic from its description
        if (t.desc.isEmpty) return null;
        return _mcq(
          question: 'Which topic is described by this sentence: "${t.desc}"',
          correct: t.name,
          wrong: levelNames,
          seed: seed,
          explanation: '${t.name}: ${t.desc}',
        );
      case 3: // belongs to this level
        return _mcq(
          question: 'Which of these topics is covered in the '
              '"${c.levelTitle}" level of the ${c.career} path?',
          correct: t.name,
          wrong: c.otherNames,
          seed: seed,
          explanation: '${t.name} is part of the "${c.levelTitle}" level.',
        );
      case 4: // which level covers the topic
        return _mcq(
          question: 'Which level of the ${c.career} path covers '
              '"${t.name}"?',
          correct: c.levelTitle,
          wrong: c.otherLevelTitles,
          seed: seed,
          explanation: '${t.name} is taught in the "${c.levelTitle}" level.',
        );
      case 5: // which is NOT in this level
        final odd = _pick(c.otherNames, seed, 1);
        if (odd.isEmpty) return null;
        return _mcq(
          question: 'Which of these topics is NOT covered in the '
              '"${c.levelTitle}" level?',
          correct: odd.first,
          wrong: levelNames,
          seed: seed,
          explanation: '${odd.first} belongs to a different level. This level '
              'covers: ${levelNames.join(', ')}.',
        );
      case 6: // scenario using the description
        if (t.desc.isEmpty) return null;
        return _mcq(
          question: 'Scenario: as a ${c.career} in the "${c.levelTitle}" '
              'level, you need to do this: "${t.desc}" Which topic fits best?',
          correct: t.name,
          wrong: levelNames,
          seed: seed,
          explanation: '${t.name}: ${t.desc}',
        );
      case 7: // scenario without description
        return _mcq(
          question: 'Scenario: your ${c.career} team is planning work for the '
              '"${c.levelTitle}" level. Which topic belongs in that plan?',
          correct: t.name,
          wrong: c.otherNames,
          seed: seed,
          explanation: '${t.name} is part of the "${c.levelTitle}" level.',
        );
    }
    return null;
  }

  static List<Map<String, dynamic>> _questions({
    required _Ctx c,
    required int count,
    required List<int> kinds,
    required int focusIdx,
    required String tag,
  }) {
    final out = <Map<String, dynamic>>[];
    final seen = <String>{};
    for (var attempt = 0; attempt < 120 && out.length < count; attempt++) {
      final kind = kinds[attempt % kinds.length];
      final t = c.topics[(focusIdx + attempt) % c.topics.length];
      final seed =
          '${c.careerId}|${c.level}|${c.lessonIndex ?? 0}|$tag|$attempt';
      final q = _buildQ(kind, c, t, seed);
      if (q == null) continue;
      final opts = q['options'] as List<String>;
      final key = '${q['question']}|${opts[q['correctIndex'] as int]}';
      if (!seen.add(key)) continue;
      out.add(q);
    }
    if (out.length < count) {
      throw LocalGenerationException(
          'Could not build $count distinct $tag questions for '
          '"${c.careerId}" level ${c.level}.');
    }
    return out;
  }

  // ── Final project ──────────────────────────────────────────────────

  static Map<String, dynamic> _project(_Ctx c, CTopic focus, bool multi) {
    final steps = <String>[];
    final names = <String>[];
    if (multi) {
      final other = c.topics.firstWhere((t) => t.name != focus.name);
      names
        ..add(focus.name)
        ..add(other.name);
      steps.addAll(<String>[
        'Pick a small, realistic ${c.career} scenario connected to '
            '"${c.levelTitle}" and write the goal in one sentence.',
        'Explain ${focus.name} in your own words'
            '${focus.desc.isNotEmpty ? ' and compare it with this definition: ${focus.desc}' : ''}.',
        'Apply ${focus.name} to your scenario and note every action and '
            'result.',
        'Connect it with ${other.name}: describe how the two work together '
            'in your scenario.',
        'Review your work, list one mistake to avoid next time and one '
            'question to research further.',
      ]);
    } else {
      steps.add('Pick a small, realistic ${c.career} scenario connected to '
          '"${c.levelTitle}" and write the goal in one sentence.');
      for (final t in c.topics) {
        names.add(t.name);
        steps.add('Apply ${t.name} to your scenario and note what you did '
            'and what you observed.');
      }
      steps.add('Review your work, list one mistake to avoid next time and '
          'one question to research further.');
    }
    final title = multi
        ? 'Mini project: apply ${focus.name}'
        : '${c.levelTitle} capstone';
    return <String, dynamic>{
      'title': title,
      'goal': multi
          ? 'Use ${focus.name} on a small, realistic task and explain your '
              'result.'
          : 'Combine the topics of "${c.levelTitle}" in one small, realistic '
              '${c.career} task.',
      'steps': steps,
      'expectedOutput': 'A short write-up (about one page) or a working demo '
          'that shows ${names.join(' and ')}, plus your notes on mistakes to '
          'avoid.',
      'xpReward': CourseGeneratorConfig.defaultProjectXp,
    };
  }
}

// ══════════════════════════════════════════════════════════════════════
// Course JSON validator. Used by tests AND by the app to reject a bad
// backend response instead of silently showing an empty course.
// ══════════════════════════════════════════════════════════════════════

class CourseJsonValidator {
  CourseJsonValidator._();

  static const Set<String> _difficulties = <String>{'Easy', 'Medium', 'Hard'};

  /// Returns a list of problems. Empty list means the course is valid.
  /// With [strictCounts] the concept/quiz/challenge counts must match
  /// CourseGeneratorConfig exactly.
  static List<String> validate(Map<String, dynamic> j,
      {bool strictCounts = false}) {
    final e = <String>[];

    String? str(String k) {
      final v = j[k];
      if (v is! String || v.trim().isEmpty) {
        e.add('"$k" must be a non-empty string.');
        return null;
      }
      return v;
    }

    int? intOf(Map m, String k, String where, {int min = 1}) {
      final v = m[k];
      if (v is! num || v != v.truncate() || v < min) {
        e.add('$where "$k" must be a whole number >= $min.');
        return null;
      }
      return v.toInt();
    }

    str('id');
    str('topicTitle');
    str('careerId');
    str('categoryId');
    str('intro');
    str('emoji');
    final diff = str('difficulty');
    if (diff != null && !_difficulties.contains(diff)) {
      e.add('"difficulty" must be Easy, Medium or Hard.');
    }
    intOf(j, 'estimatedMinutes', 'course');
    intOf(j, 'totalXp', 'course');

    // concepts
    final concepts = j['concepts'];
    if (concepts is! List || concepts.isEmpty) {
      e.add('"concepts" must be a non-empty list.');
    } else {
      if (strictCounts &&
          concepts.length != CourseGeneratorConfig.conceptsPerLesson) {
        e.add('Expected ${CourseGeneratorConfig.conceptsPerLesson} concepts, '
            'found ${concepts.length}.');
      }
      for (var i = 0; i < concepts.length; i++) {
        final m = concepts[i];
        if (m is! Map) {
          e.add('concepts[$i] must be an object.');
          continue;
        }
        for (final k in <String>[
          'title',
          'definition',
          'analogy',
          'example',
          'keyTakeaway'
        ]) {
          final v = m[k];
          if (v is! String || v.trim().isEmpty) {
            e.add('concepts[$i].$k must be a non-empty string.');
          }
        }
        final cs = m['codeSnippet'];
        if (cs != null && cs is! String) {
          e.add('concepts[$i].codeSnippet must be a string or null.');
        }
      }
    }

    void mcqList(String key, String textKey, int expected) {
      final list = j[key];
      if (list is! List || list.isEmpty) {
        e.add('"$key" must be a non-empty list.');
        return;
      }
      if (strictCounts && list.length != expected) {
        e.add('Expected $expected $key items, found ${list.length}.');
      }
      for (var i = 0; i < list.length; i++) {
        final m = list[i];
        final where = '$key[$i]';
        if (m is! Map) {
          e.add('$where must be an object.');
          continue;
        }
        final q = m[textKey];
        if (q is! String || q.trim().isEmpty) {
          e.add('$where.$textKey must be a non-empty string.');
        }
        final opts = m['options'];
        if (opts is! List || opts.length != 4) {
          e.add('$where.options must have exactly 4 items.');
        } else {
          final strs = opts.whereType<String>().map((s) => s.trim()).toList();
          if (strs.length != 4 || strs.any((s) => s.isEmpty)) {
            e.add('$where.options must be 4 non-empty strings.');
          } else if (strs.toSet().length != 4) {
            e.add('$where.options must be 4 different answers.');
          }
          final ci = m['correctIndex'];
          if (ci is! int || ci < 0 || ci >= opts.length) {
            e.add('$where.correctIndex must be 0-3.');
          }
        }
        final ex = m['explanation'];
        if (ex is! String || ex.trim().isEmpty) {
          e.add('$where.explanation must be a non-empty string.');
        }
        intOf(m, 'xpReward', where);
      }
    }

    mcqList('quiz', 'question', CourseGeneratorConfig.quizQuestionsPerLesson);
    mcqList('challenges', 'prompt', CourseGeneratorConfig.challengesPerLesson);

    final fp = j['finalProject'];
    if (fp is! Map) {
      e.add('"finalProject" must be an object.');
    } else {
      for (final k in <String>['title', 'goal', 'expectedOutput']) {
        final v = fp[k];
        if (v is! String || v.trim().isEmpty) {
          e.add('finalProject.$k must be a non-empty string.');
        }
      }
      final steps = fp['steps'];
      if (steps is! List ||
          steps.isEmpty ||
          steps.any((s) => s is! String || s.trim().isEmpty)) {
        e.add('finalProject.steps must be a non-empty list of strings.');
      }
      intOf(fp, 'xpReward', 'finalProject', min: 0);
    }
    return e;
  }

  /// Validates the lesson list {"lessons":[{index,title}]}.
  static List<String> validateLessonList(Map<String, dynamic> j,
      {int? expectedCount}) {
    final e = <String>[];
    final l = j['lessons'];
    if (l is! List || l.isEmpty) {
      return <String>['"lessons" must be a non-empty list.'];
    }
    if (expectedCount != null && l.length != expectedCount) {
      e.add('Expected $expectedCount lessons, found ${l.length}.');
    }
    final titles = <String>{};
    for (var i = 0; i < l.length; i++) {
      final m = l[i];
      if (m is! Map) {
        e.add('lessons[$i] must be an object.');
        continue;
      }
      if (m['index'] is! int || (m['index'] as int) < 1) {
        e.add('lessons[$i].index must be a whole number >= 1.');
      }
      final t = m['title'];
      if (t is! String || t.trim().isEmpty) {
        e.add('lessons[$i].title must be a non-empty string.');
      } else if (!titles.add(t.trim().toLowerCase())) {
        e.add('lessons[$i].title "$t" is a duplicate.');
      }
    }
    return e;
  }
}
