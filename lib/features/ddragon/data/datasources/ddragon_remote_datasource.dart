import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/cdn_client.dart';

class DDragonRemoteDataSource {
  DDragonRemoteDataSource(this._cdn);

  final CdnClient _cdn;

  Future<Map<int, String>> fetchChampionKeys(String version) async {
    try {
      final res = await _cdn.get<dynamic>(
        '/cdn/$version/data/en_US/champion.json',
      );
      final data = res.data;
      Map<String, dynamic> root;
      if (data is Map<String, dynamic>) {
        root = data;
      } else if (data is Map) {
        root = Map<String, dynamic>.from(data);
      } else if (data is String) {
        root = Map<String, dynamic>.from(
          jsonDecode(data) as Map<String, dynamic>,
        );
      } else {
        throw const ServerException('Champions DDragon inválidos');
      }
      final champs = root['data'];
      if (champs is! Map) {
        throw const ServerException('Champions DDragon inválidos');
      }
      final out = <int, String>{};
      for (final entry in champs.entries) {
        if (entry.value is! Map) continue;
        final c = Map<String, dynamic>.from(entry.value as Map);
        final id = (c['key'] as num?)?.toInt();
        final key = c['id'] as String? ?? entry.key as String;
        if (id != null && key.isNotEmpty) {
          out[id] = key;
        }
      }
      return out;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  Future<String> fetchLatestVersion() async {
    try {
      final res = await _cdn.get<dynamic>('/api/versions.json');
      final data = res.data;
      if (data is List && data.isNotEmpty && data.first is String) {
        return data.first as String;
      }
      if (data is String) {
        final list = jsonDecode(data) as List<dynamic>;
        return list.first as String;
      }
      throw const ServerException('Versiones DDragon inválidas');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
