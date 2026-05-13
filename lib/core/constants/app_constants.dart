abstract final class AppConstants {
  /// Web: usá `https://` si la app corre en HTTPS (mixed content bloquea HTTP).
  /// Web + cookies: `flutter run -d chrome --dart-define=WPGG_WEB_CREDENTIALS=true`
  /// y el backend debe responder CORS con origen exacto (no `*`) y
  /// `Access-Control-Allow-Credentials: true`.
  static const String baseUrl = String.fromEnvironment(
    'WPGG_BASE_URL',
    defaultValue: 'https://wpgg-back-dev.up.railway.app',
  );

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);

  /// Región Riot por defecto en formularios (ej. vincular cuenta).
  static const String riotDefaultRegion = 'LA2';

  /// Prefijo Riot Sign On (rutas públicas, sin JWT de la app). Misma base que [baseUrl].
  static const String riotRsoPathPrefix = '/riot/rso';

  /// Callback OAuth del back; el `redirect_uri` real lo define `RIOT_RSO_REDIRECT_URI` en el servidor
  /// y debe coincidir con el cliente registrado en el portal de Riot (el front no lo inventa).
  static const String riotRsoOAuthCallbackPath = '$riotRsoPathPrefix/oauth2-callback';

  /// Ruta SPA donde el backend redirige tras OAuth (tokens en `#`, sin `id_token_claims` pesado).
  /// Railway: `RIOT_RSO_SUCCESS_REDIRECT_URL` = origen HTTPS del front **sin** `/ final` + este path.
  /// Ejemplo: `https://wpgg-front-dev.up.railway.app/auth/riot-callback`
  /// Local path strategy: `http://localhost:PUERTO/auth/riot-callback`
  static const String riotRsoWebSuccessPath = '/auth/riot-callback';

  static const String keyAccessToken = 'access_token';
  static const String keyUserEmail = 'user_email';

  /// Tokens RSO (solo si completás el flujo web); no son el JWT de la app.
  static const String keyRiotRsoAccessToken = 'riot_rso_access_token';
  static const String keyRiotRsoRefreshToken = 'riot_rso_refresh_token';
}
