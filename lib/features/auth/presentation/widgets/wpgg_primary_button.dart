import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';

/// Botón rojo con leve curvatura vertical en el centro (mockup).
class WpggPrimaryButton extends StatelessWidget {
  const WpggPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final color = enabled ? AuthUiColors.accentRed : AuthUiColors.cardTextMuted;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _WpggBulgeButtonPainter(color: color),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: _WpggBulgeBorder(),
              onTap: enabled ? onPressed : null,
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        label,
                        style: const TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WpggBulgeButtonPainter extends CustomPainter {
  _WpggBulgeButtonPainter({required this.color});

  final Color color;

  static Path bulgePath(Size size) {
    const bulge = 2.8;
    final w = size.width;
    final h = size.height;
    final r = h / 2;

    final path = Path();
    path.moveTo(r, 0);
    path.quadraticBezierTo(w * 0.5, -bulge, w - r, 0);
    path.arcToPoint(
      Offset(w - r, h),
      radius: Radius.circular(r),
      clockwise: true,
    );
    path.quadraticBezierTo(w * 0.5, h + bulge, r, h);
    path.arcToPoint(
      Offset(r, 0),
      radius: Radius.circular(r),
      clockwise: true,
    );
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = bulgePath(size);
    if (color == AuthUiColors.accentRed) {
      canvas.drawShadow(
        path,
        Colors.black.withValues(alpha: 0.22),
        5,
        true,
      );
    }
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _WpggBulgeButtonPainter old) =>
      old.color != color;
}

class _WpggBulgeBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      _WpggBulgeButtonPainter.bulgePath(rect.size);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      _WpggBulgeButtonPainter.bulgePath(rect.size);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
