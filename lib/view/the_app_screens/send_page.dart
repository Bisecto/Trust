import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../res/app_colors.dart';
import '../../utills/custom_theme.dart';

class SendPage extends StatelessWidget {
  const SendPage({super.key});

  @override
  Widget build(BuildContext context) {
      final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

      return Scaffold(
        backgroundColor:
        theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
      );
  }
}
