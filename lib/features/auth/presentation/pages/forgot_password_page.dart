import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/wpgg_snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_lexend_scope.dart';
import '../widgets/auth_screen_scaffold.dart';
import '../widgets/auth_underline_field.dart';
import '../widgets/wpgg_primary_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final AuthBloc _authBloc;
  StreamSubscription<AuthState>? _authSub;
  final _email = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _authSub = _authBloc.stream.listen(_onAuthState);
  }

  void _onAuthState(AuthState state) {
    if (!mounted) return;
    if (state is AuthPasswordResetEmailSent) {
      WpggSnackBar.show(context, context.l10n.authForgotPasswordSuccess);
      context.go('/login');
      return;
    }
    if (state is AuthError) {
      WpggSnackBar.show(
        context,
        context.localizeAuthError(state.message),
        isError: true,
      );
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _email.dispose();
    super.dispose();
  }

  void _submit(bool loading) {
    if (loading) return;
    _authBloc.add(PasswordResetRequested(email: _email.text.trim()));
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
                    l10n.authForgotPassword,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AuthUiColors.cardText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.authForgotPasswordBody,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      fontSize: 14,
                      color: AuthUiColors.cardTextMuted,
                    ),
                  ),
                  const SizedBox(height: 28),
                  AuthUnderlineField(
                    controller: _email,
                    label: l10n.authLabelEmail,
                    hint: l10n.authHintEmail,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.mail_outline,
                  ),
                  const SizedBox(height: 24),
                  WpggPrimaryButton(
                    label: l10n.authButtonSendResetLink,
                    isLoading: loading,
                    onPressed: loading ? null : () => _submit(loading),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: loading ? null : () => context.go('/login'),
                    style: TextButton.styleFrom(
                      foregroundColor: AuthUiColors.cardTextMuted,
                    ),
                    child: Text(
                      l10n.authBackToLogin,
                      style: const TextStyle(fontFamily: AppFonts.lexendDeca),
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
