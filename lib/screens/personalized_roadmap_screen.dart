import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/copilot_models.dart';
import '../services/copilot_provider.dart';

class PersonalizedRoadmapScreen extends StatelessWidget {
  const PersonalizedRoadmapScreen({super.key});

  static const _bg       = Color(0xFF0F0F1A);
  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);
  static const _muted    = Color(0xFF888899);

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
    
    final roadmap = ctrl.state.roadmap;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text('Learning Roadmap',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: roadmap == null
          ? _empty()
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                    child: _ProgressHeader(roadmap: roadmap),
                  ).animate().fadeIn(),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) {
                        final phase = roadmap.phases[i];
                        final isCurrent = roadmap.currentPhaseIndex == phase.phaseNumber;
                        return _PhaseCard(
                          phase: phase,
                          isCurrent: isCurrent,
                          onComplete: phase.isUnlocked && !phase.isCompleted
                              ? () {
                                  final uid = FirebaseAuth.instance.currentUser?.uid;
                                  if (uid != null && ctrl != null) {
                                    ctrl.completePhase(uid, phase.phaseNumber);
                                  }
                                }
                              : null,
                        )
                            .animate()
                            .fadeIn(delay: Duration(milliseconds: i * 80))
                            .slideY(begin: 0.05);
                      },
                      childCount: roadmap.phases.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.route, color: Color(0xFF444455), size: 56),
          SizedBox(height: 16),
          Text('No roadmap generated yet',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 8),
          Text('Set up your skill profile first',
              style: TextStyle(color: Color(0xFF888899), fontSize: 13)),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final PersonalizedRoadmap roadmap;
  const _ProgressHeader({required this.roadmap});

  @override
  Widget build(BuildContext context) {
    final pct = (roadmap.overallProgress * 100).toInt();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7C3AED).withOpacity(0.2),
            const Color(0xFFA78BFA).withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: const Color(0xFF7C3AED).withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(roadmap.targetRole.emoji,
                  style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(roadmap.targetRole.label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
              Text('$pct%',
                  style: const TextStyle(
                      color: Color(0xFFA78BFA),
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: roadmap.overallProgress,
              minHeight: 7,
              backgroundColor: const Color(0xFF2A2A40),
              valueColor:
                  const AlwaysStoppedAnimation(Color(0xFF7C3AED)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${roadmap.phases.where((p) => p.isCompleted).length} / ${roadmap.phases.length} phases completed',
            style: const TextStyle(
                color: Color(0xFF888899), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _PhaseCard extends StatefulWidget {
  final RoadmapPhase phase;
  final bool isCurrent;
  final VoidCallback? onComplete;

  const _PhaseCard({
    required this.phase,
    required this.isCurrent,
    this.onComplete,
  });

  @override
  State<_PhaseCard> createState() => _PhaseCardState();
}

class _PhaseCardState extends State<_PhaseCard> {
  bool _expanded = false;

  static const _surface  = Color(0xFF1A1A2E);
  static const _border   = Color(0xFF2A2A40);
  static const _primary  = Color(0xFF7C3AED);
  static const _secondary= Color(0xFFA78BFA);

  Color get _stateColor {
    if (widget.phase.isCompleted) return const Color(0xFF4ADE80);
    if (widget.isCurrent)         return _primary;
    if (!widget.phase.isUnlocked) return const Color(0xFF444455);
    return const Color(0xFFF59E0B);
  }

  @override
  Widget build(BuildContext context) {
    final locked = !widget.phase.isUnlocked;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isCurrent
              ? _primary.withOpacity(0.5)
              : _border,
          width: widget.isCurrent ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: locked ? null : () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: locked
                          ? const Color(0xFF0F0F20)
                          : _stateColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: _stateColor),
                    ),
                    child: Center(
                      child: widget.phase.isCompleted
                          ? const Icon(Icons.check,
                              size: 18, color: Color(0xFF4ADE80))
                          : locked
                              ? const Icon(Icons.lock_outline,
                                  size: 16, color: Color(0xFF444455))
                              : Text(
                                  '${widget.phase.phaseNumber + 1}',
                                  style: TextStyle(
                                      color: _stateColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.phase.title,
                            style: TextStyle(
                                color: locked
                                    ? const Color(0xFF666677)
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(widget.phase.estimatedDuration,
                            style: const TextStyle(
                                color: Color(0xFF888899), fontSize: 12)),
                      ],
                    ),
                  ),
                  if (!locked) ...[
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: const Color(0xFF888899),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_expanded && !locked) ...[
            const Divider(color: Color(0xFF2A2A40), height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.phase.description,
                      style: const TextStyle(
                          color: Color(0xFF888899),
                          fontSize: 13,
                          height: 1.5)),
                  const SizedBox(height: 14),
                  const Text('Skills you\'ll learn',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: widget.phase.skills
                        .map((s) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: _primary.withOpacity(0.3)),
                              ),
                              child: Text(s,
                                  style: const TextStyle(
                                      color: Color(0xFFA78BFA),
                                      fontSize: 11)),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Resources',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                  const SizedBox(height: 8),
                  ...widget.phase.resources.map(
                    (res) => _ResourceTile(resource: res),
                  ),
                  if (widget.onComplete != null) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: widget.onComplete,
                        icon: const Icon(Icons.check_circle_outline,
                            size: 18),
                        label: const Text('Mark Phase Complete'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4ADE80),
                          side: const BorderSide(
                              color: Color(0xFF4ADE80), width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResourceTile extends StatelessWidget {
  final LearningResource resource;
  const _ResourceTile({required this.resource});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.tryParse(resource.url);
        if (url != null && await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A40)),
        ),
        child: Row(
          children: [
            Text(resource.icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(resource.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text('${resource.platform} · ${resource.duration}',
                      style: const TextStyle(
                          color: Color(0xFF888899), fontSize: 11)),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: resource.isFree
                    ? const Color(0xFF4ADE80).withOpacity(0.15)
                    : const Color(0xFFF59E0B).withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                resource.isFree ? 'Free' : 'Paid',
                style: TextStyle(
                    color: resource.isFree
                        ? const Color(0xFF4ADE80)
                        : const Color(0xFFF59E0B),
                    fontSize: 10),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.open_in_new,
                size: 14, color: Color(0xFF666677)),
          ],
        ),
      ),
    );
  }
}