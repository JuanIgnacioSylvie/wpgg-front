import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/riot_rso_entities.dart';
import '../../domain/repositories/riot_rso_repository.dart';
import '../datasources/riot_rso_remote_datasource.dart';

class RiotRsoRepositoryImpl implements RiotRsoRepository {
  RiotRsoRepositoryImpl(this._remote);

  final RiotRsoRemoteDataSource _remote;

  @override
  Future<Either<Failure, RiotRsoSignIn>> getSignIn({
    bool requestRedirect = false,
    String? loginHint,
    String? uiLocales,
  }) async {
    try {
      final r = await _remote.fetchSignIn(
        requestRedirect: requestRedirect,
        loginHint: loginHint,
        uiLocales: uiLocales,
      );
      return Right(r);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RiotRsoTokenBundle>> exchangeOAuthCallback({
    required String code,
    required String state,
    bool includeUserinfo = false,
  }) async {
    try {
      final r = await _remote.fetchOAuthCallback(
        code: code,
        state: state,
        includeUserinfo: includeUserinfo,
      );
      return Right(r);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RiotRsoTokenBundle>> refresh({
    required String refreshToken,
    String? scope,
  }) async {
    try {
      final r = await _remote.postRefresh(
        refreshToken: refreshToken,
        scope: scope,
      );
      return Right(r);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RiotRsoUserinfo>> userinfo({
    required String accessToken,
  }) async {
    try {
      final r = await _remote.postUserinfo(accessToken: accessToken);
      return Right(r);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
