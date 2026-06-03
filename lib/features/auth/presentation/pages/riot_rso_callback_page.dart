import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/oauth/riot_rso_fragment_parser.dart';
import '../../../../core/platform/browser_oauth_uri.dart';
import '../../../../core/platform/oauth_callback_fragment_capture.dart';
import '../../../../core/platform/strip_url_fragment.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/repositories/auth_repository.dart';

/// Aterrizaje tras `RIOT_RSO_SUCCESS_REDIRECT_URL`.
///
/// Prioridad: `?error=` (p. ej. `riot_session_unavailable`, `rso_no_subject`) →
/// `?riot_session=` → **solo** [POST /auth/riot-session] (sin `/auth/refresh` en ese paso).
/// Luego query/`#` legacy; [POST /auth/refresh] si falta `accessToken` en query y (**refresh
/// WPGG en almacén/URL** o **redirect “solo cookies”** del parser: el back puede haber fijado
/// cookies HttpOnly en el **origen del API**, enviadas con `withCredentials` aunque JS no las lea).
class RiotRsoCallbackPage extends StatefulWidget {
  const RiotRsoCallbackPage({super.key});

  @override
  State<RiotRsoCallbackPage> createState() => _RiotRsoCallbackPageState();
}

class _RiotRsoCallbackPageState extends State<RiotRsoCallbackPage> {
  String? _status;
  var _done = false;
  var _savedSessionOk = false;

  Uri? _oauthLocationUri;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _oauthLocationUri = browserOAuthLocationUri();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleRedirect());
  }

  String _oauthErrorMessage(String code, String? desc) {
    if (code == 'riot_session_unavailable') {
      final tail = desc != null && desc.isNotEmpty ? '\n\nDetalle del servidor: $desc' : '';
      return 'No se pudo generar el enlace de sesión (riot_session). Suele ser un '
          'problema temporal del servidor o de la base de datos (p. ej. migraciones '
          'pendientes). Quien opera el back debería revisar logs, aplicar '
          '`prisma migrate deploy` si corresponde y volver a intentar. '
          'Podés reintentar el login con Riot cuando esté resuelto.$tail';
    }
    if (code == 'rso_no_subject') {
      return desc != null && desc.isNotEmpty
          ? 'El servidor no pudo obtener tu identidad de Riot: $desc'
          : 'El servidor no pudo obtener tu identidad de Riot (rso_no_subject). '
              'Probá iniciar sesión de nuevo.';
    }
    if (desc != null && desc.isNotEmpty) {
      return 'Error: $code — $desc';
    }
    return 'Error: $code';
  }

  String _missingWpggSessionHint() {
    return 'La app no tiene JWT de WPGG (ni en la URL ni guardado). Si solo hay '
        'tokens Riot en `#`, falta un paso del back (`?riot_session=` → POST '
        '/auth/riot-session) o tokens de la app en query.';
  }

  Future<void> _finishSuccess({required String statusLine}) async {
    await sl<SecureStorage>().markRiotRsoJustLoggedIn();
    if (!mounted) return;
    setState(() {
      _savedSessionOk = true;
      _status = statusLine;
      _done = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login Riot completado')),
    );
    Future<void>.delayed(const Duration(milliseconds: 400), () {
      if (mounted) context.go('/home');
    });
  }

  Future<void> _handleRedirect() async {
    try {
      assert(() {
        if (kIsWeb) {
          final href = _oauthLocationUri ?? browserOAuthLocationUri();
          // ignore: avoid_print
          print('href (window.location): ${href.toString()}');
          // ignore: avoid_print
          print('fragment (window): "${href.fragment}"');
          // ignore: avoid_print
          print('query (window): "${href.query}"');
          // ignore: avoid_print
          print('Uri.base (Flutter): ${Uri.base}');
        }
        return true;
      }());

      if (!kIsWeb) {
        setState(() {
          _status = 'El login con Riot por redirect solo está soportado en web.';
          _done = true;
        });
        return;
      }

      final locationUri = _oauthLocationUri ?? browserOAuthLocationUri();
      final parsed = parseRiotRsoCallbackUri(locationUri);

      if (parsed.hasOAuthError) {
        final code = parsed.oauthError ?? 'unknown';
        stripOAuthReturnUrl();
        if (code == 'user_not_found') {
          if (!mounted) return;
          context.go('/login?riot_not_found=1');
          return;
        }
        if (code == 'user_already_exists') {
          if (!mounted) return;
          context.go('/login?riot_already_exists=1');
          return;
        }
        final desc = parsed.oauthErrorDescription;
        setState(() {
          _status = _oauthErrorMessage(code, desc);
          _done = true;
        });
        return;
      }

      if (parsed.hasRiotSessionCode) {
        final exchanged = await sl<AuthRepository>().exchangeRiotSession(
          code: parsed.riotSessionCode!,
        );
        final failMsg = exchanged.fold<String?>(
          (f) => f.message,
          (_) => null,
        );
        stripOAuthReturnUrl();
        if (failMsg != null) {
          if (!mounted) return;
          setState(() {
            _savedSessionOk = false;
            _status = failMsg;
            _done = true;
          });
          return;
        }
        await _finishSuccess(
          statusLine: 'Sesión WPGG vía canje Riot (riot_session).',
        );
        return;
      }

      final secure = sl<SecureStorage>();
      final q = Uri.splitQueryString(locationUri.query);
      final qAccess = q['accessToken'] ?? q['access_token'];
      final qRefresh = q['refreshToken'] ?? q['refresh_token'];
      if (qAccess != null && qAccess.isNotEmpty) {
        await secure.saveAccessToken(qAccess);
      }
      if (qRefresh != null && qRefresh.isNotEmpty) {
        await secure.saveAuthRefreshToken(qRefresh);
      }

      final tokens = parsed.tokens;
      if (tokens != null) {
        final access = tokens.accessToken;
        final refresh = tokens.refreshToken;
        final idToken = tokens.idToken;
        if (access != null && access.isNotEmpty) {
          await secure.saveRiotRsoAccessToken(access);
        }
        if (refresh != null && refresh.isNotEmpty) {
          await secure.saveRiotRsoRefreshToken(refresh);
        }
        if (idToken != null && idToken.isNotEmpty) {
          await secure.saveRiotRsoIdToken(idToken);
        }
      }

      stripOAuthReturnUrl();

      final haveAppAccessFromQuery =
          qAccess != null && qAccess.isNotEmpty;
      final storedWpggRefresh = await secure.getAuthRefreshToken();
      final haveWpggRefresh = storedWpggRefresh != null &&
          storedWpggRefresh.isNotEmpty;
      // HttpOnly cookies del API no aparecen en SecureStorage; igual se envían
      // a /auth/refresh con withCredentials cuando el redirect viene "limpio".
      final shouldCallRefresh = !haveAppAccessFromQuery &&
          (haveWpggRefresh || parsed.sessionFromCookiesOnly);

      if (shouldCallRefresh) {
        final hydrated = await sl<AuthRepository>().refreshSession();
        final failMsg = hydrated.fold<String?>(
          (f) => f.message,
          (_) => null,
        );
        if (failMsg != null) {
          if (!mounted) return;
          setState(() {
            _savedSessionOk = false;
            _status = failMsg;
            _done = true;
          });
          return;
        }
      }

      if (!haveAppAccessFromQuery) {
        final access = await secure.getAccessToken();
        if (access == null || access.isEmpty) {
          if (!mounted) return;
          setState(() {
            _savedSessionOk = false;
            _status = _missingWpggSessionHint();
            _done = true;
          });
          return;
        }
      }

      await _finishSuccess(
        statusLine: haveAppAccessFromQuery
            ? 'Sesión iniciada con Riot (tokens en la URL).'
            : parsed.sessionFromCookiesOnly
                ? 'Sesión iniciada con Riot (cookies).'
                : 'Cuenta Riot autenticada; sesión de la app actualizada.',
      );
    } finally {
      clearCapturedOauthCallbackFragment();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Riot')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_done) const CircularProgressIndicator(),
              if (_done) ...[
                Icon(
                  _savedSessionOk
                      ? Icons.check_circle_outline
                      : Icons.error_outline,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  _status ?? '',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () =>
                      context.go(_savedSessionOk ? '/home' : '/login'),
                  child: Text(
                    _savedSessionOk ? 'Ir al panel' : 'Ir al inicio de sesión',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
