import 'package:flutter/material.dart';

import 'web_colors.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';

class WebProfilePanel extends StatelessWidget {
  const WebProfilePanel({
    super.key,
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 380,
        decoration: const BoxDecoration(
          color: WebColors.surface,
          border: Border(
            left: BorderSide(color: WebColors.borderSubtle),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 24,
              offset: Offset(-4, 0),
            ),
          ],
        ),
        child: ProfilePage(
          embeddedInPanel: true,
          onClose: onClose,
        ),
      ),
    );
  }
}
