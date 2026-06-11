import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_motion.dart';

/// Protagonist WPGG coin with a mint-style entrance animation.
class LandingCoinHero extends StatefulWidget {
  const LandingCoinHero({super.key});

  @override
  State<LandingCoinHero> createState() => _LandingCoinHeroState();
}

class _LandingCoinHeroState extends State<LandingCoinHero>
    with TickerProviderStateMixin {
  static const _coinAsset = 'assets/images/wpgg-coin_512x512.png';

  late final AnimationController _entrance;
  late final AnimationController _idle;
  late final AnimationController _ring;

  late final Animation<double> _entranceScale;
  late final Animation<double> _entranceFlip;
  late final Animation<double> _entranceOpacity;
  late final Animation<double> _ringScale;
  late final Animation<double> _ringOpacity;

  @override
  void initState() {
    super.initState();

    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _idle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
    _ring = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    final entranceCurve = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0, 0.85, curve: Curves.elasticOut),
    );
    _entranceScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.15, end: 1.12), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 1.12, end: 1.0), weight: 30),
    ]).animate(entranceCurve);
    _entranceFlip = Tween<double>(begin: math.pi * 1.5, end: 0).animate(
      CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic),
    );
    _entranceOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entrance,
        curve: const Interval(0, 0.35, curve: Curves.easeOut),
      ),
    );

    _ringScale = Tween<double>(begin: 0.55, end: 1.65).animate(
      CurvedAnimation(parent: _ring, curve: Curves.easeOutCubic),
    );
    _ringOpacity = Tween<double>(begin: 0.55, end: 0).animate(
      CurvedAnimation(parent: _ring, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _runEntrance());
  }

  void _runEntrance() {
    if (!mounted) return;
    if (WebMotion.animationsEnabled(context)) {
      _entrance.forward();
      Future<void>.delayed(const Duration(milliseconds: 350), () {
        if (mounted) _ring.forward();
      });
    } else {
      _entrance.value = 1;
      _ring.value = 1;
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    _idle.dispose();
    _ring.dispose();
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
      animation: Listenable.merge([_entrance, _idle, _ring]),
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (animations)
                    Opacity(
                      opacity: _ringOpacity.value,
                      child: Transform.scale(
                        scale: _ringScale.value,
                        child: Container(
                          width: coinSize,
                          height: coinSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: WebColors.accent.withValues(alpha: 0.45),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Transform.translate(
                    offset: Offset(0, floatY),
                    child: Opacity(
                      opacity: _entranceOpacity.value,
                      child: Transform.scale(
                        scale: _entranceScale.value,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.0015)
                            ..rotateY(_entranceFlip.value),
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
                ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Opacity(
              opacity: _entranceOpacity.value,
              child: Column(
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
                    'Win · Play · Get Gold',
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
            ),
          ],
        );
      },
    );
  }
}
