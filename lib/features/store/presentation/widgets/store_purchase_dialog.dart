import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
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

Future<StoreLoaded?> _waitForPurchaseResult(
  StoreBloc storeBloc,
  PurchaseStoreProduct event,
) async {
  if (storeBloc.state is StoreLoaded) {
    storeBloc.add(const ClearStorePurchaseResult());
  }
  storeBloc.add(event);

  try {
    return await storeBloc.stream
        .where(
          (state) =>
              state is StoreLoaded &&
              !state.purchasing &&
              (state.lastPurchase != null || state.purchaseError != null),
        )
        .cast<StoreLoaded>()
        .first
        .timeout(const Duration(seconds: 60));
  } on TimeoutException {
    return null;
  }
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
          builder: (dialogContext) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: walletBloc),
            ],
            child: _PurchaseConfirmDialog(
              product: product,
              isWeb: true,
              dialogContext: dialogContext,
            ),
          ),
        )
      : await showDialog<bool>(
          context: context,
          useRootNavigator: false,
          barrierDismissible: false,
          builder: (dialogContext) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: walletBloc),
            ],
            child: _PurchaseConfirmDialog(
              product: product,
              isWeb: false,
              dialogContext: dialogContext,
            ),
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
    if (context.mounted && resultState == null) {
      WpggSnackBar.show(context, l10n.storePurchaseError, isError: true);
    }
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
  const _PurchaseConfirmDialog({
    required this.product,
    required this.isWeb,
    required this.dialogContext,
  });

  final StoreProduct product;
  final bool isWeb;
  final BuildContext dialogContext;

  void _close([bool? result]) {
    Navigator.of(dialogContext).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, walletState) {
        final balance = WpggEconomy.balanceFromState(walletState);
        final walletLoading =
            balance == null && walletState is! WalletError;
        final canAfford = WpggEconomy.canAfford(balance, product.priceWpgg);

        final content = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    l10n.storePurchaseTitle,
                    style: TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      fontSize: isWeb ? 17 : 18,
                      fontWeight: FontWeight.w700,
                      color: isWeb
                          ? WebColors.textPrimary
                          : WpggBrand.cardTextDark,
                      height: 1.25,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _close(false),
                  icon: Icon(
                    Icons.close,
                    color: isWeb
                        ? WebColors.textSecondary
                        : WpggBrand.textMuted,
                    size: isWeb ? 20 : 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
            SizedBox(height: isWeb ? 10 : 12),
            Text(
              l10n.storePurchaseBody(product.priceWpgg, product.displayName),
              style: TextStyle(
                fontFamily: AppFonts.lexendDeca,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isWeb
                    ? WebColors.textSecondary
                    : WpggBrand.cardTextDark,
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
                  color: isWeb
                      ? WebColors.textMuted
                      : WpggBrand.textMuted,
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
            SizedBox(height: isWeb ? 20 : 24),
            if (isWeb)
              Row(
                children: [
                  Expanded(
                    child: WpggCancelButton(
                      onPressed: () => _close(false),
                      label: l10n.cancel,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: WpggPrimaryButton(
                      onPressed:
                          canAfford ? () => _close(true) : null,
                      label: l10n.storeBuy,
                    ),
                  ),
                ],
              )
            else ...[
              WpggPrimaryButton(
                onPressed: canAfford ? () => _close(true) : null,
                label: l10n.storeBuy,
              ),
              const SizedBox(height: 12),
              WpggCancelButton(
                onPressed: () => _close(false),
                label: l10n.cancel,
              ),
            ],
          ],
        );

        if (isWeb) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: WebColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: WebColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 12, 20),
                  child: content,
                ),
              ),
            ),
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
            child: content,
          ),
        );
      },
    );
  }
}
