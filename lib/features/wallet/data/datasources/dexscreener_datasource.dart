import 'package:dio/dio.dart';

import '../models/wpgg_token_price.dart';

/// Cliente para la API pública de DexScreener (sin API key).
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

  static const wpggGeckoTerminalUrl =
      'https://www.geckoterminal.com/polygon_pos/tokens/$wpggContractAddress';

  static const wpggCoinMarketCapUrl =
      'https://coinmarketcap.com/currencies/well-played-good-game/';

  static const wpggPolygonPairPath =
      '/latest/dex/pairs/polygon/0x7f9a8901c73c3f62777dac914491b98a03430f17';

  final Dio _dio;

  Future<WpggTokenPrice> fetchWpggPrice() async {
    final res = await _dio.get<Map<String, dynamic>>(
      'https://api.dexscreener.com$wpggPolygonPairPath',
    );
    final pairs = res.data?['pairs'] as List<dynamic>?;
    if (pairs == null || pairs.isEmpty) {
      throw Exception('DexScreener: no pairs in response');
    }
    final pair = pairs.first as Map<String, dynamic>;
    return WpggTokenPrice.fromDexScreenerPair(pair);
  }
}
