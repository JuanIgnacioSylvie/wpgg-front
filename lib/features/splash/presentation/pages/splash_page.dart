import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/presentation/web/web_motion.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../auth/domain/usecases/refresh_token_usecase.dart';
import '../../../riot/domain/usecases/get_summoner_profile_usecase.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  static const _fullText = 'WPGG';
  var _displayText = '';
  var _showCursor = true;
  var _exiting = false;
  Timer? _typeTimer;
  Timer? _cursorTimer;
  late final AnimationController _progressController;
  late final AnimationController _exitController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();

    _exitController = AnimationController(
      vsync: this,
      duration: WebMotion.splashExit,
    );

    var index = 0;
    _typeTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (!mounted) return;
      if (index < _fullText.length) {
        setState(() => _displayText = _fullText.substring(0, index + 1));
        index++;
      } else {
        timer.cancel();
        _cursorTimer?.cancel();
        Future<void>.delayed(const Duration(milliseconds: 400), () {
          if (mounted) setState(() => _showCursor = false);
        });
      }
    });

    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted || !_showCursor) return;
      setState(() => _showCursor = !_showCursor);
    });

    Future<void>.delayed(const Duration(milliseconds: 2800), _navigate);
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
    _typeTimer?.cancel();
    _cursorTimer?.cancel();
    _progressController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final border =
        isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final primary =
        isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    final exitAnim = CurvedAnimation(
      parent: _exitController,
      curve: WebMotion.curve,
    );

    return Scaffold(
      backgroundColor: bg,
      body: FadeTransition(
        opacity: _exiting
            ? Tween<double>(begin: 1, end: 0).animate(exitAnim)
            : const AlwaysStoppedAnimation(1),
        child: ScaleTransition(
          scale: _exiting
              ? Tween<double>(begin: 1, end: 0.96).animate(exitAnim)
              : const AlwaysStoppedAnimation(1),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _displayText,
                        style: AppTextStyles.wallpoetSplashPrimary(context),
                      ),
                      if (_showCursor)
                        TextSpan(
                          text: '|',
                          style: AppTextStyles.wallpoetSplashAccent(context),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: 160,
                  child: AnimatedBuilder(
                    animation: _progressController,
                    builder: (_, __) => LinearProgressIndicator(
                      value: _progressController.value,
                      backgroundColor: border,
                      valueColor: AlwaysStoppedAnimation<Color>(primary),
                      minHeight: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
