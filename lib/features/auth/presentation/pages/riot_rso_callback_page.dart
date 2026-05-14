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

/// Aterrizaje tras `RIOT_RSO_SUCCESS_REDIRECT_URL`: errores en `?error=`, sesión en cookies
/// httpOnly (sin `#`), o tokens legacy en el fragmento.
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
        final desc = parsed.oauthErrorDescription;
        setState(() {
          _status = _oauthErrorMessage(code, desc);
          _done = true;
        });
        stripOAuthReturnUrl();
        return;
      }

      final tokens = parsed.tokens;
      if (tokens != null) {
        final secure = sl<SecureStorage>();
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

      if (parsed.sessionFromCookiesOnly || tokens != null) {
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

      if (!mounted) return;
      setState(() {
        _savedSessionOk = true;
        _status = parsed.sessionFromCookiesOnly
            ? 'Sesión iniciada con Riot (cookies).'
            : 'Cuenta Riot autenticada; sesión de la app actualizada.';
        _done = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Riot completado')),
      );

      Future<void>.delayed(const Duration(milliseconds: 400), () {
        if (mounted) context.go('/dashboard');
      });
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
                      context.go(_savedSessionOk ? '/dashboard' : '/login'),
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
