import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class DDragonRepository {
  Future<Either<Failure, String>> getLatestVersion();

  Future<Either<Failure, Map<int, String>>> getChampionKeys(String version);
}
