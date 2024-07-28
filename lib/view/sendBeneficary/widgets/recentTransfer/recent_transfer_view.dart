import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/event/send_event.dart';
import 'package:teller_trust/bloc/sendBloc/send_bloc.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/recentTransfer/recent_tranfer_details_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/recentTransfer/recent_transfer_header_widget.dart';

class RecentTransferView extends StatefulWidget {
  const RecentTransferView({super.key});

  @override
  State<RecentTransferView> createState() => _RecentTransferViewState();
}

class _RecentTransferViewState extends State<RecentTransferView> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<SendBloc>(context).add(
      const LoadUserTransactions(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RecentTransferHeaderWidget(
                searchController: searchController,
                searchFunctionality: (value) {
                  BlocProvider.of<SendBloc>(context).add(
                    SearchUserTransactions(
                      searchValue: value,
                    ),
                  );
                },
              ),
              const Expanded(
                child: RecentTranferDetailsWidget(),
              ),
            ],
          );
        },
      ),
    );
  }
}
