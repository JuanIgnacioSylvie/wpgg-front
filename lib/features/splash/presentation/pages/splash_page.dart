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
  static const _logoAsset = 'assets/icons/logo_w.png';
  static const _loadDuration = Duration(milliseconds: 2800);
  static const _logoSize = 72.0;
  static const _logoIconSize = 38.0;
  static const _progressWidth = 200.0;

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WebAnimatedAppear(
                    child: Container(
                      width: _logoSize,
                      height: _logoSize,
                      decoration: BoxDecoration(
                        color: WebColors.accent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: WebColors.accent.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          _logoAsset,
                          width: _logoIconSize,
                          height: _logoIconSize,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const WebAnimatedAppear(
                    staggerIndex: 1,
                    child: Text(
                      'WPGG',
                      style: TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: WebColors.textPrimary,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  WebAnimatedAppear(
                    staggerIndex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        width: _progressWidth,
                        height: 3,
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
    );
  }
}
