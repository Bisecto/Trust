// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/event/send_event.dart';
import 'package:teller_trust/bloc/sendBloc/send_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/states/send_state.dart';
import 'package:teller_trust/domain/txn/txn_details_to_send_out.dart';
import 'package:teller_trust/res/app_button.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/utills/constants/loading_dialog.dart';
import 'package:teller_trust/utills/enums/toast_mesage.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/bg_logo_display_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/send_to_form_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/send_to_header_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/send_to_options_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/top_beneficiaries_widget.dart';
import 'package:teller_trust/view/the_app_screens/transaction_history/transaction_history.dart';
import 'package:teller_trust/view/widgets/purchase_receipt.dart';
import 'package:teller_trust/view/widgets/show_toast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal_sheet;

import '../../../../utills/app_navigator.dart';
import '../../../auth/otp_pin_pages/confirm_with_otp.dart';

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
  bool isItForTellaTrust = false;

  bool userForTxnConfirmed = false;

  bool isUserVerified = false;

  bool processingPayment = false;

  bool verifyingUser = false;

  bool isReceiptentSelectedForTellaTrustTxn = false;

  String transferredToName = '';
  String transferredToImage = '';

  List listOfBeneficiaries = [];

  String receiverId = '';

  String narration = '';
  String verifiedAccountNumber = '';
  String verifiedBankCode = '';
  String txnSessionId = '';

  @override
  void initState() {
    txnDetails = widget.txnDetails;
    BlocProvider.of<SendBloc>(context).add(
      const LoadSendToDetailsInitialState(),
    );
    BlocProvider.of<SendBloc>(context).add(
      const LoadBanksToTxnWith(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomViewInset = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      body: BlocConsumer<SendBloc, SendState>(
        listener: (context, state) async {
          if (state is SelectedTxnOption) {
            setState(() {
              isItForTellaTrust = state.isItForTellaTrust;
            });
          }

          if (state is TellaTrustCustomerVerification) {
            setState(() {
              verifyingUser = state.requestInProgress;
              userForTxnConfirmed = state.tellaTrustCustomerReceived;
              transferredToName = userForTxnConfirmed
                  ? '${state.tellaTrustCustomerModel!.firstName} ${state.tellaTrustCustomerModel!.lastName}'
                  : '';
              isReceiptentSelectedForTellaTrustTxn =
                  state.tellaTrustCustomerReceived;
              receiverId =
                  userForTxnConfirmed ? state.tellaTrustCustomerModel!.id : '';
            });
          }
          if (state is VerificationStateForBankAccountNumber) {
            setState(() {
              verifyingUser = state.isRequestInProgress;
              isUserVerified = state.isDataReadyForUse;
              if (isUserVerified) {
                verifiedAccountNumber =
                    state.bankVerifiedAccount!.accountNumber;
                verifiedBankCode = state.bankVerifiedAccount!.bankCode;
                txnSessionId = state.bankVerifiedAccount!.sessionId;
              }
            });
          }

          if (state is SendFundToInternalOrExternalRecepitent) {
            if (!state.processingPayment) {
              if (state.isPaymentSuccessful) {

                AppNavigator.pushAndStackPage(context,
                    page: TransactionReceipt(transaction: state.transaction!));
              } else {
                showToast(
                  context: context,
                  title: state.isPaymentSuccessful ? 'Successful' : 'Error',
                  subtitle: state.statusMessage,
                  type: state.isPaymentSuccessful
                      ? ToastMessageType.success
                      : ToastMessageType.error,
                );
              }
              // await Future.delayed(
              //   const Duration(
              //     seconds: 10,
              //   ),
              // ).then((value) {
              //   print(123);
              //   Navigator.pop(context);
              // });
            }
          }

          if (state is PaymentNarration) {
            setState(() {
              narration = state.narration;
            });
          }
        },
        builder: (context, state) {
          if (state is ListOfBeneficiariesToSendTo) {
            listOfBeneficiaries = state.listOfBeneficiaries;
          }

          if (state is SendFundToInternalOrExternalRecepitent) {
            processingPayment = state.processingPayment;
          }

          return BgLogoDisplayWidget(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SendToHeaderWidget(
                      amountTransferred: txnDetails.amount,
                      txnMadeToName: transferredToName,
                      txnMadeToImage: transferredToImage,
                      isTellaTrustTxn: isItForTellaTrust,
                      userForTxnConfirmed: userForTxnConfirmed,
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
                              TopBeneficiariesWidget(
                                beneficiaries: listOfBeneficiaries,
                                isItForTellaTrust: isItForTellaTrust,
                                isUserVerified: userForTxnConfirmed,
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
                                isReceiptentSelectedForTellaTrustTxn:
                                    isReceiptentSelectedForTellaTrustTxn,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (bottomViewInset == 0)
                      if (isUserVerified || userForTxnConfirmed)
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AppButton(
                            buttonBoxDecoration: BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                            ),
                            buttonHeight: 50.0,
                            buttonChild: const Text(
                              'Tap to Send',
                              style: TextStyle(
                                color: AppColors.white,
                              ),
                            ),
                            buttonWidth: double.infinity,
                            buttonCallback: () async {
                              String transactionPin = await modal_sheet
                                      .showMaterialModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    isDismissible: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20.0)),
                                    ),
                                    context: context,
                                    builder: (context) => Padding(
                                      padding:
                                          const EdgeInsets.only(top: 200.0),
                                      child: ConfirmWithPin(
                                        context: context,
                                        title:
                                            'Input your transaction pin to continue',
                                      ),
                                    ),
                                  ) ??
                                  '';
                              print(transactionPin);
                              if (transactionPin != '') {
                                print(txnDetails.amount);
                                if (userForTxnConfirmed && isItForTellaTrust) {
                                  BlocProvider.of<SendBloc>(context).add(
                                    SendInternalFundToReceiptent(
                                      amount: double.parse(txnDetails.amount
                                          .replaceAll(',', '')),
                                      narration: narration,
                                      receiverId: receiverId,
                                      accessPin: transactionPin,
                                    ),
                                  );
                                } else {
                                  BlocProvider.of<SendBloc>(context).add(
                                    SendExternalFundToReceiptent(
                                      amount: double.parse(txnDetails.amount
                                          .replaceAll(',', '')),
                                      narration: narration,
                                      accountNumber: verifiedAccountNumber,
                                      bankCode: verifiedBankCode,
                                      sessionId: txnSessionId,
                                      txnId: transactionPin,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                  ],
                ),
                if (processingPayment || verifyingUser)
                  const LoadingDialog('Processing...'),
              ],
            ),
          );
        },
      ),
    );
  }
}
