import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/event/send_event.dart';
import 'package:teller_trust/bloc/sendBloc/send_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/states/send_state.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendMain/send_main_form_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendMain/send_main_header_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/send_beneficiary_app_logo_body_widget.dart';

class SendMainView extends StatefulWidget {
  final VoidCallback backNavCallBack;
  const SendMainView({super.key, required this.backNavCallBack,});

  @override
  State<SendMainView> createState() => _SendMainViewState();
}

class _SendMainViewState extends State<SendMainView> {
  String balance = '0.00';

  late VoidCallback backNavCallBack;

  @override
  void initState() {
    backNavCallBack = widget.backNavCallBack;
    BlocProvider.of<SendBloc>(context).add(
      const LoadUserBalance(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SendBloc, SendState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is UserBalance) {
            balance = state.balance;
          }
          return SendBeneficiaryAppLogoBodyWidget(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSpacer(
                  height: 10.0,
                ),
                SendMainHeaderWidget(
                  balance: balance,
                  backNavCallBack: backNavCallBack,
                ),
                const AppSpacer(
                  height: 30.0,
                ),
                const Expanded(
                  child: SingleChildScrollView(
                    child: SendMainFormWidget(),
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
