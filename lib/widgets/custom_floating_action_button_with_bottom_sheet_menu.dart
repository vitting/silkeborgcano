import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_menu_model.dart';
import 'package:silkeborgcano/widgets/custom_menu_item_button.dart';
import 'package:silkeborgcano/widgets/list_view_separator.dart';

class CustomFloatingActionButtonWithBottomSheetMenu extends StatelessWidget {
  final Iterable<CustomFloatingActionButtonWithMenuModel> menuItems;
  final String? tooltip;
  const CustomFloatingActionButtonWithBottomSheetMenu({super.key, required this.menuItems, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      icon: Symbols.menu,
      tooltip: tooltip ?? 'Menu',
      onPressed: () {
        showModalBottomSheet(
          backgroundColor: AppColors.dialogBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.borderSize))),
          context: context,
          builder: (context) {
            return SafeArea(
              child: ListView.separated(
                padding: EdgeInsets.only(top: AppSizes.s, left: AppSizes.s, right: AppSizes.s, bottom: AppSizes.s),
                shrinkWrap: true,
                separatorBuilder: (context, index) => ListViewSeparator(),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems.elementAt(index);
                  return CustomMenuItemButton(icon: item.icon, text: item.text, onPressed: item.onPressed);
                },
              ),
            );
          },
        );
      },
    );
  }
}
