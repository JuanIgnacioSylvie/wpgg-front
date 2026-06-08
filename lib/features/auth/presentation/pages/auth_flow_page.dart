import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';
import '../../../riot/domain/usecases/get_summoner_profile_usecase.dart';
import '../auth_flow_mode.dart';
import '../auth_strings.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
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
    if (mode == AuthFlowMode.login) {
      context.go('/login');
    } else {
      context.go('/register');
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AuthStrings.passwordsMismatch)),
      );
      return;
    }

    _authBloc.add(
      RegisterRequested(
        email: _email.text.trim(),
        password: _password.text,
        thenLinkRiot: true,
      ),
    );
  }

  Widget _header() {
    switch (_mode) {
      case AuthFlowMode.register:
        return AuthSwitchPrompt(
          line1: AuthStrings.registerSwitchLine,
          linkText: AuthStrings.registerSwitchLink,
          onLinkTap: () => _goToMode(AuthFlowMode.login),
        );
      case AuthFlowMode.login:
        return AuthSwitchPrompt(
          line1: AuthStrings.loginSwitchLine,
          linkText: AuthStrings.loginSwitchLink,
          onLinkTap: () => _goToMode(AuthFlowMode.register),
        );
    }
  }

  Widget _form(bool loading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthUnderlineField(
          controller: _email,
          label: AuthStrings.labelEmail,
          hint: AuthStrings.hintEmail,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.mail_outline,
        ),
        const SizedBox(height: 20),
        AuthUnderlineField(
          controller: _password,
          label: AuthStrings.labelPassword,
          hint: AuthStrings.hintPassword,
          obscureText: _obscurePassword,
          prefixIcon: Icons.lock_outline,
          suffix: _visibilityToggle(
            _obscurePassword,
            () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        if (_showConfirmPassword) ...[
          const SizedBox(height: 20),
          AuthUnderlineField(
            controller: _confirm,
            label: AuthStrings.labelConfirmPassword,
            hint: AuthStrings.hintConfirmPassword,
            obscureText: _obscureConfirm,
            prefixIcon: Icons.lock_outline,
            suffix: _visibilityToggle(
              _obscureConfirm,
              () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
        ],
        if (_showRememberForgot) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: Checkbox(
                  value: _remember,
                  onChanged: (v) => setState(() => _remember = v ?? false),
                  activeColor: AuthUiColors.accentRed,
                  checkColor: Colors.white,
                  side: const BorderSide(
                    color: AuthUiColors.cardText,
                    width: 1.5,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 8),
              const Text(AuthStrings.rememberMe, style: _labelStyle),
              const Spacer(),
              TextButton(
                onPressed: () => context.go('/forgot-password'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: AuthUiColors.cardTextMuted,
                ),
                child: const Text(
                  AuthStrings.forgotPassword,
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
        const SizedBox(height: 24),
        WpggPrimaryButton(
          label: _mode == AuthFlowMode.login
              ? AuthStrings.buttonLogin
              : AuthStrings.buttonRegister,
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
        return AuthLexendScope(
          child: AuthScreenScaffold(
            bottom: _showRiotFooter
                ? RiotOAuthFooter(
                    separatorText: AuthStrings.riotFooter,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _header(),
                  const SizedBox(height: 28),
                  _form(loading),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
