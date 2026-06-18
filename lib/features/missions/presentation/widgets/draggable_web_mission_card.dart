import 'package:flutter/material.dart';

import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_motion.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'web_mission_card.dart';

typedef MissionReorderCallback = void Function(String draggedId, String targetId);

class DraggableWebMissionCard extends StatefulWidget {
  const DraggableWebMissionCard({
    super.key,
    required this.mission,
    required this.onDragStarted,
    required this.onDragEnded,
    this.onReorder,
    this.onTap,
  });

  final MissionCardEntity mission;
  final ValueChanged<String> onDragStarted;
  final VoidCallback onDragEnded;
  final MissionReorderCallback? onReorder;
  final VoidCallback? onTap;

  @override
  State<DraggableWebMissionCard> createState() => _DraggableWebMissionCardState();
}

class _DraggableWebMissionCardState extends State<DraggableWebMissionCard> {
  var _dragging = false;

  void _handleDragStarted() {
    setState(() => _dragging = true);
    widget.onDragStarted(widget.mission.id);
  }

  void _handleDragEnded() {
    if (_dragging) {
      setState(() => _dragging = false);
    }
    widget.onDragEnded();
  }

  @override
  Widget build(BuildContext context) {
    final duration = WebMotion.resolve(context, WebMotion.fast);
    final card = _buildDraggable(duration);

    if (widget.onReorder == null) return card;

    return DragTarget<String>(
      onWillAcceptWithDetails: (details) =>
          details.data.isNotEmpty && details.data != widget.mission.id,
      onAcceptWithDetails: (details) {
        widget.onReorder?.call(details.data, widget.mission.id);
      },
      builder: (context, candidateData, rejectedData) {
        final isDropTarget = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: duration,
          curve: WebMotion.curve,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: isDropTarget
                ? Border.all(color: WebColors.accent, width: 2)
                : null,
            boxShadow: isDropTarget
                ? [
                    BoxShadow(
                      color: WebColors.accent.withValues(alpha: 0.25),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: card,
        );
      },
    );
  }

  Widget _buildDraggable(Duration duration) {
    return Draggable<String>(
      data: widget.mission.id,
      maxSimultaneousDrags: 1,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragStarted: _handleDragStarted,
      onDragEnd: (_) => _handleDragEnded(),
      feedback: Material(
        elevation: 16,
        color: Colors.transparent,
        shadowColor: Colors.black54,
        borderRadius: BorderRadius.circular(12),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.96, end: 1),
          duration: duration,
          curve: WebMotion.curve,
          builder: (context, scale, child) => Transform.scale(
            scale: scale,
            child: child,
          ),
          child: Transform.rotate(
            angle: -0.02,
            child: Opacity(
              opacity: 0.94,
              child: WebMissionCard(
                mission: widget.mission,
                visualState: WebMissionCardVisualState.dragFeedback,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: WebMissionCard(
        mission: widget.mission,
        visualState: WebMissionCardVisualState.placeholder,
      ),
      child: AnimatedScale(
        scale: _dragging ? 0.96 : 1,
        duration: duration,
        curve: WebMotion.curve,
        child: WebMissionCard(
          mission: widget.mission,
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
