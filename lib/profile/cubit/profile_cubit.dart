import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterconf/auth/auth.dart';
import 'package:flutterconf/profile/data/profile_repository.dart';
import 'package:flutterconf/profile/models/user_profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required ProfileRepository profileRepository,
    required AuthRepository authRepository,
  }) : _profileRepository = profileRepository,
       _authRepository = authRepository,
       super(const ProfileInitial());

  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository;

  static const String _baseUrl = 'https://flutterconf.dev';

  Future<void> loadProfile({String? userId}) async {
    emit(const ProfileLoading());
    try {
      final id = userId ?? _authRepository.currentUser?.uid;
      if (id == null) {
        emit(const ProfileError());
        return;
      }
      final profile = await _profileRepository.getProfile(id);
      emit(
        profile != null
            ? ProfileLoaded(profile, _buildQrData(profile))
            : const ProfileNotFound(),
      );
    } on Exception catch (_) {
      emit(const ProfileError());
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    emit(const ProfileLoading());
    try {
      final updatedProfile = profile.copyWith(
        photoUrl: _authRepository.currentUser?.photoURL,
      );
      await _profileRepository.updateProfile(updatedProfile);
      emit(
        ProfileLoaded(updatedProfile, _buildQrData(updatedProfile)),
      );
    } on Exception catch (_) {
      emit(const ProfileError());
    }
  }

  String _buildQrData(UserProfile profile) {
    return '$_baseUrl/profile/${profile.id}';
  }
}
