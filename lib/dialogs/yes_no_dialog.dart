import 'package:flutter/material.dart';

class YesNoDialog extends StatelessWidget {
  final String title;
  final String? noButtonText;
  final String yesButtonText;
  const YesNoDialog({super.key, required this.title, required this.yesButtonText, this.noButtonText});

  static Future<bool?> show(BuildContext context, {required String title, String? noButtonText, required String yesButtonText}) {
    return showDialog<bool?>(
      context: context,
      builder: (context) => YesNoDialog(title: title, noButtonText: noButtonText, yesButtonText: yesButtonText),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(title),
      actions: [
        if (noButtonText != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(noButtonText!),
          ),
        TextButton(
          onPressed: () {
            // Delete action
            Navigator.of(context).pop(true);
          },
          child: Text(yesButtonText),
        ),
      ],
    );
  }
}
