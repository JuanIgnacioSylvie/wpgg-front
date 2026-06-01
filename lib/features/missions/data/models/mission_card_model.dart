import '../../domain/entities/mission_card_entity.dart';

class MissionCardModel extends MissionCardEntity {
  const MissionCardModel({
    required super.id,
    super.offerId,
    required super.difficulty,
    required super.titleEs,
    required super.titleEn,
    required super.rewardWpgg,
    required super.status,
    required super.progressPercent,
    super.championId,
    super.endsAt,
  });

  factory MissionCardModel.fromJson(Map<String, dynamic> json) {
    return MissionCardModel(
      id: json['id'] as String,
      offerId: json['offerId'] as String?,
      difficulty: _difficulty(json['difficulty'] as String?),
      titleEs: json['titleEs'] as String? ?? '',
      titleEn: json['titleEn'] as String? ?? '',
      rewardWpgg: (json['rewardWpgg'] as num?)?.toInt() ?? 0,
      status: _status(json['status'] as String?),
      progressPercent: (json['progressPercent'] as num?)?.toInt() ?? 0,
      championId: (json['championId'] as num?)?.toInt(),
      endsAt: json['endsAt'] != null
          ? DateTime.tryParse(json['endsAt'] as String)
          : null,
    );
  }

  static MissionDifficulty _difficulty(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'MEDIUM':
        return MissionDifficulty.medium;
      case 'HARD':
        return MissionDifficulty.hard;
      default:
        return MissionDifficulty.easy;
    }
  }

  static MissionStatus _status(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'ACTIVE':
        return MissionStatus.active;
      case 'COMPLETED':
        return MissionStatus.completed;
      case 'EXPIRED':
        return MissionStatus.expired;
      case 'OFFER':
        return MissionStatus.offer;
      default:
        return MissionStatus.active;
    }
  }
}
