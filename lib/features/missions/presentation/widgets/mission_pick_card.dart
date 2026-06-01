import 'package:flutter/material.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'mission_ui_helpers.dart';

class MissionPickCard extends StatelessWidget {
  const MissionPickCard({
    super.key,
    required this.mission,
    required this.accepted,
    required this.onAccept,
    required this.onReroll,
  });

  final MissionCardEntity mission;
  final bool accepted;
  final VoidCallback onAccept;
  final VoidCallback onReroll;

  @override
  Widget build(BuildContext context) {
    final color = difficultyColor(mission.difficulty);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WpggBrand.cardSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  difficultyLabel(mission.difficulty),
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: ElevatedButton(
                  onPressed: accepted ? null : onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WpggBrand.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Icon(
                    accepted ? Icons.check : Icons.check,
                    color: WpggBrand.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: accepted ? null : onReroll,
                icon: const Icon(Icons.refresh, color: Colors.black87),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black12,
                  minimumSize: const Size(40, 40),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
