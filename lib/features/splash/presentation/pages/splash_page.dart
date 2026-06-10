import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_dot_grid_background.dart';
import '../../../../core/presentation/web/web_motion.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../auth/domain/usecases/refresh_token_usecase.dart';
import '../../../riot/domain/usecases/get_summoner_profile_usecase.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  static const _coinAsset = 'assets/images/wpgg-coin_200x200.png';
  static const _loadDuration = Duration(milliseconds: 2800);
  static const _coinSize = 88.0;
  static const _progressWidth = 220.0;

  var _exiting = false;
  late final AnimationController _progressController;
  late final AnimationController _exitController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: _loadDuration,
    )..forward();

    _exitController = AnimationController(
      vsync: this,
      duration: WebMotion.splashExit,
    );

    Future<void>.delayed(_loadDuration, _navigate);
  }

  Future<void> _goAfterSession() async {
    final profile = await sl<GetSummonerProfileUseCase>()();
    if (!mounted) return;
    final needsLink = profile.fold((_) => false, (s) => s == null);
    await _navigateWithFade(needsLink ? '/auth/link-riot' : '/home');
  }

  Future<void> _navigateWithFade(String location) async {
    if (!mounted) return;
    if (!WebMotion.animationsEnabled(context)) {
      context.go(location);
      return;
    }
    setState(() => _exiting = true);
    await _exitController.forward();
    if (mounted) context.go(location);
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    final storage = sl<SecureStorage>();
    final token = await storage.getAccessToken();
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      await _goAfterSession();
      return;
    }
    final refreshed = await sl<RefreshTokenUseCase>()();
    if (!mounted) return;
    await refreshed.fold(
      (_) async {
        if (mounted) await _navigateWithFade('/login');
      },
      (_) => _goAfterSession(),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exitAnim = CurvedAnimation(
      parent: _exitController,
      curve: WebMotion.curve,
    );

    return Scaffold(
      backgroundColor: WebColors.background,
      body: WebDotGridBackground(
        child: FadeTransition(
          opacity: _exiting
              ? Tween<double>(begin: 1, end: 0).animate(exitAnim)
              : const AlwaysStoppedAnimation(1),
          child: ScaleTransition(
            scale: _exiting
                ? Tween<double>(
                    begin: 1,
                    end: WebMotion.scaleEnter,
                  ).animate(exitAnim)
                : const AlwaysStoppedAnimation(1),
            child: Center(
              child: WebAnimatedAppear(
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.fromLTRB(32, 40, 32, 36),
                  decoration: BoxDecoration(
                    color: WebColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: WebColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: WebColors.accent.withValues(alpha: 0.22),
                              blurRadius: 28,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          _coinAsset,
                          width: _coinSize,
                          height: _coinSize,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'WPGG',
                        style: TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: WebColors.textPrimary,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 36),
                      WebAnimatedAppear(
                        staggerIndex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SizedBox(
                            width: _progressWidth,
                            height: 4,
                            child: ColoredBox(
                              color: WebColors.border,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AnimatedBuilder(
                                  animation: _progressController,
                                  builder: (_, __) => FractionallySizedBox(
                                    widthFactor: _progressController.value,
                                    child: const ColoredBox(
                                      color: WebColors.accent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
