abstract class RegisterEvent {
  const RegisterEvent();
}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String name;

  const RegisterSubmitted(this.email, this.password, this.name);
}
