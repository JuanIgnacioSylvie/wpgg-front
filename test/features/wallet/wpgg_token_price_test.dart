import 'package:flutter_test/flutter_test.dart';
import 'package:wpgg_flutter/features/wallet/data/models/wpgg_token_price.dart';

void main() {
  test('WpggTokenPrice.fromDexScreenerPair parses pair fields', () {
    final price = WpggTokenPrice.fromDexScreenerPair({
      'priceUsd': '0.001234',
      'priceChange': {'h24': 5.67},
      'volume': {'h24': 12500},
      'liquidity': {'usd': 89000.5},
    });

    expect(price.priceUsd, 0.001234);
    expect(price.priceChangeH24, 5.67);
    expect(price.volumeH24, 12500);
    expect(price.liquidityUsd, 89000.5);
  });

  test('WpggTokenPrice handles missing nested fields', () {
    final price = WpggTokenPrice.fromDexScreenerPair({});

    expect(price.priceUsd, 0);
    expect(price.priceChangeH24, 0);
    expect(price.volumeH24, 0);
    expect(price.liquidityUsd, 0);
  });
}
