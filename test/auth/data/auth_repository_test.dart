import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterconf/auth/data/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}
class MockUser extends Mock implements User {}
class MockUserCredential extends Mock implements UserCredential {}
class FakeAuthCredential extends Fake implements AuthCredential {}
class FakeAuthProvider extends Fake implements AuthProvider {}

void main() {
  late FirebaseAuth firebaseAuth;
  late GoogleSignIn googleSignIn;
  late AuthRepository authRepository;

  setUpAll(() {
    registerFallbackValue(FakeAuthCredential());
    registerFallbackValue(FakeAuthProvider());
  });

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    googleSignIn = MockGoogleSignIn();
    authRepository = AuthRepository(
      firebaseAuth: firebaseAuth,
      googleSignIn: googleSignIn,
    );
  });

  group('AuthRepository', () {
    test('user stream emits auth state changes', () {
      final user = MockUser();
      when(() => firebaseAuth.authStateChanges()).thenAnswer((_) => Stream.value(user));
      
      expect(authRepository.user, emits(user));
    });

    group('logInWithGoogle', () {
      test('signs in with google and signs into firebase', () async {
        final googleAccount = MockGoogleSignInAccount();
        final googleAuth = MockGoogleSignInAuthentication();
        
        when(() => googleSignIn.signIn()).thenAnswer((_) async => googleAccount);
        when(() => googleAccount.authentication).thenAnswer((_) async => googleAuth);
        when(() => googleAuth.accessToken).thenReturn('token');
        when(() => googleAuth.idToken).thenReturn('id');
        
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenAnswer((_) async => MockUserCredential());

        await authRepository.logInWithGoogle();

        verify(() => googleSignIn.signIn()).called(1);
        verify(() => firebaseAuth.signInWithCredential(any())).called(1);
      });

      test('returns early if google sign in is cancelled', () async {
        when(() => googleSignIn.signIn()).thenAnswer((_) async => null);

        await authRepository.logInWithGoogle();

        verify(() => googleSignIn.signIn()).called(1);
        verifyNever(() => firebaseAuth.signInWithCredential(any()));
      });
    });

    group('logInWithGithub', () {
      test('signs in with github using popup', () async {
        when(() => firebaseAuth.signInWithPopup(any()))
            .thenAnswer((_) async => MockUserCredential());

        await authRepository.logInWithGithub();

        verify(() => firebaseAuth.signInWithPopup(any())).called(1);
      });
    });

    group('logOut', () {
      test('signs out of firebase and google', () async {
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});
        when(() => googleSignIn.signOut()).thenAnswer((_) async => null);

        await authRepository.logOut();

        verify(() => firebaseAuth.signOut()).called(1);
        verify(() => googleSignIn.signOut()).called(1);
      });
    });
  });
}
