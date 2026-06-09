import '../../features/wallet/presentation/bloc/wallet_bloc.dart';

/// In-app WPGG economy defaults (overridden by [WalletSummary] when loaded).
abstract final class WpggEconomy {
  static const int defaultRerollCost = 5;
  static const int defaultCancelCost = 5;

  static int? balanceFromState(WalletState state) {
    return switch (state) {
      WalletLoaded(:final summary) => summary.balance,
      WalletWithdrawing(:final summary) => summary.balance,
      WalletWithdrawSuccess(:final summary) => summary.balance,
      WalletWithdrawError(:final summary) => summary.balance,
      _ => null,
    };
  }

  static int rerollCostFromState(WalletState state) {
    return switch (state) {
      WalletLoaded(:final summary) => summary.rerollCostWpgg,
      WalletWithdrawing(:final summary) => summary.rerollCostWpgg,
      WalletWithdrawSuccess(:final summary) => summary.rerollCostWpgg,
      WalletWithdrawError(:final summary) => summary.rerollCostWpgg,
      _ => defaultRerollCost,
    };
  }

  static int cancelCostFromState(WalletState state) {
    return switch (state) {
      WalletLoaded(:final summary) => summary.cancelCostWpgg,
      WalletWithdrawing(:final summary) => summary.cancelCostWpgg,
      WalletWithdrawSuccess(:final summary) => summary.cancelCostWpgg,
      WalletWithdrawError(:final summary) => summary.cancelCostWpgg,
      _ => defaultCancelCost,
    };
  }

  static bool canAfford(int? balance, int cost) =>
      balance != null && balance >= cost;

  static bool isInsufficientBalanceMessage(String message) {
    final lower = message.toLowerCase();
    return lower.contains('insufficient wpgg') ||
        lower.contains('saldo insuficiente');
  }
}
