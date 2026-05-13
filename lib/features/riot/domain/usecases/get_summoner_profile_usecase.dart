import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/summoner_entity.dart';
import '../repositories/riot_repository.dart';

class GetSummonerProfileUseCase {
  GetSummonerProfileUseCase(this._repository);

  final RiotRepository _repository;

  Future<Either<Failure, SummonerEntity?>> call() {
    return _repository.getSummonerProfile();
  }
}
