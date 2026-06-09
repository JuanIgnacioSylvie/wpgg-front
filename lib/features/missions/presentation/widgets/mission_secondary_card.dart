import 'package:flutter/material.dart';

import '../../../../core/extensions/mission_card_l10n.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'mission_shared_widgets.dart';
import 'mission_ui_helpers.dart';

class MissionSecondaryCard extends StatelessWidget {
  const MissionSecondaryCard({
    super.key,
    required this.mission,
    this.width = 280,
    this.onCancel,
  });

  final MissionCardEntity mission;
  final double width;
  final VoidCallback? onCancel;

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
              if (onCancel != null)
                IconButton(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close, size: 18),
                  color: Colors.black45,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                ),
              MissionRewardRow(
                amount: mission.rewardWpgg,
                color: color,
                fontSize: 13,
                coinSize: 24,
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
            mission.localizedTitle(context),
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
