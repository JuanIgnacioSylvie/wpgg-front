import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';

class MissionProgressRing extends StatelessWidget {
  const MissionProgressRing({
    super.key,
    required this.percent,
    required this.color,
    this.size = 64,
    this.strokeWidth = 6,
  });

  final int percent;
  final Color color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final value = (percent.clamp(0, 100)) / 100;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 8,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: strokeWidth,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Text(
            '$percent%',
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: size * 0.22,
            ),
          ),
        ],
      ),
    );
  }
}
