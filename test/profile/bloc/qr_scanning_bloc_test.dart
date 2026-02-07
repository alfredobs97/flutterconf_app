import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterconf/profile/bloc/qr_scanning_bloc.dart';
import 'package:flutterconf/profile/data/profile_repository.dart';
import 'package:flutterconf/profile/models/user_profile.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late ProfileRepository profileRepository;

  setUp(() {
    profileRepository = MockProfileRepository();
  });

  group('QRScanningBloc', () {
    test('initial state is QRScanningIdle', () {
      final bloc = QRScanningBloc(
        profileRepository: profileRepository,
      );

      expect(bloc.state, equals(const QRScanningIdle()));
    });

    blocTest<QRScanningBloc, QRScanningState>(
      'emits [Processing, Success, Idle] when QRCodeScanned is successful',
      setUp: () {
        when(() => profileRepository.getProfile(any())).thenAnswer(
          (_) async => UserProfile(
            id: 'user123',
            displayName: 'John Doe',
            email: 'john@example.com',
          ),
        );
      },
      build: () => QRScanningBloc(
        profileRepository: profileRepository,
      ),
      act: (bloc) =>
          bloc.add(const QRCodeScanned('https://example.com/profile/user123')),
      expect: () => [
        const QRScanningProcessing(),
        isA<QRScanningSuccess>()
            .having(
              (s) => s.scannedProfile.id,
              'userId',
              'user123',
            )
            .having(
              (s) => s.scannedProfile.displayName,
              'displayName',
              'John Doe',
            ),
        const QRScanningIdle(),
      ],
      verify: (_) {
        verify(() => profileRepository.getProfile('user123')).called(1);
      },
    );

    blocTest<QRScanningBloc, QRScanningState>(
      'emits [Processing, Error, Idle] when URL is invalid',
      build: () => QRScanningBloc(
        profileRepository: profileRepository,
      ),
      act: (bloc) =>
          bloc.add(const QRCodeScanned('https://example.com/invalid')),
      expect: () => [
        const QRScanningProcessing(),
        const QRScanningError('Invalid QR Code'),
        const QRScanningIdle(),
      ],
    );

    blocTest<QRScanningBloc, QRScanningState>(
      'emits [Processing, Error, Idle] when profile is not found',
      setUp: () {
        when(
          () => profileRepository.getProfile(any()),
        ).thenAnswer((_) async => null);
      },
      build: () => QRScanningBloc(
        profileRepository: profileRepository,
      ),
      act: (bloc) =>
          bloc.add(const QRCodeScanned('https://example.com/profile/user123')),
      expect: () => [
        const QRScanningProcessing(),
        const QRScanningError('Profile not found'),
        const QRScanningIdle(),
      ],
      verify: (_) {
        verify(() => profileRepository.getProfile('user123')).called(1);
      },
    );

    blocTest<QRScanningBloc, QRScanningState>(
      'emits [Processing, Error, Idle] when an exception occurs',
      setUp: () {
        when(
          () => profileRepository.getProfile(any()),
        ).thenThrow(Exception('Network error'));
      },
      build: () => QRScanningBloc(
        profileRepository: profileRepository,
      ),
      act: (bloc) =>
          bloc.add(const QRCodeScanned('https://example.com/profile/user123')),
      expect: () => [
        const QRScanningProcessing(),
        const QRScanningError('Error scanning profile'),
        const QRScanningIdle(),
      ],
    );
  });
}
