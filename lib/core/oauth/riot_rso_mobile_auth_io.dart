import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import '../constants/app_constants.dart';
import 'riot_rso_fragment_parser.dart';
import 'riot_rso_mobile_auth_result.dart';

/// Abre el flujo RSO y espera el deep link `wpgg://auth/riot-callback?...`.
Future<RiotRsoMobileAuthResult> authenticateRiotRsoMobile(String signInUrl) async {
  try {
    final callbackUrl = await FlutterWebAuth2.authenticate(
      url: signInUrl,
      callbackUrlScheme: AppConstants.riotRsoMobileCallbackScheme,
    );
    return _parseCallbackUrl(callbackUrl);
  } on PlatformException catch (e) {
    if (e.code == 'CANCELED') {
      return const RiotRsoMobileAuthResult(cancelled: true);
    }
    rethrow;
  }
}

RiotRsoMobileAuthResult _parseCallbackUrl(String callbackUrl) {
  final uri = Uri.parse(callbackUrl);
  final parsed = parseRiotRsoCallbackUri(uri);
  final q = Uri.splitQueryString(uri.query);
  final lowerQ = <String, String>{
    for (final e in q.entries) e.key.toLowerCase(): e.value,
  };
  final riotLinkPending = lowerQ['riot_link_pending'];

  if (parsed.hasOAuthError) {
    return RiotRsoMobileAuthResult(
      oauthError: parsed.oauthError,
      oauthErrorDescription: parsed.oauthErrorDescription,
      riotLinkPendingCode: riotLinkPending,
    );
  }

  if (parsed.hasRiotSessionCode) {
    return RiotRsoMobileAuthResult(riotSessionCode: parsed.riotSessionCode);
  }

  return const RiotRsoMobileAuthResult(
    oauthError: 'missing_riot_session',
    oauthErrorDescription:
        'No se recibió código de sesión tras el login con Riot.',
  );
}
