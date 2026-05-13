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

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final (user, token) = await _remote.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
      await _secure.saveAccessToken(token);
      await _secure.saveUserEmail(user.email);
      return Right(user);
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
  }) async {
    try {
      final (user, token) = await _remote.register(
        email: email,
        password: password,
      );
      await _secure.saveAccessToken(token);
      await _secure.saveUserEmail(user.email);
      return Right(user);
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
    final existing = await _secure.getAccessToken();
    if (existing == null || existing.isEmpty) {
      return const Left(AuthFailure('Sin sesión activa'));
    }
    try {
      final (user, token) = await _remote.refresh();
      await _secure.saveAccessToken(token);
      await _secure.saveUserEmail(user.email);
      return Right(user);
    } on AuthException catch (e) {
      await _secure.clearSession();
      return Left(AuthFailure(e.message));
    } catch (e) {
      await _secure.clearSession();
      return Left(ServerFailure(e.toString()));
    }
  }
}
