// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/bloc/sendBloc/event/send_event.dart';
import 'package:teller_trust/bloc/sendBloc/send_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/states/send_state.dart';
import 'package:teller_trust/model/bank_model.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/utills/constants/general_constant.dart';
import 'package:teller_trust/utills/enums/toast_mesage.dart';
import 'package:teller_trust/view/auth/otp_pin_pages/confirm_with_otp.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/bankModal/bank_view_widget.dart';
import 'package:teller_trust/view/widgets/show_toast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal_sheet;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

class SendToFormWidget extends StatefulWidget {
  final bool isItForTellaTrust;
  final bool isReceiptentSelectedForTellaTrustTxn;
  const SendToFormWidget({
    super.key,
    required this.isItForTellaTrust,
    required this.isReceiptentSelectedForTellaTrustTxn,
  });

  @override
  State<SendToFormWidget> createState() => _SendToFormWidgetState();
}

class _SendToFormWidgetState extends State<SendToFormWidget> {
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();

  bool isItForTellaTrust = false;

  bool receipentDetailsGiven = false;

  bool isReceiptentSelectedForTellaTrustTxn = false;

  bool checkingUpTellaTrustUser = false;
  bool verifyingUserAccountNumber = false;

  late Bank selectedBank;
  List<Bank> banks = [];

  bool isUserVerified = false;

  bool isAnyOptionsSelected = false;

  String verifiedUser = '';

  @override
  void initState() {
    isItForTellaTrust = widget.isItForTellaTrust;
    isReceiptentSelectedForTellaTrustTxn =
        widget.isReceiptentSelectedForTellaTrustTxn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendBloc, SendState>(
      listener: (context, state) async {
        if (state is TellaTrustCustomerVerification) {
          setState(() {
            checkingUpTellaTrustUser = state.requestInProgress;
            isUserVerified = state.tellaTrustCustomerReceived;
            isReceiptentSelectedForTellaTrustTxn =
                state.tellaTrustCustomerReceived;
            if (isUserVerified) {
              verifiedUser =
                  '${state.tellaTrustCustomerModel!.firstName} ${state.tellaTrustCustomerModel!.lastName}';
            }
            debugPrint('this is the user verified account $verifiedUser');
          });
        }
        if (state is VerificationStateForBankAccountNumber) {
          setState(() {
            verifyingUserAccountNumber = state.isRequestInProgress;
            isUserVerified = state.isDataReadyForUse;
            if (isUserVerified) {
              verifiedUser = state.bankVerifiedAccount!.accountName;
            }
          });
        }
        if (state is BanksToTxnWith) {
          setState(() {
            banks = state.banks;
            selectedBank = banks.isNotEmpty
                ? banks.first
                : Bank(
                    bankCode: '',
                    bankName: '',
                    bankType: '',
                  );
          });
        }

        if (state is TellaTrustCustomerVerification) {
          if (!state.requestInProgress) {
            if (!state.tellaTrustCustomerReceived) {
              showToast(
                context: context,
                title:
                    state.tellaTrustCustomerReceived ? 'Successful' : 'Error',
                subtitle: state.message,
                type: state.tellaTrustCustomerReceived
                    ? ToastMessageType.success
                    : ToastMessageType.error,
              );
            }
          }
        }

        if (state is VerificationStateForBankAccountNumber) {
          if (!state.isRequestInProgress) {
            if (!state.isDataReadyForUse) {
              showToast(
                context: context,
                title: state.isDataReadyForUse ? 'Successful' : 'Error',
                subtitle: state.statusMessage,
                type: state.isDataReadyForUse
                    ? ToastMessageType.success
                    : ToastMessageType.error,
              );
            }
          }
        }

        if (state is SelectedTxnOption) {
          isAnyOptionsSelected = state.toggleOn;
        }
      },
      builder: (context, state) {
        if (state is SelectedTxnOption) {
          isItForTellaTrust = state.isItForTellaTrust;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isItForTellaTrust && isAnyOptionsSelected)
              SizedBox(
                height: 45.0,
                child: InkWell(
                  onTap: !isAnyOptionsSelected
                      ? null
                      : () async {
                  selectedBank=await  modalSheet.showMaterialModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.0)),
                      ),
                      context: context,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: BankViewWidget(
                          banks: banks,
                        ),
                      ),
                    ).then((value) {
                    if (value != null) {
                      setState(() {
                        selectedBank = value;
                        bankNameController.text = selectedBank.bankName;
                      });
                    }
                    return value ?? '';
                  });
                          // selectedBank = await showDialog(
                          //   context: context,
                          //   builder: (context) {
                          //     return BankViewWidget(
                          //       banks: banks,
                          //     );
                          //   },
                          // ).then((value) {
                          //   if (value != null) {
                          //     setState(() {
                          //       selectedBank = value;
                          //       bankNameController.text = selectedBank.bankName;
                          //     });
                          //   }
                          //   return value ?? '';
                          // });
                        },
                  child: TextField(
                    controller: bankNameController,
                    textInputAction: TextInputAction.search,
                    enabled: false,
                    cursorColor: AppColors.sendToBankBgColor,
                    style: GeneralConstant.sendToDefaultTextStyle,
                    decoration: InputDecoration(
                      hintText: '',
                      hintStyle: GeneralConstant.normalTextStyle,

                      suffixIcon: const Padding(
                        padding: EdgeInsets.only(
                          right: 15.0,
                        ),
                        child: Icon(Icons.keyboard_arrow_down),
                      ),
                      contentPadding:
                          GeneralConstant.sendToFormWidgetContentPadding,
                      border: GeneralConstant.bankSendSearchBorder,
                      errorBorder: GeneralConstant.bankSendSearchErrorBorder,
                      disabledBorder: GeneralConstant.bankSendSearchBorder,
                      enabledBorder: GeneralConstant.bankSendSearchBorder,
                      focusedBorder: GeneralConstant.bankSendSearchBorder,
                    ),
                    onChanged: (value) {},
                  ),
                ),
              ),
            if (!isItForTellaTrust)
              const AppSpacer(
                height: 10.0,
              ),
            isUserVerified && isItForTellaTrust
                ? Container()
                : isItForTellaTrust
                    ? accountNumberFieldWidget(context)
                    : bankNameController.text.isNotEmpty
                        ? accountNumberFieldWidget(context)
                        : Container(),
            if (isUserVerified && !isItForTellaTrust)
              displayVerifiedUser(
                verifiedUser: verifiedUser,
              ),
            if (!isItForTellaTrust && receipentDetailsGiven) Container(),
            const AppSpacer(
              height: 10.0,
            ),
            isItForTellaTrust
                ? isReceiptentSelectedForTellaTrustTxn
                    ? txnDescription()
                    : Container()
                : isUserVerified
                    ? txnDescription()
                    : Container(),
          ],
        );
      },
    );
  }

  SizedBox accountNumberFieldWidget(BuildContext context) {
    return SizedBox(
      height: 45.0,
      child: TextField(
        controller: accountNumberController,
        enabled: isUserVerified
            ? false
            : isItForTellaTrust
                ? !checkingUpTellaTrustUser
                : !verifyingUserAccountNumber,
        textInputAction: TextInputAction.done,
        cursorColor: isItForTellaTrust
            ? AppColors.sendToTellaColor
            : AppColors.sendToBankBgColor,
        style: GeneralConstant.sendToDefaultTextStyle,
        decoration: InputDecoration(
          hintText: isItForTellaTrust
              ? 'enter @tellaid or phone number here'
              : 'Account number here',
          hintStyle: GeneralConstant.normalTextStyle,
          prefixIcon: isItForTellaTrust
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 5.0,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/sendBeneficiary/tellaTrustGrey.svg',
                  ),
                )
              : null,
          // suffixIcon:
          //     checkingUpTellaTrustUser || verifyingUserAccountNumber
          //         ? const Padding(
          //             padding: EdgeInsets.only(
          //               right: 20.0,
          //             ),
          //             child: AppRequestLoaderWidget(
          //               checkPlatform: true,
          //               size: 20,
          //               alignWidgetTo: AlignmentDirectional.centerEnd,
          //             ),
          //           )
          //         : null,
          contentPadding: GeneralConstant.sendToFormWidgetContentPadding,
          border: isItForTellaTrust
              ? GeneralConstant.tellaSendSearchBorder
              : GeneralConstant.bankSendSearchBorder,
          errorBorder: isItForTellaTrust
              ? GeneralConstant.tellaSendSearchErrorBorder
              : GeneralConstant.bankSendSearchErrorBorder,
          disabledBorder: isItForTellaTrust
              ? GeneralConstant.tellaSendSearchBorder
              : GeneralConstant.bankSendSearchBorder,
          enabledBorder: isItForTellaTrust
              ? GeneralConstant.tellaSendSearchBorder
              : GeneralConstant.bankSendSearchBorder,
          focusedBorder: isItForTellaTrust
              ? GeneralConstant.tellaSendSearchBorder
              : GeneralConstant.bankSendSearchBorder,
        ),
        onSubmitted: (value) async {
          if (isItForTellaTrust) {
            BlocProvider.of<SendBloc>(context).add(
              EnterTellaTrustReceipentAcc(
                tellaTrustReceiptentAcc: value,
              ),
            );
          } else {
            String transactionPin =
                await modal_sheet.showMaterialModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isDismissible: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0)),
                      ),
                      context: context,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.only(top: 200.0),
                        child: ConfirmWithPin(
                          context: context,
                          title: 'Input your transaction pin to continue',
                        ),
                      ),
                    ) ??
                    '';
            if (transactionPin != '') {
              BlocProvider.of<SendBloc>(context).add(
                VerifyRecepitentAccountNumber(
                  accountNumber: value,
                  bankCode: selectedBank.bankCode,
                  transactionPin: transactionPin,
                ),
              );
            }
          }
        },
      ),
    );
  }

  SizedBox txnDescription() {
    return SizedBox(
      height: 45.0,
      child: TextField(
        controller: descriptionController,
        textInputAction: TextInputAction.done,
        cursorColor: isItForTellaTrust
            ? AppColors.sendToTellaColor
            : AppColors.sendToBankBgColor,
        style: GeneralConstant.sendToDefaultTextStyle,
        decoration: InputDecoration(
          hintText: 'Add a description here',
          hintStyle: GeneralConstant.normalTextStyle,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 5.0,
            ),
            child: SvgPicture.asset(
              'assets/icons/sendBeneficiary/sendToVerified.svg',
            ),
          ),
          contentPadding: GeneralConstant.sendToFormWidgetContentPadding,
          border: isItForTellaTrust
              ? GeneralConstant.tellaSendSearchBorder
              : GeneralConstant.bankSendSearchBorder,
          errorBorder: isItForTellaTrust
              ? GeneralConstant.tellaSendSearchErrorBorder
              : GeneralConstant.bankSendSearchErrorBorder,
          disabledBorder: isItForTellaTrust
              ? GeneralConstant.tellaSendSearchBorder
              : GeneralConstant.bankSendSearchBorder,
          enabledBorder: isItForTellaTrust
              ? GeneralConstant.tellaSendSearchBorder
              : GeneralConstant.bankSendSearchBorder,
          focusedBorder: isItForTellaTrust
              ? GeneralConstant.tellaSendSearchBorder
              : GeneralConstant.bankSendSearchBorder,
        ),
        onChanged: (value) {
          BlocProvider.of<SendBloc>(context).add(
            UserNarationForPayment(
              narration: value,
            ),
          );
        },
      ),
    );
  }

  Container displayVerifiedUser({required String verifiedUser}) {
    return Container(
      alignment: AlignmentDirectional.topStart,
      width: 150,
      margin: const EdgeInsets.only(
        top: 10.0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 7.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.sendToBankBgColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(
          10.0,
        ),
        border: Border.all(
          color: AppColors.sendToBankBgColor,
        ),
      ),
      child: Center(
        child: Text(
          verifiedUser,
          style: const TextStyle(
            color: AppColors.sendBodyTextColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
