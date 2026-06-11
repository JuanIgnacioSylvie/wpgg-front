import 'package:dio/dio.dart';

import '../crypto/encrypted_routes.dart';
import '../crypto/payload_crypto.dart';
import '../crypto/payload_crypto_key_store.dart';

const String payloadEncryptionSkipExtra = 'skipPayloadEncryption';

class PayloadEncryptionInterceptor extends Interceptor {
  PayloadEncryptionInterceptor(this._keyStore);

  final PayloadCryptoKeyStore _keyStore;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[payloadEncryptionSkipExtra] == true) {
      return handler.next(options);
    }

    final path = options.uri.path;
    if (!requiresEncryptedPayload(options.method, path)) {
      return handler.next(options);
    }

    try {
      final jwk = await _keyStore.getPublicJwk();
      final plain = _plainBody(options.data);
      options.data = encryptPayload(jwk, plain);
      options.headers['X-WPGG-Encrypted'] = '1';
      handler.next(options);
    } on PayloadCryptoKeyException catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: e,
          message: e.message,
        ),
      );
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: e,
          message: 'No se pudo cifrar la solicitud',
        ),
      );
    }
  }

  Map<String, dynamic> _plainBody(Object? data) {
    if (data == null) {
      return {};
    }
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    throw StateError('Encrypted routes require a JSON object body');
  }
}
