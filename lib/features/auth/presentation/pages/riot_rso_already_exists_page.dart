import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Ruta legada: redirige al login con modal de cuenta existente.
class RiotRsoAlreadyExistsPage extends StatelessWidget {
  const RiotRsoAlreadyExistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.go('/login?riot_already_exists=1');
      }
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
