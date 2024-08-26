import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/repository/app_repository.dart';
import 'package:teller_trust/view/widgets/drop_down.dart';
import 'package:teller_trust/view/widgets/form_button.dart';

import '../../../bloc/app_bloc/app_bloc.dart';
import '../../../model/personal_profile.dart';
import '../../../res/apis.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/app_validator.dart';
import '../../../utills/constants/loading_dialog.dart';
import '../../../utills/custom_theme.dart';
import '../../../utills/enums/toast_mesage.dart';
import '../../../utills/shared_preferences.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/form_input.dart';
import '../../widgets/show_toast.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({
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

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstnameCOntroller = TextEditingController();
  final _lastnameCOntroller = TextEditingController();
  final _middlenameCOntroller = TextEditingController();
  final _phoneController = TextEditingController();
  XFile? profileImage;
  bool readOnly = true;
  String gender = '';

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      backgroundColor: theme.isDark
          ? AppColors.darkModeBackgroundColor
          : AppColors.lightPrimary,
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
                _emailController.text = personalInfo.email;
                _firstnameCOntroller.text = personalInfo.firstName;
                _lastnameCOntroller.text = personalInfo.lastName;
                _phoneController.text = personalInfo.phone;
                _middlenameCOntroller.text = personalInfo.middleName;
                gender=personalInfo.gender??'Select Gender';
                print(json.encode(state.customerProfile));
                // Use user data here
                return Padding(
                  padding: const EdgeInsets.all(0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const CustomAppBar(
                              title: "Profile Details",
                            ),

                            GestureDetector(
                              onTap: () async {
                                final pickedImage = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedImage != null) {
                                  setState(() {
                                    profileImage = pickedImage;
                                  });
                                }
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: profileImage != null
                                    ? FileImage(File(profileImage!.path))
                                    : NetworkImage(personalInfo.imageUrl)
                                        as ImageProvider,
                                onBackgroundImageError:
                                    (Object exception, StackTrace? stackTrace) {
                                  AppUtils().debuglog(stackTrace);
                                },
                                child: readOnly
                                    ? Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: 50,
                                          width: 100,
                                          decoration: const BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(50),
                                                  bottomRight:
                                                      Radius.circular(50))),
                                          child: const Center(
                                            child: CustomText(
                                              text: 'Change',
                                              color: AppColors.green,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Form(
                                  key: _formKey,
                                  child: Column(children: [
                                    const SizedBox(height: 10,),

                                    CustomTextFormField(
                                      hint: 'E.g. John',
                                      label: 'First name',
                                      enabled: false,
                                      controller: _firstnameCOntroller,
                                      validator: (inputValue) {
                                        if (inputValue == null ||
                                            inputValue.isEmpty) {
                                          return 'First Name field is required';
                                        } else if (!RegExp(r"^[\p{L} ,.'-]*$",
                                                caseSensitive: false,
                                                unicode: true,
                                                dotAll: true)
                                            .hasMatch(inputValue.toString())) {
                                          return 'Incorrect name format';
                                        }
                                        return null;
                                      },
                                      widget: const Icon(Icons.email),
                                      borderColor:
                                          _firstnameCOntroller.text.isNotEmpty
                                              ? AppColors.green
                                              : AppColors.grey,
                                    ),
                                    const SizedBox(height: 10,),

                                    CustomTextFormField(
                                      hint: 'E.g. Doe',
                                      label: 'Last name',
                                      enabled: false,
                                      controller: _lastnameCOntroller,
                                      validator: (inputValue) {
                                        if (inputValue == null ||
                                            inputValue.isEmpty) {
                                          return 'Last Name field is required';
                                        } else if (!RegExp(r"^[\p{L} ,.'-]*$",
                                                caseSensitive: false,
                                                unicode: true,
                                                dotAll: true)
                                            .hasMatch(inputValue.toString())) {
                                          return 'Incorrect name format';
                                        }
                                        return null;
                                      },
                                      widget: const Icon(Icons.email),
                                      borderColor:
                                          _lastnameCOntroller.text.isNotEmpty
                                              ? AppColors.green
                                              : AppColors.grey,
                                    ),
                                    const SizedBox(height: 10,),

                                    CustomTextFormField(
                                      hint: 'middle name',
                                      label: 'Middle name',
                                      enabled: readOnly,
                                      controller: _middlenameCOntroller,
                                      validator: (inputValue) {
                                        if (inputValue == null ||
                                            inputValue.isEmpty) {
                                          return 'Middle Name field is required';
                                        } else if (!RegExp(r"^[\p{L} ,.'-]*$",
                                                caseSensitive: false,
                                                unicode: true,
                                                dotAll: true)
                                            .hasMatch(inputValue.toString())) {
                                          return 'Incorrect name format';
                                        }
                                        return null;
                                      },
                                      widget: const Icon(Icons.person),
                                      borderColor:
                                          _middlenameCOntroller.text.isNotEmpty
                                              ? AppColors.green
                                              : AppColors.grey,
                                    ),
                                    const SizedBox(height: 10,),
                                    DropDown(
                                      items: const [
                                        "Male",
                                        "Female",
                                        "Rather not say"
                                      ],
                                      label: 'Gender',
                                      selectedValue: gender,
                                    ),
                                    const SizedBox(height: 10,),

                                    CustomTextFormField(
                                      hint: 'example@gmail.com',
                                      label: 'Email Address',
                                      enabled: false,
                                      controller: _emailController,
                                      validator: (inputValue) {
                                        if (inputValue == null ||
                                            inputValue.isEmpty) {
                                          return 'field is required';
                                        }
                                        if (!RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_'{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(inputValue)) {
                                          return 'incorrect email format';
                                        }
                                        return null;
                                      },
                                      widget: const Icon(Icons.email),
                                      borderColor:
                                          _emailController.text.isNotEmpty
                                              ? AppColors.green
                                              : AppColors.grey,
                                    ),
                                    const SizedBox(height: 10,),

                                    CustomTextFormField(
                                      hint: 'Phone number',
                                      label: 'Phone number',
                                      enabled: false,
                                      controller: _phoneController,
                                      textInputType: TextInputType.number,
                                      // validator: AppValidator.validateTextfield(),
                                      widget: const Icon(Icons.email),
                                      borderColor:
                                          _phoneController.text.isNotEmpty
                                              ? AppColors.green
                                              : AppColors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 30),
                                      child: FormButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (_) {
                                                    return const LoadingDialog(
                                                        'Processing...');
                                                  });
                                              AppRepository repository =
                                                  AppRepository();

                                              String accessToken =
                                                  await SharedPref.getString(
                                                      "access_token");

                                              Map<String, dynamic> requestData = {
                                                'middleName':
                                                    _middlenameCOntroller.text,
                                                'gender': gender,
                                              };
                                              AppUtils().debuglog(requestData);
                                              try {
                                                var response = await repository
                                                    .appPutRequestWithSingleImages(
                                                        accessToken: accessToken,
                                                        requestData,
                                                        '${AppApis.appBaseUrl}/user/c/update-profile',
                                                        profileImage);

                                                if (response.statusCode == 200 ||
                                                    response.statusCode == 201) {
                                                  await refresh();
                                                  await SharedPref.putString(
                                                      "firstname",
                                                      _firstnameCOntroller.text);
                                                  await SharedPref.putString(
                                                      "lastname",
                                                      _lastnameCOntroller.text);

                                                  Navigator.pop(context);
                                                  showToast(
                                                      context: context,
                                                      title: 'Successful',
                                                      subtitle:
                                                          "Profile update was successful",
                                                      type: ToastMessageType
                                                          .success);
                                                  setState(() {
                                                    readOnly = true;
                                                  });
                                                  //emit(GiftCardPurchaseSuccess());
                                                } else {
                                                  AppUtils()
                                                      .debuglog("Starting 4");

                                                  Navigator.pop(context);
                                                  showToast(
                                                      context: context,
                                                      title: 'Error',
                                                      subtitle:
                                                          AppUtils.convertString(
                                                              json.decode(response
                                                                      .body)[
                                                                  'message']),
                                                      type:
                                                          ToastMessageType.info);
                                                }
                                              } on SocketException {
                                                Navigator.pop(context);
                                                showToast(
                                                    context: context,
                                                    title: 'Error',
                                                    subtitle:
                                                        "Network error: Unable to connect. Please check your internet connection.",
                                                    type: ToastMessageType.info);
                                              } on HttpException {
                                                Navigator.pop(context);
                                                showToast(
                                                    context: context,
                                                    title: 'Error',
                                                    subtitle:
                                                        "Server error: Unable to communicate with the server.",
                                                    type: ToastMessageType.info);
                                              } on FormatException {
                                                Navigator.pop(context);
                                                showToast(
                                                    context: context,
                                                    title: 'Error',
                                                    subtitle:
                                                        "Data error: Received data is in an unexpected format.",
                                                    type: ToastMessageType.info);
                                              } catch (e) {
                                                AppUtils().debuglog(e);
                                                Navigator.pop(context);
                                                showToast(
                                                    context: context,
                                                    title: 'Error',
                                                    subtitle:
                                                        "There was a problem updating profile please try again.",
                                                    type: ToastMessageType.info);
                                              }
                                            }
                                          },
                                          text: "Update Profile",
                                          bgColor: AppColors.green,
                                          borderRadius: 12),
                                    )
                                  ])),
                            )
                            // Padding(
                            //   padding: const EdgeInsets.all(10.0),
                            //   child: CustomContainerWithIcon(
                            //     title: personalInfo.lastName,
                            //     iconData: SvgPicture.asset(AppIcons.person),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(10.0),
                            //   child: CustomContainerWithIcon(
                            //     title: personalInfo.firstName,
                            //     iconData: SvgPicture.asset(AppIcons.person),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(10.0),
                            //   child: CustomContainerWithIcon(
                            //     title: personalInfo.middleName,
                            //     iconData: SvgPicture.asset(AppIcons.person),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(10.0),
                            //   child: CustomContainerWithIcon(
                            //     title: personalInfo.email,
                            //     iconData: SvgPicture.asset(AppIcons.email),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(10.0),
                            //   child: CustomContainerWithIcon(
                            //     title: personalInfo.phone,
                            //     iconData: SvgPicture.asset(AppIcons.phone),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                        SizedBox(
                          height: 100,
                        ),
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

  Future<void> refresh() async {
    context.read<AppBloc>().add(InitialEvent());

    // why use freshNumbers var? https://stackoverflow.com/a/52992836/2301224
  }
}
