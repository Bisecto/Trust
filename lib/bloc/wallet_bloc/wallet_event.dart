part of 'wallet_bloc.dart';


abstract class WalletEvent {}
class GetWalletHistory extends WalletEvent {
  final String sortQuery;
  final String pageSize;
  final String page;

  GetWalletHistory(this.sortQuery, this.pageSize, this.page);
}