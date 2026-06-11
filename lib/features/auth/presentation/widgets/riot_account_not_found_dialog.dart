import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';
import '../../../../core/l10n/l10n_extension.dart';
import 'wpgg_primary_button.dart';

/// Modal caso 1: login Riot sin cuenta WPGG previa.
Future<void> showRiotAccountNotFoundDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => const _RiotAccountNotFoundDialog(),
  );
}

class _RiotAccountNotFoundDialog extends StatelessWidget {
  const _RiotAccountNotFoundDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Dialog(
      backgroundColor: AuthUiColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.riotNotFoundTitle,
                        style: const TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AuthUiColors.cardText,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.riotNotFoundBody,
                        style: const TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AuthUiColors.cardTextMuted,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: AuthUiColors.cardTextMuted,
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
            const SizedBox(height: 24),
            WpggPrimaryButton(
              label: l10n.riotNotFoundRegister,
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/register');
              },
            ),
            const SizedBox(height: 12),
            WpggCancelButton(
              label: l10n.cancel,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
