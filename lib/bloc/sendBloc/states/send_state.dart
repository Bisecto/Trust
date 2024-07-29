// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

abstract class SendState extends Equatable {
  const SendState();
}

class InitialSendState extends SendState {
  const InitialSendState();

  @override
  List<Object?> get props => [];
}

class ErrorStateForSendTo extends SendState {
  String errorMessage;
  ErrorStateForSendTo({required this.errorMessage});

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}

class UserBalance extends SendState {
  String balance;
  UserBalance({
    required this.balance,
  });

  @override
  List<Object?> get props => [
        balance,
      ];
}

class CurrentAmountEntered extends SendState {
  String mainValue;
  String fractionValue;
  CurrentAmountEntered({
    required this.mainValue,
    required this.fractionValue,
  }) : super();

  @override
  List<Object?> get props => [
        mainValue,
        fractionValue,
      ];
}

class SendToDetailsInitialState extends SendState {
  const SendToDetailsInitialState();

  @override
  List<Object?> get props => [];
}

class SendToDetailsGivenState extends SendState {
  const SendToDetailsGivenState();

  @override
  List<Object?> get props => [];
}

class ListOfBeneficiariesToSendTo extends SendState {
  List listOfBeneficiaries;
  ListOfBeneficiariesToSendTo({
    required this.listOfBeneficiaries,
  });

  @override
  List<Object?> get props => [
        listOfBeneficiaries,
      ];
}

class UserRecentTransfersAndAddedBeneficiaries extends SendState {
  List recentTransfers;
  bool loadRecentTransfers;
  bool recentTransfersReadyForUse;
  List addedBeneficiaries;
  bool loadAddedBeneficiaries;
  bool addedBeneficiariesReadyForUse;
  UserRecentTransfersAndAddedBeneficiaries({
    required this.recentTransfers,
    required this.loadRecentTransfers,
    required this.recentTransfersReadyForUse,
    required this.addedBeneficiaries,
    required this.loadAddedBeneficiaries,
    required this.addedBeneficiariesReadyForUse,
  });

  @override
  List<Object?> get props => [
        recentTransfers,
        loadRecentTransfers,
        recentTransfersReadyForUse,
        addedBeneficiaries,
        loadAddedBeneficiaries,
        addedBeneficiariesReadyForUse,
      ];
}

class BanksToTxnWith extends SendState {
  bool loadingBanks;
  bool banksReadyForUse;
  List banks;
  BanksToTxnWith({
    required this.loadingBanks,
    required this.banksReadyForUse,
    required this.banks,
  });

  @override
  List<Object?> get props => [
        loadingBanks,
        banksReadyForUse,
        banks,
      ];
}

class UserTxns extends SendState {
  bool loadingTxns;
  bool userTxnsReadyForUse;
  bool forTxnSearch;
  List txns;
  UserTxns({
    required this.loadingTxns,
    required this.userTxnsReadyForUse,
    required this.forTxnSearch,
    required this.txns,
  });

  @override
  List<Object?> get props => [
        loadingTxns,
        userTxnsReadyForUse,
        forTxnSearch,
        txns,
      ];
}

class SelectedTxnOption extends SendState {
  bool isItForTellaTrust;
  bool toggleOn;
  SelectedTxnOption({
    required this.isItForTellaTrust,
    required this.toggleOn,
  });

  @override
  List<Object?> get props => [
        isItForTellaTrust,
        toggleOn,
      ];
}
