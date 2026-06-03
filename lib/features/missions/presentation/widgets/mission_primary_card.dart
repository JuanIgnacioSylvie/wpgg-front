import 'package:flutter/material.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'mission_progress_ring.dart';
import 'mission_shared_widgets.dart';
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
    final showTimer = endsInSeconds != null && endsInSeconds! > 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: WpggBrand.cardSurface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 120, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MissionDifficultyHeader(difficulty: mission.difficulty),
                      const SizedBox(height: 12),
                      MissionProgressRing(
                        percent: mission.progressPercent,
                        color: color,
                        size: 88,
                        strokeWidth: 8,
                      ),
                      const SizedBox(height: 12),
                      MissionRewardRow(
                        amount: mission.rewardWpgg,
                        color: color,
                        underlined: true,
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 28),
                        RichText(
                          text: missionTitleSpans(
                            mission.title,
                            accent: color,
                          ),
                        ),
                        if (showTimer) ...[
                          const SizedBox(height: 8),
                          MissionEndsInTooltip(
                            label:
                                'Ends in: ${_formatDuration(Duration(seconds: endsInSeconds!))}',
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: -12,
              bottom: -28,
              child: Image.asset(
                'assets/images/sion_asset.png',
                width: 140,
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.person,
                  size: 120,
                  color: color.withValues(alpha: 0.3),
                ),
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
