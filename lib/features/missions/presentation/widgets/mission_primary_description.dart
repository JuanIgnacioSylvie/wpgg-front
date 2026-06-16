import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';

/// Mission title on the primary card (top-right).
class MissionPrimaryDescription extends StatelessWidget {
  const MissionPrimaryDescription({
    super.key,
    required this.title,
    required this.accent,
  });

  final String title;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: AppFonts.lexendDeca,
        color: WpggBrand.primary,
        fontWeight: FontWeight.w600,
        fontSize: 19,
        height: 1.35,
      ),
    );
  }
}
