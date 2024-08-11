import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/bloc/sendBloc/event/send_event.dart';
import 'package:teller_trust/bloc/sendBloc/send_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/states/send_state.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendMain/send_main_form_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendMain/send_main_header_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/send_beneficiary_app_logo_body_widget.dart';

import '../../../../res/app_colors.dart';
import '../../../../utills/custom_theme.dart';

class SendMainView extends StatefulWidget {
  final VoidCallback backNavCallBack;

  const SendMainView({
    super.key,
    required this.backNavCallBack,
  });

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
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      backgroundColor:
          theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
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
                  height: 20.0,
                ),
                SendMainHeaderWidget(
                  balance: balance,
                  backNavCallBack: backNavCallBack,
                ),
                const AppSpacer(
                  height: 30.0,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: SendMainFormWidget(
                      balance: balance,
                    ),
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
