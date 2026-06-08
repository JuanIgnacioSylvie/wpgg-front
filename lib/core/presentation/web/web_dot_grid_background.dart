import 'package:flutter/material.dart';

import 'web_colors.dart';

class WebDotGridBackground extends StatelessWidget {
  const WebDotGridBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _DotGridPainter(),
      child: child,
    );
  }
}

class _DotGridPainter extends CustomPainter {
  const _DotGridPainter();

  static const _spacing = 24.0;
  static const _dotRadius = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = WebColors.background,
    );

    final paint = Paint()..color = WebColors.dotGrid.withValues(alpha: 0.35);
    for (var x = 0.0; x < size.width; x += _spacing) {
      for (var y = 0.0; y < size.height; y += _spacing) {
        canvas.drawCircle(Offset(x, y), _dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
