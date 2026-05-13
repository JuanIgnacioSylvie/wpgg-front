import 'package:dio/dio.dart';

/// Cliente mínimo para CDNs públicos (Data Dragon) sin auth del backend.
class CdnClient {
  CdnClient({String baseUrl = 'https://ddragon.leagueoflegends.com'}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
  }

  late final Dio _dio;

  Future<Response<T>> get<T>(String path) => _dio.get<T>(path);
}
