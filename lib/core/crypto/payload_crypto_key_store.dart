import 'package:dio/dio.dart';

import 'payload_crypto.dart';

/// Fetches and caches the API RSA public key (JWK) for request encryption.
class PayloadCryptoKeyStore {
  PayloadCryptoKeyStore(this._dio);

  final Dio _dio;
  Map<String, dynamic>? _jwk;
  Future<Map<String, dynamic>>? _loading;

  Future<Map<String, dynamic>> getPublicJwk() {
    final cached = _jwk;
    if (cached != null) {
      return Future.value(cached);
    }
    return _loading ??= _fetch();
  }

  void clear() {
    _jwk = null;
    _loading = null;
  }

  Future<Map<String, dynamic>> _fetch() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/crypto/public-key',
        options: Options(extra: const {'skipPayloadEncryption': true}),
      );
      final data = res.data;
      final jwk = data?['jwk'];
      if (jwk is! Map) {
        throw const PayloadCryptoKeyException('Invalid public key response');
      }
      final map = Map<String, dynamic>.from(jwk);
      if (map['kty'] != 'RSA' || map['n'] == null || map['e'] == null) {
        throw const PayloadCryptoKeyException('Unsupported public key format');
      }
      if ((data?['v'] as int?) != payloadCryptoVersion) {
        throw const PayloadCryptoKeyException('Unsupported crypto version');
      }
      _jwk = map;
      return map;
    } on DioException catch (e) {
      throw PayloadCryptoKeyException(
        e.message ?? 'Could not load encryption public key',
      );
    } finally {
      _loading = null;
    }
  }
}

class PayloadCryptoKeyException implements Exception {
  const PayloadCryptoKeyException(this.message);

  final String message;

  @override
  String toString() => message;
}
