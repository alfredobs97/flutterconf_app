import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterconf/auth/auth.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

export 'auth_state.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(
        authRepository.currentUser != null
            ? Authenticated(authRepository.currentUser!)
            : const Unauthenticated(),
      ) {
    _userSubscription = _authRepository.user.listen(
      (user) {
        if (state is Guest && user == null) {
          return;
        }

        emit(user != null ? Authenticated(user) : const Unauthenticated());
      },
    );
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<User?> _userSubscription;

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    final status = json['status'] as String?;

    if (status == null) {
      return const Unauthenticated();
    }

    switch (status) {
      case 'Guest':
        return const Guest();
      case 'Authenticated':
        return Authenticated(_authRepository.currentUser!);
      case 'Unauthenticated':
        return const Unauthenticated();
      case 'AuthError':
        return const AuthError('Log in failed.');
      case 'AuthConflict':
        return AuthConflict(email: _authRepository.currentUser!.email!);
      default:
        return const Unauthenticated();
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return {
      'status': state.stateName,
    };
  }

  Future<void> logInWithGoogle() async {
    emit(const AuthLoading());
    try {
      await _authRepository.logInWithGoogle();
    } on AccountConflictFailure catch (e) {
      emit(AuthConflict(email: e.email));
    } on LogInCanceledFailure {
      emit(const Unauthenticated());
    } on LogInWithGoogleFailure {
      emit(const AuthError('Log in with Google failed.'));
    }
  }

  Future<void> logInWithGithub() async {
    emit(const AuthLoading());
    try {
      await _authRepository.logInWithGithub();
    } on AccountConflictFailure catch (e) {
      emit(AuthConflict(email: e.email));
    } on LogInCanceledFailure {
      emit(const Unauthenticated());
    } on LogInWithGithubFailure {
      emit(const AuthError('Log in with GitHub failed.'));
    }
  }

  void continueAsGuest() {
    emit(const Guest());
  }

  Future<void> logOut() async {
    try {
      await _authRepository.logOut();
    } catch (_) {
    } finally {
      emit(const Unauthenticated());
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
