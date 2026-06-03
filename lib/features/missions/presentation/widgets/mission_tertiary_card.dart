import 'package:flutter/material.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/extensions/mission_card_l10n.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'mission_progress_ring.dart';
import 'mission_shared_widgets.dart';
import 'mission_ui_helpers.dart';

class MissionTertiaryCard extends StatelessWidget {
  const MissionTertiaryCard({
    super.key,
    required this.mission,
  });

  final MissionCardEntity mission;

  @override
  Widget build(BuildContext context) {
    final color = difficultyColor(mission.difficulty);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: WpggBrand.cardSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          MissionDifficultyIconBox(difficulty: mission.difficulty),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.localizedTitle(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusLabel(mission.status, l10n),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
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
