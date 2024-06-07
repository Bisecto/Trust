import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import 'package:teller_trust/view/widgets/form_button.dart';

import '../../../../res/app_colors.dart';
import '../../../../utills/app_validator.dart';
import '../../../widgets/form_input.dart';

class BvnNinKyc2 extends StatefulWidget {
  const BvnNinKyc2({super.key});

  @override
  State<BvnNinKyc2> createState() => _BvnNinKyc2State();
}

class _BvnNinKyc2State extends State<BvnNinKyc2> {
  String selectedString = 'NIN';
  final _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        elevation: 1,
        title: const CustomText(text: "KYC verification1",color: AppColors.white,),
        leading: Navigator.canPop(context)
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        )
            : null,
      ),
      body: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            top: 0,
            child: Container(
              height: AppUtils.deviceScreenSize(context).height,
              width: AppUtils.deviceScreenSize(context).width,
              child: SvgPicture.asset(AppIcons.kycBackground, fit: BoxFit.cover),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: AppUtils.deviceScreenSize(context).width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.darkGreen),
                            color: AppColors.appBarMainColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedString = 'NIN';
                                    });
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: selectedString == 'NIN'
                                          ? AppColors.green
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        text: 'NIN',
                                        color: selectedString == 'NIN'
                                            ? AppColors.white
                                            : Colors.black,
                                        size: 10,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedString = 'BVN';
                                    });
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: selectedString == 'BVN'
                                          ? AppColors.green
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        text: 'BVN',
                                        color: selectedString == 'BVN'
                                            ? AppColors.white
                                            : Colors.black,
                                        size: 10,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomText(
                          text: 'Enter your $selectedString',
                          size: 20,
                          weight: FontWeight.bold,
                          textAlign: TextAlign.center,
                          color: AppColors.black,
                          maxLines: 2,
                        ),
                        const CustomText(
                          text:
                          'We will use this to ensure your account belongs to you',
                          size: 12,
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          color: AppColors.textColor,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const CustomText(
                          text: 'Level 1 Benefits',
                          size: 12,
                          textAlign: TextAlign.center,
                          color: AppColors.textColor,
                          weight: FontWeight.bold,
                        ),
                        CustomTextFormField(
                          label: '',
                          validator: AppValidator.validateTextfield,
                          controller: _numberController,
                          hint: selectedString == 'NIN'
                              ? 'Enter your NIN (11 digits)'
                              : 'Enter your BVN (11 digits)',
                          icon: Icons.verified_outlined,
                          textInputType: TextInputType.number,
                          borderColor: _numberController.text.isNotEmpty
                              ? AppColors.green
                              : AppColors.grey,
                        ),
                        FormButton(
                          onPressed: () {},
                          text: 'Save Details',
                          borderRadius: 10,
                          //bgColor: _numberController.text.length != 10?AppColors.grey:AppColors.darkGreen,
                          disableButton: _numberController.text.length != 11,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
