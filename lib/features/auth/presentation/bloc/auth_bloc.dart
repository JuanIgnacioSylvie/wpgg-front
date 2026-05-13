import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/oauth/riot_rso_sign_in_url.dart';
import '../../../../core/platform/navigate_browser.dart';
import '../../domain/repositories/riot_rso_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/refresh_token_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required RefreshTokenUseCase refreshTokenUseCase,
    required RiotRsoRepository riotRsoRepository,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _refreshTokenUseCase = refreshTokenUseCase,
        _riotRsoRepository = riotRsoRepository,
        super(const AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
    on<SessionChecked>(_onSessionChecked);
    on<RiotRsoSignInRequested>(_onRiotRsoSignIn);
  }

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final RiotRsoRepository _riotRsoRepository;

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(
      email: event.email,
      password: event.password,
      rememberMe: event.rememberMe,
    );
    result.fold(
      (f) => emit(AuthError(f.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onRegister(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _registerUseCase(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (f) => emit(AuthError(f.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await _logoutUseCase();
    emit(const AuthUnauthenticated());
  }

  Future<void> _onSessionChecked(
    SessionChecked event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _refreshTokenUseCase();
    result.fold(
      (_) => emit(const AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onRiotRsoSignIn(
    RiotRsoSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    if (kIsWeb) {
      final url = buildRiotRsoSignInAbsoluteUrl(
        AppConstants.baseUrl,
        requestRedirect: event.requestRedirect,
        loginHint: event.loginHint,
        uiLocales: event.uiLocales,
      );
      navigateBrowserTo(url);
      return;
    }

    final result = await _riotRsoRepository.getSignIn(
      requestRedirect: event.requestRedirect,
      loginHint: event.loginHint,
      uiLocales: event.uiLocales,
    );
    await result.fold(
      (failure) async => emit(AuthError(failure.message)),
      (signIn) async {
        final uri = Uri.parse(signIn.authorizeUrl);
        final ok = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!ok) {
          emit(const AuthError('No se pudo abrir la página de Riot'));
          return;
        }
        emit(const AuthRiotRsoSignInLaunched());
      },
    );
  }
}
