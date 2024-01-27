import 'dart:convert';
import 'dart:io';

import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teller_trust/utills/shared_preferences.dart';

import '../res/app_router.dart';
import 'app_navigator.dart';



class AppUtils {





  openApp(context) async {
    bool isFirstOpen = (await SharedPref.getBool('isFirstOpen')) ?? true;
    String email = await SharedPref.getString('email');
    String password = await SharedPref.getString('password');
    print(8);

    if (isFirstOpen) {

      AppNavigator.pushAndReplaceName(context,
          name: AppRouter.onBoardingScreen);

    } else {
      print(15);

      await SharedPref.putBool('isFirstOpen', false);
      if (Platform.isAndroid) {
        AppNavigator.pushAndReplaceName(context,
            name: AppRouter.onBoardingScreen);

      } else {
        Future.delayed(const Duration(seconds: 3), () {
          AppNavigator.pushAndReplaceName(context,
              name: AppRouter.onBoardingScreen);
        });
      }
    }
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
