part of 'wallet_bloc.dart';

sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class LoadWallet extends WalletEvent {
  const LoadWallet({this.filter = 'all'});

  final String filter;

  @override
  List<Object?> get props => [filter];
}

class ChangeTransactionFilter extends WalletEvent {
  const ChangeTransactionFilter(this.filter);

  final String filter;

  @override
  List<Object?> get props => [filter];
}

class RequestWithdrawal extends WalletEvent {
  const RequestWithdrawal({
    required this.walletAddress,
    required this.amountWpgg,
  });

  final String walletAddress;
  final int amountWpgg;

  @override
  List<Object?> get props => [walletAddress, amountWpgg];
}
