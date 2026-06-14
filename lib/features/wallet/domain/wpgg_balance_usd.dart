/// USD helpers for WPGG balances (live price × balance).
String formatWpggUsdAmount(double usd) {
  if (usd <= 0) return '—';
  if (usd >= 1) return '\$${usd.toStringAsFixed(2)}';
  if (usd >= 0.01) return '\$${usd.toStringAsFixed(4)}';
  return '\$${usd.toStringAsFixed(6)}';
}

double wpggBalanceToUsd(int balanceWpgg, double priceUsd) {
  if (priceUsd <= 0) return 0;
  return balanceWpgg * priceUsd;
}
