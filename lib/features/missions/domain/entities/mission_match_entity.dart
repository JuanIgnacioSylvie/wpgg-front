import '../../../riot/domain/entities/match_entity.dart';

enum MissionMatchContribution {
  contributed,
  noProgress,
  notEligible,
}

class MissionMatchEntity extends MatchEntity {
  const MissionMatchEntity({
    required super.matchId,
    required super.championId,
    required super.championName,
    required super.kills,
    required super.deaths,
    required super.assists,
    required super.win,
    required super.durationSeconds,
    required super.endedAt,
    required this.eligible,
    required this.contribution,
  });

  final bool eligible;
  final MissionMatchContribution contribution;
}
