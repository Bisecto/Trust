part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class OnClickeEventState extends AuthState {}

class AuthInitial extends AuthState {}

class LoadingState extends AuthState {}

class VerificationContinueState extends OnClickeEventState {}

class ErrorState extends AuthState {
  final String error;

  ErrorState(this.error);
}

class SuccessState extends AuthState {
  final User data;
  final String msg;

  SuccessState(this.data,this.msg);
}
class InitiatedLoginState extends AuthState {
  final User data;
  final String msg;

  InitiatedLoginState(this.data,this.msg);
}

class AuthOtpRequestState extends AuthState {
  final String msg;
  final String email;

  AuthOtpRequestState(this.msg, this.email);
}
class AuthOtpVerifySucess extends AuthState {
   final String msg;
   final User user;

  AuthOtpVerifySucess(this.msg,this.user);
}
