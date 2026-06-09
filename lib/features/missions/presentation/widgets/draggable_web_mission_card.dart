import 'package:flutter/material.dart';

import '../../domain/entities/mission_card_entity.dart';
import 'web_mission_card.dart';

class DraggableWebMissionCard extends StatelessWidget {
  const DraggableWebMissionCard({
    super.key,
    required this.mission,
    this.endsInSeconds,
    required this.onDragStarted,
    required this.onDragEnded,
  });

  final MissionCardEntity mission;
  final int? endsInSeconds;
  final ValueChanged<String> onDragStarted;
  final VoidCallback onDragEnded;

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: mission.id,
      maxSimultaneousDrags: 1,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragStarted: () => onDragStarted(mission.id),
      onDragEnd: (_) => onDragEnded(),
      feedback: Material(
        elevation: 16,
        color: Colors.transparent,
        shadowColor: Colors.black54,
        borderRadius: BorderRadius.circular(12),
        child: Transform.rotate(
          angle: -0.02,
          child: Opacity(
            opacity: 0.94,
            child: WebMissionCard(
              mission: mission,
              endsInSeconds: endsInSeconds,
              visualState: WebMissionCardVisualState.dragFeedback,
            ),
          ),
        ),
      ),
      childWhenDragging: WebMissionCard(
        mission: mission,
        endsInSeconds: endsInSeconds,
        visualState: WebMissionCardVisualState.placeholder,
      ),
      child: WebMissionCard(
        mission: mission,
        endsInSeconds: endsInSeconds,
      ),
    );
  }
}
