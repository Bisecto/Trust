import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/utills/constants/general_constant.dart';

class SendToFormWidget extends StatelessWidget {
  final TextEditingController accountNumberController;
  final Function(String value) searchFunctionality;
  final bool isItForTellaTrust;
  const SendToFormWidget({
    super.key,
    required this.accountNumberController,
    required this.isItForTellaTrust,
    required this.searchFunctionality,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40.0,
          child: TextField(
            controller: accountNumberController,
            textInputAction: TextInputAction.search,
            cursorColor: AppColors.green,
            style: GeneralConstant.networkDefaultTextStyle,
            decoration: InputDecoration(
              hintText: isItForTellaTrust
                  ? 'enter @tellaid or phone number here'
                  : '',
              hintStyle: GeneralConstant.italicTextStyle,
              suffixIcon: SvgPicture.asset(''),
              contentPadding: GeneralConstant.networkSearchWidgetContentPadding,
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
            onChanged: (value) => searchFunctionality(value),
          ),
        ),
        
      ],
    );
  }
}
