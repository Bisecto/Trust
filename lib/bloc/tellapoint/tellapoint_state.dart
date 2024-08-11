part of 'tellapoint_bloc.dart';

abstract class TellapointState {}

final class TellapointInitial extends TellapointState {}

class TellapointLoadingState extends TellapointState {}

class TellapointErrorState extends TellapointState {
  final String msg;

  TellapointErrorState(this.msg);
}

class TellapointSuccessState extends TellapointState {
  final TellapointsHistoryModel tellaPointHistoryModel;

  TellapointSuccessState(this.tellaPointHistoryModel);
}

class AccessTokenExpireState extends TellapointState {}
