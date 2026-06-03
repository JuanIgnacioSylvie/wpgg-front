import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/wpgg_brand.dart';
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

String difficultyLabel(MissionDifficulty d) {
  switch (d) {
    case MissionDifficulty.easy:
      return 'Easy';
    case MissionDifficulty.medium:
      return 'Medium';
    case MissionDifficulty.hard:
      return 'Hard';
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

String statusLabel(MissionStatus s) {
  switch (s) {
    case MissionStatus.completed:
      return 'Completed';
    case MissionStatus.expired:
      return 'Incomplete';
    case MissionStatus.active:
      return 'In Progress';
    case MissionStatus.offer:
      return 'To do';
  }
}
