import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';

abstract class NotificationsRemoteDataSource {
  Future<void> registerDevice({
    required String token,
    required String platform,
  });

  Future<void> unregisterDevice({required String token});

  Future<void> sendTestPush();
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  NotificationsRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<void> registerDevice({
    required String token,
    required String platform,
  }) async {
    await _client.post<void>(
      '/notifications/devices',
      data: {'token': token, 'platform': platform},
    );
  }

  @override
  Future<void> unregisterDevice({required String token}) async {
    await _client.delete<void>(
      '/notifications/devices',
      data: {'token': token},
    );
  }

  @override
  Future<void> sendTestPush() async {
    try {
      await _client.post<void>('/notifications/test');
    } on DioException catch (e) {
      final body = e.response?.data;
      if (body is Map && body['message'] != null) {
        final msg = body['message'];
        throw Exception(msg is List ? msg.join(', ') : msg.toString());
      }
      rethrow;
    }
  }
}
