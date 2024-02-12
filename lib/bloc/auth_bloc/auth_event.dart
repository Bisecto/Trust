part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class InitialEvent extends AuthEvent {}

class VerificationContinueEvent extends AuthEvent {}

class VerifyOTPEventCLick extends AuthEvent {
  final String token;

  VerifyOTPEventCLick(this.token);
}

class SignUpEventClick extends AuthEvent {
  final Map<dynamic, String> data;

  SignUpEventClick(this.data);
}class InitiateSignInEventClick extends AuthEvent {
  final String userData;
  final String password;

  InitiateSignInEventClick(this.userData, this.password);
}

class SignInEventClick extends AuthEvent {
  final String userData;
  final String password;
  final String loginOption;
  final String accessPin;

  SignInEventClick(this.userData, this.password,this.accessPin,this.loginOption);
}

class CreatePinEvent extends AuthEvent {
  final String accessPin;
  final String confirmAccessPin;

  CreatePinEvent(this.accessPin,this.confirmAccessPin);
}

