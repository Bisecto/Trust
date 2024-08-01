import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utills/custom_theme.dart';

class BgLogoDisplayWidget extends StatelessWidget {
  final Widget child;
  const BgLogoDisplayWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Container(
      height: size.height,
      width: size.width,
      decoration:  BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            theme.isDark?
            'assets/images/tellaTrust.png'
            :'assets/images/tellaTrustLightMode.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
