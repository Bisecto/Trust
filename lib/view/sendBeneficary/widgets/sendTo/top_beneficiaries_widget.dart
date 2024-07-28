import 'package:flutter/material.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/top_beneficiaries_item_widget.dart';

class TopBeneficiariesWidget extends StatelessWidget {
  final List beneficiaries;
  final bool isItForTellaTrust;
  const TopBeneficiariesWidget({
    super.key,
    required this.beneficiaries,
    required this.isItForTellaTrust,
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
            color: AppColors.sendToLabelColor,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (isItForTellaTrust)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppSpacer(
                height: 20.0,
              ),
              const Text(
                'Top Beneficiaries',
                style: TextStyle(
                  color: AppColors.sendBodyTextColor,
                  fontSize: 15.0,
                ),
              ),
              const AppSpacer(
                height: 5.0,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...List.generate(
                      beneficiaries.length,
                      (index) {
                        String beneficiaryFullname = '';
                        String beneficiaryImagePath = '';
                        return TopBeneficiariesItemWidget(
                          beneficiaryFullname: beneficiaryFullname,
                          beneficiaryImagePath: beneficiaryImagePath,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const AppSpacer(
                height: 10.0,
              ),
              const Divider(),
            ],
          ),
      ],
    );
  }
}
