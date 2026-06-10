import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/economy/wpgg_economy.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_shell_scope.dart';
import '../../../../core/presentation/wpgg_snackbar.dart';
import '../../../../core/presentation/wpgg_transaction_overlay.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../data/datasources/store_remote_datasource.dart';
import '../../domain/entities/store_product.dart';
import '../bloc/store_bloc.dart';
import 'store_purchase_success_dialog.dart';

String _newIdempotencyKey(String productId) {
  final random = Random();
  return '${DateTime.now().toUtc().millisecondsSinceEpoch}-$productId-${random.nextInt(1 << 32)}';
}

Future<void> _executePurchase({
  required BuildContext context,
  required StoreProduct product,
  required WalletBloc walletBloc,
  required StoreBloc storeBloc,
  required StoreRemoteDataSource dataSource,
  required dynamic l10n,
}) async {
  if (!context.mounted) return;

  WpggTransactionOverlay.show(
    context,
    message: l10n.transactionProcessingPurchase,
  );

  try {
    final purchase = await dataSource.purchaseProduct(
      productSlug: product.id,
      idempotencyKey: _newIdempotencyKey(product.id),
    );
    if (!context.mounted) return;

    walletBloc.add(const LoadWallet());
    storeBloc.add(const LoadStoreOrders());
    await showStorePurchaseSuccessDialog(context, purchase);
  } catch (e) {
    if (context.mounted) {
      WpggSnackBar.show(
        context,
        _friendlyPurchaseError(e.toString(), l10n),
        isError: true,
      );
    }
  } finally {
    WpggTransactionOverlay.hide();
  }
}

Future<void> showStorePurchaseDialog(
  BuildContext context,
  StoreProduct product,
) async {
  if (!context.mounted) return;

  final l10n = context.l10n;
  final isWeb = WebShellScope.isActive(context);
  final walletBloc = context.read<WalletBloc>();
  final storeBloc = context.read<StoreBloc>();
  final dataSource = sl<StoreRemoteDataSource>();

  void onConfirm() {
    unawaited(
      _executePurchase(
        context: context,
        product: product,
        walletBloc: walletBloc,
        storeBloc: storeBloc,
        dataSource: dataSource,
        l10n: l10n,
      ),
    );
  }

  if (isWeb) {
    await showWebDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => BlocProvider.value(
        value: walletBloc,
        child: _PurchaseConfirmDialog(
          dialogCtx: dialogCtx,
          product: product,
          isWeb: true,
          onConfirm: () {
            Navigator.pop(dialogCtx);
            onConfirm();
          },
        ),
      ),
    );
    return;
  }

  await showDialog<void>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (dialogCtx) => BlocProvider.value(
      value: walletBloc,
      child: _PurchaseConfirmDialog(
        dialogCtx: dialogCtx,
        product: product,
        isWeb: false,
        onConfirm: () {
          Navigator.pop(dialogCtx);
          onConfirm();
        },
      ),
    ),
  );
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
    required this.dialogCtx,
    required this.product,
    required this.isWeb,
    required this.onConfirm,
  });

  final BuildContext dialogCtx;
  final StoreProduct product;
  final bool isWeb;
  final VoidCallback onConfirm;

  Widget _body(BuildContext context, dynamic l10n, WalletState walletState) {
    final balance = WpggEconomy.balanceFromState(walletState);
    final walletLoading = balance == null && walletState is! WalletError;
    final canAfford = WpggEconomy.canAfford(balance, product.priceWpgg);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.storePurchaseBody(product.priceWpgg, product.displayName),
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isWeb ? WebColors.textSecondary : WpggBrand.cardTextDark,
            height: 1.45,
          ),
        ),
        if (walletLoading) ...[
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: isWeb ? WebColors.accent : WpggBrand.primary,
              ),
            ),
          ),
        ] else if (balance != null) ...[
          const SizedBox(height: 8),
          Text(
            l10n.missionSpendBalanceHint(balance),
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontSize: 13,
              color: isWeb ? WebColors.textMuted : WpggBrand.textMuted,
            ),
          ),
        ],
        if (!walletLoading && !canAfford) ...[
          const SizedBox(height: 8),
          Text(
            l10n.missionInsufficientBalance,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isWeb ? WebColors.accent : WpggBrand.primary,
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, walletState) {
        final balance = WpggEconomy.balanceFromState(walletState);
        final walletLoading = balance == null && walletState is! WalletError;

        if (isWeb) {
          return AlertDialog(
            backgroundColor: WebColors.surfaceElevated,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: WebColors.border),
            ),
            title: Text(
              l10n.storePurchaseTitle,
              style: const TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: WebColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: _body(context, l10n, walletState),
            actions: [
              WpggCancelButton(
                onPressed: () => Navigator.pop(dialogCtx),
                label: l10n.cancel,
              ),
              WpggPrimaryButton(
                onPressed: walletLoading ? null : onConfirm,
                label: l10n.storeBuy,
              ),
            ],
          );
        }

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
                Text(
                  l10n.storePurchaseTitle,
                  style: const TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: WpggBrand.cardTextDark,
                  ),
                ),
                const SizedBox(height: 12),
                _body(context, l10n, walletState),
                const SizedBox(height: 24),
                WpggPrimaryButton(
                  onPressed: walletLoading ? null : onConfirm,
                  label: l10n.storeBuy,
                ),
                const SizedBox(height: 12),
                WpggCancelButton(
                  onPressed: () => Navigator.pop(dialogCtx),
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
