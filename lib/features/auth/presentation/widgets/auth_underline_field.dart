import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';

class AuthUnderlineField extends StatelessWidget {
  const AuthUnderlineField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffix,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffix;

  static const _fieldStyle = TextStyle(
    fontFamily: AppFonts.lexendDeca,
    color: AuthUiColors.cardText,
    fontSize: 14,
  );

  static const _labelStyle = TextStyle(
    fontFamily: AppFonts.lexendDeca,
    color: AuthUiColors.cardText,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        const SizedBox(height: 8),
        Row(
          children: [
            if (prefixIcon != null) ...[
              Icon(prefixIcon, size: 20, color: AuthUiColors.cardText),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                obscureText: obscureText,
                style: _fieldStyle,
                cursorColor: AuthUiColors.cardText,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: hint,
                  hintStyle: const TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    color: AuthUiColors.cardTextMuted,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (suffix != null) suffix!,
          ],
        ),
        const SizedBox(height: 6),
        const Divider(
          height: 1,
          thickness: 1,
          color: AuthUiColors.inputUnderline,
        ),
      ],
    );
  }
}
