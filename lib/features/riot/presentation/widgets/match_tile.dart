import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../domain/entities/match_entity.dart';

class MatchTile extends StatelessWidget {
  const MatchTile({super.key, required this.match});

  final MatchEntity match;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;
    final dd = context.read<DDragonProvider>();
    final champUrl = dd.championSquareUrl(
      match.championName,
      championId: match.championId,
    );
    final ago = _relative(l10n, match.endedAt);
    final duration = _formatDuration(match.durationSeconds);
    final endedClock = DateFormat.Hm().format(match.endedAt.toLocal());

    final cardColor = _cardColor(isDark, match.win);
    final accent = match.win
        ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
        : (isDark ? AppColors.darkError : AppColors.lightError);

    return Card(
      color: cardColor,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _championAvatar(context, champUrl, onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match.championName.isNotEmpty
                            ? match.championName
                            : l10n.matchChampionFallback(match.championId),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: onSurface),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${match.kills} / ${match.deaths} / ${match.assists}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$duration · $endedClock · $ago',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  match.win ? l10n.matchWin : l10n.matchLoss,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _championAvatar(
    BuildContext context,
    String champUrl,
    Color iconColor,
  ) {
    final placeholder = Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.darkBorder,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.person, color: iconColor),
    );

    if (champUrl.isEmpty) return placeholder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: champUrl,
        width: 52,
        height: 52,
        fit: BoxFit.cover,
        placeholder: (_, __) => placeholder,
        errorWidget: (_, __, ___) => placeholder,
      ),
    );
  }

  static Color _cardColor(bool isDark, bool win) {
    if (isDark) {
      return win ? const Color(0xFF1A3A2E) : const Color(0xFF3A1F28);
    }
    return win ? const Color(0xFFD4EDDA) : const Color(0xFFF8D7DA);
  }

  static String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static String _relative(AppLocalizations l10n, DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.isNegative || diff.inMinutes < 1) return l10n.timeAgoJustNow;
    if (diff.inMinutes < 60) return l10n.timeAgoMinutes(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeAgoHours(diff.inHours);
    return l10n.timeAgoDays(diff.inDays);
  }
}
