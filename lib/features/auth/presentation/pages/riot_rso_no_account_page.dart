import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Tras `?error=user_not_found&intent=login` del redirect RSO.
class RiotRsoNoAccountPage extends StatelessWidget {
  const RiotRsoNoAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: sl<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Cuenta no encontrada')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: 56,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No encontramos tu cuenta',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Parece que todavía no te registraste en WPGG con esta cuenta de Riot.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () => context.read<AuthBloc>().add(
                          const RiotRsoSignUpRequested(requestRedirect: true),
                        ),
                    icon: const Icon(Icons.sports_esports_outlined),
                    label: const Text('Registrarme con Riot'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Volver'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
