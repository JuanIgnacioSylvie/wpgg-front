import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/store_remote_datasource.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc(this._dataSource) : super(const StoreInitial()) {
    on<LoadStoreOrders>(_onLoad);
    on<PurchaseStoreProduct>(_onPurchase);
    on<ClearStorePurchaseResult>(_onClearPurchase);
  }

  final StoreRemoteDataSource _dataSource;

  Future<void> _onLoad(LoadStoreOrders event, Emitter<StoreState> emit) async {
    emit(const StoreLoading());
    try {
      final orders = await _dataSource.fetchOrders();
      emit(StoreLoaded(orders: orders));
    } catch (e) {
      emit(StoreError(e.toString()));
    }
  }

  Future<void> _onPurchase(
    PurchaseStoreProduct event,
    Emitter<StoreState> emit,
  ) async {
    final current = state;
    final existingOrders = switch (current) {
      StoreLoaded(:final orders) => orders,
      _ => <StoreOrderResult>[],
    };

    emit(StoreLoaded(
      orders: existingOrders,
      purchasing: true,
      lastPurchase: current is StoreLoaded ? current.lastPurchase : null,
    ));

    try {
      final result = await _dataSource.purchaseProduct(
        productSlug: event.productSlug,
        idempotencyKey: event.idempotencyKey,
      );
      final orders = await _dataSource.fetchOrders();
      emit(StoreLoaded(
        orders: orders,
        lastPurchase: result,
      ));
    } catch (e) {
      emit(StoreLoaded(
        orders: existingOrders,
        purchaseError: e.toString(),
      ));
    }
  }

  void _onClearPurchase(
    ClearStorePurchaseResult event,
    Emitter<StoreState> emit,
  ) {
    final current = state;
    if (current is StoreLoaded) {
      emit(current.copyWith(clearPurchase: true, clearError: true));
    }
  }
}
