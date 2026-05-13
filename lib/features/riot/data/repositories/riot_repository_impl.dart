import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/ranked_entry_entity.dart';
import '../../domain/entities/summoner_entity.dart';
import '../../domain/repositories/riot_repository.dart';
import '../datasources/riot_remote_datasource.dart';
import '../models/match_model.dart';
import '../models/ranked_entry_model.dart';
import '../models/summoner_model.dart';

class RiotRepositoryImpl implements RiotRepository {
  RiotRepositoryImpl(this._remote);

  final RiotRemoteDataSource _remote;

  @override
  Future<Either<Failure, SummonerEntity?>> getSummonerProfile() async {
    final res = await _remote.fetchSummoner();
    return res.fold(
      (e) => Left(ServerFailure(e.message)),
      (opt) => opt.fold(
        () => const Right(null),
        (json) => Right(SummonerModel.fromJson(json)),
      ),
    );
  }

  @override
  Future<Either<Failure, List<MatchEntity>>> getMatchHistory({
    int limit = 10,
  }) async {
    try {
      final raw = await _remote.fetchMatches(limit);
      final list = raw
          .whereType<Map>()
          .map((e) => MatchModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RankedEntryEntity>>> getRankedStats() async {
    try {
      final raw = await _remote.fetchRanked();
      final list = raw
          .whereType<Map>()
          .map((e) => RankedEntryModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SummonerEntity>> linkRiotAccount({
    required String gameName,
    required String tagLine,
    required String region,
  }) async {
    try {
      final json = await _remote.linkAccount(
        gameName: gameName,
        tagLine: tagLine,
        region: region,
      );
      return Right(SummonerModel.fromJson(json));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
