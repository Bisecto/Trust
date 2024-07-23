import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:teller_trust/model/bank_model.dart';
import 'package:teller_trust/repository/app_repository.dart';

import '../../res/apis.dart';

part 'bank_event.dart';

part 'bank_state.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  BankBloc() : super(BankInitial()) {
    on<FetchBanks>(fetchBanks);
    // on<BankEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }

  Future<FutureOr<void>> fetchBanks(
      FetchBanks event, Emitter<BankState> emit) async {
    emit(LoadingState());
    AppRepository appRepository = AppRepository();
    try {
      var bankResponse = await appRepository.appGetRequest(
          "${AppApis.appBaseUrl}/misc/banks?search=${event.query}&page=${event.pageNo}");
      print(bankResponse.statusCode);
      print(bankResponse.body);
      if (bankResponse.statusCode == 200 || bankResponse.statusCode == 201) {
        BankModel bankModel =
            BankModel.fromJson(json.decode(bankResponse.body)['data']);
        emit(SuccessState(bankModel));
      } else {
        emit(ErrorState('Failed to fetch banks'));
      }
    } catch (e) {
      emit(ErrorState('Failed to fetch banks: $e'));
    }
  }
}
