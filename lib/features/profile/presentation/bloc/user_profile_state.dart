part of 'user_profile_bloc.dart';

sealed class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {
  const UserProfileInitial();
}

class UserProfileLoading extends UserProfileState {
  const UserProfileLoading();
}

class UserProfileLoaded extends UserProfileState {
  const UserProfileLoaded({required this.profile});

  final PublicUserProfile profile;

  @override
  List<Object?> get props => [profile];
}

class UserProfileAccessDenied extends UserProfileState {
  const UserProfileAccessDenied({required this.code});

  final String code;

  @override
  List<Object?> get props => [code];
}

class UserProfileError extends UserProfileState {
  const UserProfileError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
