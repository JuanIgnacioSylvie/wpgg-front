import 'package:flutter/material.dart';

import '../constants/app_fonts.dart';
import '../constants/auth_ui_colors.dart';
import '../constants/wpgg_brand.dart';
import 'web/web_colors.dart';
import 'web/web_shell_scope.dart';

/// Full-screen blocking overlay shown while a server-side transaction runs.
abstract final class WpggTransactionOverlay {
  static OverlayEntry? _entry;

  static void show(BuildContext context, {required String message}) {
    hide();
    final isWeb = WebShellScope.isActive(context);
    _entry = OverlayEntry(
      builder: (overlayContext) => Material(
        color: Colors.black.withValues(alpha: 0.55),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isWeb ? WebColors.surfaceElevated : WpggBrand.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: isWeb
                    ? Border.all(color: WebColors.border)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: isWeb
                          ? WebColors.accent
                          : AuthUiColors.accentRed,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isWeb
                            ? WebColors.textPrimary
                            : WpggBrand.cardTextDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry?.dispose();
    _entry = null;
  }
}
