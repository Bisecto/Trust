import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/bloc/product_bloc/product_bloc.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_router.dart';
import 'package:teller_trust/res/app_strings.dart';
import 'package:teller_trust/utills/custom_theme.dart';
import 'package:teller_trust/view/splash_screen.dart';

import 'bloc/app_bloc/app_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AdaptiveThemeMode? adaptiveThemeMode=await AdaptiveTheme.getThemeMode()??AdaptiveThemeMode.light;
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
        adaptiveThemeMode:adaptiveThemeMode,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  AdaptiveThemeMode? adaptiveThemeMode;

  MyApp({super.key, required this.adaptiveThemeMode});

  final AppRouter _appRoutes = AppRouter();

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        fontFamily: "CeraPro",
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        fontFamily: "CeraPro",
      ),
      initial: adaptiveThemeMode!,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Tellatrust',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: _appRoutes.onGenerateRoute,
        theme: theme,
        darkTheme: darkTheme,
        home: const SplashScreen(),

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
