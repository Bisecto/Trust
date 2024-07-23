import 'package:flutter/material.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/utills/constants/general_constant.dart';

class NetworkSearchWidget extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String value) searchFunctionality;
  const NetworkSearchWidget({
    super.key,
    required this.searchController,
    required this.searchFunctionality,
  });

  @override
  State<NetworkSearchWidget> createState() => _NetworkSearchWidgetState();
}

class _NetworkSearchWidgetState extends State<NetworkSearchWidget> {
  late TextEditingController searchController;

  @override
  void initState() {
    searchController = widget.searchController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: TextField(
        controller: searchController,
        textInputAction: TextInputAction.search,
        cursorColor: AppColors.white,
        style: GeneralConstant.networkDefaultTextStyle,
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: GeneralConstant.italicTextStyle,
          suffixIcon: const Icon(
            Icons.search_sharp,
            color: AppColors.white,
          ),
          contentPadding: GeneralConstant.networkSearchWidgetContentPadding,
          border: GeneralConstant.networkSearchBorder,
          errorBorder: GeneralConstant.networkSearchErrorBorder,
          disabledBorder: GeneralConstant.networkSearchBorder,
          enabledBorder: GeneralConstant.networkSearchBorder,
          focusedBorder: GeneralConstant.networkSearchBorder,
        ),
        onChanged: (value) => widget.searchFunctionality(value),
      ),
    );
  }
}
