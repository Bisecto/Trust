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
    on<ChangePinEvent>(changePinEvent);
    on<ChangePasswordEvent>(changePasswordEvent);
    on<PasswordResetRequestOtpEventCLick>(passwordResetRequestOtpEventCLick);
    on<ResetPasswordEvent>(resetPasswordEvent);
  }

  Future<FutureOr<void>> signUpEventClick(
      SignUpEventClick event, Emitter<AuthState> emit) async {
    //emit(LoadingState());

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
        emit(AuthInitial());
        emit(AuthOtpRequestState(
            AppUtils.convertString(json.decode(response.body)['message'] +
                " OTP: " +
                json.decode(response.body)['data']['verifyToken']),
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

  FutureOr<void> verificationContinueEvent(
      VerificationContinueEvent event, Emitter<AuthState> emit) {
    emit(VerificationContinueState());
  }

  Future<FutureOr<void>> verifyOTPEventCLick(
      VerifyOTPEventCLick event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    AuthRepository authRepository = AuthRepository();
    // User user =
    //     User();
    String deviceId = await AppUtils.getId();

    Map<dynamic, String> data = {
      "token": event.token,
      "phone": await SharedPref.getString("phone"),
    };
    Map<dynamic, String> deviceData = {
      "token": event.token,
      "userData": await SharedPref.getString("phone"),
      "deviceId": deviceId
    };
    print(data);
    try {
      var response = await authRepository.authPostRequest(
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
        emit(AuthInitial());
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

  Future<FutureOr<void>> createPinEvent(
      CreatePinEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    AuthRepository authRepository = AuthRepository();
    String userId = await SharedPref.getString("userId");
    print(userId);
    print(userId);
    print(userId);
    print(userId);
    print(userId);
    print(userId);
    Map<dynamic, String> data = {
      "userId": userId,
      "accessPin": event.accessPin,
      "confirmAccessPin": event.confirmAccessPin
    };
    print(data);
    try {
      var response =
          await authRepository.authPostRequest(data, AppApis.createAccessPin);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        User user = User.fromJson(json.decode(response.body)['data']);
        print(response.body);
        await SharedPref.putString("accessPin", event.accessPin);
        await SharedPref.putString("email", user.email);
        await SharedPref.putString("phone", user.phone);
        await SharedPref.putString("userId", user.userId);
        await SharedPref.putString("firstname", user.firstName);
        await SharedPref.putString("lastName", user.lastName);
        emit(AuthInitial());

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
    AuthRepository authRepository = AuthRepository();
    Map<dynamic, String> data = {
      "userData": event.userData,
      "password": event.password,
      "deviceId": deviceID
    };
    try {
      var response = await authRepository.authPostRequest(data, AppApis.login);

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

        emit(InitiatedLoginState(
            //userData,
            AppUtils.convertString(json.decode(response.body)['message']),
            userData.firstName,jsonDecode(response.body)['data']['isAccessPinSet']??true));
        emit(AuthInitial());

      } else if (response.statusCode == 400 &&
          json.decode(response.body)['errorCode'] == 'E302') {
        SharedPref.putString('temUserData', event.userData);
        SharedPref.putString('temUserPassword', event.password);
        await SharedPref.putString(
            "phone", json.decode(response.body)['data']['phone']);
        emit(AuthOtpRequestState(
            AppUtils.convertString(json.decode(response.body)['message'] +
                " OTP: " +
                json.decode(response.body)['data']['verifyToken']),
            event.userData));
        emit(AuthInitial());

      } else if (response.statusCode == 400 &&
          json.decode(response.body)['errorCode'] == 'E301') {
        SharedPref.putString('temUserData', event.userData);
        SharedPref.putString('temUserPassword', event.password);

        await SharedPref.putString(
            "phone", json.decode(response.body)['data']['phone']);

        emit(AuthInitial());
        emit(AuthChangeDeviceOtpRequestState(
            AppUtils.convertString(json.decode(response.body)['message'] +
                "OTP " +
                json.decode(response.body)['data']['verifyToken']),
            json.decode(response.body)['data']['phone'],
            true));
      } else {
        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
        print(event.password);
        print(json.decode(response.body));
        emit(AuthInitial());
      }
    } catch (e) {
      print(e);
      emit(AuthInitial());
      print(12345678);
    }
  }

  FutureOr<void> signInEventClick(
      SignInEventClick event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    String refreshToken = await SharedPref.getString("refresh-token");

    AuthRepository authRepository = AuthRepository();
    Map<dynamic, String> data = {
      "userData": event.userData,
      "password": event.password,
      "accessPin": event.accessPin,
      "loginOption": event.loginOption,
    };
    try {
      var response = await authRepository.authPostRequest(
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

        // String? cookie = response.headers['set-cookie'];
        // print(response.headers.values);
        // print(response.headers.entries);
        // response.headers.forEach((name, values) {
        //   print('$name: $values');
        // });
        //await SharedPref.putString("lastName", userData.lastName);
        emit(AuthInitial());

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

  Future<FutureOr<void>> changePinEvent(
      ChangePinEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    String accessToken = await SharedPref.getString("access-token");

    AuthRepository authRepository = AuthRepository();
    Map<dynamic, String> data = {
      "oldAccessPin": event.oldPin,
      "newAccessPin": event.accessPin,
      "confirmAccessPin": event.confirmAccessPin
    };
    try {
      var response = await authRepository.authPostRequest(
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
        await SharedPref.putString("accessPin", event.accessPin);
        emit(AuthInitial());

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

  Future<FutureOr<void>> changePasswordEvent(
      ChangePasswordEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    String accessToken = await SharedPref.getString("access-token");

    AuthRepository authRepository = AuthRepository();
    // Map<dynamic, String> data = {
    //   "oldPassword": event.oldPassword,
    //   "newPassword": event.newPassword,
    //   "confirmPassword": event.confirmNewPassword
    // };
    try {
      var response = await authRepository.authPostRequest(
          event.data, AppApis.changePassword,
          accessToken: accessToken, accessPIN: event.pin);
      print(response.statusCode);

      print(response.body);
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
        emit(AuthInitial());

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

  Future<FutureOr<void>> passwordResetRequestOtpEventCLick(
      PasswordResetRequestOtpEventCLick event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    //String accessToken = await SharedPref.getString("access-token");

    AuthRepository authRepository = AuthRepository();
    Map<dynamic, String> data = {"userData": event.data, "medium": "phone"};
    try {
      var response = await authRepository.authPostRequest(
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
        emit(AuthInitial());

        emit(OTPRequestSuccessState(AppUtils.convertString(
            json.decode(response.body)['message'] +
                " OTP " +
                json.decode(response.body)['data']['verifyToken'])));
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

  Future<FutureOr<void>> resetPasswordEvent(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    //String accessToken = await SharedPref.getString("access-token");

    AuthRepository authRepository = AuthRepository();
    Map<dynamic, String> data = {
      "userData": event.userData,
      "token": event.token,
      "password": event.password,
      "confirmPassword": event.confirmPassword
    };
    try {
      var response = await authRepository.authPostRequest(
        data,
        //accessToken: accessToken,
        AppApis.resetPassword,
      );
      print(response.statusCode);

      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // await SharedPref.putString(
        //     "access-token", response.headers['access-token']!);
        emit(AuthInitial());

        emit(PasswordResetSuccessState(
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
