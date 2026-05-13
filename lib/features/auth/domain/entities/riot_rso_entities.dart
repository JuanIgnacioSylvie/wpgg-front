import 'package:equatable/equatable.dart';

/// Respuesta de [GET /riot/rso/sign-in].
class RiotRsoSignIn extends Equatable {
  const RiotRsoSignIn({
    required this.authorizeUrl,
    required this.state,
  });

  final String authorizeUrl;
  final String state;

  @override
  List<Object?> get props => [authorizeUrl, state];
}

/// Tokens (y opcionalmente userinfo) tras el callback o refresh RSO.
class RiotRsoTokenBundle extends Equatable {
  const RiotRsoTokenBundle({
    this.scope,
    this.expiresIn,
    this.tokenType,
    this.subSid,
    this.accessToken,
    this.idToken,
    this.refreshToken,
    this.idTokenClaims,
    this.userinfo,
    this.raw,
  });

  final String? scope;
  final int? expiresIn;
  final String? tokenType;
  final String? subSid;
  final String? accessToken;
  final String? idToken;
  final String? refreshToken;
  final Map<String, dynamic>? idTokenClaims;
  final Map<String, dynamic>? userinfo;

  /// Campos adicionales del backend sin mapear explícitamente.
  final Map<String, dynamic>? raw;

  @override
  List<Object?> get props => [
        scope,
        expiresIn,
        tokenType,
        subSid,
        accessToken,
        idToken,
        refreshToken,
        idTokenClaims,
        userinfo,
        raw,
      ];
}

/// Respuesta de [POST /riot/rso/userinfo].
class RiotRsoUserinfo extends Equatable {
  const RiotRsoUserinfo({
    required this.sub,
    this.cpid,
  });

  final String sub;
  final String? cpid;

  @override
  List<Object?> get props => [sub, cpid];
}
