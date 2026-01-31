import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterconf/auth/auth.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockUser extends Mock implements User {}

void main() {
  late AuthRepository authRepository;
  late User user;

  setUp(() {
    authRepository = MockAuthRepository();
    user = MockUser();
    when(() => authRepository.user).thenAnswer((_) => const Stream.empty());
  });

  group('AuthCubit', () {
    test('initial state is Unauthenticated', () {
      expect(
        AuthCubit(authRepository: authRepository).state,
        const Unauthenticated(),
      );
    });

    blocTest<AuthCubit, AuthState>(
      'emits [Authenticated] when user is not null',
      build: () {
        when(() => authRepository.user).thenAnswer((_) => Stream.value(user));
        return AuthCubit(authRepository: authRepository);
      },
      expect: () => [Authenticated(user)],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [Unauthenticated] when user is null',
      build: () {
        when(() => authRepository.user).thenAnswer((_) => Stream.value(null));
        return AuthCubit(authRepository: authRepository);
      },
      expect: () => [const Unauthenticated()],
    );

    group('logInWithGoogle', () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, Unauthenticated] (internal state) or Authenticated if repo succeeds',
        build: () {
          when(() => authRepository.logInWithGoogle()).thenAnswer((_) async {});
          return AuthCubit(authRepository: authRepository);
        },
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => [const AuthLoading()],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthError] when logInWithGoogle fails',
        build: () {
          when(() => authRepository.logInWithGoogle()).thenThrow(Exception('error'));
          return AuthCubit(authRepository: authRepository);
        },
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => [
          const AuthLoading(),
          const AuthError('Exception: error'),
        ],
      );
    });

    group('logInWithGithub', () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading] and calls logInWithGithub',
        build: () {
          when(() => authRepository.logInWithGithub()).thenAnswer((_) async {});
          return AuthCubit(authRepository: authRepository);
        },
        act: (cubit) => cubit.logInWithGithub(),
        expect: () => [const AuthLoading()],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthError] when logInWithGithub fails',
        build: () {
          when(() => authRepository.logInWithGithub()).thenThrow(Exception('error'));
          return AuthCubit(authRepository: authRepository);
        },
        act: (cubit) => cubit.logInWithGithub(),
        expect: () => [
          const AuthLoading(),
          const AuthError('Exception: error'),
        ],
      );
    });

    group('continueAsGuest', () {
      blocTest<AuthCubit, AuthState>(
        'emits [Guest]',
        build: () => AuthCubit(authRepository: authRepository),
        act: (cubit) => cubit.continueAsGuest(),
        expect: () => [const Guest()],
      );
    });

    group('logOut', () {
      blocTest<AuthCubit, AuthState>(
        'calls logOut on repository',
        build: () {
          when(() => authRepository.logOut()).thenAnswer((_) async {});
          return AuthCubit(authRepository: authRepository);
        },
        act: (cubit) => cubit.logOut(),
        verify: (_) {
          verify(() => authRepository.logOut()).called(1);
        },
      );
    });
  });
}
