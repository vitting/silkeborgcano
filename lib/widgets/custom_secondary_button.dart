import 'package:flutter/material.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class CustomSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const CustomSecondaryButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: CustomText(text, letterSpacing: 1));
  }
}
