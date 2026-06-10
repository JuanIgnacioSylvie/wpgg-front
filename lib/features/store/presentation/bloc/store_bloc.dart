import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
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

  void _refreshWallet() {
    sl<WalletBloc>().add(const LoadWallet());
  }

  Future<void> _onLoad(LoadStoreOrders event, Emitter<StoreState> emit) async {
    final current = state;
    if (current is StoreLoaded && current.purchasing) {
      return;
    }

    final pendingPurchase = current is StoreLoaded ? current.lastPurchase : null;
    final pendingError = current is StoreLoaded ? current.purchaseError : null;

    emit(const StoreLoading());
    try {
      final orders = await _dataSource.fetchOrders();
      final afterFetch = state;
      if (afterFetch is StoreLoaded && afterFetch.purchasing) {
        return;
      }
      emit(StoreLoaded(
        orders: orders,
        lastPurchase: pendingPurchase,
        purchaseError: pendingError,
      ));
    } catch (e) {
      final afterError = state;
      if (afterError is StoreLoaded && afterError.purchasing) {
        return;
      }
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
    ));

    try {
      final result = await _dataSource.purchaseProduct(
        productSlug: event.productSlug,
        idempotencyKey: event.idempotencyKey,
      );
      final orders = await _dataSource.fetchOrders();
      _refreshWallet();
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
