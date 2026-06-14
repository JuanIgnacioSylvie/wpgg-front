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
    this.completedMissionsCount = 0,
    this.activeMissionTitleEn,
    this.activeMissionTitleEs,
    this.activeMissionProgressPercent,
    this.activeMissionChampionId,
  });

  final int rank;
  final String userId;
  final int balanceWpgg;
  final String gameName;
  final String tagLine;
  final String region;
  final int profileIconId;
  final int completedMissionsCount;
  final String? activeMissionTitleEn;
  final String? activeMissionTitleEs;
  final int? activeMissionProgressPercent;
  final int? activeMissionChampionId;

  bool get hasActiveMission =>
      activeMissionProgressPercent != null &&
      (activeMissionTitleEn?.isNotEmpty == true ||
          activeMissionTitleEs?.isNotEmpty == true);

  String localizedActiveMissionTitle(String languageCode) {
    if (languageCode == 'es') {
      final es = activeMissionTitleEs?.trim();
      if (es != null && es.isNotEmpty) return es;
    }
    final en = activeMissionTitleEn?.trim();
    if (en != null && en.isNotEmpty) return en;
    return activeMissionTitleEs?.trim() ?? '';
  }
}

class LeaderboardViewerPayload {
  const LeaderboardViewerPayload({
    required this.rank,
    required this.inTop,
    required this.balanceWpgg,
    this.gapToAbove,
    this.gapToLeader,
    required this.totalPlayers,
  });

  final int rank;
  final bool inTop;
  final int balanceWpgg;
  final int? gapToAbove;
  final int? gapToLeader;
  final int totalPlayers;
}

class LeaderboardResponse {
  const LeaderboardResponse({
    required this.entries,
    required this.viewer,
    required this.latestPriceUsd,
  });

  final List<LeaderboardEntry> entries;
  final LeaderboardViewerPayload viewer;
  final double latestPriceUsd;
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
    this.completedMissionsCount = 0,
    this.leaderboardRank = 0,
    this.leaderboardInTop = false,
    this.gapToAbove,
    this.gapToLeader,
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
  final int completedMissionsCount;
  final int leaderboardRank;
  final bool leaderboardInTop;
  final int? gapToAbove;
  final int? gapToLeader;
  final MissionCardModel? welcome;
  final MissionCardModel? primary;
  final List<MissionCardModel> secondary;
  final List<MissionCardModel> past;
}

abstract class ProfileRemoteDataSource {
  Future<ProfileSettings> fetchSettings();
  Future<ProfileSettings> updateSettings({required bool profilePublic});
  Future<LeaderboardResponse> fetchLeaderboard({int limit = 50});
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
  Future<LeaderboardResponse> fetchLeaderboard({int limit = 50}) async {
    final res = await _client.get<Map<String, dynamic>>(
      '/profile/leaderboard',
      queryParameters: {'limit': limit},
    );
    final data = res.data ?? {};
    final entries = (data['entries'] as List<dynamic>? ?? [])
        .map((e) => _parseLeaderboardEntry(e as Map<String, dynamic>))
        .toList();
    final viewerRaw = data['viewer'] as Map<String, dynamic>? ?? {};
    return LeaderboardResponse(
      entries: entries,
      viewer: LeaderboardViewerPayload(
        rank: (viewerRaw['rank'] as num?)?.toInt() ?? 0,
        inTop: viewerRaw['inTop'] as bool? ?? false,
        balanceWpgg: (viewerRaw['balanceWpgg'] as num?)?.toInt() ?? 0,
        gapToAbove: (viewerRaw['gapToAbove'] as num?)?.toInt(),
        gapToLeader: (viewerRaw['gapToLeader'] as num?)?.toInt(),
        totalPlayers: (viewerRaw['totalPlayers'] as num?)?.toInt() ?? entries.length,
      ),
      latestPriceUsd: (data['latestPriceUsd'] as num?)?.toDouble() ?? 0,
    );
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
      completedMissionsCount:
          (json['completedMissionsCount'] as num?)?.toInt() ?? 0,
      activeMissionTitleEn: json['activeMissionTitleEn'] as String?,
      activeMissionTitleEs: json['activeMissionTitleEs'] as String?,
      activeMissionProgressPercent:
          (json['activeMissionProgressPercent'] as num?)?.toInt(),
      activeMissionChampionId:
          (json['activeMissionChampionId'] as num?)?.toInt(),
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
      completedMissionsCount:
          (data['completedMissionsCount'] as num?)?.toInt() ?? 0,
      leaderboardRank: (data['leaderboardRank'] as num?)?.toInt() ?? 0,
      leaderboardInTop: data['leaderboardInTop'] as bool? ?? false,
      gapToAbove: (data['gapToAbove'] as num?)?.toInt(),
      gapToLeader: (data['gapToLeader'] as num?)?.toInt(),
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
