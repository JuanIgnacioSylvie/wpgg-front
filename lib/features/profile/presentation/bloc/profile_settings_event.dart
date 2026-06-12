part of 'profile_settings_bloc.dart';

sealed class ProfileSettingsEvent extends Equatable {
  const ProfileSettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileSettings extends ProfileSettingsEvent {
  const LoadProfileSettings();
}

class UpdateProfilePublic extends ProfileSettingsEvent {
  const UpdateProfilePublic({required this.profilePublic});

  final bool profilePublic;

  @override
  List<Object?> get props => [profilePublic];
}
