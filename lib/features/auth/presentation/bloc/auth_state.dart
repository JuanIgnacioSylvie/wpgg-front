import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

/// Registro OK; falta vincular Riot antes de entrar a la app.
class AuthRegisteredPendingRiotLink extends AuthState {
  const AuthRegisteredPendingRiotLink(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Se abrió el navegador / pestaña hacia Riot tras [RiotRsoSignInRequested].
class AuthRiotRsoSignInLaunched extends AuthState {
  const AuthRiotRsoSignInLaunched();
}

/// Login Riot sin cuenta WPGG (móvil).
class AuthRiotOAuthUserNotFound extends AuthState {
  const AuthRiotOAuthUserNotFound({this.riotLinkPendingCode});

  final String? riotLinkPendingCode;

  @override
  List<Object?> get props => [riotLinkPendingCode];
}

/// Registro Riot con cuenta WPGG ya existente (móvil).
class AuthRiotOAuthUserAlreadyExists extends AuthState {
  const AuthRiotOAuthUserAlreadyExists();
}

class AuthPasswordResetEmailSent extends AuthState {
  const AuthPasswordResetEmailSent();
}

class AuthPasswordResetCompleted extends AuthState {
  const AuthPasswordResetCompleted();
}
