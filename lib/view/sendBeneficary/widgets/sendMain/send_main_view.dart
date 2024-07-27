import 'package:flutter/material.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendMain/send_main_form_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendMain/send_main_header_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/send_beneficiary_app_logo_body_widget.dart';

class SendMainView extends StatefulWidget {
  const SendMainView({super.key});

  @override
  State<SendMainView> createState() => _SendMainViewState();
}

class _SendMainViewState extends State<SendMainView> {
  String balance = '192,600.00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SendBeneficiaryAppLogoBodyWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SendMainHeaderWidget(
              balance: balance,
            ),
            const AppSpacer(
              height: 30.0,
            ),
            const Expanded(
              child: SendMainFormWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
