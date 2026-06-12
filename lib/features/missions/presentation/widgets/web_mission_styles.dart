import 'package:flutter/material.dart';

import '../../../../core/presentation/web/web_colors.dart';
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
    return BoxDecoration(
      color: hovered
          ? WebColors.surfaceElevated
          : WebColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: WebColors.border.withValues(alpha: hovered ? 0.9 : 0.55),
        width: 1,
      ),
    );
  }

  final accent = difficultyColor(mission.difficulty);

  return BoxDecoration(
    color: hovered
        ? WebColors.surfaceElevated
        : webDifficultySurface(mission.difficulty),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: isPlaceholder
          ? WebColors.border
          : accent.withValues(alpha: hovered ? 0.28 : 0.16),
      width: 1,
    ),
    boxShadow: dragFeedback
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ]
        : null,
  );
}
