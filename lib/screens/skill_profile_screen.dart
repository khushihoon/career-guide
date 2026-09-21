// ══════════════════════════════════════════════════════════════════════
// lib/screens/skill_profile_screen.dart
//
// Skill Profile UI — target career, current role, experience, and a
// list of self-rated skills.
//
// Architecture boundaries (enforced deliberately):
//  • Reads the existing profile from CopilotController.state.skillProfile
//    (via CopilotProvider.maybeOf(context)) — no direct Firestore access.
//  • Saving calls CopilotController.saveSkillProfile(profile) ONLY. That
//    single call already persists the profile via CopilotFirestoreService
//    AND triggers the controller's existing skill-gap / roadmap / daily
//    goal analysis pipeline (see CopilotController._runAnalysis) —
//    nothing about that pipeline is reimplemented here.
//  • No skill-gap, roadmap, readiness, or Next-Best-Action logic lives in
//    this file — that's entirely CopilotController's responsibility.
//  • Career list is read exclusively from CareerGoal.values — no local
//    duplicate list exists in this screen.
//
// SAVE-RESULT HANDLING
// ────────────────────
// CopilotController.saveSkillProfile(profile) persists the profile and
// runs the analysis pipeline, but it swallows failures into
// ctrl.state.error rather than throwing. This screen therefore inspects
// ctrl.state.error AFTER the save completes:
//
//   • Error present  → keep the screen open, stop the saving state,
//                      surface the actual error text in a SnackBar, and
//                      leave every form field (target career, current
//                      role, experience, skills) untouched so the user
//                      can retry without re-entering data.
//   • No error        → stop the saving state and Navigator.pop() as
//                      before.
//
// The single persistence path (SkillProfileScreen → CopilotController →
// Firestore) is preserved; no direct Firestore calls are made here.
//
// Built against copilot_models.dart's actual UserSkillProfile / UserSkill
// / SkillLevel / CareerGoal shapes — nothing here invents new fields or
// a new profile shape.
// ══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/copilot_models.dart';
import '../services/copilot_controller.dart';
import '../services/copilot_provider.dart';

class SkillProfileScreen extends StatefulWidget {
  const SkillProfileScreen({super.key});

  @override
  State<SkillProfileScreen> createState() => _SkillProfileScreenState();
}

class _SkillProfileScreenState extends State<SkillProfileScreen> {
  static const _bg       = Color(0xFF0F0F1A);
  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);

  final _currentRoleCtrl = TextEditingController();
  final _newSkillCtrl = TextEditingController();

  CareerGoal _targetRole = CareerGoal.aiEngineer;
  int _experienceMonths = 0;
  List<UserSkill> _skills = [];
  SkillLevel _newSkillLevel = SkillLevel.beginner;

  bool _hydrated = false;
  bool _saving = false;

  @override
  void dispose() {
    _currentRoleCtrl.dispose();
    _newSkillCtrl.dispose();
    super.dispose();
  }

  /// Pre-fills the form from the controller's existing profile exactly
  /// once. Safe to call on every build — only acts the first time a
  /// non-null profile is seen, so it never clobbers an in-progress edit
  /// on rebuild (e.g. while the profile stream re-emits in the
  /// background).
  void _hydrateFrom(UserSkillProfile? profile) {
    if (_hydrated || profile == null) return;
    _hydrated = true;
    _targetRole = profile.targetRole;
    _experienceMonths = profile.experienceMonths;
    _currentRoleCtrl.text = profile.currentRole;
    _skills = [...profile.skills];
  }

  String get _experienceLabel {
    if (_experienceMonths <= 0) return 'Just starting out';
    final years = _experienceMonths ~/ 12;
    final months = _experienceMonths % 12;
    final parts = <String>[];
    if (years > 0) parts.add('$years ${years == 1 ? "year" : "years"}');
    if (months > 0) parts.add('$months ${months == 1 ? "month" : "months"}');
    return parts.join(' ');
  }

  void _addSkill() {
    final name = _newSkillCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() {
      final existingIndex =
          _skills.indexWhere((s) => s.name.toLowerCase() == name.toLowerCase());
      final skill =
          UserSkill(name: name, level: _newSkillLevel, addedAt: DateTime.now());
      if (existingIndex >= 0) {
        _skills[existingIndex] = skill; // update level if re-added
      } else {
        _skills.add(skill);
      }
      _newSkillCtrl.clear();
      _newSkillLevel = SkillLevel.beginner;
    });
  }

  void _removeSkill(UserSkill skill) {
    setState(() => _skills.removeWhere((s) => s.name == skill.name));
  }

  Future<void> _save(CopilotController ctrl) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to save your skill profile.')),
      );
      return;
    }
    if (_skills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one skill to continue.')),
      );
      return;
    }

    setState(() => _saving = true);

    final existing = ctrl.state.skillProfile;
    final profile = UserSkillProfile(
      uid: uid,
      targetRole: _targetRole,
      skills: _skills,
      experienceMonths: _experienceMonths,
      currentRole: _currentRoleCtrl.text.trim().isEmpty
          ? 'Student'
          : _currentRoleCtrl.text.trim(),
      createdAt: existing?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Single call: CopilotController owns persistence AND kicks off its
    // existing skill-gap / roadmap / daily-goal analysis pipeline. This
    // screen does nothing else with the saved data.
    try {
      await ctrl.saveSkillProfile(profile);
    } catch (_) {
      // Controller normally surfaces failures via ctrl.state.error, but
      // guard against an unexpected throw so the screen never advances
      // silently.
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Couldn\'t save your profile. Please try again.'),
        ),
      );
      return;
    }

    if (!mounted) return;

    // Production save-result handling: the controller writes failures
    // into ctrl.state.error instead of throwing. Read the authoritative
    // post-save state and only consider the save successful when there
    // is no error recorded.
    final saveError = ctrl.state.error;

    if (saveError != null && saveError.trim().isNotEmpty) {
      // Keep the screen open, stop the saving state, surface the actual
      // error, and leave every form field intact so the user can retry
      // without re-entering data.
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(saveError),
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    setState(() => _saving = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = CopilotProvider.maybeOf(context);

    if (ctrl == null) {
      return const Scaffold(
        backgroundColor: _bg,
        body: Center(child: CircularProgressIndicator(color: _primary)),
      );
    }

    _hydrateFrom(ctrl.state.skillProfile);
    final isSaving = _saving || ctrl.state.isLoading;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: Text(
          ctrl.state.hasProfile ? 'Edit Skill Profile' : 'Skill Profile',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            _sectionTitle('🎯 Target Career'),
            const SizedBox(height: 10),
            _careerGoalGrid(),
            const SizedBox(height: 24),

            _sectionTitle('💼 Current Role'),
            const SizedBox(height: 10),
            _textField(
              controller: _currentRoleCtrl,
              hint: 'e.g. Student, Junior Developer, Career switcher',
            ),
            const SizedBox(height: 24),

            _sectionTitle('📈 Experience'),
            const SizedBox(height: 4),
            Text(
              _experienceLabel,
              style: const TextStyle(
                  color: _secondary, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: _primary,
                inactiveTrackColor: _border,
                thumbColor: _primary,
                overlayColor: _primary.withOpacity(0.15),
                valueIndicatorColor: _primary,
              ),
              child: Slider(
                value: _experienceMonths.toDouble(),
                min: 0,
                max: 120,
                divisions: 24,
                label: _experienceLabel,
                onChanged: (v) => setState(() => _experienceMonths = v.round()),
              ),
            ),
            const SizedBox(height: 12),

            _sectionTitle('🧠 Your Skills (${_skills.length})'),
            const SizedBox(height: 10),
            _skillAdder(),
            const SizedBox(height: 12),
            if (_skills.isEmpty)
              _emptySkillsHint()
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _skills
                    .map((s) => _SkillChip(skill: s, onRemove: () => _removeSkill(s)))
                    .toList(),
              ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : () => _save(ctrl),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  disabledBackgroundColor: _primary.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        ctrl.state.hasProfile
                            ? 'Update Profile'
                            : 'Save & Analyse My Skills',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your Copilot uses this to find skill gaps, build a roadmap, and set daily goals.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
      );

  Widget _textField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _muted, fontSize: 13),
        filled: true,
        fillColor: _surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _primary, width: 1.5)),
      ),
    );
  }

  Widget _careerGoalGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: CareerGoal.values.map((g) {
        final selected = g == _targetRole;
        return GestureDetector(
          onTap: () => setState(() => _targetRole = g),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? _primary.withOpacity(0.22) : _surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: selected ? _primary : _border, width: selected ? 1.5 : 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(g.emoji, style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 6),
                Text(
                  g.label,
                  style: TextStyle(
                    color: selected ? _secondary : Colors.white70,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _skillAdder() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textField(
              controller: _newSkillCtrl,
              hint: 'e.g. Python, SQL, Prompt Engineering'),
          const SizedBox(height: 10),
          // Level options are read from SkillLevel.values directly (not
          // hard-coded) so this screen automatically stays correct if the
          // model's level set ever changes — nothing here re-declares the
          // enum's own values.
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: SkillLevel.values.map((lvl) {
              final selected = lvl == _newSkillLevel;
              return GestureDetector(
                onTap: () => setState(() => _newSkillLevel = lvl),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected ? _primary.withOpacity(0.22) : _bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: selected ? _primary : _border),
                  ),
                  child: Text(
                    lvl.label,
                    style: TextStyle(
                      color: selected ? _secondary : _muted,
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addSkill,
              icon: const Icon(Icons.add, color: _secondary, size: 18),
              label: const Text('Add Skill', style: TextStyle(color: _secondary)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _primary),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptySkillsHint() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: const Text(
        'No skills added yet. Add a few above so your Copilot can find the right gaps to close.',
        style: TextStyle(color: _muted, fontSize: 12),
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final UserSkill skill;
  final VoidCallback onRemove;
  const _SkillChip({required this.skill, required this.onRemove});

  static const _surface = Color(0xFF1A1A2E);
  static const _border  = Color(0xFF2A2A40);
  static const _muted   = Color(0xFF888899);

  Color get _levelColor {
    switch (skill.level) {
      case SkillLevel.beginner:
        return const Color(0xFF60A5FA);
      case SkillLevel.intermediate:
        return const Color(0xFFF59E0B);
      case SkillLevel.advanced:
        return const Color(0xFFA78BFA);
      case SkillLevel.expert:
        return const Color(0xFF4ADE80);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: _levelColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            skill.name,
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          Text(skill.level.label, style: TextStyle(color: _levelColor, fontSize: 10)),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: _muted),
          ),
        ],
      ),
    );
  }
}