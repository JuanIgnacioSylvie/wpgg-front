import '../../domain/entities/match_entity.dart';

class MatchModel extends MatchEntity {
  const MatchModel({
    required super.matchId,
    required super.championId,
    required super.championName,
    required super.kills,
    required super.deaths,
    required super.assists,
    required super.win,
    required super.durationSeconds,
    required super.endedAt,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    final ended = json['gameEndTimestamp'] ?? json['endedAt'];
    DateTime endedAt;
    if (ended is num) {
      endedAt = DateTime.fromMillisecondsSinceEpoch(ended.toInt());
    } else if (ended is String) {
      endedAt = DateTime.tryParse(ended) ?? DateTime.now();
    } else {
      endedAt = DateTime.now();
    }
    return MatchModel(
      matchId: _str(json['matchId']) ?? _str(json['id']) ?? '',
      championId: _int(json['championId']),
      championName: _str(json['championName']) ?? _str(json['champion']) ?? '',
      kills: _int(json['kills']),
      deaths: _int(json['deaths']),
      assists: _int(json['assists']),
      win: _bool(json['win']),
      durationSeconds: _int(json['durationSeconds'] ?? json['gameDuration']),
      endedAt: endedAt,
    );
  }

  static String? _str(dynamic v) => v?.toString();

  static int _int(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static bool _bool(dynamic v) {
    if (v is bool) return v;
    if (v is String) return v.toLowerCase() == 'true';
    if (v is num) return v != 0;
    return false;
  }
}
