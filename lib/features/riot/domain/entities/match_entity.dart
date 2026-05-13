import 'package:equatable/equatable.dart';

class MatchEntity extends Equatable {
  const MatchEntity({
    required this.matchId,
    required this.championId,
    required this.championName,
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.win,
    required this.durationSeconds,
    required this.endedAt,
  });

  final String matchId;
  final int championId;
  final String championName;
  final int kills;
  final int deaths;
  final int assists;
  final bool win;
  final int durationSeconds;
  final DateTime endedAt;

  @override
  List<Object?> get props => [
        matchId,
        championId,
        championName,
        kills,
        deaths,
        assists,
        win,
        durationSeconds,
        endedAt,
      ];
}
