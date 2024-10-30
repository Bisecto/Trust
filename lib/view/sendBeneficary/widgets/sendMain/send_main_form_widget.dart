import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/bloc/sendBloc/event/send_event.dart';
import 'package:teller_trust/bloc/sendBloc/send_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/states/send_state.dart';
import 'package:teller_trust/res/app_button.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendMain/custom_key_pad_widget.dart';

import '../../../../utills/custom_theme.dart';
import '../../../widgets/app_custom_text.dart';

class SendMainFormWidget extends StatefulWidget {
  String balance;
  String previousAmtInputed;

  SendMainFormWidget(
      {super.key, required this.balance, required this.previousAmtInputed});

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

  String currentAmount = '';

  @override
  void initState() {
    super.initState();
    currentAmount = widget.previousAmtInputed;
    BlocProvider.of<SendBloc>(context).add(
      EnterAmountToSend(value: currentAmount),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
      child: BlocConsumer<SendBloc, SendState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CurrentAmountEntered) {
            currentAmount =
                state.mainValue; // Use mainValue to hold the full amount
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: AppColors.nairaContainerColor.withOpacity(0.3),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/sendBeneficiary/naria.svg',
                        ),
                      ),
                    ),
                    const AppSpacer(width: 10.0),
                    Text(
                      currentAmount.isNotEmpty ? currentAmount : '0.00',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: theme.isDark
                            ? AppColors.darkModeBackgroundMainTextColor
                            : AppColors.amountMainValueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (widget.balance == '0.0' ||
                    (currentAmount.isNotEmpty &&
                        double.tryParse(currentAmount.replaceAll(',', '')) !=
                            null &&
                        double.parse(currentAmount.replaceAll(',', '')) >
                            double.parse(widget.balance.replaceAll(',', ''))))
                  if (currentAmount != '0') ...[
                    const AppSpacer(height: 10.0),
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: CustomText(
                        text:
                            'The amount you entered exceeds the maximum allowed limit.'
                            ' Please enter an amount less than '
                            'or equal to ${widget.balance}',
                        weight: FontWeight.bold,
                        size: 14,
                        color: AppColors.orange,
                        maxLines: 4,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                const AppSpacer(height: 0.0),
                const Divider(),
                const AppSpacer(height: 20.0),
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Text(
                    'Enter Amount with keypad',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: theme.isDark
                          ? AppColors.darkModeBackgroundMainTextColor
                          : AppColors.sendBodyTextColor,
                    ),
                  ),
                ),
                const AppSpacer(height: 30.0),
                ListView.builder(
                  itemCount: keyPadValues.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    List rowKeyPads = keyPadValues[index];
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ...List.generate(rowKeyPads.length, (keyIndex) {
                              String key = rowKeyPads[keyIndex];

                              bool isDecimalDisabled =
                                  key == '.' && currentAmount.contains('.');

                              return CustomKeyPadWidget(
                                keyPadValue: key,
                                isKeyPadValueIcon:
                                    (keyPadValues.last == rowKeyPads) &&
                                        (rowKeyPads.last == key),
                                keyPadCallback: () {
                                  if (!isDecimalDisabled) {
                                    if (!((keyPadValues.last == rowKeyPads) &&
                                        (rowKeyPads.last == key))) {
                                      setState(() {
                                        currentAmount += key;
                                      });
                                      BlocProvider.of<SendBloc>(context).add(
                                        EnterAmountToSend(value: currentAmount),
                                      );
                                    } else {
                                      if (currentAmount.isNotEmpty) {
                                        setState(() {
                                          currentAmount =
                                              currentAmount.substring(
                                                  0, currentAmount.length - 1);
                                        });
                                        BlocProvider.of<SendBloc>(context).add(
                                          EnterAmountToSend(
                                              value: currentAmount),
                                        );
                                      }
                                    }
                                  }
                                },
                                isDisabled: isDecimalDisabled,
                              );
                            }),
                          ],
                        ),
                        const AppSpacer(height: 20.0),
                      ],
                    );
                  },
                ),
                const AppSpacer(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: AppButton(
                    buttonBoxDecoration: BoxDecoration(
                      color: (currentAmount.isEmpty ||
                              double.tryParse(
                                      currentAmount.replaceAll(',', '')) ==
                                  null ||
                              double.parse(currentAmount.replaceAll(',', '')) >
                                  double.parse(
                                      widget.balance.replaceAll(',', '')))
                          ? AppColors.grey
                          : AppColors.green,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    buttonCallback: () {
                      if (currentAmount.isNotEmpty &&
                          double.tryParse(currentAmount.replaceAll(',', '')) !=
                              null) {
                        if (double.parse(currentAmount.replaceAll(',', '')) >
                            double.parse(widget.balance.replaceAll(',', ''))) {
                          // Handle case where the amount exceeds the balance
                        } else {
                          Navigator.pop(context, currentAmount);
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
