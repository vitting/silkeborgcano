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
    return Card(
      margin: EdgeInsets.zero,
      elevation: AppSizes.elevation,
      child: CheckboxListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderSize),
          side: BorderSide(color: AppColors.tileBorderColor, width: AppSizes.borderWidth),
        ),
        dense: dense,
        visualDensity: VisualDensity.compact,
        tileColor: AppColors.tileBackground,
        value: value,
        selected: selected,
        selectedTileColor: AppColors.tileSelectedBackground,
        title: title,
        onChanged: onChanged,
        side: const BorderSide(color: AppColors.borderColor, width: 2),
        activeColor: AppColors.checkboxCheckActiveColor,
        checkColor: AppColors.checkboxCheckColor,
        checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.xxs)),
      ),
    );
  }
}
