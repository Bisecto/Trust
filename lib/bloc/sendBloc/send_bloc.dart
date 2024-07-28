import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/event/send_event.dart';
import 'package:teller_trust/bloc/sendBloc/states/send_state.dart';

class SendBloc extends Bloc<SendEvent, SendState> {
  String mainValueEntered = '';
  String fractionValueEntered = '';

  SendBloc() : super(const InitialSendState()) {
    on<EnterAmountToSend>((event, emit) {
      if (event.isItForMainValue && !fractionValueEntered.contains('.')) {
        mainValueEntered += event.value;
      } else {
        fractionValueEntered += event.value;
      }
      emit(
        CurrentAmountEntered(
          mainValue: mainValueEntered,
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
          mainValue: mainValueEntered,
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
