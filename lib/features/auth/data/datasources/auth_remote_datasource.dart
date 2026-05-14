import '../models/user_model.dart';

/// Respuesta de login / register / refresh: siempre [accessToken]; [refreshToken] solo
/// si el back lo manda en JSON (p. ej. SPA sin cookie cross-site).
typedef AuthRemoteSession = ({
  UserModel user,
  String accessToken,
  String? refreshToken,
});

abstract class AuthRemoteDataSource {
  Future<AuthRemoteSession> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<AuthRemoteSession> register({
    required String email,
    required String password,
  });

  Future<void> logout();

  /// [refreshToken] opcional: el back acepta cookie `refreshToken` o `body.refreshToken`.
  Future<AuthRemoteSession> refresh({String? refreshToken});
}
