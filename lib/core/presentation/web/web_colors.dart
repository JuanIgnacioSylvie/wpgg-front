import 'package:flutter/material.dart';

/// Railway-inspired palette for the web dashboard shell.
abstract final class WebColors {
  static const Color background = Color(0xFF0B0B0F);
  static const Color surface = Color(0xFF141419);
  static const Color surfaceElevated = Color(0xFF1C1C24);
  static const Color border = Color(0xFF2A2A35);
  static const Color borderSubtle = Color(0xFF1F1F28);
  static const Color textPrimary = Color(0xFFF4F4F5);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color dotGrid = Color(0xFF2A2A35);
  static const Color accent = Color(0xFFAD1F0F);
  static const Color accentHover = Color(0xFFC42818);
  static const Color online = Color(0xFF22C55E);
  static const Color sidebarHover = Color(0xFF1A1A22);
  static const Color topBar = Color(0xFF0E0E13);

  /// Altura compartida del logo en sidebar y de [WebTopBar].
  static const double shellHeaderHeight = 48;
}
