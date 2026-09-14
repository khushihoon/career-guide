import 'dart:async';
import 'package:flutter/widgets.dart';

class Achievement {
  final String title;
  final String description;
  final String emoji;
  final String rarityLabel;
  final String rarityColor;
  final int xpReward;

  const Achievement({
    required this.title,
    required this.description,
    required this.emoji,
    required this.rarityLabel,
    required this.rarityColor,
    required this.xpReward,
  });
}

class XpLevel {
  final int level;
  final String title;
  final String emoji;
  final String color;

  const XpLevel({
    required this.level,
    required this.title,
    required this.emoji,
    required this.color,
  });
}

class EngagementController {
  final StreamController<Achievement> _achievementController =
      StreamController<Achievement>.broadcast();

  final StreamController<XpLevel> _levelController =
      StreamController<XpLevel>.broadcast();

  Stream<Achievement> get achievementUnlocked =>
      _achievementController.stream;

  Stream<XpLevel> get leveledUp =>
      _levelController.stream;

  void unlockAchievement(Achievement achievement) {
    _achievementController.add(achievement);
  }

  void levelUp(XpLevel level) {
    _levelController.add(level);
  }

  void dispose() {
    _achievementController.close();
    _levelController.close();
  }
}

class EngagementProvider extends InheritedWidget {
  final EngagementController controller;

  const EngagementProvider({
    super.key,
    required this.controller,
    required Widget child,
  }) : super(child: child);

  static EngagementController? maybeOf(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<EngagementProvider>();
    return provider?.controller;
  }

  @override
  bool updateShouldNotify(EngagementProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}