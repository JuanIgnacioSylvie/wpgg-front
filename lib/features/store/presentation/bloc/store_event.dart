part of 'store_bloc.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object?> get props => [];
}

class LoadStoreOrders extends StoreEvent {
  const LoadStoreOrders();
}

class PurchaseStoreProduct extends StoreEvent {
  const PurchaseStoreProduct({
    required this.productSlug,
    required this.idempotencyKey,
  });

  final String productSlug;
  final String idempotencyKey;

  @override
  List<Object?> get props => [productSlug, idempotencyKey];
}

class ClearStorePurchaseResult extends StoreEvent {
  const ClearStorePurchaseResult();
}
