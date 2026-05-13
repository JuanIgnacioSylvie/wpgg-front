import '../../domain/entities/riot_rso_entities.dart';

abstract class RiotRsoRemoteDataSource {
  Future<RiotRsoSignIn> fetchSignIn({
    bool requestRedirect = false,
    String? loginHint,
    String? uiLocales,
  });

  Future<RiotRsoTokenBundle> fetchOAuthCallback({
    required String code,
    required String state,
    bool includeUserinfo,
  });

  Future<RiotRsoTokenBundle> postRefresh({
    required String refreshToken,
    String? scope,
  });

  Future<RiotRsoUserinfo> postUserinfo({required String accessToken});
}
