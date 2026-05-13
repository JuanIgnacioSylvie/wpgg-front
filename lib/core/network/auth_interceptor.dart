import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';
import 'auth_request_extra.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required Dio dio,
    required SecureStorage storage,
  })  : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final SecureStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[AuthRequestExtra.skipAuth] == true) {
      return handler.next(options);
    }
    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final opts = err.requestOptions;
    if (status != 401 || opts.extra[AuthRequestExtra.skipRefresh] == true) {
      return handler.next(err);
    }

    try {
      final refresh = await _dio.post<dynamic>(
        '/auth/refresh',
        options: Options(
          extra: {
            AuthRequestExtra.skipAuth: true,
            AuthRequestExtra.skipRefresh: true,
          },
        ),
      );
      final data = refresh.data;
      String? newToken;
      if (data is Map && data['accessToken'] is String) {
        newToken = data['accessToken'] as String;
      }
      if (newToken == null || newToken.isEmpty) {
        await _storage.clearSession();
        return handler.next(err);
      }
      await _storage.saveAccessToken(newToken);

      final retry = await _dio.fetch<dynamic>(
        opts.copyWith(
          headers: {
            ...opts.headers,
            'Authorization': 'Bearer $newToken',
          },
        ),
      );
      return handler.resolve(retry);
    } catch (_) {
      await _storage.clearSession();
      return handler.next(err);
    }
  }
}
