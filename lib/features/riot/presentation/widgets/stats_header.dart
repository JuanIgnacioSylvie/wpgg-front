import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../domain/entities/summoner_entity.dart';

class StatsHeader extends StatelessWidget {
  const StatsHeader({
    super.key,
    required this.summoner,
  });

  final SummonerEntity summoner;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final dd = context.watch<DDragonProvider>();
    final iconUrl = dd.profileIconUrl(summoner.profileIconId);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primary, width: 2),
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: iconUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const Icon(Icons.person, size: 40),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    summoner.riotId,
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 18,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.summonerLevel(summoner.summonerLevel),
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 12),
                      Chip(
                        label: Text(summoner.region),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsHeaderEmpty extends StatelessWidget {
  const StatsHeaderEmpty({
    super.key,
    required this.onLinkTap,
    this.afterRiotLogin = false,
  });

  final VoidCallback onLinkTap;

  /// True cuando el usuario entró con Riot pero el back no pudo auto-vincular.
  final bool afterRiotLogin;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final message = afterRiotLogin
        ? l10n.linkRiotAfterLoginPrompt
        : l10n.linkRiotPrompt;
    final buttonLabel =
        afterRiotLogin ? l10n.completeRiotLinkButton : l10n.linkRiotButton;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              message,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onLinkTap,
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
