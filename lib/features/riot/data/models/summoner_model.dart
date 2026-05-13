import '../../domain/entities/summoner_entity.dart';

class SummonerModel extends SummonerEntity {
  const SummonerModel({
    super.puuid,
    required super.gameName,
    required super.tagLine,
    required super.summonerLevel,
    required super.profileIconId,
    required super.region,
  });

  factory SummonerModel.fromJson(Map<String, dynamic> json) {
    return SummonerModel(
      puuid: json['puuid'] as String?,
      gameName: json['gameName'] as String? ?? json['name'] as String? ?? '',
      tagLine: json['tagLine'] as String? ?? '',
      summonerLevel: (json['summonerLevel'] as num?)?.toInt() ?? 0,
      profileIconId: (json['profileIconId'] as num?)?.toInt() ?? 0,
      region: json['region'] as String? ?? '',
    );
  }
}
