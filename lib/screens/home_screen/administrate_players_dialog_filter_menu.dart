import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_menu_anchor.dart';
import 'package:silkeborgcano/widgets/custom_menu_item_button.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

enum AdministratePlayersFilter {
  active('active'),
  deleted('deleted'),
  all('all');

  final String value;
  const AdministratePlayersFilter(this.value);

  factory AdministratePlayersFilter.fromString(String value) {
    return AdministratePlayersFilter.values.firstWhere((e) => e.value == value);
  }
}

class AdministratePlayersDialogFilterMenu extends StatelessWidget {
  final AdministratePlayersFilter selectedFilter;
  final void Function(AdministratePlayersFilter) onFilterSelected;
  const AdministratePlayersDialogFilterMenu({super.key, required this.selectedFilter, required this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    return CustomMenuAnchor(
      menuChildren: [
        CustomText('Filter:', size: CustomTextSize.ms),
        const Gap(AppSizes.xs),
        CustomMenuItemButton(
          text: 'Aktive',
          onPressed: () {
            onFilterSelected(AdministratePlayersFilter.active);
          },
          popMenuOnPressed: false,
          selectedByCheckmark: selectedFilter == AdministratePlayersFilter.active,
          showTrailingIcon: true,
        ),
        const Gap(AppSizes.xs),
        CustomMenuItemButton(
          text: 'Slettede',
          onPressed: () {
            onFilterSelected(AdministratePlayersFilter.deleted);
          },
          popMenuOnPressed: false,
          selectedByCheckmark: selectedFilter == AdministratePlayersFilter.deleted,
          showTrailingIcon: true,
        ),
        const Gap(AppSizes.xs),
        CustomMenuItemButton(
          text: 'Aktiv',
          onPressed: () {
            onFilterSelected(AdministratePlayersFilter.all);
          },
          popMenuOnPressed: false,
          selectedByCheckmark: selectedFilter == AdministratePlayersFilter.all,
          showTrailingIcon: true,
        ),
      ],
      icon: Symbols.filter_list,
    );
  }
}
