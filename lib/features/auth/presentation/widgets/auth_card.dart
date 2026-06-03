import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/auth_ui_colors.dart';

/// Card blanca con ilustración Samira sobresaliendo arriba.
class AuthCard extends StatelessWidget {
  const AuthCard({
    super.key,
    required this.child,
    this.topPadding = 72,
  });

  final Widget child;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(top: topPadding * 0.55),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.fromLTRB(24, topPadding, 24, 28),
            decoration: BoxDecoration(
              color: AuthUiColors.cardBackground,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: child,
          ),
        ),
        Positioned(
          top: 0,
          child: Image.asset(
            AppAssets.samira,
            height: 140,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => const SizedBox(height: 140),
          ),
        ),
      ],
    );
  }
}
