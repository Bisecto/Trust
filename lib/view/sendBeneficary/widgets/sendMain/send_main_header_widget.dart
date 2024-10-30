import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/view/sendBeneficary/pages/recent_transfer_list_page.dart';

import '../../../../utills/custom_theme.dart';

class SendMainHeaderWidget extends StatefulWidget {
  final String balance;
  final VoidCallback backNavCallBack;

  const SendMainHeaderWidget({
    super.key,
    required this.balance,
    required this.backNavCallBack,
  });

  @override
  State<SendMainHeaderWidget> createState() => _SendMainHeaderWidgetState();
}

class _SendMainHeaderWidgetState extends State<SendMainHeaderWidget> {
  // bool isMoneyBlocked = false;
  // Future<void> getIfMoneyIsBlocked() async {
  //   isMoneyBlocked = await SharedPref.getBool('isMoneyBlocked') ?? false;
  //   print('Initial isMoneyBlocked: $isMoneyBlocked');
  //   setState(() {});
  // }
  @override
  void initState() {
    // TODO: implement initState
    //getIfMoneyIsBlocked();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if(!Navigator.canPop(context))
          SizedBox(),
        if(Navigator.canPop(context))
        InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            width: 45,
            height: 45,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color:theme.isDark?AppColors.darkModeBackgroundContainerColor: AppColors.sendBackBtnColor,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/sendBeneficiary/back.svg',
                color: theme.isDark?AppColors.white:null,
              ),
            ),
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Container(
        //       padding: const EdgeInsets.symmetric(
        //         horizontal: 10.0,
        //         vertical: 3.5,
        //       ),
        //       decoration: BoxDecoration(
        //         color:theme.isDark?Colors.transparent:  AppColors.sendBackBalanceBgColor,
        //         borderRadius: BorderRadius.circular(
        //           10.0,
        //         ),
        //         border: Border.all(
        //           color:theme.isDark?AppColors.white:  AppColors.sendBackBalanceBorderColor,
        //         ),
        //       ),
        //       child:  Center(
        //         child: Text(
        //           'Balance',
        //           style: TextStyle(
        //             color:theme.isDark?AppColors.darkModeBackgroundMainTextColor: AppColors.sendToBalanceColor,
        //             fontWeight: FontWeight.bold,
        //           ),
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
        //     ),
        //     const AppSpacer(
        //       width: 10.0,
        //     ),
        //     Text(
        //       !isMoneyBlocked?widget.balance:'*****',
        //       style:  TextStyle(
        //         color:theme.isDark?AppColors.white:  AppColors.sendToBalanceValueColor,
        //         fontSize: 18.0,
        //         fontWeight: FontWeight.w600,
        //       ),
        //       textAlign: TextAlign.start,
        //     ),
        //     const AppSpacer(
        //       width: 10.0,
        //     ),
        //     GestureDetector(
        //       onTap: () async {
        //         setState(() {
        //           isMoneyBlocked = !isMoneyBlocked;
        //         });
        //         await SharedPref.putBool(
        //             'isMoneyBlocked', isMoneyBlocked);
        //         print('Saved isMoneyBlocked: $isMoneyBlocked');
        //       },
        //       child: Padding(
        //         padding: const EdgeInsets.all(10.0),
        //         child: Align(
        //           alignment: Alignment.topRight,
        //           child: Icon(
        //             isMoneyBlocked
        //                 ? Icons.visibility_off
        //                 : Icons.visibility,
        //             color: AppColors.white,
        //             size: 16,
        //           ),
        //         ),
        //       ),
        //     ),
        //
        //   ],
        // ),
        InkWell(
          onTap: () {
            AppNavigator.pushAndStackPage(
              context,
              page: const RecentTransferListPage(),
            );
          },
          child: Container(
            width: 45,
            height: 45,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color:theme.isDark?AppColors.darkModeBackgroundContainerColor: AppColors.recentTxnBtnColor,
            ),
            child: Card(
              elevation: 2.0,
              color:theme.isDark?AppColors.darkModeBackgroundContainerColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(
                  17.0,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/sendBeneficiary/recentTxn.svg',
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
