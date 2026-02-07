import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterconf/profile/data/scanned_profiles_repository.dart';
import 'package:flutterconf/profile/models/scanned_profile.dart';

part 'scanned_profiles_state.dart';

class ScannedProfilesCubit extends Cubit<ScannedProfilesState> {
  ScannedProfilesCubit({
    required ScannedProfilesRepository repository,
  }) : _repository = repository,
       super(const ScannedProfilesInitial());

  final ScannedProfilesRepository _repository;

  Future<void> loadProfiles() async {
    emit(const ScannedProfilesLoading());
    try {
      final profiles = await _repository.getScannedProfiles();
      emit(ScannedProfilesLoaded(profiles));
    } catch (_) {
      emit(const ScannedProfilesError());
    }
  }

  Future<void> addProfile(ScannedProfile profile) async {
    try {
      await _repository.addScannedProfile(profile);
      await loadProfiles();
    } catch (_) {
      emit(const ScannedProfilesError());
    }
  }

  Future<void> removeProfile(String userId) async {
    try {
      await _repository.removeScannedProfile(userId);
      await loadProfiles();
    } catch (_) {
      emit(const ScannedProfilesError());
    }
  }
}
