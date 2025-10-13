import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';

enum CustomTextSize { l, m, s }

class CustomText extends StatelessWidget {
  final String data;
  final CustomTextSize size;
  final Color color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;

  const CustomText({
    super.key,
    required this.data,
    this.size = CustomTextSize.m,
    this.color = AppColors.textColor,
    this.textAlign,
    this.fontWeight = FontWeight.bold,
  });

  double _getFontSize() {
    switch (size) {
      case CustomTextSize.l:
        return 24;
      case CustomTextSize.m:
        return 20;
      case CustomTextSize.s:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(color: color, fontSize: _getFontSize(), fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }
}
