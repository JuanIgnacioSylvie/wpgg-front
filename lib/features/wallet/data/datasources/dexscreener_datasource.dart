import 'package:dio/dio.dart';

import '../models/wpgg_token_price.dart';

/// Live WPGG price: DexScreener → GeckoTerminal (pool on Polygon).
class DexScreenerDataSource {
  DexScreenerDataSource({
    Dio? dio,
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 15),
              ),
            );

  static const wpggContractAddress =
      '0x1226A2972e5F8b5aEF7B7381cEA1AE8Ce3B2b188';

  static const wpggPolygonPoolAddress =
      '0x7f9a8901c73c3f62777dac914491b98a03430f17';

  static const wpggGeckoTerminalUrl =
      'https://www.geckoterminal.com/polygon_pos/tokens/$wpggContractAddress';

  static const wpggCoinMarketCapUrl =
      'https://coinmarketcap.com/currencies/well-played-good-game/';

  static const _dexScreenerPairUrl =
      'https://api.dexscreener.com/latest/dex/pairs/polygon/$wpggPolygonPoolAddress';

  static const _geckoTerminalPoolUrl =
      'https://api.geckoterminal.com/api/v2/networks/polygon_pos/pools/$wpggPolygonPoolAddress';

  final Dio _dio;

  Future<WpggTokenPrice> fetchWpggPrice() async {
    try {
      return await _fetchFromDexScreener();
    } catch (dexError) {
      try {
        return await _fetchFromGeckoTerminal();
      } catch (geckoError) {
        throw Exception(
          'Unable to fetch WPGG price: $dexError; $geckoError',
        );
      }
    }
  }

  Future<WpggTokenPrice> _fetchFromDexScreener() async {
    final res = await _dio.get<Map<String, dynamic>>(_dexScreenerPairUrl);
    final pairs = res.data?['pairs'] as List<dynamic>?;
    if (pairs == null || pairs.isEmpty) {
      throw Exception('DexScreener: no pairs in response');
    }
    final pair = pairs.first as Map<String, dynamic>;
    return WpggTokenPrice.fromDexScreenerPair(pair);
  }

  Future<WpggTokenPrice> _fetchFromGeckoTerminal() async {
    final res = await _dio.get<Map<String, dynamic>>(_geckoTerminalPoolUrl);
    final pool = res.data?['data'] as Map<String, dynamic>?;
    if (pool == null) {
      throw Exception('GeckoTerminal: no pool data in response');
    }
    return WpggTokenPrice.fromGeckoTerminalPool(pool);
  }
}
