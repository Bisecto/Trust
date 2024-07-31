part of 'app_bloc.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class OnClickEventState extends AppState {}
class AccessTokenExpireState extends AppState {}

class LoadingState extends AppState {}

class ErrorState extends AppState {
  final String error;

  ErrorState(this.error);
}

class WirthdrawalAccountAddedError extends AppState {
  final String error;

  WirthdrawalAccountAddedError(this.error);
}

class WirthdrawalAccountAdded extends AppState {
  CustomerProfile customerProfile;

  WirthdrawalAccountAdded(this.customerProfile);
}

class SuccessState extends AppState {
  final CustomerProfile customerProfile;
  final TransactionHistoryModel transactionHistoryModel;

  SuccessState(this.customerProfile,this.transactionHistoryModel);
}
class TransactionListSuccessState extends AppState {
  final TransactionHistoryModel transactionHistoryModel;

  TransactionListSuccessState(this.transactionHistoryModel);
}

class TransactionErrorState extends AppState {
  final String error;

  TransactionErrorState(this.error);
}