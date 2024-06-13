import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:teller_trust/utills/shared_preferences.dart';
import 'package:teller_trust/view/auth/sign_in_screen.dart';
import 'package:teller_trust/view/auth/sign_in_with_access_pin_and_biometrics.dart';
import 'package:teller_trust/view/important_pages/dialog_box.dart';

import '../res/app_router.dart';
import 'app_navigator.dart';

class AppUtils {
  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
  openApp(context) async {
    bool isFirstOpen = (await SharedPref.getBool('isFirstOpen')) ?? true;
    String userData = await SharedPref.getString('userData');
    String password = await SharedPref.getString('password');
    String firstame = await SharedPref.getString('firstName');
    print(userData);
    print(password);
    print(8);

    if (isFirstOpen) {
      print(1);
      if (userData.isNotEmpty && password.isNotEmpty) {
        print(3);

        Future.delayed(const Duration(seconds: 3), () {
          AppNavigator.pushAndRemovePreviousPages(context, page: SignInWIthAccessPinBiometrics(userName: firstame));
        });
      } else {
        print(4);

        Future.delayed(const Duration(seconds: 3), () {
          AppNavigator.pushAndRemovePreviousPages(context, page: SignInScreen());
        });
      }
    } else {
      print(15);

      await SharedPref.putBool('isFirstOpen', false);
      if (Platform.isAndroid) {
        print(5);

        Future.delayed(const Duration(seconds: 3), () {
          AppNavigator.pushAndReplaceName(context,
              name: AppRouter.onBoardingScreen);
        });
      } else {
        print(6);

        Future.delayed(const Duration(seconds: 3), () {
          AppNavigator.pushAndReplaceName(context,
              name: AppRouter.onBoardingScreen);
        });
      }
    }
  }
  static Future<bool> biometrics(String localizedReason) async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool didAuthenticate = await auth.authenticate(
        localizedReason: localizedReason, options: const AuthenticationOptions(biometricOnly: true));

    return didAuthenticate;
  }
  ///Future<String?>
  static getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }

  void copyToClipboard(textToCopy, context) {
    Clipboard.setData(ClipboardData(text: textToCopy));
    //MSG.snackBar(context, "$textToCopy copied");
    // You can also show a snackbar or any other feedback to the user.
    print('Text copied to clipboard: $textToCopy');
  }

  static Size deviceScreenSize(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return queryData.size;
  }

  static String convertPrice(dynamic price, {bool showCurrency = false}) {
    double amount = price is String ? double.parse(price) : price;
    final formatCurrency = NumberFormat("#,##0.00", "en_US");
    return '${showCurrency ? 'NGN' : ''} ${formatCurrency.format(amount)}';
  }

  static DateTime timeToDateTime(TimeOfDay time, [DateTime? date]) {
    final newDate = date ?? DateTime.now();
    return DateTime(
        newDate.year, newDate.month, newDate.day, time.hour, time.minute);
  }

  static String formatComplexDate({required String dateTime}) {
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(dateTime);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('d MMM y hh:mm a');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  static String convertString(dynamic data) {
    if (data is String) {
      return data;
    } else if (data is List && data.isNotEmpty) {
      return data[0];
    } else {
      return data[0];
    }
  }

  static String formateSimpleDate({String? dateTime}) {
    var inputDate = DateTime.parse(dateTime!);

    var outputFormat = DateFormat('MMM d, hh:mm a');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  // static bool isPhoneNumber(String s) {
  //   if (s.length > 16 || s.length < 11) return false;
  //   return hasMatch(s, r'^(?:[+0][1-9])?[0-9]{10,12}$');
  // }

  static final dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');
  static final dateFormat = DateFormat('dd MMM, yyyy');
  static final timeFormat = DateFormat('hh:mm a');
  static final apiDateFormat = DateFormat('yyyy-MM-dd');
  static final utcTimeFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
  static final dayOfWeekFormat = DateFormat('EEEEE', 'en_US');
}
