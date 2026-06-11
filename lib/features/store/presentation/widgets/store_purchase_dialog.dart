import 'dart:math';

import '../../../../core/di/injection_container.dart';
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

void showStorePurchaseDialog(StoreProduct product) {
  sl<StoreBloc>().add(
    PurchaseStoreProduct(
      productSlug: product.id,
      idempotencyKey: newStorePurchaseIdempotencyKey(product.id),
    ),
  );
}
