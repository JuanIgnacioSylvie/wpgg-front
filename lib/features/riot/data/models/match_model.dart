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
    if (ended is int) {
      endedAt = DateTime.fromMillisecondsSinceEpoch(ended);
    } else if (ended is String) {
      endedAt = DateTime.tryParse(ended) ?? DateTime.now();
    } else {
      endedAt = DateTime.now();
    }
    return MatchModel(
      matchId: json['matchId'] as String? ?? json['id'] as String? ?? '',
      championId: (json['championId'] as num?)?.toInt() ?? 0,
      championName:
          json['championName'] as String? ?? json['champion'] as String? ?? '',
      kills: (json['kills'] as num?)?.toInt() ?? 0,
      deaths: (json['deaths'] as num?)?.toInt() ?? 0,
      assists: (json['assists'] as num?)?.toInt() ?? 0,
      win: json['win'] as bool? ?? false,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ??
          (json['gameDuration'] as num?)?.toInt() ??
          0,
      endedAt: endedAt,
    );
  }
}
