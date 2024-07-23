import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/bloc/product_bloc/product_bloc.dart';
import 'package:teller_trust/res/app_router.dart';
import 'package:teller_trust/utills/custom_theme.dart';
import 'package:teller_trust/view/important_pages/no_internet.dart';
import 'package:teller_trust/view/networkCenter/pages/network_center_main_page.dart';
import 'package:teller_trust/view/splash_screen.dart';
import 'bloc/app_bloc/app_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AdaptiveThemeMode? adaptiveThemeMode =
      await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.light;

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
          title: 'Tellatrust',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: _appRoutes.onGenerateRoute,
          theme: theme,
          darkTheme: darkTheme,
          // home: const NetworkCenterMainPage(),
          home: _connected
              ? const SplashScreen()
              : No_internet_Page(onRetry: _checkConnectivity),
        ),
      ),
    );
  }
}
