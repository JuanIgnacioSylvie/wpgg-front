import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/economy/wpgg_economy.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_shell_scope.dart';
import '../../../../core/presentation/wpgg_snackbar.dart';
import '../../../../core/presentation/wpgg_transaction_overlay.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../domain/entities/store_product.dart';
import '../bloc/store_bloc.dart';
import 'store_purchase_success_dialog.dart';

String _newIdempotencyKey(String productId) {
  final random = Random();
  return '${DateTime.now().toUtc().millisecondsSinceEpoch}-$productId-${random.nextInt(1 << 32)}';
}

Future<void> _showPurchaseLoading(BuildContext context, String message) {
  WpggTransactionOverlay.show(context, message: message);
  return Future<void>.value();
}

Future<void> showStorePurchaseDialog(
  BuildContext context,
  StoreProduct product,
) async {
  final l10n = context.l10n;
  final isWeb = WebShellScope.isActive(context);
  final walletState = context.read<WalletBloc>().state;
  final balance = WpggEconomy.balanceFromState(walletState);
  final canAfford = WpggEconomy.canAfford(balance, product.priceWpgg);

  final confirmed = isWeb
      ? await showWebDialog<bool>(
          context: context,
          builder: (ctx) => _PurchaseConfirmDialog(
            product: product,
            balance: balance,
            canAfford: canAfford,
          ),
        )
      : await showDialog<bool>(
          context: context,
          builder: (ctx) => _PurchaseConfirmDialog(
            product: product,
            balance: balance,
            canAfford: canAfford,
          ),
        );

  if (confirmed != true || !context.mounted) {
    return;
  }

  final storeBloc = context.read<StoreBloc>();
  storeBloc.add(const ClearStorePurchaseResult());

  final purchaseFuture = storeBloc.stream.firstWhere(
    (state) =>
        state is StoreLoaded &&
        !state.purchasing &&
        (state.lastPurchase != null || state.purchaseError != null),
  );

  storeBloc.add(PurchaseStoreProduct(
    productSlug: product.id,
    idempotencyKey: _newIdempotencyKey(product.id),
  ));

  if (context.mounted) {
    await _showPurchaseLoading(context, l10n.transactionProcessingPurchase);
  }

  final resultState = await purchaseFuture;

  WpggTransactionOverlay.hide();

  if (!context.mounted) {
    return;
  }

  if (resultState is StoreLoaded) {
    if (resultState.purchaseError != null) {
      WpggSnackBar.show(
        context,
        _friendlyPurchaseError(resultState.purchaseError!, l10n),
        isError: true,
      );
      return;
    }

    final purchase = resultState.lastPurchase;
    if (purchase != null) {
      context.read<WalletBloc>().add(const LoadWallet());
      storeBloc.add(const ClearStorePurchaseResult());
      await showStorePurchaseSuccessDialog(context, purchase);
    }
  }
}

String _friendlyPurchaseError(String raw, dynamic l10n) {
  final lower = raw.toLowerCase();
  if (lower.contains('insufficient')) {
    return l10n.missionInsufficientBalance;
  }
  if (lower.contains('out of stock')) {
    return l10n.storeOutOfStock;
  }
  return l10n.storePurchaseError;
}

class _PurchaseConfirmDialog extends StatelessWidget {
  const _PurchaseConfirmDialog({
    required this.product,
    required this.balance,
    required this.canAfford,
  });

  final StoreProduct product;
  final int? balance;
  final bool canAfford;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isWeb = WebShellScope.isActive(context);

    return AlertDialog(
      backgroundColor: isWeb ? WebColors.surfaceElevated : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isWeb
            ? const BorderSide(color: WebColors.border)
            : BorderSide.none,
      ),
      title: Text(
        l10n.storePurchaseTitle,
        style: TextStyle(
          color: isWeb ? WebColors.textPrimary : Colors.black87,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.storePurchaseBody(product.priceWpgg, product.displayName),
            style: TextStyle(
              color: isWeb ? WebColors.textSecondary : Colors.black54,
            ),
          ),
          if (balance != null) ...[
            const SizedBox(height: 8),
            Text(
              l10n.missionSpendBalanceHint(balance!),
              style: TextStyle(
                color: isWeb ? WebColors.textSecondary : Colors.black54,
              ),
            ),
          ],
          if (!canAfford) ...[
            const SizedBox(height: 8),
            Text(
              l10n.missionInsufficientBalance,
              style: TextStyle(
                color: isWeb ? WebColors.accent : Colors.red,
              ),
            ),
          ],
        ],
      ),
      actions: [
        WpggCancelButton(
          onPressed: () => Navigator.pop(context, false),
          label: l10n.cancel,
        ),
        WpggPrimaryButton(
          onPressed: canAfford ? () => Navigator.pop(context, true) : null,
          label: l10n.storeBuy,
        ),
      ],
    );
  }
}
