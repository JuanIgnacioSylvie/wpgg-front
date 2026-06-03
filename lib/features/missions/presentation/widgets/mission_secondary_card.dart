import 'package:flutter/material.dart';

import '../../domain/entities/mission_card_entity.dart';
import 'mission_shared_widgets.dart';
import 'mission_ui_helpers.dart';

class MissionSecondaryCard extends StatelessWidget {
  const MissionSecondaryCard({
    super.key,
    required this.mission,
    this.width = 280,
  });

  final MissionCardEntity mission;
  final double width;

  @override
  Widget build(BuildContext context) {
    final color = difficultyColor(mission.difficulty);
    final bg = difficultyCardBackground(mission.difficulty);

    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              MissionDifficultyHeader(
                difficulty: mission.difficulty,
                iconSize: 16,
                fontSize: 13,
              ),
              const Spacer(),
              MissionRewardRow(
                amount: mission.rewardWpgg,
                color: color,
                fontSize: 13,
              ),
              const SizedBox(width: 8),
              MissionDifficultyIconBox(
                difficulty: mission.difficulty,
                size: 36,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            mission.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          MissionLinearProgress(
            percent: mission.progressPercent,
            color: color,
          ),
        ],
      ),
    );
  }
}
