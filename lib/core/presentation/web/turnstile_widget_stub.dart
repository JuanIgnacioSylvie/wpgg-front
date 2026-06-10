import 'package:flutter/material.dart';

/// Non-web builds skip Turnstile (backend allows mobile without captcha).
class TurnstileWidget extends StatelessWidget {
  const TurnstileWidget({
    super.key,
    required this.siteKey,
    required this.onToken,
    this.onExpired,
    this.onError,
  });

  final String siteKey;
  final ValueChanged<String> onToken;
  final VoidCallback? onExpired;
  final VoidCallback? onError;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void resetTurnstileWidget() {}
