import '../models/user_model.dart';

/// Respuesta de login / canje Riot / verify-email: `accessToken` y `refreshToken` en JSON.
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

  Future<String> register({
    required String email,
    required String password,
    String? turnstileToken,
    String? riotLinkPendingCode,
  });

  Future<AuthRemoteSession> verifyEmail({required String token});

  Future<void> resendVerificationEmail({
    required String email,
    String? turnstileToken,
  });

  Future<String> fetchRiotLinkAuthorizeUrl({bool mobilePlatform = false});

  Future<void> logout();

  Future<AuthRemoteSession> exchangeRiotSession({required String code});

  Future<AuthRemoteSession> refresh({String? refreshToken});

  Future<void> requestPasswordReset({required String email});

  Future<void> resetPassword({
    required String token,
    required String password,
  });
}
