import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Garantiza `extra['withCredentials'] == true` en web (dio_web_adapter lee esto
/// antes que la propiedad del adapter).
class WebCredentialsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kIsWeb) {
      options.extra['withCredentials'] = true;
    }
    handler.next(options);
  }
}
