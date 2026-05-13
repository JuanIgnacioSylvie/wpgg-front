import 'package:equatable/equatable.dart';

class RankedEntryEntity extends Equatable {
  const RankedEntryEntity({
    required this.queueType,
    required this.tier,
    required this.rank,
    required this.leaguePoints,
    required this.wins,
    required this.losses,
  });

  final String queueType;
  final String tier;
  final String rank;
  final int leaguePoints;
  final int wins;
  final int losses;

  int get totalGames => wins + losses;

  double get winrate =>
      totalGames == 0 ? 0 : (wins / totalGames) * 100;

  @override
  List<Object?> get props =>
      [queueType, tier, rank, leaguePoints, wins, losses];
}
