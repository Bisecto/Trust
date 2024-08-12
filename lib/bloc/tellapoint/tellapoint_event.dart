part of 'tellapoint_bloc.dart';

abstract class TellapointEvent {}

class GetTellaPointHistory extends TellapointEvent {
  final String sortQuery;
  final String pageSize;
  final String page;

  GetTellaPointHistory(this.sortQuery, this.pageSize, this.page);
}
