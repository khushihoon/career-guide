import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/copilot_models.dart';
import '../services/copilot_provider.dart';

class SkillGapScreen extends StatelessWidget {
  const SkillGapScreen({super.key});

  static const _bg      = Color(0xFF0F0F1A);
  static const _surface = Color(0xFF1A1A2E);
  static const _border  = Color(0xFF2A2A40);
  static const _primary = Color(0xFF7C3AED);
  static const _secondary=Color(0xFFA78BFA);
  static const _muted   = Color(0xFF888899);

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: maybeOf use karo
    final ctrl = CopilotProvider.maybeOf(context);
    
    // ✅ Agar provider nahi mila to loading dikhao
    if (ctrl == null) {
      return Scaffold(
        backgroundColor: _bg,
        body: const Center(
          child: CircularProgressIndicator(color: _primary),
        ),
      );
    }
    
    final state = ctrl.state;
    final gaps  = state.skillGaps;
    final role  = state.skillProfile?.targetRole.label ?? 'Your Role';

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text('Skill Gap Analysis',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: gaps.isEmpty
          ? _empty()
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                    child: _headerCard(role, gaps),
                  ).animate().fadeIn(),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Gaps to Bridge (${gaps.length})',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _GapCard(gap: gaps[i])
                          .animate()
                          .fadeIn(delay: Duration(milliseconds: i * 60))
                          .slideX(begin: 0.05),
                      childCount: gaps.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
    );
  }

  Widget _headerCard(String role, List<SkillGap> gaps) {
    final critical  = gaps.where((g) => g.priority == 1).length;
    final important = gaps.where((g) => g.priority == 2).length;
    final nice      = gaps.where((g) => g.priority == 3).length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primary.withOpacity(0.25), _secondary.withOpacity(0.10)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _primary.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.radar, color: Color(0xFFA78BFA), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Gap Analysis for $role',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _badge('$critical', 'Critical', const Color(0xFFEF4444)),
              const SizedBox(width: 10),
              _badge('$important', 'Important', const Color(0xFFF59E0B)),
              const SizedBox(width: 10),
              _badge('$nice', 'Nice to have', const Color(0xFF6EE7B7)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(count,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(color: color.withOpacity(0.8), fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.radar, color: Color(0xFF444455), size: 56),
          const SizedBox(height: 16),
          const Text('No analysis yet',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 8),
          const Text('Set up your skill profile to get started',
              style: TextStyle(color: Color(0xFF888899), fontSize: 13)),
        ],
      ),
    );
  }
}

class _GapCard extends StatelessWidget {
  final SkillGap gap;
  const _GapCard({required this.gap});

  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _secondary= Color(0xFFA78BFA);

  Color get _priorityColor {
    switch (gap.priority) {
      case 1:  return const Color(0xFFEF4444);
      case 2:  return const Color(0xFFF59E0B);
      default: return const Color(0xFF6EE7B7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: _priorityColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(gap.skillName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _priorityColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(gap.priorityLabel,
                    style:
                        TextStyle(color: _priorityColor, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _LevelBar(gap: gap),
          const SizedBox(height: 8),
          Text(gap.reason,
              style: const TextStyle(
                  color: Color(0xFF888899), fontSize: 12, height: 1.4)),
        ],
      ),
    );
  }
}

class _LevelBar extends StatelessWidget {
  final SkillGap gap;
  const _LevelBar({required this.gap});

  @override
  Widget build(BuildContext context) {
    final required = gap.requiredLevel.value;
    final current  = gap.currentLevel?.value ?? 0;
    final max      = 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              gap.isNew
                  ? 'Not started'
                  : 'Current: ${gap.currentLevel!.label}',
              style: const TextStyle(
                  color: Color(0xFF888899), fontSize: 11),
            ),
            Text('Target: ${gap.requiredLevel.label}',
                style: const TextStyle(
                    color: Color(0xFFA78BFA), fontSize: 11)),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFF0F0F20),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            FractionallySizedBox(
              widthFactor: required / max,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            if (current > 0)
              FractionallySizedBox(
                widthFactor: current / max,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}