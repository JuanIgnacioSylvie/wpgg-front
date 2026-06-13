import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MissionLayoutStore {
  MissionLayoutStore(this._prefs);

  static const _keyPrefix = 'mission_layout_order_';

  final SharedPreferences _prefs;

  static Future<MissionLayoutStore> create() async {
    return MissionLayoutStore(await SharedPreferences.getInstance());
  }

  List<String>? loadOrder(String missionDate) {
    final raw = _prefs.getString('$_keyPrefix$missionDate');
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return decoded.whereType<String>().toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveOrder(String missionDate, List<String> missionIds) async {
    await _prefs.setString(
      '$_keyPrefix$missionDate',
      jsonEncode(missionIds),
    );
  }
}
