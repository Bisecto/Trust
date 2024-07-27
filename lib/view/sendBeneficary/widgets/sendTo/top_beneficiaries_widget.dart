import 'package:flutter/material.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/top_beneficiaries_item_widget.dart';

class TopBeneficiariesWidget extends StatelessWidget {
  final List beneficiaries;
  const TopBeneficiariesWidget({
    super.key,
    required this.beneficiaries,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Send to',
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const AppSpacer(
          height: 10.0,
        ),
        const Text(
          'Top Beneficiaries',
          style: TextStyle(
            color: AppColors.grey,
          ),
        ),
        const AppSpacer(
          height: 3.0,
        ),
        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, state) {
            String beneficiaryFullname = '';
            String beneficiaryImagePath = '';
            return TopBeneficiariesItemWidget(
              beneficiaryFullname: beneficiaryFullname,
              beneficiaryImagePath: beneficiaryImagePath,
            );
          },
        ),
        const Divider(),
      ],
    );
  }
}
