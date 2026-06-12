import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';

Future<void> showProfilePrivacyDialog(
  BuildContext context, {
  required VoidCallback onOpenSettings,
  bool useWebStyle = false,
}) {
  final l10n = context.l10n;

  if (!useWebStyle) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.profilePrivateViewerTitle),
        content: Text(l10n.profilePrivateViewerBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              onOpenSettings();
            },
            child: Text(l10n.profileOpenSettings),
          ),
        ],
      ),
    );
  }

  return showWebDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: WebColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: WebColors.border),
      ),
      title: Text(
        l10n.profilePrivateViewerTitle,
        style: const TextStyle(
          color: WebColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        l10n.profilePrivateViewerBody,
        style: const TextStyle(
          color: WebColors.textSecondary,
          height: 1.45,
        ),
      ),
      actions: [
        WpggCancelButton(
          onPressed: () => Navigator.pop(ctx),
          label: l10n.cancel,
        ),
        WpggPrimaryButton(
          onPressed: () {
            Navigator.pop(ctx);
            onOpenSettings();
          },
          label: l10n.profileOpenSettings,
        ),
      ],
    ),
  );
}
