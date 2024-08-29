import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/repository/app_repository.dart';
import 'package:teller_trust/res/app_images.dart';
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
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final _formKey = GlobalKey<FormState>();
  final _imageController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _middlenameController = TextEditingController();
  final _initialMiddlenameController = TextEditingController();
  final _phoneController = TextEditingController();

  XFile? profileImage;
  bool readOnly = true;
  String gender = '';
  String selectedGender = '';

  @override
  void initState() {
    super.initState();
    context.read<AppBloc>().add(InitialEvent());
  }

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
            if (state is SuccessState) {
              PersonalInfo personalInfo = state.customerProfile.personalInfo;
              _emailController.text = personalInfo.email;
              _firstnameController.text = personalInfo.firstName;
              _lastnameController.text = personalInfo.lastName;
              _phoneController.text = personalInfo.phone;
              _initialMiddlenameController.text =personalInfo.middleName;
              gender = personalInfo.gender ?? '';

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomAppBar(
                      title: "Profile Details",
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () async {
                                final pickedImage = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedImage != null) {
                                  setState(() {
                                    profileImage = pickedImage;
                                    _imageController.text = profileImage!.name;
                                  });
                                }
                              },
                              child: CustomTextFormField(
                                hint: '',
                                label: 'Profile Picture',
                                enabled: false,
                                controller: _imageController,
                                widget: CircleAvatar(
                                  radius: 10,
                                  backgroundImage: profileImage != null
                                      ? FileImage(File(profileImage!.path))
                                      : NetworkImage(personalInfo.imageUrl)
                                          as ImageProvider,
                                  onBackgroundImageError: (Object exception,
                                      StackTrace? stackTrace) {
                                    AppUtils().debuglog(stackTrace);
                                  },
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 30,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: CustomText(
                                        text: 'Change',
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                borderColor: AppColors.green,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              hint: 'E.g. John',
                              label: 'Profile Details',
                              enabled: false,
                              controller: _firstnameController,
                              validator: (inputValue) {
                                if (inputValue == null || inputValue.isEmpty) {
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
                              widget: SvgPicture.asset(AppIcons.person),
                              borderColor: _firstnameController.text.isNotEmpty
                                  ? AppColors.green
                                  : AppColors.grey,
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              hint: 'E.g. Doe',
                              label: '',
                              enabled: false,
                              controller: _lastnameController,
                              validator: (inputValue) {
                                if (inputValue == null || inputValue.isEmpty) {
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
                              widget: SvgPicture.asset(AppIcons.person),
                              borderColor: _lastnameController.text.isNotEmpty
                                  ? AppColors.green
                                  : AppColors.grey,
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              hint: _initialMiddlenameController.text.isEmpty?'E.g. John':_initialMiddlenameController.text,
                              label: '',
                              enabled: _initialMiddlenameController.text.isEmpty
                                  ? true
                                  : false,
                              controller:
                                  _initialMiddlenameController.text.isEmpty
                                      ? _middlenameController
                                      : _initialMiddlenameController,
                              validator: (inputValue) {
                                if (inputValue == null || inputValue.isEmpty) {
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
                              widget: SvgPicture.asset(AppIcons.person),
                              borderColor:
                                  _initialMiddlenameController.text.isEmpty
                                      ? (_middlenameController.text.isNotEmpty
                                          ? AppColors.green
                                          : AppColors.grey)
                                      : AppColors.green,
                            ),
                            const SizedBox(height: 18),
                            DropDown(
                              items: const ["male", "female"],
                              borderRadius: 10,
                              label: 'Gender',
                              showLabel: false,
                              hint: "Select gender",
                              height: 50,
                              initialValue: gender,
                              borderColor: selectedGender.isNotEmpty
                                  ? AppColors.green
                                  : AppColors.textColor2,
                              selectedValue: selectedGender,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedGender = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            CustomTextFormField(
                              hint: 'example@gmail.com',
                              label: '',
                              enabled: false,
                              controller: _emailController,
                              validator: (inputValue) {
                                if (inputValue == null || inputValue.isEmpty) {
                                  return 'Email field is required';
                                }
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_'{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(inputValue)) {
                                  return 'Incorrect email format';
                                }
                                return null;
                              },
                              widget: SvgPicture.asset(AppIcons.email),
                              borderColor: _emailController.text.isNotEmpty
                                  ? AppColors.green
                                  : AppColors.grey,
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              hint: 'Phone number',
                              label: '',
                              enabled: false,
                              controller: _phoneController,
                              textInputType: TextInputType.number,
                              widget: SvgPicture.asset(AppIcons.phone),
                              borderColor: _phoneController.text.isNotEmpty
                                  ? AppColors.green
                                  : AppColors.grey,
                            ),
                            const SizedBox(height: 30),
                            FormButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (_) =>
                                        const LoadingDialog('Processing...'),
                                  );
                                  try {
                                    final response =
                                        await _updateProfile(personalInfo.id);
                                    if (response) {
                                      await refresh();
                                      Navigator.pop(context);
                                      showToast(
                                        context: context,
                                        title: 'Successful',
                                        subtitle:
                                            "Profile update was successful",
                                        type: ToastMessageType.success,
                                      );
                                      setState(() {
                                        readOnly = true;
                                      });
                                    }
                                  } catch (e) {
                                    Navigator.pop(context);
                                    showToast(
                                      context: context,
                                      title: 'Error',
                                      subtitle: e.toString(),
                                      type: ToastMessageType.info,
                                    );
                                  }
                                }
                              },
                              text: "Update Profile",
                              bgColor: AppColors.green,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is LoadingState) {
              return const Center(
                child: Column(

                  children: [
                    const CustomAppBar(
                      title: "Profile Details",
                    ),
                    LoadingDialog(""),
                  ],
                ),
              );
            } else if (state is ErrorState) {
              return const Center(
                child: Text("An error occurred. Please try again later."),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Future<void> refresh() async {
    context.read<AppBloc>().add(InitialEvent());
  }

  Future<bool> _updateProfile(id) async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return const LoadingDialog('Processing...');
        },
      );

      AppRepository repository = AppRepository();

      try {
        String accessToken = await SharedPref.getString("access-token");

        Map<String, dynamic> requestData = {
          'middleName': _middlenameController.text,
          'gender': selectedGender.toLowerCase(),
          'customerId': id
        };

        AppUtils().debuglog(requestData);

        var response = await repository.appPutRequestWithSingleImages(
          requestData,
          accessToken: accessToken,
          '${AppApis.appBaseUrl}/user/c/update-profile',
          profileImage,
        );
        Navigator.pop(context);

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Success
          await refresh();
          await SharedPref.putString("firstname", _firstnameController.text);
          await SharedPref.putString("lastname", _lastnameController.text);

          Navigator.pop(context);
          showToast(
            context: context,
            title: 'Successful',
            subtitle: "Profile update was successful",
            type: ToastMessageType.success,
          );
          setState(() {
            readOnly = true;
          });
          return true;
        } else {
          // Failure
          Navigator.pop(context);
          showToast(
            context: context,
            title: 'Error',
            subtitle:
                AppUtils.convertString(json.decode(response.body)['message']),
            type: ToastMessageType.info,
          );
          return false;
        }
      } on SocketException {
        Navigator.pop(context);
        showToast(
          context: context,
          title: 'Error',
          subtitle:
              "Network error: Unable to connect. Please check your internet connection.",
          type: ToastMessageType.info,
        );
        return false;
      } on HttpException {
        Navigator.pop(context);
        showToast(
          context: context,
          title: 'Error',
          subtitle: "Server error: Unable to communicate with the server.",
          type: ToastMessageType.info,
        );
        return false;
      } on FormatException {
        Navigator.pop(context);
        showToast(
          context: context,
          title: 'Error',
          subtitle: "Data error: Received data is in an unexpected format.",
          type: ToastMessageType.info,
        );
        return false;
      } catch (e) {
        AppUtils().debuglog(e);
        Navigator.pop(context);
        showToast(
          context: context,
          title: 'Error',
          subtitle: "There was a problem updating profile, please try again.",
          type: ToastMessageType.info,
        );
        return false;
      }
    } else {
      return false;
    }
  }
}
