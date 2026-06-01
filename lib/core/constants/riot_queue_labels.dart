/// Human-readable labels for Riot `queueType` values.
String riotQueueLabel(String queueType) {
  switch (queueType) {
    case 'RANKED_SOLO_5x5':
      return 'Solo/Duo';
    case 'RANKED_FLEX_SR':
      return 'Flex 5v5';
    case 'RANKED_TFT':
      return 'TFT Clasificatoria';
    case 'CHERRY':
      return 'Arena';
    case 'ARAM':
      return 'ARAM';
    case 'NORMAL':
      return 'Normal';
    default:
      return queueType
          .replaceAll('_', ' ')
          .toLowerCase()
          .split(' ')
          .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
          .join(' ');
  }
}
