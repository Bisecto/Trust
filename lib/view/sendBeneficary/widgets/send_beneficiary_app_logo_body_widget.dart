import 'package:flutter/material.dart';

class SendBeneficiaryAppLogoBodyWidget extends StatelessWidget {
  final Widget child;
  const SendBeneficiaryAppLogoBodyWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 10.0,
        top: 20.0,
      ),
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
