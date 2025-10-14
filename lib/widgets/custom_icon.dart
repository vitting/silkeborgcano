import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';

enum CustomIconSize { l, m, s }

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final Widget? stackedIcon;
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
    this.stackedIcon,
  });

  double _getSize() {
    switch (size) {
      case CustomIconSize.l:
        return 30;
      case CustomIconSize.m:
        return 26;
      case CustomIconSize.s:
        return 22;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (stackedIcon != null) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, size: _getSize(), color: color, fill: fill),
          stackedIcon!,
        ],
      );
    } else {
      return Icon(icon, size: _getSize(), color: color, fontWeight: fontWeight, fill: fill);
    }
  }
}
