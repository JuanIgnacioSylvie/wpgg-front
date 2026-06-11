import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_public_config.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/turnstile_widget.dart';
import '../../../../core/presentation/wpgg_snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_lexend_scope.dart';
import '../widgets/auth_screen_scaffold.dart';
import '../widgets/wpgg_primary_button.dart';

class RegisterCheckEmailPage extends StatefulWidget {
  const RegisterCheckEmailPage({super.key, required this.email});

  final String email;

  @override
  State<RegisterCheckEmailPage> createState() => _RegisterCheckEmailPageState();
}

class _RegisterCheckEmailPageState extends State<RegisterCheckEmailPage> {
  late final AuthBloc _authBloc;
  StreamSubscription<AuthState>? _authSub;
  String? _turnstileToken;

  bool get _needsTurnstile => AppPublicConfig.turnstileEnabled;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _authSub = _authBloc.stream.listen(_onAuthState);
  }

  void _onAuthState(AuthState state) {
    if (!mounted) return;
    if (state is AuthVerificationEmailSent) {
      WpggSnackBar.show(context, context.l10n.authVerifyEmailResent);
      return;
    }
    if (state is AuthError) {
      WpggSnackBar.show(
        context,
        context.localizeAuthError(state.message),
        isError: true,
      );
      resetTurnstileWidget();
      setState(() => _turnstileToken = null);
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  void _resend(bool loading) {
    if (loading) return;
    if (_needsTurnstile &&
        (_turnstileToken == null || _turnstileToken!.isEmpty)) {
      WpggSnackBar.show(context, context.l10n.authTurnstileRequired,
          isError: true);
      return;
    }
    _authBloc.add(
      ResendVerificationEmailRequested(
        email: widget.email,
        turnstileToken: _turnstileToken,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return StreamBuilder<AuthState>(
      stream: _authBloc.stream,
      initialData: _authBloc.state,
      builder: (context, snapshot) {
        final loading = snapshot.data is AuthLoading;
        return AuthLexendScope(
          child: AuthScreenScaffold(
            child: AuthCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.authVerifyEmailTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AuthUiColors.cardText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.authVerifyEmailBody,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      fontSize: 14,
                      color: AuthUiColors.cardTextMuted,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.email,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AuthUiColors.cardText,
                    ),
                  ),
                  if (_needsTurnstile) ...[
                    const SizedBox(height: 20),
                    TurnstileWidget(
                      siteKey: AppPublicConfig.turnstileSiteKey,
                      onToken: (token) =>
                          setState(() => _turnstileToken = token),
                      onExpired: () => setState(() => _turnstileToken = null),
                      onError: () => setState(() => _turnstileToken = null),
                    ),
                  ],
                  const SizedBox(height: 24),
                  WpggPrimaryButton(
                    label: l10n.authButtonResendVerification,
                    isLoading: loading,
                    onPressed: loading ? null : () => _resend(loading),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: loading ? null : () => context.go('/login'),
                    child: Text(
                      l10n.authBackToLogin,
                      style: const TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        color: AuthUiColors.cardTextMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
