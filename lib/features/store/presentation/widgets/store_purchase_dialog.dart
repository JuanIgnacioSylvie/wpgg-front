import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/economy/wpgg_economy.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
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

Future<StoreLoaded?> _waitForPurchaseResult(
  StoreBloc storeBloc,
  PurchaseStoreProduct event,
) async {
  storeBloc.add(const ClearStorePurchaseResult());
  storeBloc.add(event);

  await storeBloc.stream.firstWhere(
    (state) => state is StoreLoaded && state.purchasing,
  );
  final result = await storeBloc.stream.firstWhere(
    (state) => state is StoreLoaded && !state.purchasing,
  );
  return result as StoreLoaded;
}

Future<void> showStorePurchaseDialog(
  BuildContext context,
  StoreProduct product,
) async {
  final l10n = context.l10n;
  final isWeb = WebShellScope.isActive(context);
  final walletBloc = context.read<WalletBloc>();
  final storeBloc = context.read<StoreBloc>();

  final confirmed = isWeb
      ? await showWebDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: walletBloc),
            ],
            child: _PurchaseConfirmDialog(product: product),
          ),
        )
      : await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: walletBloc),
            ],
            child: _PurchaseConfirmDialog(product: product),
          ),
        );

  if (confirmed != true || !context.mounted) {
    return;
  }

  WpggTransactionOverlay.show(context, message: l10n.transactionProcessingPurchase);

  StoreLoaded? resultState;
  try {
    resultState = await _waitForPurchaseResult(
      storeBloc,
      PurchaseStoreProduct(
        productSlug: product.id,
        idempotencyKey: _newIdempotencyKey(product.id),
      ),
    );
  } finally {
    WpggTransactionOverlay.hide();
  }

  if (!context.mounted || resultState == null) {
    return;
  }

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
  const _PurchaseConfirmDialog({required this.product});

  final StoreProduct product;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, walletState) {
        final balance = WpggEconomy.balanceFromState(walletState);
        final walletLoading = balance == null &&
            walletState is! WalletError;
        final canAfford = WpggEconomy.canAfford(balance, product.priceWpgg);

        return Dialog(
          backgroundColor: WpggBrand.cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
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
                      child: Text(
                        l10n.storePurchaseTitle,
                        style: const TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: WpggBrand.cardTextDark,
                          height: 1.25,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(false),
                      icon: const Icon(
                        Icons.close,
                        color: WpggBrand.textMuted,
                        size: 22,
                      ),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.storePurchaseBody(product.priceWpgg, product.displayName),
                  style: const TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: WpggBrand.cardTextDark,
                    height: 1.45,
                  ),
                ),
                if (walletLoading) ...[
                  const SizedBox(height: 16),
                  const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: WpggBrand.primary,
                      ),
                    ),
                  ),
                ] else if (balance != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.missionSpendBalanceHint(balance),
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      fontSize: 13,
                      color: WpggBrand.textMuted,
                    ),
                  ),
                ],
                if (!walletLoading && !canAfford) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.missionInsufficientBalance,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: WpggBrand.primary,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                WpggPrimaryButton(
                  onPressed: canAfford
                      ? () => Navigator.of(context, rootNavigator: true)
                          .pop(true)
                      : null,
                  label: l10n.storeBuy,
                ),
                const SizedBox(height: 12),
                WpggCancelButton(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(false),
                  label: l10n.cancel,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
