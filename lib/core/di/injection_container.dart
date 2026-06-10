import 'package:get_it/get_it.dart';

import '../config/app_public_config.dart';
import '../constants/app_constants.dart';
import '../network/api_client.dart';
import '../network/cdn_client.dart';
import '../storage/secure_storage.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource_impl.dart';
import '../../features/auth/data/datasources/riot_rso_remote_datasource.dart';
import '../../features/auth/data/datasources/riot_rso_remote_datasource_impl.dart';
import '../../features/auth/data/repositories/riot_rso_repository_impl.dart';
import '../../features/auth/domain/repositories/riot_rso_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/refresh_token_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/request_password_reset_usecase.dart';
import '../../features/auth/domain/usecases/resend_verification_email_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/verify_email_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/ddragon/data/datasources/ddragon_remote_datasource.dart';
import '../../features/ddragon/data/repositories/ddragon_repository_impl.dart';
import '../../features/ddragon/domain/repositories/ddragon_repository.dart';
import '../../features/riot/data/datasources/riot_remote_datasource.dart';
import '../../features/riot/data/datasources/riot_remote_datasource_impl.dart';
import '../../features/riot/data/repositories/riot_repository_impl.dart';
import '../../features/riot/domain/repositories/riot_repository.dart';
import '../../features/riot/domain/usecases/get_match_history_usecase.dart';
import '../../features/riot/domain/usecases/get_ranked_stats_usecase.dart';
import '../../features/riot/domain/usecases/get_summoner_profile_usecase.dart';
import '../../features/riot/domain/usecases/link_riot_account_usecase.dart';
import '../../features/riot/presentation/bloc/riot_bloc.dart';
import '../../features/missions/data/datasources/missions_remote_datasource.dart';
import '../../features/missions/presentation/bloc/missions_bloc.dart';
import '../../features/store/data/datasources/store_remote_datasource.dart';
import '../../features/store/presentation/bloc/store_bloc.dart';
import '../../features/wallet/data/datasources/wallet_remote_datasource.dart';
import '../../features/wallet/presentation/bloc/wallet_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton(SecureStorage.new);
  sl.registerLazySingleton(CdnClient.new);
  sl.registerLazySingleton(
    () => ApiClient(
      baseUrl: AppConstants.baseUrl,
      secureStorage: sl(),
    ),
  );

  await AppPublicConfig.load(sl<ApiClient>());

  sl.registerLazySingleton<DDragonRemoteDataSource>(
    () => DDragonRemoteDataSource(sl<CdnClient>()),
  );
  sl.registerLazySingleton<DDragonRepository>(
    () => DDragonRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      secureStorage: sl(),
    ),
  );
  sl.registerLazySingleton<RiotRsoRemoteDataSource>(
    () => RiotRsoRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<RiotRsoRepository>(
    () => RiotRsoRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));
  sl.registerLazySingleton(() => ResendVerificationEmailUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => RefreshTokenUseCase(sl()));
  sl.registerLazySingleton(() => RequestPasswordResetUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      verifyEmailUseCase: sl(),
      resendVerificationEmailUseCase: sl(),
      logoutUseCase: sl(),
      refreshTokenUseCase: sl(),
      requestPasswordResetUseCase: sl(),
      resetPasswordUseCase: sl(),
      authRepository: sl(),
    ),
  );

  sl.registerLazySingleton<RiotRemoteDataSource>(
    () => RiotRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<RiotRepository>(
    () => RiotRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetSummonerProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetMatchHistoryUseCase(sl()));
  sl.registerLazySingleton(() => GetRankedStatsUseCase(sl()));
  sl.registerLazySingleton(() => LinkRiotAccountUseCase(sl()));
  sl.registerLazySingleton(
    () => RiotBloc(
      getSummonerProfile: sl(),
      getMatchHistory: sl(),
      getRankedStats: sl(),
      linkRiotAccount: sl(),
    ),
  );

  sl.registerLazySingleton<MissionsRemoteDataSource>(
    () => MissionsRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton(
    () => MissionsBloc(sl<MissionsRemoteDataSource>()),
  );

  sl.registerLazySingleton<WalletRemoteDataSource>(
    () => WalletRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton(
    () => WalletBloc(sl<WalletRemoteDataSource>()),
  );

  sl.registerLazySingleton<StoreRemoteDataSource>(
    () => StoreRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton(
    () => StoreBloc(sl<StoreRemoteDataSource>()),
  );
}
