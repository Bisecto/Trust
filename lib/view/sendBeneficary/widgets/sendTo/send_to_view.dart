import 'package:flutter/material.dart';
import 'package:teller_trust/domain/txn/txn_details_to_send_out.dart';
import 'package:teller_trust/res/app_button.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/bg_logo_display_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/send_to_form_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/send_to_header_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/send_to_options_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/top_beneficiaries_widget.dart';

class SendToView extends StatefulWidget {
  final TxnDetailsToSendOut txnDetails;
  const SendToView({
    super.key,
    required this.txnDetails,
  });

  @override
  State<SendToView> createState() => _SendToViewState();
}

class _SendToViewState extends State<SendToView> {
  late TxnDetailsToSendOut txnDetails;
  TextEditingController accountNumberController = TextEditingController();

  bool isItForTellaTrust = false;

  String transferredTo = 'Favour Sophia Okpara';

  @override
  void initState() {
    txnDetails = widget.txnDetails;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomViewInset = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      body: BgLogoDisplayWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SendToHeaderWidget(
              amountTransferred: txnDetails.amount,
              txnMadeTo: transferredTo,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(
                  10.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TopBeneficiariesWidget(
                        beneficiaries: [],
                      ),
                      const AppSpacer(
                        height: 10,
                      ),
                      const SendToOptionsWidget(),
                      const AppSpacer(
                        height: 15.0,
                      ),
                      SendToFormWidget(
                        isItForTellaTrust: isItForTellaTrust,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (bottomViewInset == 0)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: AppButton(
                  buttonBoxDecoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(
                        10.0,
                      )),
                  buttonHeight: 50.0,
                  buttonChild: const Text(
                    'Tap to Send',
                    style: TextStyle(
                      color: AppColors.white,
                    ),
                  ),
                  buttonWidth: double.infinity,
                  buttonCallback: () {},
                ),
              ),
          ],
        ),
      ),
    );
  }
}
