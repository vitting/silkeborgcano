import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_icon_button.dart';

class CustomMenuAnchor extends StatelessWidget {
  final List<Widget> menuChildren;
  final IconData icon;
  const CustomMenuAnchor({super.key, required this.menuChildren, this.icon = Symbols.menu});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
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
        );
      },
    );
  }
}
