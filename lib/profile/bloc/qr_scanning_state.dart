part of 'qr_scanning_bloc.dart';

sealed class QRScanningState extends Equatable {
  const QRScanningState();

  @override
  List<Object> get props => [];
}

final class QRScanningIdle extends QRScanningState {
  const QRScanningIdle();
}

final class QRScanningProcessing extends QRScanningState {
  const QRScanningProcessing();
}

final class QRScanningSuccess extends QRScanningState {
  const QRScanningSuccess({required this.scannedProfile});

  final ScannedProfile scannedProfile;

  @override
  List<Object> get props => [scannedProfile];
}

final class QRScanningError extends QRScanningState {
  const QRScanningError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
