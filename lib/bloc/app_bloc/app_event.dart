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
class GetAllTransactionHistoryEvent extends AppEvent {
  final String type;
  final String status;

  final String search;
  final String pageSize;
  final String page;

  //final BuildContext context;

  GetAllTransactionHistoryEvent(
      this.type, this.status, this.search, this.pageSize, this.page);
}