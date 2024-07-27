import 'package:flutter/material.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendMain/send_main_view.dart';

class SendMainPage extends StatelessWidget {
  const SendMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      top: false,
      bottom: false,
      left: false,
      right: false,
      child: SendMainView(),
    );
  }
}
