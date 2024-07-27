import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/utills/constants/general_constant.dart';

class SendToFormWidget extends StatefulWidget {
  final bool isItForTellaTrust;
  const SendToFormWidget({
    super.key,
    required this.isItForTellaTrust,
  });

  @override
  State<SendToFormWidget> createState() => _SendToFormWidgetState();
}

class _SendToFormWidgetState extends State<SendToFormWidget> {
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();

  bool isItForTellaTrust = false;

  @override
  void initState() {
    isItForTellaTrust = widget.isItForTellaTrust;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isItForTellaTrust)
          SizedBox(
            height: 45.0,
            child: InkWell(
              onTap: () {},
              child: TextField(
                controller: bankNameController,
                textInputAction: TextInputAction.search,
                enabled: false,
                cursorColor: AppColors.sendToBankBgColor,
                style: GeneralConstant.sendToDefaultTextStyle,
                decoration: InputDecoration(
                  hintText: '',
                  hintStyle: GeneralConstant.normalTextStyle,
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(
                      right: 15.0,
                    ),
                    child: Icon(Icons.keyboard_arrow_down),
                  ),
                  contentPadding:
                      GeneralConstant.sendToFormWidgetContentPadding,
                  border: GeneralConstant.bankSendSearchBorder,
                  errorBorder: GeneralConstant.bankSendSearchErrorBorder,
                  disabledBorder: GeneralConstant.bankSendSearchBorder,
                  enabledBorder: GeneralConstant.bankSendSearchBorder,
                  focusedBorder: GeneralConstant.bankSendSearchBorder,
                ),
                onChanged: (value) {},
              ),
            ),
          ),
        if (!isItForTellaTrust)
          const AppSpacer(
            height: 10.0,
          ),
        SizedBox(
          height: 45.0,
          child: TextField(
            controller: accountNumberController,
            textInputAction: TextInputAction.search,
            cursorColor: isItForTellaTrust
                ? AppColors.sendToTellaColor
                : AppColors.sendToBankBgColor,
            style: GeneralConstant.sendToDefaultTextStyle,
            decoration: InputDecoration(
              hintText: isItForTellaTrust
                  ? 'enter @tellaid or phone number here'
                  : 'Account number here',
              hintStyle: GeneralConstant.normalTextStyle,
              prefixIcon: isItForTellaTrust
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 5.0,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/sendBeneficiary/tellaTrustGrey.svg',
                      ),
                    )
                  : null,
              contentPadding: GeneralConstant.sendToFormWidgetContentPadding,
              border: isItForTellaTrust
                  ? GeneralConstant.tellaSendSearchBorder
                  : GeneralConstant.bankSendSearchBorder,
              errorBorder: isItForTellaTrust
                  ? GeneralConstant.tellaSendSearchErrorBorder
                  : GeneralConstant.bankSendSearchErrorBorder,
              disabledBorder: isItForTellaTrust
                  ? GeneralConstant.tellaSendSearchBorder
                  : GeneralConstant.bankSendSearchBorder,
              enabledBorder: isItForTellaTrust
                  ? GeneralConstant.tellaSendSearchBorder
                  : GeneralConstant.bankSendSearchBorder,
              focusedBorder: isItForTellaTrust
                  ? GeneralConstant.tellaSendSearchBorder
                  : GeneralConstant.bankSendSearchBorder,
            ),
            onChanged: (value) {},
          ),
        ),
        const AppSpacer(
          height: 10.0,
        ),
        SizedBox(
          height: 45.0,
          child: TextField(
            controller: descriptionController,
            textInputAction: TextInputAction.done,
            cursorColor: isItForTellaTrust
                ? AppColors.sendToTellaColor
                : AppColors.sendToBankBgColor,
            style: GeneralConstant.sendToDefaultTextStyle,
            decoration: InputDecoration(
              hintText: 'Add a description here',
              hintStyle: GeneralConstant.normalTextStyle,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 5.0,
                ),
                child: SvgPicture.asset(
                  'assets/icons/sendBeneficiary/sendToVerified.svg',
                ),
              ),
              contentPadding: GeneralConstant.sendToFormWidgetContentPadding,
              border: isItForTellaTrust
                  ? GeneralConstant.tellaSendSearchBorder
                  : GeneralConstant.bankSendSearchBorder,
              errorBorder: isItForTellaTrust
                  ? GeneralConstant.tellaSendSearchErrorBorder
                  : GeneralConstant.bankSendSearchErrorBorder,
              disabledBorder: isItForTellaTrust
                  ? GeneralConstant.tellaSendSearchBorder
                  : GeneralConstant.bankSendSearchBorder,
              enabledBorder: isItForTellaTrust
                  ? GeneralConstant.tellaSendSearchBorder
                  : GeneralConstant.bankSendSearchBorder,
              focusedBorder: isItForTellaTrust
                  ? GeneralConstant.tellaSendSearchBorder
                  : GeneralConstant.bankSendSearchBorder,
            ),
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }
}
