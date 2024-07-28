import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/send_bloc.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/recentTransfer/recent_transfer_view.dart';

class RecentTransferListPage extends StatelessWidget {
  const RecentTransferListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      left: false,
      right: false,
      child: BlocProvider(
        create: (context) => SendBloc(),
        child: const RecentTransferView(),
      ),
    );
  }
}
