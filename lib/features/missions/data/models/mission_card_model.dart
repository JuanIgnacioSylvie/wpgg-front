import '../../domain/entities/mission_card_entity.dart';
import '../../domain/entities/mission_progress_line.dart';

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
    super.progressLines,
    super.championId,
    super.championKey,
    super.championName,
    super.endsAt,
  });

  factory MissionCardModel.fromJson(Map<String, dynamic> json) {
    final titleEs = json['titleEs'] as String? ?? '';
    final titleEn = json['titleEn'] as String? ?? '';
    return MissionCardModel(
      id: json['id'] as String,
      offerId: json['offerId'] as String?,
      kind: _kind(json['kind'] as String?),
      category: _category(
        json['category'] as String?,
        titleEs: titleEs,
        titleEn: titleEn,
      ),
      difficulty: _difficulty(json['difficulty'] as String?),
      titleEs: titleEs,
      titleEn: titleEn,
      subtitleEs: json['subtitleEs'] as String?,
      subtitleEn: json['subtitleEn'] as String?,
      rewardWpgg: (json['rewardWpgg'] as num?)?.toInt() ?? 0,
      status: _status(json['status'] as String?),
      progressPercent: (json['progressPercent'] as num?)?.toInt() ?? 0,
      progressLines: _progressLines(json['progressLines']),
      championId: (json['championId'] as num?)?.toInt(),
      championKey: json['championKey'] as String?,
      championName: json['championName'] as String?,
      endsAt: json['endsAt'] != null
          ? DateTime.tryParse(json['endsAt'] as String)
          : null,
    );
  }

  static List<MissionProgressLine> _progressLines(dynamic raw) {
    if (raw is! List<dynamic>) {
      return const [];
    }
    return raw.map((entry) {
      final map = entry as Map<String, dynamic>;
      return MissionProgressLine(
        current: (map['current'] as num?)?.toInt() ?? 0,
        target: (map['target'] as num?)?.toInt() ?? 0,
      );
    }).toList();
  }

  static MissionKind _kind(String? raw) {
    if (raw?.toUpperCase() == 'WELCOME') {
      return MissionKind.welcome;
    }
    return MissionKind.standard;
  }

  static MissionCategory _category(
    String? raw, {
    required String titleEs,
    required String titleEn,
  }) {
    final fromApi = _categoryFromApi(raw);
    if (raw != null && raw.isNotEmpty) {
      return fromApi;
    }
    return _categoryFromTitle(titleEs) ??
        _categoryFromTitle(titleEn) ??
        MissionCategory.autofill;
  }

  static MissionCategory _categoryFromApi(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'TOP':
        return MissionCategory.top;
      case 'JUNGLE':
      case 'JG':
        return MissionCategory.jungle;
      case 'MID':
        return MissionCategory.mid;
      case 'BOTTOM':
        return MissionCategory.bottom;
      case 'SUPPORT':
        return MissionCategory.support;
      case 'AUTOFILL':
      default:
        return MissionCategory.autofill;
    }
  }

  static MissionCategory? _categoryFromTitle(String title) {
    final colon = title.indexOf(':');
    if (colon <= 0) return null;
    final label = title.substring(0, colon).trim().toLowerCase();
    switch (label) {
      case 'top':
        return MissionCategory.top;
      case 'jungle':
      case 'jungla':
      case 'jg':
        return MissionCategory.jungle;
      case 'mid':
        return MissionCategory.mid;
      case 'bottom':
      case 'adc':
        return MissionCategory.bottom;
      case 'support':
      case 'soporte':
        return MissionCategory.support;
      case 'comodín':
      case 'comodin':
      case 'fill':
        return MissionCategory.autofill;
      default:
        return null;
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
      case 'CLAIMED':
        return MissionStatus.claimed;
      case 'EXPIRED':
        return MissionStatus.expired;
      case 'OFFER':
        return MissionStatus.offer;
      default:
        return MissionStatus.active;
    }
  }
}
