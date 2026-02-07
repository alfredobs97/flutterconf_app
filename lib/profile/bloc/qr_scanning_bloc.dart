import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterconf/profile/data/profile_repository.dart';
import 'package:flutterconf/profile/models/scanned_profile.dart';

part 'qr_scanning_event.dart';
part 'qr_scanning_state.dart';

class QRScanningBloc extends Bloc<QRScanningEvent, QRScanningState> {
  QRScanningBloc({
    required ProfileRepository profileRepository,
  }) : _profileRepository = profileRepository,
       super(const QRScanningIdle()) {
    on<QRCodeScanned>(_onQRCodeScanned);
  }

  final ProfileRepository _profileRepository;

  Future<void> _onQRCodeScanned(
    QRCodeScanned event,
    Emitter<QRScanningState> emit,
  ) async {
    emit(const QRScanningProcessing());

    try {
      // Parse the URL
      final uri = Uri.parse(event.url);
      final segments = uri.pathSegments;
      final profileIndex = segments.indexOf('profile');

      if (profileIndex == -1 || profileIndex + 1 >= segments.length) {
        emit(const QRScanningError('Invalid QR Code'));
        emit(const QRScanningIdle());
        return;
      }

      final userId = segments[profileIndex + 1];

      // Fetch the profile
      final userProfile = await _profileRepository.getProfile(userId);

      if (userProfile == null) {
        emit(const QRScanningError('Profile not found'));
        emit(const QRScanningIdle());
        return;
      }

      // Create scanned profile and emit success
      final scannedProfile = ScannedProfile(
        id: userProfile.id,
        displayName: userProfile.displayName ?? 'Unknown',
        scannedAt: DateTime.now(),
      );

      emit(QRScanningSuccess(scannedProfile: scannedProfile));
      emit(const QRScanningIdle());
    } catch (e) {
      emit(const QRScanningError('Error scanning profile'));
      emit(const QRScanningIdle());
    }
  }
}
