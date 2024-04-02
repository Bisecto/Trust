part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class OnClickeEventState extends AuthState {}

class AuthInitial extends AuthState {}

class LoadingState extends AuthState {}

class VerificationContinueState extends OnClickeEventState {
  // final String userData;
  //final String userData;
}
// class NewDeviceSuccessState extends OnClickeEventState {}

class ErrorState extends AuthState {
  final String error;

  ErrorState(this.error);
}

class SuccessState extends AuthState {
  final User data;
  final String msg;

  SuccessState(this.data, this.msg);
}

class OTPRequestSuccessState extends AuthState {
  final String msg;

  OTPRequestSuccessState(this.msg);
}

class PasswordResetSuccessState extends AuthState {
  final String msg;

  PasswordResetSuccessState(this.msg);
}

class InitiatedLoginState extends AuthState {
  final String userName;
  final String msg;
  final bool isBiometricPinSet;

  InitiatedLoginState(this.msg, this.userName,this.isBiometricPinSet);
}

class AuthOtpRequestState extends AuthState {
  final String msg;
  final String email;

  AuthOtpRequestState(this.msg, this.email);
}

class AuthChangeDeviceOtpRequestState extends AuthState {
  final String msg;
  final String email;
  final bool isChnageDevice;

  AuthChangeDeviceOtpRequestState(this.msg, this.email, this.isChnageDevice);
}

class AuthOtpVerifySucess extends AuthState {
  final String msg;
  final User user;

  AuthOtpVerifySucess(this.msg, this.user);
}
