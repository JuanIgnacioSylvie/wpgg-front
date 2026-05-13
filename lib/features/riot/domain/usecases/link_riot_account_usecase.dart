import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/summoner_entity.dart';
import '../repositories/riot_repository.dart';

class LinkRiotAccountUseCase {
  LinkRiotAccountUseCase(this._repository);

  final RiotRepository _repository;

  Future<Either<Failure, SummonerEntity>> call({
    required String gameName,
    required String tagLine,
    required String region,
  }) {
    return _repository.linkRiotAccount(
      gameName: gameName,
      tagLine: tagLine,
      region: region,
    );
  }
}
