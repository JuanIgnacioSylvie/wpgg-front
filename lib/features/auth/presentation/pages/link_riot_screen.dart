import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../auth_strings.dart';
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
        return AuthLexendScope(
          child: AuthScreenScaffold(
            child: AuthCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    AuthStrings.linkRiotBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                            size: 64,
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
