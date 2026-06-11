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
import '../widgets/riot_oauth_button.dart';

/// Casos 2 y 3: vincular cuenta Riot (post-registro o usuario sin summoner vinculado).
class LinkRiotScreen extends StatefulWidget {
  const LinkRiotScreen({super.key});

  @override
  State<LinkRiotScreen> createState() => _LinkRiotScreenState();
}

class _LinkRiotScreenState extends State<LinkRiotScreen> {
  late final AuthBloc _authBloc;
  StreamSubscription<AuthState>? _authSub;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _authSub = _authBloc.stream.listen(_onAuthState);
  }

  void _onAuthState(AuthState state) {
    if (!mounted) return;
    if (state is AuthAuthenticated) {
      context.go('/home');
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
    super.dispose();
  }

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
            child: AuthCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.linkRiotBody,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: AuthUiColors.cardText,
                      fontSize: 15,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: loading
                        ? const CircularProgressIndicator(
                            color: AuthUiColors.accentRed,
                          )
                        : RiotOAuthButton(
                            onPressed: () => _authBloc.add(
                              const RiotRsoLinkRequested(),
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
