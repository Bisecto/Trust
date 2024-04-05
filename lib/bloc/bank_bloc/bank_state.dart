part of 'bank_bloc.dart';

abstract class BankState {}

final class BankInitial extends BankState {}

class ErrorState extends BankState {
  final String error;

  ErrorState(this.error);
}

class LoadingState extends BankState {
  LoadingState();
}

class SuccessState extends BankState {
  final BankModel bankModel;

  //final String msg;

  SuccessState(this.bankModel);
}
