import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_public_config.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/presentation/web/turnstile_widget.dart';
import '../../../../core/presentation/web/web_motion.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/presentation/wpgg_snackbar.dart';
import '../../../riot/domain/usecases/get_summoner_profile_usecase.dart';
import '../auth_flow_mode.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_lexend_scope.dart';
import '../widgets/auth_screen_scaffold.dart';
import '../widgets/auth_switch_prompt.dart';
import '../widgets/auth_underline_field.dart';
import '../widgets/riot_account_already_exists_dialog.dart';
import '../widgets/riot_account_not_found_dialog.dart';
import '../widgets/riot_oauth_button.dart';
import '../widgets/wpgg_primary_button.dart';

/// Login y registro WPGG (card con Samira).
class AuthFlowPage extends StatefulWidget {
  const AuthFlowPage({
    super.key,
    required this.initialMode,
  });

  final AuthFlowMode initialMode;

  @override
  State<AuthFlowPage> createState() => _AuthFlowPageState();
}

class _AuthFlowPageState extends State<AuthFlowPage> {
  late AuthFlowMode _mode;
  late final AuthBloc _authBloc;
  StreamSubscription<AuthState>? _authSub;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  var _remember = false;
  var _obscurePassword = true;
  var _obscureConfirm = true;
  String? _turnstileToken;

  bool get _needsTurnstile =>
      _mode == AuthFlowMode.register && AppPublicConfig.turnstileEnabled;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _mode = widget.initialMode;
    _authSub = _authBloc.stream.listen(_onAuthState);
  }

  Future<void> _navigateAfterAuthenticated() async {
    final res = await sl<GetSummonerProfileUseCase>()();
    if (!mounted) return;
    final needsLink = res.fold((_) => false, (s) => s == null);
    context.go(needsLink ? '/auth/link-riot' : '/home');
  }

  void _onAuthState(AuthState state) {
    if (!mounted) return;
    if (state is AuthAuthenticated) {
      unawaited(_navigateAfterAuthenticated());
      return;
    }
    if (state is AuthRegistrationPendingVerification) {
      context.go(
        '/register/check-email?email=${Uri.encodeComponent(state.email)}',
      );
      return;
    }
    if (state is AuthRegisteredPendingRiotLink) {
      context.go('/auth/link-riot');
      return;
    }
    if (state is AuthRiotOAuthUserNotFound) {
      showRiotAccountNotFoundDialog(context);
      return;
    }
    if (state is AuthRiotOAuthUserAlreadyExists) {
      showRiotAccountAlreadyExistsDialog(context);
      return;
    }
    if (state is AuthError) {
      WpggSnackBar.show(context, context.localizeAuthError(state.message),
          isError: true);
      resetTurnstileWidget();
      setState(() => _turnstileToken = null);
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _goToMode(AuthFlowMode mode) {
    if (_mode == mode) return;
    setState(() => _mode = mode);
  }

  bool get _showConfirmPassword => _mode == AuthFlowMode.register;

  bool get _showRememberForgot => _mode == AuthFlowMode.login;

  bool get _showRiotFooter => _mode == AuthFlowMode.login;

  void _submit(bool loading) {
    if (loading) return;

    if (_mode == AuthFlowMode.login) {
      _authBloc.add(
        LoginRequested(
          email: _email.text.trim(),
          password: _password.text,
          rememberMe: _remember,
        ),
      );
      return;
    }

    if (_password.text != _confirm.text) {
      WpggSnackBar.show(context, context.l10n.authPasswordsMismatch,
          isError: true);
      return;
    }

    if (_needsTurnstile &&
        (_turnstileToken == null || _turnstileToken!.isEmpty)) {
      WpggSnackBar.show(context, context.l10n.authTurnstileRequired,
          isError: true);
      return;
    }

    _authBloc.add(
      RegisterRequested(
        email: _email.text.trim(),
        password: _password.text,
        turnstileToken: _turnstileToken,
        thenLinkRiot: true,
      ),
    );
  }

  Widget _header(AppLocalizations l10n) {
    switch (_mode) {
      case AuthFlowMode.register:
        return AuthSwitchPrompt(
          line1: l10n.authRegisterSwitchLine,
          linkPrefix: l10n.authSwitchLinkPrefix,
          linkText: l10n.authRegisterSwitchLink,
          onLinkTap: () => _goToMode(AuthFlowMode.login),
        );
      case AuthFlowMode.login:
        return AuthSwitchPrompt(
          line1: l10n.authLoginSwitchLine,
          linkPrefix: l10n.authSwitchLinkPrefix,
          linkText: l10n.authLoginSwitchLink,
          onLinkTap: () => _goToMode(AuthFlowMode.register),
        );
    }
  }

  Widget _form(AppLocalizations l10n, bool loading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthUnderlineField(
          controller: _email,
          label: l10n.authLabelEmail,
          hint: l10n.authHintEmail,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.mail_outline,
        ),
        const SizedBox(height: 20),
        AuthUnderlineField(
          controller: _password,
          label: l10n.authLabelPassword,
          hint: l10n.authHintPassword,
          obscureText: _obscurePassword,
          prefixIcon: Icons.lock_outline,
          suffix: _visibilityToggle(
            _obscurePassword,
            () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        AnimatedSize(
          duration: WebMotion.resolve(context, WebMotion.normal),
          curve: WebMotion.curve,
          alignment: Alignment.topCenter,
          child: _showConfirmPassword
              ? Column(
                  children: [
                    const SizedBox(height: 20),
                    AuthUnderlineField(
                      controller: _confirm,
                      label: l10n.authLabelConfirmPassword,
                      hint: l10n.authHintConfirmPassword,
                      obscureText: _obscureConfirm,
                      prefixIcon: Icons.lock_outline,
                      suffix: _visibilityToggle(
                        _obscureConfirm,
                        () => setState(
                          () => _obscureConfirm = !_obscureConfirm,
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        AnimatedSize(
          duration: WebMotion.resolve(context, WebMotion.normal),
          curve: WebMotion.curve,
          alignment: Alignment.topCenter,
          child: _showRememberForgot
              ? Column(
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: Checkbox(
                            value: _remember,
                            onChanged: (v) =>
                                setState(() => _remember = v ?? false),
                            activeColor: AuthUiColors.accentRed,
                            checkColor: Colors.white,
                            side: const BorderSide(
                              color: AuthUiColors.cardText,
                              width: 1.5,
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(l10n.authRememberMe, style: _labelStyle),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.go('/forgot-password'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: AuthUiColors.cardTextMuted,
                          ),
                          child: Text(
                            l10n.authForgotPassword,
                            style: TextStyle(
                              fontFamily: AppFonts.lexendDeca,
                              fontSize: 13,
                              color: AuthUiColors.cardTextMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        if (_needsTurnstile) ...[
          const SizedBox(height: 20),
          TurnstileWidget(
            siteKey: AppPublicConfig.turnstileSiteKey,
            onToken: (token) => setState(() => _turnstileToken = token),
            onExpired: () => setState(() => _turnstileToken = null),
            onError: () => setState(() => _turnstileToken = null),
          ),
        ],
        const SizedBox(height: 24),
        WpggPrimaryButton(
          label: _mode == AuthFlowMode.login
              ? l10n.authButtonLogin
              : l10n.authButtonRegister,
          isLoading: loading,
          onPressed: loading ? null : () => _submit(loading),
        ),
      ],
    );
  }

  static Widget _visibilityToggle(bool hidden, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: 20,
        color: AuthUiColors.cardText,
      ),
    );
  }

  static const _labelStyle = TextStyle(
    fontFamily: AppFonts.lexendDeca,
    color: AuthUiColors.cardText,
    fontSize: 13,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: _authBloc.stream,
      initialData: _authBloc.state,
      builder: (context, snapshot) {
        final loading = snapshot.data is AuthLoading;
        final l10n = context.l10n;
        return AuthLexendScope(
          child: AuthScreenScaffold(
            bottom: _showRiotFooter
                ? RiotOAuthFooter(
                    separatorText: l10n.authRiotFooter,
                    onRiotPressed: loading
                        ? null
                        : () => _authBloc.add(
                              const RiotRsoSignInRequested(
                                requestRedirect: true,
                              ),
                            ),
                  )
                : null,
            child: AuthCard(
              child: AnimatedSwitcher(
                duration: WebMotion.resolve(context, WebMotion.normal),
                switchInCurve: WebMotion.curve,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final curved = CurvedAnimation(
                    parent: animation,
                    curve: WebMotion.curve,
                  );
                  return FadeTransition(
                    opacity: curved,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.04),
                        end: Offset.zero,
                      ).animate(curved),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  key: ValueKey(_mode),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _header(l10n),
                    const SizedBox(height: 28),
                    _form(l10n, loading),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
