import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/extensions/mission_card_l10n.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'web_mission_styles.dart';
import 'mission_card_countdown.dart';
import 'mission_progress_detail.dart';
import 'mission_shared_widgets.dart';
import 'mission_ui_helpers.dart';

enum WebMissionCardVariant { active, past, empty }

enum WebMissionCardVisualState { normal, placeholder, dragFeedback }

class WebMissionCard extends StatefulWidget {
  const WebMissionCard({
    super.key,
    required this.mission,
    this.variant = WebMissionCardVariant.active,
    this.visualState = WebMissionCardVisualState.normal,
    this.onTap,
  });

  const WebMissionCard.empty({super.key, this.onTap})
      : mission = null,
        variant = WebMissionCardVariant.empty,
        visualState = WebMissionCardVisualState.normal;

  final MissionCardEntity? mission;
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
    final color = missionAccentColor(mission);
    final isPast = widget.variant == WebMissionCardVariant.past;
    final isCompleted = mission.status == MissionStatus.completed;
    final isPlaceholder =
        widget.visualState == WebMissionCardVisualState.placeholder;
    final isDragFeedback =
        widget.visualState == WebMissionCardVisualState.dragFeedback;
    final interactive = !isPlaceholder && !isDragFeedback;

    return MouseRegion(
      onEnter: interactive ? (_) => _setHovered(true) : null,
      onExit: interactive ? (_) => _setHovered(false) : null,
      cursor: interactive && widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      child: GestureDetector(
        onTap: interactive ? widget.onTap : null,
        child: AnimatedOpacity(
          opacity: isPlaceholder ? 0.35 : 1,
          duration: const Duration(milliseconds: 150),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 280,
            padding: const EdgeInsets.all(16),
            decoration: webMissionCardDecoration(
              mission,
              hovered: _hovered && interactive,
              isPlaceholder: isPlaceholder,
              dragFeedback: isDragFeedback,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    MissionLeadingIcon(
                      mission: mission,
                      size: 36,
                      borderRadius: 8,
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
                          if (mission.hasAssignedChampion) ...[
                            const SizedBox(height: 2),
                            MissionAssignedChampionLabel(
                              mission: mission,
                              useWebStyle: true,
                              accentColor: color,
                            ),
                          ],
                          const SizedBox(height: 2),
                          Text(
                            mission.isWelcome
                                ? context.l10n.welcomeMissionBadge
                                : difficultyLabel(
                                    mission.difficulty,
                                    context.l10n,
                                  ),
                            style: TextStyle(
                              color: mission.isWelcome
                                  ? WpggBrand.welcomeAccent
                                  : color,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isPast && mission.endsAt != null) ...[
                  const SizedBox(height: 8),
                  MissionCardCountdown(
                    endsAt: mission.endsAt,
                    accentColor: color,
                    useWebStyle: true,
                  ),
                ],
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
                      statusLabel(mission.status, context.l10n),
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
                  MissionProgressDetail(
                    mission: mission,
                    useWebStyle: true,
                    showBars: true,
                    accentColor: color,
                  ),
                ] else if (mission.progressLines.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  MissionProgressDetail(
                    mission: mission,
                    useWebStyle: true,
                    showBars: true,
                    accentColor: isCompleted
                        ? WebColors.online
                        : WebColors.textMuted,
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
                Icons.add_circle_outline,
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
