import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];

  String get stateName;
}

final class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  String get stateName => 'AuthLoading';
}

final class Authenticated extends AuthState {
  const Authenticated(this.user);

  final User user;

  @override
  List<Object?> get props => [user];

  @override
  String get stateName => 'Authenticated';
}

final class Guest extends AuthState {
  const Guest();

  @override
  String get stateName => 'Guest';
}

final class Unauthenticated extends AuthState {
  const Unauthenticated();

  @override
  String get stateName => 'Unauthenticated';
}

final class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String get stateName => 'AuthError';
}

final class AuthConflict extends AuthState {
  const AuthConflict({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];

  @override
  String get stateName => 'AuthConflict';
}
