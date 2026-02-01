import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterconf/auth/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  AuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn =
           googleSignIn ??
           GoogleSignIn(
             clientId: kIsWeb
                 ? const String.fromEnvironment('GOOGLE_CLIENT_ID')
                 : null,
           );

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  Stream<User?> get user => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw LogInCanceledFailure();

      final googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken == null && googleAuth.idToken == null) {
        throw LogInWithGoogleFailure();
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
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
    } catch (_) {
      throw LogOutFailure();
    }
  }
}
