import 'package:flutter/material.dart';

import '../constants/app_fonts.dart';
import '../constants/auth_ui_colors.dart';
/// Branded floating snackbar with a subtle slide + fade entrance.
abstract final class WpggSnackBar {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor:
            isError ? AuthUiColors.accentRed : const Color(0xFF2A2A35),
        elevation: 8,
        dismissDirection: DismissDirection.up,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
