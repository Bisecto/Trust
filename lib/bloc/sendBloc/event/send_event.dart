import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class SendEvent extends Equatable {
  const SendEvent();
}

// ignore: must_be_immutable
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

// ignore: must_be_immutable
class BackSpaceLastEnteredAmountToSend extends SendEvent {
  const BackSpaceLastEnteredAmountToSend() : super();

  @override
  List<Object?> get props => [];
}
