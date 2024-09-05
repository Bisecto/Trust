import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../repository/app_repository.dart';
import '../../res/apis.dart';
import '../../res/sharedpref_key.dart';
import '../../utills/constants/loading_dialog.dart';
import '../../utills/shared_preferences.dart';

part 'kyc_event.dart';

part 'kyc_state.dart';

class KycBloc extends Bloc<KycEvent, KycState> {
  KycBloc() : super(KycInitial()) {
    on<InitiateVerification>(initiateVerification);
    on<ValidateVerification>(validateVerification);
    // on<KycEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }

  FutureOr<void> initiateVerification(
      InitiateVerification event, Emitter<KycState> emit) async {
    //emit(LoadingState());
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('Processing...');
        });
    AppRepository appRepository = AppRepository();
    try {
      Map<String, String> data = {
        "type": event.identityType,
        "identityNumber": event.identityNumber,
        "dateOfBirth":event.dob
      };
      String accessToken = await SharedPref.getString(SharedPrefKey.accessTokenKey);

      var verificationResponse = await appRepository.appPostRequest(
          data, AppApis.initiateVerification,
          accessToken: accessToken);
      print(verificationResponse.statusCode);
      print(verificationResponse.body);
      Navigator.pop(event.context);
      if (verificationResponse.statusCode == 200 ||
          verificationResponse.statusCode == 201) {
        // BankModel bankModel =
        // BankModel.fromJson(json.decode(bankResponse.body)['data']);
        emit(RequestOtpState(
            json.decode(verificationResponse.body)['data']['identityId']));
      } else if (json.decode(verificationResponse.body)['errorCode'] ==
          "N404") {
        emit(AccessTokenExpireState());
      } else {
        emit(ErrorState(json.decode(verificationResponse.body)['message']));
      }
    } catch (e) {
      emit(ErrorState('Failed to: $e'));
    }
  }

  FutureOr<void> validateVerification(
      ValidateVerification event, Emitter<KycState> emit) async {
    //emit(LoadingState());
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('Processing...');
        });
    AppRepository appRepository = AppRepository();
    try {
      Map<String, String> data = {
        "identityId": event.identityId,
        "identityNumber": event.identityNumber,
        "type": event.identityType,
        "otp": event.otp,
      };
      String accessToken = await SharedPref.getString(SharedPrefKey.accessTokenKey);

      var validateVerificationResponse = await appRepository.appPostRequest(
          data, AppApis.validateVerification,
          accessToken: accessToken);
      print(validateVerificationResponse.statusCode);
      print(validateVerificationResponse.body);
      if (validateVerificationResponse.statusCode == 200 ||
          validateVerificationResponse.statusCode == 201) {
        // BankModel bankModel =
        // BankModel.fromJson(json.decode(bankResponse.body)['data']);
        Navigator.pop(event.context);
        emit(SuccessState(
            json.decode(validateVerificationResponse.body)['message'],
            json.decode(validateVerificationResponse.body)['data']
                ['accountName'],
            json.decode(validateVerificationResponse.body)['data']['bankName'],
            json.decode(validateVerificationResponse.body)['data']['nuban']));
      } else if (json.decode(validateVerificationResponse.body)['errorCode'] ==
          "N404") {
        Navigator.pop(event.context);

        emit(AccessTokenExpireState());
      } else {
        Navigator.pop(event.context);

        emit(ErrorState(
            json.decode(validateVerificationResponse.body)['message']));
      }
    } catch (e) {
      Navigator.pop(event.context);

      emit(ErrorState('Failed to: $e'));
    }
  }
}
