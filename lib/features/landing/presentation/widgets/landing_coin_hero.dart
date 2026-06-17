import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_motion.dart';

/// Protagonist WPGG coin with a gentle idle bounce.
class LandingCoinHero extends StatefulWidget {
  const LandingCoinHero({super.key});

  @override
  State<LandingCoinHero> createState() => _LandingCoinHeroState();
}

class _LandingCoinHeroState extends State<LandingCoinHero>
    with SingleTickerProviderStateMixin {
  static const _coinAsset = 'assets/images/wpgg-coin_512x512.png';

  late final AnimationController _idle;

  @override
  void initState() {
    super.initState();
    _idle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _idle.dispose();
    super.dispose();
  }

  double _coinSize(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1200) return 280;
    if (w >= 900) return 240;
    if (w >= 600) return 200;
    return 168;
  }

  @override
  Widget build(BuildContext context) {
    final coinSize = _coinSize(context);
    final animations = WebMotion.animationsEnabled(context);

    return AnimatedBuilder(
      animation: _idle,
      builder: (context, _) {
        final floatY = animations ? (_idle.value - 0.5) * 18 : 0.0;
        final glowAlpha = animations
            ? 0.18 + (_idle.value * 0.14)
            : 0.22;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: coinSize * 1.8,
              height: coinSize * 1.35,
              child: Center(
                child: Transform.translate(
                  offset: Offset(0, floatY),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: WebColors.accent.withValues(
                            alpha: glowAlpha,
                          ),
                          blurRadius: 48 + (animations ? _idle.value * 24 : 0),
                          spreadRadius: 6,
                        ),
                        BoxShadow(
                          color: const Color(0xFFE8A317).withValues(
                            alpha: glowAlpha * 0.6,
                          ),
                          blurRadius: 32,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      _coinAsset,
                      width: coinSize,
                      height: coinSize,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Column(
              children: [
                Text(
                  'WPGG',
                  style: TextStyle(
                    fontFamily: AppFonts.wallpoet,
                    fontSize: coinSize * 0.22,
                    color: WebColors.textPrimary,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  WpggBrand.taglineDisplay,
                  style: TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: WebColors.textSecondary,
                    letterSpacing: 2.5,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
