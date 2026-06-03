import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Ruta legada: redirige al login con modal (caso 1).
class RiotRsoNoAccountPage extends StatelessWidget {
  const RiotRsoNoAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.go('/login?riot_not_found=1');
      }
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
