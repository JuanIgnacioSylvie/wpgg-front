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
      return 0.1;
    case MissionDifficulty.medium:
      return 0.14;
    case MissionDifficulty.hard:
      return 0.18;
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
          : Color.alphaBlend(
              const Color(0xFFE8A317).withValues(alpha: 0.12),
              WebColors.surface,
            ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFFE8A317).withValues(alpha: hovered ? 0.65 : 0.45),
        width: 2,
      ),
    );
  }

  final accent = difficultyColor(mission.difficulty);
  final baseShadow = mission.difficulty == MissionDifficulty.hard && !hovered
      ? [
          BoxShadow(
            color: accent.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ]
      : null;

  return BoxDecoration(
    color: hovered
        ? WebColors.surfaceElevated
        : webDifficultySurface(mission.difficulty),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: isPlaceholder
          ? WebColors.border
          : accent.withValues(alpha: hovered ? 0.6 : 0.42),
      width: difficultyBorderWidth(mission.difficulty),
    ),
    boxShadow: dragFeedback
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ]
        : baseShadow,
  );
}
