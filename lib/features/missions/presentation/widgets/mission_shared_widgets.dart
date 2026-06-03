import 'package:flutter/material.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'mission_ui_helpers.dart';

class MissionDifficultyHeader extends StatelessWidget {
  const MissionDifficultyHeader({
    super.key,
    required this.difficulty,
    this.iconSize = 18,
    this.fontSize = 14,
  });

  final MissionDifficulty difficulty;
  final double iconSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final color = difficultyColor(difficulty);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(difficultyIcon(difficulty), size: iconSize, color: color),
        const SizedBox(width: 4),
        Text(
          difficultyLabel(difficulty),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}

class MissionDifficultyIconBox extends StatelessWidget {
  const MissionDifficultyIconBox({
    super.key,
    required this.difficulty,
    this.size = 40,
  });

  final MissionDifficulty difficulty;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = difficultyColor(difficulty);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        difficultyIcon(difficulty),
        color: color,
        size: size * 0.5,
      ),
    );
  }
}

class MissionRewardRow extends StatelessWidget {
  const MissionRewardRow({
    super.key,
    required this.amount,
    required this.color,
    this.underlined = false,
    this.fontSize = 14,
  });

  final int amount;
  final Color color;
  final bool underlined;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: color,
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      decoration: underlined ? TextDecoration.underline : null,
      decorationColor: color,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$amount', style: style),
        const SizedBox(width: 4),
        Image.asset(
          'assets/icons/wpgg-coin.png',
          width: fontSize + 2,
          height: fontSize + 2,
          errorBuilder: (_, __, ___) => Icon(
            Icons.toll,
            size: fontSize + 2,
            color: color,
          ),
        ),
      ],
    );
  }
}

class MissionLinearProgress extends StatelessWidget {
  const MissionLinearProgress({
    super.key,
    required this.percent,
    required this.color,
    this.height = 8,
  });

  final int percent;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final value = (percent.clamp(0, 100)) / 100;
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: SizedBox(
        height: height,
        child: LinearProgressIndicator(
          value: value,
          minHeight: height,
          backgroundColor: WpggBrand.white,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}

class MissionEndsInTooltip extends StatelessWidget {
  const MissionEndsInTooltip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: const Size(12, 6),
          painter: _TooltipArrowPainter(),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: WpggBrand.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _TooltipArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Highlights the word "day" / "día" in mission titles with difficulty color.
InlineSpan missionTitleSpans(
  String title, {
  required Color accent,
  TextStyle? baseStyle,
}) {
  final base = baseStyle ??
      const TextStyle(
        color: WpggBrand.primary,
        fontWeight: FontWeight.w600,
        fontSize: 15,
        height: 1.35,
      );
  const keywords = ['day', 'día', 'dia'];
  final lower = title.toLowerCase();
  var matchStart = -1;
  var matchLen = 0;
  for (final kw in keywords) {
    final i = lower.indexOf(kw);
    if (i >= 0) {
      matchStart = i;
      matchLen = kw.length;
      break;
    }
  }
  if (matchStart < 0) {
    return TextSpan(text: title, style: base);
  }
  final start = matchStart;
  final len = matchLen;
  return TextSpan(
    children: [
      TextSpan(text: title.substring(0, start), style: base),
      TextSpan(
        text: title.substring(start, start + len),
        style: base.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: accent,
        ),
      ),
      TextSpan(text: title.substring(start + len), style: base),
    ],
  );
}
