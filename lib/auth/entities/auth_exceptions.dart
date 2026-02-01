class LogInWithGoogleFailure implements Exception {}

class LogInWithGithubFailure implements Exception {}

class LogInWithGuestFailure implements Exception {}

class LogInCanceledFailure implements Exception {}

class LogOutFailure implements Exception {}

class AccountConflictFailure implements Exception {
  const AccountConflictFailure(this.email);
  final String email;
}
