import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/domain/txn/txn_details_to_send_out.dart';
import 'package:teller_trust/res/app_button.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/view/sendBeneficary/pages/send_to_page.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendMain/custom_key_pad_widget.dart';

class SendMainFormWidget extends StatefulWidget {
  const SendMainFormWidget({super.key});

  @override
  State<SendMainFormWidget> createState() => _SendMainFormWidgetState();
}

class _SendMainFormWidgetState extends State<SendMainFormWidget> {
  List keyPadValues = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['.', '0', 'assets/icons/sendBeneficiary/backBtnKeyPad.svg'],
  ];

  String mainValue = '0';
  String fractionValue = '00';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
                color: AppColors.nairaContainerColor.withOpacity(0.3),
              ),
              child: Center(
                child:
                    SvgPicture.asset('assets/icons/sendBeneficiary/naria.svg'),
              ),
            ),
            const AppSpacer(
              width: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$mainValue.',
                  style: const TextStyle(
                    fontSize: 28.0,
                    color: AppColors.amountMainValueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const AppSpacer(
                  width: 1.5,
                ),
                Text(
                  fractionValue,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: AppColors.amountFractionValueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const AppSpacer(
          height: 30.0,
        ),
        const Divider(),
        const AppSpacer(
          height: 20.0,
        ),
        const Align(
          alignment: AlignmentDirectional.topCenter,
          child: Text(
            'Enter Amount with keypad',
            style: TextStyle(
              fontSize: 15.0,
              color: AppColors.sendBodyTextColor,
            ),
          ),
        ),
        const AppSpacer(
          height: 30.0,
        ),
        ListView.builder(
          itemCount: keyPadValues.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            List rowKeyPads = keyPadValues[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...List.generate(
                      rowKeyPads.length,
                      (keyIndex) {
                        String key = rowKeyPads[keyIndex];
                        return CustomKeyPadWidget(
                          keyPadValue: key,
                          isKeyPadValueIcon:
                              (keyPadValues.last == rowKeyPads) &&
                                  (rowKeyPads.last == key),
                        );
                      },
                    ),
                  ],
                ),
                const AppSpacer(
                  height: 20.0,
                ),
              ],
            );
          },
        ),
        const AppSpacer(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: AppButton(
            buttonBoxDecoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(
                20.0,
              ),
            ),
            buttonCallback: () {
              AppNavigator.pushAndStackPage(
                context,
                page: SendToPage(
                  txnDetails: TxnDetailsToSendOut(
                    amount: '$mainValue.$fractionValue',
                  ),
                ),
              );
            },
            buttonChild: const Text(
              'Continue',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16.0,
              ),
            ),
            buttonHeight: 60,
            buttonWidth: double.infinity,
          ),
        )
      ],
    );
  }
}
