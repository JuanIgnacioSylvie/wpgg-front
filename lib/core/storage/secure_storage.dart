import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

class SecureStorage {
  SecureStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<String?> getAccessToken() async {
    return _storage.read(key: AppConstants.keyAccessToken);
  }

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: AppConstants.keyAccessToken, value: token);
  }

  Future<String?> getUserEmail() async {
    return _storage.read(key: AppConstants.keyUserEmail);
  }

  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: AppConstants.keyUserEmail, value: email);
  }

  Future<void> saveRiotRsoAccessToken(String token) async {
    await _storage.write(key: AppConstants.keyRiotRsoAccessToken, value: token);
  }

  Future<void> saveRiotRsoRefreshToken(String token) async {
    await _storage.write(key: AppConstants.keyRiotRsoRefreshToken, value: token);
  }

  Future<String?> getRiotRsoAccessToken() async {
    return _storage.read(key: AppConstants.keyRiotRsoAccessToken);
  }

  Future<String?> getRiotRsoRefreshToken() async {
    return _storage.read(key: AppConstants.keyRiotRsoRefreshToken);
  }

  Future<void> clearRiotRsoTokens() async {
    await _storage.delete(key: AppConstants.keyRiotRsoAccessToken);
    await _storage.delete(key: AppConstants.keyRiotRsoRefreshToken);
  }

  Future<void> clearSession() async {
    await _storage.delete(key: AppConstants.keyAccessToken);
    await _storage.delete(key: AppConstants.keyUserEmail);
    await clearRiotRsoTokens();
  }
}
