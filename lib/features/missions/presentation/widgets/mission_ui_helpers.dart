import 'package:flutter/material.dart';

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
      return Icons.eco_outlined;
    case MissionDifficulty.medium:
      return Icons.eco;
    case MissionDifficulty.hard:
      return Icons.local_fire_department;
  }
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
