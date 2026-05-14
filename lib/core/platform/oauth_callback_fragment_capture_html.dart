// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

/// Misma clave que `web/index.html` (script síncrono antes de Flutter).
const String _kOauthFragmentSessionKey = 'wpgg_oauth_fragment';

String? _captured;

bool _looksLikeRiotOAuthCallbackHash(String raw) =>
    raw.contains('access_token=') ||
    raw.contains('id_token=') ||
    raw.contains('refresh_token=') ||
    raw.contains('error=');

/// Debe llamarse en [main] **antes** de [WidgetsFlutterBinding.ensureInitialized] y
/// [configureUrlStrategy]: el engine puede hacer `replaceState` y vaciar el `#` con los tokens.
void captureOauthCallbackFragmentAtAppStart() {
  try {
    final stored = html.window.sessionStorage[_kOauthFragmentSessionKey];
    if (stored != null && _looksLikeRiotOAuthCallbackHash(stored)) {
      _captured = stored;
    }
  } catch (_) {}

  final h = html.window.location.hash;
  if (h.length > 1) {
    final raw = h.substring(1);
    if (_looksLikeRiotOAuthCallbackHash(raw)) {
      _captured = raw;
    }
  }
}

String? get capturedOauthCallbackFragment => _captured;

void clearCapturedOauthCallbackFragment() {
  _captured = null;
  try {
    html.window.sessionStorage.remove(_kOauthFragmentSessionKey);
  } catch (_) {}
}
