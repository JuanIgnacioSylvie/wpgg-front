import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  const LoginRequested({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  final String email;
  final String password;
  final bool rememberMe;

  @override
  List<Object?> get props => [email, password, rememberMe];
}

class RegisterRequested extends AuthEvent {
  const RegisterRequested({
    required this.email,
    required this.password,
    this.turnstileToken,
    this.riotLinkPendingCode,
    this.thenLinkRiot = false,
  });

  final String email;
  final String password;
  final String? turnstileToken;

  /// Código de `?riot_link_pending=` tras login Riot sin cuenta WPGG.
  final String? riotLinkPendingCode;

  /// Tras verificar email, navegar a vincular Riot.
  final bool thenLinkRiot;

  @override
  List<Object?> get props =>
      [email, password, turnstileToken, riotLinkPendingCode, thenLinkRiot];
}

class VerifyEmailRequested extends AuthEvent {
  const VerifyEmailRequested({required this.token});

  final String token;

  @override
  List<Object?> get props => [token];
}

class ResendVerificationEmailRequested extends AuthEvent {
  const ResendVerificationEmailRequested({
    required this.email,
    this.turnstileToken,
  });

  final String email;
  final String? turnstileToken;

  @override
  List<Object?> get props => [email, turnstileToken];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class SessionChecked extends AuthEvent {
  const SessionChecked();
}

/// [GET /riot/rso/sign-in] y apertura de [authorizeUrl] (Riot Sign On, sin JWT de la app).
class RiotRsoSignInRequested extends AuthEvent {
  const RiotRsoSignInRequested({
    this.loginHint,
    this.uiLocales,
    this.requestRedirect = false,
  });

  final String? loginHint;
  final String? uiLocales;

  /// Si es true, el API debe responder 302 a Riot (flujo navegación documento; obligatorio en web).
  final bool requestRedirect;

  @override
  List<Object?> get props => [loginHint, uiLocales, requestRedirect];
}

/// [GET /riot/rso/link] — vincular Riot a usuario ya autenticado (JWT).
class RiotRsoLinkRequested extends AuthEvent {
  const RiotRsoLinkRequested({
    this.loginHint,
    this.uiLocales,
  });

  final String? loginHint;
  final String? uiLocales;

  @override
  List<Object?> get props => [loginHint, uiLocales];
}

/// [GET /riot/rso/sign-up] — registro explícito con Riot (`intent=register` en OAuth state).
class RiotRsoSignUpRequested extends AuthEvent {
  const RiotRsoSignUpRequested({
    this.loginHint,
    this.uiLocales,
    this.requestRedirect = false,
  });

  final String? loginHint;
  final String? uiLocales;
  final bool requestRedirect;

  @override
  List<Object?> get props => [loginHint, uiLocales, requestRedirect];
}

class PasswordResetRequested extends AuthEvent {
  const PasswordResetRequested({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

class PasswordResetConfirmRequested extends AuthEvent {
  const PasswordResetConfirmRequested({
    required this.token,
    required this.password,
  });

  final String token;
  final String password;

  @override
  List<Object?> get props => [token, password];
}
