import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teller_trust/view/the_app_screens/transaction_history/wallet_history.dart';

import '../../model/wallet_history_model.dart';
import '../../repository/app_repository.dart';
import '../../res/apis.dart';
import '../../res/sharedpref_key.dart';
import '../../utills/app_utils.dart';
import '../../utills/shared_preferences.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletInitial()) {
    on<GetWalletHistory>(getWalletHistory);
    // on<WalletEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }

  FutureOr<void> getWalletHistory(GetWalletHistory event, Emitter<WalletState> emit) async {
    emit(
        WalletHistoryLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString(SharedPrefKey.accessTokenKey);

    try {

      var listWalletHistory = await appRepository.appGetRequest(
        "${AppApis.listWalletHistory}?page=${event.page}&pageSize=${event.pageSize}"
            "&ory=${event.sortQuery}",
        accessToken: accessToken,
      );
      print(listWalletHistory.body);
      print("userTransactionList status COde ${listWalletHistory.statusCode}");
      print("userTransactionList Data ${listWalletHistory.body}");
      if (listWalletHistory.statusCode == 200 ||
          listWalletHistory.statusCode == 201) {
        WalletHistoryModel walletHistoryModel =
        WalletHistoryModel.fromJson(json.decode(listWalletHistory.body));
        emit(WalletHistorySuccessState(
            walletHistoryModel)); // Emit success state with data
      } else if (json.decode(listWalletHistory.body)['errorCode'] == "N404") {
        emit(AccessTokenExpireState());
      } else {
        emit(WalletHistoryErrorState(AppUtils.convertString(
            json.decode(listWalletHistory.body)['message'])));
        print(json.decode(listWalletHistory.body));
      }
    } catch (e) {
      emit(WalletHistoryErrorState("An error occurred while fetching user profile."));
      print(e);
    }
  }
}
