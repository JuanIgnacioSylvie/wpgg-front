/// Display label for a Riot platform region code (e.g. `LA2` → `LAS (LA2)`).
String formatRiotServerLabel(String region) {
  final code = region.trim().toUpperCase();
  if (code.isEmpty) return '';

  return switch (code) {
    'NA1' => 'NA (NA1)',
    'EUW1' => 'EUW (EUW1)',
    'EUN1' => 'EUNE (EUN1)',
    'KR' => 'KR (KR)',
    'BR1' => 'BR (BR1)',
    'TR1' => 'TR (TR1)',
    'RU' => 'RU (RU1)',
    'LA1' => 'LAN (LA1)',
    'LA2' => 'LAS (LA2)',
    'OC1' => 'OCE (OCE/OC1)',
    'JP1' => 'JP (JP1)',
    'PH2' => 'PH (PH2)',
    'SG2' => 'SG (SG2)',
    'TW2' => 'TW (TW2)',
    'TH2' => 'TH (TH2)',
    'VN2' => 'VN (VN2)',
    _ => code,
  };
}
