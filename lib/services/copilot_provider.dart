// ══════════════════════════════════════════════════════════════════════════════
// lib/services/copilot_provider.dart
//
// CAREER COPILOT — PROVIDER / UI BRIDGE
// ══════════════════════════════════════════════════════════════════════════════
//
// Architecture:
//
//   Authoritative Firestore Evidence
//             ↓
//   CopilotFirestoreService
//             ↓
//   CopilotController
//             ↓
//   CopilotProvider
//             ↓
//   Copilot UI / Screens
//
// Responsibilities:
//   • Expose the existing CopilotController to descendant widgets.
//   • Rebuild dependent widgets when CopilotController notifies.
//   • Provide listening and non-listening access.
//   • Contain NO business logic.
//   • Contain NO Firestore logic.
//   • Contain NO XP calculations.
//   • Contain NO readiness calculations.
//   • Contain NO AI/API calls.
//
// The Controller remains the intelligence/orchestration layer.
// The Provider is only the UI ↔ Controller bridge.
//
// ══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/widgets.dart';

import 'copilot_controller.dart';

/// Lightweight dependency-injection bridge for [CopilotController].
///
/// Place one [CopilotProvider] above the screens that need Copilot access.
///
/// Example:
///
///   CopilotProvider(
///     controller: copilotController,
///     child: const MainScreen(),
///   )
///
/// Descendant widgets can then use:
///
///   final copilot = CopilotProvider.of(context);
///
/// or, for optional access:
///
///   final copilot = CopilotProvider.maybeOf(context);
class CopilotProvider extends InheritedNotifier<CopilotController> {
  const CopilotProvider({
    super.key,
    required CopilotController controller,
    required super.child,
  }) : super(
          notifier: controller,
        );

  // ══════════════════════════════════════════════════════════════════════════
  // LISTENING ACCESS
  // ══════════════════════════════════════════════════════════════════════════

  /// Returns the active [CopilotController] and subscribes the calling
  /// widget to controller notifications.
  ///
  /// Use this inside `build()` when the widget needs to rebuild whenever
  /// CopilotController state changes.
  ///
  /// Example:
  ///
  ///   final controller = CopilotProvider.of(context);
  ///   final state = controller.state;
  static CopilotController of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<CopilotProvider>();

    assert(
      provider != null,
      'CopilotProvider not found in widget tree. '
      'Wrap the required widget tree with CopilotProvider.',
    );

    final controller = provider?.notifier;

    assert(
      controller != null,
      'CopilotProvider exists but its CopilotController is null.',
    );

    return controller!;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // NON-LISTENING ACCESS
  // ══════════════════════════════════════════════════════════════════════════

  /// Returns the active [CopilotController] without subscribing the calling
  /// widget to controller notifications.
  ///
  /// Use this when the widget only needs to call a controller method and
  /// should NOT rebuild when CopilotController changes.
  ///
  /// Example:
  ///
  ///   final controller = CopilotProvider.maybeOf(context);
  ///   await controller?.recordCourseEvent(...);
  ///
  /// IMPORTANT:
  /// Unlike the old implementation, this method does NOT use
  /// `dependOnInheritedWidgetOfExactType`, so it does not create a rebuild
  /// dependency.
  static CopilotController? maybeOf(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<CopilotProvider>();

    final provider = element?.widget as CopilotProvider?;

    return provider?.notifier;
  }
}