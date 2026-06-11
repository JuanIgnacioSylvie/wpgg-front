import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
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
    this.borderRadius = 10,
  });

  final MissionDifficulty difficulty;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final color = difficultyColor(difficulty);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        difficultyIcon(difficulty),
        color: color,
        size: size * 0.5,
      ),
    );
  }
}

/// Leading icon for mission cards: welcome badge, champion portrait, or difficulty.
class MissionLeadingIcon extends StatelessWidget {
  const MissionLeadingIcon({
    super.key,
    required this.mission,
    this.size = 40,
    this.borderRadius = 10,
  });

  final MissionCardEntity mission;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final accent = missionAccentColor(mission);

    if (mission.isWelcome) {
      return _accentBox(
        accent: accent,
        child: Icon(Icons.redeem, color: accent, size: size * 0.5),
      );
    }

    final championId = mission.championId;
    if (championId != null && championId > 0) {
      final dd = context.watch<DDragonProvider>();
      final url = dd.championSquareUrl('', championId: championId);
      if (url.isNotEmpty) {
        return _accentBox(
          accent: accent,
          clipChild: true,
          child: CachedNetworkImage(
            imageUrl: url,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => Icon(
              difficultyIcon(mission.difficulty),
              color: accent,
              size: size * 0.5,
            ),
          ),
        );
      }
    }

    return MissionDifficultyIconBox(
      difficulty: mission.difficulty,
      size: size,
      borderRadius: borderRadius,
    );
  }

  Widget _accentBox({
    required Color accent,
    required Widget child,
    bool clipChild = false,
  }) {
    final radius = BorderRadius.circular(borderRadius);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: radius,
      ),
      clipBehavior: clipChild ? Clip.antiAlias : Clip.none,
      child: clipChild ? child : Center(child: child),
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
