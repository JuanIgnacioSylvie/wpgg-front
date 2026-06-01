import 'package:flutter/material.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'mission_progress_ring.dart';
import 'mission_ui_helpers.dart';

class MissionPrimaryCard extends StatelessWidget {
  const MissionPrimaryCard({
    super.key,
    required this.mission,
    this.endsInSeconds,
  });

  final MissionCardEntity mission;
  final int? endsInSeconds;

  @override
  Widget build(BuildContext context) {
    final color = difficultyColor(mission.difficulty);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WpggBrand.cardSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MissionProgressRing(
                percent: mission.progressPercent,
                color: color,
                size: 88,
                strokeWidth: 8,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(difficultyIcon(mission.difficulty),
                            size: 16, color: color),
                        const SizedBox(width: 4),
                        Text(
                          difficultyLabel(mission.difficulty),
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mission.title,
                      style: TextStyle(
                        color: WpggBrand.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: WpggBrand.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${mission.rewardWpgg} WPGG',
                            style: const TextStyle(
                              color: WpggBrand.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (endsInSeconds != null && endsInSeconds! > 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Ends in: ${_formatDuration(Duration(seconds: endsInSeconds!))} (UTC)',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: -8,
            bottom: -16,
            child: Icon(
              Icons.sports_martial_arts,
              size: 100,
              color: color.withValues(alpha: 0.25),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}
