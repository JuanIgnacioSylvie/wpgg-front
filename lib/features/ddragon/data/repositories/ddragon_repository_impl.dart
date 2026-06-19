import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/ddragon_champion_info.dart';
import '../../domain/repositories/ddragon_repository.dart';
import '../datasources/ddragon_remote_datasource.dart';

class DDragonRepositoryImpl implements DDragonRepository {
  DDragonRepositoryImpl(this._remote);

  final DDragonRemoteDataSource _remote;

  @override
  Future<Either<Failure, Map<int, DDragonChampionInfo>>> getChampionCatalog(
    String version,
  ) async {
    try {
      final catalog = await _remote.fetchChampionCatalog(version);
      return Right(catalog);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getLatestVersion() async {
    try {
      final v = await _remote.fetchLatestVersion();
      return Right(v);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
