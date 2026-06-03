import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'mission_ui_helpers.dart';

class MissionDifficultyHeader extends StatelessWidget {
  const MissionDifficultyHeader({
    super.key,
    required this.difficulty,
    this.iconSize = 18,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w700,
    this.underlined = false,
  });

  final MissionDifficulty difficulty;
  final double iconSize;
  final double fontSize;
  final FontWeight fontWeight;
  final bool underlined;

  @override
  Widget build(BuildContext context) {
    final color = difficultyColor(difficulty);
    final l10n = context.l10n;
    final labelStyle = TextStyle(
      fontFamily: AppFonts.lexendDeca,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
      decoration: underlined ? TextDecoration.underline : null,
      decorationColor: color,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(difficultyIcon(difficulty), size: iconSize, color: color),
        const SizedBox(width: 4),
        Text(difficultyLabel(difficulty, l10n), style: labelStyle),
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
    this.coinSize = 24,
  });

  final int amount;
  final Color color;
  final bool underlined;
  final double fontSize;
  final double coinSize;

  static const String _coinAsset = 'assets/images/wpgg-coin_24x24.png';

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontFamily: AppFonts.lexendDeca,
      color: color,
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
    );
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('$amount', style: style),
        const SizedBox(width: 6),
        SizedBox(
          width: coinSize,
          height: coinSize,
          child: Image.asset(
            _coinAsset,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
            errorBuilder: (_, __, ___) => Icon(
              Icons.toll,
              size: coinSize,
              color: color,
            ),
          ),
        ),
      ],
    );

    if (!underlined) return content;

    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          content,
          const SizedBox(height: 2),
          Container(height: 2, color: color),
        ],
      ),
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
              fontFamily: AppFonts.lexendDeca,
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
