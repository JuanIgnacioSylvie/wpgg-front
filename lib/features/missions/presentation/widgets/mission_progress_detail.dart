import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../domain/entities/mission_card_entity.dart';
import '../../domain/entities/mission_progress_line.dart';

class MissionProgressDetail extends StatelessWidget {
  const MissionProgressDetail({
    super.key,
    required this.mission,
    this.useWebStyle = false,
    this.showBars = false,
    this.fontSize = 11,
    this.barHeight = 6,
    this.accentColor,
    this.align = TextAlign.start,
  });

  final MissionCardEntity mission;
  final bool useWebStyle;
  final bool showBars;
  final double fontSize;
  final double barHeight;
  final Color? accentColor;
  final TextAlign align;

  static final _numberFormat = NumberFormat.decimalPattern();

  static String formatLine(MissionProgressLine line) {
    final current = _numberFormat.format(line.current);
    final target = _numberFormat.format(line.target);
    return '$current / $target';
  }

  static double lineFraction(MissionProgressLine line) {
    if (line.target <= 0) return 0;
    return (line.current / line.target).clamp(0.0, 1.0);
  }

  static int linePercent(MissionProgressLine line) {
    if (line.target <= 0) return 0;
    return ((line.current * 100) / line.target).round().clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    if (showBars) {
      return _MissionProgressBars(
        mission: mission,
        useWebStyle: useWebStyle,
        fontSize: fontSize,
        barHeight: barHeight,
        accentColor: accentColor,
        align: align,
      );
    }

    return _MissionProgressLabels(
      mission: mission,
      useWebStyle: useWebStyle,
      fontSize: fontSize,
      accentColor: accentColor,
      align: align,
    );
  }
}

class _MissionProgressBars extends StatelessWidget {
  const _MissionProgressBars({
    required this.mission,
    required this.useWebStyle,
    required this.fontSize,
    required this.barHeight,
    required this.accentColor,
    required this.align,
  });

  final MissionCardEntity mission;
  final bool useWebStyle;
  final double fontSize;
  final double barHeight;
  final Color? accentColor;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final color = accentColor ??
        (useWebStyle ? WebColors.textSecondary : Colors.black54);
    final lines = mission.progressLines;

    if (lines.isEmpty) {
      return _MissionProgressBarRow(
        fraction: mission.progressPercent / 100,
        label: '${mission.progressPercent}%',
        useWebStyle: useWebStyle,
        fontSize: fontSize,
        barHeight: barHeight,
        color: color,
        align: align,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < lines.length; i++) ...[
          if (i > 0) SizedBox(height: lines.length > 2 ? 10 : 8),
          _MissionProgressBarRow(
            fraction: MissionProgressDetail.lineFraction(lines[i]),
            label: MissionProgressDetail.formatLine(lines[i]),
            useWebStyle: useWebStyle,
            fontSize: fontSize,
            barHeight: barHeight,
            color: color,
            align: align,
          ),
        ],
      ],
    );
  }
}

class _MissionProgressBarRow extends StatelessWidget {
  const _MissionProgressBarRow({
    required this.fraction,
    required this.label,
    required this.useWebStyle,
    required this.fontSize,
    required this.barHeight,
    required this.color,
    required this.align,
  });

  final double fraction;
  final String label;
  final bool useWebStyle;
  final double fontSize;
  final double barHeight;
  final Color color;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (useWebStyle)
          WebAnimatedProgressBar(
            value: fraction,
            color: color,
            backgroundColor: WebColors.border,
            minHeight: barHeight,
          )
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(barHeight),
            child: SizedBox(
              height: barHeight,
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: barHeight,
                backgroundColor: WpggBrand.white,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: align,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MissionProgressLabels extends StatelessWidget {
  const _MissionProgressLabels({
    required this.mission,
    required this.useWebStyle,
    required this.fontSize,
    required this.accentColor,
    required this.align,
  });

  final MissionCardEntity mission;
  final bool useWebStyle;
  final double fontSize;
  final Color? accentColor;
  final TextAlign align;

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
        MissionProgressDetail.formatLine(lines.first),
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
            MissionProgressDetail.formatLine(line),
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
