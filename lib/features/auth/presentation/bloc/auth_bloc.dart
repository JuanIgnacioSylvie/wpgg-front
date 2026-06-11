import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/auth_error_codes.dart';
import '../../../../core/oauth/riot_rso_mobile_auth.dart';
import '../../../../core/oauth/riot_rso_sign_in_url.dart';
import '../../../../core/oauth/riot_sign_in_navigate.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/refresh_token_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/request_password_reset_usecase.dart';
import '../../domain/usecases/resend_verification_email_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/verify_email_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required VerifyEmailUseCase verifyEmailUseCase,
    required ResendVerificationEmailUseCase resendVerificationEmailUseCase,
    required LogoutUseCase logoutUseCase,
    required RefreshTokenUseCase refreshTokenUseCase,
    required RequestPasswordResetUseCase requestPasswordResetUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _verifyEmailUseCase = verifyEmailUseCase,
        _resendVerificationEmailUseCase = resendVerificationEmailUseCase,
        _logoutUseCase = logoutUseCase,
        _refreshTokenUseCase = refreshTokenUseCase,
        _requestPasswordResetUseCase = requestPasswordResetUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        _authRepository = authRepository,
        super(const AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<VerifyEmailRequested>(_onVerifyEmail);
    on<ResendVerificationEmailRequested>(_onResendVerification);
    on<LogoutRequested>(_onLogout);
    on<SessionChecked>(_onSessionChecked);
    on<RiotRsoSignInRequested>(_onRiotRsoSignIn);
    on<RiotRsoSignUpRequested>(_onRiotRsoSignUp);
    on<RiotRsoLinkRequested>(_onRiotRsoLink);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<PasswordResetConfirmRequested>(_onPasswordResetConfirm);
  }

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final ResendVerificationEmailUseCase _resendVerificationEmailUseCase;
  final LogoutUseCase _logoutUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final RequestPasswordResetUseCase _requestPasswordResetUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final AuthRepository _authRepository;

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
      turnstileToken: event.turnstileToken,
      riotLinkPendingCode: event.riotLinkPendingCode,
    );
    result.fold(
      (f) => emit(AuthError(f.message)),
      (email) => emit(AuthRegistrationPendingVerification(email)),
    );
  }

  Future<void> _onVerifyEmail(
    VerifyEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _verifyEmailUseCase(token: event.token);
    result.fold(
      (f) => emit(AuthError(f.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onResendVerification(
    ResendVerificationEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _resendVerificationEmailUseCase(
      email: event.email,
      turnstileToken: event.turnstileToken,
    );
    result.fold(
      (f) => emit(AuthError(f.message)),
      (_) => emit(const AuthVerificationEmailSent()),
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

  /// Web: navegación documento. Móvil: Custom Tab + deep link `wpgg://`.
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
        mobilePlatform: !kIsWeb,
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
        mobilePlatform: !kIsWeb,
      ),
    );
  }

  Future<void> _onRiotRsoLink(
    RiotRsoLinkRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _authRepository.fetchRiotLinkAuthorizeUrl(
      mobilePlatform: !kIsWeb,
    );
    await result.fold(
      (f) async => emit(AuthError(f.message)),
      (url) async {
        try {
          if (kIsWeb) {
            await openRiotRsoSignInUrl(url);
          } else {
            await _completeMobileRiotOAuth(emit, url);
          }
        } catch (e) {
          emit(AuthError('$e'));
        }
      },
    );
  }

  Future<void> _launchRiotRso(Emitter<AuthState> emit, String url) async {
    emit(const AuthLoading());
    try {
      if (kIsWeb) {
        await openRiotRsoSignInUrl(url);
      } else {
        await _completeMobileRiotOAuth(emit, url);
      }
    } catch (e) {
      emit(AuthError('$e'));
    }
  }

  Future<void> _completeMobileRiotOAuth(
    Emitter<AuthState> emit,
    String signInUrl,
  ) async {
    final outcome = await authenticateRiotRsoMobile(signInUrl);
    if (outcome.cancelled) {
      emit(const AuthUnauthenticated());
      return;
    }
    if (outcome.oauthError == 'user_not_found') {
      emit(AuthRiotOAuthUserNotFound(
        riotLinkPendingCode: outcome.riotLinkPendingCode,
      ));
      return;
    }
    if (outcome.oauthError == 'user_already_exists') {
      emit(const AuthRiotOAuthUserAlreadyExists());
      return;
    }
    if (outcome.hasOAuthError) {
      final desc = outcome.oauthErrorDescription;
      final msg = desc != null && desc.isNotEmpty
          ? '${outcome.oauthError}: $desc'
          : outcome.oauthError!;
      emit(AuthError(msg));
      return;
    }
    if (!outcome.hasRiotSessionCode) {
      emit(const AuthError(AuthErrorCodes.riotNoSession));
      return;
    }

    final exchanged = await _authRepository.exchangeRiotSession(
      code: outcome.riotSessionCode!,
    );
    exchanged.fold(
      (f) => emit(AuthError(f.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _requestPasswordResetUseCase(email: event.email);
    result.fold(
      (f) => emit(AuthError(f.message)),
      (_) => emit(const AuthPasswordResetEmailSent()),
    );
  }

  Future<void> _onPasswordResetConfirm(
    PasswordResetConfirmRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _resetPasswordUseCase(
      token: event.token,
      password: event.password,
    );
    result.fold(
      (f) => emit(AuthError(f.message)),
      (_) => emit(const AuthPasswordResetCompleted()),
    );
  }
}
