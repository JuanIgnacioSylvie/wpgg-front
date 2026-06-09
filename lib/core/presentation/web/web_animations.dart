import 'package:flutter/material.dart';

import 'web_motion.dart';

/// Fade + slight slide used for skeleton → content and card entrances.
class WebFadeSlideTransition extends StatelessWidget {
  const WebFadeSlideTransition({
    super.key,
    required this.animation,
    required this.child,
    this.slideOffset = WebMotion.slideOffset,
  });

  final Animation<double> animation;
  final Widget child;
  final double slideOffset;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: animation, curve: WebMotion.curve);

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, slideOffset),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

/// Wraps a child with enter (staggered) and optional exit animations.
class WebAnimatedAppear extends StatefulWidget {
  const WebAnimatedAppear({
    super.key,
    required this.child,
    this.staggerIndex = 0,
    this.removing = false,
  });

  final Widget child;
  final int staggerIndex;
  final bool removing;

  @override
  State<WebAnimatedAppear> createState() => _WebAnimatedAppearState();
}

class _WebAnimatedAppearState extends State<WebAnimatedAppear>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: WebMotion.normal,
    );
    _buildAnimations();
    _runEnter();
  }

  void _buildAnimations() {
    final curved = CurvedAnimation(parent: _controller, curve: WebMotion.curve);
    _fade = curved;
    _scale = Tween<double>(begin: WebMotion.scaleEnter, end: 1).animate(curved);
    _slide = Tween<Offset>(
      begin: const Offset(0, WebMotion.slideOffset),
      end: Offset.zero,
    ).animate(curved);
  }

  Future<void> _runEnter() async {
    if (widget.staggerIndex > 0) {
      await Future<void>.delayed(
        WebMotion.staggerStep * widget.staggerIndex,
      );
    }
    if (mounted && !widget.removing) {
      await _controller.forward();
    }
  }

  @override
  void didUpdateWidget(WebAnimatedAppear oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.removing && widget.removing) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Switches between [child] states with a shared fade + slide transition.
class WebAnimatedSwitcher extends StatelessWidget {
  const WebAnimatedSwitcher({
    super.key,
    required this.child,
    this.duration = WebMotion.normal,
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: WebMotion.curve,
      switchOutCurve: WebMotion.curve,
      transitionBuilder: (child, animation) {
        return WebFadeSlideTransition(animation: animation, child: child);
      },
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.topLeft,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: child,
    );
  }
}

class WebAnimatedProgressBar extends StatelessWidget {
  const WebAnimatedProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.backgroundColor,
    this.minHeight = 4,
  });

  final double value;
  final Color color;
  final Color? backgroundColor;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: minHeight,
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              color: backgroundColor,
            ),
            AnimatedFractionallySizedBox(
              duration: WebMotion.progress,
              curve: WebMotion.curve,
              widthFactor: value.clamp(0, 1),
              alignment: Alignment.centerLeft,
              child: Container(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedFractionallySizedBox extends ImplicitlyAnimatedWidget {
  const AnimatedFractionallySizedBox({
    super.key,
    required this.widthFactor,
    required this.alignment,
    required this.child,
    super.duration = WebMotion.progress,
    super.curve = WebMotion.curve,
  });

  final double widthFactor;
  final Alignment alignment;
  final Widget child;

  @override
  ImplicitlyAnimatedWidgetState<AnimatedFractionallySizedBox> createState() =>
      _AnimatedFractionallySizedBoxState();
}

class _AnimatedFractionallySizedBoxState
    extends AnimatedWidgetBaseState<AnimatedFractionallySizedBox> {
  Tween<double>? _widthFactor;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _widthFactor = visitor(
      _widthFactor,
      widget.widthFactor,
      (value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: _widthFactor?.evaluate(animation) ?? widget.widthFactor,
      alignment: widget.alignment,
      child: widget.child,
    );
  }
}

/// Modal with fade backdrop and scale entrance (Railway-style).
Future<T?> showWebDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    transitionDuration: WebMotion.normal,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return builder(dialogContext);
    },
    transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: WebMotion.curve,
      );

      return Stack(
        fit: StackFit.expand,
        children: [
          FadeTransition(
            opacity: curved,
            child: GestureDetector(
              onTap: barrierDismissible
                  ? () => Navigator.of(dialogContext).pop()
                  : null,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.black.withValues(alpha: 0.7),
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: WebMotion.scaleEnter,
                  end: 1,
                ).animate(curved),
                child: child,
              ),
            ),
          ),
        ],
      );
    },
  );
}
