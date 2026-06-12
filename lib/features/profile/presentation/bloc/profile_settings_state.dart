part of 'profile_settings_bloc.dart';

sealed class ProfileSettingsState extends Equatable {
  const ProfileSettingsState();

  @override
  List<Object?> get props => [];
}

class ProfileSettingsInitial extends ProfileSettingsState {
  const ProfileSettingsInitial();
}

class ProfileSettingsLoading extends ProfileSettingsState {
  const ProfileSettingsLoading();
}

class ProfileSettingsLoaded extends ProfileSettingsState {
  const ProfileSettingsLoaded({
    required this.profilePublic,
    this.saving = false,
    this.errorMessage,
  });

  final bool profilePublic;
  final bool saving;
  final String? errorMessage;

  @override
  List<Object?> get props => [profilePublic, saving, errorMessage];
}

class ProfileSettingsError extends ProfileSettingsState {
  const ProfileSettingsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
