import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.darkPrimary,
          secondary: AppColors.darkAccent,
          surface: AppColors.darkSurface,
          error: AppColors.darkError,
        ),
        fontFamily: AppFonts.lexendDeca,
        textTheme: _buildTextTheme(
          AppColors.darkTextPrimary,
          AppColors.darkTextSecondary,
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.darkBorder, width: 1),
          ),
        ),
        dividerColor: AppColors.darkDivider,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkBackground,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'Wallpoet',
            fontSize: 20,
            color: AppColors.darkPrimary,
            letterSpacing: 4,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkPrimary,
            foregroundColor: AppColors.darkTextPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.darkPrimary,
            foregroundColor: AppColors.darkTextPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: AppColors.darkBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: AppColors.darkBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: AppColors.darkPrimary, width: 2),
          ),
          labelStyle: TextStyle(
            color: AppColors.darkTextSecondary,
            fontFamily: AppFonts.lexendDeca,
          ),
          hintStyle: TextStyle(
            color: AppColors.darkTextDisabled,
            fontFamily: AppFonts.lexendDeca,
          ),
        ),
      );

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.lightBackground,
        colorScheme: const ColorScheme.light(
          primary: AppColors.lightPrimary,
          secondary: AppColors.lightAccent,
          surface: AppColors.lightSurface,
          error: AppColors.lightError,
        ),
        fontFamily: AppFonts.lexendDeca,
        textTheme: _buildTextTheme(
          AppColors.lightTextPrimary,
          AppColors.lightTextSecondary,
        ),
        cardTheme: CardThemeData(
          color: AppColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.lightBorder, width: 1),
          ),
        ),
        dividerColor: AppColors.lightDivider,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightBackground,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'Wallpoet',
            fontSize: 20,
            color: AppColors.lightPrimary,
            letterSpacing: 4,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightPrimary,
            foregroundColor: AppColors.lightSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.lightPrimary,
            foregroundColor: AppColors.lightSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: AppColors.lightBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: AppColors.lightBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: AppColors.lightPrimary, width: 2),
          ),
          labelStyle: TextStyle(
            color: AppColors.lightTextSecondary,
            fontFamily: AppFonts.lexendDeca,
          ),
          hintStyle: TextStyle(
            color: AppColors.lightTextDisabled,
            fontFamily: AppFonts.lexendDeca,
          ),
        ),
      );

  static TextTheme _buildTextTheme(Color primary, Color secondary) => TextTheme(
        displayLarge: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          fontWeight: FontWeight.w900,
          color: primary,
        ),
        displayMedium: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          fontWeight: FontWeight.w800,
          color: primary,
        ),
        headlineLarge: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
        titleMedium: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          fontWeight: FontWeight.w400,
          color: primary,
        ),
        bodyMedium: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          fontWeight: FontWeight.w400,
          color: secondary,
        ),
        bodySmall: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          fontWeight: FontWeight.w400,
          color: secondary,
        ),
        labelLarge: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
        labelSmall: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          fontWeight: FontWeight.w300,
          color: secondary,
        ),
      );
}
