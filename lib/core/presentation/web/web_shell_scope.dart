import 'package:flutter/material.dart';

/// Marks descendants as rendered inside the web dashboard shell.
class WebShellScope extends InheritedWidget {
  const WebShellScope({
    super.key,
    required super.child,
    required this.onAddMission,
  });

  final VoidCallback onAddMission;

  static bool isActive(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WebShellScope>() != null;
  }

  static VoidCallback? addMissionHandler(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<WebShellScope>()
        ?.onAddMission;
  }

  @override
  bool updateShouldNotify(WebShellScope oldWidget) =>
      onAddMission != oldWidget.onAddMission;
}
