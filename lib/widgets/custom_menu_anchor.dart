import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';
import 'package:silkeborgcano/widgets/custom_icon_button.dart';

class CustomMenuAnchor extends StatelessWidget {
  final List<Widget> menuChildren;
  final IconData icon;
  const CustomMenuAnchor({super.key, required this.menuChildren, this.icon = Symbols.menu});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        shape: WidgetStateOutlinedBorder.resolveWith((states) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderSize),
            side: BorderSide(color: AppColors.dialogBorderColor, width: 1),
          );
        }),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(AppSizes.s)),
        backgroundColor: WidgetStateColor.resolveWith((states) {
          return AppColors.dialogBackgroundColor;
        }),
      ),
      menuChildren: menuChildren,
      builder: (context, controller, child) {
        return CustomIconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: icon,
          size: CustomIconSize.s,
        );
      },
    );
  }
}
