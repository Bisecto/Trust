part of 'kyc_bloc.dart';

@immutable
abstract class KycState {}

final class KycInitial extends KycState {}

class ErrorState extends KycState {
  final String error;

  ErrorState(this.error);
}

class LoadingState extends KycState {
  LoadingState();
}

class SuccessState extends KycState {
  //final String msg;

  SuccessState();
}class RequestOtpState extends KycState {
  //final String msg;

  RequestOtpState();
}
