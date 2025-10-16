import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_menu_model.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class CustomFloatingActionButtonWithMenu extends StatefulWidget {
  final Iterable<CustomFloatingActionButtonWithMenuModel> menuItems;
  const CustomFloatingActionButtonWithMenu({super.key, required this.menuItems});

  @override
  State<CustomFloatingActionButtonWithMenu> createState() => _CustomFloatingActionButtonWithMenuState();
}

class _CustomFloatingActionButtonWithMenuState extends State<CustomFloatingActionButtonWithMenu> {
  @override
  Widget build(BuildContext context) {
    // All this math is done to make sure that the menu items are centered above the FAB
    double widthOfScreen = MediaQuery.sizeOf(context).width;
    debugPrint('Width of screen: $widthOfScreen');
    if (widthOfScreen > 350) {
      widthOfScreen = 350;
    }

    double widthOfSizedBox = widthOfScreen - AppSizes.l;
    const double widthOfFloatingActionButton = 56;
    double widthOfMenuItemButton = (widthOfSizedBox / 2) - (widthOfFloatingActionButton / 2) + 8;
    return MenuAnchor(
      alignmentOffset: Offset(-widthOfMenuItemButton, 5),
      style: MenuStyle(
        backgroundColor: WidgetStateColor.resolveWith((state) => AppColors.black.withValues(alpha: 0.2)),
        shadowColor: WidgetStateColor.transparent,
        padding: WidgetStateProperty.all(EdgeInsets.all(8)),
      ),
      menuChildren: List.generate(widget.menuItems.length, (index) {
        final item = widget.menuItems.elementAt(index);

        return SizedBox(
          width: widthOfSizedBox,
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.zero,
                child: MenuItemButton(
                  leadingIcon: CustomIcon(item.icon),
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    alignment: Alignment.center,
                    backgroundColor: WidgetStateColor.resolveWith((states) {
                      return AppColors.floatingActionButton;
                    }),
                  ),
                  onPressed: item.onPressed,
                  child: CustomText(data: item.text, size: CustomTextSize.ms),
                ),
              ),
              if (index < widget.menuItems.length - 1) const Gap(AppSizes.xs),
            ],
          ),
        );
      }),
      builder: (context, controller, child) {
        return CustomFloatingActionButton(
          icon: Symbols.menu,
          tooltip: 'Opret ny turnering',
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
    );
  }
}
