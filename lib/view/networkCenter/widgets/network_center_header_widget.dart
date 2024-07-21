import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/view/networkCenter/widgets/network_search_widget.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';

class NetworkCenterHeaderWidget extends StatelessWidget {
  final String title;
  final TextEditingController searchController;
  final Function(String value) searchFunctionality;
  const NetworkCenterHeaderWidget({
    super.key,
    required this.searchController,
    required this.title,
    required this.searchFunctionality,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 50.0,
        bottom: 20.0,
      ),
      margin: const EdgeInsets.only(
        bottom: 12.0,
      ),
      decoration: const BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 35.0,
                  width: 35.0,
                  decoration:  BoxDecoration(
                    color: AppColors.lightPrimaryGreen,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back,color: AppColors.darkGreen,),
                    ],
                  ),
                ),
              ),
              const AppSpacer(
                width: 10.0,
              ),
              TextStyles.textHeadings(textValue: title,textSize: 20,textColor: AppColors.white,),
              // Text(
              //   title,
              //   style: const TextStyle(
              //     fontWeight: FontWeight.w700,
              //     fontSize: 20.0,
              //     color: AppColors.white,
              //   ),
              // ),
            ],
          ),
          const AppSpacer(
            height: 15.0,
          ),
          NetworkSearchWidget(
            searchController: searchController,
            searchFunctionality: searchFunctionality,
          ),
        ],
      ),
    );
  }
}
