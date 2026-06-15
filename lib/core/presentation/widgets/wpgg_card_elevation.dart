import 'package:flutter/material.dart';

enum WpggCardElevationVariant {
  light,
  dark,
}

/// Sombras y relieve 3D compartidos para tarjetas WPGG (efecto de sobresalir del fondo).
abstract final class WpggCardElevation {
  /// Espacio extra bajo la tarjeta para que no se recorte la sombra.
  static const double shadowPaddingBottom = 10;

  static List<BoxShadow> boxShadows({
    WpggCardElevationVariant variant = WpggCardElevationVariant.light,
    bool hovered = false,
    bool dragFeedback = false,
    Color? accentColor,
  }) {
    if (dragFeedback) {
      return [
        BoxShadow(
          color: Colors.black.withValues(
            alpha: variant == WpggCardElevationVariant.light ? 0.2 : 0.5,
          ),
          blurRadius: 24,
          offset: const Offset(0, 12),
          spreadRadius: 1,
        ),
        if (accentColor != null)
          BoxShadow(
            color: accentColor.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
      ];
    }

    final lift = hovered ? 1.2 : 1.0;
    final yMain = (hovered ? 10.0 : 6.0) * lift;
    final blurMain = (hovered ? 22.0 : 14.0) * lift;
    final alphaMain = switch (variant) {
      WpggCardElevationVariant.light => hovered ? 0.12 : 0.09,
      WpggCardElevationVariant.dark => hovered ? 0.55 : 0.38,
    };

    final shadows = <BoxShadow>[
      if (variant == WpggCardElevationVariant.light)
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 2,
          offset: Offset(0, 1.5 * lift),
        ),
      BoxShadow(
        color: Colors.black.withValues(alpha: alphaMain),
        blurRadius: blurMain,
        offset: Offset(0, yMain),
        spreadRadius: hovered ? 0.5 : 0,
      ),
      BoxShadow(
        color: Colors.black.withValues(
          alpha: variant == WpggCardElevationVariant.light ? 0.04 : 0.14,
        ),
        blurRadius: 28,
        offset: Offset(0, yMain + 6),
      ),
    ];

    if (accentColor != null) {
      shadows.add(
        BoxShadow(
          color: accentColor.withValues(alpha: hovered ? 0.2 : 0.12),
          blurRadius: hovered ? 18 : 12,
          offset: Offset(0, yMain * 0.65),
        ),
      );
    }

    return shadows;
  }

  static LinearGradient convexGradient(
    Color base, {
    WpggCardElevationVariant variant = WpggCardElevationVariant.light,
  }) {
    if (variant == WpggCardElevationVariant.dark) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(base, Colors.white, 0.07)!,
          base,
          Color.lerp(base, Colors.black, 0.14)!,
        ],
        stops: const [0.0, 0.5, 1.0],
      );
    }

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.lerp(base, Colors.white, 0.14)!,
        base,
        Color.lerp(base, Colors.black, 0.035)!,
      ],
      stops: const [0.0, 0.55, 1.0],
    );
  }

  static Border mergeHighlightBorder(
    Border base, {
    WpggCardElevationVariant variant = WpggCardElevationVariant.light,
  }) {
    final highlight = variant == WpggCardElevationVariant.light
        ? Colors.white.withValues(alpha: 0.75)
        : Colors.white.withValues(alpha: 0.14);
    final top = base.top;

    return Border(
      top: BorderSide(
        color: Color.alphaBlend(highlight.withValues(alpha: 0.45), top.color),
        width: top.width,
      ),
      left: base.left,
      right: base.right,
      bottom: base.bottom,
    );
  }

  static BoxDecoration enhance(
    BoxDecoration base, {
    WpggCardElevationVariant variant = WpggCardElevationVariant.light,
    bool hovered = false,
    bool dragFeedback = false,
    Color? accentColor,
    Color? baseColor,
    bool? useConvexGradient,
    bool? useHighlightBorder,
  }) {
    final isDark = variant == WpggCardElevationVariant.dark;
    final convex = useConvexGradient ?? !isDark;
    final highlightBorder = useHighlightBorder ?? !isDark;
    final color = baseColor ?? base.color;
    final gradient = base.gradient ??
        (convex && color != null
            ? convexGradient(color, variant: variant)
            : null);

    final border = base.border is Border && highlightBorder
        ? mergeHighlightBorder(base.border as Border, variant: variant)
        : base.border;

    final accentGlow = accentColor != null &&
        (variant == WpggCardElevationVariant.light || hovered || dragFeedback);

    return base.copyWith(
      color: gradient != null ? null : color,
      gradient: gradient ?? base.gradient,
      border: border,
      boxShadow: boxShadows(
        variant: variant,
        hovered: hovered,
        dragFeedback: dragFeedback,
        accentColor: accentGlow ? accentColor : null,
      ),
    );
  }
}
