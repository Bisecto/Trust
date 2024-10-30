import 'package:flutter/material.dart';
import 'package:teller_trust/view/widgets/form_input.dart';

import '../sevices/product_beneficiary/product_beneficiary.dart';
import 'beneficiary_app_bar.dart';

class Beneficiaries extends StatefulWidget {
  const Beneficiaries({super.key});

  @override
  State<Beneficiaries> createState() => _BeneficiariesState();
}

class _BeneficiariesState extends State<Beneficiaries> {
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BeneficiaryCustomAppBar(
            title: 'Beneficiaries',
            textFormField: CustomTextFormField(
                controller: searchTextEditingController,
                hint: 'Search',
                suffixIcon: Icon(Icons.search),
                borderRadius: 30,

                label: '',),
          ),
          BeneficiaryWidget(productId: '', beneficiaryNum: (String value) {  },isProductBeneficiary:false)
        ],
      ),
    );
  }
}
