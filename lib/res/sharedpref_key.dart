import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKey {
  ///Temporal data
  static const String temUserDataKey = 'temUserData';
  static const String temPasswordKey = 'temUserPassword';
  static const String passwordKey = 'password';

  static const String emailKey = 'email';
  static const String phoneKey = 'phone';
  static const String userDataKey = 'userData';
  static const String userIdKey = 'userId';
  static const String hashedAccessPinKey = 'hashedAccessPin';
  static const String refreshTokenKey = 'refresh-token';
  static const String accessTokenKey = 'access-token';
  static const String firstNameKey = 'firstName';
  static const String lastNameKey = 'lastName';

  static const String isFirstOpenKey = 'isFirstOpen';
  static const String isMoneyBlockedKey = 'isMoneyBlocked';
  static const String notificationKey = 'notification';
  static const String biometricKey = 'biometric';
}
Future<void> clearAllSharedPrefs() async {
  final prefs = await SharedPreferences.getInstance();

  final keysToClear = [
    SharedPrefKey.temUserDataKey,
    SharedPrefKey.temPasswordKey,
    SharedPrefKey.passwordKey,
    SharedPrefKey.emailKey,
    SharedPrefKey.phoneKey,
    SharedPrefKey.userDataKey,
    SharedPrefKey.userIdKey,
    SharedPrefKey.hashedAccessPinKey,
    SharedPrefKey.refreshTokenKey,
    SharedPrefKey.accessTokenKey,
    SharedPrefKey.firstNameKey,
    SharedPrefKey.lastNameKey,
    SharedPrefKey.isFirstOpenKey,
    SharedPrefKey.isMoneyBlockedKey,
    SharedPrefKey.notificationKey,
    SharedPrefKey.biometricKey,
  ];

  for (var key in keysToClear) {
    await prefs.remove(key);
  }
}
