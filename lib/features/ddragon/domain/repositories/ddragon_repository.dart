import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/ddragon_champion_info.dart';

abstract class DDragonRepository {
  Future<Either<Failure, String>> getLatestVersion();

  Future<Either<Failure, Map<int, DDragonChampionInfo>>> getChampionCatalog(
    String version,
  );
}
