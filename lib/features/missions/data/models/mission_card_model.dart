import '../../domain/entities/mission_card_entity.dart';

class MissionCardModel extends MissionCardEntity {
  const MissionCardModel({
    required super.id,
    super.offerId,
    super.kind,
    super.category,
    required super.difficulty,
    required super.titleEs,
    required super.titleEn,
    super.subtitleEs,
    super.subtitleEn,
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
      kind: _kind(json['kind'] as String?),
      category: _category(json['category'] as String?),
      difficulty: _difficulty(json['difficulty'] as String?),
      titleEs: json['titleEs'] as String? ?? '',
      titleEn: json['titleEn'] as String? ?? '',
      subtitleEs: json['subtitleEs'] as String?,
      subtitleEn: json['subtitleEn'] as String?,
      rewardWpgg: (json['rewardWpgg'] as num?)?.toInt() ?? 0,
      status: _status(json['status'] as String?),
      progressPercent: (json['progressPercent'] as num?)?.toInt() ?? 0,
      championId: (json['championId'] as num?)?.toInt(),
      endsAt: json['endsAt'] != null
          ? DateTime.tryParse(json['endsAt'] as String)
          : null,
    );
  }

  static MissionKind _kind(String? raw) {
    if (raw?.toUpperCase() == 'WELCOME') {
      return MissionKind.welcome;
    }
    return MissionKind.standard;
  }

  static MissionCategory _category(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'WELCOME':
        return MissionCategory.welcome;
      case 'FARMING':
        return MissionCategory.farming;
      case 'SUPPORT':
        return MissionCategory.support;
      case 'WINSTREAK':
        return MissionCategory.winstreak;
      case 'OTP':
        return MissionCategory.otp;
      case 'TOP':
        return MissionCategory.top;
      case 'JG':
        return MissionCategory.jg;
      case 'MID':
        return MissionCategory.mid;
      case 'BOTTOM':
        return MissionCategory.bottom;
      case 'TANK':
        return MissionCategory.tank;
      case 'HEALER':
        return MissionCategory.healer;
      case 'CLUTCH':
        return MissionCategory.clutch;
      case 'MULTIKILL':
        return MissionCategory.multikill;
      case 'GOLD':
        return MissionCategory.gold;
      case 'OBJECTIVES':
        return MissionCategory.objectives;
      case 'ASSASSIN':
        return MissionCategory.assassin;
      case 'WARDS':
        return MissionCategory.wards;
      default:
        return MissionCategory.versatile;
    }
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
