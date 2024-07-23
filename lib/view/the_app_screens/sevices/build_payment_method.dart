import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teller_trust/model/wallet_info.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import '../../../bloc/app_bloc/app_bloc.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String amtToPay;
  final ValueChanged<String> onPaymentMethodSelected;
  final ValueChanged<bool> ispaymentAllowed;

  const PaymentMethodScreen({super.key, 
    required this.amtToPay,
    required this.onPaymentMethodSelected,
    required this.ispaymentAllowed,
  });

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedPaymentMethod = 'wallet';
  bool _saveAsBeneficiary = false;
  bool _ispaymentAllowed = false;

  @override
  void initState() {
    super.initState();
    context.read<AppBloc>().add(InitialEvent());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onPaymentMethodSelected(_selectedPaymentMethod);
      widget.ispaymentAllowed(_ispaymentAllowed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,5.0,0,16),
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
                        subtitle: 'Acct. Number *********',
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
                                padding:
                                    EdgeInsets.only(left: 16, top: 4),
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
                    const SizedBox(height: 24),
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
                            setState(() {
                              _saveAsBeneficiary = value;
                            });
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
