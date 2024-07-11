part of 'kyc_bloc.dart';

@immutable
abstract class KycEvent {}

class InitiateVerification extends KycEvent {
  final String identityType;
  final String identityNumber;
  final String dob;
  final BuildContext context;

  InitiateVerification(this.identityType, this.identityNumber,this.dob, this.context);
}

class ValidateVerification extends KycEvent {
  final String identityType;
  final String identityId;
  final String identityNumber;
  final String otp;
  final BuildContext context;

  ValidateVerification(this.identityType, this.identityId, this.otp,
      this.identityNumber,  this.context);
}
