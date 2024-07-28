import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/event/send_event.dart';
import 'package:teller_trust/bloc/sendBloc/states/send_state.dart';
import 'package:teller_trust/model/customer_profile.dart';
import 'package:teller_trust/repository/app_repository.dart';
import 'package:teller_trust/res/apis.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/utills/shared_preferences.dart';

class SendBloc extends Bloc<SendEvent, SendState> {
  String mainValueEntered = '';
  String fractionValueEntered = '';

  SendBloc() : super(const InitialSendState()) {
    on<EnterAmountToSend>((event, emit) {
      if (event.isItForMainValue && !fractionValueEntered.contains('.')) {
        List mainValues = mainValueEntered.split('');
        if (mainValues.isEmpty) {
          if (event.value != '0' && event.value != '.') {
            mainValueEntered += event.value;
          }
        } else {
          mainValueEntered += event.value;
        }
      } else {
        List fractionValues = fractionValueEntered.split('');
        if (fractionValues.isEmpty) {
          fractionValueEntered += event.value;
        } else {
          if (event.value != '.') {
            fractionValueEntered += event.value;
          }
        }
      }
      emit(
        CurrentAmountEntered(
          mainValue: mainValueEntered.isNotEmpty ? mainValueEntered : '0',
          fractionValue:
              fractionValueEntered.isNotEmpty && fractionValueEntered.length > 1
                  ? fractionValueEntered
                  : '.00',
        ),
      );
    });
    on<BackSpaceLastEnteredAmountToSend>((event, emit) {
      if (fractionValueEntered.isNotEmpty) {
        List<String> fractionValues = fractionValueEntered.split('');
        fractionValues.removeLast();
        fractionValueEntered = fractionValues.join('');
      } else {
        List<String> mainValues = mainValueEntered.split('');
        mainValues.removeLast();
        mainValueEntered = mainValues.join('');
      }
      emit(
        CurrentAmountEntered(
          mainValue: mainValueEntered.isNotEmpty ? mainValueEntered : '0',
          fractionValue:
              fractionValueEntered.isNotEmpty && fractionValueEntered.length > 1
                  ? fractionValueEntered
                  : '.00',
        ),
      );
    });
    on<LoadSendToDetailsInitialState>((event, emit) {
      emit(const SendToDetailsInitialState());
    });
    on<LoadUserBalance>((event, emit) async {
      AppRepository appRepository = AppRepository();
      String accessToken = await SharedPref.getString("access-token");

      var profileResponse = await appRepository.appGetRequest(
        AppApis.userProfile,
        accessToken: accessToken,
      );
      if (profileResponse.statusCode == 200 ||
          profileResponse.statusCode == 201) {
        CustomerProfile customerProfile =
            CustomerProfile.fromJson(json.decode(profileResponse.body)['data']);
        emit(
          UserBalance(balance: '${customerProfile.walletInfo.balance}'),
        );
      } else {
        emit(
          ErrorStateForSendTo(
            errorMessage: AppUtils.convertString(
              json.decode(profileResponse.body)['message'],
            ),
          ),
        );
      }
    });
    on<SelectTxnOption>((event, emit) {
      emit(
        SelectedTxnOption(
          isItForTellaTrust: event.isTxnForTellaTrust,
        ),
      );
    });
    on<LoadBanksToTxnWith>((event, emit) {
      emit(
        BanksToTxnWith(
          banksReadyForUse: false,
          loadingBanks: false,
          banks: const [],
        ),
      );
    });
    on<LoadUserTransactions>((event, emit) {
      emit(
        UserTxns(
          loadingTxns: false,
          userTxnsReadyForUse: false,
          forTxnSearch: false,
          txns: const [],
        ),
      );
    });
    on<SearchUserTransactions>((event, emit) {
      emit(
        UserTxns(
          loadingTxns: false,
          userTxnsReadyForUse: true,
          forTxnSearch: true,
          txns: const [],
        ),
      );
    });
    on<EnterTellaTrustReceipentAcc>((event, emit) {
      emit(
        UserRecentTransfersAndAddedBeneficiaries(
          loadRecentTransfers: false,
          recentTransfersReadyForUse: false,
          addedBeneficiariesReadyForUse: false,
          loadAddedBeneficiaries: false,
          recentTransfers: const [],
          addedBeneficiaries: const [],
        ),
      );
    });
  }
}
