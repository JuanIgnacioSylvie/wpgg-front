import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';

abstract class RiotRemoteDataSource {
  /// [Right(None)] = sin cuenta vinculada (404). [Right(Some)] = JSON summoner.
  Future<Either<ServerException, Option<Map<String, dynamic>>>> fetchSummoner();

  Future<List<dynamic>> fetchMatches(int limit);

  Future<List<dynamic>> fetchRanked();

  Future<Map<String, dynamic>> linkAccount({
    required String gameName,
    required String tagLine,
    required String region,
  });
}
