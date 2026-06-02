import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (_password.text != _confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }
    context.read<AuthBloc>().add(
          RegisterRequested(
            email: _email.text.trim(),
            password: _password.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/home');
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
          appBar: AppBar(title: const Text('Crear cuenta')),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
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
                    'Registrate',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _password,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _confirm,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar contraseña',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: loading ? null : _submit,
                    child: const Text('Registrarse'),
                  ),
                  if (loading) const LinearProgressIndicator(),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: loading
                        ? null
                        : () => context.read<AuthBloc>().add(
                              const RiotRsoSignUpRequested(
                                requestRedirect: true,
                              ),
                            ),
                    icon: const Icon(Icons.sports_esports_outlined),
                    label: const Text('Registrarme con Riot'),
                  ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Ya tengo cuenta'),
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
