/// Short display label for a Riot platform region (e.g. `LA2` → `LAS`).
String formatRiotServerLabel(String region) {
  final code = region.trim().toUpperCase();
  if (code.isEmpty) return '';

  return switch (code) {
    'NA1' => 'NA',
    'EUW1' => 'EUW',
    'EUN1' => 'EUNE',
    'KR' => 'KR',
    'BR1' => 'BR',
    'TR1' => 'TR',
    'RU' => 'RU',
    'LA1' => 'LAN',
    'LA2' => 'LAS',
    'OC1' => 'OCE',
    'JP1' => 'JP',
    'PH2' => 'PH',
    'SG2' => 'SG',
    'TW2' => 'TW',
    'TH2' => 'TH',
    'VN2' => 'VN',
    _ => code,
  };
}
