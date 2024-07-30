import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/send_bloc.dart';
import 'package:teller_trust/model/bank_model.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/bankModal/banks_modal_widget.dart';

class BankViewWidget extends StatelessWidget {
  final List<Bank> banks;
  const BankViewWidget({
    super.key,
    required this.banks,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SendBloc(),
      child: BanksModalWidget(
        banks: banks,
      ),
    );
  }
}
