import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../missions/data/models/mission_card_model.dart';

class ProfileSettings {
  ProfileSettings({required this.profilePublic});

  final bool profilePublic;
}

class LeaderboardEntry {
  LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.balanceWpgg,
    required this.gameName,
    required this.tagLine,
    required this.region,
    required this.profileIconId,
  });

  final int rank;
  final String userId;
  final int balanceWpgg;
  final String gameName;
  final String tagLine;
  final String region;
  final int profileIconId;
}

class PublicUserProfile {
  PublicUserProfile({
    required this.userId,
    required this.profilePublic,
    required this.gameName,
    required this.tagLine,
    required this.region,
    required this.profileIconId,
    required this.balanceWpgg,
    required this.balanceUsd,
    required this.latestPriceUsd,
    this.welcome,
    this.primary,
    required this.secondary,
    required this.past,
  });

  final String userId;
  final bool profilePublic;
  final String gameName;
  final String tagLine;
  final String region;
  final int profileIconId;
  final int balanceWpgg;
  final double balanceUsd;
  final double latestPriceUsd;
  final MissionCardModel? welcome;
  final MissionCardModel? primary;
  final List<MissionCardModel> secondary;
  final List<MissionCardModel> past;
}

abstract class ProfileRemoteDataSource {
  Future<ProfileSettings> fetchSettings();
  Future<ProfileSettings> updateSettings({required bool profilePublic});
  Future<List<LeaderboardEntry>> fetchLeaderboard({int limit = 50});
  Future<PublicUserProfile> fetchUserProfile(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<ProfileSettings> fetchSettings() async {
    final res = await _client.get<Map<String, dynamic>>('/profile/settings');
    final data = res.data!;
    return ProfileSettings(
      profilePublic: data['profilePublic'] as bool? ?? false,
    );
  }

  @override
  Future<ProfileSettings> updateSettings({required bool profilePublic}) async {
    final res = await _client.patch<Map<String, dynamic>>(
      '/profile/settings',
      data: {'profilePublic': profilePublic},
    );
    final data = res.data!;
    return ProfileSettings(
      profilePublic: data['profilePublic'] as bool? ?? false,
    );
  }

  @override
  Future<List<LeaderboardEntry>> fetchLeaderboard({int limit = 50}) async {
    final res = await _client.get<List<dynamic>>(
      '/profile/leaderboard',
      queryParameters: {'limit': limit},
    );
    return (res.data ?? [])
        .map((e) => _parseLeaderboardEntry(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PublicUserProfile> fetchUserProfile(String userId) async {
    try {
      final res = await _client.get<Map<String, dynamic>>(
        '/profile/users/$userId',
      );
      return _parseUserProfile(res.data!);
    } on DioException catch (e) {
      final message = e.response?.data;
      if (message is Map && message['message'] is String) {
        throw ProfileAccessException(message['message'] as String);
      }
      if (e.response?.statusCode == 403) {
        throw const ProfileAccessException('FORBIDDEN');
      }
      rethrow;
    }
  }

  LeaderboardEntry _parseLeaderboardEntry(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      userId: json['userId'] as String? ?? '',
      balanceWpgg: (json['balanceWpgg'] as num?)?.toInt() ?? 0,
      gameName: json['gameName'] as String? ?? '',
      tagLine: json['tagLine'] as String? ?? '',
      region: json['region'] as String? ?? '',
      profileIconId: (json['profileIconId'] as num?)?.toInt() ?? 0,
    );
  }

  PublicUserProfile _parseUserProfile(Map<String, dynamic> data) {
    MissionCardModel? parseMission(dynamic raw) {
      if (raw == null) return null;
      return MissionCardModel.fromJson(raw as Map<String, dynamic>);
    }

    return PublicUserProfile(
      userId: data['userId'] as String? ?? '',
      profilePublic: data['profilePublic'] as bool? ?? false,
      gameName: data['gameName'] as String? ?? '',
      tagLine: data['tagLine'] as String? ?? '',
      region: data['region'] as String? ?? '',
      profileIconId: (data['profileIconId'] as num?)?.toInt() ?? 0,
      balanceWpgg: (data['balanceWpgg'] as num?)?.toInt() ?? 0,
      balanceUsd: (data['balanceUsd'] as num?)?.toDouble() ?? 0,
      latestPriceUsd: (data['latestPriceUsd'] as num?)?.toDouble() ?? 0,
      welcome: parseMission(data['welcome']),
      primary: parseMission(data['primary']),
      secondary: (data['secondary'] as List<dynamic>? ?? [])
          .map((e) => MissionCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      past: (data['past'] as List<dynamic>? ?? [])
          .map((e) => MissionCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProfileAccessException implements Exception {
  const ProfileAccessException(this.code);

  final String code;
}
