import 'package:equatable/equatable.dart';

class SummonerEntity extends Equatable {
  const SummonerEntity({
    required this.gameName,
    required this.tagLine,
    required this.summonerLevel,
    required this.profileIconId,
    required this.region,
    this.puuid,
  });

  final String? puuid;
  final String gameName;
  final String tagLine;
  final int summonerLevel;
  final int profileIconId;
  final String region;

  String get riotId => '$gameName#$tagLine';

  @override
  List<Object?> get props =>
      [puuid, gameName, tagLine, summonerLevel, profileIconId, region];
}
