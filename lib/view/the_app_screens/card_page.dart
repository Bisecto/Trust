import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/the_app_screens/sevices/card_request.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';

import '../../res/app_icons.dart';
import '../../res/app_images.dart';
import '../../utills/custom_theme.dart';
import '../../utills/enums/toast_mesage.dart';
import '../widgets/form_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

import '../widgets/show_toast.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
      final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

      return Scaffold(
        backgroundColor:
        theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
        body: Center(
          child: Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
                color: theme.isDark
                    ? AppColors.darkModeBackgroundContainerColor
                    : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: AssetImage(
                      AppImages.modalBackground,
                    ),
                    //colorFilter: ColorFilter.,
                    opacity: theme.isDark ? 0.2 : 1,
                    fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Lottie.asset(
                          _getImage(AlertType.info),
                          height: 120,
                          width: 120)),
                  const SizedBox(
                    height: 5,
                  ),
                  TextStyles.textHeadings(
                    textValue: 'Info',
                    textColor: theme.isDark
                        ? AppColors.white
                        : AppColors.black,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText(
                        text:
                        'Oops! It looks like this service is still in the oven. We\'re baking up something great, so stay tuned! 🍰',
                        color: theme.isDark
                            ? AppColors.white
                            : AppColors.black,
                        size: 14,
                        maxLines: 5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        )


      //   Container(
      //   height: AppUtils.deviceScreenSize(context).height,
      //   width: AppUtils.deviceScreenSize(context).width,
      //   color: AppColors.white,
      //
      //   // decoration: BoxDecoration(
      //   //   color: AppColors.white,
      //   //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      //   //   // image: DecorationImage(image: AssetImage())
      //   // ),
      //   child: Stack(
      //     children: [
      //       Positioned(
      //         top: 0,
      //         left: 0,
      //         right: 0,
      //         height: 230,
      //         child: Container(
      //           decoration: const BoxDecoration(
      //             color: AppColors.darkGreen,
      //             borderRadius:
      //                 BorderRadius.vertical(bottom: Radius.circular(30)),
      //           ),
      //           child: SvgPicture.asset(
      //             AppIcons.looper1,
      //             width: double.infinity,
      //             fit: BoxFit.fill,
      //           ),
      //         ),
      //       ),
      //       Positioned(
      //         top: 40,
      //         left: 20,
      //         right: 20,
      //         bottom: 0,
      //         child: SingleChildScrollView(
      //           child: Column(
      //             children: [
      //               cardTopContainer(),
      //               const SizedBox(height: 10), // Add some spacing
      //               cardTabController(theme),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget cardTabController(AdaptiveThemeMode theme) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: AppUtils.deviceScreenSize(context).width,
            decoration: BoxDecoration(
                //color: Colors.grey[300],
                border: Border.all(color: AppColors.lightPrimaryGreen),
                borderRadius: BorderRadius.circular(16.0)),
            child: TabBar(
              indicator: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(16.0)),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 0,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(
                  text: 'Physical',
                ),
                Tab(
                  text: 'Virtual',
                ),
              ],
            ),
          ),
          SizedBox(
            height: AppUtils.deviceScreenSize(context).height -
                200, // Set an appropriate height
            width: AppUtils.deviceScreenSize(context).width,
            child: TabBarView(
               children: [physicalCardContaner(), virtualCardContaner()],
            ),
          ),
          //quickActionsWidget(),
        ],
      ),
    );
  }

  Color getColor(AlertType type) {
    if (type == AlertType.success) {
      return Colors.green;
    }
    if (type == AlertType.info) {
      return AppColors.appBarMainColor;
    }
    return Colors.red;
  }

  String _getImage(AlertType type) {
    if (type == AlertType.success) {
      return 'assets/animations/success.json';
    }
    if (type == AlertType.info) {
      return 'assets/animations/info.json';
    }
    return 'assets/animations/error.json';
  }
  Widget cardTopContainer() {
    return SizedBox(
      height: 40,
      width: AppUtils.deviceScreenSize(context).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomText(
            text: "Card",
            color: AppColors.white,
            size: 24,
            weight: FontWeight.bold,
          ),
          CircleAvatar(
            backgroundColor: AppColors.lightPrimary,
            child: SvgPicture.asset(AppIcons.notification),
          )
        ],
      ),
    );
  }

  Widget virtualCardContaner() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 350,
            width: 250,
            decoration: BoxDecoration(
                //color: Colors.grey[300],
                //border: Border.all(color: AppColors.lightPrimaryGreen),
                borderRadius: BorderRadius.circular(20.0),
                image: const DecorationImage(
                    image: AssetImage(AppImages.virtualCardStraight),
                    fit: BoxFit.cover)),
          ),
          SvgPicture.asset(
            AppIcons.virtualCard1,
            height: 70,
          ),
          SvgPicture.asset(
            AppIcons.virtualCard2,
            height: 70,
          ),
          SvgPicture.asset(
            AppIcons.virtualCard3,
            height: 70,
          ),
          FormButton(
            onPressed: () {},
            text: "Create my Virtual card",
            borderRadius: 15,
            height: 50,
            bgColor: AppColors.green,
          ),
        ],
      ),
    );
  }
  Widget comingSoonContainer() {
    return showToast(
        context: context,
        title: 'Info',
        subtitle:
        'Oops! It looks like this service is still in the oven. We\'re baking up something great, so stay tuned! 🍰',
        type: ToastMessageType.info);;
  }

  Widget physicalCardContaner() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 350,
            width: 250,
            decoration: BoxDecoration(
                //color: Colors.grey[300],
                //border: Border.all(color: AppColors.lightPrimaryGreen),
                borderRadius: BorderRadius.circular(20.0),
                image: const DecorationImage(
                    image: AssetImage(AppImages.physicalCardStraight),
                    fit: BoxFit.fill)),
          ),
          FormButton(
            onPressed: () {
              modalSheet.showMaterialModalBottomSheet(
                backgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                context: context,
                builder: (context) => const Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: TellaCardRequest(),
                ),
              );
            },
            text: "Request card",
            borderRadius: 15,
            height: 50,
            bgColor: AppColors.green,
          ),
        ],
      ),
    );
  }
}
