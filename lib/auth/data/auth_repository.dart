import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterconf/auth/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  AuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  Stream<User?> get user => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;

  /// Initializes the Google Sign-In instance.
  ///
  /// Must be called once before [logInWithGoogle] or [logOut] are used.
  Future<void> initialize() async {
    await _googleSignIn.initialize(
      clientId: kIsWeb
          ? const String.fromEnvironment('GOOGLE_CLIENT_ID')
          : null,
    );
  }

  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.authenticate();

      final googleAuth = googleUser.authentication;
      if (googleAuth.idToken == null) {
        throw LogInWithGoogleFailure();
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw LogInCanceledFailure();
      }
      throw LogInWithGoogleFailure();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        final email = e.email;
        if (email != null) {
          throw AccountConflictFailure(email);
        }
      }
      throw LogInWithGoogleFailure();
    } on LogInCanceledFailure {
      rethrow;
      // Reason: catch-all for any unexpected exception types not handled above.
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('popup_closed') ||
          errorString.contains('canceled')) {
        throw LogInCanceledFailure();
      }
      throw LogInWithGoogleFailure();
    }
  }

  Future<void> logInWithGithub() async {
    try {
      final githubProvider = GithubAuthProvider();
      await _firebaseAuth.signInWithPopup(githubProvider);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        final email = e.email;
        if (email != null) {
          throw AccountConflictFailure(email);
        }
      }
      if (e.code == 'closed-by-user' || e.code == 'canceled') {
        throw LogInCanceledFailure();
      }
      throw LogInWithGithubFailure();
      // Reason: catch-all for any unexpected exception types not handled above.
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('popup_closed') ||
          errorString.contains('canceled')) {
        throw LogInCanceledFailure();
      }
      throw LogInWithGithubFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      // Reason: log out failures should surface as LogOutFailure regardless
      // of exception type.
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      throw LogOutFailure();
    }
  }
}
