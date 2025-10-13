import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class MatchPointsSelector extends StatelessWidget {
  final int? initialPointPerMatch;
  final ValueChanged<int?> onChanged;
  const MatchPointsSelector({super.key, this.initialPointPerMatch, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return RadioGroup<int>(
      groupValue: initialPointPerMatch,
      onChanged: onChanged,
      child: Row(
        children: [
          Flexible(
            child: RadioListTile(
              value: 11,
              title: CustomText(data: '11', size: CustomTextSize.s),
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
              fillColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.iconColor;
                }
                return AppColors.iconDisabled;
              }),
            ),
          ),
          Flexible(
            child: RadioListTile(
              value: 15,
              title: CustomText(data: '15', size: CustomTextSize.s),
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
              fillColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.iconColor;
                }
                return AppColors.iconDisabled;
              }),
            ),
          ),
          Flexible(
            child: RadioListTile(
              value: 21,
              title: CustomText(data: '21', size: CustomTextSize.s),
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
              fillColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.iconColor;
                }
                return AppColors.iconDisabled;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
