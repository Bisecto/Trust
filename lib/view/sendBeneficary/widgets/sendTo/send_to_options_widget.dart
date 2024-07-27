import 'package:flutter/material.dart';
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
    return Row(
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
          width: 10.0,
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
    );
  }
}
