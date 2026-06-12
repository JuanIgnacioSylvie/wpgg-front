import 'package:flutter/material.dart';

import '../../domain/entities/mission_card_entity.dart';

/// Visual identity for a mission card based on its [MissionCategory].
abstract final class MissionCategoryIcons {
  static const String _roleTop = 'assets/icons/missions/role_top.png';
  static const String _roleJg = 'assets/icons/missions/role_jg.png';
  static const String _roleMid = 'assets/icons/missions/role_mid.png';
  static const String _roleBottom = 'assets/icons/missions/role_bottom.png';
  static const String _roleSupport = 'assets/icons/missions/role_support.png';
  static const String _winstreak = 'assets/icons/icon_hard.png';

  static String? assetPath(MissionCategory category) {
    switch (category) {
      case MissionCategory.top:
        return _roleTop;
      case MissionCategory.jg:
        return _roleJg;
      case MissionCategory.mid:
        return _roleMid;
      case MissionCategory.bottom:
        return _roleBottom;
      case MissionCategory.support:
        return _roleSupport;
      case MissionCategory.winstreak:
        return _winstreak;
      default:
        return null;
    }
  }

  static IconData materialIcon(MissionCategory category) {
    switch (category) {
      case MissionCategory.welcome:
        return Icons.redeem_rounded;
      case MissionCategory.versatile:
        return Icons.grid_view_rounded;
      case MissionCategory.farming:
        return Icons.grass_rounded;
      case MissionCategory.support:
        return Icons.visibility_rounded;
      case MissionCategory.winstreak:
        return Icons.local_fire_department_rounded;
      case MissionCategory.otp:
        return Icons.star_rounded;
      case MissionCategory.top:
      case MissionCategory.jg:
      case MissionCategory.mid:
      case MissionCategory.bottom:
        return Icons.sports_martial_arts_rounded;
      case MissionCategory.tank:
        return Icons.shield_rounded;
      case MissionCategory.healer:
        return Icons.favorite_rounded;
      case MissionCategory.clutch:
        return Icons.timer_rounded;
      case MissionCategory.multikill:
        return Icons.whatshot_rounded;
      case MissionCategory.gold:
        return Icons.paid_rounded;
      case MissionCategory.objectives:
        return Icons.account_balance_rounded;
      case MissionCategory.assassin:
        return Icons.flash_on_rounded;
      case MissionCategory.wards:
        return Icons.remove_red_eye_rounded;
    }
  }
}
