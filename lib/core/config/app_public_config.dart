import 'package:flutter/foundation.dart' show kIsWeb;

import '../constants/app_constants.dart';
import '../network/api_client.dart';

/// Runtime public config from the API (Turnstile site key, etc.).
abstract final class AppPublicConfig {
  static String _turnstileSiteKey = AppConstants.turnstileSiteKey;

  static String get turnstileSiteKey => _turnstileSiteKey;

  static bool get turnstileEnabled =>
      kIsWeb && _turnstileSiteKey.isNotEmpty;

  static Future<void> load(ApiClient api) async {
    if (!kIsWeb) return;

    if (AppConstants.turnstileSiteKey.isNotEmpty) {
      _turnstileSiteKey = AppConstants.turnstileSiteKey;
      return;
    }

    try {
      final res = await api.get<Map<String, dynamic>>('/health/public-config');
      final key = res.data?['turnstileSiteKey'] as String? ?? '';
      if (key.isNotEmpty) {
        _turnstileSiteKey = key;
      }
    } catch (_) {
      // Keep compile-time default (empty) when offline or API unavailable.
    }
  }
}
