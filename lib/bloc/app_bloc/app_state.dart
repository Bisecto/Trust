part of 'app_bloc.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class OnClickEventState extends AppState {}

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

  SuccessState(this.customerProfile);
}

