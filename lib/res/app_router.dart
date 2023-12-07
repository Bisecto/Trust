import 'package:flutter/material.dart';



class AppRouter {
  ///All route name

  /// ONBOARDING SCREEEN
  static const String splashScreen = '/';
  static const String onBoardingScreen = "/on-boarding-screen";

  /// AUTH SCREENS
  static const String signInPage = "/sign-in-page";
  static const String createAccountPage = "/sign-up-page";

  //static const String otpPage = "/otp-page";
  static const String signUpPageGetStarted = "/sign-up-page-get-started";

  ///IMPORTANT SCREENS
  static const String noInternetScreen = "/no-internet";

  ///LANDING PAGE LandingPage
  static const String landingPage = "/landing-page";
  static const String notificationPage = "/notification-page";

  static const String chooseLocation = "/choose-location-page";

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case signInPage:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case signUpPageGetStarted:
        return MaterialPageRoute(
            builder: (_) => const CreateAccountGetStartedPage());
      // case otpPage:
      //   return MaterialPageRoute(builder: (_) =>  OTPPage(email: '',));
      case landingPage:
        final UserModel userModel = routeSettings.arguments as UserModel;
        final GasPriceDetail gasPriceDetail = routeSettings.arguments as GasPriceDetail;
        final int currentIndex = routeSettings.arguments as int;

        return MaterialPageRoute(
            builder: (_) => LandingPage(
                  userModel: userModel, gasPriceDetail: gasPriceDetail, currentIndex: currentIndex,
                ));
      case createAccountPage:
        return MaterialPageRoute(builder: (_) => const CreateAccountPage());
      case notificationPage:
        return MaterialPageRoute(builder: (_) => const NotificationPage());
      case chooseLocation:
        final String gasKG = routeSettings.arguments as String;
        final UserModel userModel = routeSettings.arguments as UserModel;
        final GasPriceDetail gasPriceDetail = routeSettings.arguments as GasPriceDetail;

        return MaterialPageRoute(
            builder: (_) => ChooseLocation(
                  gasKG: gasKG, userModel: userModel, gasPriceDetail: gasPriceDetail,
                ));
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
