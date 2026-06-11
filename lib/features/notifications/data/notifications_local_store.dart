import 'package:shared_preferences/shared_preferences.dart';

class NotificationsLocalStore {
  NotificationsLocalStore(this._prefs);

  static const prefEnabled = 'notifications_enabled';
  static const prefToken = 'fcm_token';

  final SharedPreferences _prefs;

  static Future<NotificationsLocalStore> create() async {
    return NotificationsLocalStore(await SharedPreferences.getInstance());
  }

  bool get enabled => _prefs.getBool(prefEnabled) ?? false;

  Future<void> setEnabled(bool value) => _prefs.setBool(prefEnabled, value);

  String? get token => _prefs.getString(prefToken);

  Future<void> setToken(String? value) async {
    if (value == null || value.isEmpty) {
      await _prefs.remove(prefToken);
      return;
    }
    await _prefs.setString(prefToken, value);
  }
}
