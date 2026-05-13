import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import 'riot_remote_datasource.dart';

class RiotRemoteDataSourceImpl implements RiotRemoteDataSource {
  RiotRemoteDataSourceImpl(this._api);

  final ApiClient _api;

  @override
  Future<Either<ServerException, Option<Map<String, dynamic>>>> fetchSummoner() async {
    try {
      final res = await _api.get<dynamic>('/riot/summoner');
      final data = res.data;
      if (data is Map<String, dynamic>) return Right(some(data));
      if (data is Map) return Right(some(Map<String, dynamic>.from(data)));
      return const Right(None());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return const Right(None());
      return Left(ServerException(_message(e)));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<List<dynamic>> fetchMatches(int limit) async {
    try {
      final res = await _api.get<dynamic>(
        '/riot/matches',
        queryParameters: {'limit': limit},
      );
      final data = res.data;
      if (data is List) return data;
      if (data is Map && data['items'] is List) {
        return data['items'] as List<dynamic>;
      }
      return const [];
    } on DioException catch (e) {
      throw ServerException(_message(e));
    }
  }

  @override
  Future<List<dynamic>> fetchRanked() async {
    try {
      final res = await _api.get<dynamic>('/riot/ranked');
      final data = res.data;
      if (data is List) return data;
      if (data is Map && data['entries'] is List) {
        return data['entries'] as List<dynamic>;
      }
      return const [];
    } on DioException catch (e) {
      throw ServerException(_message(e));
    }
  }

  @override
  Future<Map<String, dynamic>> linkAccount({
    required String gameName,
    required String tagLine,
    required String region,
  }) async {
    try {
      final res = await _api.post<dynamic>(
        '/riot/link',
        data: {
          'gameName': gameName,
          'tagLine': tagLine,
          'region': region,
        },
      );
      final data = res.data;
      if (data is Map<String, dynamic>) return data;
      if (data is Map) return Map<String, dynamic>.from(data);
      throw const ServerException('Respuesta inválida');
    } on DioException catch (e) {
      throw ServerException(_message(e));
    }
  }

  String _message(DioException e) {
    final d = e.response?.data;
    if (d is Map && d['message'] is String) return d['message'] as String;
    return e.message ?? 'Error de red';
  }
}
