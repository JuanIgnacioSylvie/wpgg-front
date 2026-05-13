import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/cdn_client.dart';

class DDragonRemoteDataSource {
  DDragonRemoteDataSource(this._cdn);

  final CdnClient _cdn;

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
