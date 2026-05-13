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

  Future<void> clearSession() async {
    await _storage.delete(key: AppConstants.keyAccessToken);
    await _storage.delete(key: AppConstants.keyUserEmail);
  }
}
