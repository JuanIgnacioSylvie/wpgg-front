import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Estilos Wallpoet para logo / splash. El cuerpo usa `Theme.of(context).textTheme` (Mont).
abstract final class AppTextStyles {
  static TextStyle wallpoetLogo(BuildContext context, {double fontSize = 36}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    return TextStyle(
      fontFamily: 'Wallpoet',
      fontSize: fontSize,
      color: color,
      letterSpacing: 4,
    );
  }

  static TextStyle wallpoetSplashPrimary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: 'Wallpoet',
      fontSize: 64,
      color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
      letterSpacing: 8,
    );
  }

  static TextStyle wallpoetSplashAccent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent =
        isDark ? AppColors.darkAccent : AppColors.lightAccent;
    return TextStyle(
      fontFamily: 'Wallpoet',
      fontSize: 64,
      color: accent.withValues(alpha: 0.8),
    );
  }
}
