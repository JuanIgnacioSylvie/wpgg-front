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
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../domain/entities/store_product.dart';
import '../bloc/store_bloc.dart';

String newStorePurchaseIdempotencyKey(String productId) {
  final random = Random();
  return '${DateTime.now().toUtc().millisecondsSinceEpoch}-$productId-${random.nextInt(1 << 32)}';
}

String friendlyStorePurchaseError(String raw, dynamic l10n) {
  final lower = raw.toLowerCase();
  if (lower.contains('insufficient')) {
    return l10n.missionInsufficientBalance;
  }
  if (lower.contains('out of stock')) {
    return l10n.storeOutOfStock;
  }
  return l10n.storePurchaseError;
}

Future<bool> showStorePurchaseConfirmDialog(
  BuildContext context,
  StoreProduct product,
) async {
  final l10n = context.l10n;
  final isWeb = WebShellScope.isActive(context);
  final walletState = context.read<WalletBloc>().state;
  final balance = WpggEconomy.balanceFromState(walletState);
  final canAfford = WpggEconomy.canAfford(balance, product.priceWpgg);

  Widget buildDialog(BuildContext dialogContext) {
    final secondaryColor =
        isWeb ? WebColors.textSecondary : WpggBrand.cardTextDark;
    final mutedColor = isWeb ? WebColors.textMuted : WpggBrand.textMuted;
    final accentColor = isWeb ? WebColors.accent : WpggBrand.primary;
    final titleColor = isWeb ? WebColors.textPrimary : WpggBrand.cardTextDark;

    return AlertDialog(
      backgroundColor:
          isWeb ? WebColors.surfaceElevated : WpggBrand.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isWeb ? 12 : 20),
        side: isWeb
            ? const BorderSide(color: WebColors.border)
            : BorderSide.none,
      ),
      title: Text(
        l10n.storePurchaseTitle,
        style: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          color: titleColor,
          fontWeight: FontWeight.w700,
          fontSize: isWeb ? 17 : 18,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.storePurchaseBody(product.priceWpgg, product.displayName),
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: secondaryColor,
              height: 1.45,
            ),
          ),
          if (balance != null) ...[
            const SizedBox(height: 8),
            Text(
              l10n.missionSpendBalanceHint(balance),
              style: TextStyle(
                fontFamily: AppFonts.lexendDeca,
                fontSize: 13,
                color: mutedColor,
              ),
            ),
          ],
          if (!canAfford) ...[
            const SizedBox(height: 8),
            Text(
              l10n.missionInsufficientBalance,
              style: TextStyle(
                fontFamily: AppFonts.lexendDeca,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ],
        ],
      ),
      actions: [
        WpggCancelButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          label: l10n.cancel,
        ),
        WpggPrimaryButton(
          onPressed: canAfford ? () => Navigator.pop(dialogContext, true) : null,
          label: l10n.storeBuy,
        ),
      ],
    );
  }

  if (isWeb) {
    final ok = await showWebDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: buildDialog,
    );
    return ok == true;
  }

  final ok = await showDialog<bool>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: buildDialog,
  );
  return ok == true;
}

Future<void> showStorePurchaseDialog(
  BuildContext context,
  StoreProduct product,
) async {
  final ok = await showStorePurchaseConfirmDialog(context, product);
  if (!ok || !context.mounted) return;

  context.read<StoreBloc>().add(
        PurchaseStoreProduct(
          productSlug: product.id,
          idempotencyKey: newStorePurchaseIdempotencyKey(product.id),
        ),
      );
}
