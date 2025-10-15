import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class YesNoDialog extends StatelessWidget {
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
      backgroundColor: AppColors.dialogBackgroundColor,
      title: CustomText(data: title, fontFamily: GoogleFonts.jersey25().fontFamily, letterSpacing: 0.5, size: CustomTextSize.xl),
      content: CustomText(data: body, size: CustomTextSize.ms),
      actionsAlignment: noButtonText != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
      actions: [
        if (noButtonText != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: CustomText(data: noButtonText!),
          ),
        TextButton(
          onPressed: () {
            // Delete action
            Navigator.of(context).pop(true);
          },
          child: CustomText(data: yesButtonText, color: AppColors.buttonBackgroundColor),
        ),
      ],
    );
  }
}
