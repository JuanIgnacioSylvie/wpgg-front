import '../../l10n/app_localizations.dart';

/// Human-readable labels for Riot `queueType` values.
String riotQueueLabel(AppLocalizations l10n, String queueType) {
  switch (queueType) {
    case 'RANKED_SOLO_5x5':
      return l10n.queueRankedSolo;
    case 'RANKED_FLEX_SR':
      return l10n.queueRankedFlex;
    case 'RANKED_TFT':
      return l10n.queueRankedTft;
    case 'CHERRY':
      return l10n.queueArena;
    case 'ARAM':
      return l10n.queueAram;
    case 'NORMAL':
      return l10n.queueNormal;
    default:
      return queueType
          .replaceAll('_', ' ')
          .toLowerCase()
          .split(' ')
          .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
          .join(' ');
  }
}
