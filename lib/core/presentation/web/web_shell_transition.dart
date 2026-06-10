import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'web_motion.dart';

/// Fades and slides shell content when the navigation branch changes.
class WebShellBranchTransition extends StatefulWidget {
  const WebShellBranchTransition({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<WebShellBranchTransition> createState() =>
      _WebShellBranchTransitionState();
}

class _WebShellBranchTransitionState extends State<WebShellBranchTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  var _lastIndex = 0;
  var _slideDirection = 1.0;

  @override
  void initState() {
    super.initState();
    _lastIndex = widget.navigationShell.currentIndex;
    _controller = AnimationController(
      vsync: this,
      duration: WebMotion.normal,
    )..value = 1;
  }

  @override
  void didUpdateWidget(WebShellBranchTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newIndex = widget.navigationShell.currentIndex;
    if (newIndex != _lastIndex) {
      _slideDirection = newIndex > _lastIndex ? 1.0 : -1.0;
      _lastIndex = newIndex;
      final duration = WebMotion.resolve(context, WebMotion.normal);
      if (duration == Duration.zero) {
        _controller.value = 1;
      } else {
        _controller.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!WebMotion.animationsEnabled(context)) {
      return widget.navigationShell;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = WebMotion.curve.transform(_controller.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(_slideDirection * 12 * (1 - t), 0),
            child: child,
          ),
        );
      },
      child: widget.navigationShell,
    );
  }
}
