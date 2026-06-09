import 'package:flutter/material.dart';

/// Shared motion tokens for the web dashboard.
abstract final class WebMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration progress = Duration(milliseconds: 350);
  static const Duration staggerStep = Duration(milliseconds: 40);

  static const Curve curve = Curves.easeOutCubic;

  static const double slideOffset = 0.025;
  static const double scaleEnter = 0.98;
}
