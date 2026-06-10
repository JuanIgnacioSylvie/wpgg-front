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

  String? localizedSubtitle(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    if (code == 'es') {
      final es = subtitleEs?.trim();
      if (es != null && es.isNotEmpty) return es;
      final en = subtitleEn?.trim();
      return en != null && en.isNotEmpty ? en : null;
    }
    final en = subtitleEn?.trim();
    if (en != null && en.isNotEmpty) return en;
    final es = subtitleEs?.trim();
    return es != null && es.isNotEmpty ? es : null;
  }
}
