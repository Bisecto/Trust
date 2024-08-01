// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:teller_trust/model/bank_model.dart';
import 'package:teller_trust/model/bank_verified_account_model.dart';
import 'package:teller_trust/model/tella_trust_customer_model.dart';

import '../../../model/transactionHistory.dart';

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

class TellaTrustCustomerVerification extends SendState {
  TellaTrustCustomerModel? tellaTrustCustomerModel;
  bool requestInProgress;
  bool tellaTrustCustomerReceived;
  String message;
  TellaTrustCustomerVerification({
    required this.requestInProgress,
    this.tellaTrustCustomerReceived = false,
    this.tellaTrustCustomerModel,
    this.message = '',
  });

  @override
  List<Object?> get props => [
        requestInProgress,
        tellaTrustCustomerReceived,
        tellaTrustCustomerModel,
        message,
      ];
}

class BanksToTxnWith extends SendState {
  bool loadingBanks;
  bool banksReadyForUse;
  bool filteredAnyBank;
  List<Bank> banks;
  BanksToTxnWith({
    required this.loadingBanks,
    required this.banksReadyForUse,
    required this.filteredAnyBank,
    required this.banks,
  });

  @override
  List<Object?> get props => [
        loadingBanks,
        banksReadyForUse,
        filteredAnyBank,
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

class SendFundToInternalOrExternalRecepitent extends SendState {
  bool isPaymentSuccessful;
  bool processingPayment;
  String statusMessage;
  Transaction? transaction;
  SendFundToInternalOrExternalRecepitent({
    required this.processingPayment,
    required this.isPaymentSuccessful,
    required this.statusMessage,
     this.transaction
  });

  @override
  List<Object?> get props => [
        processingPayment,
        isPaymentSuccessful,
        statusMessage,
      ];
}

class VerificationStateForBankAccountNumber extends SendState {
  bool isRequestInProgress;
  bool isDataReadyForUse;
  String statusMessage;
  BankVerifiedAccountModel? bankVerifiedAccount;
  VerificationStateForBankAccountNumber({
    required this.isDataReadyForUse,
    required this.isRequestInProgress,
    required this.statusMessage,
    this.bankVerifiedAccount,
  });

  @override
  List<Object?> get props => [
        isDataReadyForUse,
        isRequestInProgress,
        statusMessage,
        bankVerifiedAccount,
      ];
}

class PaymentNarration extends SendState {
  String narration;
  PaymentNarration({required this.narration});

  @override
  List<Object?> get props => [
        narration,
      ];
}
