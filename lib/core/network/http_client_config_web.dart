import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

/// En web, `withCredentials: true` obliga a CORS estricto (origen concreto, no `*`,
/// más `Access-Control-Allow-Credentials`). Si el backend no está preparado,
/// el navegador falla con `connectionError` / XHR onError.
void configureHttpClientAdapter(Dio dio) {
  final adapter = BrowserHttpClientAdapter();
  const withCreds = bool.fromEnvironment(
    'WPGG_WEB_CREDENTIALS',
    defaultValue: true,
  );
  adapter.withCredentials = withCreds;
  dio.httpClientAdapter = adapter;
}
