part of 'kyc_bloc.dart';

@immutable
abstract class KycState {}

final class KycInitial extends KycState {}

class ErrorState extends KycState {
  final String error;

  ErrorState(this.error);
}

// class LoadingState extends KycState {
//   LoadingState();
// }
class AccessTokenExpireState extends KycState {}

class SuccessState extends KycState {
  final String msg;
  final String nuban;
  final String accountName;
  final String bankName;

  SuccessState(this.msg,this.accountName,this.bankName,this.nuban);
}class RequestOtpState extends KycState {
  final String identityId;

  RequestOtpState(this.identityId);
}
