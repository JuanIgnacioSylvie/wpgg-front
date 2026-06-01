import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../auth/domain/usecases/refresh_token_usecase.dart';

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
  Timer? _typeTimer;
  Timer? _cursorTimer;
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();

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

  Future<void> _navigate() async {
    if (!mounted) return;
    final storage = sl<SecureStorage>();
    final token = await storage.getAccessToken();
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      context.go('/home');
      return;
    }
    final refreshed = await sl<RefreshTokenUseCase>()();
    if (!mounted) return;
    refreshed.fold(
      (_) => context.go('/login'),
      (_) => context.go('/home'),
    );
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _cursorTimer?.cancel();
    _progressController.dispose();
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

    return Scaffold(
      backgroundColor: bg,
      body: Center(
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
    );
  }
}
