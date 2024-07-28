import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class SendState extends Equatable {
  const SendState();
}

class InitialSendState extends SendState {
  const InitialSendState();
  
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
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

