part of 'bank_bloc.dart';


abstract class BankEvent {}

class FetchBanks extends BankEvent {
  final String query;
  final int pageNo;

  FetchBanks(this.query, this.pageNo);
}

