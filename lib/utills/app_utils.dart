import 'dart:io';
import 'package:encrypt/encrypt.dart' as prefix0;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:teller_trust/utills/shared_preferences.dart';
import 'package:teller_trust/view/auth/sign_in_screen.dart';
import 'package:teller_trust/view/auth/sign_in_with_access_pin_and_biometrics.dart';

import '../res/app_router.dart';
import '../res/sharedpref_key.dart';
import '../view/important_pages/dialog_box.dart';
import 'app_navigator.dart';

String? env(name) {
  return dotenv.env[name];
}

class AppUtils {
  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  void debuglog(object) {
    if (kDebugMode) {
      print(object.toString());
      // debugPrint(object.toString());
    }
  }

  //final IV iv = IV.fromLength(16);
  final iv = IV.allZerosOfLength(16);

  static Encrypter crypt() {
    final appKey = env('APP_KEY')!;
    try {
      final key = prefix0.Key.fromBase64(appKey);
      return Encrypter(AES(key, mode: AESMode.cbc));
    } catch (e) {
      throw FormatException('Invalid Base64 encoding in APP_KEY');
    }
  }

  dynamic encryptData(dynamic data) {
    try {
      return crypt().encrypt(data, iv: iv).base64;
    } catch (e) {
      print("Encryption error: $e");
      return null;
    }
  }

  dynamic decryptData(dynamic data) {
    try {
      return crypt().decrypt64(data, iv: iv);
    } catch (e) {
      print("Decryption error: $e");
      return null;
    }
  }

  openApp(context) async {
    bool isFirstOpen =
        (await SharedPref.getBool(SharedPrefKey.isFirstOpenKey)) ?? true;
    String userData = await SharedPref.getString(SharedPrefKey.userDataKey);
    String password = await SharedPref.getString(SharedPrefKey.passwordKey);
    String firstame = await SharedPref.getString(SharedPrefKey.firstNameKey);
    print(userData);
    print(password);
    print(8);

    if (!isFirstOpen) {
      print(1);
      if (userData.isNotEmpty && password.isNotEmpty) {
        print(3);

        Future.delayed(const Duration(seconds: 3), () {
          AppNavigator.pushAndRemovePreviousPages(context,
              page: SignInWIthAccessPinBiometrics(userName: firstame));
        });
      } else {
        print(4);

        Future.delayed(const Duration(seconds: 3), () {
          AppNavigator.pushAndRemovePreviousPages(context,
              page: const SignInScreen());
        });
      }
    } else {
      print(15);

      await SharedPref.putBool(SharedPrefKey.isFirstOpenKey, false);
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

  logout(context) async {
    SharedPref.remove(SharedPrefKey.passwordKey);
    SharedPref.remove(SharedPrefKey.emailKey);
    SharedPref.remove(SharedPrefKey.phoneKey);
    SharedPref.remove("accessPin");
    SharedPref.remove(SharedPrefKey.userIdKey);
    SharedPref.remove(SharedPrefKey.firstNameKey);
    SharedPref.remove(SharedPrefKey.lastNameKey);
    SharedPref.remove(SharedPrefKey.userDataKey);
    SharedPref.remove(SharedPrefKey.refreshTokenKey);
    SharedPref.remove(SharedPrefKey.accessTokenKey);
    SharedPref.remove(SharedPrefKey.temUserDataKey);
    SharedPref.remove(SharedPrefKey.temPasswordKey);
    SharedPref.remove("temUserPhone");
    SharedPref.remove(SharedPrefKey.hashedAccessPinKey);
    SharedPref.remove(SharedPrefKey.biometricKey);
    SharedPref.remove("temUserPhone");
    SharedPref.remove("accessPin");
  }

  static Future<bool> biometrics(String localizedReason) async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool didAuthenticate = await auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(biometricOnly: true));

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
    Clipboard.setData(ClipboardData(text: "${textToCopy}"));
    MSG.snackBar(context, "$textToCopy copied");
    // You can also show a snackbar or any other feedback to the user.
    print('Text copied to clipboard: $textToCopy');
  }

  static Size deviceScreenSize(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return queryData.size;
  }

  static String convertPrice(dynamic price, {bool showCurrency = false}) {
    double amount = price is String ? double.parse(price.toString()) : price;
    final formatCurrency = NumberFormat("#,##0.00", "en_US");
    return '${showCurrency ? 'NGN' : ''} ${formatCurrency.format(amount)}';
  }

  static DateTime timeToDateTime(TimeOfDay time, [DateTime? date]) {
    final newDate = date ?? DateTime.now();
    return DateTime(
        newDate.year, newDate.month, newDate.day, time.hour, time.minute);
  }

  static String formatString({required String data}) {
    if (data.isEmpty) return data;

    String firstLetter = data[0].toUpperCase();
    String remainingString = data.substring(1);

    return firstLetter + remainingString;
  }

  static String formatComplexDate({required String dateTime}) {
    DateTime parseDate = DateFormat("dd-MM-yyyy").parse(dateTime);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('d MMMM, yyyy');
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

    var outputFormat = DateFormat('yyyy MMM d, hh:mm a');
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
