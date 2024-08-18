import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teller_trust/model/category_model.dart';
import 'package:teller_trust/view/auth/sign_up_screen.dart';
import 'package:teller_trust/view/the_app_screens/bills_page.dart';
import 'package:teller_trust/view/the_app_screens/card_page.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/profile_details.dart';
import 'package:teller_trust/view/the_app_screens/sevices/airtime_purchase/airtime.dart';
import 'package:teller_trust/view/the_app_screens/sevices/make_bank_transfer/bank_transfer.dart';

import '../bloc/app_bloc/app_bloc.dart';
import '../view/auth/sign_in_with_access_pin_and_biometrics.dart';
import '../view/auth/sign_in_screen.dart';
import '../view/important_pages/not_found_page.dart';
import '../view/on_boarding/main_on_boarding_screen.dart';
import '../view/splash_screen.dart';
import '../view/the_app_screens/landing_page.dart';
import '../view/the_app_screens/more_pages/tella_rewards/tella_manage_point.dart';
import '../view/the_app_screens/more_pages/tella_rewards/tella_point_product_container.dart';
import '../view/the_app_screens/more_pages/tella_rewards/tella_reward_main.dart';
import '../view/the_app_screens/send_page.dart';

class AppRouter {
  ///All route name

  /// ONBOARDING SCREEEN
  static const String splashScreen = '/';
  static const String onBoardingScreen = "/on-boarding-screen";

  /// AUTH SCREENS
  static const String signInScreen = "/sign-in-page";
  static const String signUpScreen = "/sign-up-page";

  //static const String otpVerification = "/otp-page";
  static const String signInWIthAccessPinBiometrics =
      "/sign-in-wIth-access-pin-biometrics";

  ///IMPORTANT SCREENS
  static const String noInternetScreen = "/no-internet";

  ///LANDING PAGE LandingPage
  static const String landingPage = "/landing-page";

  // static const String homePage = "/home-page";
  static const String sendPage = "/send-page";
  static const String billsPage = "/bills-page";
  static const String cardPage = "/card-page";
  static const String morePage = "/more-page";
  static const String notificationPage = "/notification-page";
  static const String profileDetailsPage = "/profile-detail-page";

  static const String chooseLocation = "/choose-location-page";

  // network center screens
  static const String networkMainPage = '/network-main-page';
  static const String airtimeNetworkPage = '/airtime-network-page';
  static const String dataNetworkPage = '/data-network-page';
  static const String electricityNetworkPage = '/electricity-network-page';
  static const String bettingNetworkPage = '/betting-network-page';
  static const String internetNetworkPage = '/internet-network-page';
  static const String cableTVNetworkPage = '/cable-tv-network-page';
  static const String bankNetworkPage = '/bank-network-page';
  static const String tellaPointPage = '/tella-point-page';

  //static const String airtime = '/airtime';

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case signUpScreen:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case tellaPointPage:
        return MaterialPageRoute(builder: (_) => BlocProvider(
    create: (_) => AppBloc(),
    child:   const TellaPointMainPage(),
    ));
      // case otpVerification:
      //   return MaterialPageRoute(
      //       builder: (_) => VerifyOtp(
      //             email: 'userEmail', isRegister: true,
      //           ));
      case signInScreen:
        return MaterialPageRoute(builder: (_) => const SignInScreen());

      case landingPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppBloc(),
            child: const LandingPage(),
          ),
        );
      case profileDetailsPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppBloc(),
            child: const ProfileDetails(),
          ),
        );
      case signInWIthAccessPinBiometrics:
        return MaterialPageRoute(
            builder: (_) => SignInWIthAccessPinBiometrics(
                  userName: 'name',
                ));
      // case homePage:
      //   final User user =
      //   routeSettings.arguments as User;
      //
      //   return MaterialPageRoute(builder: (_) =>  HomePage(user: user,));
      // case airtime:
      //   return MaterialPageRoute(builder: (_) =>  AirtimePurchase(category: Category.fromJson(json.decode('')),));
      case sendPage:
        return MaterialPageRoute(builder: (_) => const SendPage());
      case billsPage:
        return MaterialPageRoute(builder: (_) => const BillsPage());
      case cardPage:
        return MaterialPageRoute(builder: (_) => const CardPage());
      // case morePage:
      //   return MaterialPageRoute(builder: (_) => const MorePage());

      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
