import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/utills/constants/loading_dialog.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/tella_rewards/redeem_reward/redeem_airtime.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/tella_rewards/redeem_reward/redeem_data.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/tella_rewards/tella_reward_main.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

import '../../../../bloc/app_bloc/app_bloc.dart';
import '../../../../model/category_model.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_icons.dart';
import '../../../../res/app_images.dart';
import '../../../../utills/app_navigator.dart';
import '../../../../utills/app_utils.dart';
import '../../../../utills/custom_theme.dart';
import '../../../../utills/enums/toast_mesage.dart';
import '../../../widgets/app_custom_text.dart';
import '../../../widgets/show_toast.dart';

class GiftCardValue extends StatefulWidget {
  final bool allowClick;
  final bool showForwardIcon;
  final String amtUSD;
  final String cardNo;

  const GiftCardValue({
    super.key,
    this.allowClick = true,
    required this.showForwardIcon, required this.amtUSD, required this.cardNo,
  });

  @override
  State<GiftCardValue> createState() =>
      _GiftCardValueState();
}

class _GiftCardValueState extends State<GiftCardValue> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider
        .of<CustomThemeState>(context)
        .adaptiveThemeMode;

    return GestureDetector(
      onTap: () {
        if (widget.allowClick) {
          AppNavigator.pushAndStackPage(context,
              page: const TellaPointMainPage());
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 70,
          width: AppUtils
              .deviceScreenSize(context)
              .width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.lightGreen),
            color: AppColors.lightgreen2,
            image: const DecorationImage(
              image: AssetImage(AppImages.tellaPointBannerBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildWalletInfo(widget.cardNo,widget.amtUSD, theme),
              if (!widget.allowClick && !widget.showForwardIcon)
                _buildRedeemButton(context, theme),
              if (widget.showForwardIcon) _buildForwardIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletInfo(cardNo,amtUSD, AdaptiveThemeMode theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: AppColors.lightPrimary,
          child: SvgPicture.asset(AppIcons.badge),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: "Your Gift Card: $cardNo",
            ),
            TextStyles.textHeadings(
              textValue: 'Cash value: \$$amtUSD',
              textSize: 13,
              textColor: Colors.grey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRedeemButton(BuildContext context, AdaptiveThemeMode theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          redeemPoint(context, theme);
        },
        child: Container(
          height: 30,
          width: 102,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.lightGreen),
            color: AppColors.lightgreen2,
          ),
          child: const Center(
            child: CustomText(
              text: "Redeem Points",
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForwardIcon() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: AppColors.green,
        child: Icon(
          Icons.arrow_forward_ios,
        ),
      ),
    );
  }

  Future<void> redeemPoint(BuildContext context,
      AdaptiveThemeMode theme) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: 200,
            decoration: BoxDecoration(
              color: theme.isDark
                  ? AppColors.darkModeBackgroundColor
                  : AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  _buildCloseButton(context),
                  SizedBox(
                    height: 150,
                    child: _buildCategoryList(theme),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, true);
      },
      child: const Align(
        alignment: Alignment.topRight,
        child: Icon(
          Icons.cancel,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildCategoryList(AdaptiveThemeMode theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            _handleCategoryTap(context, 'airtime');
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              height: 40,
              //width: 102,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.textColor2),
                color: AppColors.grey,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Convert point to airtime",
                      color: AppColors.textColor2,
                      weight: FontWeight.bold,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textColor2,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _handleCategoryTap(context, 'data');
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              height: 40,
              //width: 102,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.textColor2),
                color: AppColors.grey,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Convert point to Data",
                      color: AppColors.textColor2,
                      weight: FontWeight.bold,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textColor2,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleCategoryTap(BuildContext context, String category) {
    //String selectedAction = category.name.toLowerCase();

    switch (category) {
      case "airtime":
        _openRedeemModal(context, RedeemWithAirtime(category: category));
        break;
      case "data":
        _openRedeemModal(context, RedeemWithData(category: category));
        break;
      default:
        showToast(
          context: context,
          title: 'Info',
          subtitle:
          'Oops! It looks like this service is still in the oven. We\'re baking up something great, so stay tuned! 🍰',
          type: ToastMessageType.info,
        );
        break;
    }
  }

  void _openRedeemModal(BuildContext context, Widget modal) {
    modalSheet.showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (context) =>
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: modal,
          ),
    );
  }

}
