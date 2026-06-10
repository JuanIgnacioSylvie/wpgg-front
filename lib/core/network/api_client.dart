import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/app_constants.dart';
import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';
import 'http_client_config.dart';
import 'web_credentials_interceptor.dart';

Map<String, String> _defaultHeaders() {
  return {
    'Content-Type': 'application/json',
    'X-WPGG-Platform': kIsWeb ? 'web' : 'mobile',
  };
}

class ApiClient {
  ApiClient({
    required String baseUrl,
    required SecureStorage secureStorage,
  }) : _secureStorage = secureStorage {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: _defaultHeaders(),
        // Web (dio_web_adapter): fuerza credenciales en cada XHR; sin esto algunos
        // builds pueden no enviar cookies cross-origin aunque el adapter tenga withCredentials.
        extra: const {'withCredentials': true},
      ),
    );

    configureHttpClientAdapter(_dio);

    if (!kIsWeb) {
      final jar = CookieJar();
      _dio.interceptors.add(CookieManager(jar));
    }

    if (kIsWeb) {
      _dio.interceptors.add(WebCredentialsInterceptor());
    }

    _dio.interceptors.addAll([
      AuthInterceptor(dio: _dio, storage: _secureStorage),
      PrettyDioLogger(requestBody: true, responseBody: true),
    ]);
  }

  final SecureStorage _secureStorage;
  late final Dio _dio;

  Dio get raw => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Options? options,
  }) {
    return _dio.post<T>(path, data: data, options: options);
  }
}
