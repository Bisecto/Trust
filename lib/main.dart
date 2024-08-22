import 'dart:async';
import 'dart:convert';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/bloc/product_bloc/product_bloc.dart';
import 'package:teller_trust/model/transactionHistory.dart';
import 'package:teller_trust/res/app_router.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/utills/custom_theme.dart';
import 'package:teller_trust/view/important_pages/no_internet.dart';
import 'package:teller_trust/view/networkCenter/pages/network_center_main_page.dart';
import 'package:teller_trust/view/sendBeneficary/pages/send_main_page.dart';
import 'package:teller_trust/view/splash_screen.dart';
import 'package:teller_trust/view/widgets/transaction_receipt.dart';
import 'bloc/app_bloc/app_bloc.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'id', 'name',
    importance: Importance.high, playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _FirebaseMessagingBacground(RemoteMessage message) async {
  AppUtils().debuglog('A message just Poped: ${message.data}');
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  AdaptiveThemeMode? adaptiveThemeMode =
      await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.light;
  try {
    AppUtils.crypt();
    // Use encrypter for encryption/decryption
  } catch (e) {
    print('Error: $e');
  }
  FirebaseMessaging.onBackgroundMessage(_FirebaseMessagingBacground);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Remove the call to Firebase.initializeApp() from here

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  NotificationSettings settings =
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    AppUtils().debuglog('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    AppUtils().debuglog('User granted provisional permission');
  } else {
    AppUtils().debuglog('User declined or has not accepted permission');
  }
  FirebaseMessaging.instance.subscribeToTopic("TellaTrust");
  //await FirebaseMessaging.instance.deleteToken();

  // var token= FirebaseMessaging.instance.getToken();
  // print( await token);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (context) => AppBloc(),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(),
        ),
        ChangeNotifierProvider<CustomThemeState>(
          create: (_) => CustomThemeState(adaptiveThemeMode),
        ),
      ],
      child: MyApp(
        adaptiveThemeMode: adaptiveThemeMode,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? adaptiveThemeMode;

  const MyApp({Key? key, required this.adaptiveThemeMode}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRoutes = AppRouter();
  bool _connected = true;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  final double defaultTextScaleFactor = 1.0;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_handleConnectivity);
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _handleConnectivity(connectivityResult);
  }

  void _handleConnectivity(ConnectivityResult result) {
    setState(() {
      _connected = result != ConnectivityResult.none;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          widget.adaptiveThemeMode!.isDark ? Brightness.light : Brightness.dark,
    ));

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.green,
          fontFamily: "CeraPro",
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.green,
          fontFamily: "CeraPro",
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        initial: widget.adaptiveThemeMode!,
        builder: (theme, darkTheme) => MaterialApp(
          title: 'TellaTrust',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: _appRoutes.onGenerateRoute,
          theme: theme,
          darkTheme: darkTheme,
          // home: TransactionReceipt(
          //     transaction: Transaction.fromJson(json.decode(jsonEncode({
          //   "id": "99603552-e705-4186-9ab0-474936d78814",
          //   "amount": 100,
          //   "description": "MTN Airtime",
          //   "type": "debit",
          //   "reference": "11134b627f574e64a34178f9ff917eaa",
          //   "status": "success",
          //   "createdAt": "2024-08-05T03:56:21.715Z",
          //   "order": {
          //     "id": "e737cdc1-72a4-4ec7-bbe9-5eb091167041",
          //     "status": "complete",
          //     "providerOrderId": "11134b627f574e64a34178f9ff917eaa",
          //     "requiredFields": {
          //       "phoneNumber": "08100204570",
          //       "amount": 100,
          //       "cardNumber": null,
          //       "meterNumber": null
          //     },
          //     "response": {
          //       "clientId": "66158f7a13bea00024201371",
          //       "serviceCategoryId": "61efacbcda92348f9dde5f92",
          //       "reference": "11134b627f574e64a34178f9ff917eaa",
          //       "status": "successful",
          //       "amount": 100,
          //       "id": "66b04d68591dfb1faea0246c"
          //     },
          //     "product": {
          //       "image":
          //           "https://tellatrust-assets.s3.eu-west-2.amazonaws.com/product/items/660bbd40-35c5-42c7-83b6-63f55e179e7d.png",
          //       "id": "660bbd40-35c5-42c7-83b6-63f55e179e7d",
          //       "name": "MTN Airtime",
          //       "description": "MTN Airtime"
          //     }
          //   }
          // })))),
          home: _connected
              ? const SplashScreen()
              : No_internet_Page(onRetry: _checkConnectivity),
        ),
      ),
    );
  }
}
