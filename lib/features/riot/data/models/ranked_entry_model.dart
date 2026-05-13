import '../../domain/entities/ranked_entry_entity.dart';

class RankedEntryModel extends RankedEntryEntity {
  const RankedEntryModel({
    required super.queueType,
    required super.tier,
    required super.rank,
    required super.leaguePoints,
    required super.wins,
    required super.losses,
  });

  factory RankedEntryModel.fromJson(Map<String, dynamic> json) {
    return RankedEntryModel(
      queueType: json['queueType'] as String? ?? '',
      tier: json['tier'] as String? ?? '',
      rank: json['rank'] as String? ?? '',
      leaguePoints: (json['leaguePoints'] as num?)?.toInt() ?? 0,
      wins: (json['wins'] as num?)?.toInt() ?? 0,
      losses: (json['losses'] as num?)?.toInt() ?? 0,
    );
  }
}
