import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../res/app_colors.dart';
import 'app_custom_text.dart';

class CustomContainerFirTitleDesc extends StatelessWidget {
  final String title;
  final String description;

  const CustomContainerFirTitleDesc(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.grey)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    weight: FontWeight.bold,
                  ),
                  CustomText(
                    text: description,
                  )
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomContainerForToggle extends StatelessWidget {
  final String title;
  final String description;
  final bool isSwitched;
  final Function(bool) toggleSwitch;

  const CustomContainerForToggle(
      {super.key,
      required this.title,
      required this.description,
      required this.isSwitched,
      required this.toggleSwitch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.lightPrimary,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.grey)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    weight: FontWeight.bold,
                  ),
                  CustomText(
                    text: description,
                    maxLines: 3,
                    size: 14,
                  ),
                ],
              ),
              Switch(
                value: isSwitched,
                onChanged: toggleSwitch,
                activeTrackColor: AppColors.lightShadowGreenColor,
                activeColor: AppColors.green,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomContainerWithIcon extends StatelessWidget {
  final String title;
  final Widget iconData;

  const CustomContainerWithIcon({
    super.key,
    required this.title,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.lightPrimary,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.grey)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconData,
              const SizedBox(
                width: 15,
              ),
              CustomText(
                text: title,
                weight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
