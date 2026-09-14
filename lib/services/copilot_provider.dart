// ══════════════════════════════════════════════════════════════════════════════
// lib/features/copilot/services/copilot_provider.dart
// Lightweight InheritedNotifier — zero extra packages.
// Wrap your widget tree once (in main_screen.dart) to inject the controller.
// ══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/widgets.dart';
import 'copilot_controller.dart';

class CopilotProvider extends InheritedNotifier<CopilotController> {
  const CopilotProvider({
    super.key,
    required CopilotController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Access the controller anywhere below this widget.
  static CopilotController of(BuildContext context) {
    final w = context
        .dependOnInheritedWidgetOfExactType<CopilotProvider>();
    assert(w != null, 'CopilotProvider not found in widget tree');
    return w!.notifier!;
  }

  /// Non-throwing access (returns null if not in tree).
  static CopilotController? maybeOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<CopilotProvider>()
          ?.notifier;
}