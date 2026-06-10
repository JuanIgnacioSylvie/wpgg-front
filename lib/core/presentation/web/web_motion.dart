import 'package:flutter/material.dart';

/// Shared motion tokens for the web dashboard.
abstract final class WebMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration progress = Duration(milliseconds: 350);
  static const Duration staggerStep = Duration(milliseconds: 40);
  static const Duration theme = Duration(milliseconds: 300);
  static const Duration splashExit = Duration(milliseconds: 400);

  static const Curve curve = Curves.easeOutCubic;

  static const double slideOffset = 0.025;
  static const double shellSlideOffset = 0.03;
  static const double scaleEnter = 0.98;

  static bool animationsEnabled(BuildContext context) =>
      !MediaQuery.disableAnimationsOf(context);

  static Duration resolve(BuildContext context, Duration duration) =>
      animationsEnabled(context) ? duration : Duration.zero;
}
