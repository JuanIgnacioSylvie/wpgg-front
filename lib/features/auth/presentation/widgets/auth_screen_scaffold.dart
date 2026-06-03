import 'package:flutter/material.dart';

import '../../../../core/constants/auth_ui_colors.dart';

class AuthScreenScaffold extends StatelessWidget {
  const AuthScreenScaffold({
    super.key,
    required this.child,
    this.bottom,
  });

  final Widget child;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AuthUiColors.screenGradientTop,
              AuthUiColors.screenGradientBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                child,
                if (bottom != null) ...[
                  const SizedBox(height: 24),
                  bottom!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
