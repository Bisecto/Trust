import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

import '../../res/app_colors.dart';
import '../../res/app_images.dart';
import '../../res/app_router.dart';
import '../../res/app_strings.dart';
import '../../utills/app_navigator.dart';
import '../../utills/app_utils.dart';
import '../widgets/app_custom_text.dart';
import '../widgets/form_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final List<String> onboardingImages = [
    AppImages.onBoardingScreen1,
    AppImages.onBoardingScreen2,
    AppImages.onBoardingScreen3,
  ];
  final List<String> onBoardingText = [
    AppStrings.onBoardingScreen1MainText,
    AppStrings.onBoardingScreen2MainText,
    AppStrings.onBoardingScreen3MainText,
  ];
  final List<String> onBoardingSubText = [
    AppStrings.onBoardingScreen1SubText,
    AppStrings.onBoardingScreen2SubText,
    AppStrings.onBoardingScreen3SubText,
  ];
  CarouselSliderController carouselSliderController =
      CarouselSliderController();
  final GlobalKey _sliderKey = GlobalKey();
  bool skip = false;
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark
        //color set to transperent or set your own color
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:currentIndex==0||currentIndex==2? AppColors.lightShadowGreenColor:AppColors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                carouselIndicator(0, currentIndex),
                carouselIndicator(1, currentIndex),
                carouselIndicator(2, currentIndex),
              ],
            ),
            SizedBox(
              height: AppUtils.deviceScreenSize(context).height * 0.75,
              child: CarouselSlider.builder(
                key: _sliderKey,
                unlimitedMode: false,
                controller: carouselSliderController,
                onSlideChanged: (index) {
                  setState(() {
                    print(index);
                    currentIndex = index;
                  });
                },
                slideBuilder: (index) {
                  return Center(
                    child: SizedBox(
                      width: AppUtils.deviceScreenSize(context).width / 1.3,
                      // Set the desired width of the container
                      height: AppUtils.deviceScreenSize(context).height * 0.65,
                      // Set the desired height of the container
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(32),
                      //   image: DecorationImage(
                      //     image: AssetImage(onboardingImages[index]),
                      //     // Replace with your actual image file path
                      //     fit: BoxFit
                      //         .cover, // You can adjust the fit property to cover, contain, or others
                      //   ),
                      // ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          // crossAxisAlignment:
                          // CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: AppUtils.deviceScreenSize(context).width /
                                  1.5,
                              // Set the desired width of the container
                              height:
                                  AppUtils.deviceScreenSize(context).height *
                                      0.4,
                              // Set the desired height of the container
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                image: DecorationImage(
                                  image: AssetImage(onboardingImages[index]),
                                  // Replace with your actual image file path
                                  fit: BoxFit
                                      .cover, // You can adjust the fit property to cover, contain, or others
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomText(
                              text: onBoardingText[index],
                              color: AppColors.textColor,
                              size: 22,
                              weight: FontWeight.bold,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: CustomText(
                                text: onBoardingSubText[index],
                                color: AppColors.textColor,
                                size: 16,
                                maxLines: 4,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                slideTransform: const DefaultTransform(),
                // slideIndicator: SequentialFillIndicator(
                //   indicatorRadius: 20,
                //  itemSpacing: 50,
                //  // alignment: Alignment.topCenter,
                //   indicatorBackgroundColor: AppColors.grey,
                //   currentIndicatorColor: AppColors.green,
                //   padding: const EdgeInsets.only(bottom: 0),
                // ),
                itemCount: onboardingImages.length,
                onSlideEnd: () {
                  print("ended");
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FormButton(
                  onPressed: () {
                    //skip = true;
                    // welcomeAlertDialog(context);
                    AppNavigator.pushAndStackNamed(context,
                        name: AppRouter.signInScreen);
                  },
                  height: 50,
                  width: AppUtils.deviceScreenSize(context).width / 2.5,
                  text: 'Login',
                  borderRadius: 10,
                  textColor: AppColors.textColor,
                  bgColor: AppColors.white,
                  borderColor: AppColors.green,
                  borderWidth: 1,
                  weight: FontWeight.w400,
                ),
                FormButton(
                  onPressed: () {
                    AppNavigator.pushAndStackNamed(context,
                        name: AppRouter.signUpScreen);
                  },
                  height: 50,
                  width: AppUtils.deviceScreenSize(context).width / 2.5,
                  text: 'Sign Up',
                  borderColor: AppColors.green,
                  bgColor: AppColors.green,
                  textColor: AppColors.white,
                  borderRadius: 10,
                  weight: FontWeight.w400,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // welcomeAlertDialog(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           backgroundColor: Colors.white,
  //           contentPadding: EdgeInsets.zero,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(20.0)),
  //           ),
  //           content: Container(
  //             decoration: BoxDecoration(
  //                 color: AppColors.white,
  //                 borderRadius: BorderRadius.circular(20)),
  //             child: Column(
  //               //mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Container(
  //                   width: AppUtils.deviceScreenSize(context).width,
  //                   height: 100,
  //                   decoration: const BoxDecoration(
  //                       color: AppColors.white,
  //                       image: DecorationImage(
  //                         image: AssetImage(
  //                           AppImages.welcomeImage,
  //                         ),
  //                         fit: BoxFit.fill,
  //                       ),
  //                       //color: AppColors.red,
  //                       borderRadius: BorderRadius.only(
  //                           topRight: Radius.circular(20),
  //                           topLeft: Radius.circular(20))),
  //                 ),
  //
  //                 const CustomText(
  //                   text: AppStrings.welcome,
  //                   weight: FontWeight.bold,
  //                   size: 18,
  //                 ),
  //
  //                 const CustomText(
  //                   text: AppStrings.welcomeDescription,
  //                   // weight: FontWeight.bold,
  //                   size: 16,
  //                   color: AppColors.textColor,
  //                   textAlign: TextAlign.center,
  //                   maxLines: 5,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.fromLTRB(15.0, 0, 20, 0),
  //                   child: FormButton(
  //                     onPressed: () {
  //                       AppNavigator.pushAndStackNamed(context,
  //                           name: AppRouter.signUpScreen);
  //                     },
  //                     height: 50,
  //                     // width: AppUtils.deviceScreenSize(context).width / 2.5,
  //                     text: 'Create Account',
  //                     borderColor: AppColors.green,
  //                     bgColor: AppColors.green,
  //                     textColor: AppColors.white,
  //                     borderRadius: 10,
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.fromLTRB(15.0, 0, 20, 0),
  //                   child: FormButton(
  //                     onPressed: () {
  //                       AppNavigator.pushAndStackNamed(context,
  //                           name: AppRouter.signInScreen);
  //                     },
  //                     height: 50,
  //                     text: 'Log In',
  //                     borderWidth: 1,
  //                     borderColor: AppColors.grey,
  //                     bgColor: AppColors.white,
  //                     textColor: AppColors.textColor,
  //                     borderRadius: 10,
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.all(15),
  //                   child: TextStyles.richTexts(
  //                     centerText: true,
  //                     size: 14,
  //                     text1: "By tapping ",
  //                     color: AppColors.textColor,
  //                     text2: '"Create Account" ',
  //                     color2: AppColors.black,
  //                     text3: "or ",
  //                     text4: '"Log In" ',
  //                     text5: "you agree to ",
  //                     color5: AppColors.textColor,
  //                     text6: "Our Terms. ",
  //                     color6: AppColors.green,
  //                     text7: 'Learn about how we process your data in Our ',
  //                     color7: AppColors.textColor,
  //                     text8: "Privacy Policy.",
  //                     color8: AppColors.green,
  //                   ),
  //                 ),
  //                 // SizedBox(
  //                 //   height: 20,
  //                 // )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  Widget carouselIndicator(index, currentIndex) {
    return Container(
      height: 10,
      width: AppUtils.deviceScreenSize(context).width / 4,
      decoration: BoxDecoration(
          color: index == currentIndex ? AppColors.green : AppColors.grey,
          borderRadius: BorderRadius.circular(10)),
      //child: ,
    );
  }
}
