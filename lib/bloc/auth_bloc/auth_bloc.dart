import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:teller_trust/res/apis.dart';

import '../../model/user.dart';
import '../../repository/app_repository.dart';
import '../../utills/app_utils.dart';
import '../../utills/constants/loading_dialog.dart';
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
    on<ChangePinEvent>(changePinEvent);
    on<ChangePasswordEvent>(changePasswordEvent);
    on<PasswordResetRequestOtpEventCLick>(passwordResetRequestOtpEventCLick);
    on<ResetPasswordEvent>(resetPasswordEvent);
  }

  Future<FutureOr<void>> signUpEventClick(
      SignUpEventClick event, Emitter<AuthState> emit) async {
    //emit(LoadingState());
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('Creating Account...');
        });
    AppRepository authRepository = AppRepository();
    try {
      var response =
          await authRepository.appPostRequest(event.data, AppApis.signUpApi);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await SharedPref.putString("password", event.data["password"]!);
        await SharedPref.putString("email", event.data["email"]!);
        await SharedPref.putString("phone", event.data['phone']!);
        await SharedPref.putString("userData", event.data['phone']!);
        Navigator.pop(event.context);
        emit(AuthOtpRequestState(
            AppUtils.convertString(json.decode(response.body)['message']),
            event.data["email"]!));
        emit(AuthInitial());

      } else {
        Navigator.pop(event.context);

        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
        //print(event.password);
        print(json.decode(response.body));
        emit(AuthInitial());
      }
    } catch (e) {
      Navigator.pop(event.context);

      print(e);
      emit(AuthInitial());
      print(12345678);
    }
  }

  FutureOr<void> verificationContinueEvent(
      VerificationContinueEvent event, Emitter<AuthState> emit) {
    emit(VerificationContinueState());
  }

  Future<FutureOr<void>> verifyOTPEventCLick(
      VerifyOTPEventCLick event, Emitter<AuthState> emit) async {
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('Verifying OTP...');
        });
    AppRepository authRepository = AppRepository();
    // User user =
    //     User();
    String deviceId = await AppUtils.getId();

    Map<String, dynamic> data = {
      "token": event.token,
      "phone": await SharedPref.getString("phone"),
    };
    Map<String, dynamic> deviceData = {
      "token": event.token,
      "userData": await SharedPref.getString("phone"),
      "deviceId": deviceId
    };
    print(data);
    try {
      var response = await authRepository.appPostRequest(
          !event.isDeviceChange ? deviceData : data,
          !event.isDeviceChange
              ? AppApis.verifyDeviceChange
              : AppApis.verifyPhone);
      print(response.statusCode);
      print(response.body);
      print(response.headers.values);
      print(response.headers.entries);
      response.headers.forEach((name, values) {
        print('$name: $values');
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        // await SharedPref.putString("password", event.user.password!);
        // await SharedPref.putString("email", event.user.email!);
        User user = User.fromJson(json.decode(response.body)['data']);
        print(response.body);
        await SharedPref.putString("userId", user.userId);
        Navigator.pop(event.context);
        emit(AuthOtpVerifySucess(
            AppUtils.convertString(json.decode(response.body)['message']),
            user));
        emit(AuthInitial());

      } else {
        Navigator.pop(event.context);

        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
        //print(event.password);
        print(json.decode(response.body));
        emit(AuthInitial());
      }
    } catch (e) {
      Navigator.pop(event.context);
      print(e);
      emit(AuthInitial());
      print(12345678);
    }
  }

  Future<FutureOr<void>> createPinEvent(
      CreatePinEvent event, Emitter<AuthState> emit) async {
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('Creating Access PIN...');
        });
    AppRepository authRepository = AppRepository();
    String userId = await SharedPref.getString("userId");
    print(userId);
    print(userId);
    print(userId);
    print(userId);
    print(userId);
    print(userId);
    Map<String, dynamic> data = {
      "userId": userId,
      "accessPin": event.accessPin,
      "confirmAccessPin": event.confirmAccessPin
    };
    print(data);
    try {
      var response =
          await authRepository.appPostRequest(data, AppApis.createAccessPin);

      if (response.statusCode == 200 || response.statusCode == 201) {
        String deviceID = await AppUtils.getId();
        String userData=await SharedPref.getString('userData');
        String password=await SharedPref.getString('password');
        String hashedAccessPin=await AppUtils().encryptData(event.accessPin);
        await SharedPref.putString('hashedAccessPin',hashedAccessPin);

        Map<String, dynamic> loginData = {
          "userData": userData,
          "password": password,
          "accessPin": event.accessPin,
          "loginOption": "accessPin",
        };
        await SharedPref.putString(
            "refresh-token", response.headers['refresh-token']!);

        var loginResponse = await authRepository.appPostRequest(
            loginData, AppApis.loginAccessPin,
            refreshToken: response.headers['refresh-token']!);
        print(loginResponse.statusCode);

        print(loginResponse.body);
        if (loginResponse.statusCode == 200 || loginResponse.statusCode == 201) {
          await SharedPref.putString("userData", userData);
          await SharedPref.putString("password", password);
          User user = User.fromJson(jsonDecode(loginResponse.body)['data']);
          await SharedPref.putString("firstName", user.firstName);
          await SharedPref.putString("lastName", user.lastName);
          await SharedPref.putString(
              "access-token", loginResponse.headers['access-token']!);

          Navigator.pop(event.context);

          emit(SuccessState(
            user,
            AppUtils.convertString(json.decode(loginResponse.body)['message']),
          ));
          emit(AuthInitial());
        }else{
          Navigator.pop(event.context);

          emit(ErrorState(
              AppUtils.convertString(json.decode(loginResponse.body)['message'])));
          //print(event.password);
          print(json.decode(loginResponse.body));
          emit(AuthInitial());
        }
      } else {
        Navigator.pop(event.context);

        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
        //print(event.password);
        print(json.decode(response.body));
        emit(AuthInitial());
      }
    } catch (e) {
      print(e);
      Navigator.pop(event.context);

      emit(AuthInitial());
      print(12345678);
    }
  }

  FutureOr<void> initialEvent(InitialEvent event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }

  Future<FutureOr<void>> initiateSignInEventClick(
      InitiateSignInEventClick event, Emitter<AuthState> emit) async {
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('Initiating login...');
        });
    String deviceID = await AppUtils.getId();
    AppRepository authRepository = AppRepository();
    Map<String, dynamic> data = {
      "userData": event.userData,
      "password": event.password,
      "deviceId": deviceID
    };
    //try {
      var response = await authRepository.appPostRequest(data, AppApis.login);

      print(response.statusCode);
      print(response.body);
      print(response.headers.values);
      print(response.headers.entries);
      response.headers.forEach((name, values) {
        print('$name: $values');
      });

      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await SharedPref.putString("userData", event.userData);
        await SharedPref.putString("password", event.password);
        User userData = User.fromJson(jsonDecode(response.body)['data']);
        await SharedPref.putString("firstName", userData.firstName);
        await SharedPref.putString("lastName", userData.lastName);
        await SharedPref.putString("userId", userData.userId);
        print(response.headers['refresh-token']);
        await SharedPref.putString(
            "refresh-token", response.headers['refresh-token']!);
        Navigator.pop(event.context);

        emit(InitiatedLoginState(
            //userData,
            AppUtils.convertString(json.decode(response.body)['message']),
            userData.firstName,jsonDecode(response.body)['data']['isAccessPinSet']??true));
        emit(AuthInitial());

      } else if (response.statusCode == 400 &&
          json.decode(response.body)['errorCode'] == 'E302') {
        SharedPref.putString('temUserData', event.userData);
        SharedPref.putString('temUserPassword', event.password);
        Navigator.pop(event.context);

        await SharedPref.putString(
            "phone", json.decode(response.body)['data']['phone']);
        emit(AuthOtpRequestState(
            AppUtils.convertString(json.decode(response.body)['message'] ),
            event.userData));
        emit(AuthInitial());

      } else if (response.statusCode == 400 &&
          json.decode(response.body)['errorCode'] == 'E301') {
        SharedPref.putString('temUserData', event.userData);
        SharedPref.putString('temUserPassword', event.password);

        await SharedPref.putString(
            "phone", json.decode(response.body)['data']['phone']);
        Navigator.pop(event.context);

        emit(AuthChangeDeviceOtpRequestState(
            AppUtils.convertString(json.decode(response.body)['message'] ),
            json.decode(response.body)['data']['phone'],
            true));
        emit(AuthInitial());

      } else {
        Navigator.pop(event.context);

        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
        print(event.password);
        print(json.decode(response.body));
        emit(AuthInitial());
      }
    // } catch (e) {
    //   print(e);
    //   Navigator.pop(event.context);
    //
    //   emit(AuthInitial());
    //   print(12345678);
    // }
  }

  FutureOr<void> signInEventClick(
      SignInEventClick event, Emitter<AuthState> emit) async {
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('Signing user in...');
        });
    String refreshToken = await SharedPref.getString("refresh-token");

    AppRepository authRepository = AppRepository();
    Map<String, dynamic> data = {
      "userData": event.userData,
      "password": event.password,
      "accessPin": event.accessPin,
      "loginOption": event.loginOption,
    };
    try {
      var response = await authRepository.appPostRequest(
          data, AppApis.loginAccessPin,
          refreshToken: refreshToken);
      print(response.statusCode);

      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await SharedPref.putString("userData", event.userData);
        await SharedPref.putString("password", event.password);
        User userData = User.fromJson(jsonDecode(response.body)['data']);
        await SharedPref.putString("firstName", userData.firstName);
        await SharedPref.putString("lastName", userData.lastName);
        await SharedPref.putString(
            "access-token", response.headers['access-token']!);
        String hashedAccessPin=await AppUtils().encryptData(event.accessPin);
        await SharedPref.putString('hashedAccessPin',hashedAccessPin);

        // String? cookie = response.headers['set-cookie'];
        // print(response.headers.values);
        // print(response.headers.entries);
        // response.headers.forEach((name, values) {
        //   print('$name: $values');
        // });
        //await SharedPref.putString("lastName", userData.lastName);
        Navigator.pop(event.context);

        emit(SuccessState(userData,
            AppUtils.convertString(json.decode(response.body)['message'])));
        emit(AuthInitial());

      } else {
        Navigator.pop(event.context);

        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
        //print(event.password);
        print(json.decode(response.body));
        emit(AuthInitial());
      }
    } catch (e) {
      print(e);
      Navigator.pop(event.context);

      emit(AuthInitial());
      print(12345678);
    }
  }

  Future<FutureOr<void>> changePinEvent(
      ChangePinEvent event, Emitter<AuthState> emit) async {
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('Changing pin...');
        });
    String accessToken = await SharedPref.getString("access-token");

    AppRepository authRepository = AppRepository();
    Map<String, dynamic> data = {
      "oldAccessPin": event.oldPin,
      "newAccessPin": event.accessPin,
      "confirmAccessPin": event.confirmAccessPin
    };
    try {
      var response = await authRepository.appPostRequest(
          data, AppApis.changeAccessPin,
          accessToken: accessToken);
      print(response.statusCode);

      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // await SharedPref.putString("userData", event.userData);
        // await SharedPref.putString("password", event.password);
        User userData = User(
            firstName: "firstName",
            middleName: "middleName",
            lastName: "lastName",
            email: "email",
            phone: 'phone',
            userId: 'userId',
            emailVerified: 'emailVerified',
            phoneVerified: false,
            imageUrl: 'imageUrl');
        // await SharedPref.putString("firstName", userData.firstName);
        // await SharedPref.putString("lastName", userData.lastName);
        // await SharedPref.putString(
        //     "access-token", response.headers['access-token']!);

        // String? cookie = response.headers['set-cookie'];
        // print(response.headers.values);
        // print(response.headers.entries);
        // response.headers.forEach((name, values) {
        //   print('$name: $values');
        // });
        //await SharedPref.putString("lastName", userData.lastName);
        String hashedAccessPin=await AppUtils().encryptData(event.accessPin);
        await SharedPref.putString('hashedAccessPin',hashedAccessPin);
        Navigator.pop(event.context);

        emit(SuccessState(userData,
            AppUtils.convertString(json.decode(response.body)['message'])));
        emit(AuthInitial());

      }else if (response.statusCode == 401) {
        emit(AccessTokenExpireState());
      } else {
        Navigator.pop(event.context);

        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
        //print(event.password);
        print(json.decode(response.body));
        emit(AuthInitial());
      }
    } catch (e) {
      print(e);
      Navigator.pop(event.context);

      emit(AuthInitial());
      print(12345678);
    }
  }

  Future<FutureOr<void>> changePasswordEvent(
      ChangePasswordEvent event, Emitter<AuthState> emit) async {
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('Changing password ...');
        });
    String accessToken = await SharedPref.getString("access-token");

    AppRepository authRepository = AppRepository();
    // Map<String, dynamic> data = {
    //   "oldPassword": event.oldPassword,
    //   "newPassword": event.newPassword,
    //   "confirmPassword": event.confirmNewPassword
    // };
    try {
      var response = await authRepository.appPostRequest(
          event.data, AppApis.changePassword,
          accessToken: accessToken, accessPIN: event.pin);
      print(response.statusCode);

     // print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // await SharedPref.putString("userData", event.userData);
        await SharedPref.putString("password", event.data['newPassword']!);
        User userData = User.fromJson(jsonDecode(response.body)['data']);
        // await SharedPref.putString("firstName", userData.firstName);
        // await SharedPref.putString("lastName", userData.lastName);
        // await SharedPref.putString(
        //     "access-token", response.headers['access-token']!);

        // String? cookie = response.headers['set-cookie'];
        // print(response.headers.values);
        // print(response.headers.entries);
        // response.headers.forEach((name, values) {
        //   print('$name: $values');
        // });
        //await SharedPref.putString("lastName", userData.lastName);
        Navigator.pop(event.context);

        emit(SuccessState(userData,
            AppUtils.convertString(json.decode(response.body)['message'])));
        emit(AuthInitial());

      } else if (response.statusCode == 401) {
        emit(AccessTokenExpireState());
      }else {
        Navigator.pop(event.context);

        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
        //print(event.password);
        print(json.decode(response.body));
        emit(AuthInitial());
      }
    } catch (e) {

      //Navigator.pop(event.context);

      print(e);
      emit(AuthInitial());
      emit(ErrorState("There was a problem"));

      Navigator.pop(event.context);

      print(12345678);
    }
  }

  Future<FutureOr<void>> passwordResetRequestOtpEventCLick(
      PasswordResetRequestOtpEventCLick event, Emitter<AuthState> emit) async {
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('Requesting OTP...');
        });
    //String accessToken = await SharedPref.getString("access-token");

    AppRepository authRepository = AppRepository();
    Map<String, dynamic> data = {"userData": event.data, "medium": "phone"};
    try {
      var response = await authRepository.appPostRequest(
        data,
        AppApis.sendPhoneToken,
      );
      print(response.statusCode);
      // response.headers.forEach((name, values) {
      //   print('$name: $values');
      // });
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // print(response.headers.keys);
        // await SharedPref.putString(
        //     "access-token", response.headers['access-token']!);
        Navigator.pop(event.context);

        emit(OTPRequestSuccessState(AppUtils.convertString(
            json.decode(response.body)['message'])));
        emit(AuthInitial());

      } else {
        Navigator.pop(event.context);

        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
        //print(event.password);
        print(json.decode(response.body));
        emit(AuthInitial());
      }
    } catch (e) {
      print(e);
      Navigator.pop(event.context);

      emit(AuthInitial());
      print(12345678);
    }
  }

  Future<FutureOr<void>> resetPasswordEvent(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('Reseting password...');
        });
    //String accessToken = await SharedPref.getString("access-token");

    AppRepository authRepository = AppRepository();
    Map<String, dynamic> data = {
      "userData": event.userData,
      "token": event.token,
      "password": event.password,
      "confirmPassword": event.confirmPassword
    };
    try {
      var response = await authRepository.appPostRequest(
        data,
        //accessToken: accessToken,
        AppApis.resetPassword,
      );
      print(response.statusCode);

      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // await SharedPref.putString(
        //     "access-token", response.headers['access-token']!);
        Navigator.pop(event.context);

        emit(PasswordResetSuccessState(
            AppUtils.convertString(json.decode(response.body)['message'])));
        emit(AuthInitial());

      } else {
        Navigator.pop(event.context);
        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
        //print(event.password);
        print(json.decode(response.body));
        emit(AuthInitial());
      }
    } catch (e) {
      print(e);
      Navigator.pop(event.context);
      emit(AuthInitial());
      print(12345678);
    }
  }
}
