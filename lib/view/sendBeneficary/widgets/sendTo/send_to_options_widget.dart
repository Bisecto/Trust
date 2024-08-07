import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/bloc/sendBloc/event/send_event.dart';
import 'package:teller_trust/bloc/sendBloc/send_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/states/send_state.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/options_item_widget.dart';

class SendToOptionsWidget extends StatefulWidget {
  const SendToOptionsWidget({super.key});

  @override
  State<SendToOptionsWidget> createState() => _SendToOptionsWidgetState();
}

class _SendToOptionsWidgetState extends State<SendToOptionsWidget> {
  bool tellaTrustSelected = false;

  bool toggleOptionsOn = false;

  bool allowActions = true;

  bool isUserVerified = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendBloc, SendState>(
      builder: (context, state) {
        if (state is SelectedTxnOption) {
          tellaTrustSelected = state.isItForTellaTrust;
          toggleOptionsOn = state.toggleOn;
        }

        if (state is TellaTrustCustomerVerification) {
          allowActions = !state.requestInProgress;
          isUserVerified = state.tellaTrustCustomerReceived;
        }
        if (state is VerificationStateForBankAccountNumber) {
          allowActions = !state.isRequestInProgress;
        }
        if (state is SendFundToInternalOrExternalRecepitent ||
            state is SendFundToInternalOrExternalRecepitent) {
          allowActions = !state.processingPayment;
        }
        return isUserVerified && tellaTrustSelected
            ? Container()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: OptionsItemWidget(
                          isItForTellaTrustTransferOption: true,
                          isOptionItemSelected:
                              toggleOptionsOn ? tellaTrustSelected : false,
                          selectedCallback: () {
                            if (allowActions) {
                              BlocProvider.of<SendBloc>(context).add(
                                SelectTxnOption(
                                  isTxnForTellaTrust: true,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const AppSpacer(
                        width: 15.0,
                      ),
                      Expanded(
                        child: OptionsItemWidget(
                          isItForTellaTrustTransferOption: false,
                          isOptionItemSelected:
                              toggleOptionsOn ? !tellaTrustSelected : false,
                          selectedCallback: () {
                            if (allowActions) {
                              BlocProvider.of<SendBloc>(context).add(
                                SelectTxnOption(
                                  isTxnForTellaTrust: false,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  if (!tellaTrustSelected && toggleOptionsOn)
                    const AppSpacer(
                      height: 15.0,
                    ),
                  if (!tellaTrustSelected && toggleOptionsOn)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Beneficiary',
                          style: TextStyle(
                            color: AppColors.sendBodyTextColor,
                            fontSize: 16.0,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                width: 90,
                                padding: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 1.0,
                                  top: 3.0,
                                  bottom: 5.0,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.sendToBankBgColor
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(
                                    12.0,
                                  ),
                                  border: Border.all(
                                    color: AppColors.sendToBankBgColor,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const FittedBox(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: AppColors.sendBodyTextColor,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                    const AppSpacer(
                                      width: 5.0,
                                    ),
                                    SvgPicture.asset(
                                      'assets/icons/sendBeneficiary/beneficiaryCancel.svg',
                                      height: 25.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              );
      },
    );
  }
}
