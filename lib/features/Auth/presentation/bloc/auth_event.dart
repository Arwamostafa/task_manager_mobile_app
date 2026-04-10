abstract class AuthEvent {
  const AuthEvent();
}

class AppStarted extends AuthEvent {
  const AppStarted();
}

class LoggedIn extends AuthEvent {
  const LoggedIn();
}

class LoggedOut extends AuthEvent {
  const LoggedOut();
}
