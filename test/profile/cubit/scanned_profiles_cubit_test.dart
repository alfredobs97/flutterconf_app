import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterconf/auth/auth.dart';
import 'package:flutterconf/profile/cubit/scanned_profiles_cubit.dart';
import 'package:flutterconf/profile/data/profile_repository.dart';
import 'package:flutterconf/profile/data/scanned_profiles_repository.dart';
import 'package:flutterconf/profile/models/scanned_profile.dart';

import 'package:mocktail/mocktail.dart';

class MockScannedProfilesRepository extends Mock
    implements ScannedProfilesRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements firebase_auth.User {}

class FakeScannedProfile extends Fake implements ScannedProfile {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeScannedProfile());
  });

  group('ScannedProfilesCubit', () {
    late ScannedProfilesRepository repository;
    late MockProfileRepository mockProfileRepository;
    late MockAuthRepository mockAuthRepository;
    late MockUser mockUser;

    setUp(() {
      repository = MockScannedProfilesRepository();
      mockProfileRepository = MockProfileRepository();
      mockAuthRepository = MockAuthRepository();
      mockUser = MockUser();

      when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('user_123');
      when(
        () => mockProfileRepository.incrementScannedCount(any()),
      ).thenAnswer((_) async {});
    });

    ScannedProfilesCubit buildCubit() {
      return ScannedProfilesCubit(
        repository: repository,
        profileRepository: mockProfileRepository,
        authRepository: mockAuthRepository,
      );
    }

    test('initial state is ScannedProfilesInitial', () {
      expect(buildCubit().state, const ScannedProfilesInitial());
    });

    blocTest<ScannedProfilesCubit, ScannedProfilesState>(
      'emits [ScannedProfilesLoading, ScannedProfilesLoaded] when loadProfiles succeeds',
      setUp: () {
        when(() => repository.getScannedProfiles()).thenAnswer((_) async => []);
      },
      build: buildCubit,
      act: (cubit) => cubit.loadProfiles(),
      expect: () => [
        const ScannedProfilesLoading(),
        const ScannedProfilesLoaded([]),
      ],
    );

    blocTest<ScannedProfilesCubit, ScannedProfilesState>(
      'addProfile calls repository and increments Firestore count for new profiles',
      setUp: () {
        when(
          () => repository.addScannedProfile(any()),
        ).thenAnswer((_) async => true);
        when(() => repository.getScannedProfiles()).thenAnswer((_) async => []);
      },
      build: buildCubit,
      act: (cubit) => cubit.addProfile(
        ScannedProfile(
          id: '1',
          displayName: 'Test',
          scannedAt: DateTime.now(),
        ),
      ),
      expect: () => [
        const ScannedProfilesLoading(),
        const ScannedProfilesLoaded([]),
      ],
      verify: (_) {
        verify(
          () => mockProfileRepository.incrementScannedCount('user_123'),
        ).called(1);
      },
    );

    blocTest<ScannedProfilesCubit, ScannedProfilesState>(
      'addProfile calls repository but does NOT increment Firestore for existing profiles',
      setUp: () {
        when(
          () => repository.addScannedProfile(any()),
        ).thenAnswer((_) async => false);
        when(() => repository.getScannedProfiles()).thenAnswer((_) async => []);
      },
      build: buildCubit,
      act: (cubit) => cubit.addProfile(
        ScannedProfile(
          id: '1',
          displayName: 'Test',
          scannedAt: DateTime.now(),
        ),
      ),
      verify: (_) {
        verifyNever(() => mockProfileRepository.incrementScannedCount(any()));
      },
    );
  });
}
