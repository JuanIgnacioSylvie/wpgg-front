import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/economy/wpgg_economy.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/wpgg_snackbar.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../domain/entities/store_product.dart';

Future<void> showStorePurchaseDialog(
  BuildContext context,
  StoreProduct product,
) async {
  final l10n = context.l10n;
  final walletState = context.read<WalletBloc>().state;
  final balance = WpggEconomy.balanceFromState(walletState);
  final canAfford = WpggEconomy.canAfford(balance, product.priceWpgg);

  final confirmed = await showWebDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: WebColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: WebColors.border),
      ),
      title: Text(
        l10n.storePurchaseTitle,
        style: const TextStyle(color: WebColors.textPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.storePurchaseBody(product.priceWpgg, product.displayName),
            style: const TextStyle(color: WebColors.textSecondary),
          ),
          if (balance != null) ...[
            const SizedBox(height: 8),
            Text(
              l10n.missionSpendBalanceHint(balance),
              style: const TextStyle(color: WebColors.textSecondary),
            ),
          ],
          if (!canAfford) ...[
            const SizedBox(height: 8),
            Text(
              l10n.missionInsufficientBalance,
              style: const TextStyle(color: WebColors.accent),
            ),
          ],
        ],
      ),
      actions: [
        WpggCancelButton(
          onPressed: () => Navigator.pop(ctx, false),
          label: l10n.cancel,
        ),
        WpggPrimaryButton(
          onPressed: canAfford ? () => Navigator.pop(ctx, true) : null,
          label: l10n.storeBuy,
        ),
      ],
    ),
  );

  if (confirmed == true && context.mounted) {
    WpggSnackBar.show(context, l10n.storeComingSoon);
  }
}
