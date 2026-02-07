part of 'qr_scanning_bloc.dart';

sealed class QRScanningEvent extends Equatable {
  const QRScanningEvent();

  @override
  List<Object> get props => [];
}

final class QRCodeScanned extends QRScanningEvent {
  const QRCodeScanned(this.url);

  final String url;

  @override
  List<Object> get props => [url];
}
