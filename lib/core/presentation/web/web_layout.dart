import 'package:flutter/material.dart';

abstract final class WebLayout {
  static const double mobileBreakpoint = 768;

  static bool isMobileLayout(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;
}
