import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterconf/auth/auth.dart';
import 'package:flutterconf/profile/data/profile_repository.dart';
import 'package:flutterconf/profile/data/scanned_profiles_repository.dart';
import 'package:flutterconf/profile/models/scanned_profile.dart';

part 'scanned_profiles_state.dart';

class ScannedProfilesCubit extends Cubit<ScannedProfilesState> {
  ScannedProfilesCubit({
    required ScannedProfilesRepository repository,
    required ProfileRepository profileRepository,
    required AuthRepository authRepository,
  }) : _repository = repository,
       _profileRepository = profileRepository,
       _authRepository = authRepository,
       super(const ScannedProfilesInitial());

  final ScannedProfilesRepository _repository;
  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository;

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
      final isProfileAdded = await _repository.addScannedProfile(profile);
      await loadProfiles();

      // Sync with Firestore in background if it's a new scan
      final userId = _authRepository.currentUser?.uid;
      if (isProfileAdded && userId != null) {
        unawaited(_profileRepository.incrementScannedCount(userId));
      }
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
