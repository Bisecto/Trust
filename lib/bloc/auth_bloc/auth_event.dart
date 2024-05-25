part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class InitialEvent extends AuthEvent {}

class VerificationContinueEvent extends AuthEvent {
  final BuildContext context;
  VerificationContinueEvent(this.context);
}

class VerifyOTPEventCLick extends AuthEvent {
  final String token;
  final bool isDeviceChange;
  final BuildContext context;


  VerifyOTPEventCLick(this.token,this.isDeviceChange, this.context);
}

class SignUpEventClick extends AuthEvent {
  final Map<String, dynamic> data;
  final BuildContext context;

  SignUpEventClick(this.data,this.context);
}

class InitiateSignInEventClick extends AuthEvent {
  final String userData;
  final String password;
  final BuildContext context;


  InitiateSignInEventClick(this.userData, this.password,this.context);
}

class SignInEventClick extends AuthEvent {
  final String userData;
  final String password;
  final String loginOption;
  final String accessPin;
  final BuildContext context;


  SignInEventClick(
      this.userData, this.password, this.accessPin, this.loginOption,this.context);
}

class CreatePinEvent extends AuthEvent {
  final String accessPin;
  final String confirmAccessPin;
  final BuildContext context;

  CreatePinEvent(this.accessPin, this.confirmAccessPin,this.context);
}

class ChangePinEvent extends AuthEvent {
  final String oldPin;
  final String accessPin;
  final String confirmAccessPin;
  final BuildContext context;


  ChangePinEvent(this.oldPin, this.accessPin, this.confirmAccessPin,this.context);
}
class ChangePasswordEvent extends AuthEvent {
  final String pin;
  Map<String, dynamic> data;
  final BuildContext context;



  ChangePasswordEvent(this.pin, this.data,this.context);
}
class PasswordResetRequestOtpEventCLick extends AuthEvent {
  String data;
  final BuildContext context;


  PasswordResetRequestOtpEventCLick( this.data,this.context);
}
class ResetPasswordEvent extends AuthEvent {
  String password;
  String token;
  String confirmPassword;
  String userData;
  final BuildContext context;



  ResetPasswordEvent( this.userData,this.token, this.password,this.confirmPassword,this.context);
}
