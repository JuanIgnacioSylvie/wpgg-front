import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';

Future<bool> showCancelMissionDialog(
  BuildContext context, {
  required String missionId,
}) async {
  final l10n = context.l10n;
  final ok = await showWebDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: WebColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: WebColors.border),
      ),
      title: Text(
        l10n.cancelMissionTitle,
        style: const TextStyle(color: WebColors.textPrimary),
      ),
      content: Text(
        l10n.cancelMissionBody,
        style: const TextStyle(color: WebColors.textSecondary),
      ),
      actions: [
        WpggCancelButton(
          onPressed: () => Navigator.pop(ctx, false),
          label: l10n.cancel,
        ),
        WpggPrimaryButton(
          onPressed: () => Navigator.pop(ctx, true),
          label: l10n.deleteMission,
        ),
      ],
    ),
  );
  return ok == true;
}
