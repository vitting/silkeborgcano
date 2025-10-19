import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class CustomPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const CustomPrimaryButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.borderSize)),
      ),
      onPressed: onPressed,
      child: CustomText(data: text, color: AppColors.white, letterSpacing: 1),
    );
  }
}
