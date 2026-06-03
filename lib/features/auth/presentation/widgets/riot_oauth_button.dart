import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';

/// Icono Riot para OAuth (la imagen ya incluye el círculo rojo; sin contenedor extra).
class RiotOAuthButton extends StatelessWidget {
  const RiotOAuthButton({
    super.key,
    required this.onPressed,
    this.size = 64,
  });

  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size * 0.2),
        ),
        child: Image.asset(
          AppAssets.riotIcon,
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.sports_martial_arts,
            size: size * 0.5,
            color: AuthUiColors.riotButtonRed,
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
