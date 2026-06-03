import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';

class RiotOAuthButton extends StatelessWidget {
  const RiotOAuthButton({
    super.key,
    required this.onPressed,
    this.size = 56,
  });

  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AuthUiColors.riotButtonRed,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Image.asset(
              AppAssets.riotIcon,
              width: size * 0.55,
              height: size * 0.55,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.sports_martial_arts,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RiotOAuthFooter extends StatelessWidget {
  const RiotOAuthFooter({
    super.key,
    required this.onRiotPressed,
    this.separatorText = 'or continue with',
  });

  final VoidCallback? onRiotPressed;
  final String separatorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          separatorText,
          style: const TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: AuthUiColors.footerText,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        RiotOAuthButton(onPressed: onRiotPressed),
      ],
    );
  }
}
