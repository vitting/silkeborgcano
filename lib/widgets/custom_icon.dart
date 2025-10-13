import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';

enum CustomIconSize { l, m, s }

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final CustomIconSize size;
  final Color color;
  final double? fill;
  final FontWeight? fontWeight;

  const CustomIcon(
    this.icon, {
    super.key,
    this.size = CustomIconSize.m,
    this.color = AppColors.iconColor,
    this.fill = 1,
    this.fontWeight = FontWeight.w300,
  });

  double _getSize() {
    switch (size) {
      case CustomIconSize.l:
        return 32;
      case CustomIconSize.m:
        return 28;
      case CustomIconSize.s:
        return 24;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: _getSize(), color: color, fontWeight: fontWeight, fill: fill);
  }
}
