import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:teller_trust/model/customer_profile.dart';
import 'package:teller_trust/model/personal_profile.dart';
import 'package:teller_trust/model/wallet_info.dart';
import 'package:teller_trust/repository/app_repository.dart';
import 'package:teller_trust/res/apis.dart';

import '../../model/user.dart';
import '../../utills/app_utils.dart';
import '../../utills/constants/loading_dialog.dart';
import '../../utills/shared_preferences.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  CustomerProfile? customerProfile; // Variable to store user data
  AppBloc() : super(AppInitial()) {
    on<InitialEvent>(initialEvent);
    on<AddWithdrawalAccount>(addWithdrawalAccount);

    // on<AppEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }

  Future<FutureOr<void>> initialEvent(
      InitialEvent event, Emitter<AppState> emit) async {
    emit(LoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString("access-token");

    //try {
    var profileResponse = await appRepository.appGetRequest(
      AppApis.userProfile,
      accessToken: accessToken,
    );
    print("Profile status COde ${profileResponse.statusCode}");
    print("Profile Data ${profileResponse.body}");
    if (profileResponse.statusCode == 200 ||
        profileResponse.statusCode == 201) {
      CustomerProfile customerProfile =
          CustomerProfile.fromJson(json.decode(profileResponse.body)['data']);

      emit(SuccessState(customerProfile)); // Emit success state with data
    } else {
      emit(ErrorState(AppUtils.convertString(
          json.decode(profileResponse.body)['message'])));
      print(json.decode(profileResponse.body));
    }
    // } catch (e) {
    //   emit(ErrorState("An error occurred while fetching user profile."));
    //   print(e);
    // }
  }

  void updateData(CustomerProfile _customerProfile) {
    customerProfile = _customerProfile;
    emit(SuccessState(customerProfile!));
  }

  Future<FutureOr<void>> addWithdrawalAccount(
      AddWithdrawalAccount event, Emitter<AppState> emit) async {
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('Processing...');
        });
    //String accessToken = await SharedPref.getString("access-token");

    AppRepository appRepository = AppRepository();
    Map<dynamic, String> data = {
      "accountNumber": event.accountNumber,
      "bvn": event.bvn,
      "bankCode": event.bankCode
    };
    try {
      var response = await appRepository.appPostRequest(
        data,
        //accessToken: accessToken,
        AppApis.addWithdrawalAccount,
      );
      print(response.statusCode);

      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // await SharedPref.putString(
        //     "access-token", response.headers['access-token']!);
        Navigator.pop(event.context);

        // emit(PasswordResetSuccessState(
        //     AppUtils.convertString(json.decode(response.body)['message'])));
        emit(WirthdrawalAccountAdded());
      } else {
        Navigator.pop(event.context);
        emit(WirthdrawalAccountAddedError(
            AppUtils.convertString(json.decode(response.body)['message'])));
        //print(event.password);
        print(json.decode(response.body));
      }
    } catch (e) {
      print(e);
      Navigator.pop(event.context);
      emit(WirthdrawalAccountAddedError(
          AppUtils.convertString("There was a problem")));
      print(12345678);
    }
  }
}
