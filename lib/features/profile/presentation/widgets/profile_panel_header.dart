import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/presentation/web/web_colors.dart';

class ProfilePanelHeader extends StatelessWidget {
  const ProfilePanelHeader({
    super.key,
    required this.title,
    this.onBack,
    this.onClose,
    this.useWebStyle = false,
  });

  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final titleColor =
        useWebStyle ? WebColors.textPrimary : WpggBrand.cardTextDark;
    final iconColor =
        useWebStyle ? WebColors.textSecondary : WpggBrand.cardTextDark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              onPressed: onBack,
              icon: Icon(Icons.arrow_back, color: iconColor),
            )
          else
            const SizedBox(width: 48),
          Expanded(
            child: Text(
              title,
              textAlign: onClose == null ? TextAlign.center : TextAlign.start,
              style: TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: titleColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (onClose != null)
            IconButton(
              onPressed: onClose,
              icon: Icon(Icons.close, color: iconColor),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}
