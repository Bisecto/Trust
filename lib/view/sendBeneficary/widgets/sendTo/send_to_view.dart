import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/event/send_event.dart';
import 'package:teller_trust/bloc/sendBloc/send_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/states/send_state.dart';
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
  bool isItForTellaTrust = false;

  bool userForTxnConfirmed = false;

  bool isReceiptentSelectedForTellaTrustTxn = false;

  String transferredToName = 'Favour Sophia Okpara';
  String transferredToImage = 'Favour Sophia Okpara';

  List listOfBeneficiaries = [];

  @override
  void initState() {
    txnDetails = widget.txnDetails;
    BlocProvider.of<SendBloc>(context).add(
      const LoadSendToDetailsInitialState(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomViewInset = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      body: BlocConsumer<SendBloc, SendState>(
        listener: (context, state) {
          if (state is SelectedTxnOption) {
            setState(() {
              isItForTellaTrust = state.isItForTellaTrust;
            });
          }
        },
        builder: (context, state) {
          if (state is ListOfBeneficiariesToSendTo) {
            listOfBeneficiaries = state.listOfBeneficiaries;
          }

          return BgLogoDisplayWidget(
            child: Column(
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
                      buttonCallback: () {},
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
