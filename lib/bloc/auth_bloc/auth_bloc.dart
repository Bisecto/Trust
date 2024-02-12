import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teller_trust/res/apis.dart';
import 'package:teller_trust/view/auth/otp_pin_pages/verify_otp.dart';

import '../../model/user.dart';
import '../../repository/auth_repository.dart';
import '../../utills/app_utils.dart';
import '../../utills/shared_preferences.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SignUpEventClick>(signUpEventClick);
    on<VerificationContinueEvent>(verificationContinueEvent);
    on<VerifyOTPEventCLick>(verifyOTPEventCLick);
    on<CreatePinEvent>(createPinEvent);
    on<InitialEvent>(initialEvent);
    on<InitiateSignInEventClick>(initiateSignInEventClick);
    on<SignInEventClick>(signInEventClick);
  }

  Future<FutureOr<void>> signUpEventClick(SignUpEventClick event,
      Emitter<AuthState> emit) async {
    emit(LoadingState());
    AuthRepository authRepository = AuthRepository();
    try {
      var response =
      await authRepository.authPostRequest(event.data, AppApis.signUpApi);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await SharedPref.putString("password", event.data["password"]!);
        await SharedPref.putString("email", event.data["email"]!);
        await SharedPref.putString("phone", event.data['phone']!);
        emit(AuthOtpRequestState(
            AppUtils.convertString(json.decode(response.body)['message']),
            event.data["email"]!));
      } else {
        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
        //print(event.password);
        print(json.decode(response.body));
        emit(AuthInitial());
      }
    } catch (e) {
      print(e);
      emit(AuthInitial());
      print(12345678);
    }
  }

  FutureOr<void> verificationContinueEvent(VerificationContinueEvent event,
      Emitter<AuthState> emit) {
    emit(VerificationContinueState());
  }

  Future<FutureOr<void>> verifyOTPEventCLick(VerifyOTPEventCLick event,
      Emitter<AuthState> emit) async {
    emit(LoadingState());
    AuthRepository authRepository = AuthRepository();
    // User user =
    //     User();
    Map<dynamic, String> data = {
      "token": event.token,
      "phone": await SharedPref.getString("phone")
    };
    print(data);
    try {
      var response =
      await authRepository.authPostRequest(data, AppApis.verifyPhone);
      print(response.statusCode);
      User user = User.fromJson(json.decode(response.body)['data']);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // await SharedPref.putString("password", event.user.password!);
        // await SharedPref.putString("email", event.user.email!);
        await SharedPref.putString("userId", user.id);
        emit(AuthOtpVerifySucess(
            AppUtils.convertString(json.decode(response.body)['message']),
            user));
      } else {
        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
        //print(event.password);
        print(json.decode(response.body));
        emit(AuthInitial());
      }
    } catch (e) {
      print(e);
      emit(AuthInitial());
      print(12345678);
    }
  }

  Future<FutureOr<void>> createPinEvent(CreatePinEvent event,
      Emitter<AuthState> emit) async {
    emit(LoadingState());
    AuthRepository authRepository = AuthRepository();
    Map<dynamic, String> data = {
      "userId": "46a73f07-e1a2-4d85-b1f6-3538e847d729",
      "accessPin": event.accessPin,
      "confirmAccessPin": event.confirmAccessPin
    };
    try {
      var response =
      await authRepository.authPostRequest(data, AppApis.createAccessPin);
      print(response.statusCode);
      User user = User.fromJson(json.decode(response.body)['data']);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await SharedPref.putString("accessPin", event.accessPin);
        await SharedPref.putString("email", user.email);
        await SharedPref.putString("phone", user.phone);
        await SharedPref.putString("userId", user.id);
        await SharedPref.putString("firstname", user.firstName);
        await SharedPref.putString("lastName", user.lastName);
        emit(SuccessState(
          user,
          AppUtils.convertString(json.decode(response.body)['message']),
        ));
      } else {
        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
        //print(event.password);
        print(json.decode(response.body));
        emit(AuthInitial());
      }
    } catch (e) {
      print(e);
      emit(AuthInitial());
      print(12345678);
    }
  }

  FutureOr<void> initialEvent(InitialEvent event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }

  Future<FutureOr<void>> initiateSignInEventClick(
      InitiateSignInEventClick event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    String deviceID = await AppUtils.getId();
    // print(deviceID);
    // print((deviceID + deviceID).substring(0, 16));
    AuthRepository authRepository = AuthRepository();
    Map<dynamic, String> data = {
      "userData": event.userData,
      "password": event.password,
      "deviceId": "eDMeP7882w4813q9"
    };
    try {
      var response = await authRepository.authPostRequest(data, AppApis.login);
      print(response.headers);

      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await SharedPref.putString("userData", event.userData);
        await SharedPref.putString("password", event.password);
        User userData = User.fromJson(jsonDecode(response.body)['data']);
        await SharedPref.putString("firstName", userData.firstName);
        await SharedPref.putString("lastName", userData.lastName);


        emit(InitiatedLoginState(userData,
            AppUtils.convertString(json.decode(response.body)['message'])));
      } else {
        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
        //print(event.password);
        print(json.decode(response.body));
        emit(AuthInitial());
      }
    } catch (e) {
      print(e);
      emit(AuthInitial());
      print(12345678);
    }
  }

  FutureOr<void> signInEventClick(SignInEventClick event,
      Emitter<AuthState> emit) async {
    emit(LoadingState());
    AuthRepository authRepository = AuthRepository();
    Map<dynamic, String> data = {
      "userData": event.userData,
      "password": event.password,
      "accessPin": event.accessPin,
      "loginOption": event.loginOption,
    };
    try {
      var response =
      await authRepository.authPostRequest(data, AppApis.loginAccessPin);
      print(response.statusCode);

      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await SharedPref.putString("userData", event.userData);
        await SharedPref.putString("password", event.password);
        User userData = User.fromJson(jsonDecode(response.body)['data']);
        await SharedPref.putString("firstName", userData.firstName);
        await SharedPref.putString("lastName", userData.lastName);
        // String? cookie = response.headers['set-cookie'];

        await SharedPref.putString("lastName", userData.lastName);

        emit(SuccessState(userData,
            AppUtils.convertString(json.decode(response.body)['message'])));
      } else {
        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
        //print(event.password);
        print(json.decode(response.body));
        emit(AuthInitial());
      }
    } catch (e) {
      print(e);
      emit(AuthInitial());
      print(12345678);
    }
  }
}
