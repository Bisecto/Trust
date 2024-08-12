import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teller_trust/utills/constants/loading_dialog.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/tella_rewards/tella_reward_main.dart';

import '../../../../bloc/app_bloc/app_bloc.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_icons.dart';
import '../../../../res/app_images.dart';
import '../../../../utills/app_navigator.dart';
import '../../../../utills/app_utils.dart';
import '../../../widgets/app_custom_text.dart';

class TellaPointProductContainer extends StatelessWidget {
  const TellaPointProductContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is SuccessState) {
          var walletInfo = state.customerProfile.walletInfo;
          return GestureDetector(
            onTap: () {
              AppNavigator.pushAndStackPage(context,
                  page: TellaPointMainPage());
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 70,
                width: AppUtils.deviceScreenSize(context).width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.lightGreen),
                    color: AppColors.lightgreen2,
                    image: DecorationImage(
                        image: AssetImage(AppImages.tellaPointBannerBackground),
                        fit: BoxFit.cover)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.lightPrimary,
                      child: SvgPicture.asset(AppIcons.badge),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Tella Point: ${walletInfo.points}",
                        ),
                        TextStyles.textHeadings(
                            textValue: 'Cash value: N${walletInfo.points}',
                            textSize: 13,
                            textColor: Colors.grey)
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return LoadingDialog(
              ''); // Show loading indicator or handle error state
        }
      },
    );
  }
}
