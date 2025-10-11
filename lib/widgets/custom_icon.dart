import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final double? fill;
  final FontWeight? fontWeight;

  const CustomIcon(
    this.icon, {
    super.key,
    this.size = 32,
    this.color = AppColors.textAndIcon,
    this.fill = 1,
    this.fontWeight = FontWeight.w300,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: size, color: color, fontWeight: fontWeight, fill: fill);
  }
}
