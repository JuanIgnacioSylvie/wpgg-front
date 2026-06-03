import 'package:flutter/material.dart';

import '../../features/missions/domain/entities/mission_card_entity.dart';

extension MissionCardL10n on MissionCardEntity {
  String localizedTitle(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    if (code == 'es') {
      return titleEs.isNotEmpty ? titleEs : titleEn;
    }
    return titleEn.isNotEmpty ? titleEn : titleEs;
  }
}
