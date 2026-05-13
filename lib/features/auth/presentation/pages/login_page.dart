import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/dashboard');
        }
        if (state is AuthRiotRsoSignInLaunched) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                kIsWeb
                    ? 'Se abrió Riot. Al volver, deberías aterrizar en ${Uri.base.origin}${AppConstants.riotRsoWebSuccessPath} con los tokens en el #.'
                    : 'Se abrió la página de Riot.',
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
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'WPGG',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.wallpoetLogo(context, fontSize: 36),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bienvenido de vuelta',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 32),
                      const LoginForm(),
                      if (loading) ...[
                        const SizedBox(height: 16),
                        const Center(child: CircularProgressIndicator()),
                      ],
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: loading
                            ? null
                            : () => context.read<AuthBloc>().add(
                                  const RiotRsoSignInRequested(
                                    requestRedirect: true,
                                  ),
                                ),
                        icon: const Icon(Icons.sports_esports_outlined),
                        label: const Text('Entrar con Riot'),
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () => context.go('/register'),
                        child: const Text('¿No tenés cuenta? Registrate'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
