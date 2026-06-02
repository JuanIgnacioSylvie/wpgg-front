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
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
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
