import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/view/widgets/form_button.dart';

import '../../../bloc/app_bloc/app_bloc.dart';
import '../../../model/personal_profile.dart';
import '../../../model/user.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../../utills/constants/loading_dialog.dart';
import '../../../utills/custom_theme.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/custom_container.dart';

class ProfileDetails extends StatefulWidget {
  ProfileDetails({
    super.key,
  });

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<AppBloc>().add(InitialEvent());

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      backgroundColor: theme.isDark?AppColors.darkModeBackgroundColor:AppColors.lightPrimary,

      body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              print(state);
              print(state);
              print(state);
              print(state);
              print(state);
              print(state);
              if (state is SuccessState) {
                PersonalInfo personalInfo = state.customerProfile.personalInfo;
                print(json.encode(state.customerProfile));
                // Use user data here
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const CustomAppBar(
                          title: "Profile Details",
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomContainerWithIcon(
                            title: personalInfo.lastName,
                            iconData: SvgPicture.asset(AppIcons.person),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomContainerWithIcon(
                            title: personalInfo.firstName,
                            iconData: SvgPicture.asset(AppIcons.person),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomContainerWithIcon(
                            title: personalInfo.middleName,
                            iconData: SvgPicture.asset(AppIcons.person),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomContainerWithIcon(
                            title: personalInfo.email,
                            iconData: SvgPicture.asset(AppIcons.email),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomContainerWithIcon(
                            title: personalInfo.phone,
                            iconData: SvgPicture.asset(AppIcons.phone),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                      child: FormButton(
                          onPressed: () {},
                          text: "Update Profile",
                          bgColor: AppColors.green,
                          borderRadius: 12),
                    )
                  ],
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      children: [
                        CustomAppBar(
                          title: "Profile Details",
                        ),
                        SizedBox(height: 100,),
                        LoadingDialog("Fetching profile details")
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                      child: FormButton(
                        onPressed: () {},
                        text: "Update Profile",
                        bgColor: AppColors.grey,
                        borderRadius: 12,
                        disableButton: true,
                      ),
                    )
                  ],
                ); // Show loading indicator or handle error state
              }
            },
          )),
    );
  }
}
