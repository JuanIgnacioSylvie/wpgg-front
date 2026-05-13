import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/ddragon_repository.dart';
import '../datasources/ddragon_remote_datasource.dart';

class DDragonRepositoryImpl implements DDragonRepository {
  DDragonRepositoryImpl(this._remote);

  final DDragonRemoteDataSource _remote;

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
