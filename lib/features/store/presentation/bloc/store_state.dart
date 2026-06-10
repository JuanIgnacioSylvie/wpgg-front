part of 'store_bloc.dart';

abstract class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object?> get props => [];
}

class StoreInitial extends StoreState {
  const StoreInitial();
}

class StoreLoading extends StoreState {
  const StoreLoading();
}

class StoreLoaded extends StoreState {
  const StoreLoaded({
    required this.orders,
    this.purchasing = false,
    this.lastPurchase,
    this.purchaseError,
  });

  final List<StoreOrderResult> orders;
  final bool purchasing;
  final StorePurchaseResult? lastPurchase;
  final String? purchaseError;

  StoreLoaded copyWith({
    List<StoreOrderResult>? orders,
    bool? purchasing,
    StorePurchaseResult? lastPurchase,
    String? purchaseError,
    bool clearPurchase = false,
    bool clearError = false,
  }) {
    return StoreLoaded(
      orders: orders ?? this.orders,
      purchasing: purchasing ?? this.purchasing,
      lastPurchase: clearPurchase ? null : (lastPurchase ?? this.lastPurchase),
      purchaseError: clearError ? null : (purchaseError ?? this.purchaseError),
    );
  }

  @override
  List<Object?> get props =>
      [orders, purchasing, lastPurchase, purchaseError];
}

class StoreError extends StoreState {
  const StoreError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
