part of 'wallet_bloc.dart';

@immutable
sealed class WalletState {}

final class WalletInitial extends WalletState {}
class WalletHistoryLoadingState extends WalletState {}

class WalletHistoryErrorState extends WalletState {
  final String msg;

  WalletHistoryErrorState(this.msg);
}

class WalletHistorySuccessState extends WalletState {
  final WalletHistoryModel walletHistoryModel;

  WalletHistorySuccessState(this.walletHistoryModel);
}

class AccessTokenExpireState extends WalletState {}
