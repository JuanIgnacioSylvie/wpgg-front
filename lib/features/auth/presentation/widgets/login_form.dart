import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import 'auth_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _remember = false;
  var _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AuthBloc>().add(
          LoginRequested(
            email: _email.text.trim(),
            password: _password.text,
            rememberMe: _remember,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          controller: _email,
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.mail_outline,
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _password,
          label: 'Contraseña',
          obscureText: _obscure,
          prefixIcon: Icons.lock_outline,
          suffix: IconButton(
            onPressed: () => setState(() => _obscure = !_obscure),
            icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Switch(
              value: _remember,
              onChanged: (v) => setState(() => _remember = v),
            ),
            Text('Recordar sesión', style: theme.textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _submit,
          child: const Text('Iniciar sesión'),
        ),
      ],
    );
  }
}
