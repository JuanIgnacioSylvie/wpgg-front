import '../../../../core/network/api_client.dart';
import '../models/mission_card_model.dart';

enum MissionSyncApiStatus {
  noActiveMissions,
  upToDate,
  updatesAvailable;

  static MissionSyncApiStatus fromApi(String value) {
    return switch (value) {
      'NO_ACTIVE_MISSIONS' => MissionSyncApiStatus.noActiveMissions,
      'UP_TO_DATE' => MissionSyncApiStatus.upToDate,
      'UPDATES_AVAILABLE' => MissionSyncApiStatus.updatesAvailable,
      _ => MissionSyncApiStatus.updatesAvailable,
    };
  }
}

class MissionSyncStatusResponse {
  const MissionSyncStatusResponse({
    required this.status,
    this.lastSyncedAt,
    this.latestMatchId,
    this.newestMatchId,
  });

  final MissionSyncApiStatus status;
  final String? lastSyncedAt;
  final String? latestMatchId;
  final String? newestMatchId;

  factory MissionSyncStatusResponse.fromJson(Map<String, dynamic> json) {
    return MissionSyncStatusResponse(
      status: MissionSyncApiStatus.fromApi(json['status'] as String? ?? ''),
      lastSyncedAt: json['lastSyncedAt'] as String?,
      latestMatchId: json['latestMatchId'] as String?,
      newestMatchId: json['newestMatchId'] as String?,
    );
  }
}

class MissionSyncResult {
  const MissionSyncResult({
    required this.processed,
    required this.lastSyncedAt,
    this.latestMatchId,
  });

  final int processed;
  final String lastSyncedAt;
  final String? latestMatchId;

  factory MissionSyncResult.fromJson(Map<String, dynamic> json) {
    return MissionSyncResult(
      processed: (json['processed'] as num?)?.toInt() ?? 0,
      lastSyncedAt: json['lastSyncedAt'] as String? ?? '',
      latestMatchId: json['latestMatchId'] as String?,
    );
  }
}

class MissionsHomeResponse {
  MissionsHomeResponse({
    this.welcome,
    required this.primary,
    required this.secondary,
    required this.past,
    required this.endsInSeconds,
    required this.missionDate,
    required this.missionDayTimezone,
  });

  final MissionCardModel? welcome;
  final MissionCardModel? primary;
  final List<MissionCardModel> secondary;
  final List<MissionCardModel> past;
  final int endsInSeconds;
  final String missionDate;
  final String missionDayTimezone;
}

class PickTodayResponse {
  PickTodayResponse({
    required this.date,
    required this.offers,
    required this.selectedCount,
    required this.maxSelectable,
    required this.maxHard,
  });

  final String date;
  final List<MissionCardModel> offers;
  final int selectedCount;
  final int maxSelectable;
  final int maxHard;
}

abstract class MissionsRemoteDataSource {
  Future<MissionsHomeResponse> fetchHome();
  Future<PickTodayResponse> fetchPickToday();
  Future<List<MissionCardModel>> fetchByDay(String? date);
  Future<MissionCardModel> acceptOffer(String offerId);
  Future<MissionCardModel> rerollOffer(String offerId);
  Future<void> cancelActiveMission(String missionId);
  Future<MissionSyncStatusResponse> fetchSyncStatus();
  Future<MissionSyncResult> syncMatches();
}

class MissionsRemoteDataSourceImpl implements MissionsRemoteDataSource {
  MissionsRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<MissionsHomeResponse> fetchHome() async {
    final res = await _client.get<Map<String, dynamic>>('/missions/home');
    final data = res.data!;
    return MissionsHomeResponse(
      missionDate: data['missionDate'] as String? ?? '',
      missionDayTimezone:
          data['missionDayTimezone'] as String? ?? 'UTC',
      welcome: data['welcome'] != null
          ? MissionCardModel.fromJson(
              data['welcome'] as Map<String, dynamic>,
            )
          : null,
      primary: data['primary'] != null
          ? MissionCardModel.fromJson(
              data['primary'] as Map<String, dynamic>,
            )
          : null,
      secondary: (data['secondary'] as List<dynamic>? ?? [])
          .map((e) => MissionCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      past: (data['past'] as List<dynamic>? ?? [])
          .map((e) => MissionCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      endsInSeconds: (data['endsInSeconds'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<PickTodayResponse> fetchPickToday() async {
    final res = await _client.get<Map<String, dynamic>>('/missions/pick/today');
    final data = res.data!;
    return PickTodayResponse(
      date: data['date'] as String? ?? '',
      offers: (data['offers'] as List<dynamic>? ?? [])
          .map((e) => MissionCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedCount: (data['selectedCount'] as num?)?.toInt() ?? 0,
      maxSelectable: (data['maxSelectable'] as num?)?.toInt() ?? 3,
      maxHard: (data['maxHard'] as num?)?.toInt() ?? 1,
    );
  }

  @override
  Future<List<MissionCardModel>> fetchByDay(String? date) async {
    final res = await _client.get<Map<String, dynamic>>(
      '/missions/by-day',
      queryParameters: date != null ? {'date': date} : null,
    );
    final list = res.data!['missions'] as List<dynamic>? ?? [];
    return list
        .map((e) => MissionCardModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MissionCardModel> acceptOffer(String offerId) async {
    final res = await _client.post<Map<String, dynamic>>(
      '/missions/pick/$offerId/accept',
    );
    return MissionCardModel.fromJson(res.data!);
  }

  @override
  Future<MissionCardModel> rerollOffer(String offerId) async {
    final res = await _client.post<Map<String, dynamic>>(
      '/missions/pick/$offerId/reroll',
    );
    return MissionCardModel.fromJson(res.data!);
  }

  @override
  Future<void> cancelActiveMission(String missionId) async {
    await _client.post<void>('/missions/active/$missionId/cancel');
  }

  @override
  Future<MissionSyncStatusResponse> fetchSyncStatus() async {
    final res = await _client.get<Map<String, dynamic>>('/missions/sync-status');
    return MissionSyncStatusResponse.fromJson(res.data!);
  }

  @override
  Future<MissionSyncResult> syncMatches() async {
    final res = await _client.post<Map<String, dynamic>>('/missions/sync');
    return MissionSyncResult.fromJson(res.data!);
  }
}
