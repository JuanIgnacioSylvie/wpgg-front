import 'package:flutter/foundation.dart';

import '../../domain/repositories/ddragon_repository.dart';

class DDragonProvider extends ChangeNotifier {
  DDragonProvider(this._repository);

  final DDragonRepository _repository;

  String? _version;
  String? _error;
  Map<int, String> _championKeys = {};
  Future<void>? _ensureInFlight;

  String? get version => _version;
  String? get loadError => _error;

  static const String cdnBase = 'https://ddragon.leagueoflegends.com/cdn';

  /// Ranked tier emblems are not on DDragon (`/img/tier/` returns 403).
  static const String rankedEmblemBase =
      'https://raw.communitydragon.org/latest/plugins/rcp-fe-lol-static-assets/global/default/images/ranked-emblem';

  Future<void> ensureLoaded() async {
    if (_version != null) return;
    _ensureInFlight ??= _loadVersionOnce();
    try {
      await _ensureInFlight;
    } finally {
      _ensureInFlight = null;
    }
  }

  Future<void> _loadVersionOnce() async {
    final r = await _repository.getLatestVersion();
    await r.fold<Future<void>>(
      (f) async {
        _error = f.message;
        _version = '14.1.1';
        await _loadChampionKeys(_version!);
        notifyListeners();
      },
      (v) async {
        _version = v;
        _error = null;
        await _loadChampionKeys(v);
        notifyListeners();
      },
    );
  }

  Future<void> _loadChampionKeys(String version) async {
    final r = await _repository.getChampionKeys(version);
    r.fold(
      (_) => _championKeys = {},
      (keys) => _championKeys = keys,
    );
  }

  String profileIconUrl(int profileIconId) {
    final v = _version ?? '14.1.1';
    return '$cdnBase/$v/img/profileicon/$profileIconId.png';
  }

  String championSquareUrl(String championName, {int championId = 0}) {
    final v = _version ?? '14.1.1';
    final fromId = championId > 0 ? _championKeys[championId] : null;
    final key = (fromId ?? championName).replaceAll(' ', '').replaceAll("'", '');
    if (key.isEmpty) return '';
    return '$cdnBase/$v/img/champion/$key.png';
  }

  String rankedEmblemUrl(String tier) {
    final t = tier.trim().toLowerCase();
    if (t.isEmpty) return '';
    return '$rankedEmblemBase/emblem-$t.png';
  }
}
