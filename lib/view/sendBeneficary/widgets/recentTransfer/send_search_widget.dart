import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/utills/constants/general_constant.dart';

class SendSearchWidget extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String value) searchFunctionality;
  const SendSearchWidget({
    super.key,
    required this.searchController,
    required this.searchFunctionality,
  });

  @override
  State<SendSearchWidget> createState() => _SendSearchWidgetState();
}

class _SendSearchWidgetState extends State<SendSearchWidget> {
  late TextEditingController searchController;

  @override
  void initState() {
    searchController = widget.searchController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: TextField(
        controller: searchController,
        textInputAction: TextInputAction.search,
        cursorColor: AppColors.white,
        style: GeneralConstant.networkDefaultTextStyle,
        decoration: InputDecoration(
          hintText: 'Search here',
          fillColor: AppColors.white,
          filled: true,
          hintStyle: GeneralConstant.normalTextStyle,
          suffixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(
              end: 12.0,
            ),
            child: SvgPicture.asset(
              'assets/icons/sendBeneficiary/recentTxnFilter.svg',
            ),
          ),
          contentPadding: GeneralConstant.sendSearchWidgetContentPadding,
          border: GeneralConstant.sendSearchBorder,
          errorBorder: GeneralConstant.networkSearchErrorBorder,
          disabledBorder: GeneralConstant.sendSearchBorder,
          enabledBorder: GeneralConstant.sendSearchBorder,
          focusedBorder: GeneralConstant.sendSearchBorder,
        ),
        onChanged: (value) => widget.searchFunctionality(value),
      ),
    );
  }
}
