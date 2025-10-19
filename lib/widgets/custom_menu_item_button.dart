import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class CustomMenuItemButton extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onPressed;
  final String text;
  final bool popMenuOnPressed;
  final bool selectedByColor;
  final bool selectedByCheckmark;
  const CustomMenuItemButton({
    super.key,
    this.icon,
    this.onPressed,
    required this.text,
    this.popMenuOnPressed = true,
    this.selectedByColor = false,
    this.selectedByCheckmark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,

      child: MenuItemButton(
        leadingIcon: icon != null
            ? CustomIcon(icon!)
            : selectedByCheckmark
            ? CustomIcon(Symbols.check)
            : null,
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.borderSize)),
          ),
          alignment: Alignment.center,
          backgroundColor: WidgetStateColor.resolveWith((states) {
            return selectedByColor ? AppColors.buttonSelectedBackgroundColor : AppColors.buttonBackgroundColor;
          }),
        ),
        onPressed: () {
          if (popMenuOnPressed) {
            Navigator.of(context).pop();
          }

          if (onPressed != null) {
            onPressed!();
          }
        },
        child: CustomText(data: text, size: CustomTextSize.ms),
      ),
    );
  }
}
