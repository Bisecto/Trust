// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

abstract class SendEvent extends Equatable {
  const SendEvent();
}

class EnterAmountToSend extends SendEvent {
  bool isItForMainValue;
  String value;
  EnterAmountToSend({
    required this.isItForMainValue,
    required this.value,
  }) : super();

  @override
  List<Object?> get props => [
        isItForMainValue,
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

class LoadUserTransactions extends SendEvent {
  const LoadUserTransactions() : super();

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
