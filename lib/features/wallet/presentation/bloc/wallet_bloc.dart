import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/wallet_remote_datasource.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc(this._dataSource) : super(const WalletInitial()) {
    on<LoadWallet>(_onLoad);
    on<ChangeTransactionFilter>(_onFilter);
    on<RequestWithdrawal>(_onWithdraw);
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

  Future<void> _onWithdraw(
    RequestWithdrawal event,
    Emitter<WalletState> emit,
  ) async {
    final current = state;
    if (current is WalletWithdrawing) {
      return;
    }

    final snapshot = switch (current) {
      WalletLoaded() => (
          summary: current.summary,
          chart: current.chart,
          transactions: current.transactions,
          filter: current.filter,
        ),
      WalletWithdrawSuccess() => (
          summary: current.summary,
          chart: current.chart,
          transactions: current.transactions,
          filter: current.filter,
        ),
      WalletWithdrawError() => (
          summary: current.summary,
          chart: current.chart,
          transactions: current.transactions,
          filter: current.filter,
        ),
      _ => null,
    };
    if (snapshot == null) {
      return;
    }

    emit(WalletWithdrawing(summary: snapshot.summary));
    try {
      final result = await _dataSource.requestWithdrawal(
        walletAddress: event.walletAddress,
        amountWpgg: event.amountWpgg,
      );
      final summary = await _dataSource.fetchWallet();
      emit(WalletWithdrawSuccess(
        summary: summary,
        chart: snapshot.chart,
        transactions: snapshot.transactions,
        filter: snapshot.filter,
        result: result,
      ));
    } catch (e) {
      emit(WalletWithdrawError(
        summary: snapshot.summary,
        chart: snapshot.chart,
        transactions: snapshot.transactions,
        filter: snapshot.filter,
        message: e.toString(),
      ));
    }
  }
}
