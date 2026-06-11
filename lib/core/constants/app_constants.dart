abstract final class AppConstants {
  /// Web: usá `https://` si la app corre en HTTPS (mixed content bloquea HTTP).
  /// Por defecto el cliente XHR envía cookies al API (`withCredentials` en el adapter
  /// y en `BaseOptions.extra` de [ApiClient]).
  ///
  /// Front en un dominio (p. ej. Vercel) y API en otro (Railway): las cookies del API
  /// deben llevar **SameSite=None; Secure** o el navegador no las manda en `fetch`/XHR
  /// y `/auth/refresh` responde 401 sin `Cookie`.
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

  /// Ruta SPA tras Riot OAuth: **`?riot_session=`** (código) → `POST /auth/riot-session`.
  /// Legacy: `?accessToken=` / `?refreshToken=`; errores `?error=` / `error_description=`.
  /// Railway: `RIOT_RSO_SUCCESS_REDIRECT_URL` = origen HTTPS del front **sin** `/ final` + este path.
  /// Ejemplo: `https://wpgg-front-dev.up.railway.app/auth/riot-callback`
  /// Local path strategy: `http://localhost:PUERTO/auth/riot-callback`
  static const String riotRsoWebSuccessPath = '/auth/riot-callback';

  /// Deep link tras Riot OAuth en móvil (`RIOT_RSO_MOBILE_SUCCESS_REDIRECT_URL` en el back).
  static const String riotRsoMobileCallbackScheme = 'wpgg';

  static const String riotRsoMobileCallbackUrl =
      '$riotRsoMobileCallbackScheme://auth/riot-callback';

  /// Query param con código de un solo uso para vincular Riot tras registro.
  static const String riotLinkPendingQueryParam = 'riot_link_pending';

  static const String keyAccessToken = 'access_token';
  static const String keyUserEmail = 'user_email';

  /// JWT refresh de la app (SPA / otro dominio sin cookie cross-site).
  static const String keyAuthRefreshToken = 'auth_refresh_token';

  /// Marca login reciente con Riot (para UX si falla auto-vinculación en el back).
  static const String keyRiotRsoJustLoggedIn = 'riot_rso_just_logged_in';

  /// Tokens RSO (solo si completás el flujo web); no son el JWT de la app.
  static const String keyRiotRsoAccessToken = 'riot_rso_access_token';
  static const String keyRiotRsoRefreshToken = 'riot_rso_refresh_token';
  static const String keyRiotRsoIdToken = 'riot_rso_id_token';

  /// Cloudflare Turnstile site key (public). Empty disables the widget in the client.
  static const String turnstileSiteKey = String.fromEnvironment(
    'WPGG_TURNSTILE_SITE_KEY',
    defaultValue: '',
  );

  /// FCM Web Push VAPID public key (Firebase Console → Cloud Messaging → Web Push certificates).
  static const String firebaseVapidKey = String.fromEnvironment(
    'WPGG_FIREBASE_VAPID_KEY',
    defaultValue: '',
  );
}
