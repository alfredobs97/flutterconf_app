part of 'scanned_profiles_cubit.dart';

sealed class ScannedProfilesState extends Equatable {
  const ScannedProfilesState();

  @override
  List<Object> get props => [];
}

final class ScannedProfilesInitial extends ScannedProfilesState {
  const ScannedProfilesInitial();
}

final class ScannedProfilesLoading extends ScannedProfilesState {
  const ScannedProfilesLoading();
}

final class ScannedProfilesLoaded extends ScannedProfilesState {
  const ScannedProfilesLoaded(this.profiles);

  final List<ScannedProfile> profiles;

  @override
  List<Object> get props => [profiles];
}

final class ScannedProfilesError extends ScannedProfilesState {
  const ScannedProfilesError();
}
