import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterconf/auth/auth.dart';
import 'package:flutterconf/profile/cubit/profile_cubit.dart';
import 'package:flutterconf/profile/data/profile_repository.dart';
import 'package:flutterconf/profile/models/user_profile.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('ProfileCubit', () {
    late ProfileRepository profileRepository;
    late AuthRepository authRepository;
    late User user;

    setUp(() {
      profileRepository = MockProfileRepository();
      authRepository = MockAuthRepository();
      user = MockUser();

      when(() => user.uid).thenReturn('1');
      when(() => authRepository.currentUser).thenReturn(user);
    });

    test('initial state is correct', () {
      expect(
        ProfileCubit(
          profileRepository: profileRepository,
          authRepository: authRepository,
        ).state,
        const ProfileInitial(),
      );
    });

    group('loadProfile', () {
      blocTest<ProfileCubit, ProfileState>(
        'emits [loading, success] when getProfile succeeds',
        setUp: () {
          when(() => profileRepository.getProfile(any())).thenAnswer(
            (_) async => const UserProfile(id: '1', email: 'test@example.com'),
          );
        },
        build: () => ProfileCubit(
          profileRepository: profileRepository,
          authRepository: authRepository,
        ),
        act: (cubit) => cubit.loadProfile(),
        expect: () => [
          const ProfileLoading(),
          const ProfileLoaded(
            UserProfile(id: '1', email: 'test@example.com'),
            'https://flutterconf.dev/profile/1',
          ),
        ],
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits [loading, failure] when getProfile fails',
        setUp: () {
          when(
            () => profileRepository.getProfile(any()),
          ).thenThrow(Exception('oops'));
        },
        build: () => ProfileCubit(
          profileRepository: profileRepository,
          authRepository: authRepository,
        ),
        act: (cubit) => cubit.loadProfile(),
        expect: () => [
          const ProfileLoading(),
          const ProfileError(),
        ],
      );
    });
  });
}
