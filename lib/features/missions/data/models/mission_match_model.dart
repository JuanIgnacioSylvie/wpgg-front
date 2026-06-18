import '../../domain/entities/mission_match_entity.dart';
import '../../../riot/data/models/match_model.dart';

class MissionMatchModel extends MissionMatchEntity {
  const MissionMatchModel({
    required super.matchId,
    required super.championId,
    required super.championName,
    required super.kills,
    required super.deaths,
    required super.assists,
    required super.win,
    required super.durationSeconds,
    required super.endedAt,
    required super.eligible,
    required super.contribution,
  });

  factory MissionMatchModel.fromJson(Map<String, dynamic> json) {
    final base = MatchModel.fromJson(json);
    return MissionMatchModel(
      matchId: base.matchId,
      championId: base.championId,
      championName: base.championName,
      kills: base.kills,
      deaths: base.deaths,
      assists: base.assists,
      win: base.win,
      durationSeconds: base.durationSeconds,
      endedAt: base.endedAt,
      eligible: json['eligible'] as bool? ?? false,
      contribution: _contributionFromApi(
        json['contribution'] as String? ?? '',
      ),
    );
  }

  static MissionMatchContribution _contributionFromApi(String value) {
    return switch (value) {
      'CONTRIBUTED' => MissionMatchContribution.contributed,
      'NOT_ELIGIBLE' => MissionMatchContribution.notEligible,
      _ => MissionMatchContribution.noProgress,
    };
  }
}
