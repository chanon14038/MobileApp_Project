abstract class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String username;
  final String password;

  AuthLoginEvent(this.username, this.password);
}

class AuthLogoutEvent extends AuthEvent {}
