import 'package:flutter/material.dart';

import '../../constants/app_fonts.dart';
import '../../constants/wpgg_brand.dart';
import '../../utils/riot_region_label.dart';
import '../web/web_colors.dart';

/// Label for the Riot platform region (e.g. LA2, BR1).
class WpggServerTag extends StatelessWidget {
  const WpggServerTag({
    super.key,
    required this.region,
    this.useWebStyle = false,
  });

  final String region;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final label = formatRiotServerLabel(region);
    if (label.isEmpty) return const SizedBox.shrink();

    if (useWebStyle) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: WebColors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: WebColors.border),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: WebColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      );
    }

    return Text(
      label,
      style: const TextStyle(
        fontFamily: AppFonts.lexendDeca,
        color: WpggBrand.textMuted,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
    );
  }
}
