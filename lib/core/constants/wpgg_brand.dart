import 'package:flutter/material.dart';

/// WPGG brand palette from product design.
abstract final class WpggBrand {
  static const Color primary = Color(0xFFAD1F0F);
  static const Color primaryDark = Color(0xFF8A180C);
  static const Color white = Color(0xFFFFFFFF);
  static const Color scaffoldTop = Color(0xFF0A0A0C);
  static const Color scaffoldBottom = Color(0xFF0F1A18);
  static const Color navBar = Color(0xFFF3EEF5);
  static const Color easyAccent = Color(0xFF27C840);
  static const Color mediumAccent = Color(0xFFFF8D28);
  static const Color hardAccent = Color(0xFFFF383C);
  static const Color missionSecondaryBg = Color(0xFFEBF5FF);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFF5F5F7);
  static const Color textMuted = Color(0xFFB8B5C3);
  static const Color incomeGreen = Color(0xFF22C55E);
  static const Color expenseRed = Color(0xFFEF476F);

  static const LinearGradient scaffoldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [scaffoldTop, scaffoldBottom],
  );
}
