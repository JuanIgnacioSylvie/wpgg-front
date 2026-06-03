import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';

class AuthSwitchPrompt extends StatelessWidget {
  const AuthSwitchPrompt({
    super.key,
    required this.line1,
    required this.linkText,
    required this.onLinkTap,
  });

  final String line1;
  final String linkText;
  final VoidCallback onLinkTap;

  static const _baseStyle = TextStyle(
    fontFamily: AppFonts.lexendDeca,
    color: AuthUiColors.cardText,
    fontSize: 14,
    height: 1.45,
  );

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: _baseStyle,
        children: [
          TextSpan(text: '$line1\nPodés '),
          TextSpan(
            text: linkText,
            style: const TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: AuthUiColors.accentRed,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()..onTap = onLinkTap,
          ),
        ],
      ),
    );
  }
}
