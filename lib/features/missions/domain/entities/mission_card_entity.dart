import 'package:equatable/equatable.dart';

enum MissionDifficulty { easy, medium, hard }

enum MissionStatus { offer, active, completed, expired }

class MissionCardEntity extends Equatable {
  const MissionCardEntity({
    required this.id,
    this.offerId,
    required this.difficulty,
    required this.titleEs,
    required this.titleEn,
    required this.rewardWpgg,
    required this.status,
    required this.progressPercent,
    this.championId,
    this.endsAt,
  });

  final String id;
  final String? offerId;
  final MissionDifficulty difficulty;
  final String titleEs;
  final String titleEn;
  final int rewardWpgg;
  final MissionStatus status;
  final int progressPercent;
  final int? championId;
  final DateTime? endsAt;

  @override
  List<Object?> get props => [id, status, progressPercent];
}
