import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../domain/entities/match_entity.dart';

class MatchTile extends StatelessWidget {
  const MatchTile({super.key, required this.match});

  final MatchEntity match;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dd = context.watch<DDragonProvider>();
    final champUrl = dd.championSquareUrl(match.championName);
    final ago = _relative(match.endedAt);
    final duration = _formatDuration(match.durationSeconds);
    final endedClock = DateFormat.Hm('es').format(match.endedAt.toLocal());

    final winBg = isDark
        ? AppColors.darkSuccess.withValues(alpha: 0.12)
        : AppColors.lightSuccess.withValues(alpha: 0.12);
    final lossBg = isDark
        ? AppColors.darkError.withValues(alpha: 0.12)
        : AppColors.lightError.withValues(alpha: 0.12);

    return Card(
      color: match.win ? winBg : lossBg,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: champUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.image_not_supported),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    match.championName,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: '${match.kills}',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkSuccess
                                : AppColors.lightSuccess,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(text: ' / '),
                        TextSpan(
                          text: '${match.deaths}',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkError
                                : AppColors.lightError,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(text: ' / '),
                        TextSpan(
                          text: '${match.assists}',
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$duration · $endedClock · $ago',
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            Chip(
              label: Text(match.win ? 'Victoria' : 'Derrota'),
              backgroundColor: match.win
                  ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
                  : (isDark ? AppColors.darkError : AppColors.lightError),
              labelStyle: theme.textTheme.labelSmall?.copyWith(
                color:
                    isDark ? AppColors.darkTextPrimary : AppColors.lightSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static String _relative(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'hace instantes';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'hace ${diff.inHours} h';
    return 'hace ${diff.inDays} d';
  }
}
