// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:teller_trust/model/bank_model.dart';

abstract class SendEvent extends Equatable {
  const SendEvent();
}

class EnterAmountToSend extends SendEvent {
 // bool isItForMainValue;
  String value;
  EnterAmountToSend({
   // required this.isItForMainValue,
    required this.value,
  }) : super();

  @override
  List<Object?> get props => [
        //isItForMainValue,
        value,
      ];
}

class BackSpaceLastEnteredAmountToSend extends SendEvent {
  const BackSpaceLastEnteredAmountToSend() : super();

  @override
  List<Object?> get props => [];
}

class LoadSendToDetailsInitialState extends SendEvent {
  const LoadSendToDetailsInitialState() : super();

  @override
  List<Object?> get props => [];
}

class SelectTxnOption extends SendEvent {
  bool isTxnForTellaTrust;
  SelectTxnOption({required this.isTxnForTellaTrust}) : super();

  @override
  List<Object?> get props => [
        isTxnForTellaTrust,
      ];
}

class LoadBanksToTxnWith extends SendEvent {
  const LoadBanksToTxnWith() : super();

  @override
  List<Object?> get props => [];
}

class SearchForABank extends SendEvent {
  String searchValue;
  List<Bank> banks;
  SearchForABank({
    required this.searchValue,
    required this.banks,
  }) : super();

  @override
  List<Object?> get props => [
    searchValue,
    banks,
  ];
}

class LoadUserTransactions extends SendEvent {
  const LoadUserTransactions() : super();

  @override
  List<Object?> get props => [];
}

class LoadUserBalance extends SendEvent {
  const LoadUserBalance() : super();

  @override
  List<Object?> get props => [];
}

class SearchUserTransactions extends SendEvent {
  String searchValue;
  SearchUserTransactions({
    required this.searchValue,
  }) : super();

  @override
  List<Object?> get props => [
        searchValue,
      ];
}

class EnterTellaTrustReceipentAcc extends SendEvent {
  String tellaTrustReceiptentAcc;
  EnterTellaTrustReceipentAcc({
    required this.tellaTrustReceiptentAcc,
  }) : super();

  @override
  List<Object?> get props => [
        tellaTrustReceiptentAcc,
      ];
}

class SendInternalFundToReceiptent extends SendEvent {
  String receiverId;
  String narration;
  num amount;
  String accessPin;
  SendInternalFundToReceiptent({
    required this.receiverId,
    required this.narration,
    required this.amount,
    required this.accessPin,
  }) : super();

  @override
  List<Object?> get props => [
        receiverId,
        narration,
        amount,
      ];
}

class SendExternalFundToReceiptent extends SendEvent {
  String bankCode;
  String accountNumber;
  String sessionId;
  String narration;
  String txnId;
  num amount;
  SendExternalFundToReceiptent({
    required this.bankCode,
    required this.accountNumber,
    required this.sessionId,
    required this.narration,
    required this.amount,
    required this.txnId,
  }) : super();

  @override
  List<Object?> get props => [
        bankCode,
        accountNumber,
        sessionId,
        narration,
        amount,
        txnId,
      ];
}

class VerifyRecepitentAccountNumber extends SendEvent {
  String bankCode;
  String accountNumber;
  VerifyRecepitentAccountNumber({
    required this.bankCode,
    required this.accountNumber,
  }) : super();

  @override
  List<Object?> get props => [
        bankCode,
        accountNumber,
      ];
}


class UserNarationForPayment extends SendEvent {
  String narration;
  UserNarationForPayment({required this.narration});

  @override
  List<Object?> get props => [
        narration,
      ];
}
