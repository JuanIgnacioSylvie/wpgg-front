import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
      final storedRefresh = await _storage.getAuthRefreshToken();
      final body = <String, dynamic>{};
      if (storedRefresh != null && storedRefresh.isNotEmpty) {
        body['refreshToken'] = storedRefresh;
      }
      final refresh = await _dio.post<dynamic>(
        '/auth/refresh',
        data: body.isEmpty ? const <String, dynamic>{} : body,
        options: Options(
          extra: {
            AuthRequestExtra.skipAuth: true,
            AuthRequestExtra.skipRefresh: true,
            if (kIsWeb) 'withCredentials': true,
          },
        ),
      );
      final data = refresh.data;
      String? newToken;
      String? newRefresh;
      if (data is Map) {
        final access = data['accessToken'];
        if (access is String && access.isNotEmpty) {
          newToken = access;
        }
        final r = data['refreshToken'] ?? data['refresh_token'];
        if (r is String && r.isNotEmpty) {
          newRefresh = r;
        }
      }
      if (newToken == null || newToken.isEmpty) {
        await _storage.clearSession();
        return handler.next(err);
      }
      await _storage.saveAccessToken(newToken);
      if (newRefresh != null && newRefresh.isNotEmpty) {
        await _storage.saveAuthRefreshToken(newRefresh);
      } else {
        await _storage.deleteAuthRefreshToken();
      }

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
