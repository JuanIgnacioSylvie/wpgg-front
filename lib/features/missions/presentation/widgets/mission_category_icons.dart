import '../../domain/entities/mission_card_entity.dart';

/// Role icons for mission cards (LoL lane + fill).
abstract final class MissionCategoryIcons {
  static const String top = 'assets/icons/missions/role_top.png';
  static const String jungle = 'assets/icons/missions/role_jg.png';
  static const String mid = 'assets/icons/missions/role_mid.png';
  static const String bottom = 'assets/icons/missions/role_bottom.png';
  static const String support = 'assets/icons/missions/role_support.png';
  static const String autofill = 'assets/icons/missions/role_autofill.png';

  static String assetPath(MissionCategory category) {
    switch (category) {
      case MissionCategory.top:
        return top;
      case MissionCategory.jungle:
        return jungle;
      case MissionCategory.mid:
        return mid;
      case MissionCategory.bottom:
        return bottom;
      case MissionCategory.support:
        return support;
      case MissionCategory.autofill:
        return autofill;
    }
  }
}
