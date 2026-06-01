import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/presentation/wpgg_gradient_scaffold.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WpggGradientScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Profile',
              style: TextStyle(
                color: WpggBrand.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {
                context.read<AuthBloc>().add(const LogoutRequested());
                context.go('/login');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: WpggBrand.white,
                side: const BorderSide(color: WpggBrand.white),
              ),
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
