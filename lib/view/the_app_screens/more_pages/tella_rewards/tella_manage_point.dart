import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teller_trust/res/app_images.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/tella_rewards/tella_point_product_container.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';

import '../../../../res/app_colors.dart';
import '../../../../res/app_icons.dart';

class TellaManagePoint extends StatefulWidget {
  const TellaManagePoint({super.key});

  @override
  State<TellaManagePoint> createState() => _TellaManagePointState();
}

class _TellaManagePointState extends State<TellaManagePoint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
          ),
          TellaPointProductContainer(),
          SizedBox(
            height: 20,
          ),
          TextStyles.textHeadings(
              textValue: 'Tella Point Rules',
              textSize: 15,
              textColor: Colors.black)
        ],
      ),
    );
  }
}
