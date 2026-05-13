import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/ranked_entry_entity.dart';
import '../repositories/riot_repository.dart';

class GetRankedStatsUseCase {
  GetRankedStatsUseCase(this._repository);

  final RiotRepository _repository;

  Future<Either<Failure, List<RankedEntryEntity>>> call() {
    return _repository.getRankedStats();
  }
}
