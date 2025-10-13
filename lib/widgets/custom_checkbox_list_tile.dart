import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';

class CustomCheckboxListTile extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final bool selected;
  final Widget? title;
  final bool dense;
  const CustomCheckboxListTile({
    super.key,
    required this.value,
    this.onChanged,
    this.selected = false,
    this.title,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      dense: dense,
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: AppColors.tileBackground,
      value: value,
      selected: selected,
      selectedTileColor: AppColors.tileSelectedBackground,
      title: title,
      onChanged: onChanged,
      side: const BorderSide(color: AppColors.borderColor, width: 2),
      activeColor: AppColors.checkboxSelectedBackground,
      checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.xxs)),
    );
  }
}
