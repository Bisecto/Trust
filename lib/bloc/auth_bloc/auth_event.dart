part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class InitialEvent extends AuthEvent {}

class VerificationContinueEvent extends AuthEvent {
  VerificationContinueEvent();
}

class VerifyOTPEventCLick extends AuthEvent {
  final String token;
  final bool isDeviceChange;

  VerifyOTPEventCLick(this.token,this.isDeviceChange);
}

class SignUpEventClick extends AuthEvent {
  final Map<dynamic, String> data;

  SignUpEventClick(this.data);
}

class InitiateSignInEventClick extends AuthEvent {
  final String userData;
  final String password;

  InitiateSignInEventClick(this.userData, this.password);
}

class SignInEventClick extends AuthEvent {
  final String userData;
  final String password;
  final String loginOption;
  final String accessPin;

  SignInEventClick(
      this.userData, this.password, this.accessPin, this.loginOption);
}

class CreatePinEvent extends AuthEvent {
  final String accessPin;
  final String confirmAccessPin;

  CreatePinEvent(this.accessPin, this.confirmAccessPin);
}

class ChangePinEvent extends AuthEvent {
  final String oldPin;
  final String accessPin;
  final String confirmAccessPin;

  ChangePinEvent(this.oldPin, this.accessPin, this.confirmAccessPin);
}
class ChangePasswordEvent extends AuthEvent {
  final String pin;
  Map<dynamic,String> data;


  ChangePasswordEvent(this.pin, this.data);
}
class PasswordResetRequestOtpEventCLick extends AuthEvent {
  String data;


  PasswordResetRequestOtpEventCLick( this.data);
}
class ResetPasswordEvent extends AuthEvent {
  String password;
  String token;
  String confirmPassword;
  String userData;


  ResetPasswordEvent( this.userData,this.token, this.password,this.confirmPassword);
}
