import 'package:flutter/material.dart';

import '../../auth/sign_in_with_access_pin_and_biometrics.dart';
import 'package:custom_pin_screen/custom_pin_screen.dart';

class SendFunds extends StatefulWidget {
  const SendFunds({super.key});

  @override
  State<SendFunds> createState() => _SendFundsState();
}

class _SendFundsState extends State<SendFunds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 35.0,
              vertical: 35.0,
            ),
            child: Text(
              "How much do you want to fund your wallet with",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
