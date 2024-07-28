import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';

class TopBeneficiariesItemWidget extends StatelessWidget {
  final String beneficiaryImagePath;
  final String beneficiaryFullname;
  const TopBeneficiariesItemWidget({
    super.key,
    required this.beneficiaryFullname,
    required this.beneficiaryImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(''),
          ),
        ),
        const AppSpacer(
          height: 5.0,
        ),
        Text(
          beneficiaryFullname,
          style: const TextStyle(
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}
