import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';
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
import '../widgets/riot_oauth_button.dart';
import '../widgets/wpgg_primary_button.dart';

/// Pantalla única de auth: solo cambia [AuthFlowMode] (login, registro, sin cuenta, vincular Riot).
class AuthFlowPage extends StatefulWidget {
  const AuthFlowPage({
    super.key,
    required this.initialMode,
    this.riotLinkPendingCode,
  });

  final AuthFlowMode initialMode;
  final String? riotLinkPendingCode;

  @override
  State<AuthFlowPage> createState() => _AuthFlowPageState();
}

class _AuthFlowPageState extends State<AuthFlowPage> {
  late AuthFlowMode _mode;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  var _remember = false;
  var _obscurePassword = true;
  var _obscureConfirm = true;

  String? get _riotLinkPending =>
      widget.riotLinkPendingCode ??
      GoRouterState.of(context).uri.queryParameters['riot_link_pending'];

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _setMode(AuthFlowMode mode) {
    setState(() => _mode = mode);
  }

  bool get _showConfirmPassword =>
      _mode == AuthFlowMode.register || _mode == AuthFlowMode.riotNoAccount;

  bool get _showRememberForgot => _mode == AuthFlowMode.login;

  bool get _showRiotFooter => _mode == AuthFlowMode.login;

  bool get _isLinkOnly => _mode == AuthFlowMode.linkRiot;

  void _submit(bool loading) {
    if (loading) return;

    if (_mode == AuthFlowMode.login) {
      context.read<AuthBloc>().add(
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

    if (_mode == AuthFlowMode.riotNoAccount) {
      final pending = _riotLinkPending;
      if (pending == null || pending.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AuthStrings.riotLinkExpired)),
        );
        return;
      }
      context.read<AuthBloc>().add(
            RegisterRequested(
              email: _email.text.trim(),
              password: _password.text,
              riotLinkPendingCode: pending,
            ),
          );
      return;
    }

    context.read<AuthBloc>().add(
          RegisterRequested(
            email: _email.text.trim(),
            password: _password.text,
            thenLinkRiot: true,
          ),
        );
  }

  Widget _header() {
    switch (_mode) {
      case AuthFlowMode.riotNoAccount:
        return Column(
          children: [
            Text(
              AuthStrings.riotNoAccountTitle,
              textAlign: TextAlign.center,
              style: _titleStyle,
            ),
            const SizedBox(height: 10),
            Text(
              AuthStrings.riotNoAccountBody,
              textAlign: TextAlign.center,
              style: _bodyMutedStyle,
            ),
            const SizedBox(height: 20),
            AuthSwitchPrompt(
              line1: AuthStrings.registerSwitchLine,
              linkText: AuthStrings.registerSwitchLink,
              onLinkTap: () => _setMode(AuthFlowMode.login),
            ),
          ],
        );
      case AuthFlowMode.linkRiot:
        return Text(
          AuthStrings.linkRiotBody,
          textAlign: TextAlign.center,
          style: _bodyStyle,
        );
      case AuthFlowMode.register:
        return AuthSwitchPrompt(
          line1: AuthStrings.registerSwitchLine,
          linkText: AuthStrings.registerSwitchLink,
          onLinkTap: () => _setMode(AuthFlowMode.login),
        );
      case AuthFlowMode.login:
        return AuthSwitchPrompt(
          line1: AuthStrings.loginSwitchLine,
          linkText: AuthStrings.loginSwitchLink,
          onLinkTap: () => _setMode(AuthFlowMode.register),
        );
    }
  }

  Widget _form(bool loading) {
    if (_isLinkOnly) {
      return Center(
        child: loading
            ? const CircularProgressIndicator(color: AuthUiColors.accentRed)
            : RiotOAuthButton(
                size: 64,
                onPressed: () => context.read<AuthBloc>().add(
                      const RiotRsoLinkRequested(),
                    ),
              ),
      );
    }

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
                onPressed: () {},
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

  static const _titleStyle = TextStyle(
    fontFamily: AppFonts.lexendDeca,
    color: AuthUiColors.cardText,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const _bodyStyle = TextStyle(
    fontFamily: AppFonts.lexendDeca,
    color: AuthUiColors.cardText,
    fontSize: 15,
    height: 1.5,
    fontWeight: FontWeight.w500,
  );

  static const _bodyMutedStyle = TextStyle(
    fontFamily: AppFonts.lexendDeca,
    color: AuthUiColors.cardTextMuted,
    fontSize: 14,
    height: 1.4,
  );

  static const _labelStyle = TextStyle(
    fontFamily: AppFonts.lexendDeca,
    color: AuthUiColors.cardText,
    fontSize: 13,
  );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/home');
        }
        if (state is AuthRegisteredPendingRiotLink) {
          setState(() => _mode = AuthFlowMode.linkRiot);
        }
        if (state is AuthRiotRsoSignInLaunched) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                kIsWeb
                    ? 'Se abrió Riot. Al volver, deberías aterrizar en ${Uri.base.origin}${AppConstants.riotRsoWebSuccessPath}.'
                    : 'Se abrió la página de Riot.',
                style: const TextStyle(fontFamily: AppFonts.lexendDeca),
              ),
            ),
          );
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final loading = state is AuthLoading;
        return AuthLexendScope(
          child: AuthScreenScaffold(
            bottom: _showRiotFooter
                ? RiotOAuthFooter(
                    separatorText: AuthStrings.riotFooter,
                    onRiotPressed: loading
                        ? null
                        : () => context.read<AuthBloc>().add(
                              const RiotRsoSignInRequested(
                                requestRedirect: true,
                              ),
                            ),
                  )
                : null,
            child: Center(
              child: AuthCard(
                topPadding: _mode == AuthFlowMode.linkRiot ? 88 : 72,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _header(),
                    SizedBox(height: _isLinkOnly ? 32 : 28),
                    _form(loading),
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
