part of 'wallet_bloc.dart';

sealed class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletLoading extends WalletState {
  const WalletLoading();
}

class WalletLoaded extends WalletState {
  const WalletLoaded({
    required this.summary,
    required this.chart,
    required this.transactions,
    required this.filter,
  });

  final WalletSummary summary;
  final List<MarketChartPoint> chart;
  final List<WalletTransaction> transactions;
  final String filter;

  WalletLoaded copyWith({
    WalletSummary? summary,
    List<MarketChartPoint>? chart,
    List<WalletTransaction>? transactions,
    String? filter,
  }) {
    return WalletLoaded(
      summary: summary ?? this.summary,
      chart: chart ?? this.chart,
      transactions: transactions ?? this.transactions,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [summary, chart, transactions, filter];
}

class WalletError extends WalletState {
  const WalletError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class WalletWithdrawing extends WalletState {
  const WalletWithdrawing({required this.summary});

  final WalletSummary summary;

  @override
  List<Object?> get props => [summary];
}

class WalletWithdrawSuccess extends WalletState {
  const WalletWithdrawSuccess({
    required this.summary,
    required this.chart,
    required this.transactions,
    required this.filter,
    required this.result,
  });

  final WalletSummary summary;
  final List<MarketChartPoint> chart;
  final List<WalletTransaction> transactions;
  final String filter;
  final WithdrawalResult result;

  @override
  List<Object?> get props => [summary, chart, transactions, filter, result];
}

class WalletWithdrawError extends WalletState {
  const WalletWithdrawError({
    required this.summary,
    required this.chart,
    required this.transactions,
    required this.filter,
    required this.message,
  });

  final WalletSummary summary;
  final List<MarketChartPoint> chart;
  final List<WalletTransaction> transactions;
  final String filter;
  final String message;

  @override
  List<Object?> get props => [summary, chart, transactions, filter, message];
}
