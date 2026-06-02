import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/oauth/riot_rso_sign_in_url.dart';
import '../../../../core/oauth/riot_sign_in_navigate.dart';
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
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _refreshTokenUseCase = refreshTokenUseCase,
        super(const AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
    on<SessionChecked>(_onSessionChecked);
    on<RiotRsoSignInRequested>(_onRiotRsoSignIn);
    on<RiotRsoSignUpRequested>(_onRiotRsoSignUp);
  }

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;

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

  /// Nunca [GET /riot/rso/sign-in|sign-up] vía Dio: solo navegación documento (web) o
  /// [launchUrl] externo (móvil/desktop).
  Future<void> _onRiotRsoSignIn(
    RiotRsoSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _launchRiotRso(
      emit,
      buildRiotRsoSignInAbsoluteUrl(
        AppConstants.baseUrl,
        requestRedirect: event.requestRedirect,
        loginHint: event.loginHint,
        uiLocales: event.uiLocales,
      ),
    );
  }

  Future<void> _onRiotRsoSignUp(
    RiotRsoSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _launchRiotRso(
      emit,
      buildRiotRsoSignUpAbsoluteUrl(
        AppConstants.baseUrl,
        requestRedirect: event.requestRedirect,
        loginHint: event.loginHint,
        uiLocales: event.uiLocales,
      ),
    );
  }

  Future<void> _launchRiotRso(Emitter<AuthState> emit, String url) async {
    emit(const AuthLoading());
    try {
      await openRiotRsoSignInUrl(url);
      if (!kIsWeb) emit(const AuthRiotRsoSignInLaunched());
    } catch (e) {
      emit(AuthError('$e'));
    }
  }
}
