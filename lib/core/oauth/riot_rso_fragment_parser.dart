import 'dart:convert';

import '../../features/auth/domain/entities/riot_rso_entities.dart';

/// Resultado de parsear el redirect del backend (query y/o fragmento `#...`).
class RiotRsoFragmentParseResult {
  const RiotRsoFragmentParseResult({
    this.tokens,
    this.oauthError,
    this.oauthErrorDescription,
    this.sessionFromCookiesOnly = false,
    this.riotSessionCode,
  });

  static const RiotRsoFragmentParseResult empty = RiotRsoFragmentParseResult();

  factory RiotRsoFragmentParseResult.oauthError({
    required String error,
    String? description,
  }) =>
      RiotRsoFragmentParseResult(
        oauthError: error,
        oauthErrorDescription: description,
      );

  factory RiotRsoFragmentParseResult.success(RiotRsoTokenBundle tokens) =>
      RiotRsoFragmentParseResult(tokens: tokens);

  final RiotRsoTokenBundle? tokens;
  final String? oauthError;
  final String? oauthErrorDescription;

  /// Sin tokens en el hash ni `?error=…` ni `?riot_session=…`: sesión wpgg solo vía cookies.
  final bool sessionFromCookiesOnly;

  /// Código de un solo uso del back (`?riot_session=`) para `POST /auth/riot-session`.
  final String? riotSessionCode;

  bool get hasOAuthError => oauthError != null && oauthError!.isNotEmpty;

  bool get hasRiotSessionCode =>
      riotSessionCode != null && riotSessionCode!.isNotEmpty;
}

/// Tras el redirect del backend a la ruta SPA.
///
/// 1. Errores OAuth en **query** (`?error=` / `error_description=`), p. ej. Riot o `rso_no_subject`.
/// 2. **`?riot_session=`** (código de un solo uso) → canje con `POST /auth/riot-session`.
/// 3. Tokens legacy en el **fragmento** (`#access_token=…`).
/// 4. Si no hay error ni código ni tokens: sesión solo en cookies httpOnly (sin hash).
RiotRsoFragmentParseResult parseRiotRsoCallbackUri(Uri uri) {
  final q = Uri.splitQueryString(uri.query);
  final lowerQ = <String, String>{
    for (final e in q.entries) e.key.toLowerCase(): e.value,
  };
  final qErr = lowerQ['error'];
  if (qErr != null && qErr.isNotEmpty) {
    return RiotRsoFragmentParseResult.oauthError(
      error: qErr,
      description: lowerQ['error_description'],
    );
  }

  final riotSession = lowerQ['riot_session'];
  if (riotSession != null && riotSession.isNotEmpty) {
    return RiotRsoFragmentParseResult(riotSessionCode: riotSession);
  }

  final frag = parseRiotRsoFragment(uri.fragment);
  if (frag.hasOAuthError) return frag;
  if (frag.tokens != null) {
    return RiotRsoFragmentParseResult.success(frag.tokens!);
  }
  return const RiotRsoFragmentParseResult(sessionFromCookiesOnly: true);
}

/// Soporta:
/// - `application/x-www-form-urlencoded` (`access_token=...&refresh_token=...`)
/// - JSON (`{ "access_token": "..." }`), opcionalmente [Uri]-encoded.
///
/// No incluye `id_token_claims` en el fragmento (lo acordás con el backend); el front puede
/// decodificar el `id_token` (JWT) si hace falta.
RiotRsoFragmentParseResult parseRiotRsoFragment(String rawFragment) {
  final trimmed = rawFragment.trim();
  if (trimmed.isEmpty) {
    return RiotRsoFragmentParseResult.empty;
  }

  var payload = trimmed;
  if (payload.contains('%')) {
    try {
      payload = Uri.decodeFull(payload);
    } catch (_) {
      /* seguir con original */
    }
  }

  if (payload.startsWith('{')) {
    return _fromJsonMap(payload);
  }

  return _fromQueryString(payload);
}

RiotRsoFragmentParseResult _fromJsonMap(String jsonStr) {
  try {
    final decoded = jsonDecode(jsonStr);
    if (decoded is! Map) {
      return RiotRsoFragmentParseResult.empty;
    }
    final map = Map<String, dynamic>.from(decoded);
    final err = _readString(map, const ['error', 'Error']);
    if (err != null && err.isNotEmpty) {
      return RiotRsoFragmentParseResult.oauthError(
        error: err,
        description: _readString(map, const ['error_description', 'errorDescription']),
      );
    }
    final bundle = _bundleFromMap(map);
    if (_hasAnyToken(bundle)) {
      return RiotRsoFragmentParseResult.success(bundle);
    }
    return RiotRsoFragmentParseResult.empty;
  } catch (_) {
    return RiotRsoFragmentParseResult.empty;
  }
}

RiotRsoFragmentParseResult _fromQueryString(String fragment) {
  final map = Uri.splitQueryString(fragment);
  if (map.isEmpty) {
    return RiotRsoFragmentParseResult.empty;
  }

  final lower = <String, String>{
    for (final e in map.entries) e.key.toLowerCase(): e.value,
  };

  final err = lower['error'];
  if (err != null && err.isNotEmpty) {
    return RiotRsoFragmentParseResult.oauthError(
      error: err,
      description: lower['error_description'],
    );
  }

  final dynamicMap = <String, dynamic>{
    'access_token': lower['access_token'],
    'id_token': lower['id_token'],
    'refresh_token': lower['refresh_token'],
    'token_type': lower['token_type'],
    'scope': lower['scope'],
    'expires_in': lower['expires_in'],
  };

  final bundle = _bundleFromMap(dynamicMap);
  if (_hasAnyToken(bundle)) {
    return RiotRsoFragmentParseResult.success(bundle);
  }
  return RiotRsoFragmentParseResult.empty;
}

bool _hasAnyToken(RiotRsoTokenBundle b) =>
    (b.accessToken != null && b.accessToken!.isNotEmpty) ||
    (b.idToken != null && b.idToken!.isNotEmpty) ||
    (b.refreshToken != null && b.refreshToken!.isNotEmpty);

RiotRsoTokenBundle _bundleFromMap(Map<String, dynamic> map) {
  Map<String, dynamic>? claims;
  final rawClaims = map['id_token_claims'] ?? map['idTokenClaims'];
  if (rawClaims is Map) {
    claims = Map<String, dynamic>.from(rawClaims);
  }

  final expires = map['expires_in'] ?? map['expiresIn'];
  return RiotRsoTokenBundle(
    scope: map['scope'] as String?,
    expiresIn: expires is int ? expires : int.tryParse('$expires'),
    tokenType: map['token_type'] as String? ?? map['tokenType'] as String?,
    subSid: map['sub_sid'] as String? ?? map['subSid'] as String?,
    accessToken: map['access_token'] as String? ?? map['accessToken'] as String?,
    idToken: map['id_token'] as String? ?? map['idToken'] as String?,
    refreshToken:
        map['refresh_token'] as String? ?? map['refreshToken'] as String?,
    idTokenClaims: claims,
    userinfo: null,
    raw: map,
  );
}

String? _readString(Map<String, dynamic> map, List<String> keys) {
  for (final k in keys) {
    if (map.containsKey(k)) {
      final v = map[k];
      if (v is String && v.isNotEmpty) return v;
    }
  }
  return null;
}
