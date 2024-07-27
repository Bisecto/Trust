import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/options_item_widget.dart';

class SendToOptionsWidget extends StatefulWidget {
  const SendToOptionsWidget({super.key});

  @override
  State<SendToOptionsWidget> createState() => _SendToOptionsWidgetState();
}

class _SendToOptionsWidgetState extends State<SendToOptionsWidget> {
  bool tellaTrustSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: OptionsItemWidget(
                isItForTellaTrustTransferOption: true,
                isOptionItemSelected: tellaTrustSelected,
                selectedCallback: () {
                  setState(() {
                    tellaTrustSelected = !tellaTrustSelected;
                  });
                },
              ),
            ),
            const AppSpacer(
              width: 15.0,
            ),
            Expanded(
              child: OptionsItemWidget(
                isItForTellaTrustTransferOption: false,
                isOptionItemSelected: !tellaTrustSelected,
                selectedCallback: () {
                  setState(() {
                    tellaTrustSelected = !tellaTrustSelected;
                  });
                },
              ),
            ),
          ],
        ),
        const AppSpacer(
          height: 15.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Beneficiary',
              style: TextStyle(
                color: AppColors.sendBodyTextColor,
                fontSize: 16.0,
              ),
            ),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: 90,
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 2.0,
                      top: 3.0,
                      bottom: 5.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sendToBankBgColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                      border: Border.all(
                        color: AppColors.sendToBankBgColor,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const FittedBox(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColors.sendBodyTextColor,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        const AppSpacer(
                          width: 5.0,
                        ),
                        SvgPicture.asset(
                          'assets/icons/sendBeneficiary/beneficiaryCancel.svg',
                          height: 25.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
