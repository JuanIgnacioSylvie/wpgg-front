import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../domain/entities/ranked_entry_entity.dart';

class RankedBadge extends StatelessWidget {
  const RankedBadge({super.key, required this.entry});

  final RankedEntryEntity entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dd = context.watch<DDragonProvider>();
    final emblemUrl = dd.rankedEmblemUrl(entry.tier);
    final winrate = entry.winrate;
    final bar = winrate >= 50
        ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
        : (isDark ? AppColors.darkError : AppColors.lightError);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.queueType,
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: emblemUrl,
                  width: 56,
                  height: 56,
                  errorWidget: (_, __, ___) => const Icon(Icons.military_tech),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.tier} ${entry.rank}',
                        style: theme.textTheme.displayLarge?.copyWith(fontSize: 22),
                      ),
                      Text(
                        '${entry.leaguePoints} LP · ${entry.wins}W ${entry.losses}L',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Winrate ${winrate.toStringAsFixed(0)}%',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (winrate / 100).clamp(0, 1),
                minHeight: 6,
                backgroundColor: theme.dividerColor,
                valueColor: AlwaysStoppedAnimation<Color>(bar),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
