import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/tellapoint_history_model.dart';
import '../../model/transactionHistory.dart';
import '../../repository/app_repository.dart';
import '../../res/apis.dart';
import '../../utills/app_utils.dart';
import '../../utills/shared_preferences.dart';

part 'tellapoint_event.dart';

part 'tellapoint_state.dart';

class TellapointBloc extends Bloc<TellapointEvent, TellapointState> {
  TellapointBloc() : super(TellapointInitial()) {
    on<GetTellaPointHistory>(getTellaPointHistory);
    // on<TellapointEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }

  FutureOr<void> getTellaPointHistory(
      GetTellaPointHistory event, Emitter<TellapointState> emit) async {
    emit(
        TellapointLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString("access-token");

     try {

    var listPointHistory = await appRepository.appGetRequest(
      "${AppApis.listPointHistory}?page=${event.page}&pageSize=${event.pageSize}"
      "&ory=${event.sortQuery}",
      accessToken: accessToken,
    );
    print(listPointHistory.body);
    print("userTransactionList status COde ${listPointHistory.statusCode}");
    print("userTransactionList Data ${listPointHistory.body}");
    if (listPointHistory.statusCode == 200 ||
        listPointHistory.statusCode == 201) {
      TellapointsHistoryModel tellaPointHistoryModel =
      TellapointsHistoryModel.fromJson(json.decode(listPointHistory.body));
      emit(TellapointSuccessState(
          tellaPointHistoryModel)); // Emit success state with data
    } else if (json.decode(listPointHistory.body)['errorCode'] == "N404") {
      emit(AccessTokenExpireState());
    } else {
      emit(TellapointErrorState(AppUtils.convertString(
          json.decode(listPointHistory.body)['message'])));
      print(json.decode(listPointHistory.body));
    }
    } catch (e) {
      emit(TellapointErrorState("An error occurred while fetching user profile."));
      print(e);
    }
  }
}
