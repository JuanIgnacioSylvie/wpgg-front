import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_dot_grid_background.dart';
import 'landing_language_menu.dart';

/// Full-page web layout for public content linked from the landing (terms, FAQs).
class PublicWebPageShell extends StatelessWidget {
  const PublicWebPageShell({
    super.key,
    required this.title,
    required this.child,
    this.backLocation = '/',
  });

  final String title;
  final Widget child;
  final String backLocation;

  @override
  Widget build(BuildContext context) {
    final maxContent = MediaQuery.sizeOf(context).width.clamp(0, 1080).toDouble();

    return Scaffold(
      backgroundColor: WebColors.background,
      body: WebDotGridBackground(
        child: Column(
          children: [
            Material(
              color: WebColors.topBar.withValues(alpha: 0.92),
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: WebColors.shellHeaderHeight,
                  child: Row(
                    children: [
                      IconButton(
                        tooltip:
                            MaterialLocalizations.of(context).backButtonTooltip,
                        onPressed: () => context.go(backLocation),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: WebColors.textSecondary,
                          size: 22,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontFamily: AppFonts.lexendDeca,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: WebColors.textPrimary,
                          ),
                        ),
                      ),
                      const LandingLanguageMenu(),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContent),
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
