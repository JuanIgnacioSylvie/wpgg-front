import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/presentation/wpgg_snackbar.dart';
import '../auth_strings.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_lexend_scope.dart';
import '../widgets/auth_screen_scaffold.dart';
import '../widgets/auth_underline_field.dart';
import '../widgets/wpgg_primary_button.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final AuthBloc _authBloc;
  StreamSubscription<AuthState>? _authSub;
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  var _obscurePassword = true;
  var _obscureConfirm = true;
  String? _token;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _authSub = _authBloc.stream.listen(_onAuthState);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = GoRouterState.of(context).uri.queryParameters['token'];
      if (token == null || token.trim().isEmpty) {
        if (!mounted) return;
        WpggSnackBar.show(
          context,
          AuthStrings.resetPasswordInvalidLink,
          isError: true,
        );
        context.go('/forgot-password');
        return;
      }
      setState(() => _token = token.trim());
    });
  }

  void _onAuthState(AuthState state) {
    if (!mounted) return;
    if (state is AuthPasswordResetCompleted) {
      WpggSnackBar.show(context, AuthStrings.resetPasswordSuccess);
      context.go('/login');
      return;
    }
    if (state is AuthError) {
      WpggSnackBar.show(context, state.message, isError: true);
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit(bool loading) {
    if (loading || _token == null) return;
    if (_password.text != _confirm.text) {
      WpggSnackBar.show(
        context,
        AuthStrings.passwordsMismatch,
        isError: true,
      );
      return;
    }
    _authBloc.add(
      PasswordResetConfirmRequested(
        token: _token!,
        password: _password.text,
      ),
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

  @override
  Widget build(BuildContext context) {
    final token = _token;
    return StreamBuilder<AuthState>(
      stream: _authBloc.stream,
      initialData: _authBloc.state,
      builder: (context, snapshot) {
        final loading = snapshot.data is AuthLoading;
        return AuthLexendScope(
          child: AuthScreenScaffold(
            child: AuthCard(
              child: token == null
                  ? const SizedBox(
                      height: 120,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          AuthStrings.resetPasswordTitle,
                          style: TextStyle(
                            fontFamily: AppFonts.lexendDeca,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AuthUiColors.cardText,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          AuthStrings.resetPasswordBody,
                          style: TextStyle(
                            fontFamily: AppFonts.lexendDeca,
                            fontSize: 14,
                            color: AuthUiColors.cardTextMuted,
                          ),
                        ),
                        const SizedBox(height: 28),
                        AuthUnderlineField(
                          controller: _password,
                          label: AuthStrings.labelPassword,
                          hint: AuthStrings.hintPassword,
                          obscureText: _obscurePassword,
                          prefixIcon: Icons.lock_outline,
                          suffix: _visibilityToggle(
                            _obscurePassword,
                            () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        AuthUnderlineField(
                          controller: _confirm,
                          label: AuthStrings.labelConfirmPassword,
                          hint: AuthStrings.hintConfirmPassword,
                          obscureText: _obscureConfirm,
                          prefixIcon: Icons.lock_outline,
                          suffix: _visibilityToggle(
                            _obscureConfirm,
                            () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        WpggPrimaryButton(
                          label: AuthStrings.buttonResetPassword,
                          isLoading: loading,
                          onPressed: loading ? null : () => _submit(loading),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: loading ? null : () => context.go('/login'),
                          style: TextButton.styleFrom(
                            foregroundColor: AuthUiColors.cardTextMuted,
                          ),
                          child: const Text(
                            AuthStrings.backToLogin,
                            style: TextStyle(fontFamily: AppFonts.lexendDeca),
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
