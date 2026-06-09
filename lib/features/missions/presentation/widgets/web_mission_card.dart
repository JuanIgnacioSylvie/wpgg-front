import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/extensions/mission_card_l10n.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_motion.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'mission_ui_helpers.dart';

enum WebMissionCardVariant { active, past, empty }

enum WebMissionCardVisualState { normal, placeholder, dragFeedback }

class WebMissionCard extends StatefulWidget {
  const WebMissionCard({
    super.key,
    required this.mission,
    this.endsInSeconds,
    this.variant = WebMissionCardVariant.active,
    this.visualState = WebMissionCardVisualState.normal,
    this.onTap,
  });

  const WebMissionCard.empty({super.key, this.onTap})
      : mission = null,
        endsInSeconds = null,
        variant = WebMissionCardVariant.empty,
        visualState = WebMissionCardVisualState.normal;

  final MissionCardEntity? mission;
  final int? endsInSeconds;
  final WebMissionCardVariant variant;
  final WebMissionCardVisualState visualState;
  final VoidCallback? onTap;

  @override
  State<WebMissionCard> createState() => _WebMissionCardState();
}

class _WebMissionCardState extends State<WebMissionCard> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    if (widget.variant == WebMissionCardVariant.empty) {
      return _EmptyCard(
        onTap: widget.onTap,
        hovered: _hovered,
        onHover: _setHovered,
      );
    }

    final mission = widget.mission!;
    final color = difficultyColor(mission.difficulty);
    final isPast = widget.variant == WebMissionCardVariant.past;
    final isCompleted = mission.status == MissionStatus.completed ||
        mission.progressPercent >= 100;
    final isPlaceholder =
        widget.visualState == WebMissionCardVisualState.placeholder;
    final isDragFeedback =
        widget.visualState == WebMissionCardVisualState.dragFeedback;
    final interactive = !isPlaceholder && !isDragFeedback;

    return MouseRegion(
      onEnter: interactive ? (_) => _setHovered(true) : null,
      onExit: interactive ? (_) => _setHovered(false) : null,
      child: GestureDetector(
        onTap: interactive ? widget.onTap : null,
        child: AnimatedOpacity(
          opacity: isPlaceholder ? 0.35 : 1,
          duration: const Duration(milliseconds: 150),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 280,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _hovered && interactive
                  ? WebColors.surfaceElevated
                  : WebColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isPlaceholder
                    ? WebColors.border
                    : (_hovered && interactive
                        ? WebColors.border
                        : WebColors.borderSubtle),
                width: isPlaceholder ? 1.5 : 1,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              boxShadow: isDragFeedback
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : (_hovered && interactive
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        difficultyIcon(mission.difficulty),
                        color: color,
                        size: 20,
                      ),
                    ),
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
                              fontFamily: AppFonts.lexendDeca,
                              color: WebColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            difficultyLabel(mission.difficulty, context.l10n),
                            style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isPast
                            ? (isCompleted
                                ? WebColors.online
                                : WebColors.textMuted)
                            : WebColors.online,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isPast
                          ? statusLabel(mission.status, context.l10n)
                          : context.l10n.statusInProgress,
                      style: const TextStyle(
                        color: WebColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/wpgg-coin_24x24.png',
                          width: 16,
                          height: 16,
                          filterQuality: FilterQuality.high,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${mission.rewardWpgg}',
                          style: const TextStyle(
                            color: WebColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (!isPast) ...[
                  const SizedBox(height: 12),
                  WebAnimatedProgressBar(
                    value: mission.progressPercent / 100,
                    color: color,
                    backgroundColor: WebColors.border,
                  ),
                  const SizedBox(height: 6),
                  _AnimatedPercentLabel(
                    percent: mission.progressPercent,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setHovered(bool value) {
    if (_hovered != value) setState(() => _hovered = value);
  }
}

class _AnimatedPercentLabel extends StatefulWidget {
  const _AnimatedPercentLabel({required this.percent});

  final int percent;

  @override
  State<_AnimatedPercentLabel> createState() => _AnimatedPercentLabelState();
}

class _AnimatedPercentLabelState extends State<_AnimatedPercentLabel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: WebMotion.progress,
    );
    _animation = Tween<double>(begin: 0, end: widget.percent.toDouble())
        .animate(CurvedAnimation(parent: _controller, curve: WebMotion.curve));
    _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedPercentLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percent != widget.percent) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.percent.toDouble(),
      ).animate(CurvedAnimation(parent: _controller, curve: WebMotion.curve));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Text(
          '${_animation.value.round()}%',
          style: const TextStyle(
            color: WebColors.textMuted,
            fontSize: 11,
          ),
        );
      },
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({
    required this.onTap,
    required this.hovered,
    required this.onHover,
  });

  final VoidCallback? onTap;
  final bool hovered;
  final ValueChanged<bool> onHover;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 280,
          height: 160,
          decoration: BoxDecoration(
            color: hovered
                ? WebColors.surfaceElevated
                : WebColors.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hovered ? WebColors.accent : WebColors.border,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Symbols.add_circle_outline,
                color: hovered ? WebColors.accent : WebColors.textMuted,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.pickMissions,
                style: TextStyle(
                  color:
                      hovered ? WebColors.textPrimary : WebColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.noActiveMissions,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: WebColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
