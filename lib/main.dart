import 'dart:async';
import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/bloc/product_bloc/product_bloc.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_router.dart';
import 'package:teller_trust/res/app_strings.dart';
import 'package:teller_trust/utills/custom_theme.dart';
import 'package:teller_trust/view/important_pages/no_internet.dart';
import 'package:teller_trust/view/splash_screen.dart';

import 'bloc/app_bloc/app_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AdaptiveThemeMode? adaptiveThemeMode =
      await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.light;
  //final savedThemeMode = await AdaptiveTheme.getThemeMode();

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
          create: (_) => CustomThemeState(adaptiveThemeMode!),
        ),
        // Add more BlocProviders as needed
      ],
      child: MyApp(
        adaptiveThemeMode: adaptiveThemeMode,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  AdaptiveThemeMode? adaptiveThemeMode;

  MyApp({super.key, required this.adaptiveThemeMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRoutes = AppRouter();
  bool _connected = true;

  StreamSubscription<ConnectivityStatus>? _connectivitySubscription;

  @override
  void initState() {
    // TODO: implement initState
  _checkConnectivity();
  _connectivitySubscription =
      Connectivity().onConnectivityChanged.listen(_handleConnectivity);

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
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:widget.adaptiveThemeMode!.isDark? Brightness
          .light:Brightness.dark, // Brightness.light for white icons, Brightness.dark for dark icons
    ));
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        fontFamily: "CeraPro",
        appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
        )
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        fontFamily: "CeraPro",
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light,
          )
      ),

      initial: widget.adaptiveThemeMode!,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Tellatrust',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: _appRoutes.onGenerateRoute,
        theme: theme,
        darkTheme: darkTheme,
        home: _connected
            ? SplashScreen():No_internet_Page(onRetry: _checkConnectivity),


        //onGenerateInitialRoutes: _appRoutes.onGenerateRoute,
      ),
    );
    //   MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: AppStrings.appName,
    //   themeMode: ThemeMode.light,
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: AppColors.green),
    //     useMaterial3: true,
    //   ),
    //   onGenerateRoute: _appRoutes.onGenerateRoute,
    // );
  }
}
