import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_menu_anchor.dart';
import 'package:silkeborgcano/widgets/custom_menu_item_button.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

enum TournamentFilter {
  all('all'),
  notStarted('notStarted'),
  active('active'),
  ended('ended');

  final String value;
  const TournamentFilter(this.value);

  factory TournamentFilter.fromString(String value) {
    return TournamentFilter.values.firstWhere((e) => e.value == value);
  }
}

class HomeScreenFilterMenu extends StatelessWidget {
  final TournamentFilter selectedFilter;
  final void Function(TournamentFilter) onFilterSelected;
  const HomeScreenFilterMenu({super.key, required this.selectedFilter, required this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    return CustomMenuAnchor(
      menuChildren: [
        CustomText('Filter:', size: CustomTextSize.ms),
        const Gap(AppSizes.xs),
        CustomMenuItemButton(
          text: 'Alle',
          onPressed: () {
            onFilterSelected(TournamentFilter.all);
          },
          popMenuOnPressed: false,
          selectedByCheckmark: selectedFilter == TournamentFilter.all,
          showTrailingIcon: true,
        ),
        const Gap(AppSizes.xs),
        CustomMenuItemButton(
          text: 'Ikke startet',
          onPressed: () {
            onFilterSelected(TournamentFilter.notStarted);
          },
          popMenuOnPressed: false,
          selectedByCheckmark: selectedFilter == TournamentFilter.notStarted,
          showTrailingIcon: true,
        ),
        const Gap(AppSizes.xs),
        CustomMenuItemButton(
          text: 'Aktiv',
          onPressed: () {
            onFilterSelected(TournamentFilter.active);
          },
          popMenuOnPressed: false,
          selectedByCheckmark: selectedFilter == TournamentFilter.active,
          showTrailingIcon: true,
        ),
        const Gap(AppSizes.xs),
        CustomMenuItemButton(
          text: 'Afsluttet',
          onPressed: () {
            onFilterSelected(TournamentFilter.ended);
          },
          popMenuOnPressed: false,
          selectedByCheckmark: selectedFilter == TournamentFilter.ended,
          showTrailingIcon: true,
        ),
      ],
      icon: Symbols.filter_list,
    );
  }
}
