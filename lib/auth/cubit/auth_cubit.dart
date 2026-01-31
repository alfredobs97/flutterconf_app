import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterconf/auth/auth.dart';

export 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const Unauthenticated()) {
    _userSubscription = _authRepository.user.listen(
      (user) {
        if (state is Guest) {
          return;
        }

        emit(user != null ? Authenticated(user) : const Unauthenticated());
      },
    );
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<User?> _userSubscription;

  Future<void> logInWithGoogle() async {
    emit(const AuthLoading());
    try {
      await _authRepository.logInWithGoogle();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logInWithGithub() async {
    emit(const AuthLoading());
    try {
      await _authRepository.logInWithGithub();
    } catch (e) {
      emit(AuthError(e.toString()));
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
