import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teller_trust/bloc/product_bloc/product_bloc.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_router.dart';
import 'package:teller_trust/res/app_strings.dart';

import 'bloc/app_bloc/app_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (context) => AppBloc(),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(),
        ),
        // Add more BlocProviders as needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _appRoutes = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.green),
        useMaterial3: true,
      ),
      onGenerateRoute: _appRoutes.onGenerateRoute,
    );
  }
}
