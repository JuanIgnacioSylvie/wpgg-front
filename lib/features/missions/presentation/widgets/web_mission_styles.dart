import 'package:flutter/material.dart';

import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/widgets/wpgg_card_elevation.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'mission_ui_helpers.dart';

Color webDifficultySurface(MissionDifficulty difficulty) {
  final accent = difficultyColor(difficulty);
  return Color.alphaBlend(
    accent.withValues(alpha: _webTintAlpha(difficulty)),
    WebColors.surface,
  );
}

double _webTintAlpha(MissionDifficulty difficulty) {
  switch (difficulty) {
    case MissionDifficulty.easy:
      return 0.035;
    case MissionDifficulty.medium:
      return 0.045;
    case MissionDifficulty.hard:
      return 0.055;
  }
}

BoxDecoration webMissionCardDecoration(
  MissionCardEntity mission, {
  bool hovered = false,
  bool isPlaceholder = false,
  bool dragFeedback = false,
}) {
  if (mission.isWelcome) {
    final surface = hovered ? WebColors.surfaceElevated : WebColors.surface;

    return WpggCardElevation.enhance(
      BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: WebColors.border.withValues(alpha: hovered ? 0.9 : 0.55),
          width: 1,
        ),
      ),
      variant: WpggCardElevationVariant.dark,
      hovered: hovered,
      dragFeedback: dragFeedback,
      baseColor: surface,
    );
  }

  final accent = difficultyColor(mission.difficulty);
  final surface = hovered
      ? WebColors.surfaceElevated
      : webDifficultySurface(mission.difficulty);

  return WpggCardElevation.enhance(
    BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isPlaceholder ? WebColors.border : WebColors.borderSubtle,
        width: 1,
      ),
    ),
    variant: WpggCardElevationVariant.dark,
    hovered: hovered,
    dragFeedback: dragFeedback,
    accentColor: isPlaceholder ? null : accent,
    baseColor: surface,
  );
}
