import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/oauth/riot_rso_fragment_parser.dart';
import '../../../../core/platform/strip_url_fragment.dart';
import '../../../../core/storage/secure_storage.dart';

/// Pantalla de aterrizaje tras `RIOT_RSO_SUCCESS_REDIRECT_URL`: lee el `#`, guarda tokens RSO
/// en [SecureStorage] y limpia el fragmento del historial.
class RiotRsoCallbackPage extends StatefulWidget {
  const RiotRsoCallbackPage({super.key});

  @override
  State<RiotRsoCallbackPage> createState() => _RiotRsoCallbackPageState();
}

class _RiotRsoCallbackPageState extends State<RiotRsoCallbackPage> {
  String? _status;
  var _done = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _consumeFragment());
  }

  Future<void> _consumeFragment() async {
    if (!kIsWeb) {
      setState(() {
        _status = 'El login con Riot por redirect solo está soportado en web.';
        _done = true;
      });
      return;
    }

    final fragment = Uri.base.fragment;
    final parsed = parseRiotRsoFragment(fragment);

    if (parsed.hasOAuthError) {
      final desc = parsed.oauthErrorDescription;
      setState(() {
        _status = desc != null && desc.isNotEmpty
            ? 'Riot: ${parsed.oauthError}: $desc'
            : 'Riot: ${parsed.oauthError}';
        _done = true;
      });
      stripUrlFragment();
      return;
    }

    final tokens = parsed.tokens;
    if (tokens == null) {
      setState(() {
        _status =
            'No hay tokens en la URL (# vacío o formato no reconocido). '
            'Revisá que el backend redirija con fragmento tipo '
            'access_token=…&refresh_token=… o JSON equivalente.';
        _done = true;
      });
      if (kIsWeb) stripUrlFragment();
      return;
    }

    final secure = sl<SecureStorage>();
    final access = tokens.accessToken;
    final refresh = tokens.refreshToken;
    if (access != null && access.isNotEmpty) {
      await secure.saveRiotRsoAccessToken(access);
    }
    if (refresh != null && refresh.isNotEmpty) {
      await secure.saveRiotRsoRefreshToken(refresh);
    }

    stripUrlFragment();

    if (!mounted) return;
    setState(() {
      _status = 'Cuenta Riot autenticada. Los tokens RSO quedaron guardados en el dispositivo '
          'para próximos pasos (p. ej. intercambio por sesión de app en el backend). '
          'El JWT de la app sigue siendo el de email/contraseña.';
      _done = true;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login Riot completado')),
    );

    Future<void>.delayed(const Duration(milliseconds: 400), () {
      if (mounted) context.go('/login');
    });
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
                  _status != null && _status!.startsWith('Riot:')
                      ? Icons.error_outline
                      : Icons.check_circle_outline,
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
                  onPressed: () => context.go('/login'),
                  child: const Text('Ir al inicio de sesión'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
