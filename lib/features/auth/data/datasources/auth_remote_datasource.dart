import '../models/user_model.dart';

/// Respuesta de login / register / canje Riot: siempre `accessToken` y `refreshToken` en JSON.
/// En [AuthRemoteDataSource.refresh] el refresh en JSON es opcional si el back renueva solo por cookie.
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

  /// Canje del código `?riot_session=` tras Riot Sign On → `{ accessToken, refreshToken }`.
  Future<AuthRemoteSession> exchangeRiotSession({required String code});

  /// [refreshToken] opcional: el back acepta cookie `refreshToken` o `body.refreshToken`.
  Future<AuthRemoteSession> refresh({String? refreshToken});
}
