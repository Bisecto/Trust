import 'dart:async';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idle_detector_wrapper/idle_detector_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/bloc/product_bloc/product_bloc.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/view/important_pages/no_internet.dart';
import 'package:teller_trust/view/sendBeneficary/pages/send_main_page.dart';
import 'package:teller_trust/view/the_app_screens/send_page.dart';

import '../../bloc/app_bloc/app_bloc.dart';
import '../../domain/txn/txn_details_to_send_out.dart';
import '../../main.dart';
import '../../res/app_colors.dart';
import '../../utills/app_navigator.dart';
import '../../utills/app_utils.dart';
import '../../utills/custom_theme.dart';
import '../../utills/shared_preferences.dart';
import '../auth/sign_in_with_access_pin_and_biometrics.dart';
import '../sendBeneficary/pages/send_to_page.dart';
import 'bills_page.dart';
import 'card_page.dart';
import 'home_page.dart';
import 'more_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;
  List<Widget> landPageScreens = [];
  bool _connected = true;

  StreamSubscription<ConnectivityStatus>? _connectivitySubscription;
  bool isNotification = false;

  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        // OrderNotification orderNotification =
        //  OrderNotification.fromJson(message.data);
        setState(() {
          isNotification = true;
        });

        modalSheet.showMaterialModalBottomSheet(
          context: context,
          enableDrag: true,
          isDismissible: true,
          expand: false,
          builder: (context) => SingleChildScrollView(
            controller: modalSheet.ModalScrollController.of(context),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: AppUtils.deviceScreenSize(context).width,
                    height: 100,
                    color: AppColors.blue,
                  ),
                ],
              ),
            ),
          ),
        );
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  //channel.description,
                  color: Colors.blueAccent,
                  playSound: true,
                  icon: 'asset/images/logo.png',
                )));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppUtils().debuglog('A new MessageOpenedApp event was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        // OrderNotification orderNotification =
        // OrderNotification.fromJson(message.data);
        setState(() {
          isNotification = true;
          // cat_Slug = message.data['categorySlug'];
          // news_Id = message.data['news_id'];
        });

        //AppUtils().debuglog(orderNotification);
        setState(() {
          isNotification = true;
        });

        // modalSheet.showMaterialModalBottomSheet(
        //   context: context,
        //   enableDrag: true,
        //   isDismissible: true,
        //   expand: false,
        //   builder: (context) => SingleChildScrollView(
        //     controller: modalSheet.ModalScrollController.of(context),
        //     child: Padding(
        //       padding: const EdgeInsets.all(0.0),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: <Widget>[
        //           Container(
        //             width: AppUtils.deviceScreenSize(context).width,
        //             height: 130,
        //             color: AppColors.blue,
        //             child: const Padding(
        //               padding: EdgeInsets.all(15.0),
        //               child: Padding(
        //                 padding: EdgeInsets.all(0),
        //               ),
        //             ),
        //           ),
        //           const Padding(
        //             padding: EdgeInsets.all(15.0),
        //             child: Row(
        //               children: [
        //                 Icon(
        //                   Icons.home,
        //                   color: AppColors.green,
        //                 ),
        //                 CustomText(
        //                   text: "Home Delivery",
        //                   weight: FontWeight.bold,
        //                 )
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // );
      }
    });
    context.read<AppBloc>().add(InitialEvent());
    context.read<ProductBloc>().add(ListCategoryEvent("1", "8"));

    _checkConnectivity();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_handleConnectivity);

    landPageScreens = [
       HomePage(onPageChanged: _onPageChanged),
      SendToPage(),
      const BillsPage(),
      const CardPage(),
      const MorePage()
    ];
    super.initState();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _handleConnectivity(connectivityResult);
  }

  void _handleConnectivity(ConnectivityStatus result) {
    if (result == ConnectivityStatus.none) {
      debugPrint("No network");
      setState(() {
        _connected = false;
      });
    } else {
      debugPrint("Network connected");
      setState(() {
        _connected = true;
      });
    }
  }
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return _connected
        ? IdleDetector(
            idleTime: const Duration(minutes: 20),
            onIdle: () async {
              String firstame = await SharedPref.getString('firstName');

              AppNavigator.pushAndRemovePreviousPages(context,
                  page: SignInWIthAccessPinBiometrics(
                    userName: firstame,
                  ));
              // Perform actions when the user becomes idle
            },
            child: Scaffold(
              backgroundColor: theme.isDark
                  ? AppColors.darkModeBackgroundColor
                  : AppColors.lightShadowGreenColor,

              body: IndexedStack(
                children: [
                  landPageScreens[_currentIndex],
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: AppColors.white,
                showUnselectedLabels: true,
                currentIndex: _currentIndex,
                selectedItemColor: AppColors.green,
                unselectedItemColor: theme.isDark
                    ? AppColors.lightPrimary
                    : AppColors.lightDivider,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AppIcons.home,
                      color: _currentIndex == 0
                          ? AppColors.green
                          : theme.isDark
                              ? AppColors.lightPrimary
                              : AppColors.lightgrey,
                    ), //Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(AppIcons.send,
                        color: _currentIndex == 1
                            ? AppColors.green
                            : theme.isDark
                                ? AppColors.lightPrimary
                                : AppColors.lightgrey),
                    label: 'Send',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AppIcons.bill,
                      color: _currentIndex == 2
                          ? AppColors.green
                          : theme.isDark
                              ? AppColors.lightPrimary
                              : AppColors.lightgrey,
                    ), //Icon(Icons.home),
                    label: 'Bills',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AppIcons.card,
                      color: _currentIndex == 3
                          ? AppColors.green
                          : theme.isDark
                              ? AppColors.lightPrimary
                              : AppColors.lightgrey,
                    ), //Icon(Icons.home),
                    label: 'Card',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AppIcons.more,
                      color: _currentIndex == 4
                          ? AppColors.green
                          : theme.isDark
                              ? AppColors.lightPrimary
                              : AppColors.lightgrey,
                    ), //Icon(Icons.home),
                    label: 'More',
                  ),
                ],
              ),
              // Stack(
              //   //   index: selectedIndex,
              //   children: <Widget>[
              //     _buildOffstageNavigator('Home'),
              //     _buildOffstageNavigator('History'),
              //     _buildOffstageNavigator('Account'),
              //   ],
              // ),
              // bottomNavigationBar: BottomNavigationBar(
              //   showSelectedLabels: true,
              //   type: BottomNavigationBarType.fixed,
              //   showUnselectedLabels: true,
              //   items: const <BottomNavigationBarItem>[
              //     BottomNavigationBarItem(
              //       icon: Icon(
              //         Icons.home_outlined,
              //         //color: Colors.grey,
              //       ),
              //       label: 'Home',
              //     ),
              //     BottomNavigationBarItem(
              //       icon: Icon(
              //         Icons.history,
              //         //color: Colors.grey,
              //       ),
              //       label: 'History',
              //     ),
              //     BottomNavigationBarItem(
              //       icon: Icon(
              //         Icons.person_2_outlined,
              //         //color: Colors.grey,
              //       ),
              //       label: 'Account',
              //     ),
              //   ],
              //   currentIndex: currentIndex,
              //   unselectedItemColor: Colors.grey,
              //   selectedIconTheme: const IconThemeData(color: AppColors.green),
              //   selectedItemColor: AppColors.green,
              //   onTap: (int index) {
              //     _onItemTapped(pageyKeys[index], index);
              //   },
              // )),
            ),
          )
        : No_internet_Page(onRetry: _checkConnectivity);
  }
}
