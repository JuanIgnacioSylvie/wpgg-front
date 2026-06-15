import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/auth_ui_colors.dart';
import '../../../../core/presentation/widgets/wpgg_card_elevation.dart';

/// Card blanca con ilustración Samira sobresaliendo arriba.
class AuthCard extends StatelessWidget {
  const AuthCard({
    super.key,
    required this.child,
  });

  final Widget child;

  /// Altura de la ilustración (sobresale del borde superior).
  static const double heroImageHeight = 162;

  /// Desplazamiento vertical de la card respecto al stack.
  static const double cardOffsetTop = 70;

  /// Padding superior interno: el texto empieza debajo de la ilustración.
  static const double contentTopPadding = 92;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: cardOffsetTop),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.fromLTRB(24, contentTopPadding, 24, 28),
            decoration: WpggCardElevation.enhance(
              BoxDecoration(
                color: AuthUiColors.cardBackground,
                borderRadius: BorderRadius.circular(24),
              ),
              baseColor: AuthUiColors.cardBackground,
            ),
            child: child,
          ),
        ),
        Positioned(
          top: 0,
          child: Image.asset(
            AppAssets.samira,
            height: heroImageHeight,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) =>
                const SizedBox(height: heroImageHeight),
          ),
        ),
      ],
    );
  }
}
