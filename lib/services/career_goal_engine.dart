// lib/services/career_goal_engine.dart
//
// PURPOSE
// -------
// Deterministic decision layer for Career Guide daily goals.
//
// This file does NOT persist data, award XP, calculate readiness, or call an
// API. It chooses existing GoalTemplate content using the user's real career
// state and evidence available to the caller.
//
// Decision priority:
//   explicit focus skill
//   -> open skill gaps
//   -> selected/profile skills
//   -> current NextBestAction
//   -> career/stage progression
//   -> recent-work avoidance
//
// Daily progression is intentionally human and professional:
//   LEARN -> PRACTICE -> BUILD -> TEST/PROVE
//
// Friendly rest messages are NOT goals and never create XP/evidence.

import '../models/copilot_models.dart';
import 'goal_content_database.dart';

class CareerGoalDecision {
  final List<GoalTemplate> templates;
  final String? focusSkill;
  final String? decisionReason;

  const CareerGoalDecision({
    required this.templates,
    this.focusSkill,
    this.decisionReason,
  });

  bool get isEmpty => templates.isEmpty;
}

class CareerGoalEngine {
  const CareerGoalEngine();

  CareerGoalDecision decideDaily({
    required CareerGoal career,
    required UserSkillProfile? profile,
    required List<SkillGap> skillGaps,
    CopilotContext? context,
    String? preferredSkill,
    int currentLevel = 1,
    int roadmapPhase = 0,
    Set<String> completedGoalIds = const {},
    Set<String> recentGoalIds = const {},
    Set<String> recentSkillNames = const {},
    int maxGoals = 4,
  }) {
    final pool = GoalContentDatabase.dailyForRole(career.label);
    if (pool.isEmpty) {
      return const CareerGoalDecision(templates: []);
    }

    final skillLevels = <String, int>{};
    for (final skill in profile?.skills ?? const <UserSkill>[]) {
      skillLevels[_key(skill.name)] = skill.level.value;
    }

    final gapBySkill = <String, SkillGap>{};
    for (final gap in skillGaps) {
      if (gap.careerId != null &&
          context?.career?.careerId != null &&
          gap.careerId != context!.career!.careerId) {
        continue;
      }
      gapBySkill[_key(gap.skillName)] = gap;
    }

    final explicit = _clean(preferredSkill);
    final nextActionSkill = _clean(
      context?.pendingActions
          .where((a) =>
              a.relatedSkill != null && a.relatedSkill!.trim().isNotEmpty)
          .firstOrNull
          ?.relatedSkill,
    );
    final gapSkill = _bestGapSkill(skillGaps, context);
    final profileSkill = _bestProfileSkill(profile, gapBySkill);
    final focusSkill = explicit ?? nextActionSkill ?? gapSkill ?? profileSkill;

    final stage = context?.currentStage;
    final candidates = pool.where((t) {
      if (t.minLevel > currentLevel || t.minPhase > roadmapPhase) return false;
      if (completedGoalIds.contains(t.id) || recentGoalIds.contains(t.id))
        return false;
      return true;
    }).toList();

    final usable = candidates.isNotEmpty
        ? candidates
        : pool
            .where(
                (t) => t.minLevel <= currentLevel && t.minPhase <= roadmapPhase)
            .toList();

    final scored = <_ScoredTemplate>[];
    for (final template in usable) {
      final skill = _templateSkill(template);
      final key = _key(skill ?? '');
      final gap = key.isEmpty ? null : gapBySkill[key];
      var score = 0.0;

      // Explicit user focus always dominates generic rotation.
      if (focusSkill != null && _sameSkill(skill, focusSkill)) score += 120;
      if (gap != null) score += 60 + ((4 - gap.priority) * 18);

      // A selected/profile skill should remain relevant, but an actual gap
      // gets higher priority than a skill the user already demonstrates.
      if (key.isNotEmpty && skillLevels.containsKey(key)) score += 12;
      if (key.isNotEmpty && !skillLevels.containsKey(key)) score += 8;

      // Respect professional progression metadata.
      score += _stageScore(template.stage, stage);
      score +=
          _difficultyScore(template.difficulty, currentLevel, roadmapPhase);

      // Prefer tangible outcomes over passive reading when the user is past
      // the foundation stage.
      if (roadmapPhase >= 1 && template.professionalOutcome != null) {
        score += 10;
      }

      if (recentSkillNames.any((s) => _sameSkill(s, skill))) score -= 22;
      if (template.prerequisites.isNotEmpty) score += 3;

      // Small deterministic tie-breaker based only on stable template id.
      score += _stableTie(template.id);
      scored.add(_ScoredTemplate(template, score));
    }

    scored.sort((a, b) => b.score.compareTo(a.score));

    final picked = <GoalTemplate>[];
    final usedSkills = <String>{};

    // Slot 1: the most important current move.
    _pickFirst(scored, picked, usedSkills, focusSkill: focusSkill);

    // Slot 2: practice/implementation, preferably the same skill so the day
    // feels like one coherent journey rather than four unrelated tasks.
    _pickStage(scored, picked, usedSkills, {
      GoalStage.practice,
      GoalStage.coreSkills,
      GoalStage.testing,
    });

    // Slot 3: real-world/build/proof.
    _pickStage(scored, picked, usedSkills, {
      GoalStage.realProjects,
      GoalStage.production,
      GoalStage.deployment,
      GoalStage.portfolio,
      GoalStage.jobReady,
    });

    // Slot 4 is optional. Fill only when a distinct useful step exists.
    if (maxGoals > 3) {
      _pickStage(scored, picked, usedSkills, {
        GoalStage.foundation,
        GoalStage.coreSkills,
        GoalStage.practice,
        GoalStage.debugging,
        GoalStage.apisDatabase,
        GoalStage.gitGithub,
        GoalStage.security,
        GoalStage.architecture,
        GoalStage.ciCd,
        GoalStage.interview,
      });
    }

    // If authored metadata is sparse for a role, fill from the scored list.
    for (final item in scored) {
      if (picked.length >= maxGoals) break;
      if (!picked.contains(item.template)) picked.add(item.template);
    }

    final reason = focusSkill == null
        ? 'Selected from your current career stage and available evidence.'
        : 'Built around your current focus: $focusSkill.';

    return CareerGoalDecision(
      templates: picked.take(maxGoals).toList(growable: false),
      focusSkill: focusSkill,
      decisionReason: reason,
    );
  }

  String? _bestGapSkill(List<SkillGap> gaps, CopilotContext? context) {
    final activeCareer = context?.career?.careerId;
    final filtered = gaps.where((g) {
      if (activeCareer == null || g.careerId == null) return true;
      return g.careerId == activeCareer;
    }).toList();
    filtered.sort((a, b) {
      final p = a.priority.compareTo(b.priority);
      if (p != 0) return p;
      return b.gapScore.compareTo(a.gapScore);
    });
    return filtered.isEmpty ? null : filtered.first.skillName;
  }

  String? _bestProfileSkill(
      UserSkillProfile? profile, Map<String, SkillGap> gaps) {
    if (profile == null || profile.skills.isEmpty) return null;
    final sorted = [...profile.skills]
      ..sort((a, b) => a.level.value.compareTo(b.level.value));
    // A selected lower-level skill is a useful focus when it also appears as
    // an authored gap; otherwise the first user-selected skill remains valid.
    for (final s in sorted) {
      if (gaps.containsKey(_key(s.name))) return s.name;
    }
    return sorted.first.name;
  }

  void _pickFirst(
    List<_ScoredTemplate> scored,
    List<GoalTemplate> picked,
    Set<String> usedSkills, {
    String? focusSkill,
  }) {
    for (final item in scored) {
      final skill = _templateSkill(item.template);
      if (focusSkill != null && !_sameSkill(skill, focusSkill)) continue;
      picked.add(item.template);
      if (skill != null) usedSkills.add(_key(skill));
      return;
    }
    if (scored.isNotEmpty) {
      final item = scored.first;
      picked.add(item.template);
      final skill = _templateSkill(item.template);
      if (skill != null) usedSkills.add(_key(skill));
    }
  }

  void _pickStage(
    List<_ScoredTemplate> scored,
    List<GoalTemplate> picked,
    Set<String> usedSkills,
    Set<GoalStage> stages,
  ) {
    for (final item in scored) {
      if (picked.contains(item.template)) continue;
      if (!stages.contains(item.template.stage)) continue;
      final skill = _templateSkill(item.template);
      if (skill != null &&
          usedSkills.contains(_key(skill)) &&
          picked.length > 1) {
        // Same skill is useful, but avoid a repetitive day when another skill
        // has equal professional value.
        continue;
      }
      picked.add(item.template);
      if (skill != null) usedSkills.add(_key(skill));
      return;
    }
  }

  double _stageScore(GoalStage? templateStage, CareerStage? current) {
    if (templateStage == null || current == null) return 0;
    switch (current) {
      case CareerStage.exploration:
      case CareerStage.assessment:
      case CareerStage.learning:
        return templateStage == GoalStage.foundation ||
                templateStage == GoalStage.coreSkills
            ? 18
            : 0;
      case CareerStage.practice:
        return templateStage == GoalStage.practice ||
                templateStage == GoalStage.testing
            ? 18
            : 0;
      case CareerStage.projects:
        return templateStage == GoalStage.realProjects ||
                templateStage == GoalStage.testing ||
                templateStage == GoalStage.production
            ? 22
            : 0;
      case CareerStage.portfolio:
        return templateStage == GoalStage.portfolio ||
                templateStage == GoalStage.realProjects
            ? 22
            : 0;
      case CareerStage.cvReady:
        return templateStage == GoalStage.portfolio ? 20 : 0;
      case CareerStage.interviewPrep:
        return templateStage == GoalStage.interview ? 24 : 0;
      case CareerStage.jobSearch:
        return templateStage == GoalStage.jobReady ||
                templateStage == GoalStage.interview
            ? 22
            : 0;
      case CareerStage.jobReady:
      case CareerStage.growth:
        return templateStage == GoalStage.production ||
                templateStage == GoalStage.jobReady ||
                templateStage == GoalStage.portfolio
            ? 20
            : 0;
    }
  }

  double _difficultyScore(
    LocalGoalDifficulty difficulty,
    int level,
    int phase,
  ) {
    if (level <= 1 && difficulty == LocalGoalDifficulty.easy) return 10;
    if (level >= 3 && difficulty == LocalGoalDifficulty.hard) return 10;
    if (phase >= 2 && difficulty == LocalGoalDifficulty.medium) return 4;
    return 0;
  }

  String? _templateSkill(GoalTemplate t) =>
      _clean(t.skill) ?? _inferSkillFromText('${t.title} ${t.description}');

  String? _inferSkillFromText(String text) {
    final lower = text.toLowerCase();
    const known = <String, String>{
      'pytorch': 'PyTorch',
      'tensorflow': 'TensorFlow',
      'python': 'Python',
      'machine learning': 'Machine Learning',
      'deep learning': 'Deep Learning',
      'large language model': 'LLMs',
      'llm': 'LLMs',
      'rag': 'RAG',
      'prompt engineering': 'Prompt Engineering',
      'computer vision': 'Computer Vision',
      'natural language': 'NLP',
      'nlp': 'NLP',
      'sql': 'SQL',
      'algorithm': 'Algorithms',
      'data structure': 'Data Structures',
      'system design': 'System Design',
      'docker': 'Docker',
      'kubernetes': 'Kubernetes',
      'git': 'Git',
      'testing': 'Testing',
      'security': 'Security',
      'api': 'APIs',
      'mlops': 'MLOps',
      'cloud': 'Cloud Computing',
    };
    for (final entry in known.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return null;
  }

  bool _sameSkill(String? a, String? b) {
    if (a == null || b == null) return false;
    return _key(a) == _key(b) ||
        _key(a).contains(_key(b)) ||
        _key(b).contains(_key(a));
  }

  String _key(String value) =>
      value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();

  String? _clean(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return value.trim();
  }

  double _stableTie(String id) {
    var hash = 0;
    for (final unit in id.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return (hash % 100) / 1000.0;
  }
}

class _ScoredTemplate {
  final GoalTemplate template;
  final double score;
  const _ScoredTemplate(this.template, this.score);
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
