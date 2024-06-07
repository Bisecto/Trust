part of 'kyc_bloc.dart';

@immutable
abstract class KycEvent {}

class InitiateVerification extends KycEvent {
  final String identityType;
  final String identityNumber;

  InitiateVerification(this.identityType, this.identityNumber);
}
