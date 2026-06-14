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

  test('WpggTokenPrice.fromGeckoTerminalPool parses pool fields', () {
    final price = WpggTokenPrice.fromGeckoTerminalPool({
      'attributes': {
        'base_token_price_usd': '0.00153396447287921',
        'price_change_percentage': {'h24': '-2.5'},
        'volume_usd': {'h24': '125.4'},
        'reserve_in_usd': '374.571',
      },
    });

    expect(price.priceUsd, closeTo(0.00153396447287921, 0.0000001));
    expect(price.priceChangeH24, -2.5);
    expect(price.volumeH24, 125.4);
    expect(price.liquidityUsd, 374.571);
  });

  test('WpggTokenPrice.fromCoinGeckoToken parses token fields', () {
    final price = WpggTokenPrice.fromCoinGeckoToken({
      'usd': 0.00153,
      'usd_24h_change': 1.25,
      'usd_24h_vol': 500.0,
    });

    expect(price.priceUsd, 0.00153);
    expect(price.priceChangeH24, 1.25);
    expect(price.volumeH24, 500);
    expect(price.liquidityUsd, 0);
  });
}
