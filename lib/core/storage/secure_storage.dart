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

  Future<String?> getAuthRefreshToken() async {
    return _storage.read(key: AppConstants.keyAuthRefreshToken);
  }

  Future<void> saveAuthRefreshToken(String token) async {
    await _storage.write(key: AppConstants.keyAuthRefreshToken, value: token);
  }

  Future<void> deleteAuthRefreshToken() async {
    await _storage.delete(key: AppConstants.keyAuthRefreshToken);
  }

  Future<void> saveRiotRsoAccessToken(String token) async {
    await _storage.write(key: AppConstants.keyRiotRsoAccessToken, value: token);
  }

  Future<void> saveRiotRsoRefreshToken(String token) async {
    await _storage.write(key: AppConstants.keyRiotRsoRefreshToken, value: token);
  }

  Future<void> saveRiotRsoIdToken(String token) async {
    await _storage.write(key: AppConstants.keyRiotRsoIdToken, value: token);
  }

  Future<String?> getRiotRsoAccessToken() async {
    return _storage.read(key: AppConstants.keyRiotRsoAccessToken);
  }

  Future<String?> getRiotRsoRefreshToken() async {
    return _storage.read(key: AppConstants.keyRiotRsoRefreshToken);
  }

  Future<String?> getRiotRsoIdToken() async {
    return _storage.read(key: AppConstants.keyRiotRsoIdToken);
  }

  Future<void> clearRiotRsoTokens() async {
    await _storage.delete(key: AppConstants.keyRiotRsoAccessToken);
    await _storage.delete(key: AppConstants.keyRiotRsoRefreshToken);
    await _storage.delete(key: AppConstants.keyRiotRsoIdToken);
  }

  Future<void> markRiotRsoJustLoggedIn() async {
    await _storage.write(key: AppConstants.keyRiotRsoJustLoggedIn, value: '1');
  }

  Future<bool> consumeRiotRsoJustLoggedIn() async {
    final v = await _storage.read(key: AppConstants.keyRiotRsoJustLoggedIn);
    if (v == '1') {
      await _storage.delete(key: AppConstants.keyRiotRsoJustLoggedIn);
      return true;
    }
    return false;
  }

  Future<void> clearSession() async {
    await _storage.delete(key: AppConstants.keyAccessToken);
    await _storage.delete(key: AppConstants.keyAuthRefreshToken);
    await _storage.delete(key: AppConstants.keyUserEmail);
    await _storage.delete(key: AppConstants.keyRiotRsoJustLoggedIn);
    await clearRiotRsoTokens();
  }
}
