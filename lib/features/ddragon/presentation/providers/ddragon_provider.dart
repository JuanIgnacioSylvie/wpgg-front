import 'package:flutter/foundation.dart';

import '../../domain/repositories/ddragon_repository.dart';

class DDragonProvider extends ChangeNotifier {
  DDragonProvider(this._repository);

  final DDragonRepository _repository;

  String? _version;
  String? _error;
  Future<void>? _ensureInFlight;

  String? get version => _version;
  String? get loadError => _error;

  static const String cdnBase = 'https://ddragon.leagueoflegends.com/cdn';

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
    r.fold(
      (f) {
        _error = f.message;
        _version = '14.1.1';
        notifyListeners();
      },
      (v) {
        _version = v;
        _error = null;
        notifyListeners();
      },
    );
  }

  String profileIconUrl(int profileIconId) {
    final v = _version ?? '14.1.1';
    return '$cdnBase/$v/img/profileicon/$profileIconId.png';
  }

  String championSquareUrl(String championName) {
    final v = _version ?? '14.1.1';
    final key = championName.replaceAll(' ', '');
    return '$cdnBase/$v/img/champion/$key.png';
  }

  String rankedEmblemUrl(String tier) {
    final v = _version ?? '14.1.1';
    final t = tier.toUpperCase();
    return '$cdnBase/$v/img/tier/$t.png';
  }
}
