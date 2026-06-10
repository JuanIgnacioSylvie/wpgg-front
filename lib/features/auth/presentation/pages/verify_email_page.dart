import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/presentation/wpgg_snackbar.dart';
import '../../../riot/domain/usecases/get_summoner_profile_usecase.dart';
import '../auth_strings.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_lexend_scope.dart';
import '../widgets/auth_screen_scaffold.dart';
import '../widgets/wpgg_primary_button.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late final AuthBloc _authBloc;
  StreamSubscription<AuthState>? _authSub;
  String? _token;
  var _started = false;

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
          AuthStrings.verifyEmailInvalidLink,
          isError: true,
        );
        context.go('/register');
        return;
      }
      setState(() {
        _token = token.trim();
        _started = true;
      });
      _authBloc.add(VerifyEmailRequested(token: _token!));
    });
  }

  Future<void> _navigateAfterAuthenticated() async {
    final res = await sl<GetSummonerProfileUseCase>()();
    if (!mounted) return;
    final needsLink = res.fold((_) => false, (s) => s == null);
    WpggSnackBar.show(context, AuthStrings.verifyEmailSuccess);
    context.go(needsLink ? '/auth/link-riot' : '/home');
  }

  void _onAuthState(AuthState state) {
    if (!mounted) return;
    if (state is AuthAuthenticated) {
      unawaited(_navigateAfterAuthenticated());
      return;
    }
    if (state is AuthError) {
      WpggSnackBar.show(context, state.message, isError: true);
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: _authBloc.stream,
      initialData: _authBloc.state,
      builder: (context, snapshot) {
        final loading = snapshot.data is AuthLoading || !_started;
        return AuthLexendScope(
          child: AuthScreenScaffold(
            child: AuthCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AuthStrings.verifyEmailTitle,
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
                    loading
                        ? 'Confirmando tu email…'
                        : AuthStrings.verifyEmailInvalidLink,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      fontSize: 14,
                      color: AuthUiColors.cardTextMuted,
                      height: 1.45,
                    ),
                  ),
                  if (loading) ...[
                    const SizedBox(height: 24),
                    const Center(child: CircularProgressIndicator()),
                  ] else ...[
                    const SizedBox(height: 24),
                    WpggPrimaryButton(
                      label: AuthStrings.backToLogin,
                      onPressed: () => context.go('/login'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
