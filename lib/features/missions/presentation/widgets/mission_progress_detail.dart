import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../domain/entities/mission_card_entity.dart';
import '../../domain/entities/mission_progress_line.dart';

class MissionProgressDetail extends StatelessWidget {
  const MissionProgressDetail({
    super.key,
    required this.mission,
    this.useWebStyle = false,
    this.fontSize = 11,
    this.accentColor,
    this.align = TextAlign.start,
  });

  final MissionCardEntity mission;
  final bool useWebStyle;
  final double fontSize;
  final Color? accentColor;
  final TextAlign align;

  static final _numberFormat = NumberFormat.decimalPattern();

  static String formatLine(MissionProgressLine line) {
    final current = _numberFormat.format(line.current);
    final target = _numberFormat.format(line.target);
    return '$current / $target';
  }

  @override
  Widget build(BuildContext context) {
    final lines = mission.progressLines;
    if (lines.isEmpty) {
      return Text(
        '${mission.progressPercent}%',
        textAlign: align,
        style: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          color: useWebStyle ? WebColors.textMuted : Colors.black45,
          fontSize: fontSize,
        ),
      );
    }

    final color = accentColor ??
        (useWebStyle ? WebColors.textSecondary : Colors.black54);

    if (lines.length == 1) {
      return Text(
        formatLine(lines.first),
        textAlign: align,
        style: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Column(
      crossAxisAlignment: align == TextAlign.end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        for (final line in lines)
          Text(
            formatLine(line),
            textAlign: align,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
      ],
    );
  }
}
