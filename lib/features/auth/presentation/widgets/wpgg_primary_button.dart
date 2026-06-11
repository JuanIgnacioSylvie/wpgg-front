import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';
import '../../../../core/presentation/web/web_motion.dart';

/// Drop shadow Figma: X 0, Y 4, blur 4, spread 0, #000000 25%.
abstract final class WpggButtonShadow {
  static const Offset offset = Offset(0, 4);
  static const double blurRadius = 4;
  static const Color color = Color(0x40000000);

  /// Espacio extra bajo el botón para que no se recorte la sombra.
  static const double layoutPaddingBottom = 4;
}

void paintWpggBulgeDropShadow(Canvas canvas, Path path) {
  canvas.save();
  canvas.translate(WpggButtonShadow.offset.dx, WpggButtonShadow.offset.dy);
  canvas.drawPath(
    path,
    Paint()
      ..color = WpggButtonShadow.color
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        WpggButtonShadow.blurRadius,
      ),
  );
  canvas.restore();
}

/// Forma pill con leve curvatura (mockup WPGG). Compartida por botones primario y cancel.
Path wpggBulgeButtonPath(Size size) {
  const bulge = 2.2;
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

/// Botón primario default de la app (rojo sólido, texto blanco).
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

  static const double height = 44;

  static const TextStyle labelStyle = TextStyle(
    fontFamily: AppFonts.lexendDeca,
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final baseColor =
        enabled ? AuthUiColors.accentRed : AuthUiColors.cardTextMuted;
    final hoverColor = enabled
        ? Color.lerp(AuthUiColors.accentRed, Colors.black, 0.12)!
        : baseColor;

    return _WpggInteractiveBulgeButton(
      enabled: enabled,
      onPressed: enabled ? onPressed : null,
      baseColor: baseColor,
      hoverColor: hoverColor,
      drawShadow: enabled,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(label, style: labelStyle),
    );
  }
}

/// Botón cancel / secundario: misma forma que [WpggPrimaryButton], fondo blanco,
/// texto rojo default y borde rojo.
class WpggCancelButton extends StatelessWidget {
  const WpggCancelButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  static const TextStyle labelStyle = TextStyle(
    fontFamily: AppFonts.lexendDeca,
    color: AuthUiColors.accentRed,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final borderColor =
        enabled ? AuthUiColors.accentRed : AuthUiColors.cardTextMuted;

    return _WpggInteractiveBulgeButton(
      enabled: enabled,
      onPressed: onPressed,
      baseColor: Colors.white,
      hoverColor: const Color(0xFFF8F8F8),
      borderColor: borderColor,
      borderWidth: 1.5,
      drawShadow: enabled,
      child: Text(
        label,
        style: labelStyle.copyWith(
          color: enabled ? AuthUiColors.accentRed : AuthUiColors.cardTextMuted,
        ),
      ),
    );
  }
}

class _WpggInteractiveBulgeButton extends StatefulWidget {
  const _WpggInteractiveBulgeButton({
    required this.enabled,
    required this.onPressed,
    required this.baseColor,
    required this.hoverColor,
    required this.drawShadow,
    required this.child,
    this.borderColor,
    this.borderWidth = 0,
  });

  final bool enabled;
  final VoidCallback? onPressed;
  final Color baseColor;
  final Color hoverColor;
  final bool drawShadow;
  final Widget child;
  final Color? borderColor;
  final double borderWidth;

  @override
  State<_WpggInteractiveBulgeButton> createState() =>
      _WpggInteractiveBulgeButtonState();
}

class _WpggInteractiveBulgeButtonState extends State<_WpggInteractiveBulgeButton> {
  var _hovered = false;
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    final fillColor = !widget.enabled
        ? widget.baseColor
        : _pressed
            ? Color.lerp(widget.hoverColor, widget.baseColor, 0.5)!
            : _hovered
                ? widget.hoverColor
                : widget.baseColor;
    final scale = widget.enabled && _pressed ? 0.98 : 1.0;
    final duration = WebMotion.resolve(context, WebMotion.fast);

    return Padding(
      padding: const EdgeInsets.only(bottom: WpggButtonShadow.layoutPaddingBottom),
      child: MouseRegion(
        onEnter: widget.enabled ? (_) => setState(() => _hovered = true) : null,
        onExit: widget.enabled ? (_) => setState(() => _hovered = false) : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
          onTapUp: widget.enabled ? (_) => setState(() => _pressed = false) : null,
          onTapCancel: widget.enabled ? () => setState(() => _pressed = false) : null,
          onTap: widget.onPressed,
          child: AnimatedScale(
            scale: WebMotion.animationsEnabled(context) ? scale : 1,
            duration: duration,
            curve: WebMotion.curve,
            child: SizedBox(
              width: double.infinity,
              height: WpggPrimaryButton.height,
              child: CustomPaint(
                painter: _WpggFilledBulgePainter(
                  fillColor: fillColor,
                  borderColor: widget.borderColor,
                  borderWidth: widget.borderWidth,
                  drawShadow: widget.drawShadow,
                ),
                child: Center(child: widget.child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WpggFilledBulgePainter extends CustomPainter {
  _WpggFilledBulgePainter({
    required this.fillColor,
    this.borderColor,
    this.borderWidth = 0,
    this.drawShadow = false,
  });

  final Color fillColor;
  final Color? borderColor;
  final double borderWidth;
  final bool drawShadow;

  @override
  void paint(Canvas canvas, Size size) {
    final path = wpggBulgeButtonPath(size);
    if (drawShadow) {
      paintWpggBulgeDropShadow(canvas, path);
    }
    canvas.drawPath(path, Paint()..color = fillColor);
    if (borderColor != null && borderWidth > 0) {
      canvas.drawPath(
        path,
        Paint()
          ..color = borderColor!
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WpggFilledBulgePainter old) =>
      old.fillColor != fillColor ||
      old.borderColor != borderColor ||
      old.borderWidth != borderWidth ||
      old.drawShadow != drawShadow;
}
