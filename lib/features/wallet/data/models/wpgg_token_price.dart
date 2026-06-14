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

  factory WpggTokenPrice.fromGeckoTerminalPool(Map<String, dynamic> pool) {
    final attrs = pool['attributes'] as Map<String, dynamic>? ?? {};
    final priceChange =
        attrs['price_change_percentage'] as Map<String, dynamic>?;
    final volume = attrs['volume_usd'] as Map<String, dynamic>?;

    return WpggTokenPrice(
      priceUsd: _parseDouble(attrs['base_token_price_usd']),
      priceChangeH24: _parseDouble(priceChange?['h24']),
      volumeH24: _parseDouble(volume?['h24']),
      liquidityUsd: _parseDouble(attrs['reserve_in_usd']),
    );
  }

  factory WpggTokenPrice.fromCoinGeckoToken(Map<String, dynamic> token) {
    return WpggTokenPrice(
      priceUsd: _parseDouble(token['usd']),
      priceChangeH24: _parseDouble(token['usd_24h_change']),
      volumeH24: _parseDouble(token['usd_24h_vol']),
      liquidityUsd: 0,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}
