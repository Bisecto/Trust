import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/bloc/sendBloc/event/send_event.dart';
import 'package:teller_trust/bloc/sendBloc/send_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/states/send_state.dart';
import 'package:teller_trust/domain/txn/txn_details_to_send_out.dart';
import 'package:teller_trust/res/app_button.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/view/sendBeneficary/pages/send_to_page.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendMain/custom_key_pad_widget.dart';

class SendMainFormWidget extends StatefulWidget {
  String balance;

  SendMainFormWidget({super.key, required this.balance});

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
  String fractionValue = '.00';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendBloc, SendState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is CurrentAmountEntered) {
          mainValue = state.mainValue;
          fractionValue = state.fractionValue;
        }
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
                    child: SvgPicture.asset(
                      'assets/icons/sendBeneficiary/naria.svg',
                    ),
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
                      mainValue,
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
                              keyPadCallback: () {
                                if (!((keyPadValues.last == rowKeyPads) &&
                                    (rowKeyPads.last == key))) {
                                  BlocProvider.of<SendBloc>(context).add(
                                    EnterAmountToSend(
                                      isItForMainValue:
                                          !((keyPadValues.last == rowKeyPads) &&
                                              (rowKeyPads.first == key)),
                                      value: key,
                                    ),
                                  );
                                } else {
                                  BlocProvider.of<SendBloc>(context).add(
                                    const BackSpaceLastEnteredAmountToSend(),
                                  );
                                }
                              },
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
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: AppButton(
                buttonBoxDecoration: BoxDecoration(
                  color: (widget.balance == '0.00' ||
                          (double.parse(widget.balance.replaceAll(',', '')) <
                              double.parse((mainValue + fractionValue)
                                  .replaceAll(',', ''))))
                      ? AppColors.grey
                      : AppColors.green,
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
                buttonCallback: () {
                  if (widget.balance != '0.00') {
                    print(widget.balance);
                    print(mainValue);
                    print(fractionValue);
                    if (double.parse(widget.balance.replaceAll(',', '')) <
                        double.parse(
                            (mainValue + fractionValue).replaceAll(',', ''))) {
                      //print('SPmething');
                    } else {
                      AppNavigator.pushAndStackPage(
                        context,
                        page: SendToPage(
                          txnDetails: TxnDetailsToSendOut(
                            amount: '$mainValue$fractionValue',
                          ),
                        ),
                      );
                    }
                  }
                },
                buttonChild: const Text(
                  'Continue',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16.0,
                  ),
                ),
                buttonHeight: 50,
                buttonWidth: double.infinity,
              ),
            )
          ],
        );
      },
    );
  }
}
