import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  LocaleProvider() {
    _load();
  }

  static const _prefKey = 'app_locale';

  Locale _locale = const Locale('es');

  Locale get locale => _locale;

  bool get isSpanish => _locale.languageCode == 'es';

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
  }

  Future<void> setEnglish() => setLocale(const Locale('en'));

  Future<void> setSpanish() => setLocale(const Locale('es'));

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey);
    if (code == 'en') {
      _locale = const Locale('en');
      notifyListeners();
    } else if (code == 'es') {
      _locale = const Locale('es');
      notifyListeners();
    }
  }
}
