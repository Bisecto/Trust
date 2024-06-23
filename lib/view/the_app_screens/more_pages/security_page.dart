import 'package:flutter/material.dart';
import 'package:teller_trust/res/app_colors.dart';

import '../../../res/app_icons.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/custom_container.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  bool isSwitched = false
  ;

  void _toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          const CustomAppBar(title: "Security",),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const CustomContainerFirTitleDesc(
                    title: "Transaction PIN",
                    description: "Secure all transactions"),
                CustomContainerForToggle(
                  title: "Face ID",
                  description:
                  "Account name, email, phone",
                  isSwitched: isSwitched,
                  toggleSwitch: _toggleSwitch,
                ),

              ],
            ),
          )

        ],
      ),
    );
  }
}
