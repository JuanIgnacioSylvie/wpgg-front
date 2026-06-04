import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorage secureStorage,
  })  : _remote = remoteDataSource,
        _secure = secureStorage;

  final AuthRemoteDataSource _remote;
  final SecureStorage _secure;

  Future<void> _persistAuthSession(AuthRemoteSession session) async {
    await _secure.saveAccessToken(session.accessToken);
    final r = session.refreshToken;
    if (r != null && r.isNotEmpty) {
      await _secure.saveAuthRefreshToken(r);
    } else {
      await _secure.deleteAuthRefreshToken();
    }
    await _secure.saveUserEmail(session.user.email);
  }

  /// Tras [POST /auth/refresh]: si el JSON no trae `refreshToken`, no borramos el que
  /// ya estaba guardado (sigue sirviendo para el body en la próxima renovación).
  Future<void> _persistAuthSessionAfterRefresh(
    AuthRemoteSession session, {
    required String? refreshSent,
  }) async {
    await _secure.saveAccessToken(session.accessToken);
    final r = session.refreshToken;
    if (r != null && r.isNotEmpty) {
      await _secure.saveAuthRefreshToken(r);
    } else if (refreshSent == null || refreshSent.isEmpty) {
      await _secure.deleteAuthRefreshToken();
    }
    await _secure.saveUserEmail(session.user.email);
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final session = await _remote.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
      await _persistAuthSession(session);
      return Right(session.user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    String? riotLinkPendingCode,
  }) async {
    try {
      final session = await _remote.register(
        email: email,
        password: password,
        riotLinkPendingCode: riotLinkPendingCode,
      );
      await _persistAuthSession(session);
      return Right(session.user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remote.logout();
      await _secure.clearSession();
      return const Right(null);
    } on ServerException catch (e) {
      await _secure.clearSession();
      return Left(ServerFailure(e.message));
    } catch (e) {
      await _secure.clearSession();
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> refreshSession() async {
    try {
      final storedRefresh = await _secure.getAuthRefreshToken();
      final session = await _remote.refresh(refreshToken: storedRefresh);
      await _persistAuthSessionAfterRefresh(
        session,
        refreshSent: storedRefresh,
      );
      return Right(session.user);
    } on AuthException catch (e) {
      await _secure.clearSession();
      return Left(AuthFailure(e.message));
    } catch (e) {
      await _secure.clearSession();
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> fetchRiotLinkAuthorizeUrl() async {
    try {
      final url = await _remote.fetchRiotLinkAuthorizeUrl();
      return Right(url);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> exchangeRiotSession({
    required String code,
  }) async {
    try {
      final session = await _remote.exchangeRiotSession(code: code);
      await _persistAuthSession(session);
      return Right(session.user);
    } on AuthException catch (e) {
      await _secure.clearSession();
      return Left(AuthFailure(e.message));
    } catch (e) {
      await _secure.clearSession();
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset({
    required String email,
  }) async {
    try {
      await _remote.requestPasswordReset(email: email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String password,
  }) async {
    try {
      await _remote.resetPassword(token: token, password: password);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
