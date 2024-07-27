import 'package:flutter/material.dart';

class BgLogoDisplayWidget extends StatelessWidget {
  final Widget child;
  const BgLogoDisplayWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/tellaTrust.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
