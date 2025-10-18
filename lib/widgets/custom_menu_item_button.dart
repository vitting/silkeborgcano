import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class CustomMenuItemButton extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onPressed;
  final String text;
  const CustomMenuItemButton({super.key, this.icon, this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: MenuItemButton(
        leadingIcon: icon != null ? CustomIcon(icon!) : null,
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.borderSize)),
          ),
          alignment: Alignment.center,
          backgroundColor: WidgetStateColor.resolveWith((states) {
            return AppColors.floatingActionButton;
          }),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: CustomText(data: text, size: CustomTextSize.ms),
      ),
    );
  }
}
