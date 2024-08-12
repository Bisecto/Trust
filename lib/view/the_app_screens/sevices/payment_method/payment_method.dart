import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/model/wallet_info.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import 'package:teller_trust/view/widgets/form_button.dart';
import '../../../../bloc/app_bloc/app_bloc.dart';
import '../../../../res/app_icons.dart';
import '../../../../res/app_images.dart';
import '../../../../utills/app_utils.dart';
import '../../../../utills/custom_theme.dart';
import '../../../widgets/form_input.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String amtToPay;
  final ValueChanged<String> onPaymentMethodSelected;
  final ValueChanged<bool> ispaymentAllowed;
  final ValueChanged<String> name;
  final ValueChanged<bool> isSaveAsBeneficiarySelected;

  final String number;
  final bool showAddBeneficiary;

  const PaymentMethodScreen({
    super.key,
    required this.amtToPay,
    required this.onPaymentMethodSelected,
    required this.ispaymentAllowed,
    required this.isSaveAsBeneficiarySelected,
    required this.name,
    required this.number,
    this.showAddBeneficiary=true
  });

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedPaymentMethod = 'wallet';
  bool _saveAsBeneficiary = false;
  bool _ispaymentAllowed = false;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AppBloc>().add(InitialEvent());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onPaymentMethodSelected(_selectedPaymentMethod);
      widget.ispaymentAllowed(_ispaymentAllowed);
      print(_phoneController.text == (widget.number));
      print(widget.number);
      print(_phoneController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Choose Payment Method',
            // style: TextStyle(
            //   fontSize: 12,
            //   fontWeight: FontWeight.bold,
            //   color: Colors.grey[700],
            // ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              if (state is SuccessState) {
                WalletInfo walletInfo = state.customerProfile.walletInfo;
                _deferredUpdatePaymentAllowed(walletInfo);
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          _onPaymentMethodChanged('wallet', walletInfo),
                      child: _buildPaymentOption(
                        title: 'Wallet Balance',
                        subtitle:
                            'Acct. Number ${state.customerProfile.customerAccount!.nuban}',
                        trailing: CustomText(
                          text: 'NGN${walletInfo.balance}',
                          weight: FontWeight.bold,
                          size: 12,
                          // style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        selected: _selectedPaymentMethod == 'wallet',
                        onChanged: () =>
                            _onPaymentMethodChanged('wallet', walletInfo),
                        additionalInfo: _selectedPaymentMethod == 'wallet' &&
                                double.parse(widget.amtToPay) >
                                    double.parse(walletInfo.balance.toString())
                            ? const Padding(
                                padding: EdgeInsets.only(left: 16, top: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      color: Colors.orange,
                                      size: 10,
                                    ),
                                    SizedBox(width: 4),
                                    CustomText(
                                      text:
                                          'Insufficient Funds. Fund your wallet to enjoy benefits',
                                      weight: FontWeight.bold,
                                      size: 10,
                                      color: AppColors.orange,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPaymentOption(
                      title: 'Pay Using Quick Pay',
                      selected: _selectedPaymentMethod == 'quick_pay',
                      onChanged: () =>
                          _onPaymentMethodChanged('quick_pay', walletInfo),
                    ),
                    if (widget.number != '') const SizedBox(height: 24),
                    if (widget.number != ''&&widget.showAddBeneficiary)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            text: 'Save as Beneficiary',
                            size: 14,
                            weight: FontWeight.bold,
                          ),
                          Switch(
                            value: _saveAsBeneficiary,
                            onChanged: (value) {
                              _deferredUpdateselectedBeneficiary(widget.number);
                              setState(() {
                                _saveAsBeneficiary = value;
                              });
                              if (value) {
                                showInputField(context: context);
                              } else {
                                Future.microtask(() {
                                  if (mounted) {
                                    setState(() {
                                      _saveAsBeneficiary = false;
                                      widget.isSaveAsBeneficiarySelected(false);
                                      widget.name('');
                                    });
                                  }
                                });
                              }
                            },
                            activeColor: Colors.green,
                          ),
                        ],
                      ),
                  ],
                );
              } else {
                return const Center(
                  child: CustomText(text: "Loading....."),
                ); // Show loading indicator or handle error state
              }
            },
          ),
        ],
      ),
    );
  }

  void _deferredUpdateselectedBeneficiary(String data) {
    // Deferred update to avoid state changes during build phase
    Future.microtask(() {
      if (mounted) {
        if (widget.number != '') {
          setState(() {
            _phoneController.text = widget.number;
          });
        }
      }
    });
  }

  void _deferredUpdatePaymentAllowed(WalletInfo walletInfo) {
    // Deferred update to avoid state changes during build phase
    Future.microtask(() {
      if (mounted) {
        if (widget.amtToPay != '0') {
          if (_selectedPaymentMethod == 'wallet') {
            if (double.parse(walletInfo.balance.toString()) >=
                double.parse(widget.amtToPay)) {
              setState(() {
                _ispaymentAllowed = true;
                widget.ispaymentAllowed(_ispaymentAllowed);
              });
            } else {
              setState(() {
                _ispaymentAllowed = false;
                widget.ispaymentAllowed(_ispaymentAllowed);
              });
            }
            // setState(() {
            //   _ispaymentAllowed = _selectedPaymentMethod != 'wallet' ||
            //       double.parse(walletInfo.balance.toString()) >=
            //           double.parse(widget.amtToPay);
            //   widget.ispaymentAllowed(_ispaymentAllowed);
            // });
          } else {
            setState(() {
              _ispaymentAllowed = true;
              widget.ispaymentAllowed(_ispaymentAllowed);
            });
          }
        } else {
          setState(() {
            _ispaymentAllowed = false;
            widget.ispaymentAllowed(_ispaymentAllowed);
          });
        }
      }
    });
  }

  Future<bool?> showInputField({
    required BuildContext context,
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
            height: 400,
            decoration: BoxDecoration(
              color: theme.isDark
                  ? AppColors.darkModeBackgroundColor
                  : AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
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
                                  textValue: 'Beneficiary',
                                  textColor: AppColors.darkGreen,
                                  // w: FontWeight.w600,
                                  textSize: 14,
                                ),
                                // Text(
                                //   "Airtime purchase",
                                //   style: TextStyle(
                                //     color: AppColors.darkGreen,
                                //     fontWeight: FontWeight.w600,
                                //     fontSize: 18,
                                //   ),
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Future.microtask(() {
                                      if (mounted) {
                                        setState(() {
                                          _saveAsBeneficiary = false;
                                          widget.isSaveAsBeneficiarySelected(
                                              false);
                                          widget.name('');
                                        });
                                      }
                                    });
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
                  Column(
                    children: [
                      CustomTextFormField(
                        hint: 'Input Name of Beneficiary',
                        label: '',
                        controller: _nameController,
                        textInputType: TextInputType.text,
                        onChanged: (value) async {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter beneficiary name';
                          }
                          return null;
                        },
                        borderColor: _nameController.text.isNotEmpty
                            ? AppColors.green
                            : AppColors.grey,
                        widget: SvgPicture.asset(
                          AppIcons.person,
                          color: _nameController.text.isNotEmpty
                              ? AppColors.green
                              : AppColors.grey,
                        ),
                      ),
                      CustomTextFormField(
                        hint: '',
                        label: '',
                        enabled: false,
                        controller: _phoneController,
                        textInputType: TextInputType.number,
                        onChanged: (value) async {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter beneficiary name';
                          }
                          return null;
                        },
                        borderColor: _phoneController.text.isNotEmpty
                            ? AppColors.green
                            : AppColors.grey,
                        widget: const Icon(Icons.person),
                      ),
                      FormButton(
                        onPressed: () {
                          if (_nameController.text.isNotEmpty) {
                            Future.microtask(() {
                              if (mounted) {
                                widget.isSaveAsBeneficiarySelected(true);
                                widget.name(_nameController.text);
                              }
                            });
                          } else {
                            Future.microtask(() {
                              if (mounted) {
                                setState(() {
                                  _saveAsBeneficiary = false;
                                  widget.isSaveAsBeneficiarySelected(false);
                                  widget.name('');
                                });
                              }
                            });
                          }
                          Navigator.pop(context);
                        },
                        text: "Save",
                        borderRadius: 10,
                      )
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

  Widget _buildPaymentOption({
    required String title,
    String? subtitle,
    Widget? trailing,
    required bool selected,
    required VoidCallback onChanged,
    Widget? additionalInfo,
  }) {
    return GestureDetector(
      onTap: onChanged,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio(
                  value: selected,
                  groupValue: true,
                  onChanged: (value) => onChanged(),
                  activeColor: Colors.blue,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
            if (additionalInfo != null) additionalInfo,
          ],
        ),
      ),
    );
  }

  void _onPaymentMethodChanged(String method, WalletInfo walletInfo) {
    setState(() {
      _selectedPaymentMethod = method;
      _deferredUpdatePaymentAllowed(walletInfo);
    });
    widget.onPaymentMethodSelected(method);
  }
}
