import 'package:flutter/material.dart';

import '../../constants/app_fonts.dart';
import '../../l10n/l10n_extension.dart';
import '../web/web_colors.dart';

/// Generic unavailable / maintenance / 404 screen.
class UnavailablePage extends StatelessWidget {
  const UnavailablePage({
    super.key,
    this.embedded = false,
  });

  /// When true, renders without a full-screen scaffold (inside web shell).
  final bool embedded;

  static const _imagePath = 'assets/images/amumu_crying.png';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final content = _UnavailableContent(
      title: l10n.pageUnavailableTitle,
      body: l10n.pageUnavailableBody,
    );

    if (embedded) {
      return Center(child: content);
    }

    return Scaffold(
      backgroundColor: WebColors.background,
      body: Center(child: content),
    );
  }
}

class _UnavailableContent extends StatelessWidget {
  const _UnavailableContent({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              UnavailablePage._imagePath,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
            const SizedBox(height: 28),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: WebColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: WebColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
