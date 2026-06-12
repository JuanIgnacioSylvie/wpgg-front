import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/entities/inbox_notification.dart';

abstract class NotificationsRemoteDataSource {
  Future<void> registerDevice({
    required String token,
    required String platform,
  });

  Future<void> unregisterDevice({required String token});

  Future<void> sendTestPush();

  Future<InboxPage> fetchInbox({int limit = 20, String? cursor});

  Future<void> markInboxRead(String id);

  Future<void> markAllInboxRead();
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
      _throwDioMessage(e);
    }
  }

  @override
  Future<InboxPage> fetchInbox({int limit = 20, String? cursor}) async {
    try {
      final res = await _client.get<Map<String, dynamic>>(
        '/notifications/inbox',
        queryParameters: {
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
        },
      );
      final data = res.data ?? {};
      final rawItems = data['items'] as List<dynamic>? ?? [];
      return InboxPage(
        items: rawItems
            .map((e) => InboxNotification.fromJson(e as Map<String, dynamic>))
            .toList(),
        unreadCount: data['unreadCount'] as int? ?? 0,
        nextCursor: data['nextCursor'] as String?,
      );
    } on DioException catch (e) {
      _throwDioMessage(e);
    }
  }

  @override
  Future<void> markInboxRead(String id) async {
    try {
      await _client.raw.patch<void>('/notifications/inbox/$id/read');
    } on DioException catch (e) {
      _throwDioMessage(e);
    }
  }

  @override
  Future<void> markAllInboxRead() async {
    try {
      await _client.post<void>('/notifications/inbox/read-all');
    } on DioException catch (e) {
      _throwDioMessage(e);
    }
  }

  Never _throwDioMessage(DioException e) {
    final body = e.response?.data;
    if (body is Map && body['message'] != null) {
      final msg = body['message'];
      throw Exception(msg is List ? msg.join(', ') : msg.toString());
    }
    throw e;
  }
}
