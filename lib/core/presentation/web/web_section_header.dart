import 'package:flutter/material.dart';

import '../../constants/app_fonts.dart';
import 'web_animations.dart';
import 'web_colors.dart';

class WebSectionHeader extends StatelessWidget {
  const WebSectionHeader({
    super.key,
    required this.title,
    this.count,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final int? count;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: WebColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: WebColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: WebColors.border),
                ),
                child: WebAnimatedNumber(
                  value: count!,
                  style: const TextStyle(
                    color: WebColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing!,
            ],
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: const TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: WebColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
