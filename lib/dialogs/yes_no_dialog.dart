import 'package:flutter/material.dart';
import 'package:silkeborgcano/mixins/vibrate_mixin.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_primary_button.dart';
import 'package:silkeborgcano/widgets/custom_secondary_button.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';
import 'package:silkeborgcano/widgets/custom_text_title.dart';

class YesNoDialog extends StatelessWidget with VibrateMixin {
  final String title;
  final String body;
  final String? noButtonText;
  final String yesButtonText;
  const YesNoDialog({super.key, required this.title, required this.yesButtonText, this.noButtonText, required this.body});

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? noButtonText,
    required String yesButtonText,
    required String body,
  }) {
    return showDialog<bool?>(
      context: context,
      builder: (context) => YesNoDialog(title: title, noButtonText: noButtonText, yesButtonText: yesButtonText, body: body),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: AppSizes.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderSize),
        side: BorderSide(color: AppColors.dialogBorderColor, width: AppSizes.borderWidth),
      ),
      insetPadding: EdgeInsets.all(AppSizes.s),
      backgroundColor: AppColors.dialogBackgroundColor,
      title: CustomTextTitle(title),
      content: CustomText(body, size: CustomTextSize.m),
      actionsAlignment: noButtonText != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
      actions: [
        if (noButtonText != null)
          CustomSecondaryButton(
            onPressed: () {
              vibrateShort();
              Navigator.of(context).pop();
            },
            text: noButtonText!,
          ),

        CustomPrimaryButton(
          onPressed: () {
            vibrateShort();
            // Delete action
            Navigator.of(context).pop(true);
          },
          text: yesButtonText,
        ),
      ],
    );
  }
}
