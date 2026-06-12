import 'package:equatable/equatable.dart';

enum MissionDifficulty { easy, medium, hard }

enum MissionKind { standard, welcome }

enum MissionStatus { offer, active, completed, expired }

/// LoL lane / fill role shown on mission cards.
enum MissionCategory {
  top,
  jungle,
  mid,
  bottom,
  support,
  autofill,
}

class MissionCardEntity extends Equatable {
  const MissionCardEntity({
    required this.id,
    this.offerId,
    this.kind = MissionKind.standard,
    this.category = MissionCategory.autofill,
    required this.difficulty,
    required this.titleEs,
    required this.titleEn,
    this.subtitleEs,
    this.subtitleEn,
    required this.rewardWpgg,
    required this.status,
    required this.progressPercent,
    this.championId,
    this.endsAt,
  });

  final String id;
  final String? offerId;
  final MissionKind kind;
  final MissionCategory category;
  final MissionDifficulty difficulty;
  final String titleEs;
  final String titleEn;
  final String? subtitleEs;
  final String? subtitleEn;
  final int rewardWpgg;
  final MissionStatus status;
  final int progressPercent;
  final int? championId;
  final DateTime? endsAt;

  bool get isWelcome => kind == MissionKind.welcome;

  @override
  List<Object?> get props => [id, status, progressPercent, kind, category];
}
