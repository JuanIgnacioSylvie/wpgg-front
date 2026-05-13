import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<(UserModel, String)> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<(UserModel, String)> register({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<(UserModel, String)> refresh();
}
