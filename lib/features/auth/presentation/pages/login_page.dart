import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth_flow_mode.dart';
import '../widgets/riot_account_already_exists_dialog.dart';
import '../widgets/riot_account_not_found_dialog.dart';
import 'auth_flow_page.dart';

/// Login WPGG + modales tras redirect Riot OAuth.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowRiotOAuthModal());
  }

  void _maybeShowRiotOAuthModal() {
    if (!mounted) return;
    final q = GoRouterState.of(context).uri.queryParameters;

    final notFound =
        q['riot_not_found'] == '1' || q['error'] == 'user_not_found';
    final alreadyExists = q['riot_already_exists'] == '1' ||
        q['error'] == 'user_already_exists';

    if (!notFound && !alreadyExists) return;

    context.replace('/login');

    if (alreadyExists) {
      showRiotAccountAlreadyExistsDialog(context);
    } else {
      showRiotAccountNotFoundDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const AuthFlowPage(initialMode: AuthFlowMode.login);
  }
}
