import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? tooltip;
  final IconData icon;
  const CustomFloatingActionButton({super.key, this.onPressed, this.tooltip, required this.icon});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: tooltip,
      onPressed: onPressed,
      shape: CircleBorder(),
      elevation: 0,
      backgroundColor: AppColors.textAndIcon,
      child: CustomIcon(icon, size: AppSizes.l, color: AppColors.white),
    );
  }
}
