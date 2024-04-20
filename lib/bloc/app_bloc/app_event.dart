part of 'app_bloc.dart';

@immutable
abstract class AppEvent {}

class InitialEvent extends AppEvent {}

class AddWithdrawalAccount extends AppEvent {
  final String accountNumber;
  final String bvn;

  final String bankCode;
  final String pin;

  final BuildContext context;

  AddWithdrawalAccount(
      this.accountNumber, this.bankCode, this.bvn, this.pin, this.context);
}
