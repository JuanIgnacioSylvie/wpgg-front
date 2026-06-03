import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';

/// Aísla tipografía y colores del auth del [Theme] global (evita tintes azul/morado).
class AuthLexendScope extends StatelessWidget {
  const AuthLexendScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final lexendTextTheme = base.textTheme.apply(
      fontFamily: AppFonts.lexendDeca,
      bodyColor: AuthUiColors.cardText,
      displayColor: AuthUiColors.cardText,
    );

    return Theme(
      data: base.copyWith(
        textTheme: lexendTextTheme,
        colorScheme: base.colorScheme.copyWith(
          primary: AuthUiColors.accentRed,
          onPrimary: Colors.white,
          onSurface: AuthUiColors.cardText,
          surface: AuthUiColors.cardBackground,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AuthUiColors.cardText,
          selectionColor: Color(0x331A1A1A),
          selectionHandleColor: AuthUiColors.cardText,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: false,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintStyle: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: AuthUiColors.cardTextMuted,
            fontSize: 14,
          ),
        ),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontFamily: AppFonts.lexendDeca,
          color: AuthUiColors.cardText,
        ),
        child: child,
      ),
    );
  }
}
