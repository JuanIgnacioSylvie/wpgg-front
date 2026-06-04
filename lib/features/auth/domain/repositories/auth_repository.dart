import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    String? riotLinkPendingCode,
  });

  /// URL de autorización Riot para vincular cuenta (`GET /riot/rso/link`).
  Future<Either<Failure, String>> fetchRiotLinkAuthorizeUrl();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> refreshSession();

  /// `POST /auth/riot-session` con el valor de `?riot_session=`.
  Future<Either<Failure, UserEntity>> exchangeRiotSession({required String code});

  Future<Either<Failure, void>> requestPasswordReset({required String email});

  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String password,
  });
}
