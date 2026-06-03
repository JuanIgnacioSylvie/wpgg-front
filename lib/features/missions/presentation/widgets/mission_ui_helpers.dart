import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/mission_card_entity.dart';

Color difficultyColor(MissionDifficulty d) {
  switch (d) {
    case MissionDifficulty.easy:
      return WpggBrand.easyAccent;
    case MissionDifficulty.medium:
      return WpggBrand.mediumAccent;
    case MissionDifficulty.hard:
      return WpggBrand.hardAccent;
  }
}

String difficultyLabel(MissionDifficulty d, AppLocalizations l10n) {
  switch (d) {
    case MissionDifficulty.easy:
      return l10n.difficultyEasy;
    case MissionDifficulty.medium:
      return l10n.difficultyMedium;
    case MissionDifficulty.hard:
      return l10n.difficultyHard;
  }
}

IconData difficultyIcon(MissionDifficulty d) {
  switch (d) {
    case MissionDifficulty.easy:
      return Symbols.psychiatry;
    case MissionDifficulty.medium:
      return Symbols.swords;
    case MissionDifficulty.hard:
      return Symbols.local_fire_department;
  }
}

Color difficultyCardBackground(MissionDifficulty d) {
  return Color.alphaBlend(
    difficultyColor(d).withValues(alpha: 0.1),
    WpggBrand.missionSecondaryBg,
  );
}

String statusLabel(MissionStatus s, AppLocalizations l10n) {
  switch (s) {
    case MissionStatus.completed:
      return l10n.statusCompleted;
    case MissionStatus.expired:
      return l10n.statusIncomplete;
    case MissionStatus.active:
      return l10n.statusInProgress;
    case MissionStatus.offer:
      return l10n.statusToDo;
  }
}
