abstract class AuthEvent {}

class SendOtpEvent extends AuthEvent {
  final String phoneNumber;
  SendOtpEvent(this.phoneNumber);
}

class VerifyOtpEvent extends AuthEvent {
  final String otp;
  VerifyOtpEvent(this.otp);
}

class LoginWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  LoginWithEmailEvent(this.email, this.password);
}

class SignUpWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  SignUpWithEmailEvent(this.email, this.password, this.confirmPassword);
}

class CheckLoginStatusEvent extends AuthEvent {}