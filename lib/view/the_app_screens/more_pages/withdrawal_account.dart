import 'package:flutter/material.dart';
import 'package:pin_plus_keyboard/pin_plus_keyboard.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../../utills/app_validator.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/form_input.dart';

class WithdrawalAccount extends StatefulWidget {
  const WithdrawalAccount({super.key});

  @override
  State<WithdrawalAccount> createState() => _WithdrawalAccountState();
}

class _WithdrawalAccountState extends State<WithdrawalAccount> {
  final _bvmController = TextEditingController();
  final _accNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(
            title: AppIcons.withdrawalAccountAppbar,
          ),
          CustomTextFormField(
            hint: 'BVN',
            label: '',
            controller: _bvmController,
            validator: AppValidator.validateTextfield,
            icon: Icons.person_2_outlined,
            textInputType: TextInputType.number,
            borderColor: _bvmController.text.isNotEmpty
                ? AppColors.green
                : AppColors.grey,
          ),
          CustomTextFormField(
            hint: 'Account Number',
            label: '',
            textInputType: TextInputType.number,
            controller: _accNumberController,
            validator: AppValidator.validateAccountNumberfield,
            icon: Icons.person_2_outlined,
            borderColor: _accNumberController.text.isNotEmpty
                ? AppColors.green
                : AppColors.grey,
          ),
          CustomTextFormField(
            hint: 'Select Bank',
            label: '',
            textInputType: TextInputType.number,
            controller: _accNumberController,
            validator: AppValidator.validateAccountNumberfield,
            icon: Icons.currency_exchange,
            borderColor: _accNumberController.text.isNotEmpty
                ? AppColors.green
                : AppColors.grey,
          )
        ],
      ),
    );
  }
}
