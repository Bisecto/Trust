// import 'package:adaptive_theme/adaptive_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:nicetel/bloc/bill_bloc/bill_bloc.dart';
// import 'package:nicetel/model/beneficiary_model.dart';
// import 'package:nicetel/res/app_images.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer_animation/shimmer_animation.dart';
//
// import '../../../model/service.dart';
// import '../../../res/app_colors.dart';
// import '../../../res/app_enums.dart';
// import '../../../utills/custom_theme.dart';
// import '../../important_pages/dialog_box.dart';
// import '../../widgets/app_custom_text.dart';
//
// class BillBeneficiary extends StatefulWidget {
//   String billType;
//   final Function(String)? onBeneficiarySelected;
//
//   BillBeneficiary(
//       {super.key, required this.billType, this.onBeneficiarySelected});
//
//   @override
//   State<BillBeneficiary> createState() => _BillBeneficiaryState();
// }
//
// class _BillBeneficiaryState extends State<BillBeneficiary> {
//   BillBloc billBloc = BillBloc();
//
//   @override
//   void initState() {
//     // TODO: implement initState'
//     billBloc.add(InitialEvent(widget.billType));
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
//
//     return BlocConsumer<BillBloc, BillState>(
//         bloc: billBloc,
//         //listenWhen: (previous, current) => current is! InitialEvent,
//         buildWhen: (previous, current) => current is! InitialEvent,
//         listener: (context, state) async {
//           if (state is ErrorState) {
//             showToast(
//                 context: context,
//                 title: 'Error',
//                 subtitle: "There was a problem fetching beneficiary",
//                 type: ToastMessageType.error);
//           }
//         },
//         builder: (context, state) {
//           switch (state.runtimeType) {
//           // case PostsFetchingState:
//           //   return const Center(
//           //     child: CircularProgressIndicator(),
//           //   );
//
//             case GetBeneficiarySuccessState:
//               final getBeneficiarySuccessState =
//               state as GetBeneficiarySuccessState;
//
//               return getBeneficiarySuccessState.beneficiaries.isNotEmpty
//                   ? Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: CustomText(
//                         text: "Choose Beneficiary",
//                         size: 14,
//                         color: !theme.isDark
//                             ? AppColors.darkBackgroundColor
//                             : AppColors.lightPrimary,
//                       ),
//                     ),
//                     ListView.builder(
//                       itemCount:
//                       getBeneficiarySuccessState.beneficiaries.length,
//                       padding: EdgeInsets.zero,
//                       //controller: ScrollController(),
//                       addAutomaticKeepAlives: true,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       scrollDirection: Axis.vertical,
//                       itemBuilder: (BuildContext context, int index) {
//                         return serviceItem(
//                             getBeneficiarySuccessState
//                                 .beneficiaries[index],
//                             theme);
//                       },
//                     ),
//                   ],
//                 ),
//               )
//                   : SizedBox();
//             case BeneficiaryLoadingState:
//               return _loadingBeneficiaries();
//             default:
//               return _loadingBeneficiaries();
//           }
//         });
//   }
//
//   Widget serviceItem(BeneficiaryModel beneficiary, AdaptiveThemeMode theme) {
//     return GestureDetector(
//       onTap: () {
//         if (widget.onBeneficiarySelected != null) {
//           if(beneficiary.billType=='tv'){
//             widget.onBeneficiarySelected!(
//                 beneficiary.smartcardNumber);
//           }else if(beneficiary.billType.toLowerCase().contains('electricity')){
//             widget.onBeneficiarySelected!(
//                 beneficiary.meterNumber);
//           }else{
//             widget.onBeneficiarySelected!(
//                 beneficiary.phone); }// Pass the selected phone number
//         }
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: 25,
//               backgroundColor: AppColors.mainAppColor.withOpacity(0.1),
//               child: SvgPicture.asset(beneficiary.billType == 'tv'
//                   ? beneficiary.smartcardNumber
//                   : (beneficiary.billType.toLowerCase().contains('electricity')
//                   ? beneficiary.meterNumber
//                   : beneficiary.phone)),
//             ),
//             const SizedBox(height: 5),
//             CustomText(
//               text: beneficiary.billType == 'tv'
//                   ? AppSvgImages.monitor
//                   : (beneficiary.billType.toLowerCase().contains('electricity')
//                   ? AppSvgImages.flash
//                   : AppSvgImages.mobile),
//               color: !theme.isDark
//                   ? AppColors.darkBackgroundColor
//                   : AppColors.lightPrimary,
//               size: 12,
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _loadingBeneficiaries() {
//     return SizedBox(
//       height: 90,
//       child: ListView.builder(
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         //physics: const NeverScrollableScrollPhysics(),
//         padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
//         itemCount: 10,
//         itemBuilder: (BuildContext context, int index) {
//           return Padding(
//               padding: const EdgeInsets.only(right: 10.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                       height: 50,
//                       width: 50,
//                       decoration: BoxDecoration(
//                           color: Colors.grey.withOpacity(0.2),
//                           borderRadius:
//                           const BorderRadius.all(Radius.circular(50)))),
//                   const SizedBox(height: 10),
//                   Shimmer(
//                     duration: const Duration(seconds: 1),
//                     interval: const Duration(milliseconds: 50),
//                     color: Colors.grey.withOpacity(0.5),
//                     colorOpacity: 0.5,
//                     enabled: true,
//                     direction: const ShimmerDirection.fromLTRB(),
//                     child: Container(
//                       height: 10,
//                       width: 50,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Shimmer(
//                     duration: const Duration(seconds: 1),
//                     interval: const Duration(milliseconds: 50),
//                     color: Colors.grey.withOpacity(0.5),
//                     colorOpacity: 0.5,
//                     enabled: true,
//                     direction: ShimmerDirection.fromLTRB(),
//                     child: Container(
//                       height: 5,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.2),
//                       ),
//                     ),
//                   )
//                 ],
//               ));
//         },
//       ),
//     );
//   }
// }
