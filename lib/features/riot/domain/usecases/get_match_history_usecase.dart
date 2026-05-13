import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/match_entity.dart';
import '../repositories/riot_repository.dart';

class GetMatchHistoryUseCase {
  GetMatchHistoryUseCase(this._repository);

  final RiotRepository _repository;

  Future<Either<Failure, List<MatchEntity>>> call({int limit = 10}) {
    return _repository.getMatchHistory(limit: limit);
  }
}
