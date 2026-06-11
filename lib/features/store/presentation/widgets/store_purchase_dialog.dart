import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_shell_scope.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../domain/entities/store_product.dart';
import '../bloc/store_bloc.dart';

String newStorePurchaseIdempotencyKey(String productId) {
  final random = Random();
  // Avoid `1 << 32`: on web it evaluates to 0 and breaks Random.nextInt.
  final nonce = random.nextInt(999999999);
  return '${DateTime.now().toUtc().millisecondsSinceEpoch}-$productId-$nonce';
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

void purchaseStoreProduct(StoreProduct product) {
  sl<StoreBloc>().add(
    PurchaseStoreProduct(
      productSlug: product.id,
      idempotencyKey: newStorePurchaseIdempotencyKey(product.id),
    ),
  );
}

Future<void> showStorePurchaseDialog(
  BuildContext context,
  StoreProduct product,
) async {
  final l10n = context.l10n;
  final isWeb = WebShellScope.isActive(context);

  Widget buildDialog(BuildContext dialogContext) {
    final secondaryColor =
        isWeb ? WebColors.textSecondary : WpggBrand.cardTextDark;
    final titleColor = isWeb ? WebColors.textPrimary : WpggBrand.cardTextDark;

    void confirm() {
      purchaseStoreProduct(product);
      Navigator.of(dialogContext).pop();
    }

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
      content: Text(
        l10n.storePurchaseBody(product.priceWpgg, product.displayName),
        style: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: secondaryColor,
          height: 1.45,
        ),
      ),
      actions: [
        WpggCancelButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          label: l10n.cancel,
        ),
        WpggPrimaryButton(
          onPressed: confirm,
          label: l10n.storeBuy,
        ),
      ],
    );
  }

  if (isWeb) {
    await showWebDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: buildDialog,
    );
    return;
  }

  await showDialog<void>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: buildDialog,
  );
}
