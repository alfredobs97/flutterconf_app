part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile, this.qrData);

  final UserProfile profile;
  final String qrData;

  @override
  List<Object?> get props => [profile];
}

class ProfileGuest extends ProfileState {
  const ProfileGuest();
}

class ProfileNotFound extends ProfileState {
  const ProfileNotFound();
}

class ProfileError extends ProfileState {
  const ProfileError();
}
