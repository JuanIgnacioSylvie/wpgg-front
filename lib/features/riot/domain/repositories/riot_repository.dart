import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/match_entity.dart';
import '../entities/ranked_entry_entity.dart';
import '../entities/summoner_entity.dart';

abstract class RiotRepository {
  Future<Either<Failure, SummonerEntity?>> getSummonerProfile();

  Future<Either<Failure, List<MatchEntity>>> getMatchHistory({int limit});

  Future<Either<Failure, List<RankedEntryEntity>>> getRankedStats();

  Future<Either<Failure, SummonerEntity>> linkRiotAccount({
    required String gameName,
    required String tagLine,
    required String region,
  });
}
