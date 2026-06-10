class WpggTokenPrice {
  const WpggTokenPrice({
    required this.priceUsd,
    required this.priceChangeH24,
    required this.volumeH24,
    required this.liquidityUsd,
  });

  final double priceUsd;
  final double priceChangeH24;
  final double volumeH24;
  final double liquidityUsd;

  factory WpggTokenPrice.fromDexScreenerPair(Map<String, dynamic> pair) {
    final priceChange = pair['priceChange'] as Map<String, dynamic>?;
    final volume = pair['volume'] as Map<String, dynamic>?;
    final liquidity = pair['liquidity'] as Map<String, dynamic>?;

    return WpggTokenPrice(
      priceUsd: _parseDouble(pair['priceUsd']),
      priceChangeH24: _parseDouble(priceChange?['h24']),
      volumeH24: _parseDouble(volume?['h24']),
      liquidityUsd: _parseDouble(liquidity?['usd']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}
