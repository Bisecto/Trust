import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/send_bloc.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendMain/send_main_view.dart';

class SendMainPage extends StatelessWidget {
  const SendMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      left: false,
      right: false,
      child: BlocProvider(
        create: (context) => SendBloc(),
        child: const SendMainView(),
      ),
    );
  }
}
