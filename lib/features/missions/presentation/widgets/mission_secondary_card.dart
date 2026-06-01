import 'package:flutter/material.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'mission_progress_ring.dart';
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
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WpggBrand.cardSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(difficultyIcon(mission.difficulty), color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusLabel(mission.status),
                  style: const TextStyle(fontSize: 11, color: Colors.black45),
                ),
              ],
            ),
          ),
          MissionProgressRing(
            percent: mission.progressPercent,
            color: color,
            size: 52,
            strokeWidth: 4,
          ),
        ],
      ),
    );
  }
}
