import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class CustomCountCircle extends StatelessWidget {
  final int count;
  const CustomCountCircle({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.m,
      height: AppSizes.m,
      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.countCircleBackgroundColor),
      child: Center(child: CustomText(count.toString())),
    );
  }
}
