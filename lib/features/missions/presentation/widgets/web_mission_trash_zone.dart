import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';

class WebMissionTrashZone extends StatelessWidget {
  const WebMissionTrashZone({
    super.key,
    required this.onAccept,
  });

  final ValueChanged<String> onAccept;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DragTarget<String>(
      onWillAcceptWithDetails: (details) => details.data.isNotEmpty,
      onAcceptWithDetails: (details) => onAccept(details.data),
      builder: (context, candidateData, rejectedData) {
        final hovering = candidateData.isNotEmpty;

        return AnimatedScale(
          scale: hovering ? 1.12 : 1,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: hovering
                  ? WebColors.accent.withValues(alpha: 0.18)
                  : WebColors.surfaceElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hovering ? WebColors.accent : WebColors.border,
                width: hovering ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: hovering ? 0.45 : 0.3),
                  blurRadius: hovering ? 24 : 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Symbols.delete,
                  color: hovering ? WebColors.accent : WebColors.textMuted,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.dropToDeleteMission,
                  style: TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    color: hovering
                        ? WebColors.textPrimary
                        : WebColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
