import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_images.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/tella_rewards/reward_rules/tella_reward_rules.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/tella_rewards/tella_point_product_container.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';

import '../../../../bloc/app_bloc/app_bloc.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_icons.dart';
import '../../../../utills/custom_theme.dart';

class TellaManagePoint extends StatefulWidget {
  const TellaManagePoint({super.key});

  @override
  State<TellaManagePoint> createState() => _TellaManagePointState();
}

class _TellaManagePointState extends State<TellaManagePoint> {
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
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
             const TellaPointProductContainer(allowClick: false, showForwardIcon: false,),
            const SizedBox(
              height: 20,
            ),
            TextStyles.textHeadings(
                textValue: 'Tella Point Rules\n',
                textSize: 15,
                textColor: theme.isDark ? AppColors.white : AppColors.black),
            RewardRulesScreen()
          ],
        ),
      ),
    );
  }
}
