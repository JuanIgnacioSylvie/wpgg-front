import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/riot_rso_entities.dart';

/// Riot Sign On: rutas públicas bajo `/riot/rso` (sin JWT de la app).
abstract class RiotRsoRepository {
  /// [GET /riot/rso/sign-in] — devuelve URL de autorización y state.
  Future<Either<Failure, RiotRsoSignIn>> getSignIn({
    bool requestRedirect = false,
    String? loginHint,
    String? uiLocales,
  });

  /// [GET /riot/rso/oauth2-callback] — intercambio de `code` + `state` (mismo host que el API).
  Future<Either<Failure, RiotRsoTokenBundle>> exchangeOAuthCallback({
    required String code,
    required String state,
    bool includeUserinfo = false,
  });

  /// [POST /riot/rso/refresh]
  Future<Either<Failure, RiotRsoTokenBundle>> refresh({
    required String refreshToken,
    String? scope,
  });

  /// [POST /riot/rso/userinfo]
  Future<Either<Failure, RiotRsoUserinfo>> userinfo({
    required String accessToken,
  });
}
