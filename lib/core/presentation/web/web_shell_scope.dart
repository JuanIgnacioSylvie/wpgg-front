import 'package:flutter/material.dart';

/// Marks descendants as rendered inside the web dashboard shell.
class WebShellScope extends InheritedWidget {
  const WebShellScope({
    super.key,
    required super.child,
    required this.onAddMission,
    this.onOpenSettings,
  });

  final VoidCallback onAddMission;
  final VoidCallback? onOpenSettings;

  static bool isActive(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WebShellScope>() != null;
  }

  static VoidCallback? addMissionHandler(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<WebShellScope>()
        ?.onAddMission;
  }

  static VoidCallback? openSettingsHandler(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<WebShellScope>()
        ?.onOpenSettings;
  }

  @override
  bool updateShouldNotify(WebShellScope oldWidget) =>
      onAddMission != oldWidget.onAddMission ||
      onOpenSettings != oldWidget.onOpenSettings;
}
