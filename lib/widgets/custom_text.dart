import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';

enum CustomTextSize { xl, l, m, ms, s }

class CustomText extends StatelessWidget {
  final String data;
  final CustomTextSize size;
  final Color color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final double? letterSpacing;
  final double? height;

  const CustomText({
    super.key,
    required this.data,
    this.size = CustomTextSize.m,
    this.color = AppColors.textColor,
    this.textAlign,
    this.letterSpacing,
    this.fontFamily,
    this.fontWeight = FontWeight.bold,
    this.height,
  });

  double _getFontSize() {
    switch (size) {
      case CustomTextSize.xl:
        return 24;
      case CustomTextSize.l:
        return 20;
      case CustomTextSize.m:
        return 16;
      case CustomTextSize.ms:
        return 14;
      case CustomTextSize.s:
        return 12;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        color: color,
        fontSize: _getFontSize(),
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
        height: height,
      ),
      textAlign: textAlign,
    );
  }
}
