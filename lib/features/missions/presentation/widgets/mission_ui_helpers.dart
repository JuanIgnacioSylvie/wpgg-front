import 'package:flutter/material.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/presentation/widgets/wpgg_card_elevation.dart';
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

Color missionAccentColor(MissionCardEntity mission) {
  if (mission.isWelcome) {
    return WpggBrand.welcomeAccent;
  }
  return difficultyColor(mission.difficulty);
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
      return Icons.eco_outlined;
    case MissionDifficulty.medium:
      return Icons.eco;
    case MissionDifficulty.hard:
      return Icons.local_fire_department_outlined;
  }
}

Color difficultyCardBackground(MissionDifficulty d) {
  return Color.alphaBlend(
    difficultyColor(d).withValues(alpha: _backgroundTintAlpha(d)),
    WpggBrand.missionSecondaryBg,
  );
}

double _backgroundTintAlpha(MissionDifficulty d) {
  switch (d) {
    case MissionDifficulty.easy:
      return 0.05;
    case MissionDifficulty.medium:
      return 0.06;
    case MissionDifficulty.hard:
      return 0.07;
  }
}

double difficultyBorderWidth(MissionDifficulty d) {
  return 1;
}

BoxDecoration missionCardDecoration(
  MissionCardEntity mission, {
  bool hovered = false,
  Color? surfaceColor,
}) {
  if (mission.isWelcome) {
    return WpggCardElevation.enhance(
      BoxDecoration(
        color: WpggBrand.welcomeAccentSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: WpggBrand.welcomeAccent.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      hovered: hovered,
      accentColor: WpggBrand.welcomeAccent,
      baseColor: WpggBrand.welcomeAccentSoft,
    );
  }

  final color = difficultyColor(mission.difficulty);
  final background = surfaceColor ?? difficultyCardBackground(mission.difficulty);

  return WpggCardElevation.enhance(
    BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: color.withValues(alpha: 0.2),
        width: difficultyBorderWidth(mission.difficulty),
      ),
    ),
    hovered: hovered,
    accentColor: color,
    baseColor: background,
  );
}

String statusLabel(MissionStatus s, AppLocalizations l10n) {
  switch (s) {
    case MissionStatus.completed:
      return l10n.statusCompleted;
    case MissionStatus.claimed:
      return l10n.statusClaimed;
    case MissionStatus.expired:
      return l10n.statusIncomplete;
    case MissionStatus.active:
      return l10n.statusInProgress;
    case MissionStatus.offer:
      return l10n.statusToDo;
  }
}
