import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../bloc/missions_bloc.dart';

Future<void> showCancelMissionDialog(
  BuildContext context, {
  required String missionId,
}) async {
  final l10n = context.l10n;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.cancelMissionTitle),
      content: Text(l10n.cancelMissionBody),
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
  if (ok == true && context.mounted) {
    context.read<MissionsBloc>().add(CancelActiveMission(missionId));
    context.read<WalletBloc>().add(const LoadWallet());
  }
}
