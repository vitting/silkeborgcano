import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class CustomRadioListTile<T> extends StatelessWidget {
  final T value;
  final String title;
  const CustomRadioListTile({super.key, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: value,
      title: CustomText(data: title, size: CustomTextSize.s),
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.radioSelectedBackground;
        }
        return AppColors.iconDisabled;
      }),
    );
  }
}
