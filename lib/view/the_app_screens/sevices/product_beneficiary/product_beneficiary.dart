import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:teller_trust/model/required_field_model.dart';

import '../../../../bloc/product_bloc/product_bloc.dart';
import '../../../../model/beneficiary_model.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_icons.dart';
import '../../../../utills/app_utils.dart';
import '../../../../utills/custom_theme.dart';
import '../../../../utills/enums/toast_mesage.dart';
import '../../../widgets/app_custom_text.dart';
import '../../../widgets/form_button.dart';
import '../../../widgets/show_toast.dart';

class BeneficiaryWidget extends StatefulWidget {
  String productId;
  final ValueChanged<String> beneficiaryNum;

  BeneficiaryWidget(
      {super.key, required this.productId, required this.beneficiaryNum});

  @override
  State<BeneficiaryWidget> createState() => _BeneficiaryWidgetState();
}

class _BeneficiaryWidgetState extends State<BeneficiaryWidget> {
  ProductBloc productBloc = ProductBloc();

  @override
  void initState() {
    // TODO: implement initState'
    productBloc.add(GetProductBeneficiaryEvent(widget.productId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return BlocConsumer<ProductBloc, ProductState>(
        bloc: productBloc,
        //listenWhen: (previous, current) => current is! InitialEvent,
        buildWhen: (previous, current) => current is! ProductInitial,
        listener: (context, state) async {
          if (state is ErrorState) {
            showToast(
                context: context,
                title: 'Error',
                subtitle: "There was a problem fetching beneficiaries",
                type: ToastMessageType.error);
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            // case PostsFetchingState:
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );

            case GetBeneficiarySuccessState:
              final getBeneficiarySuccessState =
                  state as GetBeneficiarySuccessState;

              return getBeneficiarySuccessState
                      .beneficiaryModel.items.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CustomText(
                              text: "Beneficiaries",
                              size: 12,
                              color: !theme.isDark
                                  ? AppColors.darkModeBackgroundSubTextColor
                                  : AppColors.lightPrimary,
                            ),
                          ),
                          Container(
                            height: 70,
                            child: ListView.builder(
                              itemCount: getBeneficiarySuccessState
                                  .beneficiaryModel.items.length,
                              padding: EdgeInsets.zero,
                              //controller: ScrollController(),
                              addAutomaticKeepAlives: true,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return serviceItem(
                                    getBeneficiarySuccessState
                                        .beneficiaryModel.items[index],
                                    theme,
                                    context);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox();
            case BeneficiaryLoadingState:
              return _loadingBeneficiaries();
            default:
              return _loadingBeneficiaries();
          }
        });
  }

  Widget serviceItem(Item item, AdaptiveThemeMode theme, context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          print(item.requiredFields);
          widget.beneficiaryNum(item.requiredFields.meterNumber ??
              item.requiredFields.cardNumber ??
              item.requiredFields.phoneNumber ??
              '');
          //widget.onBeneficiarySelectedRequiredFields!(item.requiredFields);
        });
        // if (widget.onBeneficiarySelectedRequiredFields != null) {
        //   if (beneficiary.ProductType == 'tv') {
        //     widget.onBeneficiarySelected!(beneficiary.smartcardNumber);
        //   } else if (beneficiary.ProductType.toLowerCase()
        //       .contains('electricity')) {
        //     widget.onBeneficiarySelected!(beneficiary.meterNumber);
        //   } else {
        //     widget.onBeneficiarySelected!(beneficiary.phone);
        //   } // Pass the selected phone number
        // }
      },
      onLongPress: () {
        showDeleteModal(context: context, beneficiaryId: item.id);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.appBarMainColor.withOpacity(0.1),
              child: Image.network(item.product.image),
            ),
            const SizedBox(height: 5),
            CustomText(
              text: item.fullName,
              color: !theme.isDark
                  ? AppColors.darkModeBackgroundColor
                  : AppColors.lightPrimary,
              size: 12,
            )
          ],
        ),
      ),
    );
  }

  Widget _loadingBeneficiaries() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        //physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)))),
                  const SizedBox(height: 5),
                  Shimmer(
                    duration: const Duration(seconds: 1),
                    interval: const Duration(milliseconds: 50),
                    color: Colors.grey.withOpacity(0.5),
                    colorOpacity: 0.5,
                    enabled: true,
                    direction: ShimmerDirection.fromLTRB(),
                    child: Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  )
                ],
              ));
        },
      ),
    );
  }

  Future<bool?> showDeleteModal({
    required BuildContext context,
    required beneficiaryId,
  }) {
    final theme =
        Provider.of<CustomThemeState>(context, listen: false).adaptiveThemeMode;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: theme.isDark
                  ? AppColors.darkModeBackgroundColor
                  : AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: theme.isDark
                            ? AppColors.darkModeBackgroundColor
                            : AppColors.white,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 0, // Adjust position as needed
                            left: 0,
                            right: 0,
                            child: SvgPicture.asset(
                              AppIcons.billTopBackground,
                              height: 60,
                              // Increase height to fit the text
                              width: AppUtils.deviceScreenSize(context).width,
                              color: AppColors.darkGreen,
                              // Set the color if needed
                              placeholderBuilder: (context) {
                                return Container(
                                  height: 50,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 10, // Adjust position as needed
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextStyles.textHeadings(
                                  textValue: 'Delete Beneficiary',
                                  textColor: AppColors.darkGreen,
                                  // w: FontWeight.w600,
                                  textSize: 14,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomText(
                    text: 'Are you sure you want to delete this beneficiary?',
                    maxLines: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FormButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: "Cancel",
                        bgColor: AppColors.red,
                        width: 100,
                        borderRadius: 10,
                      ),
                      FormButton(
                        onPressed: () {
                          Navigator.pop(context);
                          productBloc
                              .add(DeleteBeneficiaryEvent(beneficiaryId,widget.productId));
                        },
                        width: 100,
                        bgColor: AppColors.green,
                        text: "Ok",
                        borderRadius: 10,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
