import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/wallet_remote_datasource.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc(this._dataSource) : super(const WalletInitial()) {
    on<LoadWallet>(_onLoad);
    on<ChangeTransactionFilter>(_onFilter);
  }

  final WalletRemoteDataSource _dataSource;

  Future<void> _onLoad(LoadWallet event, Emitter<WalletState> emit) async {
    emit(const WalletLoading());
    try {
      final summary = await _dataSource.fetchWallet();
      final chart = await _dataSource.fetchMarketChart(7);
      final transactions =
          await _dataSource.fetchTransactions(event.filter);
      emit(WalletLoaded(
        summary: summary,
        chart: chart,
        transactions: transactions,
        filter: event.filter,
      ));
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> _onFilter(
    ChangeTransactionFilter event,
    Emitter<WalletState> emit,
  ) async {
    final current = state;
    if (current is! WalletLoaded) {
      add(LoadWallet(filter: event.filter));
      return;
    }
    try {
      final transactions =
          await _dataSource.fetchTransactions(event.filter);
      emit(current.copyWith(
        transactions: transactions,
        filter: event.filter,
      ));
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }
}
